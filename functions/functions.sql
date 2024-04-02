SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION PROCESS_HASHTAGS(PI_POST_ID NUMBER, PI_TEXT NCLOB)
RETURN VARCHAR2 AS
    -- Local variables to hold intermediate data
    v_hashtag VARCHAR2(100);
    v_position INT;
    v_end_position INT;
    v_text NVARCHAR2(4000) := TRIM(PI_TEXT) || ' '; -- Ensure the text ends with space for processing
    v_tag_id NUMBER;
BEGIN
    -- Loop through the text to find hashtags
    v_position := INSTR(v_text, '#');
    WHILE v_position > 0 LOOP
        v_end_position := INSTR(v_text, ' ', v_position);
        v_hashtag := SUBSTR(v_text, v_position + 1, v_end_position - v_position - 1);
        

        ADD_TAG(v_hashtag, 0, v_tag_id);

        
        -- Associate the post with the tag using the ADD_POST_HASHTAG procedure
        EXECUTE IMMEDIATE 'CALL ADD_POST_HASHTAG(:1, :2)' USING PI_POST_ID, v_tag_id;
        
        -- Prepare for the next iteration
        v_text := SUBSTR(v_text, v_end_position);
        v_position := INSTR(v_text, '#'); 
    END LOOP;
    
    RETURN 'Processed hashtags successfully';
EXCEPTION
    WHEN OTHERS THEN
        RETURN SQLERRM;
END PROCESS_HASHTAGS;
/