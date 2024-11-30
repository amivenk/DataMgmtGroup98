<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ page import="java.io.*,java.util.*,java.sql.*, com.group98.pkg.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Loading...</title>
	<link rel="stylesheet" href="./styles/midStyle.css" />
</head>
<body>
	<%
		try {
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
			Statement stmnt = con.createStatement();
			
			int ssn = Integer.parseInt(request.getParameter("ssn"));
			String firstName = request.getParameter("firstName");
			String lastName = request.getParameter("lastName");
			String username = request.getParameter("username");
			String password = request.getParameter("password");
			String type = "customerRep";
			
			String q = String.format("INSERT INTO trainsdb.employee VALUES (%d, '%s', '%s', '%s', '%s', '%s');", ssn, firstName, lastName, username, password, type);
			
			int affectedRows = stmnt.executeUpdate(q);
			
			if (affectedRows <= 0) {
				throw new Exception("Customer rep not added");
			} else {
				session.setAttribute("repAdded", username);
				response.sendRedirect("admin.jsp");
			}
		} catch (Exception e) {
			out.print(e);
		}
	%>
</body>
</html>