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

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript">

		$(function () {

			//让光标在编码框中
			$("#code").focus();


			//需要点击保存按钮后，再对其进行判断的操作
			$("#saveBtn").click(function () {
				//获取编码的值，如果编码没有输入那么则无法进行创建
				var codeClick = $("#code").val();
				if (codeClick == ""){
					$("#codeSpan").html("您好，您输入的编码不能为空！！")
				}

				//使用ajax请求，根据编码值进行查询，编码值不能重复，重复则无法进行添加，不重复则可以进行添加的操作
				$.ajax({
					url: "settrings/dictionary/type/saveReuseDisTypeByCode.do",
					type: "POST",
					data: {
						//trim方法是可以将空格省略
						"code":$.trim(codeClick)
					},
					success: function(data){

						//获取从后端传递回来的数据
						if (data.success){

							//如果为真，说明code没有重复,那么就可以直接进行创建，创建之后跳转回字典类型页面
							//使用表单提交的方法，对表单进行提交的操作
							$("#savaForm").submit()

						}else {
							//如果为假，说明code重复，给用户进行提示
							$("#codeSpan").html(data.msg)
						}
					}
				});

			})

		})
	</script>
</head>
<body>

	<div style="position:  relative; left: 30px;">
		<h3>新增字典类型</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button id="saveBtn" type="button" class="btn btn-primary">保存</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form id="savaForm" method="post" action="settrings/dictionary/saveDistype.do" class="form-horizontal" role="form">
					
		<div class="form-group">
			<label for="create-code" class="col-sm-2 control-label">编码<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="code" name="code" style="width: 200%;">
				<span id="codeSpan"></span>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-name" class="col-sm-2 control-label">名称</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="name" name="name" style="width: 200%;">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 300px;">
				<textarea class="form-control" rows="3" id="describe" name="description" style="width: 200%;"></textarea>
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>