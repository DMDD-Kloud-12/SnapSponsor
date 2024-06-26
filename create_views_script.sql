-- Sponsorship_opportunities_view
CREATE OR REPLACE VIEW sponsorship_opportunities_view AS
SELECT p.post_id,
       p.created_at,
       p.text,
       p.image,
       p.venue,
       p.food,
       p.monetary,
       p.other,
       p.likescount,
       p.commentscount,
       p.user_id,
       p.activestatus,
       t.tag_id,
       t.tag
  FROM posts p
       JOIN posts_hashtags ph ON p.post_id = ph.post_id
       JOIN tags t ON ph.hashtag_id = t.tag_id
  WHERE p.activestatus = 1;

-- Sponsorship_request_status_view
CREATE OR REPLACE VIEW sponsorship_request_status_view AS
SELECT s.sponsorship_id,
       s.created_at,
       p.text AS event_name,
       u1.name AS sponsor_name,
       u2.name AS sponsee_name,
       s.status
  FROM sponsorship s
       JOIN posts p ON s.post_id = p.post_id
       JOIN users u1 ON s.sponsor_id = u1.user_id
       JOIN users u2 ON s.sponsee_id = u2.user_id;

-- User_profile_management_view
CREATE OR REPLACE VIEW user_profile_management_view AS
SELECT u.user_id,
       u.last_login,
       u.is_superuser,
       u.created_at,
       u.name,
       u.profileimage,
       u.phonenumber,
       u.aboutme,
       u.aboutorganisation,
       u.email,
       t.tag_id,
       t.tag,
       t.point
  FROM users u
       LEFT JOIN user_hashtags uh ON u.user_id = uh.user_id
       LEFT JOIN tags t ON uh.hashtag_id = t.tag_id;


-- User_tag_management_view
CREATE OR REPLACE VIEW user_tag_management_view AS
SELECT u.user_id,
       u.name,
       t.tag_id,
       t.tag,
       t.point
  FROM users u
       LEFT JOIN user_hashtags uh ON u.user_id = uh.user_id
       LEFT JOIN tags t ON uh.hashtag_id = t.tag_id
GROUP BY u.user_id, u.name, t.tag_id, t.tag, t.point;


-- Post Popularity report 
CREATE OR REPLACE VIEW POST_POPULARITY_REPORT AS
SELECT 
    p.POST_ID,
    p.USER_ID,
    u.NAME AS USER_NAME,
    p.TEXT,
    p.LIKESCOUNT,
    p.COMMENTSCOUNT,
    CALCULATE_POST_POPULARITY(p.POST_ID) AS POPULARITY_SCORE
FROM 
    POSTS p
JOIN 
    USERS u ON p.USER_ID = u.USER_ID;
