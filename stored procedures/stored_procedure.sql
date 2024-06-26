SET SERVEROUTPUT ON;


-- Add user
CREATE OR REPLACE PROCEDURE ADD_USER (
    PI_IS_SUPERUSER NUMBER,
    PI_NAME NVARCHAR2,
    PI_PROFILEIMAGE NVARCHAR2,
    PI_PHONENUMBER NVARCHAR2,
    PI_ABOUTME NCLOB,
    PI_ABOUTORGANISATION NCLOB,
    PI_EMAIL NVARCHAR2,
    PI_PASSWORD NVARCHAR2
    
) AS
    E_EMAIL_EXISTS EXCEPTION;
    E_PHONE_FORMAT EXCEPTION;
    E_SUPERUSER_INVALID EXCEPTION;
    
    V_EMAIL_COUNT NUMBER;
    V_PHONE_LENGTH NUMBER;
    V_PATTERN VARCHAR2(20) := '^[0-9]{10}$';
BEGIN
    -- Check for unique email
    SELECT COUNT(USER_ID) INTO V_EMAIL_COUNT FROM USERS WHERE EMAIL = LOWER(PI_EMAIL);
    IF V_EMAIL_COUNT > 0 THEN
        RAISE E_EMAIL_EXISTS;
    END IF;
    
    -- Validate phone number format (basic check for length only as an example)
    IF NOT REGEXP_LIKE(PI_PHONENUMBER, V_PATTERN) THEN
        RAISE E_PHONE_FORMAT;
    END IF;
    
    -- Check for valid superuser flag
    IF PI_IS_SUPERUSER NOT IN (0, 1) THEN
        RAISE E_SUPERUSER_INVALID;
    END IF;
    
    -- Insert user
    INSERT INTO USERS (
        USER_ID, 
        LAST_LOGIN, 
        IS_SUPERUSER, 
        CREATED_AT, 
        NAME, 
        PROFILEIMAGE, 
        PHONENUMBER, 
        ABOUTME, 
        ABOUTORGANISATION, 
        EMAIL, 
        PASSWORD
    ) VALUES (
        SEQ_USER.NEXTVAL, 
        SYSTIMESTAMP, 
        PI_IS_SUPERUSER, 
        SYSTIMESTAMP, 
        PI_NAME,
        PI_PROFILEIMAGE,
        PI_PHONENUMBER,
        PI_ABOUTME,
        PI_ABOUTORGANISATION,
        LOWER(PI_EMAIL),
        PI_PASSWORD
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('USER ADDED SUCCESSFULLY');
EXCEPTION
    WHEN E_EMAIL_EXISTS THEN
        DBMS_OUTPUT.PUT_LINE('EMAIL ALREADY EXISTS');
    WHEN E_PHONE_FORMAT THEN
        DBMS_OUTPUT.PUT_LINE('PHONE NUMBER SHOULD BE 10 DIGITS');
    WHEN E_SUPERUSER_INVALID THEN
        DBMS_OUTPUT.PUT_LINE('SUPERUSER FLAG INVALID');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 2));
END ADD_USER;
/

-- Update User
CREATE OR REPLACE PROCEDURE UPDATE_USER_PROFILE (
    PI_USER_ID NUMBER,
    PI_NAME NVARCHAR2,
    PI_PROFILEIMAGE NVARCHAR2,
    PI_PHONENUMBER NVARCHAR2,
    PI_ABOUTME NCLOB,
    PI_ABOUTORGANISATION NCLOB
) AS
    E_USER_NOT_FOUND EXCEPTION;
    V_USER_COUNT NUMBER;
BEGIN
    SELECT COUNT(*) INTO V_USER_COUNT FROM USERS WHERE USER_ID = PI_USER_ID;
    IF V_USER_COUNT = 0 THEN
        RAISE E_USER_NOT_FOUND;
    END IF;

    UPDATE USERS SET
        NAME = PI_NAME,
        PROFILEIMAGE = PI_PROFILEIMAGE,
        PHONENUMBER = PI_PHONENUMBER,
        ABOUTME = PI_ABOUTME,
        ABOUTORGANISATION = PI_ABOUTORGANISATION
    WHERE USER_ID = PI_USER_ID;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('USER PROFILE UPDATED SUCCESSFULLY');
EXCEPTION
    WHEN E_USER_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('USER NOT FOUND');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 2));
END UPDATE_USER_PROFILE;
/


-- Add post
CREATE OR REPLACE PROCEDURE ADD_POST (
    PI_TEXT NCLOB,
    PI_IMAGE NVARCHAR2,
    PI_VENUE NCLOB,
    PI_FOOD NCLOB,
    PI_MONETARY NCLOB,
    PI_OTHER NCLOB,
    PI_USER_ID NUMBER,
    PI_ACTIVESTATUS NUMBER
) AS
    E_USER_NOT_FOUND EXCEPTION;
    E_ACTIVESTATUS_INVALID EXCEPTION;
    V_USER_COUNT NUMBER;
    V_POST_ID NUMBER;
BEGIN
    SELECT COUNT(*) INTO V_USER_COUNT FROM USERS WHERE USER_ID = PI_USER_ID;
    IF V_USER_COUNT = 0 THEN
        RAISE E_USER_NOT_FOUND;
    END IF;

    IF PI_ACTIVESTATUS NOT IN (0, 1) THEN
        RAISE E_ACTIVESTATUS_INVALID;
    END IF;

    INSERT INTO POSTS (
        POST_ID,
        CREATED_AT,
        TEXT,
        IMAGE,
        VENUE,
        FOOD,
        MONETARY,
        OTHER,
        LIKESCOUNT,
        COMMENTSCOUNT,
        USER_ID,
        ACTIVESTATUS
    ) VALUES (
        SEQ_POST.NEXTVAL,
        SYSTIMESTAMP,
        PI_TEXT,
        PI_IMAGE,
        PI_VENUE,
        PI_FOOD,
        PI_MONETARY,
        PI_OTHER,
        0,
        0,
        PI_USER_ID,
        PI_ACTIVESTATUS
    ) RETURNING POST_ID INTO V_POST_ID;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('POST ADDED SUCCESSFULLY. POST ID: ' || V_POST_ID);
EXCEPTION
    WHEN E_USER_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('USER NOT FOUND');
    WHEN E_ACTIVESTATUS_INVALID THEN
        DBMS_OUTPUT.PUT_LINE('INVALID ACTIVE STATUS');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 2));
END ADD_POST;
/


-- Add comment to post
CREATE OR REPLACE PROCEDURE ADD_COMMENT (
    PI_COMMENTS NCLOB,
    PI_USER_ID NUMBER,
    PI_POST_ID NUMBER
) AS
    E_USER_NOT_FOUND EXCEPTION;
    E_POST_NOT_FOUND EXCEPTION;
    V_USER_COUNT NUMBER;
    V_POST_COUNT NUMBER;
BEGIN
    SELECT COUNT(*) INTO V_USER_COUNT FROM USERS WHERE USER_ID = PI_USER_ID;
    IF V_USER_COUNT = 0 THEN
        RAISE E_USER_NOT_FOUND;
    END IF;

    SELECT COUNT(*) INTO V_POST_COUNT FROM POSTS WHERE POST_ID = PI_POST_ID;
    IF V_POST_COUNT = 0 THEN
        RAISE E_POST_NOT_FOUND;
    END IF;

    INSERT INTO COMMENTS (
        COMMENT_ID,
        CREATED_AT,
        COMMENTS,
        USER_ID,
        POST_ID
    ) VALUES (
        SEQ_COMMENTS.NEXTVAL,
        SYSTIMESTAMP,
        PI_COMMENTS,
        PI_USER_ID,
        PI_POST_ID
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('COMMENT ADDED SUCCESSFULLY');
EXCEPTION
    WHEN E_USER_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('USER NOT FOUND');
    WHEN E_POST_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('POST NOT FOUND');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 2));
END ADD_COMMENT;
/


-- Delete Comment from post
CREATE OR REPLACE PROCEDURE DELETE_COMMENT (
    PI_COMMENT_ID NUMBER
) AS
    E_COMMENT_NOT_FOUND EXCEPTION;
    V_COMMENT_COUNT NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO V_COMMENT_COUNT
    FROM COMMENTS
    WHERE COMMENT_ID = PI_COMMENT_ID;

    IF V_COMMENT_COUNT = 0 THEN
        RAISE E_COMMENT_NOT_FOUND;
    END IF;

    DELETE FROM COMMENTS
    WHERE COMMENT_ID = PI_COMMENT_ID;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('COMMENT DELETED SUCCESSFULLY');
EXCEPTION
    WHEN E_COMMENT_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('COMMENT NOT FOUND');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 2));
END DELETE_COMMENT;
/


-- Like post
CREATE OR REPLACE PROCEDURE ADD_LIKE (
    PI_USER_ID NUMBER,
    PI_POST_ID NUMBER
) AS
    E_ALREADY_LIKED EXCEPTION;
    E_USER_NOT_FOUND EXCEPTION;
    E_POST_NOT_FOUND EXCEPTION;
    V_LIKE_COUNT NUMBER;
    V_USER_COUNT NUMBER;
    V_POST_COUNT NUMBER;
BEGIN

    -- Check if the user exists
    SELECT COUNT(*) INTO V_USER_COUNT FROM USERS WHERE USER_ID = PI_USER_ID;
    IF V_USER_COUNT = 0 THEN
        RAISE E_USER_NOT_FOUND;
    END IF;
    
    -- Check if the post exists
    SELECT COUNT(*) INTO V_POST_COUNT FROM POSTS WHERE POST_ID = PI_POST_ID;
    IF V_POST_COUNT = 0 THEN
        RAISE E_POST_NOT_FOUND;
    END IF;
    
    -- Check if user already liked the post
    SELECT COUNT(*) INTO V_LIKE_COUNT FROM LIKES WHERE USER_ID = PI_USER_ID AND POST_ID = PI_POST_ID;
    IF V_LIKE_COUNT > 0 THEN
        RAISE E_ALREADY_LIKED;
    END IF;

    INSERT INTO LIKES (
        LIKE_ID,
        CREATED_AT,
        USER_ID,
        POST_ID
    ) VALUES (
        SEQ_LIKES.NEXTVAL,
        SYSTIMESTAMP,
        PI_USER_ID,
        PI_POST_ID
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('LIKE ADDED SUCCESSFULLY');
EXCEPTION
    WHEN E_ALREADY_LIKED THEN
        DBMS_OUTPUT.PUT_LINE('USER HAS ALREADY LIKED THIS POST');
    WHEN E_USER_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('USER NOT FOUND');
    WHEN E_POST_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('POST NOT FOUND');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 2));
END ADD_LIKE;
/


-- dislike post
CREATE OR REPLACE PROCEDURE REMOVE_LIKE (
    PI_USER_ID NUMBER,
    PI_POST_ID NUMBER
) AS
    E_LIKE_NOT_FOUND EXCEPTION;
    E_USER_NOT_FOUND EXCEPTION;
    E_POST_NOT_FOUND EXCEPTION;
    V_LIKE_COUNT NUMBER;
    V_USER_COUNT NUMBER;
    V_POST_COUNT NUMBER;
BEGIN

    -- Check if the user exists
    SELECT COUNT(*) INTO V_USER_COUNT FROM USERS WHERE USER_ID = PI_USER_ID;
    IF V_USER_COUNT = 0 THEN
        RAISE E_USER_NOT_FOUND;
    END IF;
    
    -- Check if the post exists
    SELECT COUNT(*) INTO V_POST_COUNT FROM POSTS WHERE POST_ID = PI_POST_ID;
    IF V_POST_COUNT = 0 THEN
        RAISE E_POST_NOT_FOUND;
    END IF;
    
    -- Check if the like exists
    SELECT COUNT(*) INTO V_LIKE_COUNT FROM LIKES WHERE USER_ID = PI_USER_ID AND POST_ID = PI_POST_ID;
    IF V_LIKE_COUNT = 0 THEN
        RAISE E_LIKE_NOT_FOUND;
    END IF;
    
    -- Delete the like
    DELETE FROM LIKES WHERE USER_ID = PI_USER_ID AND POST_ID = PI_POST_ID;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('LIKE REMOVED SUCCESSFULLY');
EXCEPTION
    WHEN E_LIKE_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('LIKE NOT FOUND');
    WHEN E_USER_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('USER NOT FOUND');
    WHEN E_POST_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('POST NOT FOUND');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 2));
END REMOVE_LIKE;
/


-- Add tag
CREATE OR REPLACE PROCEDURE ADD_TAG (
    PI_TAG NVARCHAR2,
    PI_POINT NUMBER,
    PO_TAG_ID OUT NUMBER
) AS
    E_TAG_EXISTS EXCEPTION;
    V_TAG_COUNT NUMBER;
BEGIN
    SELECT COUNT(*) INTO V_TAG_COUNT FROM TAGS WHERE TAG = UPPER(PI_TAG);
    
    IF V_TAG_COUNT > 0 THEN
        SELECT TAG_ID INTO PO_TAG_ID FROM TAGS WHERE UPPER(TAG) = UPPER(PI_TAG);
        RAISE E_TAG_EXISTS;
    END IF;
    

    INSERT INTO TAGS (TAG_ID, CREATED_AT, TAG, POINT)
    VALUES (SEQ_TAGS.NEXTVAL, SYSTIMESTAMP, UPPER(PI_TAG), PI_POINT)
    RETURNING TAG_ID INTO PO_TAG_ID;

    DBMS_OUTPUT.PUT_LINE('TAG ADDED SUCCESSFULLY');
EXCEPTION
    WHEN E_TAG_EXISTS THEN
        DBMS_OUTPUT.PUT_LINE('TAG ALREADY EXISTS');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 2));
END ADD_TAG;
/


-- Add post hashtag
CREATE OR REPLACE PROCEDURE ADD_POST_HASHTAG (
    PI_POST_ID NUMBER,
    PI_HASHTAG_ID NUMBER
) AS
    E_POST_NOT_FOUND EXCEPTION;
    E_TAG_NOT_FOUND EXCEPTION;
    E_ASSOCIATION_EXISTS EXCEPTION;
    V_POST_COUNT NUMBER;
    V_TAG_COUNT NUMBER;
    V_ASSOC_COUNT NUMBER;
BEGIN
    SELECT COUNT(*) INTO V_POST_COUNT FROM POSTS WHERE POST_ID = PI_POST_ID;
    IF V_POST_COUNT = 0 THEN
        RAISE E_POST_NOT_FOUND;
    END IF;

    SELECT COUNT(*) INTO V_TAG_COUNT FROM TAGS WHERE TAG_ID = PI_HASHTAG_ID;
    IF V_TAG_COUNT = 0 THEN
        RAISE E_TAG_NOT_FOUND;
    END IF;

    SELECT COUNT(*) INTO V_ASSOC_COUNT FROM POSTS_HASHTAGS WHERE POST_ID = PI_POST_ID AND HASHTAG_ID = PI_HASHTAG_ID;
    IF V_ASSOC_COUNT > 0 THEN
        RAISE E_ASSOCIATION_EXISTS;
    END IF;

    INSERT INTO POSTS_HASHTAGS (
        POST_ID,
        HASHTAG_ID
    ) VALUES (
        PI_POST_ID,
        PI_HASHTAG_ID
    );

    DBMS_OUTPUT.PUT_LINE('POST-HASHTAG ASSOCIATION ADDED SUCCESSFULLY');
EXCEPTION
    WHEN E_POST_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('POST NOT FOUND');
    WHEN E_TAG_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('TAG NOT FOUND');
    WHEN E_ASSOCIATION_EXISTS THEN
        DBMS_OUTPUT.PUT_LINE('ASSOCIATION ALREADY EXISTS');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 2));
END ADD_POST_HASHTAG;
/


-- Add user hashtag
CREATE OR REPLACE PROCEDURE ADD_USER_HASHTAG (
    PI_USER_ID NUMBER,
    PI_HASHTAG_ID NUMBER
) AS
    E_USER_NOT_FOUND EXCEPTION;
    E_TAG_NOT_FOUND EXCEPTION;
    E_ASSOCIATION_EXISTS EXCEPTION;
    V_USER_COUNT NUMBER;
    V_TAG_COUNT NUMBER;
    V_ASSOC_COUNT NUMBER;
BEGIN
    SELECT COUNT(*) INTO V_USER_COUNT FROM USERS WHERE USER_ID = PI_USER_ID;
    IF V_USER_COUNT = 0 THEN
        RAISE E_USER_NOT_FOUND;
    END IF;

    SELECT COUNT(*) INTO V_TAG_COUNT FROM TAGS WHERE TAG_ID = PI_HASHTAG_ID;
    IF V_TAG_COUNT = 0 THEN
        RAISE E_TAG_NOT_FOUND;
    END IF;

    SELECT COUNT(*) INTO V_ASSOC_COUNT FROM USER_HASHTAGS WHERE USER_ID = PI_USER_ID AND HASHTAG_ID = PI_HASHTAG_ID;
    IF V_ASSOC_COUNT > 0 THEN
        RAISE E_ASSOCIATION_EXISTS;
    END IF;

    INSERT INTO USER_HASHTAGS (
        USER_ID,
        HASHTAG_ID
    ) VALUES (
        PI_USER_ID,
        PI_HASHTAG_ID
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('USER-HASHTAG ASSOCIATION ADDED SUCCESSFULLY');
EXCEPTION
    WHEN E_USER_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('USER NOT FOUND');
    WHEN E_TAG_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('TAG NOT FOUND');
    WHEN E_ASSOCIATION_EXISTS THEN
        DBMS_OUTPUT.PUT_LINE('ASSOCIATION ALREADY EXISTS');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 2));
END ADD_USER_HASHTAG;
/


-- Add sponsorship
CREATE OR REPLACE PROCEDURE ADD_SPONSORSHIP (
    PI_POST_ID NUMBER,
    PI_SPONSEE_ID NUMBER,
    PI_SPONSOR_ID NUMBER
) AS
    E_POST_NOT_FOUND EXCEPTION;
    E_SPONSEE_NOT_FOUND EXCEPTION;
    E_SPONSOR_NOT_FOUND EXCEPTION;
    E_POST_INACTIVE EXCEPTION;
    V_POST_COUNT NUMBER;
    V_SPONSEE_COUNT NUMBER;
    V_SPONSOR_COUNT NUMBER;
    V_POST_ACTIVE_STATUS NUMBER;
BEGIN

    -- Check if the post exists
    SELECT COUNT(*) INTO V_POST_COUNT FROM POSTS WHERE POST_ID = PI_POST_ID;
    IF V_POST_COUNT = 0 THEN
        RAISE E_POST_NOT_FOUND;
    END IF;

    -- Check the active status of the post
    SELECT NVL(ACTIVESTATUS, -1) INTO V_POST_ACTIVE_STATUS FROM POSTS WHERE POST_ID = PI_POST_ID;
    IF V_POST_ACTIVE_STATUS = 0 THEN
        RAISE E_POST_INACTIVE;
    END IF;

    SELECT COUNT(*) INTO V_SPONSEE_COUNT FROM USERS WHERE USER_ID = PI_SPONSEE_ID;
    IF V_SPONSEE_COUNT = 0 THEN
        RAISE E_SPONSEE_NOT_FOUND;
    END IF;

    SELECT COUNT(*) INTO V_SPONSOR_COUNT FROM USERS WHERE USER_ID = PI_SPONSOR_ID;
    IF V_SPONSOR_COUNT = 0 THEN
        RAISE E_SPONSOR_NOT_FOUND;
    END IF;

    INSERT INTO SPONSORSHIP (
        SPONSORSHIP_ID,
        CREATED_AT,
        POST_ID,
        SPONSEE_ID,
        SPONSOR_ID,
        STATUS
    ) VALUES (
        SEQ_SPONSORSHIP.NEXTVAL,
        SYSTIMESTAMP,
        PI_POST_ID,
        PI_SPONSEE_ID,
        PI_SPONSOR_ID,
        'PENDING'
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('SPONSORSHIP CREATED SUCCESSFULLY');
EXCEPTION
    WHEN E_POST_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('POST NOT FOUND');
    WHEN E_SPONSEE_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('SPONSEE NOT FOUND');
    WHEN E_SPONSOR_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('SPONSOR NOT FOUND');
    WHEN E_POST_INACTIVE THEN
        DBMS_OUTPUT.PUT_LINE('POST IS INACTIVE');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 2));
END ADD_SPONSORSHIP;
/


-- Update Sponsorship
CREATE OR REPLACE PROCEDURE UPDATE_SPONSORSHIP (
    PI_SPONSORSHIP_ID NUMBER,
    PI_NEW_STATUS VARCHAR2
) AS
    E_SPONSORSHIP_NOT_FOUND EXCEPTION;
    E_STATUS_INVALID EXCEPTION;
    V_SPONSORSHIP_COUNT NUMBER;

BEGIN
    -- Check if the sponsorship exists
    SELECT COUNT(*) INTO V_SPONSORSHIP_COUNT FROM SPONSORSHIP WHERE SPONSORSHIP_ID = PI_SPONSORSHIP_ID;

    IF V_SPONSORSHIP_COUNT = 0 THEN
        RAISE E_SPONSORSHIP_NOT_FOUND;
    END IF;


    -- Validate the new status
    IF PI_NEW_STATUS NOT IN ('SUCCESSFUL', 'CANCELLED') THEN
        RAISE E_STATUS_INVALID;
    END IF;

    -- Update the sponsorship
    UPDATE SPONSORSHIP
    SET
        STATUS = PI_NEW_STATUS
    WHERE SPONSORSHIP_ID = PI_SPONSORSHIP_ID;

    DBMS_OUTPUT.PUT_LINE('SPONSORSHIP UPDATED SUCCESSFULLY');
EXCEPTION
    WHEN E_SPONSORSHIP_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Sponsorship not found.');
    WHEN E_STATUS_INVALID THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid status provided.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END UPDATE_SPONSORSHIP;
/

-- Add follower
CREATE OR REPLACE PROCEDURE ADD_FOLLOWER (
    PI_FOLLOWER_ID NUMBER,
    PI_FOLLOWING_ID NUMBER
) AS
    E_SELF_FOLLOW EXCEPTION;
    E_FOLLOWER_NOT_FOUND EXCEPTION;
    E_FOLLOWING_NOT_FOUND EXCEPTION;
    E_ALREADY_FOLLOWING EXCEPTION;
    V_FOLLOWER_COUNT NUMBER;
    V_FOLLOWING_COUNT NUMBER;
    V_FOLLOWING_EXISTS NUMBER;
BEGIN
    IF PI_FOLLOWER_ID = PI_FOLLOWING_ID THEN
        RAISE E_SELF_FOLLOW;
    END IF;

    SELECT COUNT(*) INTO V_FOLLOWER_COUNT FROM USERS WHERE USER_ID = PI_FOLLOWER_ID;
    SELECT COUNT(*) INTO V_FOLLOWING_COUNT FROM USERS WHERE USER_ID = PI_FOLLOWING_ID;
    IF V_FOLLOWER_COUNT = 0 THEN
        RAISE E_FOLLOWER_NOT_FOUND;
    ELSIF V_FOLLOWING_COUNT = 0 THEN
        RAISE E_FOLLOWING_NOT_FOUND;
    END IF;

    SELECT COUNT(*) INTO V_FOLLOWING_EXISTS FROM USER_FOLLOWERS WHERE FOLLOWER_ID = PI_FOLLOWER_ID AND FOLLOWING_ID = PI_FOLLOWING_ID;
    IF V_FOLLOWING_EXISTS > 0 THEN
        RAISE E_ALREADY_FOLLOWING;
    END IF;

    INSERT INTO USER_FOLLOWERS (
        FOLLOWER_ID,
        FOLLOWING_ID
    ) VALUES (
        PI_FOLLOWER_ID,
        PI_FOLLOWING_ID
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('FOLLOWER ADDED SUCCESSFULLY');
EXCEPTION
    WHEN E_SELF_FOLLOW THEN
        DBMS_OUTPUT.PUT_LINE('CANNOT FOLLOW YOURSELF');
    WHEN E_FOLLOWER_NOT_FOUND OR E_FOLLOWING_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('USER NOT FOUND');
    WHEN E_ALREADY_FOLLOWING THEN
        DBMS_OUTPUT.PUT_LINE('ALREADY FOLLOWING THIS USER');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 2));
END ADD_FOLLOWER;
/

CREATE OR REPLACE PROCEDURE INCREMENT_TAG_POINTS (
    PI_TAG_ID NUMBER
) AS
    E_TAG_NOT_FOUND EXCEPTION;
    V_TAG_COUNT NUMBER;
BEGIN
    -- Check if the tag exists
    SELECT COUNT(*) INTO V_TAG_COUNT FROM TAGS WHERE TAG_ID = PI_TAG_ID;

    IF V_TAG_COUNT = 0 THEN
        RAISE E_TAG_NOT_FOUND;
    END IF;

    -- Update the points for the tag
    UPDATE TAGS SET POINT = POINT + 1 WHERE TAG_ID = PI_TAG_ID;

    DBMS_OUTPUT.PUT_LINE('Tag points incremented successfully.');
EXCEPTION
    WHEN E_TAG_NOT_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Tag not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, INSTR(SQLERRM, ':') + 2));
END INCREMENT_TAG_POINTS;
/
