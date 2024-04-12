# SnapSponsor Database Setup Guide

## Overview
This guide outlines the steps to set up the Snap Sponsor database using a series of SQL scripts. The setup process includes user creation, schema object creation (tables, sequences), data insertion, functions, stored procedures, triggers, views creation, and reports.

## Prerequisites
- Oracle SQL Developer or a compatible SQL execution environment.
- Git for version control.
- Access permissions to the project's Git repository.

## Repository Setup
1. Clone the project repository from the main branch:

```bash
    git clone git@github.com:DMDD-Kloud-12/SnapSponsor.git
```

2. Change into the project directory:

```bash
    cd SnapSponsor
```

## Execution Sequence
Scripts should be executed in the following order to ensure the database schema and data are set up correctly without errors.

1. **Admin Script** (`admin_script.sql`): Prepares the database by checking for existing users and dropping them if necessary before re-creation.
2. Connect with the user `ss_admin` created in above script.
3. **DDL Script** (`ddl_script.sql`): Creates all the required database objects such as tables and sequences.
4. **Create User Script** (`create_user_script.sql`): Prepares the database by checking for existing users and dropping them if necessary before re-creation.
5. **Create Stored Procedure** (`stored procedures/stored_procedure.sql`): Sets up all required stored procedures for database operations.
6. **Create Functions Script** (`functions/functions.sql`): Defines and deploys all necessary functions to support application logic.
7. **Create Trigger Script** (`triggers/triggers.sql`): Implements triggers to automate database operations and enforce business rules.
8. **Create Views Script** (`create_views_script.sql`): Creates views for data presentation, supporting user interface components.
9. **DML Script** (`dml_script.sql`): Inserts sample data into tables to facilitate testing of views and queries.
10. **Reports** (`reports/all_reports.xml`): Provides XML file for importing custom user-defined reports into the system. Import the file in reports -> User Defines Reports



## Running the Scripts
To execute these scripts, follow these steps:

1. Open Oracle SQL Developer.
2. Connect to the database using the admin user credentials.
3. Open each script file in the sequence mentioned above.
4. Execute each script.

## Error Handling
Each script includes error handling to ensure idempotency. This means you can safely run the scripts multiple times without causing failures or inconsistencies.