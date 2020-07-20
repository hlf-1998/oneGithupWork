<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" contentType="text/html;charset=UTF-8" language="java" %>
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
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>


	<script type="text/javascript">

	$(function(){

		//年月日
		$(".dateTime").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});

		
		
		//TODO 01 在我们点击进入我们的线索主页面的时候，我们需要进行分页的操作，我们在这里调用分页的方法
		getPageList(1,5);

		//TODO 02 在这里我们通过模糊查询的方法，对我们数据进行查询的操作
		$("#clueLike").click(function () {
			//首先我们需要为隐藏域中的数据进行赋值的操作(这里是将我们在查询框输入的数据，在搜索的时候，先放入到隐藏域中)
			$("#hidden_fullname_appellation").val($.trim($("#fullname_appellation").val()));
			$("#hidden_company").val($.trim($("#company").val()));
			$("#hidden_mphone").val($.trim($("#mphone").val()));
			$("#hidden_phone").val($.trim($("#phone").val()));
			$("#hidden_source").val($.trim($("#source").val()));
			$("#hidden_state").val($.trim($("#state").val()));

			//我们在这里调用分页的方法，将我们所要查询的数据进行传递，并且，还需要进行分页的操作
			getPageList(1,5);


		})

		//TODO 03 点击新建的按钮后，我们首先需要获取到我们页面中需要的数据，然后再打开我们的模态窗口,因为我们窗口中现在只需要获取所有者的信息，其他的信息已经被我们获取了
		$("#saveBtn").click(function () {
			//我们把查询的方法，进行封装成方法，在此处我们直接调用即可
			getUserList();

		})

		//TODO 04 我们点击保存的按钮，然后我们首先需要对我们的数据进行校验
		$("#saveButton").click(function (i,n) {
			//在此处我们增加的方法可以进行封装，在调用方法的时候，对其进行我们的判断操作
				saveButtonClue();

		})

		//对数据库中的数据进行增加的操作
		function saveButtonClue() {
			//我们需要对表单中的一些数据进行校验的操作
			if ($("#create-company").val() == '' || $("#create-fullname").val() == ''){
				alert("公司和名字都不能为空，需要您进行填写！！！")
				return;
			}

			//对增加页面中所有的数据进行获取的操作
			var fullname = $.trim($("#create-fullname").val());
			var appellation = $.trim($("#create-appellation").val());
			var owner = $.trim($("#create-owner").val());
			var company = $.trim($("#create-company").val());
			var job = $.trim($("#create-job").val());
			var email = $.trim($("#create-email").val());
			var phone = $.trim($("#create-phone").val());
			var website = $.trim($("#create-website").val());
			var mphone = $.trim($("#create-mphone").val());
			var state = $.trim($("#create-state").val());
			var source = $.trim($("#create-source").val());
			var description = $.trim($("#create-description").val());
			var contactSummary = $.trim($("#create-contactSummary").val());
			var nextContactTime = $.trim($("#create-nextContactTime").val());
			var address = $.trim($("#create-address").val());

			//发送ajax请求，将我们的数据向后端进行传递
			$.ajax({
				url: "workbench/clue/saveClue.do",
				type: "POST",
				dataType:"json",
				data: {
					"fullname":fullname,
					"appellation":appellation,
					"owner":owner,
					"company":company,
					"job":job,
					"email":email,
					"phone":phone,
					"website":website,
					"mphone":mphone,
					"state":state,
					"source":source,
					"description":description,
					"contactSummary":contactSummary,
					"nextContactTime":nextContactTime,
					"address":address
				},
				success: function(data){
					if (data.success){
						//增加成功
						//增加成功之后，我们需要将表单的数据进行清空
						$("#cleanForm")[0].reset();
						//关闭模态窗口
						$("#createClueModal").modal("hide");
						getPageList(1,5);
					}
				}
			});



		}

		//TODO 05 正选和反选

		//正选
		$("#selectAll").click(function () {
			//将所有的复选框，进行选中/取消操作
			$("input[name=flag]").prop("checked", $("#selectAll").prop("checked") )
		})

		//反选
		//获取tbody对象，操作的是它里面的子标签，给它的子标签绑定事件
		//参数1，事件的名称
		//参数2，绑定的对象，一个或多个
		//执行事件的回调方法
		$("#tbodyBtn").on("click",$("input[name=flag]"),function () {

			//反选操作，当复选框全部选中，将全选按钮，自动勾选。
			$("#selectAll").prop(
					"checked",
					$("input[name=flag]").length == $("input[name=flag]:checked").length
			)

		})

		//TODO 06 点击删除的按钮,对我们选中的数据进行我们的删除操作
		$("#deleteBtn").click(function () {

			if (confirm("您确定需要删除此数据吗？")){

			}
			//我们需要对选中的东西进行校验
			var flags = $("input[name=flag]:checked");
			if (flags.length == 0){
				alert("请至少选中一条需要删除的数据！！！");
				return;
			}
			//获取我们选中数据的id
			var clueId = "?";

			$.each(flags,function (i,n) {
				clueId += "clueId=" + $(n).val();
				if (i < flags.length - 1){
					clueId += "&";
				}
			})
			//alert(clueId)
			//发送ajax请求，将我们的获取到需要删除的id向我们的后台进行传递，然后进行我们的删除操作
			$.ajax({
				url: "workbench/clue/deleteClueById.do"+clueId,
				type: "POST",
				dataType:"json",
				data: {},
				success: function(data){
					if (data.success){
						//删除成功，跳转到当前页
						getPageList(
								$("#clueDiv").bs_pagination('getOption', 'currentPage'),
								$("#clueDiv").bs_pagination('getOption', 'rowsPerPage')
						)
					}else {
						alert(data.msg)
					}
				}
			});

		})




		//查询我们所有者的方法
		function getUserList() {
			//我们直接发送ajax请求进行我们的查询
			$.ajax({
				url: "workbench/clue/getUserList.do",
				type: "post",
				dataType:"json",
				data: {},
				success: function(data){
					if (data.success){
						//查询成功
						var html = "";

						$.each(data.uList,function (i,n) {

							html += "<option value="+n.id+">"+n.name+"</option>";

						})
						//局部刷新我们的下拉框
						$("#create-owner").html(html);

						//默认选中当前的用户
						$("#create-owner").val('${user.id}');

						//打开模态窗口
						$("#createClueModal").modal("show");
					}

				}
			});
		}
		
		//TODO  分页查询的方法
		function getPageList(pageNo,pageSize) {
			//我们需要发送ajax请求，刷新列表
			//我们需要计算出当前页的页码
			var pageIndex = (pageNo - 1) * pageSize;

			//在此处我们需要将我们查询的数据进行传递到我们的后台，进行模糊查询
			var fullname_appellation = $("#hidden_fullname_appellation").val();
			var company = $("#hidden_company").val();
			var mphone = $("#hidden_mphone").val();
			var phone = $("#hidden_phone").val();
			var source = $("#hidden_source").val();
			var state = $("#hidden_state").val();

			$.ajax({
				url: "workbench/clue/getPageList.do",
				type: "POST",
				dataType:"json",
				data: {
					"pageIndex":pageIndex,
					"pageSize":pageSize,
                    //将我们保存在作用域中的id进行传递
                    "userId":"${user.id}",

					//将需要查询的数据进行传递
					"fullname_appellation":fullname_appellation,
					"company":company,
					"mphone":mphone,
					"phone":phone,
					"source":source,
					"state": state

				},
				success: function(data){

					if (data.success){

						//我们需要将获取的数据进行循环遍历，然后进行拼接
						var html = "";
						$.each(data.cList,function (i,n) {
							html += '<tr>';
							html += '<td><input name="flag" value='+n.id+' type="checkbox" /></td>';
							//																onclick="window.location.href=\'workbench/activity/toDetail.do?id='+n.id+'\';">'+n.name+'</a></td>';
							html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/toClueDetail.do?id='+n.id+'\';">'+n.fullname+n.appellation+'</a></td>';
							html += '<td>'+n.company+'</td>';
							html += '<td>'+n.phone+'</td>';
							html += '<td>'+n.mphone+'</td>';
							html += '<td>'+n.state+'</td>';
							html += '<td>'+n.owner+'</td>';
							html += '<td>'+n.source+'</td>';
							html += '</tr>';
						})
						$("#tbodyBtn").html(html);

						//我们需要计算出我们的总页数用于分页操作
						var totalPage = data.total % pageSize == 0 ? (data.total / pageSize) : parseInt((data.total / pageSize) + 1)

						//加载分页插件
						$("#clueDiv").bs_pagination({
							currentPage: pageNo, // 页码
							rowsPerPage: pageSize, // 每页显示的记录条数
							maxRowsPerPage: 20, // 每页最多显示的记录条数
							totalPages: totalPage, // 总页数
							totalRows: data.total, // 总记录条数

							visiblePageLinks: 3, // 显示几个卡片

							showGoToPage: true,
							showRowsPerPage: true,
							showRowsInfo: true,
							showRowsDefaultInfo: true,

							onChangePage : function(event, data){
								getPageList(data.currentPage , data.rowsPerPage);
							}
						});


					}else {
						//请求失败
						alert(data.msg)
					}
				}
			});

		}
		
		
	});
	
</script>
</head>
<body>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="cleanForm" role="form">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select  class="form-control" id="create-owner">

								  <%--<option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>--%>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation" name="appellation">
								  <option></option>
									<%--在此处我们需要通过el表达式，获取数据--%>
									<c:forEach items="${appellationList}" var="aList">
										<option value="${aList.value}">${aList.text}</option>
									</c:forEach>
								  <%--<option>先生</option>
								  <option>夫人</option>
								  <option>女士</option>
								  <option>博士</option>
								  <option>教授</option>--%>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
								  <option></option>
									<c:forEach items="${clueStateList}" var="cList">
										<option value="${cList.value}">${cList.text}</option>
									</c:forEach>
								  <%--<option>试图联系</option>
								  <option>将来联系</option>
								  <option>已联系</option>
								  <option>虚假线索</option>
								  <option>丢失线索</option>
								  <option>未联系</option>
								  <option>需要条件</option>--%>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
									<c:forEach items="${sourceList}" var="sList">
										<option value="${sList.value}">${sList.text}</option>
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
						</div>
						

						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control dateTime" id="create-nextContactTime" autocomplete="off" readonly>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="saveButton" class="btn btn-primary" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">
								  <option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
								  <option></option>
								  <option selected>先生</option>
								  <option>夫人</option>
								  <option>女士</option>
								  <option>博士</option>
								  <option>教授</option>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" value="李四">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
								  <option></option>
								  <option>试图联系</option>
								  <option>将来联系</option>
								  <option selected>已联系</option>
								  <option>虚假线索</option>
								  <option>丢失线索</option>
								  <option>未联系</option>
								  <option>需要条件</option>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
								  <option selected>广告</option>
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
								  <option>聊天</option>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime" value="2017-05-01">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="fullname_appellation">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text" id="company">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="source">
					  	  <option></option>
						  <c:forEach items="${sourceList}" var="s" >
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
					  	 <%-- <option>广告</option>
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
				  </div>
				  
				  <br>
				  
				  <%--<div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text">
				    </div>
				  </div>--%>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text" id="mphone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="state">
					  	<option></option>
						  <c:forEach items="${clueStateList}" var="c">
							  <option value="${c.value}">${c.text}</option>
						  </c:forEach>
					  	<%--<option>试图联系</option>
					  	<option>将来联系</option>
					  	<option>已联系</option>
					  	<option>虚假线索</option>
					  	<option>丢失线索</option>
					  	<option>未联系</option>
					  	<option>需要条件</option>--%>
					  </select>
				    </div>
				  </div>

				  <button type="button" id="clueLike" class="btn btn-default">查询</button>

					<%--在这里我们设置隐藏域的对象存放位置，是因为我们的查询的时候，
					我们需要通过我们点击查询之后，我们在查询框中输入的内容才可以被我们所查询
					--%>
					<input type="hidden" id="hidden_fullname_appellation">
					<input type="hidden" id="hidden_company">
					<input type="hidden" id="hidden_phone">
					<input type="hidden" id="hidden_source">
					<input type="hidden" id="hidden_mphone">
					<input type="hidden" id="hidden_state">

				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="saveBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editClueModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="selectAll" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="tbodyBtn">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a></td>
							<td>动力节点</td>
							<td>010-84846003</td>
							<td>12345678901</td>
							<td>广告</td>
							<td>zhangsan</td>
							<td>已联系</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a></td>
                            <td>动力节点</td>
                            <td>010-84846003</td>
                            <td>12345678901</td>
                            <td>广告</td>
                            <td>zhangsan</td>
                            <td>已联系</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 60px;">
				<%--在此处我们设置一个标签，用于放入分页的插件--%>
				<div id="clueDiv"></div>
				<%--<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>--%>
			</div>
			
		</div>
		
	</div>
</body>
</html>