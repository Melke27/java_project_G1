package com.equbidir.controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Registration endpoint is now disabled for public users.
 * Only admins can create members from the admin panel.
 */
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("error",
                "Self registration is disabled. Please contact the administrator to create your account.");
        request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("error",
                "Self registration is disabled. Please contact the administrator to create your account.");
        request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
    }
}