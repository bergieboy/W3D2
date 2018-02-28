DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  associated_author INTEGER NOT NULL,

  FOREIGN KEY (associated_author) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id)

);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL

);

INSERT INTO
  users (fname, lname)
VALUES
  ('Lady', 'GAGA'),
  ('David', 'Bowie'),
  ('Carly', 'Jepson');

INSERT INTO
  questions (title, body, associated_author)
VALUES
  ('SQL', 'what is sql?', 1),
  ('Movies', 'Have you seen Labrynth?', 2),
  ('Boyssss...', 'Call Me, maybe?', 3);

INSERT INTO
  replies (question_id, parent_id, user_id, body)
VALUES
  (1, NULL, 3, 'It''s pronounced SEQUEL.'),
  (3, NULL, 2, 'No.');

INSERT INTO
  question_likes (question_id, user_id)
VALUES
  (1,3),
  (3,2);

INSERT INTO
  question_follows (question_id, user_id)
VALUES
  (1,2),
  (2,1),
  (3,1),
  (1,1),
  (2,3);
