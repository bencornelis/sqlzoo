/*
This tutorial introduces the notion of a join. The database consists of three tables movie , actor and casting.
*/

/*
1. List the films where the yr is 1962 [Show id, title]
*/
SELECT id, title
  FROM movie
 WHERE yr = 1962

/*
2. Give year of 'Citizen Kane'.
*/
SELECT yr
  FROM movie
 WHERE title = 'Citizen Kane'

/*
3. List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title).
Order results by year.
*/
SELECT id, title, yr
  FROM movie
 WHERE title LIKE '%Star Trek%'
 ORDER BY yr

/*
4. What id number does the actor 'Glenn Close' have?
*/
SELECT id
  FROM actor
 WHERE name = 'Glenn Close'

/*
5. What is the id of the film 'Casablanca'
*/
SELECT id
  FROM movie
 WHERE title = 'Casablanca'

/*
6. Obtain the cast list for 'Casablanca'. Use movieid=11768
*/
SELECT name
  FROM casting JOIN actor ON actorid = id
 WHERE movieid = 11768

/*
7. Obtain the cast list for the film 'Alien'
*/
 SELECT actor.name
   FROM actor JOIN casting ON actor.id = casting.actorid
              JOIN movie   ON casting.movieid = movie.id
  WHERE movie.title = 'Alien'
 ORDER BY casting.ord ASC

/*
8. List the films in which 'Harrison Ford' has appeared
*/
SELECT title
  FROM movie JOIN casting ON movie.id = casting.movieid
             JOIN actor   ON casting.actorid = actor.id
 WHERE actor.name = 'Harrison Ford'

/*
9. List the films where 'Harrison Ford' has appeared - but not in the starring role.
*/
SELECT title
  FROM movie JOIN casting ON movie.id=movieid
             JOIN actor   ON actorid = actor.id
 WHERE actor.name = 'Harrison Ford'
   AND ord != 1

/*
10. List the films together with the leading star for all 1962 films.
*/
SELECT title, actor.name AS leading_star
  FROM movie JOIN casting ON movie.id = movieid
             JOIN actor   ON actorid = actor.id
 WHERE ord = 1
   AND yr = 1962

/*
Harder Questions
*/

/*
11. Which were the busiest years for 'John Travolta',
show the year and the number of movies he made each year for any year in which he made more than 2 movies.
*/
SELECT yr, COUNT(title)
  FROM movie JOIN casting ON movie.id = movieid
             JOIN actor   ON actorid = actor.id
 WHERE name='John Travolta'
GROUP BY yr
HAVING COUNT(title) > 2

/*
12. List the film title and the leading actor for all of the films 'Julie Andrews' played in.
*/
SELECT DISTINCT movie.title AS film_title, y.name AS leading_actor
   FROM
    (casting x JOIN actor y ON x.actorid = y.id)
   JOIN
    (casting z JOIN actor w ON z.actorid = w.id)
   ON x.movieid = z.movieid
   JOIN movie ON x.movieid = movie.id
 WHERE x.ord = 1
   AND (y.name = 'Julie Andrews' OR w.name = 'Julie Andrews')

/*
13. Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles.
*/
SELECT name
  FROM movie JOIN casting ON movie.id = movieid
             JOIN actor   ON actorid = actor.id
  WHERE ord = 1
  GROUP BY name
  HAVING COUNT(name) >= 30
  ORDER BY name ASC

/*
14. List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
*/
SELECT title, COUNT(actorid)
  FROM movie JOIN casting ON movie.id = movieid
                         JOIN actor     ON actorid = actor.id
 WHERE yr = 1978
 GROUP BY title
 ORDER BY COUNT(actorid) DESC, title

/*
15. List all the people who have worked with 'Art Garfunkel'.
*/
SELECT z.name
  FROM casting x JOIN casting y ON x.movieid = y.movieid
                JOIN actor z   ON x.actorid = z.id
                JOIN actor w   ON y.actorid = w.id
 WHERE w.name = 'Art Garfunkel'
   AND z.name != 'Art Garfunkel'
