<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.group98.pkg.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Customer Representative</title>
	<link rel="stylesheet" href="./styles/midStyle.css" />
</head>
<body>
<%
	// Get the username from the session, set by checkCredentials
	String username = (String)session.getAttribute("username");
	
	if (username == null) {
		response.sendRedirect("login.jsp");
	}
%>
<div class="marginDiv">
		<%
			
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
			Statement stmt = con.createStatement();
		%>
	
	<h4>Customer Q&A</h4>
	<h5>Search:</h5>
	<form action="searchQnA.jsp" >
		Question:
		<input type="text" name="question" class="inputField" />
		Answer:
		<input type="text" name="answer" class="inputField" />
		<input type="submit" value="Search" class="defaultButton" />
	</form>
	
	<h4>Station Schedules</h4>
	<form action="searchSchedules.jsp" >
		Station:
		<select name="station">
			<%
				String q = "SELECT name FROM trainsdb.station;";
				ResultSet res = stmt.executeQuery(q);
				while (res.next()) {
					out.print("<option value=\""+res.getString("name")+"\">"+res.getString("name")+"</option>");
				}
			%>
		</select>
		<input type="submit" value="Search" class="defaultButton" />
	</form>
	
	<h4>Search Reservations</h4>
	<form action="searchReservations.jsp">
		Transit Line:
		<select name="transitLine">
			<option value=""></option>
			<%
				q = "SELECT DISTINCT linename FROM trainsdb.schedule;";
				res = stmt.executeQuery(q);
				while (res.next()) {
					out.print("<option value=\""+res.getString("linename")+"\">"+res.getString("linename")+"</option>");
				}
			%>
		</select>
		Date
		<input type="date" name="date" class="inputField"/>
		<input type="submit" value="Search" class="defaultButton"/>
	</form>
	<br>
	<form action="logout.jsp">
		<input type="submit" value="Log out" class="defaultButton" />
	</form>
</div>
</body>
</html>