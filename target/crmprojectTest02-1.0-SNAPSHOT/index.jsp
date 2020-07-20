<%@ page isELIgnored="false" contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<%
String basePath = request.getScheme() + "://" +
request.getServerName() + ":" + request.getServerPort() +
request.getContextPath() + "/";

%>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
</head>
<body>
	<script type="text/javascript">
		/*document.location.href = "login.jsp";*/
		document.location.href = "workbench/user/toLogin.do";

	</script>
</body>
</html>