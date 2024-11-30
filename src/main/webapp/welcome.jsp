<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.group98.pkg.*" %>
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
	%>
	<script type="text/javascript">
		var invalid = "<% out.print(username); %>";
		
		if (invalid == "null") {
			alert("Invalid Session.");
		}
	</script>
	<%
		// If there is no username the session is invalid
		if (username == null) {
			response.sendRedirect("login.jsp");
		} else {
			out.print("<h2>Welcome " + username + "!</h2>");
		}
	%>
	
	<h4>Current Reservations</h4>
	<p>placeholder<p>
	
	<h4>Past Reservations</h4>
	<p>placeholder</p>
		
	<h4>Search Train Schedules</h4>
	<form action="search.jsp">
		Origin:
		<input type="text" name="origin" class="inputField"/>
		Destination:
		<input type="text" name="destination" class="inputField"/>
		Date of Travel:
		<input type="text" name="date" class="inputField"/>
		<input type="submit" value="Search" class="defaultButton" />
	</form>
	<br>
	
	<form action="logout.jsp">
		<input type="submit" value="Log out" class="defaultButton" />
	</form>
</div>
</body>
</html>