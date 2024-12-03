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
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
			Statement stmnt = con.createStatement();
			
			int ssn = Integer.parseInt(request.getParameter("ssn"));
	
			String[] attributes = {"fname", "lname", "username", "password"};
			
			StringBuilder query = new StringBuilder();
			query.append("UPDATE trainsdb.employee SET ");
			for (String s : attributes) {
				if (!request.getParameter(s).equals("")) {
					query.append(s+"='"+request.getParameter(s)+"',");
				}
			}
			query.deleteCharAt(query.length() - 1);
			query.append(" WHERE ssn="+ssn+";");
			
			int affectedRows = stmnt.executeUpdate(query.toString());
			
			if (affectedRows <= 0) {
				throw new Exception("Customer rep not changed");
			} else {
				session.setAttribute("repChanged", ssn);
				response.sendRedirect("admin.jsp");
			}
		} catch (Exception e) {
			out.print(e);
		}
	%>
</body>
</html>