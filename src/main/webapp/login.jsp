<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.group98.pkg.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Login</title>
	<link rel="stylesheet" href="./styles/midStyle.css" />
</head>
<body>
	<script type="text/javascript">
		function showRegistration() {
			document.getElementById("registrationForm").style.visibility = "visible";
			document.getElementById("createAccount").style.visibility = "hidden";
		}
		function checkPasswordMatch() {
			let passInput = document.getElementById("newPassword").value;
			let confirmation = document.getElementById("confirmPassword").value;
			
			if (passInput != confirmation) {
				document.getElementById("warningText").style.visibility = "visible";
			} else {
				document.getElementById("warningText").style.visibility = "hidden";
			}
		}
	
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
	<br>
	<br>
	<button id="createAccount" onclick="showRegistration()" class="defaultButton">Create new account</button>
	<form action="registerAccount.jsp" method="post" id="registrationForm" style="visibility: hidden">
		<h2>Register</h2>
		First<br>
		<input type="text" name="firstName" class="inputField" placeholder="First Name" required /> <br>
		Last<br>
		<input type="text" name="lastName" class="inputField" placeholder="Last Name" required /> <br>
		E-mail<br>
		<input type="text" name="email" class="inputField" placeholder="E-Mail Address" required /> <br>
		Username <br>
		<input type="text" name="newUsername" class="inputField" placeholder="Username" required /> <br>
		Password <br>
		<input id="newPassword" type="password" name="newPassword" class="inputField" placeholder="Password" onkeyup="checkPasswordMatch()" required /> <br>
		<input id="confirmPassword" type="password" class="inputField" placeholder="Confirm Password" onkeyup="checkPasswordMatch()" required /> <br>
		<div id="warningText" class="warningText" style="visibility: hidden">Passwords do not match!</div>
		<input type="submit" value="Create Account" class="defaultButton" />
	</form>
	</div>
</body>
</html>