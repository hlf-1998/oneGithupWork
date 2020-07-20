<%@  page isELIgnored="false" contentType="text/html;charset=UTF-8" language="java" %>
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
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript">

        //将前端页面输入的数据想后端页面进行传递
        $(function () {



			//点击了登录按钮则会执行数据传递
			$("#myButton").click(function () {

			    //需要点击了登录按钮，并且选中了十天免登录按钮，则会执行以下的步骤
                var flag = "";
                if ($("#flag").prop("checked")){
                    flag = "a";
                }

				//使用ajax请求
				$.ajax({
					url: "workbench/user/ajaxLogin.do",
					type: "POST",
					dataType: "json",
					data: {
						//从前端获取得到的数据是以键值对的形式存在的
						"loginAct": $("#loginAct").val(),
						"loginPwd": $("#loginPwd").val(),
                        "flag":flag
					},
					success: function (data) {
						//在此处对从前端传递回来的json数据进行判断
						if (data.success) {
							//如果返回的true，那么说明登录成功，我们就需要先将页面跳转回controller页面进行跳转到WEB-INF下的页面
							window.location.href = "workbench/user/loginSuccess.do";

						} else {

							//如果登录失败，那么我们就将从后台获取的数据进行在页面的弹窗输出
							alert(data.msg);

						}


					}
				});
			});
		})
    </script>
</head>
<body>
<%--加入音频文件--%>

<%--<bgsound src="music/123.mp3" loop="true"></bgsound>--%>

<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
    <img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
        CRM &nbsp;<span style="font-size: 12px;">&copy;2020&nbsp;动力节点</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录</h1>
        </div>

        <form id="loginForm" class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <%--添加input标签，它的name就是key，输入的内容就是value
                        autocomplete="off"属性，关闭自动提醒
                    --%>
                    <input id="loginAct" name="loginAct" class="form-control" autocomplete="off" type="text"
                           placeholder="用户名">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input id="loginPwd" name="loginPwd" class="form-control" type="password" placeholder="密码">
                </div>
                <div class="checkbox" style="position: relative;top: 30px; left: 10px;">
                    <label>
                        <input id="flag" type="checkbox"> 十天内免登录
                    </label>
                    &nbsp;&nbsp;
                    <span id="msg"></span>
                </div>
                <button type="button" id="myButton" class="btn btn-primary btn-lg btn-block"
                        style="width: 350px; position: relative;top: 45px;">登录
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>