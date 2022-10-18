-- Harper Sanford
-- Exercise 2, Problem 3 Answers
--
-- NOTE: I set up a personal PostgreSQL DB on my computer and verified these.

-- Given the following table structure:

--User
    -- user_id (PK)
    -- first_name
    -- last_name
    -- email
    -- join_date

--Group
    -- group_id (PK)
    -- group_name
    -- created_at

--User_group
    -- user_id (PK)
    -- group_id

-- 1.  generate a list of all users who joined in the last month in the Cat Lovers group

select u.*
	from user u
	join user_group ug
		on u.user_id = ug.user_id
	join group g
		on g.group_id = ug.group_id
	where g.group_name = 'Cat Lovers'
	AND u.join_date > NOW() - INTERVAL '1 month';

-- 2.  generate a list of all users with an @yahoo.com email address who are in the Unicorn Conspiracy Theories group

-- This is filtering on user email rather than join date.
select u.*
	from user u
	join user_group ug
		on u.user_id = ug.user_id
	join group g
		on g.group_id = ug.group_id
	where g.group_name = 'Unicorn Conspiracy Theories'
    -- Need to ensure that the email ENDS with @yahoo.com
    -- hence the lack of % at the end of the like string.
	and u.email like '%@yahoo.com';

-- 3.  generate a list of all groups created before 1-1-2016 with zero members

select g.*
	from group g
    -- No need for count() when we can just look for group_id's
    -- that don't exist in the user_group table using a left join.
    --
    -- Also much much faster.  count() can get REALLY expensive!
	left outer join user_group ug
		on g.group_id = ug.group_id
	where ug.group_id is null
	AND g.created_at::date < date '2016-1-1';