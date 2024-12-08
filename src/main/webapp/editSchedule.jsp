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
		// 19:25
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		
		String q = "SELECT DATE(departure) d FROM trainsdb.schedule WHERE scid="+request.getParameter("scid")+";";
		ResultSet res = stmt.executeQuery(q);
		res.next();
		
		String date = res.getString("d");
		
		String[] attrs = {"linename", "departure", "arrival", "travel", "origin", "dest", "fare", "tid"};
		
		StringBuilder query = new StringBuilder();
		query.append("UPDATE trainsdb.schedule SET ");
		
		for (int i = 0; i < attrs.length; i++) {
			String attr = request.getParameter(attrs[i]);
			if (!attr.equals("")) {
				if (attrs[i].equals("departure") || attrs[i].equals("arrival")) {
					attr = date+" "+attr+":00";
				}
				query.append(attrs[i]+"='"+attr+"',");
			}
		}
		query.deleteCharAt(query.length() - 1);
		query.append(" WHERE scid='"+request.getParameter("scid")+"';");
		
		
		int affectedRows = stmt.executeUpdate(query.toString());
		
		if (affectedRows < 1) {
			throw new Exception("Could not edit schedule");
		} else {
			response.sendRedirect("customerRep.jsp");
		} 
	%>
</body>
</html>