-- Retrieve the top 5 most-issued books with their issue count
SELECT 
    b.title AS Title,  
    COUNT(t.book_id) AS issue_count  FROM

    transactions AS t
JOIN 
    books b ON t.book_id = b.book_id
GROUP BY   b.title
ORDER BY 
    issue_count DESC
LIMIT 5;

--List books along with their authors that belong to the "Fantasy" genre, sorted by publication year in descending order.
SELECT 
    books.title AS book_title, 
    authors.name AS author_name, 
    books.publication_year
FROM books  
JOIN book_authors ba ON books.book_id = ba.book_id   
JOIN authors ON ba.author_id = authors.author_id
WHERE  books.genre = 'Fantasy';
order by books.publication_year desc;

-- Identify the top 3 customers who have borrowed the most books.
SELECT 
    c.name AS customer_name, 
    COUNT(t.customer_id) AS borrowed_count
FROM transactions t
JOIN customers c ON t.customer_id = c.c_id
GROUP BY c.name
ORDER BY borrowed_count DESC
LIMIT 3;

-- List all customers who have overdue books.
SELECT 
    c.name AS customer_name, 
    t.issue_date
FROM 
    transactions t
JOIN 
    customers c ON t.customer_id = c.c_id
WHERE 
    t.return_date IS NULL 
    AND t.issue_date < NOW() - INTERVAL '30 days';

-- Find authors who have written more than 3 books
SELECT 
    a.name AS author_name, 
    COUNT(ba.book_id) AS book_count
FROM 
    book_authors ba
JOIN 
    authors a ON ba.author_id = a.author_id
GROUP BY 
    a.name
HAVING 
    COUNT(ba.book_id) > 3;


--  Retrieve a list of authors who have books issued in the last 6 months
SELECT DISTINCT 
    a.name AS author_name
FROM transactions t   
JOIN books b ON t.book_id = b.book_id    
JOIN book_authors ba ON b.book_id = ba.book_id    
JOIN authors a ON ba.author_id = a.author_id
WHERE t.issue_date >= NOW() - INTERVAL '6 months';
    


-- Calculate the total number of books currently issued and the percentage of books issued compared to the total available.
SELECT 
    COUNT(t.book_id) AS currently_issued_books,
   ROUND(
  (COUNT(t.book_id)::DECIMAL / (SUM(b.copies_available) + COUNT(t.book_id))) * 100, 
  2
)
 AS percentage_issued
FROM books b    
LEFT JOIN transactions t ON b.book_id = t.book_id 
WHERE t.status = 'not returned';
    


-- Generate a monthly report of issued books for the past year
SELECT 
    TO_CHAR(t.issue_date, 'YYYY-MM') AS issue_month,
    COUNT(t.book_id) AS book_count,
    COUNT(DISTINCT t.c_id) AS unique_customer_count
FROM transactions t   
WHERE t.issue_date >= NOW() - INTERVAL '1 year'    
GROUP BY TO_CHAR(t.issue_date, 'YYYY-MM')    
ORDER BY issue_month;
    


--Add appropriate indexes to optimize queries.
CREATE INDEX idx_issue_date ON transactions(issue_date);
CREATE INDEX idx_status ON transactions(status);
CREATE INDEX idx_genre ON books(genre);
CREATE INDEX idx_book_authors ON book_authors(book_id, author_id);


-- 10:Analyze query execution plans for at least two queries using EXPLAIN and write your understanding from execution query plan in your words.
EXPLAIN SELECT 
    b.title AS Title,  
    COUNT(t.book_id) AS issue_count  FROM

    transactions AS t
JOIN 
    books b ON t.book_id = b.book_id
GROUP BY   b.title
ORDER BY 
    issue_count DESC
LIMIT 5;


EXPLAIN SELECT 
    books.title AS book_title, 
    authors.name AS author_name, 
    books.publication_year
FROM books  
JOIN book_authors ba ON books.book_id = ba.book_id   
JOIN authors ON ba.author_id = authors.author_id
WHERE  books.genre = 'Fantasy';
order by books.publication_year desc;

