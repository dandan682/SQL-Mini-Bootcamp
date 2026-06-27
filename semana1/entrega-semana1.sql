DROP DATABASE IF EXISTS streamflix;
-- Crea la base de datos streamflix
CREATE DATABASE streamflix;
USE streamflix;
SELECT DATABASE();
-- Crea la tabla peliculas
CREATE TABLE peliculas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    titulo_original VARCHAR(200),
    director VARCHAR(100) NOT NULL,
    año INT NOT NULL,
    duracion_minutos INT,
    genero VARCHAR(50) NOT NULL,
    calificacion DECIMAL(3, 1),
    sinopsis TEXT,
    idioma_original VARCHAR(50) DEFAULT 'Inglés',
    destacada BOOLEAN DEFAULT FALSE,
    fecha_agregada DATE DEFAULT (CURRENT_DATE)
);
DESCRIBE peliculas;
SHOW TABLES;
-- Select simple
SELECT COUNT(*) FROM peliculas;
-- Insertar 15 películas
INSERT INTO peliculas
    (titulo, titulo_original, director, año, duracion_minutos, genero, calificacion, sinopsis, idioma_original, destacada)
VALUES
    ('El Padrino', 'The Godfather', 'Francis Ford Coppola', 1972, 175, 'Drama', 9.2,
     'La historia de la familia Corleone en el mundo de la mafia italiana.', 'Inglés', TRUE),

    ('Pulp Fiction', 'Pulp Fiction', 'Quentin Tarantino', 1994, 154, 'Crimen', 8.9,
     'Historias entrelazadas de criminales en Los Ángeles.', 'Inglés', TRUE),

    ('El Caballero de la Noche', 'The Dark Knight', 'Christopher Nolan', 2008, 152, 'Acción', 9.0,
     'Batman enfrenta al caótico Joker en Gotham City.', 'Inglés', TRUE),

    ('Inception', 'Inception', 'Christopher Nolan', 2010, 148, 'Ciencia Ficción', 8.8,
     'Un ladrón que roba secretos del subconsciente durante el sueño.', 'Inglés', TRUE),

    ('Forrest Gump', 'Forrest Gump', 'Robert Zemeckis', 1994, 142, 'Drama', 8.8,
     'La vida extraordinaria de un hombre simple que presencia eventos históricos.', 'Inglés', TRUE),

    ('Matrix', 'The Matrix', 'Lana y Lilly Wachowski', 1999, 136, 'Ciencia Ficción', 8.7,
     'Un programador descubre que la realidad es una simulación.', 'Inglés', FALSE),

    ('El Señor de los Anillos: La Comunidad del Anillo',
     'The Lord of the Rings: The Fellowship of the Ring',
     'Peter Jackson', 2001, 178, 'Fantasía', 8.8,
     'Frodo inicia su viaje para destruir el Anillo Único.', 'Inglés', TRUE),

    ('Gladiador', 'Gladiator', 'Ridley Scott', 2000, 155, 'Acción', 8.5,
     'Un general romano busca venganza contra el emperador corrupto.', 'Inglés', FALSE),

    ('El Laberinto del Fauno', 'El Laberinto del Fauno', 'Guillermo del Toro', 2006, 118, 'Fantasía', 8.2,
     'Una niña descubre un mundo mágico durante la Guerra Civil Española.', 'Español', FALSE),

    ('Interestelar', 'Interstellar', 'Christopher Nolan', 2014, 169, 'Ciencia Ficción', 8.6,
     'Exploradores viajan por un agujero de gusano buscando un nuevo hogar.', 'Inglés', FALSE),

    ('Parásitos', 'Gisaengchung', 'Bong Joon-ho', 2019, 132, 'Thriller', 8.6,
     'Una familia pobre infiltra la casa de una familia rica.', 'Coreano', TRUE),

    ('Tiempos Violentos', 'Reservoir Dogs', 'Quentin Tarantino', 1992, 99, 'Crimen', 8.3,
     'Un atraco sale mal y los criminales sospechan de un traidor.', 'Inglés', FALSE),

    ('El Club de la Pelea', 'Fight Club', 'David Fincher', 1999, 139, 'Drama', 8.8,
     'Un hombre insomne forma un club clandestino de pelea.', 'Inglés', FALSE),

    ('La Lista de Schindler', 'Schindler''s List', 'Steven Spielberg', 1993, 195, 'Drama', 9.0,
     'La historia real de un empresario que salvó a más de mil judíos.', 'Inglés', TRUE),

    ('Toy Story', 'Toy Story', 'John Lasseter', 1995, 81, 'Animación', 8.3,
     'Los juguetes de Andy cobran vida cuando él no está.', 'Inglés', FALSE);
-- Numero de filas en peliculas
SELECT COUNT(*) AS total FROM peliculas;
-- Lista las peliculas con los id y las fechas asignadas por mysql
SELECT id, titulo, año, fecha_agregada FROM peliculas;
-- **********************
-- Queries del negocio:
-- **********************
-- Listado simple — solo título, director y año
SELECT titulo, director, año
FROM peliculas;    
-- Películas destacadas 
SELECT titulo, calificacion, destacada
FROM peliculas
WHERE destacada = TRUE;
-- Películas de Ciencia Ficción
SELECT titulo, genero, año
FROM peliculas
WHERE genero = 'Ciencia Ficción';    
-- Películas con calificación mayor a 8.5 
SELECT titulo, calificacion
FROM peliculas
WHERE calificacion > 8.5
ORDER BY calificacion DESC;
-- Películas estrenadas entre 1990 y 2000 (inclusivo)
SELECT titulo, año
FROM peliculas
WHERE año BETWEEN 1990 AND 2000
ORDER BY año;     
-- Películas de Drama o Thriller
SELECT titulo, genero
FROM peliculas
WHERE genero IN ('Drama', 'Thriller');
-- Películas cuyo título empieza con "El"
SELECT titulo
FROM peliculas
WHERE titulo LIKE 'El%';
-- Directores cuyo nombre contiene "Nolan"
SELECT DISTINCT director
FROM peliculas
WHERE director LIKE '%Nolan%';
-- Top 5 películas mejor calificadas
SELECT titulo, calificacion
FROM peliculas
ORDER BY calificacion DESC
LIMIT 5;
-- Las 3 películas más antiguas
SELECT titulo, año
FROM peliculas
ORDER BY año ASC
LIMIT 3;
-- Películas ordenadas por duración (más largas primero)
SELECT titulo, duracion_minutos
FROM peliculas
WHERE duracion_minutos IS NOT NULL
ORDER BY duracion_minutos DESC;
-- Películas de Acción o Ciencia Ficción, con calificación mayor a 8.0, 
-- estrenadas después del año 2000, ordenadas por calificación descendente
SELECT titulo, genero, calificacion, año
FROM peliculas
WHERE genero IN ('Acción', 'Ciencia Ficción')
  AND calificacion > 8.0
  AND año > 2000
ORDER BY calificacion DESC;
-- Listado de géneros únicos disponibles
SELECT DISTINCT genero
FROM peliculas
ORDER BY genero;
-- Películas destacadas, con duración mayor a 140 minutos, calificación mayor a 8.5,
-- ordenadas por calificación.
SELECT titulo, duracion_minutos, calificacion
FROM peliculas
WHERE destacada = TRUE
  AND duracion_minutos > 140
  AND calificacion > 8.5
ORDER BY calificacion DESC;

-- DECISIONES DE DISEÑO
-- ======================================
--
-- 1. ¿Por qué DECIMAL(3,1) para rating en vez de FLOAT?
--    El FLOAT es mejor para datos científicos o de ingeniería que usualmente son valores muy grandes o muy pequeños 
--    y FLOAT se prefiere para evitar error por redondeo. DECIMAL es para numeros de dígitos exactos con precisión
--    absoluta.
--
-- 2. ¿Por qué VARCHAR(200) para title en vez de TEXT?
--    VARCHAR es más eficiente de manejar en caso de búsquedas, ordenar o filtrar y para cuando el límite es predecible. 
--    TEXT es más para contenido libre, sin un límite predecible.
--
-- 3. ¿Qué ventaja tiene AUTO_INCREMENT en id?
--    El motor de la base de datos genera los números de forma secuencial, no hay que calcular manualmente y se garantiza
--    que no se dupliquen y para 
--
-- 4. Si tuvieras que agregar rental_price, ¿qué tipo usarías?
--    DECIMAL porque es para valores de precisión absoluta como dinero, calificaciones, porcentajes fijos.
--
-- 5. ¿Qué fue lo que más te sorprendió esta semana?
--    Por ejemplo saber que existe AUTO_INCREMENT que es como un contador automático y que puede evitar conflictos de concurrencia.
--    O que hay que elegir el tipo de dato correcto.

     
