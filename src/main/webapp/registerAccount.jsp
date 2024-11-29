<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.group98.pkg.*" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Registration</title>
		<link rel="stylesheet" href="./styles/midStyle.css" />
	</head>
	<body>
		<% 
			// Check if the username (primary key) is already in the database
			// If it is not then add the new user's data
			// Otherwise registration fails
			
			try {
			// Create connection to the database
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
			
			Statement stmt = con.createStatement();
			
			// Get data from registration form
			String firstName = request.getParameter("firstName");
			String lastName = request.getParameter("lastName");
			String username = request.getParameter("newUsername");
			String password = request.getParameter("newPassword");
			String email = request.getParameter("email");
			
			// Query the database for a matching account
			String q = "SELECT * FROM trainsdb.customer c WHERE c.username = '" + username + "';";
			ResultSet res = stmt.executeQuery(q);
			
			// If the result has a match, the username is taken
			if (res.next()) {
				session.setAttribute("takenUsername", "true");
				response.sendRedirect("login.jsp");
			} else {
				q = String.format("INSERT INTO trainsdb.customer (email, fname, lname, username, password) VALUES ('%s', '%s', '%s', '%s', '%s');",
						email, firstName, lastName, username, password);
				
				// When inserting or updating tables executeUpdate is used instead of executeQuery
				int affectedRows = stmt.executeUpdate(q);
				
				out.print("<h2>Success! Welcome "+firstName+"!</h2>");
			}
			
			db.closeConnection(con);
		} catch (Exception e) {
			out.print(e);
		}
		%>
		<form action="login.jsp">
			<input type="submit" value="Back to login" class="defaultButton" />
		</form>
	</body>
</html>