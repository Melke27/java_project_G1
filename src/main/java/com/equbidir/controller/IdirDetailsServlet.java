package com.equbidir.controller;

import com.equbidir.dao.MemberDAO;
import com.equbidir.model.Member;
import com.equbidir.model.IdirMemberInfo;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;

@WebServlet("/member/idir-details")
public class IdirDetailsServlet extends HttpServlet {

    private final MemberDAO memberDAO = new MemberDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Member user = (Member) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        try {
            IdirMemberInfo idirInfo = memberDAO.getMemberIdirInfo(user.getMemberId());

            request.setAttribute("idirInfo", idirInfo);
            request.getRequestDispatcher("/views/member/idir-details.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error loading Idir details.");
            response.sendRedirect(request.getContextPath() + "/views/member/dashboard.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}