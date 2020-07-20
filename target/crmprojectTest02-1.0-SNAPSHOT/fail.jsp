<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2020/6/29
  Time: 20:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page isELIgnored="false" contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() + ":" + request.getServerPort() +
            request.getContextPath() + "/";

%>
<html>
<head>
    <base href="<%=basePath%>">
    <title>Title</title>

</head>
<body>
    <img src="image/goutou.jpg">
</body>
</html>
