<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.group98.pkg.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Administration</title>
	<link rel="stylesheet" href="./styles/midStyle.css" />
	<%
		// Get the username from the session, set by checkCredentials
		String username = (String)session.getAttribute("username");
	
		if (username == null) {
			response.sendRedirect("login.jsp");
		}
	%>
</head>
<body>
<script type="text/javascript">
	var repAdded = "<% out.print(session.getAttribute("repAdded")); %>";
	var repChanged = "<% out.print(session.getAttribute("repChanged")); %>";
	var repDeleted = "<% out.print(session.getAttribute("repDeleted")); %>";
	
	if (repAdded != "null") {
		alert("Added "+repAdded+" as a customer representative.");
	}
	if (repChanged != "null") {
		alert("Changed attributes of customer representative "+repChanged);
	}
	if (repDeleted != "null") {
		alert("Deleted customer representative "+repDeleted);
	}
	<% 
		session.removeAttribute("repAdded");
		session.removeAttribute("repChanged");
		session.removeAttribute("repDeleted");
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
	
	<% // This will just be a query that gets listed since there isn't any inputs required for it
		// Add up the total of each customers reservations, the top result is the best customer
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		
		StringBuilder query = new StringBuilder();
		query.append("SELECT c.fname, c.lname, SUM(r.total) sum\n");
		query.append("FROM trainsdb.customer c, trainsdb.reservation r\n");
		query.append("WHERE c.username=r.username\n");
		query.append("GROUP BY c.fname, c.lname ORDER BY sum DESC;");
		
		ResultSet res = stmt.executeQuery(query.toString());
		res.next();
		
		// Round to 2 decimal places
		float sum = ((int) ((res.getFloat("sum") + 0.005f) * 100)) / 100f;
		
		out.print(res.getString("fname")+" "+res.getString("lname")+" $"+sum);
	%>
	
	<h4>5 Most Active Transit Lines</h4>
	<% // Same here
		// Transit Lines with the most reservations
		StringBuilder mostResQ = new StringBuilder();
		mostResQ.append("SELECT sc.linename, COUNT(*) c\n");
		mostResQ.append("FROM trainsdb.schedule sc, trainsdb.reservation r\n");
		mostResQ.append("WHERE sc.scid=r.scid\n");
		mostResQ.append("GROUP BY(sc.linename) ORDER BY c DESC LIMIT 5;");
		
		res = stmt.executeQuery(mostResQ.toString());
		
		int i = 1;
		while(res.next()) {
			out.print(i+". "+res.getString("linename")+": "+res.getString("c")+" reservations");
			i++;
		}
	%>
	<br>
	<br>
	<form action="logout.jsp">
		<input type="submit" value="Log out" class="defaultButton" />
	</form>
</div>
</body>
</html>