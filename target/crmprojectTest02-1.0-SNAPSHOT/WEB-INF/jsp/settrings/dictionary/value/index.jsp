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

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript">
		$(function () {
			//在用户点击编辑按钮后对其进行判断的操作
			$("#updateBtn").click(function () {
				//需要对选中的复选框进行判断，
				//如果复选框没有进行选中，我们无法进行修改，需要给用户进行提示的操作
				if ($("input[name=flag]:checked").length == 0 || $("input[name=flag]:checked").length > 1){
					alert("您只能选择修改一条数据哦！！！")
					return;
				}
				var id = $("input[name=flag]:checked").val()

				window.location.href = "settrings/dictionary/value/findDisValueByID.do?id="+id;

			})

			//全选:当点击全选框之后，其他的复选框也都会被选中
			$("#findAll").click(function () {
				//$("input[name=flag]"):获取所有的复选框
				//$("#findAll").prop("checked"):全选框的选中状态，如果全选框被选中了，这里就是true
				//这里的方式是：通过prop批量设置复选框的选中状态
				//如果参数二为true，那么所有复选框也都会被选中
				$("input[name=flag]").prop("checked",$("#findAll").prop("checked"))
			})

			//点击删除的按钮
			$("#deleteBtn").click(function () {



				//获取选中对象的value，我们可以根据对象中的value保存是我们的唯一值id对其进行删除的操作
				//alert($("input[name=flag]:checked").val())
				//我们需要使用循环，将我们选中的数据进行拼接
				var param = "?";

				$.each($("input[name=flag]:checked"),function (i,n) {
					param += "ids="+ $(n).val()
					if (i < $("input[name=flag]:checked").length - 1){
						param += "&"
					}
				})

				//在点击删除按钮的时候，我们需要添加一个事件，让用户确定是否进行删除
				if (confirm("删除后数据无法恢复，是否删除？")){
					alert(param)
					//使用ajax发送请求
					$.ajax({
						url: "settrings/dictionary/value/deleteDisValueByID.do"+param,
						type: "get",
						dataType:"json",
						//数据已经跟随我们的url进行了发送，所以这里不用再进行填写
						data: {},
						success: function(data){
							if(data.success){
								//如果返回结果为true，那么说明删除成功
								window.location.href = "settrings/dictionary/toDisValue.do";
							}else{
								//返回结果为false，说明删除失败
								alert(data.msg)
							}
						}
					});
				}

			})

		})
		//反选
		function result() {
			//当所有的按钮被选中后，全选框也会被选中
			//$("input[name=flag]").length == $("input[name=flag]:checked").length?：选中的复选框和所有复选框的个数一样时，返回true，
			// 那么根据方法，我们的全选框也就会被选中
			$("#findAll").prop("checked",$("input[name=flag]").length == $("input[name=flag]:checked").length?true:false);

		}
	</script>
</head>
<body>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典值列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
			<%--对页面进行跳转，跳转到增加的页面--%>
		  <button type="button" class="btn btn-primary" onclick="window.location.href='settrings/dictionary/toSaveValue.do'"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		 	<%--对页面进行编辑操作，需要在点击后，对其进行判断，在这里为其添加id按钮--%>
		  <button type="button" class="btn btn-default" id="updateBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input id="findAll" type="checkbox" /></td>
					<td>序号</td>
					<td>字典值</td>
					<td>文本</td>
					<td>排序号</td>
					<td>字典类型编码</td>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${dvList}" var="dv" varStatus="c">
					<tr class="active">
						<%--value属性:可以让复选框jquery对象通过val()获取value的属性值,这里的id是这张表的唯一标识--%>
						<td><input name="flag" value="${dv.id}" onclick="result()" id="codeAndVal" type="checkbox" /></td>
						<td>${c.count}</td>
						<td>${dv.value}</td>
						<td>${dv.text}</td>
						<td>${dv.orderNo}</td>
						<td>${dv.typeCode}</td>
					</tr>
				</c:forEach>


			</tbody>
		</table>
	</div>
	
</body>
</html>