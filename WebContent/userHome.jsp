<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Remica Rich</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<style>
    .chatbox {
        position: fixed;
        bottom: 20px;
        left: 20px;
        width: 300px;
        border: 1px solid #ccc;
        border-radius: 5px;
        background-color: #fff;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        z-index: 1000;
    }

    .chatbox-header {
        background-color: #007bff;
        color: #fff;
        padding: 10px;
        border-top-left-radius: 5px;
        border-top-right-radius: 5px;
        text-align: center;
    }

    .chatbox-body {
        padding: 10px;
    }

    .messages {
        height: 200px;
        overflow-y: auto;
        border: 1px solid #ccc;
        padding: 5px;
        margin-bottom: 10px;
    }

    #chat-input {
        width: calc(100% - 80px);
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
        margin-right: 10px;
    }

    #send-button {
        padding: 10px;
        border: none;
        background-color: #007bff;
        color: #fff;
        border-radius: 5px;
        cursor: pointer;
    }

    #send-button:hover {
        background-color: #0056b3;
    }
</style>
</head>
<body style="background-color: #E6F9E6;">

	<%
	/* Checking the user credentials */
	String userName = (String) session.getAttribute("username");
	String password = (String) session.getAttribute("password");

	if (userName == null || password == null) {
		response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
	}

	ProductServiceImpl prodDao = new ProductServiceImpl();
	List<ProductBean> products = new ArrayList<ProductBean>();

	String search = request.getParameter("search");
	String type = request.getParameter("type");
	String message = "All Products";
	if (search != null) {
		products = prodDao.searchAllProducts(search);
		message = "Showing Results for '" + search + "'";
	} else if (type != null) {
		products = prodDao.getAllProductsByType(type);
		message = "Showing Results for '" + type + "'";
	} else {
		products = prodDao.getAllProducts();
	}
	if (products.isEmpty()) {
		message = "No items found for the search '" + (search != null ? search : type) + "'";
		products = prodDao.getAllProducts();
	}
	%>

	<jsp:include page="header.jsp" />

	<div class="text-center"
		style="color: black; font-size: 14px; font-weight: bold;"><%=message%></div>

	<!-- Start of Product Items List -->
	<div class="container">
		<div class="row text-center">
			<%
			for (ProductBean product : products) {
				int cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId());
			%>
			<div class="col-sm-4" style='height: 350px;'>
				<div class="thumbnail">
					<img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product"
						style="height: 150px; max-width: 180px">
					<p class="productname"><%=product.getProdName()%></p>
					<%
					String description = product.getProdInfo();
					description = description.substring(0, Math.min(description.length(), 100));
					%>
					<p class="productinfo"><%=description%>..</p>
					<p class="price">RM <%=product.getProdPrice()%></p>
					<form method="post">
						<%
						if (cartQty == 0) {
						%>
						<button type="submit"
							formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1"
							class="btn btn-success">Add to Cart</button>
						&nbsp;&nbsp;&nbsp;
						<button type="submit"
							formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1"
							class="btn btn-primary">Buy Now</button>
						<%
						} else {
						%>
						<button type="submit"
							formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0"
							class="btn btn-danger">Remove From Cart</button>
						&nbsp;&nbsp;&nbsp;
						<button type="submit" formaction="cartDetails.jsp"
							class="btn btn-success">Checkout</button>
						<%
						}
						%>
					</form>
					<br />
				</div>
			</div>
			<%
			}
			%>
		</div>
	</div>
	<!-- End of Product Items List -->

	<%@ include file="footer.html"%>

	<!-- Start of Chatbox -->
	<div id="chatbox" class="chatbox">
		<div class="chatbox-header">
			<h4>Chat with us!</h4>
		</div>
		<div class="chatbox-body">
			<div class="messages" id="messages">
				<!-- Chat messages will be dynamically inserted here -->
			</div>
			<input type="text" id="chat-input" placeholder="Type your message..." />
			<button id="send-button">Send</button>
		</div>
	</div>
	<!-- End of Chatbox -->

	<script>
		document.addEventListener('DOMContentLoaded', function() {
			const messagesDiv = document.getElementById('messages');
			const chatInput = document.getElementById('chat-input');
			const sendButton = document.getElementById('send-button');

			// Function to send a message
			function sendMessage() {
				const message = chatInput.value.trim();
				if (message !== '') {
					fetch('ChatServlet', {
						method: 'POST',
						headers: {
							'Content-Type': 'application/x-www-form-urlencoded'
						},
						body: `message=${encodeURIComponent(message)}`
					})
					.then(response => response.json())
					.then(data => {
						if (data.success) {
							const messageDiv = document.createElement('div');
							messageDiv.textContent = message;
							messagesDiv.appendChild(messageDiv);
							chatInput.value = '';
							messagesDiv.scrollTop = messagesDiv.scrollHeight;
						} else {
							alert('Error sending message');
						}
					});
				}
			}

			// Event listener for send button
			sendButton.addEventListener('click', sendMessage);

			// Optional: Send message on Enter key press
			chatInput.addEventListener('keypress', function(event) {
				if (event.key === 'Enter') {
					sendMessage();
					event.preventDefault();
				}
			});
		});
	</script>

</body>
</html>
