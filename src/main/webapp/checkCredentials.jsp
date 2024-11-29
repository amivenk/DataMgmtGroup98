<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, com.group98.pkg.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Loading...</title>
</head>
<body>
	<%
		try {
			// Create connection to the database
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
			
			Statement stmt = con.createStatement();
			
			// Get the username and password from the login form
			String username = request.getParameter("username");
			String password = request.getParameter("password");
			
			// Query the database for a matching account
			String q = "SELECT * FROM trainsdb.customer c WHERE c.username = '" + username + "' AND c.password = '" + password + "';";
			ResultSet usrRes = stmt.executeQuery(q);
			boolean isCustomer = usrRes.next();
			
			// If you use the same stmt for another query the previous ResultSet is no longer usable
			q = String.format("SELECT * FROM trainsdb.employee e WHERE e.username='%s' AND e.password='%s';", username, password);
			ResultSet empRes = stmt.executeQuery(q);
			boolean isEmployee = empRes.next();
			
			
			// If the result has no match redirect back to login screen
			if (!isEmployee && !isCustomer) {
				session.setAttribute("noLogin", "true");
				response.sendRedirect("login.jsp");
			} else {
				// Session is created and populated for you by jsp
				session.setAttribute("username", username);
				
				if (isCustomer) {
					response.sendRedirect("welcome.jsp");
				} else {
					int ssn = empRes.getInt("ssn");
					
					q = "SELECT e.type FROM trainsdb.employee e WHERE ssn="+ssn+";";
					ResultSet typeRes = stmt.executeQuery(q);
					if (typeRes.next()) {
						String type = typeRes.getString("type");
						if (type.equals("admin")) {
							response.sendRedirect("admin.jsp");
						} else if (type.equals("customerRep")) {
							response.sendRedirect("customerRep.jsp");
						}
					} else {
						throw new RuntimeException("Illegal employee type");
					}
				}
			}
			
			db.closeConnection(con);
		} catch (Exception e) {
			out.print(e);
		}
	%>
</body>
</html>