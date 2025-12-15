package com.equbidir.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Simple language switcher for English / Amharic.
 * Usage: /lang?lang=en or /lang?lang=am
 * Stores the chosen language code in HTTP session under "lang".
 */
@WebServlet("/lang")
public class LanguageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String lang = request.getParameter("lang");
        if (!"am".equalsIgnoreCase(lang)) {
            lang = "en"; // default
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("lang", lang.toLowerCase());

        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}


