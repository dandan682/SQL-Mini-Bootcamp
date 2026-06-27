-- ======================================
-- ENTREGA WEEK 3 — BIBLIOTECH biblioteca
-- Nombre: [Bernardo Castro]  |  Fecha: [22-Jun-26]
-- ======================================

DROP DATABASE IF EXISTS biblioteca;
CREATE DATABASE biblioteca;
USE biblioteca;
SELECT DATABASE();

-- Crea tablas principales e inserta datos	
CREATE TABLE categories (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(50) UNIQUE NOT NULL,
description TEXT
);

INSERT INTO categories (name, description) 
VALUES
    ('Fiction',    'Novels and fiction stories'),
    ('Science',    'Scientific and technical books'),
    ('History',    'History books and biographies'),
    ('Children',   'Literature for children'),
    ('Technology', 'Programming, Development, AI');

CREATE TABLE authors (
id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(150) NOT NULL,
country VARCHAR(50),
birth_date DATE,
biography TEXT
);

INSERT INTO authors (name, country, birth_date)
VALUES 
	('Gabriel García Márquez', 'Colombia',       '1927-03-06'),   -- 1
    ('Isabel Allende',         'Chile',          '1942-08-02'),   -- 2
    ('Stephen Hawking',        'United Kingdom', '1942-01-08'),   -- 3
    ('J.K. Rowling',           'United Kingdom', '1965-07-31'),   -- 4
    ('Yuval Noah Harari',      'Israel',         '1976-02-24'),   -- 5
    ('Roald Dahl',             'United Kingdom', '1916-09-13'),   -- 6
    ('Andrew S. Tanenbaum',    'United States',  '1944-03-16'),   -- 7
    ('Ian Goodfellow',         'United States',  '1985-01-01'),   -- 8
    ('Yoshua Bengio',          'Canada',         '1964-03-05'),   -- 9
    ('Eric Matthes',           'United States',  '1970-01-01'),   -- 10
    ('Joshua Bloch',           'United States',  '1961-08-28');   -- 11
    
CREATE TABLE books (
	id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    title VARCHAR(250) NOT NULL,
    category_id INT,
    publication_year INT,
    price DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_books_category
		FOREIGN KEY (category_id) REFERENCES categories(id)
        ON DELETE SET NULL,
        
	CONSTRAINT chk_year CHECK (publication_year between 1450 and 2100),
    CONSTRAINT chk_price CHECK (price >= 0),
    CONSTRAINT chk_stock CHECK (stock >= 0)
);

INSERT INTO books (isbn, title, category_id, publication_year, price, stock) 
VALUES
    -- Fiction (cat 1)
    ('978-0307474728', 'One Hundred Years of Solitude',            1, 1967, 18.99, 5),
    ('978-0142437247', 'The House of the Spirits',                 1, 1982, 16.50, 3),
    ('978-0439708180', 'Harry Potter and the Philosopher''s Stone', 1, 1997, 22.99, 8),

    -- Science (cat 2)
    ('978-0553380163', 'A Brief History of Time',                  2, 1988, 15.99, 4),
    ('978-0062316097', 'Sapiens: A Brief History of Humankind',    2, 2011, 24.99, 6),
    ('978-0062464310', 'Homo Deus',                                2, 2015, 26.50, 4),

    -- History (cat 3)
    ('978-0062315007', '21 Lessons for the 21st Century',          3, 2018, 20.99, 5),

    -- Children (cat 4)
    ('978-0142410318', 'Matilda',                                  4, 1988, 12.99, 10),
    ('978-0142410387', 'Charlie and the Chocolate Factory',        4, 1964, 14.50, 7),
    ('978-0141365534', 'The BFG',                                  4, 1982, 13.99, 6),

    -- Technology (cat 5)
    ('978-0132126953', 'Modern Operating Systems',                 5, 2007, 89.99, 3),
    ('978-0262035613', 'Deep Learning',                            5, 2016, 75.00, 2),
    ('978-0135957059', 'Computer Networks',                        5, 2010, 95.50, 2),
    ('978-1593279288', 'Python Crash Course',                      5, 2019, 39.99, 8),
    ('978-0134685991', 'Effective Java',                           5, 2017, 54.99, 4);

CREATE TABLE users (
	id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(150) UNIQUE NOT NULL,
    name VARCHAR(150) NOT NULL,
    phone VARCHAR(20),
    membership_type ENUM('basic', 'premium', 'vip') DEFAULT 'basic',
    is_active BOOLEAN DEFAULT TRUE,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (email, name, phone, membership_type) VALUES
    ('alice.garcia@email.com',     'Alice Garcia',     '555-0001', 'premium'),   -- 1
    ('charles.lopez@email.com',    'Charles Lopez',    '555-0002', 'basic'),     -- 2
    ('mary.torres@email.com',      'Mary Torres',      '555-0003', 'vip'),       -- 3
    ('john.perez@email.com',       'John Perez',        NULL,      'basic'),     -- 4
    ('lucy.martinez@email.com',    'Lucy Martinez',    '555-0005', 'premium'),   -- 5
    ('sophie.rodriguez@email.com', 'Sophie Rodriguez', '555-0006', 'basic'),     -- 6
    ('david.fernandez@email.com',  'David Fernandez',   NULL,      'basic');     -- 7
    
CREATE TABLE loans (
	id INT auto_increment PRIMARY KEY,
	user_id INT NOT NULL,
	book_id INT NOT NULL,
	loan_date DATE NOT NULL DEFAULT (CURRENT_DATE),
	due_date DATE NOT NULL,
	return_date DATE,
	fine DECIMAL(10,2) DEFAULT 0.00,
	notes TEXT,

CONSTRAINT fk_loans_user
	FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE restrict,
    
CONSTRAINT fk_loans_book
	FOREIGN KEY (book_id) REFERENCES books(id)
    ON DELETE restrict,
    
CONSTRAINT chk_fine CHECK (fine >= 0),
CONSTRAINT chk_return_date CHECK (
	return_date IS NULL OR
    return_date >= loan_date
)
);

-- Verificar fase 2
SELECT
(SELECT count(*) FROM categories) AS categories,
(SELECT count(*) FROM authors) AS authors,
(SELECT count(*) FROM books) AS books,
(SELECT count(*) FROM users) AS users;

-- Fase 3

-- La tabla de unión N:M 
CREATE TABLE book_authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    author_order INT DEFAULT 1,   -- 1 = autor principal, 2 = co-autor, etc.

    PRIMARY KEY (book_id, author_id),

    CONSTRAINT fk_ba_book
        FOREIGN KEY (book_id) REFERENCES books(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_ba_author
        FOREIGN KEY (author_id) REFERENCES authors(id)
        ON DELETE CASCADE
);

INSERT INTO book_authors (book_id, author_id, author_order) 
VALUES
    (1,  1, 1),   -- One Hundred Years → García Márquez
    (2,  2, 1),   -- The House of the Spirits → Allende
    (3,  4, 1),   -- Harry Potter → Rowling
    (4,  3, 1),   -- A Brief History → Hawking
    (5,  5, 1),   -- Sapiens → Harari
    (6,  5, 1),   -- Homo Deus → Harari
    (7,  5, 1),   -- 21 Lessons → Harari
    (8,  6, 1),   -- Matilda → Dahl
    (9,  6, 1),   -- Charlie → Dahl
    (10, 6, 1),   -- The BFG → Dahl
    (11, 7, 1),   -- Modern Operating Systems → Tanenbaum
    (12, 8, 1),   -- Deep Learning → Goodfellow (autor principal)
    (12, 9, 2),   -- Deep Learning → Bengio (co-autor)   ← ¡un libro, dos autores!
    (13, 7, 1),   -- Computer Networks → Tanenbaum
    (14, 10, 1),  -- Python Crash Course → Matthes
    (15, 11, 1);  -- Effective Java → Bloch
    
-- Verificación N:M
-- libros co-escritos (más de un autor) debe salir solo Deep Learning
SELECT b.title, count(*) AS num_authors
FROM book_authors ba
JOIN books b ON ba.book_id = b.id
GROUP BY ba.book_id, b.title
HAVING count(*) > 1;

-- Fase 4
INSERT INTO loans
    (user_id, book_id, loan_date, due_date, return_date, fine)
VALUES
    -- Devueltos (históricos, multa ya guardada — tarifa: $2.50 por día de retraso)
    (1, 1, '2024-01-01', '2024-01-15', '2024-01-14',  0.00),    -- Alice, devolvió a tiempo
    (2, 3, '2024-01-05', '2024-01-19', '2024-01-25', 15.00),    -- Charles, 6 días tarde × 2.50
    (3, 5, '2024-01-08', '2024-01-22', '2024-01-20',  0.00),    -- Mary, devolvió antes
    (1, 8, '2024-01-10', '2024-01-24', '2024-01-23',  0.00),    -- Alice, a tiempo
    (4, 9, '2024-01-12', '2024-01-26', '2024-02-05', 25.00),    -- John, 10 días tarde × 2.50

    -- Activos (return_date = NULL; fechas relativas a HOY)
    (1,  4, DATE_SUB(CURDATE(), INTERVAL 20 DAY), DATE_SUB(CURDATE(), INTERVAL  6 DAY), NULL, 0.00),  -- Alice, 6 días vencido
    (5,  5, DATE_SUB(CURDATE(), INTERVAL 12 DAY), DATE_ADD(CURDATE(), INTERVAL  2 DAY), NULL, 0.00),  -- Lucy, al corriente
    (6, 10, DATE_SUB(CURDATE(), INTERVAL  9 DAY), DATE_ADD(CURDATE(), INTERVAL  5 DAY), NULL, 0.00),  -- Sophie, al corriente
    (7, 14, DATE_SUB(CURDATE(), INTERVAL  6 DAY), DATE_ADD(CURDATE(), INTERVAL  8 DAY), NULL, 0.00),  -- David, al corriente
    (2, 11, DATE_SUB(CURDATE(), INTERVAL  4 DAY), DATE_ADD(CURDATE(), INTERVAL 10 DAY), NULL, 0.00);  -- Charles, al corriente

-- Fase 5
-- Libros de tecnología con su autor
SELECT
    b.title,
    a.name AS author,
    b.price,
    b.stock
FROM books b
JOIN categories   c  ON b.category_id = c.id
JOIN book_authors ba ON b.id = ba.book_id
JOIN authors      a  ON ba.author_id = a.id
WHERE c.name = 'Technology'
ORDER BY b.title, ba.author_order;

-- Usuarios con préstamos activos
SELECT
    u.name AS user,
    b.title AS book,
    l.due_date,
    DATEDIFF(CURDATE(), l.due_date) AS days_late
FROM users u
JOIN loans l ON u.id = l.user_id
JOIN books b ON l.book_id = b.id
WHERE l.return_date IS NULL
ORDER BY l.due_date;

-- TOP 5 libros más prestados
SELECT
    b.title,
    a.name AS author,
    COUNT(l.id) AS times_borrowed
FROM books b
LEFT JOIN loans        l  ON b.id = l.book_id
LEFT JOIN book_authors ba ON b.id = ba.book_id AND ba.author_order = 1
LEFT JOIN authors      a  ON ba.author_id = a.id
GROUP BY b.id, b.title, a.name
ORDER BY times_borrowed DESC, b.title
LIMIT 5;

-- Total de multas por usuario
SELECT
    u.name AS user,
    COUNT(l.id) AS num_loans,
    SUM(l.fine) AS total_fines
FROM users u
LEFT JOIN loans l ON u.id = l.user_id
GROUP BY u.id, u.name
HAVING total_fines > 0
ORDER BY total_fines DESC;

-- Fase 6
-- Préstamo y devolución como transacciones
START TRANSACTION;

SELECT id, title, stock FROM books WHERE id = 12 AND stock > 0;
-- Reducir el stock (a lápiz)
UPDATE books SET stock = stock - 1 WHERE id = 12;
-- Registrar el préstamo (devolución esperada en 14 días)
INSERT INTO loans
    (user_id, book_id, loan_date, due_date)
VALUES
    (3, 12, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY));
-- Verificar las dos mitades antes de cerrar
SELECT id, title, stock FROM books WHERE id = 12;
SELECT * FROM loans WHERE id = LAST_INSERT_ID();

COMMIT;

-- Procesar una devolución con multa (Alice devuelve el libro 4)
-- Abrir la transacción y calcular la multa
START TRANSACTION;

SET @days_late = (
    SELECT DATEDIFF(CURDATE(), due_date)
    FROM loans WHERE id = 6
);
SET @fine = GREATEST(0, @days_late * 2.50);
-- Marcar el préstamo como devuelto y aplicar la multa
UPDATE loans
SET return_date = CURDATE(),
    fine = @fine
WHERE id = 6;
-- Devolver el ejemplar al stock
UPDATE books
SET stock = stock + 1
WHERE id = (SELECT book_id FROM loans WHERE id = 6);
-- Verificar
SELECT id, return_date, fine FROM loans WHERE id = 6;

COMMIT;

-- Fase 7
--  Probar la integridad referencial sin destruir tus datos
START TRANSACTION;

-- Antes: el libro 7 tiene category_id = 3
SELECT id, title, category_id FROM books WHERE id = 7;

-- Borrar la categoría (id es PK → Safe Updates no se queja)
DELETE FROM categories WHERE id = 3;

-- Después: el libro NO desaparece, solo queda con category_id = NULL
SELECT id, title, category_id FROM books WHERE id = 7;

ROLLBACK;  -- deshacemos: la categoría "History" y el libro vuelven intactos

-- Intentar borrar a Alice (id=1), que tiene préstamos → RESTRICT lo impide
-- VALIDADO -- ✔
-- DELETE FROM users WHERE id = 1; 
-- VALIDADO -- ✔

START TRANSACTION;

SET SQL_SAFE_UPDATES = 0;            -- user_id NO es PK/UNIQUE → Safe Updates lo bloquearía (Error 1175)
DELETE FROM loans WHERE user_id = 1;
SET SQL_SAFE_UPDATES = 1;            -- vuelve a poner el seguro de inmediato

DELETE FROM users WHERE id = 1;      -- ahora SÍ funciona (Alice ya no tiene hijos)

ROLLBACK;  -- deshacemos todo: Alice y sus préstamos vuelven intactos

SELECT name FROM users WHERE id = 1;  -- Alice sigue ahí 

-- Rechazando valores inválidos
-- VALIDADO -- ✔
-- INSERT INTO books (isbn, title, publication_year, price)
-- VALUES ('978-0000000001', 'Medieval manuscript', 1200, 29.99);
-- VALIDADO -- ✔

-- Precio negativo
-- VALIDADO -- ✔
-- INSERT INTO books (isbn, title, publication_year, price)
-- VALUES ('978-0000000002', 'Free book', 2020, -10.00);
-- VALIDADO -- ✔︎

SELECT COUNT(*) FROM books;

-- BONUS

-- Tabla de reseñas
CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    rating INT,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_rating CHECK (rating BETWEEN 1 AND 5),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    UNIQUE (user_id, book_id)   -- un usuario reseña un libro una sola vez
);
INSERT INTO reviews
    (user_id, book_id, rating, comment)
VALUES
    (1, 1, 4, 'Calificación: Muy bueno'),    
    (2, 3, 5, 'Evaluación: Excelente'),    
    (3, 5, 3, 'Opinión: Regular'),  
    (4, 9, 1, 'Muy ñoño: Malo');
SELECT * FROM reviews;

-- Trigger de auditoría de precios
CREATE TABLE price_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    old_price DECIMAL(10,2),
    new_price DECIMAL(10,2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$
CREATE TRIGGER tr_price_audit
AFTER UPDATE ON books
FOR EACH ROW
BEGIN
    IF OLD.price <> NEW.price THEN
        INSERT INTO price_audit (book_id, old_price, new_price)
        VALUES (NEW.id, OLD.price, NEW.price);
    END IF;
END$$
DELIMITER ;

UPDATE books SET price = 18.55 WHERE isbn = '978-0307474728'; 
UPDATE books SET price = 17.50 WHERE isbn = '978-0142437247'; 
UPDATE books SET price = 25.99 WHERE isbn = '978-0439708180';

SELECT * FROM price_audit;
