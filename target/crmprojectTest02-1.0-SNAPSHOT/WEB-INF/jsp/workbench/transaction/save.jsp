<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" +
request.getServerName() + ":" + request.getServerPort() +
request.getContextPath() + "/";

	//从服务器缓存中获取阶段和可能性的集合
	Map<String,String> sMap = (Map<String, String>) application.getAttribute("sMap");

	//将他转换为前台的容器，json对象，json数组

%>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
	<script>
		$(function () {
			//TODO 01 加载时间样式
			loadDateTimePicker();

			//TODO 02 从我们的域对象中加载阶段，类型、来源的数据

			//TODO 03 对数据进行我们的自动补全
			autoCompletion();

			//TODO 04 加载阶段和可能性的数据
			//在这里我们从我们的方法中获取我们阶段和可能性的数据
			var json = loadStagePossibilityJsonData();

			//TODO 05 监听阶段的下拉框，加载对应的可能性数值，这里我们将我们获取到的阶段和可能性的json数据传递到我们的方法中，然后我们对其进行获取到我们页面中
			loadPossibilityByStage(json);

			//TODO 08 加载市场活动信息，将我们的市场活动的id存放到我们的隐藏域中
			loadActivitySource();


			//TODO 07加载联系人信息，把联系人的id存放到我们的隐藏域中

			//加载我们的数据，然后打开模态窗口
			loadContactsSourceOpen();

			//在联系人模态窗口中点击保存按钮，将数据进行提交到页面
			loadContactsSource();

			//TODO 08 点击保存按钮，新增交易记录/历史记录
			saveTranAndHistory();

		})

		//我们点击保存按钮，然后发送我们的请求，将我们表单中的数据进行post提交
		function saveTranAndHistory() {
			$("#saveTranBtn").click(function () {
				//必填字段的校验

				//获取form表单对象，提交
				$("#tranForm").submit();
			})
		}


		//点击联系人模态窗口中的保存按钮，然将数据进行回显操作
		function loadContactsSource() {
			$("#saveContactsBtn").click(function () {
				//获取复选框选中的id
				var contactsId = $("input[name=contacts]:checked").val();
				//获取联系人的姓名
				var contactsName = $("#c_"+contactsId).html();

				//将联系人名称回显到文本框中
				$("#create-contactsName").val(contactsName);

				//将联系人的id存放在隐藏域中
				$("#contactsId").val(contactsId);

				//关闭模态窗口
				$("#findContacts").modal("hide");

			})
		}

		//点击联系人名称搜索按钮，弹出模态窗口，并且去数据进行搜素模态窗口中需要的数据
		function loadContactsSourceOpen() {
			$("#search-contacts-icon").click(function () {
				//发送ajax请求，获取到联系人的信息，然后将其输出在联系人的模态窗口中
				$.ajax({
					url: "workbench/transaction/getContactsList.do",
					type: "POST",
					dataType: "json",
					data: {},
					success: function (data) {
						//请求成功
						//加载列表
						var html = "";

						$.each(data.cList, function (i, n) {
							html += '<tr>';
							html += '<td><input type="radio" value="' + n.id + '" name="contacts"/></td>';
							html += '<td id="c_' + n.id + '">' + n.fullname + '</td>';
							html += '<td>' + n.email + '</td>';
							html += '<td>' + n.mphone + '</td>';
							html += '</tr>';
						})
						//将我们的数据插入到我们父标签中
						$("#contactsTbody").html(html);

						//打开模态窗口
						$("#findContacts").modal("show");

					}
				});
			})

		}
		
		//我们点击保存按钮，将我们选中的数据进行获取并且加载到我们的页面中
		function loadActivitySource() {
			$("#saveActivityBtn").click(function () {
				//获取我们复选框选中的的id
				var activityId = $("input[name=activity]:checked").val();
				//通过我们的选中的id获取到我们选中数据的名称,这里的名称是文本信息，需要使用html获取
				var activityName = $("#n_"+activityId).html();
				//将市场活动进行回显（将我们的名称输出在我们市场活动源的文本框中，进行显示,这个是显示在文本框中的信息，我们需要使用val）
				$("#create-activitySrc").val(activityName);
				//将市场活动的id存放到隐藏域中
				$("#activityId").val(activityId);
				//将我们的模态窗口进行我们的关闭
				$("#findMarketActivity").modal("hide");
			})

		}

		//我们点击市场活动源的按钮，我们需要为市场活动源的搜索图标添加一个点击事件，然后会弹出模态窗口
		function loadActivitySourceOpen() {


				//我们发送ajax请求，获取到我们市场活动源的数据进行我们的显示
				$.ajax({
					url: "workbench/transaction/getActivityList.do",
					type: "post",
					dataType:"json",
					data: {},
					success: function(data){
						if (data.success){
							//请求成功
							//加载列表
							var html = "";

							$.each(data.aList,function (i, n) {
								html += '<tr>';
								html += '<td><input type="radio" name="activity" value="'+n.id+'"/></td>';
								html += '<td id="n_'+n.id+'">'+n.name+'</td>';
								html += '<td>'+n.startDate+'</td>';
								html += '<td>'+n.endDate+'</td>';
								html += '<td>'+n.owner+'</td>';
								html += '</tr>';
							})

							//将数据加载到我们的显示页面
							$("#actTbody").html(html);

							//打开模态窗口
							$("#findMarketActivity").modal("show");
						}

					}
				});

		}

		function loadPossibilityByStage(json) {
			//在这里获取到json数据，数据我们在本个jsp中，对其进行了获取并转换成我们json数据，
			// 然后传递到了这个方法中，在这里使用change事件，当我们对我们阶段的数据进行改变的时候，
			// 则会执行我们以下的方法
			$("#create-transactionStage").change(function () {
				//获取当前阶段的属性值
				var stage = $("#create-transactionStage").val();
				//根据我们key值，加载我们阶段对应可能性的值
				$("#create-possibility").val(json[stage]);

			})
		}

		//在这里我们对我们从我们properties中获取的数据先在我们script中进行我们的得获取操作，
		// 然后我们在这个方法中，将我们获取到的数据进行遍历操作，
		// 然后将获取到的数据组合到我们的json数据中，最后将我们获取到的值进行返回操作
		function loadStagePossibilityJsonData() {
			//将java中的集合对象
			var j = {
				<%

				//编写java代码
				Set<String> stringSet = sMap.keySet();
				for (String key : stringSet) {
				    String value = sMap.get(key);

				%>
				//编写js代码，组合成json数据
				"<%=key%>" : "<%=value%>",

				<%

                }

                %>
			}
			return j;

		}

		function autoCompletion() {
			$("#create-accountName").typeahead({
				//source，自动补全所指定的方法
				//query参数，输入的关键字
				//process参数，是js传递过来的方法，用它来将返回的数据显示在自动补全的地方。要求返回的结果是List<String>  --> [张三,李四....]
				//delay参数，查询执行毫秒数，每1.5秒执行一次请求，去查询结果
				source: function (query, process) {
					$.post(
							"workbench/transaction/getCustomerName.do",
							{ "name" : query },
							function (data) {
								//alert(data);
								process(data);
							},
							"json"
					);
				},
				delay: 500
			});


		}


		function loadDateTimePicker() {
			//年月日
			$(".dateTimeBottom").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});

			//年月日
			$(".dateTimeTop").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "top-left"
			});
		}

	</script>

</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="actTbody">
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

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contactsTbody">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="saveContactsBtn" type="button" class="btn btn-primary" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" id="saveTranBtn" class="btn btn-primary">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form id="tranForm" action="workbench/transaction/saveTran.do" method="post" class="form-horizontal" role="form" style="position: relative; top: -30px;">

		<%--我们将我们市场活动源的隐藏域设置在这里存放市场活动源的id--%>
		<input type="hidden" id="activityId" name="activityId">
		<%--联系人id存放在隐藏域中--%>
		<input type="hidden" id="contactsId" name="contactsId">

		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner" name="owner">
					<c:forEach items="${uList}" var="u">
						<%--在el表达式中也可以使用三目运算符对数据进行选择--%>
						<option value="${u.id}" ${u.id eq user.id ? "selected" : ""}>${u.name}</option>
					</c:forEach>
				  <%--<option>zhangsan</option>
				  <option>lisi</option>
				  <option>wangwu</option>--%>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney" name="money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName" name="name">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control dateTimeBottom" readonly autocomplete="off" id="create-expectedClosingDate" name="expectedDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<%--如果不点击搜索按钮，直接编写客户姓名，是可以在后台先查询如果没有，再新增客户--%>
				<input type="text" name="customerName" class="form-control" id="create-accountName" autocomplete="off" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-transactionStage" name="stage">
			  	<option></option>
				  <c:forEach items="${stageList}" var="st">
					  <option value="${st.value}">${st.text}</option>
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
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType" name="type">
				  <option></option>
					<c:forEach items="${transactionTypeList}" var="tt">
						<option value="${tt.value}">${tt.text}</option>
					</c:forEach>
				  <%--<option>已有业务</option>
				  <option>新业务</option>--%>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" readonly id="create-possibility" name="text" >
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource" name="source">
				  <option></option>
					<c:forEach items="${sourceList}" var="sl">
						<option ${sl.value}>${sl.text}</option>
					</c:forEach>
				  <%--<option>广告</option>
				  <option>推销电话</option>
				  <option>员工介绍</option>
				  <option>外部介绍</option>
				  <option>在线商场</option>
				  <option>合作伙伴</option>
				  <option>公开媒介</option>
				  <option>销售邮件</option>
				  <option>合作伙伴研讨会</option>
				  <option>内部研讨会</option>
				  <option>交易会</option>
				  <option>web下载</option>
				  <option>web调研</option>
				  <option>聊天</option>--%>
				</select>
			</div>

			<%--我们这里通过点击我们市场活动源的的搜索图标，然后会打开我们的模态窗口--%>
			<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" onclick="loadActivitySourceOpen()" ><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<%--我们需要将这文本框设置为只读，让其只能显示我们从模态窗口中选中的数据--%>
				<input type="text" class="form-control" readonly id="create-activitySrc">
			</div>
		</div>
		
		<div class="form-group">

			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a id="search-contacts-icon" href="javascript:void(0);"><span class="glyphicon glyphicon-search"></span></a></label>
			<%--在这里我们的联系人可能是新开发的客户，所以在当前的输入框中不能设置为只读--%>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-contactsName" name="contactsName">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe" name="description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary" name="contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control dateTimeTop" autocomplete="off" readonly id="create-nextContactTime" name="nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>