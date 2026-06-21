INSERT IGNORE INTO products (code, name, category, price, description) VALUES 
('P001', 'Laptop', 'STANDARD', 999.99, 'High-performance laptop with 16GB RAM'),
('P002', 'Organic Apples', 'FOOD', 4.99, 'Fresh organic apples - 1kg'),
('P003', 'Diamond Ring', 'LUXURY', 2999.99, '24K diamond ring with sapphire'),
('P004', 'E-Book Reader', 'DIGITAL', 129.99, 'Digital e-book reader'),
('P005', 'Smartphone', 'STANDARD', 799.99, 'Latest 5G smartphone'),
('P006', 'Wine Collection', 'FOOD', 29.99, 'Premium wine bottle collection'),
('P007', 'Leather Handbag', 'LUXURY', 499.99, 'Designer leather handbag'),
('P008', 'Software License', 'DIGITAL', 199.99, 'Annual software license');

INSERT IGNORE INTO customers (email, name, type, country) VALUES
('john.doe@email.com', 'John Doe', 'REGULAR', 'ITALY'),
('jane.smith@email.com', 'Jane Smith', 'PREMIUM', 'FRANCE'),
('bob.johnson@email.com', 'Bob Johnson', 'VIP', 'USA'),
('alice.williams@email.com', 'Alice Williams', 'REGULAR', 'GERMANY'),
('charlie.brown@email.com', 'Charlie Brown', 'PREMIUM', 'UK');
