--Login as Admin user from SQL Developer and run below commands


-- 1. Check if the user exists before dropping it

SET SERVEROUTPUT ON;

DECLARE
    user_exists NUMBER;
BEGIN
    SELECT COUNT(*) INTO user_exists FROM dba_users WHERE username = 'SS_ADMIN';
    
    IF user_exists > 0 THEN
        DBMS_OUTPUT.PUT_LINE('User SS_ADMIN exists. Dropping user...');
        EXECUTE IMMEDIATE 'DROP USER SS_ADMIN CASCADE';
        DBMS_OUTPUT.PUT_LINE('User SS_ADMIN dropped successfully.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('User SS_ADMIN does not exist. Nothing to drop.');
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

-- 2. Once we ensure that SS_Admin does not exist, create the user and give grants

CREATE USER SS_ADMIN IDENTIFIED BY SnapSponsor2024#;
ALTER USER SS_ADMIN DEFAULT TABLESPACE users QUOTA UNLIMITED ON users;
ALTER USER SS_ADMIN TEMPORARY TABLESPACE TEMP;

-- The SELECT_CATALOG_ROLE provides read access to DBA tables

GRANT CREATE USER, DROP USER, RESOURCE, UNLIMITED TABLESPACE, CONNECT,
      CREATE ANY VIEW, CREATE TABLE, CREATE SEQUENCE, SELECT_CATALOG_ROLE 
TO SS_ADMIN WITH ADMIN OPTION;

