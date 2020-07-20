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
    $.ajax({
    url: "some.php",
    type: "POST",
    dataType:"json",
    data: {},
    success: function(data){

    }
    });

</head>
<body>

</body>
</html>
