<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.group98.pkg.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Loading...</title>
</head>
<body>
	<%
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		
		int affectedRows = stmt.executeUpdate("DELETE FROM trainsdb.schedule WHERE scid="+request.getParameter("scid")+";");
		
		if (affectedRows < 1) {
			throw new Exception("Could not delete schedule");
		} else {
			response.sendRedirect("customerRep.jsp");
		}
	%>
</body>
</html>