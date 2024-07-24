package com.shashi.srv;

import java.io.IOException;
import java.io.InputStream;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.shashi.service.impl.ProductServiceImpl;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.shashi.service.UserService;
import com.shashi.service.impl.UserServiceImpl;
import com.shashi.beans.UserBean;

@WebServlet("/updateProfile")
public class UpdateProfileSrv extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userName = (String) request.getSession().getAttribute("username");
        String password = (String) request.getSession().getAttribute("password");

        if (userName == null || password == null) {
            response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
            return;
        }

        UserService dao = new UserServiceImpl();

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String pincode = request.getParameter("pincode");

        UserBean user = new UserBean(name, Long.parseLong(phone), email, address, Integer.parseInt(pincode), password);

        boolean isUpdated = dao.updateUserDetails(userName, password, user);

        if (isUpdated) {
            response.sendRedirect("userProfile.jsp?message=Profile updated successfully");
        } else {
            response.sendRedirect("editProfile.jsp?message=Update failed. Please try again.");
        }
    }
}
