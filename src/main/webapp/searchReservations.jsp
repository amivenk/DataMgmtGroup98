<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<%@ page import="java.io.*,java.util.*,java.sql.*, com.group98.pkg.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" href="./styles/midStyle.css" />
	<title>Customer Reservations</title>
</head>
<body>
<div class="marginDiv">
	<table>
		<tr>
			<th>Date&emsp;</th>
			<th>Username&emsp;</th>
			<th>Passenger&emsp;</th>
			<th>Type&emsp;</th>
			<th>Total&emsp;</th>
			<th>Line</th>
		</tr>
	<%
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		
		String tLine = request.getParameter("transitLine");
		String customer = request.getParameter("customerName");
		
		StringBuilder query = new StringBuilder();
		query.append("SELECT date, username, passenger, type, total, sc.linename\n");
		query.append("FROM trainsdb.reservation r, trainsdb.schedule sc\n");
		query.append("WHERE r.scid = sc.scid\n");
		if (tLine.equals("") && customer.equals("")) {
			query.append(";");
		} else {
			query.append("AND ");
			if (!tLine.equals("") && !customer.equals("")) {
				query.append("sc.linename="+tLine+"AND r.passenger="+customer+";");
			} else if(!tLine.equals("")){
				query.append("sc.linename='"+tLine+"';");
			} else {
				query.append("r.passenger='"+customer+"';");
			}
		}
		
		ResultSet reservations = stmt.executeQuery(query.toString());
		ResultSetMetaData rsmd = reservations.getMetaData();
		
		if (reservations.next()) {
			// First next() already called
			do {
				out.print("<tr>");
				for (int i = 1; i <= rsmd.getColumnCount(); i++) {
				 	out.print("<td>"+reservations.getString(rsmd.getColumnName(i))+"</td>");
				}
				out.print("</tr>");
			} while(reservations.next());
		} else {
			out.print("</table>No reservations found.");
		}
		out.print("</table>");
	%>
	<br>
	<form action="admin.jsp">
		<input type="submit" value="Back" class="defaultButton" />
	</form>
</div>
</body>
</html>