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

	<h5>Browse Questions and Answers:</h5>
	<table border="1" class="resultTable">
		<thead>
			<tr>
				<th>Question</th>
				<th>Answer</th>
			</tr>
		</thead>
		<tbody>
			<%
				try {
					String browseQuery = "SELECT question, answer FROM trainsdb.questions_answers;";
					ResultSet browseRes = stmt.executeQuery(browseQuery);
					while (browseRes.next()) {
			%>
			<tr>
				<td><%= browseRes.getString("question") %></td>
				<td><%= browseRes.getString("answer") %></td>
			</tr>
			<%
					}
					browseRes.close();
				} catch (SQLException e) {
					out.print("Error loading questions and answers: " + e.getMessage());
				}
			%>
		</tbody>
	</table>

	<h5>Search Questions by Keywords:</h5>
	<form action="searchQnA.jsp" method="get">
		Keyword:
		<input type="text" name="keyword" class="inputField" />
		<input type="submit" value="Search by Keyword" class="defaultButton" />
	</form>

	<table border="1" class="resultTable">
		<thead>
			<tr>
				<th>Question</th>
				<th>Answer</th>
			</tr>
		</thead>
		<tbody>
			<%
				String keyword = request.getParameter("keyword");
				if (keyword != null && !keyword.trim().isEmpty()) {
					try {
						String keywordQuery = "SELECT question, answer FROM trainsdb.questions_answers WHERE question LIKE ?;";
						PreparedStatement pstmt = con.prepareStatement(keywordQuery);
						pstmt.setString(1, "%" + keyword + "%");
						ResultSet keywordRes = pstmt.executeQuery();

						while (keywordRes.next()) {
			%>
			<tr>
				<td><%= keywordRes.getString("question") %></td>
				<td><%= keywordRes.getString("answer") %></td>
			</tr>
			<%
						}
						keywordRes.close();
						pstmt.close();
					} catch (SQLException e) {
						out.print("Error searching questions by keyword: " + e.getMessage());
					}
				}
			%>
		</tbody>
	</table>


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
