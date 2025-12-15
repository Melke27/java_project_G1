package com.equbidir.controller;

import com.equbidir.dao.MemberDAO;
import com.equbidir.model.Member;
import com.equbidir.model.Contribution;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/member/contribution-history")
public class ContributionHistoryServlet extends HttpServlet {

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
            List<Contribution> contributions = memberDAO.getMemberContributionHistory(user.getMemberId());

            request.setAttribute("contributions", contributions);
            request.getRequestDispatcher("/views/member/contribution-history.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error loading contribution history.");
            response.sendRedirect(request.getContextPath() + "/views/member/dashboard.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}