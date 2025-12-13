USE equb_idir_db;

-- Default admin user
-- password: admin123 (SHA-256 without salt for demo; you can change later)
INSERT INTO members (full_name, phone, address, password_hash, role)
VALUES ('System Admin', '0900000000', 'Admin Office', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'admin')
ON DUPLICATE KEY UPDATE phone = phone;

-- Sample groups
INSERT INTO equb_groups (equb_name, amount, frequency)
VALUES ('Equb A', 500.0, 'monthly')
ON DUPLICATE KEY UPDATE equb_name = equb_name;

INSERT INTO idir_groups (idir_name, monthly_payment)
VALUES ('Idir A', 200.0)
ON DUPLICATE KEY UPDATE idir_name = idir_name;

