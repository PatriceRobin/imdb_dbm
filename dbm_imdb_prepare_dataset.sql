use imdb;

##alter table names to use the same style guid as before
#genres
ALTER TABLE imdb.genres
	CHANGE COLUMN `genre` `name` INT(11) NOT NULL AUTO_INCREMENT , RENAME TO  `imdb`.`genres`;

#director_genres
ALTER TABLE `imdb`.`directors_genres` 
	CHANGE COLUMN `id_genre` `genre_id` INT(11) NULL DEFAULT NULL ;


#### FK directors_genres & directors
#error 1452 - genres has director_id that do not exist in our directors table
#check details
select director_id from imdb.directors_genres
	WHERE director_id NOT IN (SELECT id FROM imdb.directors);

#look at the two tables
DESCRIBE imdb.directors;
DESCRIBE imdb.directors_genres;

#drop the director_genres without a corresponding director_id
DELETE FROM imdb.directors_genres
	WHERE director_id NOT IN (SELECT id FROM imdb.directors);

#add foreign keys to existing tables
ALTER TABLE imdb.directors_genres
	ADD FOREIGN key (director_id) REFERENCES imdb.directors(id);

#check foreign key in imdb.directors_genres
SHOW CREATE TABLE imdb.directors_genres;

#### FK directors_genres & genres
#check check whether keys match (no missing)
Select distinct genre_id from imdb.directors_genres
WHERE genre_id NOT IN (SELECT id FROM imdb.genres);

# add genre_id as a foreign key into imdb.directors_genres
ALTER TABLE imdb.directors_genres
	ADD FOREIGN key (genre_id) REFERENCES imdb.genres(id);


#### FK movies_directors & directors
#check check whether ids match between movie_directors and directors
#1921 distinct ids are missing in the directors table
SELECT count(distinct director_id) from imdb.movies_directors
WHERE director_id NOT IN (SELECT id FROM imdb.directors);

#drop the entries in movie_directors without a corresponding id in the directors table
DELETE FROM imdb.movies_directors
WHERE director_id NOT IN (SELECT id FROM imdb.directors);

# add genre_id as a foreign key into imdb.directors_genres
ALTER TABLE imdb.movies_directors
	ADD FOREIGN key (director_id) REFERENCES imdb.directors(id);
    
    
#### FK movies_directors & movies
#check check whether ids match between movie_directors and movies
#4211 distinct movie_ids are missing in the movies table
SELECT count(distinct movie_id) from imdb.movies_directors
WHERE movie_id NOT IN (SELECT id FROM imdb.movies);

#drop the entries in movie_directors without a corresponding id in the directors table
DELETE FROM imdb.movies_directors
WHERE movie_id NOT IN (SELECT id FROM imdb.movies);

# add genre_id as a foreign key into imdb.directors_genres
ALTER TABLE imdb.movies_directors
	ADD FOREIGN key (movie_id) REFERENCES imdb.movies(id);
    
    
#### FK roles & movies
#check check whether ids match between movie_directors and movies
#0 missing ids
SELECT count(distinct movie_id) from imdb.roles
WHERE movie_id NOT IN (SELECT id FROM imdb.movies);

# add genre_id as a foreign key into imdb.directors_genres
ALTER TABLE imdb.roles
	ADD FOREIGN key (movie_id) REFERENCES imdb.movies(id);

#check foreign key in imdb.roles
SHOW CREATE TABLE imdb.roles;