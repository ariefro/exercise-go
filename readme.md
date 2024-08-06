## Description

In this project, I am learning step-by-step how to design, develop and deploy a backend web service from scratch. The service that I am building is a simple transaction. It will provide APIs for the frontend to do the following things:

- Create and manage accounts, which are composed of owner’s name, balance, and currency.
- Perform a money transfer between 2 accounts. This should happen within a transaction, so that either both accounts’ balance are updated successfully or none of them are.
- Record all balance changes to each of the accounts. So every time some money is added to or subtracted from the account, an account entry record will be created.

## Getting Started

### Environment Parameter

| Key                   | Desc                          |
| --------------------- | ----------------------------- |
| HTTP_SERVER_ADDRESS        | Http Application Port              |
| GRPC_SERVER_ADDRESS        | gRPC Application Port              |
| DB_CONNECTION         | Type of Database Connection   |
| DB_USERNAME           | Postgres Username             |
| DB_PASSWORD           | Postgres Password             |
| DB_DATABASE           | Postgres Database Name        |
| DB_PORT               | Postgres Port                 |
| DB_SOURCE             | Connection url to Supabase      |
| ACCESS_TOKEN_DURATION | Duration of access token      |
| TOKEN_SYMMETRIC_KEY   | Secret key for generate token |

### Setup infrastructure

- Install all dependencies

  ```
  go get .
  ```

- Start postgres container:

  ```
  make postgres
  ```

- Create database:

  ```
  make createdb
  ```

- Drop database:

  ```
  make dropdb
  ```

- Run db migration up all versions:

  ```
  make migrateup
  ```

- Run db migration down all versions:

  ```
  make migratedown
  ```

### Documentation

- Generate DB documentation:

  ```
  make dbdocs
  ```

- Access the DB documentation at [this address](https://dbdocs.io/ariefromadhon/simple_transaction). Password: `secret`

### How to generate code

- Generate schema SQL file with DBML:

  ```bash
  make dbschema
  ```

- Generate SQL CRUD with sqlc:

  ```bash
  make sqlc
  ```

- Generate DB mock with gomock:

  ```bash
  make mock
  ```

- Create a new db migration:

  ```bash
  migrate create -ext sql -dir db/migration -seq <migration_name>
  ```

### Run the development server:

- Run server:

  ```
  make server
  ```

- Run test:

  ```
  make test
  ```
