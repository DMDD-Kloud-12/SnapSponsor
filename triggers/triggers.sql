-- Create trigger to update post status
CREATE OR REPLACE TRIGGER UPDATE_POST_STATUS
AFTER INSERT OR UPDATE OF STATUS ON SPONSORSHIP
FOR EACH ROW
BEGIN
    IF :NEW.STATUS = 'SUCCESSFUL' THEN
        -- Set associated post status to inactive
        UPDATE POSTS SET ACTIVESTATUS = 0 WHERE POST_ID = :NEW.POST_ID;
    ELSIF :NEW.STATUS in ('PENDING', 'CANCELLED') THEN
        -- Set associated post status to active
        UPDATE POSTS SET ACTIVESTATUS = 1 WHERE POST_ID = :NEW.POST_ID;
    END IF;
END;
/


-- Trigger to update comment count on post
CREATE OR REPLACE TRIGGER TRG_UPDATE_COMMENT_COUNT
AFTER INSERT OR DELETE ON COMMENTS
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        UPDATE POSTS
        SET COMMENTSCOUNT = COMMENTSCOUNT + 1
        WHERE POST_ID = :NEW.POST_ID;
    ELSIF DELETING THEN
        UPDATE POSTS
        SET COMMENTSCOUNT = COMMENTSCOUNT - 1
        WHERE POST_ID = :OLD.POST_ID AND COMMENTSCOUNT > 0;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_UPDATE_LIKE_COUNT
AFTER INSERT OR DELETE ON LIKES
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        -- Increase LIKESCOUNT by 1 for the associated post when a like is added
        UPDATE POSTS
        SET LIKESCOUNT = LIKESCOUNT + 1
        WHERE POST_ID = :NEW.POST_ID;
    ELSIF DELETING THEN
        -- Decrease LIKESCOUNT by 1 for the associated post when a like is removed, ensuring it doesn't go below 0
        UPDATE POSTS
        SET LIKESCOUNT = LIKESCOUNT - 1
        WHERE POST_ID = :OLD.POST_ID AND LIKESCOUNT > 0;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_post_operations
FOR INSERT ON posts
COMPOUND TRIGGER

    TYPE t_posts_rec IS TABLE OF posts%ROWTYPE INDEX BY PLS_INTEGER;
    posts_tab t_posts_rec;
    idx PLS_INTEGER := 0;

    AFTER EACH ROW IS
    BEGIN
        idx := idx + 1;
        posts_tab(idx).post_id := :NEW.post_id;
        posts_tab(idx).text := :NEW.text;
    END AFTER EACH ROW;

    AFTER STATEMENT IS
    BEGIN
        FOR i IN 1 .. posts_tab.COUNT LOOP
            DECLARE
                v_process_result VARCHAR2(4000);
            BEGIN
                v_process_result := PROCESS_HASHTAGS(posts_tab(i).post_id, posts_tab(i).text);
                DBMS_OUTPUT.PUT_LINE('Hashtags processed for Post ID ' || posts_tab(i).post_id || ': ' || v_process_result);
            END;
        END LOOP;
    END AFTER STATEMENT;

END trg_post_operations;