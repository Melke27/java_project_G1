package com.equbidir.controller;

import com.equbidir.dao.MemberDAO;
import com.equbidir.model.Member;
import com.equbidir.model.EqubMemberInfo;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;

@WebServlet("/member/equb-details")
public class EqubDetailsServlet extends HttpServlet {

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
            EqubMemberInfo equbInfo = memberDAO.getMemberEqubInfo(user.getMemberId());

            request.setAttribute("equbInfo", equbInfo);
            request.getRequestDispatcher("/views/member/equb-details.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error loading Equb details.");
            response.sendRedirect(request.getContextPath() + "/views/member/dashboard.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}