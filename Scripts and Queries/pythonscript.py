import random
import psycopg2
from faker import Faker

# Initialize Faker instance
fake = Faker()

# Number of records to generate
num_authors = 10
num_books = 15
num_customers = 20
num_transactions = 30

# Database connection details
db_params = {
    "host": "localhost",  # Change this to your database host
    "dbname": "lms_db",   # The name of your database
    "user": "postgres",  # Your PostgreSQL username
    "password": "Yashik@1234"  # Your PostgreSQL password
}

# Create a connection to PostgreSQL
conn = psycopg2.connect(**db_params)
cursor = conn.cursor()

# Define maximum lengths for string columns
max_phone_length = 15
max_email_length = 50  # Adjusted to allow for longer email addresses
max_name_length = 100  # Adjusted for longer names
max_title_length = 255  # Adjusted for book titles

# Create Authors table data
authors = []
for author_id in range(1, num_authors + 1):
    name = fake.name()[:max_name_length]  # Trim name if it exceeds max length
    years_of_experience = random.randint(5, 30)
    authors.append((author_id, name, years_of_experience))

# Create Books table data
books = []
for book_id in range(1, num_books + 1):
    title = fake.sentence(nb_words=3)[:max_title_length]  # Trim title to max length
    genre = random.choice(['Fantasy', 'Mystery', 'Science Fiction', 'Romance', 'Thriller'])
    price = round(random.uniform(5.0, 50.0), 2)
    copies_available = random.randint(1, 100)
    publication_year = random.randint(2000, 2023)
    books.append((book_id, title, genre, price, copies_available, publication_year))

# Create Customers table data
customers = []
for c_id in range(1, num_customers + 1):
    name = fake.name()[:max_name_length]  # Trim name if it exceeds max length
    email = fake.email()[:max_email_length]  # Trim email if it exceeds max length
    phone = fake.phone_number()[:max_phone_length]  # Trim phone if it exceeds max length
    dob = fake.date_of_birth(minimum_age=18, maximum_age=80)
    customers.append((c_id, name, email, phone, dob))

# Create Book Transactions table data
transactions = []
for transaction_id in range(1, num_transactions + 1):
    book_id = random.choice(range(1, num_books + 1))
    c_id = random.choice(range(1, num_customers + 1))
    issue_date = fake.date_this_decade()
    status = random.choice(['Issued', 'Returned'])
    # Ensure return_date is None if status is 'Issued', or set a valid return date if status is 'Returned'
    if status == 'Issued':
        return_date = None
    else:  # If status is 'Returned', assign a random return date
        return_date = fake.date_this_decade()
    transactions.append((transaction_id, book_id, c_id, issue_date, status, return_date))

# Create BookAuthors table data (relationship between books and authors)
book_authors = []
for book_id in range(1, num_books + 1):
    author_id = random.choice(range(1, num_authors + 1))
    book_authors.append((book_id, author_id))

# Insert data into Authors table
author_insert_query = """
    INSERT INTO Authors (author_id, name, years_of_experience)
    VALUES (%s, %s, %s)
"""
cursor.executemany(author_insert_query, authors)

# Insert data into Books table
book_insert_query = """
    INSERT INTO Books (book_id, title, genre, price, copies_available, publication_year)
    VALUES (%s, %s, %s, %s, %s, %s)
"""
cursor.executemany(book_insert_query, books)

# Insert data into Customers table
customer_insert_query = """
    INSERT INTO Customers (c_id, name, email, phone, dob)
    VALUES (%s, %s, %s, %s, %s)
"""
cursor.executemany(customer_insert_query, customers)

# Insert data into Book Transactions table
transaction_insert_query = """
    INSERT INTO transactions (transaction_id, book_id, c_id, issue_date, status, return_date)
    VALUES (%s, %s, %s, %s, %s, %s)
"""
cursor.executemany(transaction_insert_query, transactions)

# Insert data into BookAuthors table (relationship between books and authors)
book_author_insert_query = """
    INSERT INTO book_authors (book_id, author_id)
    VALUES (%s, %s)
"""
cursor.executemany(book_author_insert_query, book_authors)

# Commit changes to the database
conn.commit()

# Close the cursor and connection
cursor.close()
conn.close()

print("Data inserted successfully!")
