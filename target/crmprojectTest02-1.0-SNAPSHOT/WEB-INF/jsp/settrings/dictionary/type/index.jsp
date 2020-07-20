<%@ page isELIgnored="false" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" >
		/**
		 * 如果需要点击修改的按钮，需要符合几个要求，才可以进行点击，
		 * 1、必须选中需要修改的数据
		 * 2、所需要修改的数据必须只能选择一个
		 */
		$(function () {

			//需要进行点击了修改按钮后，再对操作是否符合要求进行判断
			$("#codeBtn").click(function () {

				//判断复选框选中的情况
				//JSON.stringify()方法是将对象转换成字符串
				//获取复选框<input name="flag" type="checkbox"的选中状态
				//获取input输入中的复选框
				//input[name=flag],获取所有input标签name为flag的复选框
				//input[name=flag]:checked,获取所有选中的复选框
				//$("input[name=flag]:checked").length,获取选中的复选框个数



				if ($("input[name=flag]:checked").length == 0){
					//没有进行选择
					alert("请您选择所需要修改的数据，否则我们无法进行判断哦！！！")
				}else if ($("input[name=flag]:checked").length > 1){
					//选择了多个
					alert("您选择的数据太多了，我们无法判断您需要修改的是那个数据")
				}else {
					//选择了一个
					//获取选中的code，因为code是唯一的，我们就可以通过code进行判断的操作
					var code = $("input[name=flag]:checked").val();
					//让我们获取到的code跟随我们的跳转进行传递
					window.location.href = "settrings/dictionary/updateDisTypeByCode.do?code="+code;


				}
			})

			//TODO 全选按钮，选择一个全选按钮后，其他的复选框都会全部被选中
			//Dom对象转换为jquery对象：$(dom对象)
			//jquery对象转换为Dom对象：jquery对象[0]

			//首先需要点击了全选的复选框
			$("#findAll").click(function () {

				//获取所有的复选框
				//$("input[name=flag]")
				/*var flags = $("input[name=flag]")*/

				//$("#findAll").prop("checked")中prop就是返回选择属性的值，如果全选的复选框被选中了那么就会返回true
				//flags[i].checked这个表示的是：这个的值如果是true，那么说明他的复选框需要被选中
				//方式一：for循环
				/*for (var i = 0;i<flags.length;i++){
					//如果全选框被选中了，那么我们需要把所有的复选框都被选中
					//$("#findAll").prop("checked")，当我们全选框被选中的时候，那么这里返回的值就是true
					//flags[i].checked，这个是我们的所有的复选框，我们把全选框选中之后的直接赋值给这里，那么所有的复选框也就会被选中,
					//反之，如果全选框未被选中的话，那么复选框也不会被选中
					flags[i].checked = $("#findAll").prop("checked")
				}*/

				/*//方式二：$.each循环
				$.each(flags,function (i,n) {
					//和上面是一样的原理
					n.checked = $("#findAll").prop("checked")
				})*/

				//方式三：通过使用prop方法，批量设置复选框的选中状态
				//参数1：设置的key，要设置的属性
				//参数2：给参数1设置的属性值（在此处的作用是如果参数2为真，那么所有的的复选框都会被选中）
				$("input[name=flag]").prop("checked",$("#findAll").prop("checked"))

			})

			//TODO 删除的操作
			//首先我们在点击删除按钮的时候需要进行校验，判断我们是否复选框是否有选中所需要删除的数据
			$("#deleteBtn").click(function () {

				//根据判断复选框选中的个数来进行判断复选框是否有数据被选中
				if ($("input[name=flag]:checked").length == 0){
					alert("您好，您没有选中需要删除的数据！！")
					//在弹出框之后，可以使用return，可以避免再向下继续执行
					return
				}
				//url参数	http://localhost:8080/crm/xxx.do?key=value&key=value
				//获取选中的jquery对象
				//定义字符串，封装参数
				var param = "?";
				//使用循环对选中的数据进行拼接
				$.each($("input[name=flag]:checked"),function (i,n) {
					param += "codes=" + $(n).val();
					if (i < $("input[name=flag]:checked").length -1){
						param += "&";
					}
				})
				//alert(param)
				//在删除的时候，可以使用一个事件，提醒用户是否确定进行删除，因为可能是用户的失误操作不小心进行了点击
				if (confirm("删除之后就无法恢复了，您是否确定删除?")){
					//使用ajax发送请求
					$.ajax({
						url: "settrings/dictionary/type/deleteDisType.do"+param,
						type: "get",
						//查询到的数据跟随请求进行传递了，所以这里的data，我们就不用进行赋值的操作了
						data: {},
						success: function(data){
							if (data.success){
								//返回真，则表示删除成功，则将页面跳转回字典类型的首页
								window.location.href = "settrings/dictionary/toDictionaryType.do"
							}else{
								//如果没有删除成功则打印提示用户
								alert(data.msg)
							}
						}
					});
				}

			})



		})
		//TODO 反选按钮，如果所有的复选框被选中后，那么我们的全选框也会被选中
		function result() {

			$("#findAll").prop("checked",$("input[name=flag]").length == $("input[name=flag]:checked").length?true:false)

		}

	</script>
</head>
<body>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典类型列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" onclick="window.location.href='settrings/dictionary/type/toDicTypeSave.do'"><span class="glyphicon glyphicon-plus"></span> 创建</button>
			<%--onclick="window.location.href='edit.jsp'"--%>
			<button type="button" class="btn btn-default" id="codeBtn" ><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" id="findAll" /></td>
					<td>序号</td>
					<td>编码</td>
					<td>名称</td>
					<td>描述</td>
				</tr>
			</thead>
			<%--可以使用jstl标签库进行使用，将获取到的数据输出到页面中,c:foreach标签进行遍历操作
				第一步：首先需要先导入jstl标签库
				第二步：设置isELIgnored="false",让页面可以加载el表达式
						items属性:使用el表达式遍历的集合名称
						var属性：每次遍历的变量名称
						varStatus：变量的状态属性，index是从0开始计数，count是从1开始计数

			--%>
			<c:forEach items="${dtList}" var="dt" varStatus="c">
				<tbody>
				<tr class="active">
					<%--在复选框input标签中可以对属性进行设置
						name属性：可以根据属性获取的多个选中的复选框
						value属性：通过选中的复选框jquery通过对象通过val()的方法获取value的属性值
					--%>
					<td><input name="flag" onclick="result()" value="${dt.code}" type="checkbox" /></td>
					<td>${c.count}</td>
					<td>${dt.code}</td>
					<td>${dt.name}</td>
					<td>${dt.description}</td>
				</tr>
				</tbody>
			</c:forEach>

		</table>
	</div>
	
</body>
</html>