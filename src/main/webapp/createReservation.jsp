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
		let cost = 0;
		
		function calculateFare() {
			const stop1data = document.getElementById("originSelect").value.split(" ");
			const stop2data = document.getElementById("destination").value.split(" ");
			const originId = stop1data[0];
			const stop1num = stop1data[1];
			const depart = stop1data[2];
			const destId = stop2data[0];
			const stop2num = stop2data[1];
			const arrive = stop2data[2];
			const options = document.getElementsByName("discount");
			const types = document.getElementsByName("tripType");
			
			let multiplier = Math.abs(stop1num - stop2num);
			let stopCost = fare/stops;
			cost = stopCost * multiplier + stopCost;
			
			// Apply reservation type pricing
			for (let i = 0; i < types.length; i++) {
				if (types[i].checked) {
					cost *= types[i].value;
					break;
				}
			}
			
			// Apply discount
			for (let i = 0; i < options.length; i++) {
				if (options[i].checked) {
					cost -= (cost * options[i].value);
					break;
				}
			}
			
			document.getElementById("resTotal").innerHTML = "$"+cost.toFixed(2);
			document.getElementById("hiddenTotal").value = cost.toFixed(2);
			document.getElementById("arrivalText").innerHTML = arrive;
			document.getElementById("departText").innerHTML = depart;
			
			document.getElementById("originId").value = originId;
			document.getElementById("destId").value = destId;
			console.log("cost: "+cost);
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
		<select name="originSelect" id="originSelect" onclick="calculateFare()">
	<%
		int numStops = 0;
		while (res.next()) {
			numStops++;
			String sid = res.getString("sid");
			String stName = res.getString("name");
			String stCity = res.getString("city");
			String stState = res.getString("state");
			String arrive = res.getString("TIME(sa.arrival)") == null ? "-" : res.getString("TIME(sa.arrival)");
			String depart = res.getString("TIME(sa.departure)") == null ? "-" : res.getString("TIME(sa.departure)");
			String number = res.getString("stopNum");
			
			String stopString = String.format("%s, %s\nArrives: %s\nDeparts: %s", stCity, stState, arrive, depart);
			
			out.print("<option value=\""+sid+" "+number+" "+depart+"\" title=\""+stopString+"\">"+stName+"</option>");
		}
		
	%>
		</select>
	</td>
	<%
		out.print("<script type=\"text/javascript\">const stops = "+numStops+";</script>");
	%>
	<td>
		<select name="destination" id="destination" onclick="calculateFare()">
	<%
		res.first();
		// res.first() puts it already on the first row instead of before
		// But since these are destinations we don't want the user to be able to create reservation
		// to the first station anyway.
		while (res.next()) {
			String sid = res.getString("sid");
			String stName = res.getString("name");
			String stCity = res.getString("city");
			String stState = res.getString("state");
			String arrive = res.getString("TIME(sa.arrival)") == null ? "-" : res.getString("TIME(sa.arrival)");
			String depart = res.getString("TIME(sa.departure)") == null ? "-" : res.getString("TIME(sa.departure)");
			String number = res.getString("stopNum");
			
			String stopString = String.format("%s, %s\nArrives: %s\nDeparts: %s", stCity, stState, arrive, depart);
			
			out.print("<option value=\""+sid+" "+number+" "+arrive+"\" title=\""+stopString+"\">"+stName+"</option>");
		}
	%>
		</select>
	</td>
	<td>
		<input type="text" name="passenger" class="inputField" placeholder="Name" required />
	</td>
	</tr>
	</table>
	<h4>Available Discounts</h4>
	<input id="childDiscount" type="radio" name="discount" value="0.25" onclick="calculateFare()"/>
	<label for="childDiscount">Child (Under 12 years old)</label> <br>
	<input id="seniorDiscount" type="radio" name="discount" value="0.35" onclick="calculateFare()"/>
	<label for="seniorDiscount">Senior (Over 55 years old)</label> <br>
	<input id="disabledDiscount" type="radio" name="discount" value="0.50" onclick="calculateFare()"/>
	<label for="disabledDiscount">Disabled</label> <br>
	<input id="noDiscount" type="radio" name="discount" value="0" onclick="calculateFare()"/>
	<label for="noDiscount">None</label> <br>
	<h4>Reservation Type</h4>
	<input id="oneWay" type="radio" name="tripType" value="1" onclick="calculateFare()" required/>
	<label for="oneWay">One Way</label> <br>
	<input id="roundTrip" type="radio" name="tripType" value="2" onclick="calculateFare()" required/>
	<label for="roundTrip">Round Trip</label>
	<br><br>
	<div style="text-decoration: underline">Departure Time:</div> <div id="departText">-</div>
	<div style="text-decoration: underline">Arrival Time:</div> <div id="arrivalText">-</div>
	<div style="text-decoration: underline">Train Number:</div> <div id="trainText">
	<%
		res = stmt.executeQuery("SELECT tid FROM trainsdb.schedule WHERE scid="+scid+";");
		// Should probably check if next() is successful but if it's not we have bigger problems anyway
		res.next();
		out.print(res.getString("tid"));
	%>
	</div>
	<div style="text-decoration: underline">Total:</div> <div id="resTotal">$0</div>
	<input type="submit" class="defaultButton" value="Confirm" />
	<input type="hidden" name="total" id="hiddenTotal" />
	<input type="hidden" name="origin" id="originId"/>
	<input type="hidden" name="dest" id="destId" />
	<input type="hidden" name="scid" value="<%=scid %>" />
</form>
</div>

<script type="text/javascript">
	window.onload = calculateFare();
</script>
</body>
</html>