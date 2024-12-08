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
	<%
		String type = (String)session.getAttribute("type");
		if (type != null) {
			if (type.equals("customerRep")) {
				out.print("<form action=\"customerRep.jsp\">");
			} else if (type.equals("admin")) {
				out.print("<form action=\"admin.jsp\">");
			} 
		} else {
			throw new Exception("Illegal employee type");
			//response.sendRedirect("login.jsp");
		}
		
	%>
		<input type="submit" value="Back" class="defaultButton" />
	</form>
	<br>
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
		
		String tLine = request.getParameter("transitLine") == null ? "" : request.getParameter("transitLine");
		String customer = request.getParameter("customerName") == null ? "" : request.getParameter("customerName");
		String date = request.getParameter("date") == null ? "" : request.getParameter("date");
		
		StringBuilder query = new StringBuilder();
		query.append("SELECT date, username, passenger, type, total, sc.linename\n");
		query.append("FROM trainsdb.reservation r, trainsdb.schedule sc\n");
		query.append("WHERE r.scid = sc.scid\n");
		if (tLine.equals("") && customer.equals("") && date.equals("")) {
			query.append(";");
		} else {
			query.append("AND ");
			String[] names = {"r.date", "r.passenger", "sc.linename"};
			String[] params = {date, customer, tLine};
			int populatedFields = 0;
			for (String s : params) {
				populatedFields = s.equals("") ? populatedFields : populatedFields + 1;
			}
			populatedFields--;
			for (int i = 0; i < params.length; i++) {
				if (params[i].equals("")){
					continue;
				} else {
					query.append(names[i]+"='"+params[i]+"' ");
					if (populatedFields > 0) {
						populatedFields--;
						query.append("AND ");
					}
				}
			}
			query.append(";");
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
</div>
</body>
</html>