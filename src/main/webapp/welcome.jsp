<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.group98.pkg.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Dashboard</title>
	<style>
		.defaultButton {
			margin: 2px;
			padding: 6px;
			border-radius: 15px;
		}
		body {
			font-family: "Arial";
		}
	</style>
</head>
<body>
	<%
		// Get the username from the session, set by checkCredentials
		String username = (String)session.getAttribute("username");
	
	%>
	<script type="text/javascript">
		var invalid = "<% out.print(username); %>";
		
		if (invalid == "null") {
			alert("Invalid Session.");
		}
	</script>
	<%
		// If there is no username the session is invalid
		if (username == null) {
			response.sendRedirect("login.jsp");
		} else {
			out.print("<h2>Welcome " + username + "!</h2>");
		}
	%>
	<form action="logout.jsp">
		<input type="submit" value="Log out" class="defaultButton" />
	</form>
</body>
</html>