# SNF Wholesaler Platform 🏪

[![Ruby](https://img.shields.io/badge/Ruby-3.x-red)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/Rails-7.x-red)](https://rubyonrails.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A robust wholesaler management system built with Ruby on Rails, designed to streamline wholesale operations and inventory management.

## 🚀 Features

- User Authentication & Authorization
- Inventory Management
- Order Processing
- Quotation System
- Reporting & Analytics
- RESTful API

## 📋 Prerequisites

- Ruby 3.x
- Rails 8.x
- PostgreSQL

## 🛠 Get Started


1. Clone the repository
```bash
git clone git@github.com:your-username/snf_wholesaler.git

cd snf_wholesaler

````

2. Install dependencies and set up the database
```bash
bundle install
````

3. Run DB commands
```bash
rails db:create
rails db:migrate
rails db:seed
````

4. Start the server
```bash
rails server
````


5. Running Tests

```bash

bundle exec rspec
````

## 🛣️ API Routes Documentation

Our API routes are fully documented and can be accessed at:

- **Development**: `http://localhost:3000/rails/info/routes`
- **Production**: `https://snf.bitscollege.edu.et/snf_wholesaler/rails/info/routes`

### 🔐 Authentication

All API endpoints require authentication using JWT tokens. Include the token in the Authorization header:

```http
Authorization: Bearer your-jwt-token
```