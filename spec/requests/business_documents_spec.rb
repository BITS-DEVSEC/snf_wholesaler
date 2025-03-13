require 'rails_helper'

RSpec.describe "BusinessDocuments", type: :request do
  include ActionDispatch::TestProcess

  let(:valid_attributes) do
    {
      business_id: create(:business).id,
      document_type: :business_license_doc,
      uploaded_at: Time.current,
      document: fixture_file_upload('spec/fixtures/files/sample.pdf', 'application/pdf')
    }
  end

  let(:invalid_attributes) do
    {
      business_id: nil,
      document_type: nil,
      uploaded_at: nil
    }
  end

  it_behaves_like "request_shared_spec", "business_documents", 6, [ :update, :create ]

  describe "POST /create" do
    context "with valid params" do
      it "creates a new business document" do
        expect {
          post business_documents_url,
               params: {
                 payload: valid_attributes
               }
        }.to change(SnfCore::BusinessDocument, :count).by(1)
      end
    end
  end

  describe "PUT /update" do
    context "with valid params" do
      it "updates the requested business_document" do
        business_document = SnfCore::BusinessDocument.create! valid_attributes
        put business_document_url(business_document),
            params: { payload: { document_type: :representative_id_doc } }
        business_document.reload
        expect(business_document.document_type).to eq("representative_id_doc")
      end
    end
  end
end
