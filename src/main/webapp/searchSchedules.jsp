<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.group98.pkg.*, java.time.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Search Scheduled Trains</title>
	<link rel="stylesheet" href="./styles/midStyle.css" />
</head>
<body>
<div class="marginDiv">
	<form action="welcome.jsp">
		<input type="submit" value="Back" class="defaultButton"/>
	</form>
	<br>
	<h2>Schedules</h2>
	<p>Click the stops menu to view all stops. Hover over a stop to see more info</p>
	<table>
		<tr>
			<th>Line&emsp;</th>
			<th>Departure&emsp;</th>
			<th>Arrival&emsp;</th>
			<th>Travel Time&emsp;</th>
			<th>Origin&emsp;</th>
			<th>Destination&emsp;</th>
			<th>Train #&emsp;</th>
			<th>Stops&emsp;</th>
		</tr>
	<%
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		
		String origin = request.getParameter("origin");
		String dest = request.getParameter("destination");
		String date = request.getParameter("date");
		
		String[] names = {"origin", "dest", "DATE(departure)"};
		String[] params = {origin, dest, date};
		
		StringBuilder query = new StringBuilder();

		query.append("SELECT linename, departure, arrival, travel, origin, dest, tid, scid ");
		query.append("FROM trainsdb.schedule");
		if (origin.equals("") && dest.equals("") && date.equals("")) {
			query.append(";");
		} else {
			query.append(" WHERE ");
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
		
		ResultSet results = stmt.executeQuery(query.toString());
		ResultSetMetaData rsmd = results.getMetaData();
		
		if (!results.next()) {
			out.print("No schedules available.");
		} else {
			// do while because the first next() was already consumed
			do {
				out.print("<tr>");
				for (int i = 1; i <= rsmd.getColumnCount() - 1; i++) {
					out.print("<td>"+results.getString(rsmd.getColumnName(i))+"</td>");
				}
				// Get the stops for the schedule
				Statement stopsStmt = con.createStatement();
				StringBuilder stopsQ = new StringBuilder();
				stopsQ.append("SELECT s.name, s.city, s.state, TIME(sa.arrival), TIME(sa.departure)\n");
				stopsQ.append("FROM trainsdb.stopsat sa, trainsdb.station s\n");
				stopsQ.append("WHERE sa.scid="+results.getString("scid")+"\n");
				stopsQ.append("AND sa.sid=s.sid\n");
				stopsQ.append("ORDER BY sa.arrival ASC;");
				// It's definitely more efficient to just make a big 1 line string, but this is easier for debugging
				// and looks cleaner
				
				ResultSet stopsRes = stopsStmt.executeQuery(stopsQ.toString());
						
				out.print("<td><select name=\"stops\">");
				while (stopsRes.next()) {
					String stName = stopsRes.getString("name");
					String stCity = stopsRes.getString("city");
					String stState = stopsRes.getString("state");
					String arrive = stopsRes.getString("TIME(sa.arrival)");
					String depart = stopsRes.getString("TIME(sa.departure)");
					
					String stopString = String.format("%s, %s\nArrives: %s\nDeparts: %s", stCity, stState, arrive, depart == null ? "-" : depart);
					
					out.print("<option value=\""+stName+"\" title=\""+stopString+"\">"+stName+"</option>");
				}
				out.print("</select></td>");
				out.print("</tr>");
			} while(results.next());
		}
	
		%>
	</table>
</div>
</body>
</html>