SET SERVEROUTPUT ON;

-- Create User Manager
DECLARE
    V_USER VARCHAR(100);
BEGIN
    SELECT USERNAME INTO V_USER FROM ALL_USERS WHERE USERNAME='USER_MANAGER';
    DBMS_OUTPUT.PUT_LINE('USER: USER_MANAGER already exists');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    EXECUTE IMMEDIATE 'CREATE USER USER_MANAGER IDENTIFIED BY UserManager2024#';
    EXECUTE IMMEDIATE 'GRANT CONNECT TO USER_MANAGER';
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON ss_admin.users TO USER_MANAGER';
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON ss_admin.posts TO USER_MANAGER';
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON ss_admin.comments TO USER_MANAGER';
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON ss_admin.likes TO USER_MANAGER';
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON ss_admin.user_followers TO USER_MANAGER';
    EXECUTE IMMEDIATE 'GRANT SELECT ON sponsorship TO USER_MANAGER';
    DBMS_OUTPUT.PUT_LINE('USER_MANAGER created successfully');
END;
/


-- Create Sponsorship Manager
DECLARE
    V_USER VARCHAR(100);
BEGIN
    SELECT USERNAME INTO V_USER FROM ALL_USERS WHERE USERNAME='SPONSORSHIP_MANAGER';
    DBMS_OUTPUT.PUT_LINE('USER: SPONSORSHIP_MANAGER already exists');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    EXECUTE IMMEDIATE 'CREATE USER SPONSORSHIP_MANAGER IDENTIFIED BY SponsorshipManager2024#';
    EXECUTE IMMEDIATE 'GRANT CONNECT TO SPONSORSHIP_MANAGER';
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON ss_admin.sponsorship TO SPONSORSHIP_MANAGER';
    EXECUTE IMMEDIATE 'GRANT SELECT ON users TO SPONSORSHIP_MANAGER';
    EXECUTE IMMEDIATE 'GRANT SELECT ON posts TO SPONSORSHIP_MANAGER';
    DBMS_OUTPUT.PUT_LINE('SPONSORSHIP_MANAGER created successfully');
END;
/

-- Create Tags Manager
DECLARE
    V_USER VARCHAR(100);
BEGIN
    SELECT USERNAME INTO V_USER FROM ALL_USERS WHERE USERNAME='TAGS_MANAGER';
    DBMS_OUTPUT.PUT_LINE('USER: TAGS_MANAGER already exists');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    EXECUTE IMMEDIATE 'CREATE USER TAGS_MANAGER IDENTIFIED BY TagsManager2024#';
    EXECUTE IMMEDIATE 'GRANT CONNECT TO TAGS_MANAGER';
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON ss_admin.tags TO TAGS_MANAGER';
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON ss_admin.posts_hashtags TO TAGS_MANAGER';
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON ss_admin.user_hashtags TO TAGS_MANAGER';
    EXECUTE IMMEDIATE 'GRANT SELECT ON users TO TAGS_MANAGER';
    EXECUTE IMMEDIATE 'GRANT SELECT ON posts TO TAGS_MANAGER';
    DBMS_OUTPUT.PUT_LINE('TAGS_MANAGER created successfully');
END;
/


-- Create Business Analyst
DECLARE
    V_USER VARCHAR(100);
BEGIN
    SELECT USERNAME INTO V_USER FROM ALL_USERS WHERE USERNAME='BUSINESS_ANALYST';
    
    DBMS_OUTPUT.PUT_LINE('USER: BUSINESS_ANALYST already exists');
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    EXECUTE IMMEDIATE 'CREATE USER BUSINESS_ANALYST IDENTIFIED BY BusinessAnalyst2024#';
    EXECUTE IMMEDIATE 'GRANT CONNECT TO BUSINESS_ANALYST';
    EXECUTE IMMEDIATE 'GRANT SELECT ON users TO BUSINESS_ANALYST';
    EXECUTE IMMEDIATE 'GRANT SELECT ON posts TO BUSINESS_ANALYST';
    EXECUTE IMMEDIATE 'GRANT SELECT ON sponsorship TO BUSINESS_ANALYST';
    EXECUTE IMMEDIATE 'GRANT SELECT ON likes TO BUSINESS_ANALYST';
    EXECUTE IMMEDIATE 'GRANT SELECT ON comments TO BUSINESS_ANALYST';
    EXECUTE IMMEDIATE 'GRANT SELECT ON posts_hashtags TO BUSINESS_ANALYST';
    EXECUTE IMMEDIATE 'GRANT SELECT ON user_followers TO BUSINESS_ANALYST';
    EXECUTE IMMEDIATE 'GRANT SELECT ON user_hashtags TO BUSINESS_ANALYST';
    EXECUTE IMMEDIATE 'GRANT SELECT ON tags TO BUSINESS_ANALYST';
    DBMS_OUTPUT.PUT_LINE('BUSINESS_ANALYST created successfully');
END;
/
