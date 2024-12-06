<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.group98.pkg.*, java.time.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Dashboard</title>
	<link rel="stylesheet" href="./styles/midStyle.css" />
</head>
<body>
<div class="marginDiv">
	<%
		// Get the username from the session, set by checkCredentials
		String username = (String)session.getAttribute("username");
		
		String reservationCanceled = (String)session.getAttribute("reservationCanceled");
	%>
	<script type="text/javascript">
		const invalid = "<%=username %>";
		const reservationCanceled = "<%=reservationCanceled %>";
		
		if (invalid == "null") {
			alert("Invalid Session.");
		}
		if (reservationCanceled != "null") {
			alert("Reservation #"+reservationCanceled+" canceled.");
		}
	</script>
	
	<%
		session.removeAttribute("reservationCanceled");
	
		// If there is no username the session is invalid
		if (username == null) {
			response.sendRedirect("login.jsp");
		} else {
			out.print("<h2>Welcome " + username + "!</h2>");
		}
	%>
	
	<h4>Current Reservations</h4>
	<table>
		<tr>
			<th>Date&emsp;</th>
			<th>Line&emsp;</th>
			<th>Train #&emsp;</th>
			<th>Passenger&emsp;</th>
			<th>Type&emsp;</th>
			<th>Total&emsp;</th>
		</tr>
		<%
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
			Statement stmt = con.createStatement();
			
			LocalDate today = LocalDate.now();
			
			// It's only split so it isn't a gigantic line of mess
			StringBuilder query = new StringBuilder();
			query.append("SELECT date, linename, tid, passenger, type, total, resnum ");
			query.append("FROM trainsdb.reservation r, trainsdb.schedule sc ");
			query.append("WHERE r.username='"+username+"' AND r.date>='"+today+"' AND r.scid=sc.scid;");
			String q = query.toString();
			
			ResultSet results = stmt.executeQuery(q);
			ResultSetMetaData rsmd = results.getMetaData();
			
			while (results.next()) {
				out.print("<tr>");
				for (int i = 1; i < rsmd.getColumnCount(); i++) {
				 	out.print("<td>"+results.getString(rsmd.getColumnName(i))+"</td>");
				}
				out.print("<td><form action=\"cancelReservation.jsp\"> <input type=\"submit\" value=\"Cancel\" class=\"defaultButton\"/>");
				out.print("<input type=\"hidden\" name=\"resnum\" value=\""+results.getString("resnum")+"\" /> </form></td>");
				out.print("</tr>");
			}
		%>
	</table>
	
	<h4>Past Reservations</h4>
	<table>
		<tr>
			<th>Date&emsp;</th>
			<th>Line&emsp;</th>
			<th>Train #&emsp;</th>
			<th>Passenger&emsp;</th>
			<th>Type&emsp;</th>
			<th>Total&emsp;</th>
		</tr>
		<%
			q = q.replaceAll(">=", "<");
			results = stmt.executeQuery(q);
			rsmd = results.getMetaData();
			
			while (results.next()) {
				out.print("<tr>");
				for (int i = 1; i <= rsmd.getColumnCount(); i++) {
				 	out.print("<td>"+results.getString(rsmd.getColumnName(i))+"</td>");
				}
				out.print("</tr>");
			}
		%>
	</table>
		
	<h4>Search Train Schedules</h4>
	<form method="post" action="searchSchedules.jsp">
		Origin:
		<select name="origin" id="originSelect">
			<option value=""></option>
			<%
				// Populate origin list
				q = "SELECT DISTINCT origin FROM trainsdb.schedule;";
				results = stmt.executeQuery(q);
				
				while(results.next()) {
					String o = results.getString("origin");
					out.print("<option value=\""+o+"\">"+o+"</option>");
				}
			%>
		</select>
		Destination:
		<select name="destination" id="destinationSelect">
			<option value=""></option>
			<%
				// Populate Destination list
				q = "SELECT DISTINCT dest FROM trainsdb.schedule;";
				results = stmt.executeQuery(q);
				
				while(results.next()) {
					String o = results.getString("dest");
					out.print("<option value=\""+o+"\">"+o+"</option>");
				}
			%>
		</select>
		Date of Travel:
		<select name="date" id="dateSelect">
			<option value=""></option>
			<%
				// Populate Dates
				q = "SELECT DISTINCT DATE(departure) FROM trainsdb.schedule;";
				results = stmt.executeQuery(q);
				
				while(results.next()) {
					String o = results.getString("DATE(departure)");
					out.print("<option value=\""+o+"\">"+o+"</option>");
				}
			%>
		</select>
		<input type="submit" value="Search" class="defaultButton" />
	</form>
	
	<h4>Ask a Question</h4>
	<form action="askQuestion.jsp" method="post">
		<input type="text" name="question" class="bigInputField" />
		<input type="submit" class="defaultButton" />
	</form>
	<form action="viewQuestions.jsp">
		<input type="submit" class="defaultButton" value="View Questions" />
	</form>
	
	<br>
	<form action="logout.jsp">
		<input type="submit" value="Log out" class="defaultButton" />
	</form>
</div>
</body>
</html>