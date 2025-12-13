-- MySQL schema for Equb/Idir Management System
-- Create DB (optional)
CREATE DATABASE IF NOT EXISTS equb_idir_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE equb_idir_db;

-- MEMBERS
CREATE TABLE IF NOT EXISTS members (
  member_id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(150) NOT NULL,
  phone VARCHAR(30) NOT NULL UNIQUE,
  address VARCHAR(255) NULL,
  password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(20) NOT NULL DEFAULT 'member',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- EQUB GROUPS
CREATE TABLE IF NOT EXISTS equb_groups (
  equb_id INT AUTO_INCREMENT PRIMARY KEY,
  equb_name VARCHAR(150) NOT NULL UNIQUE,
  amount DOUBLE NOT NULL,
  frequency VARCHAR(20) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- EQUB MEMBERSHIP + PAYMENT STATUS + ROTATION POSITION
CREATE TABLE IF NOT EXISTS equb_members (
  id INT AUTO_INCREMENT PRIMARY KEY,
  member_id INT NOT NULL,
  equb_id INT NOT NULL,
  payment_status VARCHAR(20) NOT NULL DEFAULT 'unpaid',
  rotation_position INT NULL,
  UNIQUE KEY uq_equb_member (member_id, equb_id),
  CONSTRAINT fk_equb_members_member FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
  CONSTRAINT fk_equb_members_equb FOREIGN KEY (equb_id) REFERENCES equb_groups(equb_id) ON DELETE CASCADE
);

-- IDIR GROUPS
CREATE TABLE IF NOT EXISTS idir_groups (
  idir_id INT AUTO_INCREMENT PRIMARY KEY,
  idir_name VARCHAR(150) NOT NULL UNIQUE,
  monthly_payment DOUBLE NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- (Needed for admin member assignment + payment tracking)
CREATE TABLE IF NOT EXISTS idir_members (
  id INT AUTO_INCREMENT PRIMARY KEY,
  member_id INT NOT NULL,
  idir_id INT NOT NULL,
  payment_status VARCHAR(20) NOT NULL DEFAULT 'unpaid',
  UNIQUE KEY uq_idir_member (member_id, idir_id),
  CONSTRAINT fk_idir_members_member FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
  CONSTRAINT fk_idir_members_idir FOREIGN KEY (idir_id) REFERENCES idir_groups(idir_id) ON DELETE CASCADE
);

-- IDIR EXPENSES
CREATE TABLE IF NOT EXISTS idir_expenses (
  expense_id INT AUTO_INCREMENT PRIMARY KEY,
  idir_id INT NOT NULL,
  amount DOUBLE NOT NULL,
  description TEXT NULL,
  expense_date DATE NOT NULL,
  CONSTRAINT fk_expenses_idir FOREIGN KEY (idir_id) REFERENCES idir_groups(idir_id) ON DELETE CASCADE
);

-- Helpful indexes
CREATE INDEX idx_equb_members_equb ON equb_members(equb_id);
CREATE INDEX idx_equb_members_status ON equb_members(payment_status);
CREATE INDEX idx_idir_members_idir ON idir_members(idir_id);
CREATE INDEX idx_idir_members_status ON idir_members(payment_status);
CREATE INDEX idx_idir_expenses_idir ON idir_expenses(idir_id);

