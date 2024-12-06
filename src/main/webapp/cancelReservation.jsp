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
		
		String resnum = request.getParameter("resnum");
		
		String q = "DELETE FROM trainsdb.reservation WHERE resnum="+resnum+";";
		
		int affectedRows = stmt.executeUpdate(q);
		
		if (affectedRows == 0) {
			throw new Exception("Unable to cancel reservation.");
		} else {
			if (session != null) {
				session.setAttribute("reservationCanceled", resnum);
			}
			
			response.sendRedirect("welcome.jsp");
		}
	%>
</body>
</html>