SET SERVEROUTPUT ON;

-- Drop tables and sequence

DECLARE
    l_constraint_name USER_CONSTRAINTS.CONSTRAINT_NAME%TYPE;
    l_count NUMBER;
BEGIN
    FOR c IN (SELECT CONSTRAINT_NAME, TABLE_NAME FROM USER_CONSTRAINTS WHERE CONSTRAINT_TYPE = 'R')
    LOOP
        BEGIN
            EXECUTE IMMEDIATE 'ALTER TABLE ' || c.TABLE_NAME || ' DROP CONSTRAINT ' || c.CONSTRAINT_NAME;
            DBMS_OUTPUT.PUT_LINE('Dropped foreign key constraint: ' || c.CONSTRAINT_NAME);
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Failed to drop constraint ' || c.CONSTRAINT_NAME || ' with error: ' || SQLERRM);
        END;
    END LOOP;

    FOR i IN (SELECT OBJECT_NAME, OBJECT_TYPE FROM USER_OBJECTS WHERE OBJECT_TYPE IN ('SEQUENCE', 'TABLE'))
    LOOP
        BEGIN
            EXECUTE IMMEDIATE 'DROP ' || i.OBJECT_TYPE || ' ' || i.OBJECT_NAME;
            DBMS_OUTPUT.PUT_LINE(i.OBJECT_TYPE || ' DROPPED: ' || i.OBJECT_NAME);
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Failed to drop ' || i.OBJECT_TYPE || ': ' || i.OBJECT_NAME || ' with error: ' || SQLERRM);
        END;
    END LOOP;
END;
/


-- Drop Functions

DROP FUNCTION PROCESS_HASHTAGS;
DROP FUNCTION CALCULATE_POST_POPULARITY;

-- Drop triggers

DROP TRIGGER UPDATE_POST_STATUS;
DROP TRIGGER TRG_UPDATE_COMMENT_COUNT;
DROP TRIGGER TRG_UPDATE_LIKE_COUNT;
DROP TRIGGER trg_post_operations;

-- Drop procedures

DROP PROCEDURE ADD_USER;
DROP PROCEDURE UPDATE_USER_PROFILE;
DROP PROCEDURE ADD_POST;
DROP PROCEDURE ADD_COMMENT;
DROP PROCEDURE DELETE_COMMENT;
DROP PROCEDURE ADD_LIKE;
DROP PROCEDURE REMOVE_LIKE;
DROP PROCEDURE ADD_TAG;
DROP PROCEDURE ADD_POST_HASHTAG;
DROP PROCEDURE ADD_USER_HASHTAG;
DROP PROCEDURE ADD_SPONSORSHIP;
DROP PROCEDURE ADD_FOLLOWER;
DROP PROCEDURE INCREMENT_TAG_POINTS;

-- Drop Views

DROP VIEW sponsorship_opportunities_view;
DROP VIEW sponsorship_request_status_view;
DROP VIEW user_profile_management_view;
DROP VIEW user_tag_management_view;
DROP VIEW POST_POPULARITY_REPORT;

-- Drop Users

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
    
    SELECT COUNT(*) INTO user_exists FROM dba_users WHERE username = 'USER_MANAGER';
    
    IF user_exists > 0 THEN
        DBMS_OUTPUT.PUT_LINE('User USER_MANAGER exists. Dropping user...');
        EXECUTE IMMEDIATE 'DROP USER USER_MANAGER CASCADE';
        DBMS_OUTPUT.PUT_LINE('User USER_MANAGER dropped successfully.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('User USER_MANAGER does not exist. Nothing to drop.');
    END IF;
    
    SELECT COUNT(*) INTO user_exists FROM dba_users WHERE username = 'SPONSORSHIP_MANAGER';
    
    IF user_exists > 0 THEN
        DBMS_OUTPUT.PUT_LINE('User SPONSORSHIP_MANAGER exists. Dropping user...');
        EXECUTE IMMEDIATE 'DROP USER SPONSORSHIP_MANAGER CASCADE';
        DBMS_OUTPUT.PUT_LINE('User SPONSORSHIP_MANAGER dropped successfully.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('User SPONSORSHIP_MANAGER does not exist. Nothing to drop.');
    END IF;
    
    SELECT COUNT(*) INTO user_exists FROM dba_users WHERE username = 'TAGS_MANAGER';
    
    IF user_exists > 0 THEN
        DBMS_OUTPUT.PUT_LINE('User TAGS_MANAGER exists. Dropping user...');
        EXECUTE IMMEDIATE 'DROP USER TAGS_MANAGER CASCADE';
        DBMS_OUTPUT.PUT_LINE('User TAGS_MANAGER dropped successfully.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('User TAGS_MANAGER does not exist. Nothing to drop.');
    END IF;
    
    SELECT COUNT(*) INTO user_exists FROM dba_users WHERE username = 'BUSINESS_ANALYST';
    
    IF user_exists > 0 THEN
        DBMS_OUTPUT.PUT_LINE('User BUSINESS_ANALYST exists. Dropping user...');
        EXECUTE IMMEDIATE 'DROP USER BUSINESS_ANALYST CASCADE';
        DBMS_OUTPUT.PUT_LINE('User BUSINESS_ANALYST dropped successfully.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('User BUSINESS_ANALYST does not exist. Nothing to drop.');
    END IF;
    
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/




