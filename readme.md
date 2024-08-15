## Description

In this project, I am learning step-by-step how to design, develop and deploy a backend web service from scratch. The service that I am building is a simple transaction. It will provide APIs for the frontend to do the following things:

- Create and manage accounts, which are composed of owner’s name, balance, and currency.
- Perform a money transfer between 2 accounts. This should happen within a transaction, so that either both accounts’ balance are updated successfully or none of them are.
- Record all balance changes to each of the accounts. So every time some money is added to or subtracted from the account, an account entry record will be created.

## Getting Started

### Environment Parameter
1. Create a Configuration File:
Create a file named `local.env` in the root directory of your project. This file will be used to define environment variables necessary for the application.
2. Define Environment Variables:
In the `local.env` file, define the following environment variables:

| Key                   | Description                          | Example Value |
| --------------------- | ----------------------------- | -------------------- |
| `HTTP_SERVER_ADDRESS`        | The address and port for the HTTP server               | `0.0.0.0:8080` |
| `GRPC_SERVER_ADDRESS `       | The address and port for the gRPC server               | `0.0.0.0:50051` |
| `DB_CONNECTION`         | Type of database connection    | `postgres` |
| `DB_USERNAME`           | Username for accessing the Postgres database        | `your_username`|
| `DB_PASSWORD  `         | Password for the Postgres database user       | `your_password` |
| `DB_DATABASE`           | Name of the Postgres database to connect to     | `your_database`|
| `DB_PORT`               | Port number for the Postgres database                | `5432` |
| `DB_SOURCE  `           | Database connection URL or DSN (Data Source Name)     | `postgresql://your_username:your_password@localhost:5432/your_database?sslmode=disable` |
| `ACCESS_TOKEN_DURATION` | Duration for which the access token remains valid     | `15m` |
| `REFRESH_TOKEN_DURATION` | Duration for which the refresh token remains valid       | `1h` |
| `TOKEN_SYMMETRIC_KEY`   | Secret key used for generating and verifying access tokens | `your_secret_key` |
| `MIGRATION_SOURCE_URL`   | Source URL for Golang Migrate migrations| `file://db/migration` |

### Setup infrastructure

- Install all dependencies

  ```bash
  go get .
  ```

- Start postgres container:

  ```bash
  make postgres
  ```

- Create database:

  ```bash
  make createdb
  ```

- Drop database:

  ```bash
  make dropdb
  ```

- Run db migration up all versions:

  ```bash
  make migrateup
  ```

- Run db migration down all versions:

  ```bash
  make migratedown
  ```

### Documentation

- Generate DB documentation:

  ```bash
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

  ```bash
  make server
  ```

- Run test:

  ```bash
  make test
  ```
