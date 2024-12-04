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
<script type="text/javascript">
	function spawnEditForm(ssn) {
		console.log("Editing: "+ssn);
		document.getElementById("editFormSSN").value = ssn;
		document.getElementById("editForm").style.visibility = "visible";
	}
	function confirmDelete(e, ssn) {
		if (!confirm("Are you sure you want to delete customer rep: "+ssn+"?")) {
			e.preventDefault();
		}
	}
</script>
<div class="marginDiv">
<h2 style="text-decoration: underline">Customer Representatives</h2>
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
			out.print("<td><button class=\"defaultButton\" onclick=\"spawnEditForm(\'"+results.getString("ssn")+"\')\">Edit</button></td>");
			out.print("<td><form action=\"delRep.jsp\" method=\"post\" onsubmit=\"confirmDelete(event, "+results.getString("ssn")+")\">");
			out.print("<input type=\"submit\" value=\"Delete\" class=\"defaultButton\"/>");
			out.print("<input value=\""+results.getString("ssn")+"\" type=\"text\" name=\"ssn\" style=\"visibility: hidden\" readonly/>");
			// This input is just to hide the ssn for when the delete gets submitted
			// There might be a simpler way of doing this but this also works for now
			out.print("</form></td>");
			out.print("</tr>");
		}
	%>
	</table>
	<form action="editRep.jsp" method="post" id="editForm" style="visibility: hidden">
	<br><div style="font-weight: bold">Leave a field blank to retain its current value. </div><br>
		<input type="text" name="ssn" id="editFormSSN" class="inputField" readonly/>
		<input type="text" name="fname" id="editFirstName" placeholder="New first name" class="inputField"/>
		<input type="text" name="lname" id="editLastName" placeholder="New last name" class="inputField"/>
		<input type="text" name="username" id="editUsername" placeholder="New username" class="inputField"/>
		<input type="text" name="password" id="editPassword" placeholder="New password" class="inputField"	/>
		<input type="submit" value="Save" class="defaultButton"/>
	</form>
	
	<form action="admin.jsp">
		<input type="submit" value="Back" class="defaultButton" />
	</form>
</div>
</body>
</html>