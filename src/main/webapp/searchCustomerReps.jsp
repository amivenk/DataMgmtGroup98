<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.group98.pkg.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Search Customer Representatives</title>
	<link rel="stylesheet" href="./styles/midStyle.css" />
</head>
<body>
<div class="marginDiv">
<h2>Customer Representatives</h2>
	<table>
	<tr>
		<th>SSN&emsp;</th>
		<th>First Name&emsp;</th>
		<th>Last Name&emsp;</th>
		<th>Username&emsp;</th>
		<th>Password</th>
	</tr>
	<%
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		Statement stmnt = con.createStatement();
		
		String[] parameters = {"ssn", "fname", "lname", "username", "password"};
		
		String ssn = request.getParameter("ssn");
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		// String ssn = request.getParameter("ssn") == null ? "" : "e.ssn=" + request.getParameter("ssn");
				
		StringBuilder qBuilder = new StringBuilder("SELECT * FROM trainsdb.employee WHERE type='customerRep'");
		for (String s : parameters) {
			if (request.getParameter(s) != null && !request.getParameter(s).equals("")) {
				qBuilder.append(" AND "+s+"='"+request.getParameter(s)+"'");
			}
		}
		qBuilder.append(";");
		
		ResultSet results = stmnt.executeQuery(qBuilder.toString());
		
		while (results.next()) {
			out.print("<tr>");
			out.print("<td>"+results.getInt("ssn")+"</td>");
			for (String s : parameters) {
				if (s.equals("ssn"))
					continue;
				out.print("<td>"+results.getString(s)+"</td>");
			}
			out.print("</tr>");
		}
	%>
	</table>
	<form action="admin.jsp">
		<input type="submit" value="Back" class="defaultButton" />
	</form>
</div>
</body>
</html>