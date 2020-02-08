CREATE DATABASE star_wars;
CREATE TABLE users(
nameid INTEGER NOT NULL AUTO_INCREMENT,
email VARCHAR(100) NOT NULL,
PRIMARY KEY (nameid));
CREATE TABLE movies(
movieid INTEGER NOT NULL AUTO_INCREMENT,
movieName VARCHAR(100) NOT NULL,
PRIMARY KEY (movieid));
CREATE TABLE rankings(
rankid INTEGER NOT NULL AUTO_INCREMENT,
nameid INTEGER NOT NULL,
movieid INTEGER NOT NULL,
ranking INTEGER,
PRIMARY KEY (rankid),
FOREIGN KEY (nameid) REFERENCES users (nameid) ON UPDATE CASCADE,
FOREIGN KEY (movieid) REFERENCES movies (movieid) ON UPDATE CASCADE);
INSERT INTO users (email)
VALUES
('aradcliffe@energytechhs.org'),
('mpicciolo@energytechhs.org'),
('cferrari@energytechhs.org'),
('agarcia@energytechhs.org'),
('lauraemoste@gmail.com');
INSERT INTO movies (movieNAME)
VALUES
('Episode I: The Phantom Menace'),
('Episode II: Attack of the Clones'),
('Episode III: Revenge of the Sith'),
('Episode IV: A New Hope'),
('Episode V: The Empire Strikes Back'),
('Episode VI: Return of the Jedi'),
('Episode VII: The Force Awakens'),
('Episode VIII: The Last Jedi'),
('Episode IX: The Rise of Skywalker');
INSERT INTO ranking (nameid, movieid, ranking)
VALUES
(1,1,8),
(1,2,9),
(1,3,7),
(1,4,3),
(1,5,2),
(1,6,1),
(1,7,5),
(1,8,4),
(1,9,null),
(2,1,9),
(2,2,8),
(2,3,7),
(2,4,3),
(2,5,1),
(2,6,2),
(2,7,6),
(2,8,5),
(2,9,4),
(3,1,9),
(3,2,8),
(3,3,7),
(3,4,4),
(3,5,2),
(3,6,3),
(3,7,5),
(3,8,1),
(3,9,6),
(4,1,3),
(4,2,9),
(4,3,6),
(4,4,1),
(4,5,2),
(4,6,4),
(4,7,5),
(4,8,7),
(4,9,8),
(5,1,7),
(5,2,8),
(5,3,9),
(5,4,1),
(5,5,2),
(5,6,3),
(5,7,4),
(5,8,5),
(5,9,null);