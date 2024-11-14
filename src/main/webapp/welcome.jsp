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
		try {
			// Create connection to the database
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
			
			Statement stmt = con.createStatement();
			
			// Get the username and password from the login form
			String username = request.getParameter("username");
			String password = request.getParameter("password");
			
			// Query the database for a matching account
			String q = "SELECT * FROM trainsdb.accounts a WHERE a.username = '" + username + "' AND a.pass = '" + password + "';";
			ResultSet res = stmt.executeQuery(q);
			
			// If the result has no match redirect back to login screen
			if (!res.next()) {
				response.sendRedirect("login.jsp");
			}
	%>
	
	<h2>Welcome <% out.print(username); %>!</h2>
	
	
	<form action="logout.jsp">
		<input type="submit" value="Log out" class="defaultButton" />
	</form>
	
	<%
			db.closeConnection(con);
		} catch (Exception e) {
			out.print(e);
		}
	%>
</body>
</html>