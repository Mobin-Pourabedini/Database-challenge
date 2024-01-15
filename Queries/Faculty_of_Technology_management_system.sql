DROP TABLE IF EXISTS student_groups;
DROP TABLE IF EXISTS groups;
DROP TABLE IF EXISTS prerequisite;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS professor;
DROP TABLE IF EXISTS courses;
create table courses
(
    title  TEXT not null,
    id     SERIAL
        constraint courses_pk
            primary key,
    credit int
);
INSERT INTO courses(TITLE, CREDIT)
VALUES      ('CE384', 3),
            ('DB', 3),
            ('AP', 3),
            ('NETWORK', 3),
            ('BP', 3),
            ('CSL', 3),
            ('WEB', 3),
            ('R1', 4),
            ('R2', 4),
            ('R3', 4),
            ('SOFTWARE DESIGN 1', 3),
            ('SOFTWARE DESIGN 2', 3);

create table professor
(
    id   SERIAL
        constraint professor_pk
            primary key,
    "name" VARCHAR(255)
);
INSERT INTO professor(name)
VALUES ('MAHDI AKHI'),
       ('ALI SHARIFI ZARCHI'),
       ('FAZLI');

create table student
(
    id   SERIAL
        constraint student_pk
            primary key,
    "name" VARCHAR(255),
    major  VARCHAR(255)
);
INSERT INTO student("name", major)
VALUES ('MOBIN', 'CE'),
       ('MATIN', 'CS'),
       ('ARMIN', 'CE'),
       ('MOBINA', 'SOFTWARE'),
       ('MITRA', 'EE'),
       ('777', 'NETWORK SECURITY'),
       ('MONA', 'EE'),
       ('MATIN', 'EE');

create table prerequisite
(
    course_id bigint
        constraint course_id
            references courses,
    pre_course_id bigint
        constraint pre_course_id
            references courses
);
alter table prerequisite
    add constraint prerequisite_pk
        primary key (course_id, pre_course_id);
INSERT INTO prerequisite(course_id, pre_course_id)
VALUES (2, 3);

create table groups
(
    course_id bigint
        constraint course_id
            references courses,
    professor_id bigint
        constraint pre_course_id
            references professor,
    group_id    int,
    term        int,
    "year"      int
);
alter table groups
    add constraint groups_pk
        primary key (course_id, group_id, term, "year");
INSERT INTO groups(course_id, professor_id, group_id, term, "year")
VALUES (2, 1, 1, 1, 1402),
       (3, 3, 2, 2, 1401),
       (2, 1, 3, 2, 1393),
       (3, 3, 4, 2, 1393),
       (1, 2, 5, 2, 1393),
       (5, 3, 6, 2, 1393),
       (6, 3, 7, 2, 1393),
       (7, 3, 8, 2, 1393),
       (8, 3, 9, 2, 1393),
       (9, 3, 10, 2, 1393),
       (4, 3, 12, 2, 1393),
       (10, 3, 11, 2, 1393),
       (11, 1, 13, 2, 1393),
       (12, 1, 14, 2, 1393);


create table student_groups
(
    student_id bigint
        constraint student_id
            references student,
    course_id bigint
        constraint course_id
            references courses,
    professor_id bigint
        constraint pre_course_id
            references professor,
    group_id    int,
    term        int,
    "year"      int,
    grade       int
);
alter table student_groups
    add constraint student_groups_pk
        primary key (course_id, group_id, term, "year", student_id);
INSERT INTO student_groups(student_id, course_id, professor_id, group_id, term, "year", grade)
VALUES (1, 2, 1, 1, 1, 1402, 18),
       (1, 3, 3, 2, 2, 1401, 19),
       (2, 3, 3, 2, 2, 1401, 15),
       (3, 3, 3, 2, 2, 1401, 14),
       (1, 2, 1, 3, 2, 1393, 20),
       (3, 2, 1, 3, 2, 1393, 17),
       (4, 2, 1, 3, 2, 1393, 16),
       (6, 2, 1, 3, 2, 1393, 18),
       (1, 3, 3, 4, 2, 1393, 20),
       (6, 3, 3, 4, 2, 1393, 19),
       (2, 1, 2, 5, 2, 1393, 17),
       (3, 1, 2, 5, 2, 1393, 9),
       (4, 1, 2, 5, 2, 1393, 7),
       (6, 1, 2, 5, 2, 1393, 16),
       (5, 2, 1, 3, 2, 1393, 12),
       (5, 3, 3, 4, 2, 1393, 6),
       (5, 1, 2, 5, 2, 1393, 5),
       (5, 5, 3, 6, 2, 1393, 18),
       (5, 6, 3, 7, 2, 1393, 14),
       (5, 7, 3, 8, 2, 1393, 16),
       (5, 8, 3, 9, 2, 1393, 15),
       (5, 9, 3, 10, 2, 1393, 3),
       (5, 4, 3, 12, 2, 1393, 19),
       (5, 10, 3, 11, 2, 1393, 20),
       (7, 2, 1, 3, 2, 1393, 20),
       (7, 3, 3, 4, 2, 1393, 12),
       (7, 1, 2, 5, 2, 1393, 20),
       (7, 5, 3, 6, 2, 1393, 18),
       (7, 6, 3, 7, 2, 1393, 17),
       (7, 7, 3, 8, 2, 1393, 16),
       (7, 8, 3, 9, 2, 1393, 11),
       (7, 9, 3, 10, 2, 1393, 19),
       (7, 4, 3, 12, 2, 1393, 14),
       (7, 10, 3, 11, 2, 1393, 13),
       (4, 11, 1, 13, 2, 1393, 20),
       (4, 12, 1, 14, 2, 1393, 18);


SELECT student.name, major, student_groups.year, student_groups.term, title, professor.name, grade
FROM groups
JOIN courses ON groups.course_id = courses.id
JOIN professor ON groups.professor_id = professor.id
JOIN student_groups ON groups.group_id = student_groups.group_id
JOIN student ON student_groups.student_id = student.id;

-- FIRST PART
SELECT student.id, student.name, CAST(SUM(grade*credit) AS FLOAT)/SUM(credit)
FROM student
LEFT OUTER JOIN student_groups ON student.id = student_groups.student_id
LEFT OUTER JOIN courses ON student_groups.course_id = courses.id
GROUP BY student.name, student.id;

-- SECOND PART
SELECT *
FROM student
WHERE EXISTS(
    SELECT
    FROM student_groups
    JOIN courses ON student_groups.course_id = courses.id
    WHERE student_id = student.id AND courses.title = 'CE384' AND grade < 10
);

-- THIRD PART
SELECT id1, id2
FROM (
        SELECT student.id as id1, S.id as id2
        FROM student
        JOIN student AS S ON student.id < S.id
     ) AS X
WHERE (
    SELECT count(*)
    FROM student_groups AS SG1
    JOIN  student_groups AS SG2 ON SG1.student_id = X.id1 AND SG2.student_id = X.id2 AND SG1.course_id = SG2.course_id
          ) >= 10;

-- FORTH PART
SELECT *
FROM (
        SELECT student.id as id1, student.name AS name1, student.major AS major1, S.id as id2, S.name AS name2, S.major AS major2
        FROM student
        JOIN student AS S ON student.id < S.id
     ) AS X
WHERE (
    SELECT count(*)
    FROM student_groups AS SG1
    JOIN  student_groups AS SG2 ON SG1.student_id = X.id1 AND SG2.student_id = X.id2 AND SG1.course_id = SG2.course_id
          ) = 0 AND X.major1 = X.major2;

-- FIFTH PART
SELECT professor.name
FROM professor
WHERE (
    SELECT MIN(RESULT)
    FROM (
             SELECT AVG(grade) OVER (PARTITION BY course_id) AS RESULT, course_id, grade
             FROM student_groups
             WHERE student_groups.professor_id = professor.id
         ) AS X
    ) > 16;

-- SIXTH PART
SELECT professor.id, professor.name
FROM professor
WHERE (
    SELECT MIN(RESULT)
    FROM (
        SELECT COUNT(*) OVER (PARTITION BY term, "year") AS RESULT, groups.professor_id, term
        FROM groups
        WHERE professor_id = professor.id
    ) AS X
) < 2;

-- SEVENTH PART
SELECT student.id, student.name
FROM student
WHERE (
    SELECT COUNT(DISTINCT SG1.course_id)
    FROM student_groups AS SG1
    JOIN student AS S1 ON SG1.student_id = S1.id
    JOIN  student_groups AS SG2 ON S1.name = '777' AND SG2.student_id = student.id AND SG1.course_id = SG2.course_id
          ) =
                (
                    SELECT COUNT(DISTINCT SG3.course_id)
                    FROM student_groups AS SG3
                    JOIN student AS S2 ON SG3.student_id = S2.id
                    WHERE S2.name = '777'
                ) AND student.name <> '777';


-- EIGHTH PART
(   SELECT DISTINCT(course_id)
    FROM groups
    WHERE groups.year = 1393 AND groups.term = 2
    EXCEPT
    SELECT DISTINCT(course_id)
    FROM student_groups
    JOIN student ON student_groups.student_id = student.id
    WHERE student_groups.year = 1393 AND student_groups.term = 2 AND student.major <> 'SOFTWARE'
)
INTERSECT
SELECT DISTINCT(course_id)
FROM groups
WHERE EXISTS(
    SELECT
    FROM student_groups
    JOIN student ON student_groups.student_id = student.id
    WHERE student_groups.course_id = groups.course_id AND
          student.major = 'SOFTWARE'
          );

-- NINTH PART
SELECT X.course_id, "year", term, professor.name, AVG
FROM (
         SELECT course_id, group_id, AVG(grade) AS AVG, RANK() OVER (PARTITION BY course_id ORDER BY AVG(grade)) AS RANK
         FROM (
                  SELECT sg.course_id, sg.group_id, grade
                  FROM courses
                           JOIN groups ON courses.id = groups.course_id
                           JOIN student_groups sg on courses.id = sg.course_id
              ) AS X
         GROUP BY course_id, group_id
     ) AS X
JOIN groups ON X.group_id = groups.group_id
JOIN professor ON groups.professor_id = professor.id
WHERE RANK = 1
