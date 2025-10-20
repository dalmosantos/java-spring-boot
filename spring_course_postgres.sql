-- PostgreSQL Database: springcourse
-- Converted from MySQL to PostgreSQL

-- Drop tables if they exist (in correct order due to foreign keys)
DROP TABLE IF EXISTS student_course CASCADE;
DROP TABLE IF EXISTS "user" CASCADE;
DROP TABLE IF EXISTS student CASCADE;
DROP TABLE IF EXISTS course CASCADE;

-- --------------------------------------------------------
-- Table structure for course
-- --------------------------------------------------------

CREATE TABLE course (
  courseid BIGSERIAL PRIMARY KEY,
  coursename VARCHAR(255) DEFAULT NULL
);

-- Insert data into course
INSERT INTO course (courseid, coursename) VALUES
(1, 'Programming Logic'),
(2, 'Programming'),
(3, 'Data Structure'),
(4, 'Database'),
(5, 'Software Engineering'),
(6, 'People Management');

-- Update sequence for course
SELECT setval('course_courseid_seq', (SELECT MAX(courseid) FROM course));

-- --------------------------------------------------------
-- Table structure for student
-- --------------------------------------------------------

CREATE TABLE student (
  id BIGSERIAL PRIMARY KEY,
  department VARCHAR(255) DEFAULT NULL,
  email VARCHAR(255) DEFAULT NULL,
  firstname VARCHAR(255) DEFAULT NULL,
  lastname VARCHAR(255) DEFAULT NULL
);

-- Insert data into student
INSERT INTO student (id, department, email, firstname, lastname) VALUES
(1, 'TI', 'john@mayer.com', 'John', 'Mayer'),
(2, 'RH', 'mary@jane.com', 'Mary', 'Jane'),
(3, 'TI', 'stephany@alba.com', 'Stephany', 'Alba');

-- Update sequence for student
SELECT setval('student_id_seq', (SELECT MAX(id) FROM student));

-- --------------------------------------------------------
-- Table structure for student_course
-- --------------------------------------------------------

CREATE TABLE student_course (
  id BIGINT NOT NULL,
  courseid BIGINT NOT NULL,
  PRIMARY KEY (id, courseid),
  CONSTRAINT fk_student_course_student FOREIGN KEY (id) 
    REFERENCES student (id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_student_course_course FOREIGN KEY (courseid) 
    REFERENCES course (courseid) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create indexes for foreign keys
CREATE INDEX idx_student_course_courseid ON student_course(courseid);
CREATE INDEX idx_student_course_id ON student_course(id);

-- Insert data into student_course
INSERT INTO student_course (id, courseid) VALUES
(1, 1),
(2, 1),
(3, 1),
(1, 2),
(1, 3),
(2, 3),
(3, 6);

-- --------------------------------------------------------
-- Table structure for user
-- --------------------------------------------------------

CREATE TABLE "user" (
  id BIGSERIAL PRIMARY KEY,
  password VARCHAR(255) NOT NULL,
  role VARCHAR(255) NOT NULL,
  username VARCHAR(255) NOT NULL UNIQUE
);

-- Create unique index on username
CREATE UNIQUE INDEX uk_user_username ON "user"(username);

-- Insert data into user
-- Password for 'user': user
-- Password for 'admin': admin
INSERT INTO "user" (id, password, role, username) VALUES
(1, '$2a$06$3jYRJrg0ghaaypjZ/.g4SethoeA51ph3UD4kZi9oPkeMTpjKU5uo6', 'USER', 'user'),
(2, '$2a$08$bCCcGjB03eulCWt3CY0AZew2rVzXFyouUolL5dkL/pBgFkUH9O4J2', 'ADMIN', 'admin');

-- Update sequence for user
SELECT setval('user_id_seq', (SELECT MAX(id) FROM "user"));
