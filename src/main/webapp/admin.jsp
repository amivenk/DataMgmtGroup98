<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Administration</title>
	<link rel="stylesheet" href="./styles/midStyle.css" />
</head>
<body>
<script type="text/javascript">
	var repAdded = "<% out.print(session.getAttribute("repAdded")); %>";
	var repChanged = "<% out.print(session.getAttribute("repChanged")); %>";
	
	if (repAdded != "null") {
		alert("Added "+repAdded+" as a customer representative.");
	}
	if (repChanged != "null") {
		alert("Changed attributes of employee "+repChanged);
	}
	<% 
		session.removeAttribute("repAdded");
		session.removeAttribute("repChanged");
	%>
	
</script>

<div class="marginDiv">
	<h4>Customer Representatives</h4>
	<form method="post" action="addCustomerRep.jsp">
		<input name="ssn" type="text" placeholder="SSN" class="inputField" required/>
		<input name="firstName" type="text" placeholder="First Name" class="inputField" required/>
		<input name="lastName" type="text" placeholder="Last Name" class="inputField" required/>
		<input name="username" type="text" placeholder="Username" class="inputField" required/>
		<input name="password" type="password" placeholder="Password" class="inputField" required/>
		<input type="submit" value="Add Customer Representative" class="defaultButton"/>
	</form>
	<form id="searchRepsForm" method="post" action="searchCustomerReps.jsp">
		<input id="searchSsn" name="ssn" type="text" placeholder="SSN" class="inputField"/>
		<input id="searchFirstName" name="fname" type="text" placeholder="First Name" class="inputField"/>
		<input id="searchLastName" name="lname" type="text" placeholder="Last Name" class="inputField"/>
		<input id="searchUsername" name="username" type="text" placeholder="Username" class="inputField"/>
		<input id="searchPassword" name="password" type="password" placeholder="Password" class="inputField"/>
		<input type="submit" value="Search Customer Representatives" class="defaultButton"/>
	</form>
	
	
	<h4>Sales Report</h4>
	<p>placeholder</p>
	
	<h4>Search Reservations</h4>
	<form action="searchReservations.jsp" method="post">
		<input type="text" name="transitLine" placeholder="Transit Line" class="inputField"/>
		<input type="text" name="customerName" placeholder="Customer Name" class="inputField"/>
		<input type="submit" value="Search" class="defaultButton" />
	</form>
	
	<h4>Revenue</h4>
	
	
	<h4>Best Customer</h4>
	<p>John Smith<p>
	<% // This will just be a query that gets listed since there isn't any inputs required for it %>
	
	<h4>5 Most Active Transit Lines</h4>
	<p>placeholder</p>
	<% // Same here %>
	
	<br>
	<form action="logout.jsp">
		<input type="submit" value="Log out" class="defaultButton" />
	</form>
</div>
</body>
</html>