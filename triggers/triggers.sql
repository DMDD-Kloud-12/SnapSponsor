-- Create trigger to update post status
CREATE OR REPLACE TRIGGER trg_update_post_status
AFTER INSERT OR UPDATE OF STATUS ON SPONSORSHIP
FOR EACH ROW
BEGIN
    IF :NEW.STATUS IN ('PENDING', 'SUCCESSFUL') THEN
        -- Set associated post status to inactive
        UPDATE POSTS SET ACTIVESTATUS = 0 WHERE POST_ID = :NEW.POST_ID;
    ELSIF :NEW.STATUS = 'CANCELLED' THEN
        -- Set associated post status to active
        UPDATE POSTS SET ACTIVESTATUS = 1 WHERE POST_ID = :NEW.POST_ID;
    END IF;
END;
/