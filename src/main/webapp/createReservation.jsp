<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.group98.pkg.*, java.time.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Create Reservation</title>
	<link rel="stylesheet" href="./styles/midStyle.css" />
	<%
		String scid = request.getParameter("scid");
	
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		Statement fstmt = con.createStatement();
		
		String fq = "SELECT fare FROM trainsdb.schedule WHERE scid="+scid+";";
		
		ResultSet fareRes = fstmt.executeQuery(fq);
		fareRes.next();
		
		float fare = fareRes.getFloat("fare");
	%>
	<script type="text/javascript">
		let fare = <%=fare%>;
		
		function calculateFare() {
			
		}
		
		function applyDiscount(discount) {
			
		} 
	</script>
</head>
<body>
<div class="marginDiv">
<form action="welcome.jsp">
	<input type="submit" value="Cancel" class="defaultButton" />
</form>
<h2>Create Reservation</h2>
<p>Select your desired origin and destination stations.
Please include a passenger name and check any boxes for applicable discounts.</p>
<form action="submitReservation.jsp" method="post">
	<table>
	<tr>
		<th>Origin&emsp;</th>
		<th>Destination&emsp;</th>
		<th>Fare&emsp;</th>
		<th>Passenger&emsp;</th>
	</tr>
	<tr>
	<%
		Statement stmt = con.createStatement();
		
		// Get the stops for the schedule
		StringBuilder q = new StringBuilder();
		q.append("SELECT s.sid, s.name, s.city, s.state, TIME(sa.arrival), TIME(sa.departure), ROW_NUMBER() OVER (ORDER BY sa.arrival) stopNum\n");
		q.append("FROM trainsdb.stopsat sa, trainsdb.station s\n");
		q.append("WHERE sa.scid="+scid+"\n");
		q.append("AND sa.sid=s.sid\n");
		q.append("ORDER BY sa.arrival ASC;");
		
		ResultSet res = stmt.executeQuery(q.toString());
	%>
	<td>
		<select name="origin">
	<%
		int numStops = 0;
		while (res.next()) {
			numStops++;
			String sid = res.getString("sid");
			String stName = res.getString("name");
			String stCity = res.getString("city");
			String stState = res.getString("state");
			String arrive = res.getString("TIME(sa.arrival)");
			String depart = res.getString("TIME(sa.departure)");
			String number = res.getString("stopNum");
			
			String stopString = String.format("%s, %s\nArrives: %s\nDeparts: %s", stCity, stState, arrive, depart == null ? "-" : depart);
			
			out.print("<option value=\""+sid+" "+number+"\" title=\""+stopString+"\">"+stName+"</option>");
		}
		
	%>
		</select>
	</td>
	<%
		out.print("<script type=\"text/javascript\">const stops = "+numStops+";</script>");
	%>
	<td>
		<select name="destination">
	<%
		res.first();
		// res.first() puts it already on the first row instead of before
		do {
			String sid = res.getString("sid");
			String stName = res.getString("name");
			String stCity = res.getString("city");
			String stState = res.getString("state");
			String arrive = res.getString("TIME(sa.arrival)");
			String depart = res.getString("TIME(sa.departure)");
			String number = res.getString("stopNum");
			
			String stopString = String.format("%s, %s\nArrives: %s\nDeparts: %s", stCity, stState, arrive, depart == null ? "-" : depart);
			
			out.print("<option value=\""+sid+" "+number+"\" title=\""+stopString+"\">"+stName+"</option>");
		} while (res.next());
	%>
		</select>
	</td>
	<td>
		<div id="fare"><%=fare %></div>
	</td>
	<td>
		<input type="text" class="inputField" placeholder="Name" required />
	</td>
	</tr>
	</table>
	<h4>Available Discounts</h4>
	<input id="childDiscount" type="radio" name="discount" value="0.25"/>
	<label for="childDiscount">Child (Under 12 years old)</label> <br>
	<input id="seniorDiscount" type="radio" name="discount" value="0.35"/>
	<label for="seniorDiscount">Senior (Over 55 years old)</label> <br>
	<input id="disabledDiscount" type="radio" name="discount" value="0.50"/>
	<label for="disabledDiscount">Disabled</label> <br>
	<h4>Reservation Type</h4>
	<input id="oneWay" type="radio" name="tripType" />
	<label for="oneWay">One Way</label> <br>
	<input id="roundTrip" type="radio" name="tripType" />
	<label for="roundTrip">Round Trip</label>
	<br><br>
	Total: <div id="resTotal">$0</div>
	<input type="submit" class="defaultButton" value="Confirm" />
</form>
</div>
</body>
</html>