<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page
    import="com.shashi.service.impl.*, com.shashi.service.*, com.shashi.beans.*, java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Edit Profile</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
    href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script
    src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
    src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<link rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body style="background-color: #E6F9E6;">

    <%
    /* Checking the user credentials */
    String userName = (String) session.getAttribute("username");
    String password = (String) session.getAttribute("password");

    if (userName == null || password == null) {
        response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
    }

    UserService dao = new UserServiceImpl();
    UserBean user = dao.getUserDetails(userName, password);
    %>

    <jsp:include page="header.jsp" />

    <div class="container bg-secondary">
        <div class="row">
            <div class="col">
                <nav aria-label="breadcrumb" class="bg-light rounded-3 p-3 mb-4">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="index.jsp">Home</a></li>
                        <li class="breadcrumb-item"><a href="UserProfile.jsp">User Profile</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Edit Profile</li>
                    </ol>
                </nav>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-8">
                <div class="card mb-4">
                    <div class="card-body">
                        <form action="updateProfile" method="post">
                            <div class="row">
                                <div class="col-sm-3">
                                    <p class="mb-0">Full Name</p>
                                </div>
                                <div class="col-sm-9">
                                    <input type="text" name="name" class="form-control" value="<%=user.getName()%>" required>
                                </div>
                            </div>
                            <hr>
                            <div class="row">
                                <div class="col-sm-3">
                                    <p class="mb-0">Email</p>
                                </div>
                                <div class="col-sm-9">
                                    <input type="email" name="email" class="form-control" value="<%=user.getEmail()%>" required>
                                </div>
                            </div>
                            <hr>
                            <div class="row">
                                <div class="col-sm-3">
                                    <p class="mb-0">Phone</p>
                                </div>
                                <div class="col-sm-9">
                                    <input type="text" name="phone" class="form-control" value="<%=user.getMobile()%>" required>
                                </div>
                            </div>
                            <hr>
                            <div class="row">
                                <div class="col-sm-3">
                                    <p class="mb-0">Address</p>
                                </div>
                                <div class="col-sm-9">
                                    <input type="text" name="address" class="form-control" value="<%=user.getAddress()%>" required>
                                </div>
                            </div>
                            <hr>
                            <div class="row">
                                <div class="col-sm-3">
                                    <p class="mb-0">PinCode</p>
                                </div>
                                <div class="col-sm-9">
                                    <input type="text" name="pincode" class="form-control" value="<%=user.getPinCode()%>" required>
                                </div>
                            </div>
                            <hr>
                            <div class="row">
                                <div class="col-sm-12 text-center">
                                    <button type="submit" class="btn btn-primary">Update Profile</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <br>
    <br>
    <br>

    <%@ include file="footer.html"%>

</body>
</html>
