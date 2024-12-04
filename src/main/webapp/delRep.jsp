<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.group98.pkg.*" %>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="./styles/midStyle.css" />
	<meta charset="UTF-8">
	<title>Loading...</title>
</head>
<body>
	<%
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		
		String ssn = request.getParameter("ssn");
		
		String q = "DELETE FROM trainsdb.employee WHERE ssn="+ssn+";";
		
		int affectedRows = stmt.executeUpdate(q);
		
		if (affectedRows >= 1) {
			session.setAttribute("repDeleted", ssn);
			response.sendRedirect("admin.jsp");
		} else {
			throw new Exception("Unable to delete customer rep");
		}
	%>
</body>
</html>