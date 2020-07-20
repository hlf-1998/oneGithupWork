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


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>


<script type="text/javascript">
	$(function(){
		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});


		// TODO 00、引入时间控件
		//年月日
		$(".dateTime").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

		//TODO 01 页面显示数据，公司名称，联系人名称，称呼，所有者名称
		//我们将线索的id存放在隐藏域中
		$("#clueId").val('${clue.id}');

		//TODO 02 在这里我们创建一个是否创建交易的标识
		var flag = "";
		$("#isCreateTransaction").click(function () {
			//如果我们为客户创建交易的按钮被点击了，那么我们就为我们的标识进行赋值，没有点击则标识为空字符串
			if ($("#isCreateTransaction").prop("checked")){
				flag = "a";
			}else {
				flag = "";
			}
		})

		//TODO 03 点击搜索市场活动的图标，获取已经关联的市场活动列表信息
		$("#search_data").click(function () {
			//我们将搜索的方法写在外部，我们在此处直接调用方法即可
			getRelationActivityList();
		})

		//TODO 04 通过模糊查询搜索市场活动名称		(这里没有写完！！！！！！！！！！明天继续！！！！！！！！！！！)
		$("#search_activityName").keydown(function (event) {
			if(event.keyCode == 13){
				var html = "";
				//按下回车键后，发送ajax请求
				$.ajax({
					url: "workbench/clue/getRelationActivityListLike.do",
					type: "POST",
					dataType:"json",
					data: {
						"clueId":"${clue.id}",
						"activityName":$.trim($("#search_activityName").val())
					},

					success: function(data){
						if (data.success){
							html += '<tr>';
							html += '<td><input type="radio" value="'+n.id+'" name="activity"/></td>';
							html += '<td id="n_'+n.id+'">'+n.name+'</td>';
							html += '<td>'+n.startDate+'</td>';
							html += '<td>'+n.endDate+'</td>';
							html += '<td>'+n.owner+'</td>';
							html += '</tr>';
						}
						//刷新列表
						$("#tbodyBtn").html(html);
					}
				});
			}
			return;

		})

		/**
		 * 	点击市场活动的保存按钮，存储市场活动id以及显示市场活动名称
		 * 	这里我们点击保存之后的目的是为了将我们的数据保存到我们市场活动源的框中
		 * 	然后在我们进行转换的时候，会把我们这些数据进行传递到我们的后台，然后
		 * 	在后台可以通过这些标识，查询到我们选中的数据
		 */

		$("#saveActivityBtn").click(function () {
			//获取选中的市场活动
			var activityId = $("input[name=activity]:checked").val();

			//为隐藏域对象进行赋值
			$("#activityId").val(activityId);
			//获取我们选中标签的名称
			var activityName = $("#n_"+activityId).html();

			//将我们获取到的数据回显到我们的页面中，在我们市场活动源的文本框中进行显示
			$("#activity").val(activityName);


		})

		//TODO 05 对我们的线索进行转换，将线索转换为客户、联系人，如果创建了交易，那么交易也需要进行转换
		//点击我们转换按钮，我们需要为我们隐藏域中的是否选中交易的按钮进行赋值，
		// 另外两个隐藏域对象线索id和activityId已经赋值了，再我们进行表单提交的时候，数据会进行传递
		$("#exchange").click(function () {
			$("#flag").val(flag);
			//进行表单提交
			$("#exchangeClueForm").submit();
		})


	});
	function getRelationActivityList() {
		//发送ajax请求，根据我们的线索id，查询我们已经进行关联的数据
		$.ajax({
			url: "workbench/clue/getRelationActivityList.do",
			type: "POST",
			dataType:"json",
			data: {
				"clueId":"${clue.id}"
			},
			success: function(data){
				if (data.success){
					//数据查询成功,将查询到的数据进行遍历
					var html = "";
					$.each(data.aList,function (i,n) {
						html += '<tr>';
						html += '<td><input type="radio" value="'+n.id+'" name="activity"/></td>';
						html += '<td id="n_'+n.id+'">'+n.name+'</td>';
						html += '<td>'+n.startDate+'</td>';
						html += '<td>'+n.endDate+'</td>';
						html += '<td>'+n.owner+'</td>';
						html += '</tr>';
					})
					//将我们获取到的数据进行覆盖的操作
					$("#tbodyBtn").html(html);
					//打开模态窗口
					$("#searchActivityModal").modal("show");

				}else {
					alert(data.msg)
				}

			}
		});
	}

</script>

</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" id="search_activityName" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="tbodyBtn">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveActivityBtn" type="button" class="btn btn-primary" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${clue.fullname}${clue.appellation}-${clue.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${clue.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${clue.fullname}${clue.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >

		<%--我们在这里需要将我们选中的数据进行表单的提交--%>
		<form id="exchangeClueForm" method="post" action="workbench/clue/exchangeClueForm.do">

			<%--将我们的线索id存放在隐藏域中--%>
			<input type="hidden" id="clueId" name="clueId">

			<%--将我们的activityId保存到我们的隐藏域中--%>
			<input type="hidden" id="activityId" name="activityId">

			<%--在此处我们需要创建是否点击了交易按钮的表示--%>
			<input type="hidden" id="flag" name="flag">


		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="money" name="money">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" name="name">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control dateTime" autocomplete="off" readonly name="expected" id="expectedClosingDate">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage" name="stage" class="form-control">
		    	<option></option>
				<c:forEach items="${stageList}" var="sList">
					<option value="${sList.value}">${sList.text}</option>
				</c:forEach>
		    	<%--<option>资质审查</option>
		    	<option>需求分析</option>
		    	<option>价值建议</option>
		    	<option>确定决策者</option>
		    	<option>提案/报价</option>
		    	<option>谈判/复审</option>
		    	<option>成交</option>
		    	<option>丢失的线索</option>
		    	<option>因竞争丢失关闭</option>--%>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activity">市场活动源&nbsp;&nbsp;<a id="search_data" href="javascript:void(0);" data-toggle="modal" data-target="#searchActivityModal" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
		    <input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${clue.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input id="exchange" class="btn btn-primary" type="button" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="取消">
	</div>
</body>
</html>