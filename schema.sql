CREATE DATABASE IF NOT EXISTS bookstore_db;
USE bookstore_db;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'CUSTOMER',
    phone VARCHAR(20),
    address TEXT
);

CREATE TABLE IF NOT EXISTS books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    description TEXT
);

CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(30) DEFAULT 'PENDING',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);

-- Default Admin and Sample Data
INSERT INTO users (name, email, password, role, phone, address) 
VALUES ('Admin', 'admin@bookstore.com', 'admin123', 'ADMIN', '9999999999', 'Headquarters')
ON DUPLICATE KEY UPDATE id=id;

INSERT INTO books (title, author, category, price, stock, description) VALUES
('Clean Code', 'Robert C. Martin', 'Technology', 599.00, 15, 'A Handbook of Agile Software Craftsmanship'),
('Effective Java', 'Joshua Bloch', 'Technology', 799.00, 20, 'Best practices for the Java platform'),
('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 249.00, 30, 'Classic novel of the Jazz Age'),
('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 349.00, 25, 'Pulitzer Prize-winning masterpiece'),
('Sapiens', 'Yuval Noah Harari', 'History', 499.00, 10, 'A Brief History of Humankind');
