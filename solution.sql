-- Which authors are represented in our store?
SELECT first_name, last_name FROM authors;
-- Which authors are also distinguished authors?
SELECT authors.first_name, authors.last_name, distinguished_authors.award FROM authors
	JOIN distinguished_authors on (authors.id = distinguished_authors.id);
-- Which authors are not distinguished authors?
SELECT authors.first_name, authors.last_name FROM authors
	WHERE NOT EXISTS (SELECT distinguished_authors.id FROM distinguished_authors
			WHERE authors.id = distinguished_authors.id);
-- How many authors are represented in our store?
SELECT COUNT(*) FROM authors;
-- Who are the favorite authors of the employee with the first name of Michael?
SELECT authors_and_titles FROM favorite_authors
	WHERE employee_id = (SELECT id FROM employees
				     WHERE first_name = 'Michael');
-- What are the titles of all the books that are in stock today?
SELECT books.title, editions.edition FROM books, editions
	WHERE books.id = editions.book_id
	AND editions.isbn IN (SELECT isbn from daily_inventory WHERE is_stocked = TRUE);
-- Insert one of your favorite books into the database. Hint: You’ll want to create data into at least 2 other tables to completely create this book.
INSERT INTO books (id, title, author_id, subject_id)
	VALUES(9021, 'On Basilisk Station', 8732, 15),
		(2190, 'March Up Country', 8732, 15);
INSERT INTO editions(isbn, book_id, edition, publisher_id, publication, type)
	VALUES('9780671577728', 9021, 1, 7382, '1993-10-10', 'p'),
		('9781439568231', 2190, 1, 7382, '2001-5-01', 'p');
INSERT INTO authors(id, last_name, first_name)
	VALUES(8732, 'Weber', 'David');
INSERT INTO daily_inventory(isbn, is_stocked)
	VALUES('9780671577728', TRUE),
		('9781439568231', TRUE);
-- What authors have books that are not in stock?
SELECT first_name, last_name FROM authors
  WHERE id IN (SELECT author_id FROM books
  		WHERE id IN (SELECT book_id FROM editions
  				WHERE isbn IN (SELECT isbn FROM stock WHERE stock = 0)));
-- What is the title of the book that has the most stock?
SELECT title FROM books
WHERE id = (SELECT book_id FROM editions
		WHERE isbn = (SELECT isbn FROM stock
				ORDER BY stock DESC
				LIMIT 1));
