
-- DIFICULTAD: Muy Fácil
-- Devuelve todas las películas
SELECT * FROM MOVIES;

-- Devuelve todos los géneros 
SELECT * FROM GENRES;

-- Devuelve la lista de todos los estudios de grabación que estén activos 
SELECT * FROM STUDIOS
WHERE STUDIO_ACTIVE = TRUE;

-- Devuelve una lista de los 20 últimos miembros en anotarse a la plataforma
SELECT * FROM USERS
ORDER BY USER_JOIN_DATE DESC  
LIMIT 20;

-- DIFICULTAD: Fácil
-- Devuelve las 20 duraciones de películas más frecuentes, ordenados de mayor a menor
SELECT M.MOVIE_DURATION AS Duracion, COUNT(M.MOVIE_ID) AS Frecuencia FROM PUBLIC.MOVIES M
GROUP BY MOVIE_DURATION 
ORDER BY Frecuencia  DESC 
LIMIT 20;

-- Devuelve las películas del año 2000 en adelante que empiecen por la letra A.
SELECT MOVIE_NAME AS Película FROM PUBLIC.MOVIES M 
WHERE YEAR(M.MOVIE_RELEASE_DATE) > 1999 AND M.MOVIE_NAME LIKE 'A%';

-- Devuelve los actores nacidos un mes de Junio
SELECT ACTOR_NAME AS Nombre FROM PUBLIC.ACTORS A
WHERE MONTH(A.ACTOR_BIRTH_DATE) = 6;

-- Devuelve los actores nacidos cualquier mes que no sea Junio y que sigan vivos
SELECT A.ACTOR_NAME AS Nombre FROM PUBLIC.ACTORS A
WHERE MONTH(A.ACTOR_BIRTH_DATE) != 6 AND A.ACTOR_DEAD_DATE IS NULL;

--  Devuelve el nombre y la edad de todos los directores menores o iguales de 50 años que estén vivos
SELECT D.DIRECTOR_NAME AS Nombre, DATEDIFF(YEAR, D.DIRECTOR_BIRTH_DATE, CURDATE()) AS Edad 
FROM PUBLIC.DIRECTORS D
WHERE DATEDIFF(YEAR, D.DIRECTOR_BIRTH_DATE, CURDATE()) < 51 AND D.DIRECTOR_DEAD_DATE IS NULL;

-- Devuelve el nombre y la edad de todos los actores menores de 50 años que hayan fallecido
SELECT A.ACTOR_NAME AS Nombre, DATEDIFF(YEAR, A.ACTOR_BIRTH_DATE, A.ACTOR_DEAD_DATE) AS Edad
FROM PUBLIC.ACTORS A
WHERE DATEDIFF(YEAR, A.ACTOR_BIRTH_DATE, A.ACTOR_DEAD_DATE) < 50 AND A.ACTOR_DEAD_DATE IS NOT NULL;

-- Devuelve el nombre de todos los directores menores o iguales de 40 años que estén vivos
SELECT D.DIRECTOR_NAME AS Nombre
FROM PUBLIC.DIRECTORS D
WHERE DATEDIFF(YEAR, D.DIRECTOR_BIRTH_DATE, CURDATE()) <= 40 AND D.DIRECTOR_DEAD_DATE IS NULL;

-- Indica la edad media de los directores vivos
SELECT AVG(DATEDIFF(YEAR, D.DIRECTOR_BIRTH_DATE, CURDATE())) AS "Edad Media"
FROM PUBLIC.DIRECTORS D
WHERE D.DIRECTOR_DEAD_DATE IS NULL;

-- Indica la edad media de los actores que han fallecido
SELECT AVG(DATEDIFF(YEAR, D.DIRECTOR_BIRTH_DATE, CURDATE())) AS "Edad Media"
FROM PUBLIC.DIRECTORS D
WHERE D.DIRECTOR_DEAD_DATE IS NOT NULL;

-- DIFICULTAD: Media
-- Devuelve el nombre de todas las películas y el nombre del estudio que las ha realizado
SELECT M.MOVIE_NAME AS "Nombre Película", S.STUDIO_NAME "Nombre Estudio"
FROM PUBLIC.MOVIES M
INNER JOIN PUBLIC.STUDIOS S ON (M.STUDIO_ID = S.STUDIO_ID);

-- Devuelve los miembros que accedieron al menos una película entre el año 2010 y el 2015
SELECT DISTINCT U.USER_ID AS ID, U.USER_NAME AS Nombre
FROM PUBLIC.USERS U
INNER JOIN PUBLIC.USER_MOVIE_ACCESS UMA ON (U.USER_ID = UMA.USER_ID)
WHERE YEAR(UMA.ACCESS_DATE) >= 2010 AND YEAR(UMA.ACCESS_DATE) <= 2015;

-- Devuelve cuantas películas hay de cada país
SELECT N.NATIONALITY_NAME AS Nacionalidad, COUNT(M.MOVIE_ID) AS Cantidad
FROM PUBLIC.MOVIES M
INNER JOIN PUBLIC.NATIONALITIES N ON (M.NATIONALITY_ID = N.NATIONALITY_ID)
GROUP BY N.NATIONALITY_ID;

-- Devuelve todas las películas que hay de género documental
SELECT M.MOVIE_NAME AS Nombre
FROM PUBLIC.MOVIES M
WHERE M.GENRE_ID = (SELECT G.GENRE_ID
				    FROM PUBLIC.GENRES G
					WHERE G.GENRE_NAME = 'Documentary');

/* Devuelve todas las películas creadas por directores 
 * nacidos a partir de 1980 y que todavía están vivos*/
SELECT M.MOVIE_NAME AS "Nombre Película", D.DIRECTOR_NAME AS "Nombre Director"
FROM PUBLIC.MOVIES M
INNER JOIN PUBLIC.DIRECTORS D ON (M.DIRECTOR_ID = D.DIRECTOR_ID)
WHERE YEAR(D.DIRECTOR_BIRTH_DATE) >= 1980 AND D.DIRECTOR_DEAD_DATE IS NULL; 

/*Indica si hay alguna coincidencia de nacimiento de ciudad 
 *(y si las hay, indicarlas) entre los miembros de la plataforma y los directores
 */
SELECT U.USER_TOWN AS "Ciudad En Comun"
FROM PUBLIC.USERS U
WHERE U.USER_TOWN IN (SELECT D.DIRECTOR_BIRTH_PLACE FROM PUBLIC.DIRECTORS D);

/*Devuelve el nombre y el año de todas las películas que han sido 
 * producidas por un estudio que actualmente no esté activo
 */
SELECT M.MOVIE_NAME AS Nombre, YEAR(M.MOVIE_RELEASE_DATE) AS Fecha
FROM PUBLIC.MOVIES M
INNER JOIN PUBLIC.STUDIOS S ON (M.STUDIO_ID = S.STUDIO_ID)
WHERE S.STUDIO_ACTIVE = 0;

-- Devuelve una lista de las últimas 10 películas a las que se ha accedido
SELECT DISTINCT M.MOVIE_NAME AS Nombre, UMA.ACCESS_DATE AS Fecha 
FROM PUBLIC.MOVIES M
INNER JOIN PUBLIC.USER_MOVIE_ACCESS UMA ON (UMA.MOVIE_ID = M.MOVIE_ID)
ORDER BY UMA.ACCESS_DATE DESC
LIMIT 10;

-- Indica cuántas películas ha realizado cada director antes de cumplir 41 años
SELECT D.DIRECTOR_NAME AS Director, COUNT(M.MOVIE_ID) AS Cantidad
FROM PUBLIC.MOVIES M
INNER JOIN PUBLIC.DIRECTORS D ON (M.DIRECTOR_ID = D.DIRECTOR_ID)
WHERE DATEDIFF(YEAR, D.DIRECTOR_BIRTH_DATE, M.MOVIE_RELEASE_DATE) < 41
GROUP BY D.DIRECTOR_ID ;

-- Indica cuál es la media de duración de las películas de cada director
SELECT D.DIRECTOR_NAME AS Director, AVG(M.MOVIE_DURATION) "Duración Media" 
FROM PUBLIC.MOVIES M
INNER JOIN PUBLIC.DIRECTORS D ON (M.DIRECTOR_ID = D.DIRECTOR_ID)
GROUP BY D.DIRECTOR_ID;

/*Indica cuál es el nombre y la duración mínima de las películas a las que se ha 
 * accedido en los últimos 2 años por los miembros del plataforma 
 *(La “fecha de ejecución” de esta consulta es el 25-01-2019)
 */

SELECT M.MOVIE_NAME AS "Película", M.MOVIE_DURATION AS "Duración"
FROM PUBLIC.MOVIES M
JOIN PUBLIC.USER_MOVIE_ACCESS UMA ON (M.MOVIE_ID = UMA.MOVIE_ID)
WHERE UMA.ACCESS_DATE BETWEEN DATE '2017-01-25' AND DATE '2019-01-25'
AND M.MOVIE_DURATION = (SELECT MIN(M2.MOVIE_DURATION)
    					FROM PUBLIC.MOVIES M2
    					JOIN PUBLIC.USER_MOVIE_ACCESS UMA2 ON M2.MOVIE_ID = UMA2.MOVIE_ID
    					WHERE UMA2.ACCESS_DATE BETWEEN DATE '2017-01-25' AND DATE '2019-01-25'););

/*Indica el número de películas que hayan hecho los directores durante las décadas 
 * de los 60, 70 y 80 que contengan la palabra “The” en cualquier parte del título
 */

SELECT 
FROM PUBLIC.MOVIES M
INNER JOIN PUBLIC.DIRECTORS D ON (M.DIRECTOR_ID = D.DIRECTOR_ID)
WHERE M.MOVIE_RELEASE_DATE BETWEEN DATE '1960-01-01' AND DATE '1989-12-31'
GROUP BY ;

