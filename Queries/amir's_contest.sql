create table users
(
    "id" bigint
        constraint users_pk
            primary key,
    "name"        VARCHAR(255)
);

create table contests
(
    "id" bigint
        constraint contests_pk
            primary key,
    title         VARCHAR(255)
);

create table problems
(
    "id" bigint
        constraint problems_pk
            primary key,
    contest_id bigint
        constraint contest_id
            references users,
    title VARCHAR(255)
);

create table submissions
(
    "id" bigint
        constraint submissions_pk
            primary key,
    user_id int
        constraint user_id
            references users,
    problem_id int
        constraint problem_id
            references problems,
    score       bigint
);

-- FIRST PART
SELECT problems.title AS P_TITLE, contests.title AS C_TITLE, count(*) AS NUMBER_OF_SUBMISSIONS
FROM problems
JOIN submissions ON problems.id = submissions.problem_id
JOIN contests ON problems.contest_id = contests.id
GROUP BY problems.title, contests.title
ORDER BY NUMBER_OF_SUBMISSIONS DESC, P_TITLE, C_TITLE;


-- SECOND PART
SELECT contests.title, count(DISTINCT user_id) AS AMOUNT
FROM contests
JOIN problems ON contests.id = problems.contest_id
JOIN submissions ON problems.id = submissions.problem_id
GROUP BY contest_id, contests.title
ORDER BY AMOUNT DESC, contests.title;


-- THIRD PART
SELECT users.name, SUM(MAX_SCORE) AS SCORE
FROM (
    SELECT user_id, problem_id, MAX(score) AS MAX_SCORE
    FROM submissions
    JOIN problems ON submissions.problem_id = problems.id
    JOIN contests ON problems.contest_id = contests.id
    WHERE contests.title = 'mahale'
    GROUP BY user_id, problem_id
) AS X
JOIN users ON X.user_id = users.id
GROUP BY user_id, users.name
ORDER BY SCORE DESC, name;

-- FORTH PART
SELECT *
FROM (
         SELECT users.name, coalesce(SUM(MAX_SCORE), 0) AS SCORE
         FROM (
                  SELECT user_id, problem_id, MAX(score) AS MAX_SCORE
                  FROM submissions
                           JOIN problems ON submissions.problem_id = problems.id
                           JOIN contests ON problems.contest_id = contests.id
                  GROUP BY user_id, problem_id
              ) AS X
                  RIGHT OUTER JOIN users ON X.user_id = users.id
         GROUP BY user_id, users.name
     ) AS X
ORDER BY X.SCORE DESC;


-- FIFTH PART
UPDATE contests
SET title = replace(title, 'mahale', 'Mosabeghe Mahale')
WHERE title = 'mahale';

-- SIXTH PART
DELETE
FROM contests AS OUTER_CONTEST
WHERE NOT EXISTS(
    SELECT *
    FROM submissions
    JOIN problems ON submissions.problem_id = problems.id
    JOIN contests ON problems.contest_id = contests.id
    WHERE contests.id = OUTER_CONTEST.id
)