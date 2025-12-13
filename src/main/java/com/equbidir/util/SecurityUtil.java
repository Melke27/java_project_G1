package com.equbidir.util;

import org.mindrot.jbcrypt.BCrypt;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;

public class SecurityUtil {

    public static String hashPassword(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
    }

    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }

        // BCrypt hashes start with $2a$, $2b$, $2y$ etc.
        if (hashedPassword.startsWith("$2")) {
            try {
                return BCrypt.checkpw(plainPassword, hashedPassword);
            } catch (IllegalArgumentException e) {
                return false;
            }
        }

        // Legacy support: some seed data uses raw SHA-256 hex.
        if (hashedPassword.matches("(?i)[0-9a-f]{64}")) {
            return sha256Hex(plainPassword).equalsIgnoreCase(hashedPassword);
        }

        return false;
    }

    private static String sha256Hex(String input) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(input.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(hash.length * 2);
            for (byte b : hash) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            // Should never happen on a standard Java runtime.
            throw new RuntimeException(e);
        }
    }
}
