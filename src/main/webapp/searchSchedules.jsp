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
<script type="text/javascript">
	function showEditForm(scid) {
		document.getElementById("formScid").value = scid;
		document.getElementById("editScheduleForm").style.visibility = "visible";
	}
</script>

<div class="marginDiv">
	<%
		// This page is reused for customers and customer reps so it has different behaviors
		// depending on who is using it
	
		String type = (String)session.getAttribute("type");
		if (type != null && type.equals("customerRep")) {
			out.print("<form action=\"customerRep.jsp\">");
		} else {
			out.print("<form action=\"welcome.jsp\">");
		}
	%>
		<input type="submit" value="Back" class="defaultButton"/>
	</form>
	<br>
	<h2>Schedules</h2>
	<%
		if (type == null) 
			out.print("<p>Click the stops menu to view all stops. Hover over a stop to see more info</p>");
	%>
	<br>
	<script type="text/javascript">
		window.onload = () => {
			let sortby = "<%= request.getParameter("sortby") %>"
			
			if (sortby == "arrival") {
				document.getElementById("arrivalRadio").checked = true;
			} else if (sortby == "departure") {
				document.getElementById("departRadio").checked = true;
			} else if (sortby == "fare") {
				document.getElementById("fareRadio").checked = true;
			}
		}
	
		function submitSort() {
			document.getElementById("sortForm").submit();
		}
	</script>	
	
	<form action="searchSchedules.jsp" id="sortForm">
	<input type="hidden" name="origin" value="<%=request.getParameter("origin") %>" />
	<input type="hidden" name="destination" value="<%=request.getParameter("destination") %>" />
	<input type="hidden" name="date" value="<%=request.getParameter("date") %>" />
	Sort By:<br>
	<label for="arrivalRadio">Arrival Time</label>
	<input id="arrivalRadio" type="radio" name="sortby" onclick="submitSort()" value="arrival" />
	<label for="departRadio">Departure Time</label>
	<input id="departRadio" type="radio" name="sortby" onclick="submitSort()" value="departure" />
	<label for="fareRadio">Fare</label>
	<input id="fareRadio" type="radio" name="sortby" onclick="submitSort()" value="fare"/>
	</form>
	<br>
	<table>
		<tr>
			<th>Line&emsp;</th>
			<th>Departure&emsp;</th>
			<th>Arrival&emsp;</th>
			<th>Travel Time&emsp;</th>
			<th>Origin&emsp;</th>
			<th>Destination&emsp;</th>
			<th>Fare&emsp;</th>
			<th>Train #&emsp;</th>
			<%
				if (type == null)
					out.print("<th>Stops&emsp;</th>");
			%>
			
		</tr>
	<%
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		
		if (type == null) {
			String origin = request.getParameter("origin") == null ? "" : request.getParameter("origin");
			String dest = request.getParameter("destination") == null ? "" : request.getParameter("destination");
			String date = request.getParameter("date") == null ? "" : request.getParameter("date");
			String sortby = request.getParameter("sortby") == null ? "" : request.getParameter("sortby");
			
			String[] names = {"origin", "dest", "DATE(departure)"};
			String[] params = {origin, dest, date};
			
			StringBuilder query = new StringBuilder();
	
			query.append("SELECT linename, departure, arrival, travel, origin, dest, fare, tid, scid ");
			query.append("FROM trainsdb.schedule");
			if (origin.equals("") && dest.equals("") && date.equals("")) {
				if (!sortby.equals("")) {
					query.append(" ORDER BY "+sortby+" DESC");
				}
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
				if (!sortby.equals("")) {
					query.append("ORDER BY "+sortby+" DESC");
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
						out.print("<td>"+results.getString(rsmd.getColumnName(i))+"&emsp;</td>");
					}
					
					// Get the stops for the schedule
					Statement stopsStmt = con.createStatement();
					StringBuilder stopsQ = new StringBuilder();
					stopsQ.append("SELECT s.sid, sa.scid, s.name, s.city, s.state, TIME(sa.arrival), TIME(sa.departure)\n");
					stopsQ.append("FROM trainsdb.stopsat sa, trainsdb.station s\n");
					stopsQ.append("WHERE sa.scid="+results.getString("scid")+"\n");
					stopsQ.append("AND sa.sid=s.sid\n");
					stopsQ.append("ORDER BY sa.arrival ASC;");
					// It's definitely more efficient to just make a big 1 line string, but this is easier for debugging
					// and looks cleaner
					
					ResultSet stopsRes = stopsStmt.executeQuery(stopsQ.toString());
							
					out.print("<td><form action=\"createReservation.jsp\"><select name=\"scid\">");
					while (stopsRes.next()) {
						String scid = stopsRes.getString("scid");
						String sid = stopsRes.getString("sid");
						String stName = stopsRes.getString("name");
						String stCity = stopsRes.getString("city");
						String stState = stopsRes.getString("state");
						String arrive = stopsRes.getString("TIME(sa.arrival)");
						String depart = stopsRes.getString("TIME(sa.departure)");
						
						String stopString = String.format("%s, %s\nArrives: %s\nDeparts: %s", stCity, stState, arrive, depart == null ? "-" : depart);
						
						out.print("<option value=\""+scid+"\" title=\""+stopString+"\">"+stName+"</option>");
					}
					out.print("</select><input type=\"submit\" value=\"Make Reservation\" class=\"defaultButton\"/></form>");
					out.print("</tr>");	
				} while(results.next());
			}
		} else if (type.equals("customerRep")) {
			StringBuilder repQ = new StringBuilder();
			
			String station = request.getParameter("station");
			
			repQ.append("SELECT linename, departure, arrival, travel, origin, dest, fare, tid, scid\n");
			repQ.append("FROM trainsdb.schedule\n");
			repQ.append("WHERE origin='"+station+"' OR dest='"+station+"';");
			
			ResultSet res = stmt.executeQuery(repQ.toString());
			ResultSetMetaData rsmd = res.getMetaData();
			
			while (res.next()) {
				out.print("<tr>");
				for (int i = 1; i <= rsmd.getColumnCount() - 1; i++) {
					out.print("<td>"+res.getString(rsmd.getColumnName(i))+"&emsp;</td>");
				}
				out.print("<td><button onclick=\"showEditForm("+res.getString("scid")+")\" class=\"defaultButton\">Edit</button></td>");
				out.print("<td><form action=\"delSchedule.jsp\"><input type=\"submit\" class=\"defaultButton\" value=\"Delete\"/>");
				out.print("<input type=\"hidden\" name=\"scid\" value=\""+res.getString("scid")+"\" /></form></td>");
				out.print("</tr>");
			}
		}
		%>
	</table>
	<br>
	<form action="editSchedule.jsp" id="editScheduleForm" style="visibility: hidden">
	<p>Leaving a field blank will not change its value.</p>
	<table>
	<tr>
		<th><label for="formScid">Schedule ID</label></th>
		<th><label for="editName">Line Name</label></th>
		<th><label for="editDepart">Departure Time</label></th>
		<th><label for="editArrival">Arrival Time</label></th>
		<th><label for="editTravel">Travel Time</label></th>
		<th><label for="editOrigin">Origin Station</label></th>
		<th><label for="editDest">Destination Station</label></th>
		<th><label for="editFare">Fare</label></th>
		<th><label for="editTrain">Train #</label></th>
	</tr>
	<tr>
		<td><input type="text" id="formScid" name="scid" class="inputField" value="0" readonly /></td>
		<td><input type="text" id="editName" name="linename" class="inputField" placeholder="Line Name"/></td>
		<td><input type="time" id="editDepart" name="departure" class="inputField"/></td>
		<td><input type="time" id="editArrival" name="arrival" class="inputField"/></td>
		<td><input type="text" id="editTravel" name="travel" class="inputField" placeholder="Travel Time"/></td>
		<td>
		<select name="origin" id="editOrigin">
		<option value=""></option>
		<%
			String q = "SELECT name FROM trainsdb.station;";
			ResultSet res = stmt.executeQuery(q);
			while (res.next()) {
				out.print("<option value=\""+res.getString("name")+"\">"+res.getString("name")+"</option>");
			}
		%>
		</select>
		</td>
		<td>
		<select name="dest" id="editDest">
		<option value=""></option>
		<%
			res.first();
			do { 
				out.print("<option value=\""+res.getString("name")+"\">"+res.getString("name")+"</option>");
			} while (res.next());
		%>
		</select>
		</td>
		<td><input type="text" name="fare" class="inputField" placeholder="Fare" id="editFare"/>
		<td>
		<select name="tid" id="editTrain">
		<option value=""></option>
			<%
				q = "SELECT tid FROM trainsdb.train;";
				res = stmt.executeQuery(q);
				while (res.next()) {
					out.print("<option value=\""+res.getString("tid")+"\">"+res.getString("tid")+"</option>");
				}
			%>
		</select>
		</td>
	</tr>
	</table>
	<input type="submit" class="defaultButton" />
	</form>
</div>
</body>
</html>