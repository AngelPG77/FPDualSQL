
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
SELECT AVG(DATEDIFF(YEAR, A.ACTOR_BIRTH_DATE, A.ACTOR_DEAD_DATE)) AS "Edad Media"
FROM PUBLIC.ACTORS A
WHERE A.ACTOR_DEAD_DATE IS NOT NULL;

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
GROUP BY D.DIRECTOR_NAME 
ORDER BY D.DIRECTOR_NAME;

/*Indica cuál es el nombre y la duración mínima de las películas a las que se ha 
 * accedido en los últimos 2 años por los miembros del plataforma 
 *(La “fecha de ejecución” de esta consulta es el 25-01-2019)
 */

SELECT M.MOVIE_NAME AS "Película", M.MOVIE_DURATION AS "Duración"
FROM PUBLIC.MOVIES M
JOIN PUBLIC.USER_MOVIE_ACCESS UMA ON (M.MOVIE_ID = UMA.MOVIE_ID)
WHERE UMA.ACCESS_DATE BETWEEN DATE '2017-01-25' AND DATE '2019-01-25'
AND M.MOVIE_DURATION IN (SELECT MIN(M2.MOVIE_DURATION)
    					 FROM PUBLIC.MOVIES M2
    					 JOIN PUBLIC.USER_MOVIE_ACCESS UMA2 ON M2.MOVIE_ID = UMA2.MOVIE_ID
    					 WHERE UMA2.ACCESS_DATE BETWEEN DATE '2017-01-25' AND DATE '2019-01-25');

/*Indica el número de películas que hayan hecho los directores durante las décadas 
 * de los 60, 70 y 80 que contengan la palabra “The” en cualquier parte del título
 */
SELECT D.DIRECTOR_NAME AS Nombre, COUNT(M.MOVIE_ID) AS "Cantidad de películas"
FROM PUBLIC.MOVIES M
INNER JOIN PUBLIC.DIRECTORS D ON (M.DIRECTOR_ID = D.DIRECTOR_ID)
WHERE M.MOVIE_RELEASE_DATE BETWEEN DATE '1960-01-01' AND DATE '1989-12-31' 
AND UPPER(M.MOVIE_NAME) LIKE '%THE%'
GROUP BY D.DIRECTOR_ID;

-- DIFICULTAD: Difícil
-- 26 Lista nombre, nacionalidad y director de todas las películas
SELECT M.MOVIE_NAME AS "Película", N.NATIONALITY_NAME AS "Nacionalidad", D.DIRECTOR_NAME AS "Director"
FROM PUBLIC.MOVIES M
INNER JOIN PUBLIC.NATIONALITIES N ON (M.NATIONALITY_ID = N.NATIONALITY_ID)
INNER JOIN PUBLIC.DIRECTORS D ON (M.DIRECTOR_ID = D.DIRECTOR_ID);

-- 27 Muestra las películas con los actores que han participado en cada una de ellas
SELECT M.MOVIE_NAME AS "Película", GROUP_CONCAT(A.ACTOR_NAME) AS "Actores"
FROM PUBLIC.MOVIES M
INNER JOIN PUBLIC.MOVIES_ACTORS MA ON (M.MOVIE_ID = MA.MOVIE_ID)
INNER JOIN PUBLIC.ACTORS A ON (MA.ACTOR_ID = A.ACTOR_ID)
GROUP BY M.MOVIE_NAME;

-- 28 Indica cual es el nombre del director del que más películas se ha accedido
SELECT D.DIRECTOR_NAME AS "Director", COUNT(UMA.ACCESS_ID) AS "Accesos"
FROM PUBLIC.MOVIES M
INNER JOIN PUBLIC.DIRECTORS D ON (M.DIRECTOR_ID = D.DIRECTOR_ID)
INNER JOIN PUBLIC.USER_MOVIE_ACCESS UMA ON (UMA.MOVIE_ID = M.MOVIE_ID)
GROUP BY D.DIRECTOR_NAME
HAVING COUNT(UMA.ACCESS_ID) = (
    SELECT MAX("Accesos")
    FROM (
        SELECT COUNT(UMA2.ACCESS_ID) AS "Accesos"
        FROM PUBLIC.MOVIES M2
        INNER JOIN PUBLIC.DIRECTORS D2 ON (M2.DIRECTOR_ID = D2.DIRECTOR_ID)
        INNER JOIN PUBLIC.USER_MOVIE_ACCESS UMA2 ON (UMA2.MOVIE_ID = M2.MOVIE_ID)
        GROUP BY D2.DIRECTOR_NAME
    ) AS "Accesos"
);

-- 29 Indica cuantos premios han ganado cada uno de los estudios con las películas que han creado
SELECT S.STUDIO_NAME AS "Estudio", SUM(A.AWARD_WIN) AS "Premios Ganados"
FROM PUBLIC.MOVIES M
INNER JOIN PUBLIC.STUDIOS S ON (S.STUDIO_ID = M.STUDIO_ID)
INNER JOIN PUBLIC.AWARDS A ON (A.MOVIE_ID = M.MOVIE_ID)
GROUP BY S.STUDIO_NAME
ORDER BY "Premios Ganados" DESC;

/* 30 Indica el número de premios a los que estuvo nominado un actor, pero que no ha conseguido 
 * (Si una película está nominada a un premio, su actor también lo está)
 */
SELECT AC.ACTOR_NAME AS "Actor", SUM(A.AWARD_ALMOST_WIN) AS "Premios casi ganados"
FROM PUBLIC.MOVIES M
INNER JOIN PUBLIC.MOVIES_ACTORS MA ON (M.MOVIE_ID = MA.MOVIE_ID)
INNER JOIN PUBLIC.AWARDS A ON (A.MOVIE_ID = M.MOVIE_ID)
INNER JOIN PUBLIC.ACTORS AC  ON (AC.ACTOR_ID = MA.ACTOR_ID)
GROUP BY AC.ACTOR_NAME
ORDER BY SUM(A.AWARD_ALMOST_WIN) DESC;

-- 31 Indica cuantos actores y directores hicieron películas para los estudios no activos
SELECT COUNT(DISTINCT M.DIRECTOR_ID) AS "Numero de Directores",
	   COUNT(DISTINCT MA.ACTOR_ID) AS "Numero de Actores"
FROM PUBLIC.STUDIOS S
INNER JOIN PUBLIC.MOVIES M ON (M.STUDIO_ID = S.STUDIO_ID)
INNER JOIN PUBLIC.MOVIES_ACTORS MA ON (M.STUDIO_ID = S.STUDIO_ID)
WHERE S.STUDIO_ACTIVE = FALSE;

/* 32 Indica el nombre, ciudad, y teléfono de todos los miembros de la plataforma que hayan
 * accedido películas que hayan sido nominadas a más de 150 premios y ganaran menos de 50
 */
SELECT DISTINCT 
    U.USER_NAME, 
    U.USER_TOWN, 
    U.USER_PHONE
FROM USER_MOVIE_ACCESS UMA
INNER JOIN USERS U 
    ON UMA.USER_ID = U.USER_ID
WHERE UMA.MOVIE_ID IN (
    SELECT 
        MOVIE_ID
    FROM AWARDS
    WHERE 
        AWARD_NOMINATION > 150
        AND AWARD_WIN < 50
);

/*33 Comprueba si hay errores en la BD entre las películas y directores 
 * (un director muerto en el 76 no puede dirigir una película en el 88)
 */
SELECT D.DIRECTOR_NAME AS "Director", D.DIRECTOR_DEAD_DATE AS "Muerte del director", MAX(M.MOVIE_RELEASE_DATE) AS "Fecha de lanzamiento"
FROM PUBLIC.MOVIES M
INNER JOIN PUBLIC.DIRECTORS D ON (M.DIRECTOR_ID = D.DIRECTOR_ID)
WHERE D.DIRECTOR_DEAD_DATE IS NOT NULL 
AND D.DIRECTOR_DEAD_DATE < M.MOVIE_RELEASE_DATE
GROUP BY D.DIRECTOR_NAME, D.DIRECTOR_DEAD_DATE;

/* 34- Utilizando la información de la sentencia anterior, modifica la 
 * fecha de defunción a un año más tarde del estreno de la película 
 * (mediante sentencia SQL)
 */
UPDATE DIRECTORS 
SET DIRECTOR_DEAD_DATE = (
    SELECT 
        DATE(MAX(M.MOVIE_RELEASE_DATE), '+1 year') AS POST_MOVIE_LAUNCH_DATE
    FROM MOVIES M
    INNER JOIN DIRECTORS D 
        ON M.DIRECTOR_ID = D.DIRECTOR_ID
    WHERE 
        D.DIRECTOR_DEAD_DATE IS NOT NULL
        AND D.DIRECTOR_DEAD_DATE < M.MOVIE_RELEASE_DATE
        AND D.DIRECTOR_ID = DIRECTORS.DIRECTOR_ID
    GROUP BY 
        DIRECTOR_NAME, 
        DIRECTOR_DEAD_DATE
)
WHERE DIRECTOR_ID IN (
    SELECT 
        D.DIRECTOR_ID
    FROM MOVIES M
    INNER JOIN DIRECTORS D 
        ON M.DIRECTOR_ID = D.DIRECTOR_ID
    WHERE 
        D.DIRECTOR_DEAD_DATE IS NOT NULL
        AND D.DIRECTOR_DEAD_DATE < M.MOVIE_RELEASE_DATE
    GROUP BY 
        DIRECTOR_NAME, 
        DIRECTOR_DEAD_DATE
);


-- DIFICULTAD: Berseker
-- 35 Indica cuál es el género favorito de cada uno de los directores cuando dirigen una película

WITH GENRE_COUNTS AS (
    SELECT 
        D.DIRECTOR_ID, 
        D.DIRECTOR_NAME, 
        G.GENRE_ID, 
        G.GENRE_NAME, 
        COUNT(G.GENRE_NAME) AS "NUM_MOVIES"
    FROM PUBLIC.MOVIES M
    INNER JOIN PUBLIC.GENRES G ON (G.GENRE_ID = M.GENRE_ID)
    INNER JOIN PUBLIC.DIRECTORS D ON (D.DIRECTOR_ID = M.DIRECTOR_ID)
    GROUP BY D.DIRECTOR_ID, G.GENRE_ID
),
MAX_VALUES AS (
    SELECT 
        DIRECTOR_ID, 
        MAX(NUM_MOVIES) AS MAX_MOVIES
    FROM GENRE_COUNTS
    GROUP BY DIRECTOR_ID
)
SELECT GC.DIRECTOR_NAME, GROUP_CONCAT(GC.GENRE_NAME)
FROM GENRE_COUNTS GC
JOIN MAX_VALUES MV ON GC.DIRECTOR_ID = MV.DIRECTOR_ID 
AND GC.NUM_MOVIES = MV.MAX_MOVIES
GROUP BY GC.DIRECTOR_NAME;

-- 36 Indica cuál es la nacionalidad favorita de cada uno de los estudios en la producción de las películas

WITH TOT_NAT AS (
    SELECT 
        S.STUDIO_ID,
        S.STUDIO_NAME,
        N.NATIONALITY_ID,
        N.NATIONALITY_NAME,
        COUNT(N.NATIONALITY_ID) AS NUM_MOVIES
    FROM PUBLIC.MOVIES M
    INNER JOIN PUBLIC.NATIONALITIES N ON N.NATIONALITY_ID = M.NATIONALITY_ID
    INNER JOIN PUBLIC.STUDIOS S ON S.STUDIO_ID = M.STUDIO_ID
    GROUP BY S.STUDIO_ID, N.NATIONALITY_ID
    ORDER BY S.STUDIO_ID ASC, NUM_MOVIES DESC
),
MAX_NAT AS (
    SELECT 
        TN.STUDIO_ID,
        MAX(TN.NUM_MOVIES) AS MAX_MOVIES
    FROM TOT_NAT TN
    GROUP BY TN.STUDIO_ID
)
SELECT
    STUDIO_NAME,
    GROUP_CONCAT(NATIONALITY_NAME) AS NATIONALITY_NAME
FROM TOT_NAT TN
INNER JOIN MAX_NAT MN ON
    TN.STUDIO_ID = MN.STUDIO_ID AND 
    TN.NUM_MOVIES = MN.MAX_MOVIES
GROUP BY STUDIO_NAME;
 			  
						  
-- 37 Indica cuál fue la primera película a la que accedieron los miembros de la plataforma cuyos teléfonos tengan como último dígito el ID de alguna nacionalidad		

SELECT 
    USER_NAME, 
    MOVIE_NAME 
FROM (
    SELECT 
        a.NATIONALITY_ID, 
        a.USER_NAME, 
        a.USER_ID, 
        a.MOVIE_ID, 
        a.ACCESS_DATE 
    FROM (
        SELECT 
            NATIONALITY_ID, 
            USER_NAME, 
            MMR.USER_ID, 
            MOVIE_ID, 
            ACCESS_DATE 
        FROM NATIONALITIES N
        INNER JOIN (
            SELECT 
                USER_NAME, 
                USER_ID, 
                SUBSTR(USER_PHONE, LENGTH(USER_PHONE), 1) AS LAST_NUMBER 
            FROM USERS
        ) M 
            ON N.NATIONALITY_ID = M.LAST_NUMBER
        INNER JOIN USER_MOVIE_ACCESS MMR 
            ON MMR.USER_ID = M.USER_ID 
        ORDER BY MMR.USER_ID, MMR.ACCESS_DATE ASC
    ) a
    INNER JOIN (
        SELECT 
            USER_ID, 
            MIN(ACCESS_DATE) AS ACCESS_DATE 
        FROM (
            SELECT 
                NATIONALITY_ID, 
                USER_NAME, 
                MMR.USER_ID, 
                MOVIE_ID, 
                ACCESS_DATE 
            FROM NATIONALITIES N
            INNER JOIN (
                SELECT 
                    USER_NAME, 
                    USER_ID, 
                    SUBSTR(USER_PHONE, LENGTH(USER_PHONE), 1) AS LAST_NUMBER 
                FROM USERS
            ) M 
                ON N.NATIONALITY_ID = M.LAST_NUMBER
            INNER JOIN USER_MOVIE_ACCESS MMR 
                ON MMR.USER_ID = M.USER_ID 
            ORDER BY MMR.USER_ID, MMR.ACCESS_DATE ASC
        ) 
        GROUP BY USER_ID
    ) b 
        ON a.USER_ID = b.USER_ID 
        AND a.ACCESS_DATE = b.ACCESS_DATE
) MEM
INNER JOIN MOVIES 
    ON MEM.MOVIE_ID = MOVIES.MOVIE_ID;


