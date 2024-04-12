SET DEFINE OFF;

--DML Queries

truncate table user_followers;
truncate table user_hashtags;
truncate table likes;
truncate table comments;
truncate table posts_hashtags;
truncate table sponsorship;
truncate table posts;
truncate table users;
truncate table tags;


/*
select * from  users;
select * from  likes;
select * from  comments;
select * from  posts;
select * from  posts_hashtags;
select * from  sponsorship;
select * from  tags;
select * from  user_followers;
select * from  user_hashtags;
*/

-- USERS

EXEC ADD_USER (0, 'Alice Johnson', 'profile1.jpg', '2315551001', 'Organizer of local community events.', 'Community Events', 'alicej@example.com', 'passAlice1');
EXEC ADD_USER (0, 'Bob Smith', 'profile2.jpg', '5553341002', 'Tech enthusiast, loves attending conferences.', 'Tech Innovations', 'bobsmith@example.com', 'passBob2');
EXEC ADD_USER (0, 'Carol Taylor', 'profile3.jpg', '5551343003', 'Passionate about art and music festivals.', 'Art & music Forever', 'carolt@example.com', 'passCarol3');
EXEC ADD_USER (1, 'David Lee', 'profile4.jpg', '5551343004', 'Developer and part-time event photographer.', 'Coding & photos', 'davidl@example.com', 'passDavid4');
EXEC ADD_USER (0, 'Emma Wilson', 'profile5.jpg', '5551364005', 'Fitness enthusiast, organizes sports events.', 'Wellness in Motion', 'emmaw@example.com', 'passEmma5');
EXEC ADD_USER (0, 'Frank Moore', 'profile6.jpg', '5551456006', 'Food critic, enjoys gourmet food events.', 'Taste the Best', 'frankm@example.com', 'passFrank6');
EXEC ADD_USER (0, 'Grace Lee', 'profile7.jpg', '5551234007', 'Advocates for sustainability in events.', 'Green Events', 'gracel@example.com', 'passGrace7');
EXEC ADD_USER (0, 'Henry Garcia', 'profile8.jpg', '5557541008', 'Enjoys exploring cultural and historic events.', 'CultureQuest', 'henryg@example.com', 'passHenry8');
EXEC ADD_USER (0, 'Isabella Brown', 'profile9.jpg', '5551043709', 'Freelance writer, covers various events.', 'Stories of Events', 'isabellab@example.com', 'passBella9');
EXEC ADD_USER (0, 'Jack Davis', 'profile10.jpg', '5551547010', 'Professional DJ, participates in music events.', 'Beats & rhythms', 'jackd@example.com', 'passJack10');


-- POSTS 

EXEC ADD_POST ('Tech Conference 2024 - Exploring New Horizons #tech', 'post1.jpg', 'Convention Center', 'Snacks available', 'Free', 'Early bird discount', 2, 1); COMMIT;
EXEC ADD_POST ('Annual #Charity Run - Run for a Cause', 'post2.jpg', 'City Park', 'Healthy snacks', '$30 entry', 'Prizes for top 3', 1, 1); COMMIT;
EXEC ADD_POST ('#Art Exhibition Opening Night', 'post3.jpg', 'Art Gallery', 'Wine & Cheese', 'By invite', 'Featured artists', 3, 1); COMMIT;
EXEC ADD_POST ('Local #Farmers Market - Fresh & Organic', 'post4.jpg', 'Downtown', 'Free samples', 'Free', null, 7, 1); COMMIT;
EXEC ADD_POST ('#Coding Bootcamp: Learn to Code in 10 Weeks', 'post5.jpg', 'Tech Hub', 'Lunch provided', '$500', 'Scholarships available', 4, 1); COMMIT;
EXEC ADD_POST ('Sustainability in Event Planning #Workshop', 'post6.jpg', 'Eco Center', 'Vegan friendly', '$20', 'Materials provided', 7, 1); COMMIT;
EXEC ADD_POST ('Live Jazz Night - Enjoy #Classic Hits #music', 'post7.jpg', 'Jazz Club', 'Special menu', 'Cover $10', 'Reservations recommended', 9, 1); COMMIT;
EXEC ADD_POST ('Gourmet #Food Tasting Event', 'post8.jpg', 'Luxury Hotel', 'Chefs selection', '$100', 'Limited seats', 6, 1); COMMIT;
EXEC ADD_POST ('DIY Home #Decor Workshop #planning', 'post9.jpg', 'Craft Store', 'Snacks & Drinks', '$25', 'All materials included', 5, 1); COMMIT;
EXEC ADD_POST ('#Yoga Retreat - Find Your Inner #Peace', 'post10.jpg', 'Mountain Resort', 'Organic meals', '$300', 'Spa access included', 5, 1); COMMIT;
EXEC ADD_POST ('Film Screening: Indie #Film Night', 'post11.jpg', 'Indie Theater', 'Popcorn & Soda', '$15', 'Q&A with directors', 8, 1); COMMIT;
EXEC ADD_POST ('#Photography Contest: Capture the City', 'post12.jpg', 'Online', null, 'Free', 'Winning prize $500', 4, 1); COMMIT;

-- LIKES

EXEC ADD_LIKE (2, 1);
EXEC ADD_LIKE (3, 12);
EXEC ADD_LIKE (1, 2);
EXEC ADD_LIKE (4, 5);
EXEC ADD_LIKE (5, 3);
EXEC ADD_LIKE (6, 1);
EXEC ADD_LIKE (7, 4);
EXEC ADD_LIKE (8, 10);
EXEC ADD_LIKE (9, 11);
EXEC ADD_LIKE (10, 2);
EXEC ADD_LIKE (1, 6);
EXEC ADD_LIKE (2, 1);
EXEC ADD_LIKE (3, 7);
EXEC ADD_LIKE (4, 6);
EXEC ADD_LIKE (5, 8);
EXEC ADD_LIKE (5, 9);

EXEC REMOVE_LIKE(5, 9);

-- COMMENTS

EXEC ADD_COMMENT ('This is going to be groundbreaking!', 1, 1);
EXEC ADD_COMMENT ('Can''t wait to participate.', 3, 12);
EXEC ADD_COMMENT ('Looking forward to this!', 5, 2);
EXEC ADD_COMMENT ('Is registration still open?', 2, 1);
EXEC ADD_COMMENT ('Amazing event!', 4, 3);
EXEC ADD_COMMENT ('Will there be a live stream?', 6, 10);
EXEC ADD_COMMENT ('I love these workshops!', 7, 1);
EXEC ADD_COMMENT ('Finally, something for us foodies.', 8, 4);
EXEC ADD_COMMENT ('What time does it start?', 9, 7);
EXEC ADD_COMMENT ('This will be fun!', 10, 5);

-- USER_FOLLOWERS

EXEC ADD_FOLLOWER (1, 2);
EXEC ADD_FOLLOWER (1, 3);
EXEC ADD_FOLLOWER (2, 1);
EXEC ADD_FOLLOWER (3, 4);
EXEC ADD_FOLLOWER (4, 2);
EXEC ADD_FOLLOWER (5, 6);
EXEC ADD_FOLLOWER (6, 5);
EXEC ADD_FOLLOWER (7, 8);
EXEC ADD_FOLLOWER (8, 7);
EXEC ADD_FOLLOWER (9, 10);
EXEC ADD_FOLLOWER (10, 9);
EXEC ADD_FOLLOWER (2, 4);
EXEC ADD_FOLLOWER (4, 3);


-- SPONSORSHIP

EXEC ADD_SPONSORSHIP (1, 2, 1);
EXEC ADD_SPONSORSHIP (2, 1, 3);
EXEC ADD_SPONSORSHIP (3, 4, 2);
EXEC ADD_SPONSORSHIP (4, 3, 1);



-- USER_HASHTAGS

EXEC ADD_USER_HASHTAG (3, 2);
EXEC ADD_USER_HASHTAG (4, 1);
EXEC ADD_USER_HASHTAG (5, 5);
EXEC ADD_USER_HASHTAG (6, 8);
EXEC ADD_USER_HASHTAG (7, 6);
EXEC ADD_USER_HASHTAG (8, 7);
EXEC ADD_USER_HASHTAG (9, 9);
EXEC ADD_USER_HASHTAG (10, 10);

