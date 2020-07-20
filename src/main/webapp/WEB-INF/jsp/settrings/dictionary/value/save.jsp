<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page isELIgnored="false" contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" +
request.getServerName() + ":" + request.getServerPort() +
request.getContextPath() + "/";

%>
<!DOCTYPE html>
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
			//在点击保存按钮后，我们需要字典类型编码还有字典值进行判断操作，判断其是否有值，并且字典值不能重复
			$("#saveBtn").click(function () {

				//先判断字典类型编码和字典值是否为空，如果为空的话，那么将无法进行提交
				if ($("#create-dicTypeCode").val() == "" || $("#create-dicValue").val() == ""){
					$("#flag").html("您的字典类型和字典值都不能为空哦！")
					//如果出现了问题就会终止,不会向下继续执行
					return;
				}
				//我们在判断字典值不能重复的时候，首先必须根据字符编码类型作为条件，在字符编码之下的字典值不能重复
				$.ajax({
					url: "settrings/dictionary/value/valueIfOnly.do",
					type: "get",
					dataType:"json",
					data: {
						"typeCode":$.trim($("#create-dicTypeCode").val()),
						"value":$.trim($("#create-dicValue").val())
					},
					success: function(data){
						if (data.success){
							//返回的结果为真，说明没有重复，我们可以进行表单提交提交
							$("#saveForm").submit()
						}else {
							//返回的结果为假，说明重复了，无法提交，我们需要给用户进行提示
							$("#onlyCodeSpan").html(data.msg)
						}
					}
				});
			})

		})
	</script>

</head>
<body>

	<div style="position:  relative; left: 30px;">
		<h3>新增字典值</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button id="saveBtn" type="button" class="btn btn-primary">保存</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form id="saveForm" action="settrings/dictionary/value/saveDisValue.do" method="post" class="form-horizontal" role="form">
					
		<div class="form-group">
			<label for="create-dicTypeCode" class="col-sm-2 control-label">字典类型编码<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select name="typeCode" class="form-control" id="create-dicTypeCode" style="width: 200%;">
				  <option></option>
					<c:forEach items="${codeList}" var="cdList">
						<option value="${cdList}">${cdList}</option>
					</c:forEach>
				</select>
				<span id="flag" style="color: red"></span>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-dicValue" class="col-sm-2 control-label">字典值<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input name="value" type="text" class="form-control" id="create-dicValue" style="width: 200%;">
				<span id="onlyCodeSpan" style="color:red"></span>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-text" class="col-sm-2 control-label">文本</label>
			<div class="col-sm-10" style="width: 300px;">
				<input name="text" type="text" class="form-control" id="create-text" style="width: 200%;">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-orderNo" class="col-sm-2 control-label">排序号</label>
			<div class="col-sm-10" style="width: 300px;">
				<input name="orderNo" type="text" class="form-control" id="create-orderNo" style="width: 200%;">
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>