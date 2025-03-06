class WholesalerFinderService
  def initialize(product_ids)
    @product_ids = Array(product_ids)
  end

  def find_best_wholesalers
    return [] if @product_ids.empty?

    store_inventories = SnfCore::StoreInventory.includes(:store)
      .where(product_id: @product_ids, status: 0) # Using 0 for active status
      .group_by(&:store_id)

    # Filter stores that have all products
    complete_stores = store_inventories.select { |_, inventories| inventories.map(&:product_id).uniq.size == @product_ids.size }
    partial_stores = store_inventories.reject { |store_id, _| complete_stores.key?(store_id) }

    if complete_stores.empty? && !partial_stores.empty?
      # Sort partial stores by coverage and then price
      sorted_partial_stores = partial_stores.values
        .sort_by do |inventories|
          coverage = inventories.map(&:product_id).uniq.size
          total_price = inventories.sum(&:base_price)
          [-coverage, total_price]
        end

      sorted_stores = sorted_partial_stores.first(3)
    else
      # Prioritize complete stores first, then sort by price
      complete_store_values = complete_stores.values.sort_by { |inventories| inventories.sum(&:base_price) }
      partial_store_values = partial_stores.values
        .sort_by do |inventories|
          coverage = inventories.map(&:product_id).uniq.size
          total_price = inventories.sum(&:base_price)
          [-coverage, total_price]
        end

      sorted_stores = (complete_store_values + partial_store_values).first(3)
    end

    format_response(sorted_stores)
  end

  private

  def format_response(sorted_stores)
    sorted_stores.map do |inventories|
      store = inventories.first.store
      {
        id: store.id,
        name: store.name,
        products: inventories.map { |inv|
          {
            product_id: inv.product_id,
            price: inv.base_price
          }
        },
        total_price: inventories.sum(&:base_price),
        available_products: inventories.map(&:product_id).uniq.size,
        total_products: @product_ids.size,
        coverage_percentage: ((inventories.map(&:product_id).uniq.size.to_f / @product_ids.size) * 100).round(2)
      }
    end
  end
end
