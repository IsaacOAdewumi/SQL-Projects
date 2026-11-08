# MME PostgreSQL Database Prototype

**Author:** Isaac Olufemi Adewumi  
**Project:** Millie's Musical Emporium customer, stock and purchase database  
**Tools:** PostgreSQL, SQL, PL/pgSQL, pgAdmin

## Overview

This educational prototype replaces a paper-based customer, sales and stock-recording process with a relational database. It implements five related tables, sample records, customer registration and purchase procedures, and a separate table-privilege demonstration.

## Files

| File | Purpose |
| --- | --- |
| [01_schema_and_procedures.sql](sql/01_schema_and_procedures.sql) | Main schema, sample data, procedures, example calls and inspection queries |
| [02_roles_and_privileges.sql](sql/02_roles_and_privileges.sql) | Admin/customer role creation and table GRANT statements |
| [Project brief](docs/project-brief.docx) | Original requirements |
| [Earlier schema draft](docs/task-1-earlier-schema-draft.docx) | Original Word implementation draft; differs from the main SQL script |
| [Privilege notes](docs/task-2-privileges-notes.docx) | Original Word explanation of privileges |

The two extensionless attachments were byte-for-byte duplicates of the SQL files and are not duplicated here. The three Word documents are preserved unchanged. The main SQL script is preserved unchanged under a shorter filename. In the privilege script, the two hard-coded password/login clauses have been replaced with `NOLOGIN`; these are demonstration group roles, not usable login accounts.

## Database design

| Table | Purpose and relationships |
| --- | --- |
| `customer` | Customer contact, date-of-birth and banking fields |
| `store` | Store branches |
| `product` | Product catalogue and cost |
| `warehouse_item` | Product quantities by store; references product and store |
| `transaction_tbl` | Purchases and delivery timestamps; references customer, product and store |

`register_new_customer` checks mandatory inputs, a past birth date and an existing matching name/telephone/birth-date combination before insertion.

`purchase_product` checks IDs, a future delivery timestamp, available stock and an unused delivery timestamp at the selected store. It records one product purchase and reduces stock by one.

## Run in an isolated demonstration environment

**The main script starts with DROP TABLE ... CASCADE. It removes existing tables with the same names and dependent objects. Use a new disposable database, never an existing business database.**

Create a dedicated database using an appropriately authorised local PostgreSQL account:

```sh
createdb mme_demo
psql -v ON_ERROR_STOP=1 -d mme_demo -f mme-postgresql/sql/01_schema_and_procedures.sql
```

Alternatively, open the main script in pgAdmin's Query Tool while connected to the new database and run it as the database owner.

The script includes a registration example and a purchase scheduled for 20 June 2030. After that date, change the example to a future timestamp. Re-running the script resets its tables and sample data. Invalid example calls are commented out.

Task 2 is a privilege-design demonstration. In a disposable PostgreSQL instance with no existing `admin` or `customer` roles, a role-creating administrator can run:

```sh
psql -v ON_ERROR_STOP=1 -d mme_demo -f mme-postgresql/sql/02_roles_and_privileges.sql
```

Roles are instance-wide, not database-local. The role-creation script is not idempotent and will fail if those names already exist. It creates no login credentials.

## Expected demonstration checks

These are expectations inferred from the code, not observed test results:

- The initial registration example adds a third customer.
- The purchase example inserts one transaction for customer 1, product 1, store 1.
- Product 1 stock at store 1 decreases from 10 to 9.
- Missing inputs, unknown IDs, unavailable stock, past delivery dates and an already-booked delivery timestamp should trigger the corresponding procedure exceptions.

## Scope and limitations

The scripts were reviewed as text during repository preparation. PostgreSQL was not available in that environment, so successful execution and role behaviour have **not** been verified.

- The Word schema draft uses different column names and a different transaction-table design. Run the SQL implementation as the primary version; do not combine both schemas.
- The commented duplicate-customer test contains malformed quoting and a leading space in the name; correct it before using that test.
- Duplicate-customer and delivery-slot checks are procedural; there are no corresponding unique constraints. Stock reads are not locked. Concurrent purchases need additional safeguards.
- Stock and price fields lack non-negative CHECK constraints; warehouse product/store pairs lack a unique constraint.
- Table-level SELECT grants do not restrict customers to their own records. The customer table includes banking fields, so this is not a production access-control model.
- SERIAL sequence grants are not included. The default invoker procedure execution and stock UPDATE also require privilege review before running purchases as the customer role.
- Direct INSERT privileges can bypass the purchase procedure's business checks.
- Stock transfers and management sales reports requested in the broader scenario are not implemented as dedicated features in these scripts.

Use synthetic demonstration records only. The source labels its inserted records as sample data. This repository presents a learning prototype, not a production-ready banking-data or customer-access system.

[Back to SQL projects](../README.md)
