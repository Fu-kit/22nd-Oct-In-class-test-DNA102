This is explanation for InvoiceDB_Week10.sql

If your SQL statement is successful, you may see something like that;
(The following picture is a table of Customers, which is one of InvoiceDB tables).
<img width="758" height="451" alt="image" src="https://github.com/user-attachments/assets/7d86606c-2d92-467b-874f-5a2cae56306b" />

## 🧩 Step 1: Create the database
-------------------------------------------------------------------------

**Script chunk**
```sql
-- 1) If 'InvoiceDB' does not exist, please create it
IF DB_ID('InvoiceDB') IS NULL
    CREATE DATABASE InvoiceDB;
GO

USE InvoiceDB;
GO
English explanation

"GO" is needed to run each function (CREATE and USE).
```

"IF ... IS NULL" and "CREATE..." are used to avoid creating a duplicate database.
Without this condition, the same database could be created twice or more.
