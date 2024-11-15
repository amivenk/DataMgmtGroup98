<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.group98.pkg.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Login</title>
	<style>
		/* If anyone is a css wizard that would be awesome */
		.loginDiv {
			margin: 5px;
		}
		.inputField {
			margin: 2px;
			padding: 6px;
			border-radius: 6px;
		}
		.defaultButton {
			margin: 2px;
			padding: 6px;
			border-radius: 15px;
		}
		body {
			font-family: "Arial";
		}
	</style>
</head>
<body>
	<script type="text/javascript">
		// If the noLogin attribute is set from checkCredentials it will alert the user
		var invalid = "<% out.print(session.getAttribute("noLogin")); %>";
		
		if (invalid != "null") {
			alert("Invalid Login.");
		}
		
		<% session.removeAttribute("noLogin"); %>
	</script>
	<div class="loginDiv">
	<h2>Login</h2>
	<form method="post" action="checkCredentials.jsp">
		<input name="username" type="text" placeholder="Username" class="inputField" />
		<br>
		<input name="password" type="password" placeholder="Password" class="inputField" />
		<br>
		<input id="loginButton" type="submit" value="Login" class="defaultButton" />
	</form>
	</div>
</body>
</html>