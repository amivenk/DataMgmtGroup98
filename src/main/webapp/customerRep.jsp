<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
	<h4>Train Schedules</h4>
	<form action="searchSchedules.jsp" method="post">
		Origin:
		<select name="origin">
		</select>
		Destination:
		<select name="dest">
		</select>
		<input type="submit" value="Search" class="defaultButton" />
	</form>
	<form action="searchSchedules.jsp" method="post">
		<input type="submit" value="View all schedules" class="defaultButton" />
	</form>
	
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
	<form action="stationSchedules.jsp" >
		Station:
		<input type="text" name="station" class="inputField" />
		<input type="submit" value="Search" class="defaultButton" />
	</form>
	
	<h4>Search Reservations</h4>
	<form>
		Transit Line:
		<input type="text" name="line" class="inputField" />
		Date
		<input type="text" name="date" class="inputField" />
		<input type="submit" value="Search" class="defaultButton" />
	</form>
	<br>
	<form action="logout.jsp">
		<input type="submit" value="Log out" class="defaultButton" />
	</form>
</div>
</body>
</html>