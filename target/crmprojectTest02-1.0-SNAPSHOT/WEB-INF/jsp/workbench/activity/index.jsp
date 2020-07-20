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




		//TODO 01、点击创建按钮，打开新增的模态窗口
		$("#saveBtn").click(function () {

			//打开模态窗口
			//$("#createActivityModal").modal("show");

			//我们需要使用ajax局部刷新html代码，获取用户列表
			//在本模块下获取用户列表的url：workbench/activity/getUserList.do
			$.ajax({

				url: "workbeach/activity/getUserList.do",
				type: "get",
				data: {},
				dataType:"json",
				success: function(data){

					if (data.success){
						//返回的结果为true，那么说明查询到了结果
						//使用ajax发送异步请求，局部刷新页面数据
						//通过字符串拼接html代码加载
						var html = "";

						//通过循环遍历出集合中的数据，然后将其进行拼接的操作
						$.each(data.uList,function (i,n) {
							html += "<option value="+n.id+">"+n.name+"</option>";
						})

						//将拼接好的字符串插入到servlet中
						$("#create-userOwner").html(html);

						//默认选中当前登录的用户
						//在js代码中获取session中的属性值可以直接使用el表达式即可，必须把字符串套起来
						$("#create-userOwner").val("${user.id}");

						//打开模态窗口
						$("#createActivityModal").modal("show");
					}else{
						//返回结果为false，说明没有查询到结果
						alert(data.msg)
					}
				}
			});
		})



		//TODO 03、提交市场活动的表单
		//在点击按钮之后，我们需要对其进行判断的操作
		$("#saveModelBtn").click(function () {


			//1、需要判断名称是否为空，如果为空，那么则无法进行提交，需要对用户进行提示
			if ($("#create-marketActivityName").val() == ""){
				alert("名称不能为空！！！");
				return;
			}

			//发送ajax请求
			$.ajax({
				url: "workbeach/activity/saveActivityAll.do",
				type: "POST",
                dataType: "json",
				data: {
                    "owner":$("#create-userOwner").val(),
                    "name":$.trim($("#create-marketActivityName").val()),
                    "startDate":$.trim($("#create-startTime").val()),
                    "endDate":$.trim($("#create-endTime").val()),
                    "cost":$.trim($("#create-cost").val()),
                    "description":$.trim($("#create-describe").val())
                },
				success: function(data){
					if (data.success){
					    //增加成功就跳转到市场活动的首页
                        //window.location.href = "workbeach/activity/toActivityIndex.do"
						//当点击创建时，当新增完成后，会再次调用页面刷新的方法
						getPageList(1,5)
                    }else {
					    //未增加成功给用户提示
                        alert(data.msg)
                    }
				}
			});

		})

		//TODO 04、点击市场活动后需要加载的页面列表
		getPageList(1,4);

		//TODO 05、这是一个分页查询的方法，作为我们点击市场活动后的主页面显示
		//我们需要将我们的开始页面和每页的总页面进入传入，可以在其他地方对其进行调用设置
		function getPageList(pageNo,pageSize) {
			//我们需要发送ajax请求，刷新我们的列表，对分页进行设置的操作
			//注意：正常的查询，少量条件情况下可以使用get请求的方式，如果条件过多使用post请求方式
			//js里面可以不使用双引号，但是后面由于我们需要使用的工具，必须有双引号，需要严格区分json格式

			//我们需要对当前页进行计算，算出查询页码的索引值
			//1、我们登录后，点击市场活动，我们需要发送参数：登录用户的id，当前页的页码，每页的总条数，返回到数据库对我们的页面进行查询的操作
			var pageNoIndex = ((pageNo - 1) * pageSize);

			//2、获取我们需要进行查询的参数，然后我们通过以下ajax请求进行传递，通过模糊查询到我们想要的数据,
			// 我们在这里需要获取我们隐藏域中的数据进行查询的操作，不然在我们点击其他地方的时候，因为我们
			// onChangePage方法会在我们未点击查询的时候，进行查询的操作
			var name = $.trim($("#hidden-name").val());
			var startDate = $("#hidden-startDate").val();
			var endDate = $("#hidden-endDate").val();

			//

				$.ajax({
					url: "workbeach/activity/getPageList.do",
					type: "POST",
					dataType:"json",
					data: {
						"pageNo":pageNoIndex,
						"pageSize":pageSize,
						"userId":"${user.id}",
						"name":name,
						"startDate":startDate,
						"endDate":endDate
					},
					success: function(data){
						if (data.success){
							//数据查询成功，我们需要加载列表
							//定义一个html标签，用于拼接html标签
							var html = "";
							//将我们获取到的数据进行遍历，这里的n是activity对象
							$.each(data.aList,function (i,n) {
								html += "<tr class='active'>";
								//复选框需要进行name设值，可以进行批量操作
								html += "<td><input name='flag' type='checkbox' value="+n.id+" /></td>";
								//在此处我们通过点击我们的名称需要进行跳转的操作，跳转的时候，我们需要携带我们的id数据到controller进行跳转，再进行传递查询
								html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbeach/activity/toDetail.do?id='+n.id+'\';">'+n.name+'</a></td>';
								//html += "<td><a style='text-decoration: none; cursor: pointer;' onclick='window.location.href=\'workbeach/activity/toDetail.do?id="+n.id+"\';'>"+n.name+"</a></td>";
								html += "<td>"+n.owner+"</td>";
								html += "<td>"+n.startDate+"</td>";
								html += "<td>"+n.endDate+"</td>";
								html += "</tr>"
							})

							//加载html
							$("#tbodyBtn").html(html)



							//计算总页数：总页数 = 总记录数/每页条数
							//当我们的  总记录数/每页条数有余数时，我们需要多增加一个页面显示多余的数据
							var totalPages = data.total % pageSize == 0 ? (data.total / pageSize) : parseInt((data.total / pageSize)+1)

							//加载分页的插件
							$("#activityPage").bs_pagination({
								currentPage: pageNo, // 页码
								rowsPerPage: pageSize, // 每页显示的记录条数
								maxRowsPerPage: 20, // 每页最多显示的记录条数
								totalPages: totalPages, // 总页数
								totalRows: data.total, // 总记录条数

								visiblePageLinks: 5, // 显示几个卡片

								showGoToPage: true,
								showRowsPerPage: true,
								showRowsInfo: true,
								showRowsDefaultInfo: true,


								//当加载分页插件时，当页码发生了变化（页码被点击了），会回调onChangePage方法，该方法会重新调用加载列表的方法
								onChangePage : function(event, data){

									getPageList(data.currentPage , data.rowsPerPage);
								}
							});
						}else {
							alert(data.msg)
						}
					}
				});


		}

		//TODO 06、模糊查询
		$("#selectBtn").click(function () {

			//我们需要将我们需要查询的数据存入到我们的隐藏域当中
			$("#hidden-name").val($.trim($("#name").val()));
			$("#hidden-startDate").val( $("#startTime").val());
			$("#hidden-endDate").val( $("#endTime").val());


			getPageList(1,4)
		})

		//TODO 06、全选和反选
		$("#selectAll").click(function () {

			$("input[name=flag]").prop("checked",$("#selectAll").prop("checked"))

		})
		//获取tbody对象，操作的是它里面的子标签，给它的子标签绑定事件
		//参数1，事件的名称
		//参数2，绑定的对象，一个或多个
		//执行事件的回调方法
		$("#tbodyBtn").on("click",$("input[name=flag]"),function () {
			// alert("hello world")
			//反选操作，当复选框全部选中，将全选按钮，自动勾选。
			$("#selectAll").prop(
					"checked",
					$("input[name=flag]").length == $("input[name=flag]:checked").length
			)

		})

		//TODO 07、通过我们复选框选中的值，获取到他的id，通过id的值，进行传递，最后将数据给删除掉
		$("#deleteBtn").click(function () {

			//我们首先需要判断是否有选中复选框，如果没有选中复选框，那么我们将无法进行以下的操作
			var flags = $("input[name=flag]:checked");
			if (flags.length == 0){
				alert("请至少选中一条需要进行删除的数据")
			}else {
				//使用ajax发送请求，将我们复选框选中的数据进行传递，然后对数据进行删除的操作
				var activityId = "?";
				//获取选中复选框的id值，然后通过循环，将对其进行拼接的操作
				$.each(flags,function (i,n) {
					activityId += "activityId=" + $(n).val();
					if (i < flags.length - 1){
						activityId += "&";
					}
				})


				$.ajax({
					url: "workbeach/activity/deleteActivityById.do"+activityId,
					type: "POST",
					dataType:"json",
					data: {},
					success: function(data){
						if (data.success){
							getPageList(
									$("#activityPage").bs_pagination('getOption', 'currentPage'),
									$("#activityPage").bs_pagination('getOption', 'rowsPerPage')
							)
						}else {
							alert(data.msg)
						}
					}
				});
			}
		})


		//TODO 08 点击修改打开模态窗口
		$("#updateBtn").click(function () {

			var flags = $("input[name=flag]:checked");
			//校验我们选中的对象，如果选中的对象不是一个的话，需要给用户进行提示的操作
			if (flags.length > 1 || flags.length == 0){
				//我们需要给用户进行提示的操作
				alert("修改时只能选择一个需要修改的数据！！！")
				return;
			}

			//如果不执行以上if语句，那么说明我们现在的选中的就是一条数据，此时我们就可以发送ajax的请求
			//在这里我们先通过我们复选框选中的数据，然后获取他的id值，然后通过id的值去数据库中进行查询
			// 然后将查询到的数据把它显示在我们的页面中
			//alert(flags.val()):里面存储的就是我们的id值
			$.ajax({
				url: "workbeach/activity/saveActivityById.do",
				type: "get",
				dataType:"json",
				data: {
					"id":flags.val()
				},
				success: function(data){
					var activity = data.aty;

					if (data.success){
						//在我们获取到我们当前选中复选框的数据之后，我们获取得到的只是我们的其他数据，
						// 但是我们的下拉框中，现在需要获取到我们数据库中所有所有者的信息，此时我们需要在
						//获取成功之后，再次发送ajax请求，数据库中所有者的信息
						$.ajax({

							//在此处我们可以使用我们之前在创建的时候，获取下拉框数据的方法进行获取
							url: "workbeach/activity/getUserList.do",
							type: "get",
							dataType:"json",
							data: {},
							success: function(data){



								if (data.success){
									//如果我们获取成功之后，我们需要将我们获取到的数据为我们修改的模态窗口进行赋值操作
									//首先我们先为我们的下拉框进行赋值的操作
									var html = "";
									$.each(data.uList,function (i,n) {
										html += "<option value="+n.id+">"+n.name+"</option>"
									})
									//将我们的html对我们的option进行覆盖
									$("#edit-owner").html(html);
									//我们需要将我们修改时候的唯一标识id保存到我们的隐藏域中进行保存的操作
									$("#hidden-id").val(activity.id);

									//默认选中我们的当前用户
									$("#edit-owner").val("${user.id}");

									//为其他的属性进行赋值
									$("#edit-marketActivityName").val(activity.name);
									$("#edit-startTime").val(activity.startDate);
									$("#edit-endTime").val(activity.endDate);
									$("#edit-cost").val(activity.cost);
									$("#edit-describe").val(activity.description);


									//在进行以上所有的操作之后，我们打开模态窗口
									$("#editActivityModal").modal("show");

								}
							}
						});
					}else{
						//如果没有查询到用户的信息,则需要给用户进行提示
						alert("查询失败，没有查询到任何的信息！！！")
					}
				}
			});
		})

		//TODO 09、对模态窗口中的内容进行修改的操作
		$("#updateModalBtn").click(function () {
			//在点击更新的按钮后，我们需要进行判断名称是否有值
			if ($("#edit-marketActivityName").val() == ''){
				alert("修改不能让名称的值为空！！！");
				return;
			}
			//我们发送ajax请求，将我们修改后的数据发送后台进行修改的操作
			$.ajax({
				url: "workbeach/activity/deleteActivity.do",
				type: "POST",
				dataType:"json",
				data: {
					//将我们获取到的数据进行传递回我们的后台
					"id":$("#hidden-id").val(),
					"owner":$.trim($("#edit-owner").val()),
					"name":$.trim($("#edit-marketActivityName").val()),
					"startDate":$.trim($("#edit-startTime").val()),
					"endDate":$.trim($("#edit-endTime").val()),
					"cost":$.trim($("#edit-cost").val()),
					"description":$.trim($("#edit-describe").val())

				},
				success: function(data){
					if (data.success){
						//更新成功之后，我们关闭模态窗口，刷新页面
						$("#editActivityModal").modal("hide");

						//清空表单的数据
						$("#edit-form").reset();

						//更新后跳转回修改的页面
						getPageList(
								$("#activityPage").bs_pagination('getOption', 'currentPage'),
								$("#activityPage").bs_pagination('getOption', 'rowsPerPage')
						)
					}else {
						//更新失败，给客户提示
						alert(data.msg)
					}
				}
			});
		})

		//TODO 10、点击批量导出的按钮，将我们数据库表中的数据进行导出的操作
		$("#exportActivityAllBtn").click(function () {
			//在我们点击批量导出的按钮后，会在后台进行批量导出的操作
			window.location.href = "workbeach/activity/exportActivityAll.do";

		})


		//TODO 11、点击选择导出的按钮，将我们数据库中的数据根据id的值，进行导出的操作
		$("#exportActivityXzBtn").click(function () {
			//选择我们需要导出数据的复选框
			//我们首先要进行校验，是否有选中我们的数据
			var flags = $("input[name=flag]:checked");
			if (flags.length == 0){
				//如果用户没有选中任何一条数据的话，我们就需要对用户进行提示的操作
				alert("请您至少选中一条需要导出的数据！！！");
				return;
			}
			var param = "?";
			//循环遍历我们复选框选中的数据,然后进行拼接的操作
			$.each(flags,function (i,n) {
				param += "ids=" + $(n).val();
				if (i < flags.length - 1){
					param += "&";
				}
			})

			//使用href的方法，将我们的数据传递到我们的后台
			window.location.href = "workbeach/activity/exportActivityXzBtn.do"+param;

			//取消我们的选中状态
			$("input[name=flag]").prop("checked",false);

		})



		//TODO 11、上传我们的Excel的数据到我们的数据库中，Excel导入数据库中
		//前端页面已经可以直接打开我们模态窗口，在我们进入模态窗口后选择需要进行导入的文件后，点击上传的时候，判断文件的后缀名和文件的大小
		$("#importActivityBtn").click(function () {
			//首先判断文件的后缀名是否为.xls,获取点击按钮之后得到的数据的文件名
			var pathName = $("#activityFile").val();
			//对获取到的文件名进行截取的操作，获取到它的文件名后缀
			var suffix = pathName.substring(pathName.lastIndexOf(".")+1);
			if (suffix != "xls"){
				alert("只能选择上传xls文件！！！");
				return;
			}
			//判断上传文件的大小，如果上传的文件大于5M，则无法上传
			var size = $("#activityFile")[0].files[0].size;

			if (size < 1024 * 1024 * 5){
				//可以上传
				//将我们上传的参数使用formDate进行封装
				var formData = new FormData();
				formData.append("myFile",$("#activityFile")[0].files[0]);

				//发送ajax请求，将我们选中的文件进行ajax请求的发送
				$.ajax({
					url: 'workbeach/activity/importActivity.do',
					data: formData,
					type: 'post',
					// 主要是配合contentType使用的,默认情况下,
					// ajax把所有数据进行applciation/x-www-form-urlencoded编码之前,
					// 会把所有数据统一转化为字符串;把proccessData设置为false,可以阻止这种行为.
					processData: false,
					// 默认情况下,ajax向服务器发送数据之前,
					// 把所有数据统一按照applciation/x-www-form-urlencoded编码格式进行编码;
					// 把contentType设置为false,能够阻止这种行为.
					contentType: false,
					success: function (data) {
						//data : {success: true/false ,msg:xxx}
						if (data.success) {

							//提示导入数据成功
							alert("数据导入成功");

							//关闭模态窗口
							$("#importActivityModal").modal("hide");

							//刷新列表
							getPageList(1,5);

						}else {
							//导入数据失败
							alert("数据导入失败！！！")
						}
					}
				});

			}else {
				alert("文件过大无法上传，请选择5M以下的文件")
			}
		})
		

	});
	
</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-userOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div  class="col-sm-10" style="width: 300px;">
								<select  class="form-control" id="create-userOwner">
									<%--在这里使用ajax发送异步请求，无法通过el表达式进行页面的取值--%>
								  <option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>
								</select>

							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">

                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<%--需要关闭自动提示，只有只读功能，并且需要引入时间控制样式--%>
								<input type="text" readonly autocomplete="off" class="form-control dateTime" id="create-startTime">
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" readonly autocomplete="off" class="form-control dateTime" id="create-endTime">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<%--在点击保存按钮后我们需要对其进行校验后才能进行提交--%>
					<button id="saveModelBtn" type="button" class="btn btn-primary" data-dismiss="modal">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" id="edit-form" role="form">

						<%--将我们的唯一标识id，存储在隐藏域中，隐藏域的位置写在我们的表单中--%>
						<input type="hidden" id="hidden-id"/>

						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" name="owner" id="edit-owner">

								</select>
							</div>
                            <label for="edit-marketActivityName"  class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" name="name" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label dateTime" >开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control dateTime" readonly autocomplete="off" name="startDate" id="edit-startTime" value="2020-10-10">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label dateTime" readonly >结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control dateTime" readonly autocomplete="off" name="endDate" id="edit-endTime" value="2020-10-20">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="cost" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" name="description" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button id="updateModalBtn" type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls格式]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
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
				      <input id="name" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <%--<div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="owner" class="form-control" type="text">
				    </div>
				  </div>--%>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control dateTime" readonly autocomplete="off" type="text" id="startTime" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control dateTime" readonly autocomplete="off" type="text" id="endTime">
				    </div>
				  </div>

					<%--在我们这里点击查询后，我们可以跟随我们分页查询进行传递数据进行查询--%>
				  <button id="selectBtn" type="button" class="btn btn-default">查询</button>

					<%--隐藏域，用来存储我们的查询的数据--%>
                    <input type="hidden" id="hidden-name" />
                    <input type="hidden" id="hidden-startDate" />
                    <input type="hidden" id="hidden-endDate" />


				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
					<%--
						BootStarp提供的模态窗口：
									通过点击事件控制，打开模态窗口/关闭模态窗口
									相比于jsp页面，风格更好看，无需更多的jsp页面

						通过点击事件来控制模态窗口是非常简单

						在打开或者关闭模态窗口时，可以通过标签中的属性进行控制，也可以通过js代码进行控制
						data-toggle="modal"：设置当前为打开模态窗口
						data-target="#createActivityModal" ：打开目标的模态窗口，模态窗口的id
						$("#createActivityModal").modal("show/hide")：打开或者关闭模态窗口
					--%>
				  <button id="saveBtn" type="button" class="btn btn-primary" ><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="updateBtn" type="button" class="btn btn-default" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="deleteBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button id="importActivityButton" type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="selectAll" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="tbodyBtn">
					<%--方式一：此种方法通过el表达式传递过来的数据--%>
						<%--<c:forEach items="${ayList}" var="al" >
							<tr class="active">
								<td><input type="checkbox" /></td>
								<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">${al.name}</a></td>
								<td>${al.owner}</td>
								<td>${al.startDate}</td>
								<td>${al.endDate}</td>
							</tr>
						</c:forEach>--%>


					</tbody>
				</table>
			</div>

			<div id="activityPage"></div>
			
			<%--<div style="height: 50px; position: relative;top: 30px;">
				&lt;%&ndash;<div>
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
				</div>&ndash;%&gt;
			</div>--%>
			
		</div>
		
	</div>
</body>
</html>