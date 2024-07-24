package com.shashi.service.impl;

import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.shashi.beans.UserBean;
import com.shashi.constants.IUserConstants;
import com.shashi.service.UserService;
import com.shashi.utility.DBUtil;
import com.shashi.utility.MailMessage;

public class UserServiceImpl implements UserService {


	    @Override
	    public String registerUser(String userName, Long mobileNo, String emailId, String address, int pinCode, String password) {
	        UserBean user = new UserBean(userName, mobileNo, emailId, address, pinCode, password);
	        return registerUser(user);
	    }

	    @Override
	    public String registerUser(UserBean user) {
	        String status = "User Registration Failed!";
	        boolean isRegtd = isRegistered(user.getEmail());

	        if (isRegtd) {
	            status = "Email Id Already Registered!";
	            return status;
	        }

	        Connection conn = DBUtil.provideConnection();
	        PreparedStatement ps = null;

	        try {
	            ps = conn.prepareStatement("INSERT INTO " + IUserConstants.TABLE_USER + " VALUES (?, ?, ?, ?, ?, ?)");
	            ps.setString(1, user.getEmail());
	            ps.setString(2, user.getName());
	            ps.setLong(3, user.getMobile());
	            ps.setString(4, user.getAddress());
	            ps.setInt(5, user.getPinCode());
	            ps.setString(6, user.getPassword());

	            int k = ps.executeUpdate();
	            if (k > 0) {
	                status = "User Registered Successfully!";
	                MailMessage.registrationSuccess(user.getEmail(), user.getName().split(" ")[0]);
	            }
	        } catch (SQLException e) {
	            status = "Error: " + e.getMessage();
	            e.printStackTrace();
	        } finally {
	            DBUtil.closeConnection(ps);
	            DBUtil.closeConnection(conn);
	        }

	        return status;
	    }

	    @Override
	    public boolean isRegistered(String emailId) {
	        boolean flag = false;
	        Connection con = DBUtil.provideConnection();
	        PreparedStatement ps = null;
	        ResultSet rs = null;

	        try {
	            ps = con.prepareStatement("SELECT * FROM user WHERE email = ?");
	            ps.setString(1, emailId);
	            rs = ps.executeQuery();
	            if (rs.next()) {
	                flag = true;
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            DBUtil.closeConnection(rs);
	            DBUtil.closeConnection(ps);
	            DBUtil.closeConnection(con);
	        }

	        return flag;
	    }

	    @Override
	    public String isValidCredential(String emailId, String password) {
	        String status = "Login Denied! Incorrect Username or Password";
	        Connection con = DBUtil.provideConnection();
	        PreparedStatement ps = null;
	        ResultSet rs = null;

	        try {
	            ps = con.prepareStatement("SELECT * FROM user WHERE email = ? AND password = ?");
	            ps.setString(1, emailId);
	            ps.setString(2, password);
	            rs = ps.executeQuery();
	            if (rs.next()) {
	                status = "valid";
	            }
	        } catch (SQLException e) {
	            status = "Error: " + e.getMessage();
	            e.printStackTrace();
	        } finally {
	            DBUtil.closeConnection(rs);
	            DBUtil.closeConnection(ps);
	            DBUtil.closeConnection(con);
	        }

	        return status;
	    }

	    @Override
	    public UserBean getUserDetails(String emailId, String password) {
	        UserBean user = null;
	        Connection con = DBUtil.provideConnection();
	        PreparedStatement ps = null;
	        ResultSet rs = null;

	        try {
	            ps = con.prepareStatement("SELECT * FROM user WHERE email = ? AND password = ?");
	            ps.setString(1, emailId);
	            ps.setString(2, password);
	            rs = ps.executeQuery();
	            if (rs.next()) {
	                user = new UserBean();
	                user.setName(rs.getString("name"));
	                user.setMobile(rs.getLong("mobile"));
	                user.setEmail(rs.getString("email"));
	                user.setAddress(rs.getString("address"));
	                user.setPinCode(rs.getInt("pincode"));
	                user.setPassword(rs.getString("password"));
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            DBUtil.closeConnection(rs);
	            DBUtil.closeConnection(ps);
	            DBUtil.closeConnection(con);
	        }

	        return user;
	    }

	    @Override
	    public String getFName(String emailId) {
	        String fname = "";
	        Connection con = DBUtil.provideConnection();
	        PreparedStatement ps = null;
	        ResultSet rs = null;

	        try {
	            ps = con.prepareStatement("SELECT name FROM user WHERE email = ?");
	            ps.setString(1, emailId);
	            rs = ps.executeQuery();
	            if (rs.next()) {
	                fname = rs.getString(1);
	                fname = fname.split(" ")[0];
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            DBUtil.closeConnection(rs);
	            DBUtil.closeConnection(ps);
	            DBUtil.closeConnection(con);
	        }

	        return fname;
	    }

	    @Override
	    public String getUserAddr(String userId) {
	        String userAddr = "";
	        Connection con = DBUtil.provideConnection();
	        PreparedStatement ps = null;
	        ResultSet rs = null;

	        try {
	            ps = con.prepareStatement("SELECT address FROM user WHERE email = ?");
	            ps.setString(1, userId);
	            rs = ps.executeQuery();
	            if (rs.next()) {
	                userAddr = rs.getString(1);
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            DBUtil.closeConnection(rs);
	            DBUtil.closeConnection(ps);
	            DBUtil.closeConnection(con);
	        }

	        return userAddr;
	    }

	    public boolean updateUserDetails(String userName, String password, UserBean user) {
	        boolean isUpdated = false;
	        Connection conn = DBUtil.provideConnection();
	        PreparedStatement ps = null;

	        try {
	            String updateQuery = "UPDATE user SET name = ?, mobile = ?, address = ?, pincode = ? WHERE email = ? AND password = ?";
	            ps = conn.prepareStatement(updateQuery);

	            ps.setString(1, user.getName());
	            ps.setLong(2, user.getMobile());
	            ps.setString(3, user.getAddress());
	            ps.setInt(4, user.getPinCode());
	            ps.setString(5, user.getEmail());
	            ps.setString(6, password);

	            int rowsAffected = ps.executeUpdate();
	            if (rowsAffected > 0) {
	                isUpdated = true;
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            DBUtil.closeConnection(ps);
	            DBUtil.closeConnection(conn);
	        }

	        return isUpdated;
	    }
	}