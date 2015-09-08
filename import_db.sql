DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT,
  user_id INTEGER REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  question_id INTEGER REFERENCES questions(id),
  user_id INTEGER REFERENCES users(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER REFERENCES questions(id) NOT NULL,
  parent_id INTEGER REFERENCES replies(id),
  user_id INTEGER REFERENCES users(id),
  body TEXT
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER REFERENCES questions(id),
  user_id INTEGER REFERENCES users(id)
);

INSERT INTO
  users(id, fname, lname)
VALUES
  (1, 'Christopher', 'Huang'), (2, 'Joe', 'Cho');

INSERT INTO
  questions(id, title, body, user_id)
VALUES
  (1, "Test Question", "question has a body", 1);

INSERT INTO
  question_follows(id, question_id, user_id)
VALUES
  (1, 1, 2);

INSERT INTO
  replies(id, question_id, parent_id, user_id, body)
VALUES
  (1, 1, NULL, 2, "reply to question"), (2,1,1,1,"answer back to first reply");

INSERT INTO
  question_likes(id, question_id, user_id)
VALUES
  (1,1,2);
