<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.group98.pkg.*, java.time.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Loading...</title>
	<link rel="stylesheet" href="./styles/midStyle.css" />
</head>
<body>
	<%
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		
		String passenger = request.getParameter("passenger");
		String originId = request.getParameter("origin");
		String destId = request.getParameter("dest");
		String scid = request.getParameter("scid");
		String total = request.getParameter("total");
		String username = (String)session.getAttribute("username");
		String type = request.getParameter("tripType").equals("1") ? "One Way" : "Round Trip";
		
		String query = "SELECT DATE(departure) as d FROM trainsdb.schedule WHERE scid="+scid+";";
		ResultSet res = stmt.executeQuery(query);
		res.next();
		String date = res.getString("d");
		
		StringBuilder q = new StringBuilder();
		q.append("INSERT INTO trainsdb.reservation (passenger, total, type, username, date, scid, originst, destst)");
		q.append(String.format("VALUES ('%s', %s, '%s', '%s', '%s', %s, %s, %s);",
				passenger, total, type, username, date, scid, originId, destId));
		
		int affectedRows = stmt.executeUpdate(q.toString());
		
		if (affectedRows >= 1) {
			session.setAttribute("reservationCreated", true);
			response.sendRedirect("welcome.jsp");
		} else {
			throw new Exception("Unable to create reservation");
		}
	%>
</body>
</html>