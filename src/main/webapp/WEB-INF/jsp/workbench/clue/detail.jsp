<!DOCTYPE html>
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
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});


		// TODO 01 发送ajax请求，展示线索备注列表和市场活动列表信息
		getActivityListAndClueRemarkList();


		//TODO 02.解决异步刷新市场详情列表的图标不显示问题
		//通过父id，添加实践鼠标捕获/鼠标移除的时间
		$("#remarkBody").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		})
		$("#remarkBody").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		})

		//TODO 03.新增我们备注列表的信息
		//点击保存按钮，对我们的备注数据进行新增
		$("#saveBtn").click(function () {
			//发送ajax请求对数据进行增加操作
			$.ajax({
				url: "workbench/clueRemark/saveClueRemark.do",
				type: "POST",
				dataType:"json",
				data: {
					//我们需要将我们在备注框中输入的信息以及我们从线索首页中我们通过链接点击进入的id
					"noteContent":$.trim($("#remark").val()),
					"clueId":"${c.id}"
				},
				success: function(data){
					if (data.success){
						//备注增加成功
						var clueRemarkHtml = "";
						clueRemarkHtml += '<div id="'+data.cr.id+'" class="remarkDiv" style="height: 60px;">';
						clueRemarkHtml += '<img title="${c.owner}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
						clueRemarkHtml += '<div style="position: relative; top: -40px; left: 40px;" >';
						//在noteContent中需要一个id，这样可以方便获取标签中的值
						clueRemarkHtml += '<h5 id="n_'+data.cr.id+'">'+data.cr.noteContent+'</h5>';
						clueRemarkHtml += '<font color="gray">线索</font> <font color="gray">-</font> <b>${c.fullname}${c.appellation}-${c.company}</b> <small style="color: gray;" id="s_'+data.cr.id+'"> '+ (data.cr.editFlag == "0" ? data.cr.createTime : data.cr.editTime) +'  由  '+ (data.cr.editFlag == "0" ? data.cr.createBy : data.cr.editBy) +'</small>';
						clueRemarkHtml += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						//对本条数据进行修改的按钮链接
						clueRemarkHtml += '<a onclick="openUpdateModal(\''+data.cr.id+'\')" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: green;"></span></a>';
						clueRemarkHtml += '&nbsp;&nbsp;&nbsp;&nbsp;';
						//对本条数据进行删除的按钮链接
						clueRemarkHtml += '<a onclick="deleteClueRemarkById(\''+data.cr.id+'\')" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: red;"></span></a>';
						clueRemarkHtml += '</div>';
						clueRemarkHtml += '</div>';
						clueRemarkHtml += '</div>';

						//将我们的语句放入到我们的标签上下方
						$("#reDiv").after(clueRemarkHtml);

					}else {
						alert(data.msg)
					}


				}
			});

		})

		//TODO 04 对未关联的数据进行查询
		//对市场活动进行关联操作，点击关联操作按钮后，打开模态窗口，并且将我们获取到未关联的数据传递到页面中
		$("#modal_relevance").click(function () {
			//调用查询未关联数据的方法
			getUnActivityListById();
		})


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
		$("#unTbody").on("click",$("input[name=flag]"),function () {

			//反选操作，当复选框全部选中，将全选按钮，自动勾选。
			$("#selectAll").prop(
					"checked",
					$("input[name=flag]").length == $("input[name=flag]:checked").length
			)

		})

		//TODO 06、对我们未关联的数据进行模糊查询
		$("#searchActivity").keydown(function (event) {
			// alert(event.keyCode)
			//当按下回车时，码值是13
			if (13 == event.keyCode) {
				//按下回车键之后会进行模糊查询,我们可以调用我们未进行关联的市场活动进行查询
				getUnActivityListById();
				return;
			}
		});

		//TODO 07、将模态窗口中的数据进行关联的操作，添加线索和市场活动的关系
		$("#addClueBtn").click(function () {
			//校验我们是否有选中数据
			var flags = $("input[name=flag]:checked");
			if (flags.length == 0){
				alert("请至少选中一条需要关联的数据")
				return;
			}
			//将选中的数据id，进行拼接，发送ajax请求，然后将模态窗口进行关闭
			var param = "?";
			$.each(flags,function (i,n) {
				param += "ids=" + $(n).val();
				if (i < flags.length - 1){
					param += "&";
				}
			})
			alert(param)
			//关系线索和市场活动的关系
			$.ajax({
				//发送ajax请求，将我们的数据向我们的后端进行传递
				url: "workbench/clue/addRelation.do"+param,
				data: {
					//还需要将我们主页链接id传递到后台
					"clueId":"${c.id}"
				},
				type: "post",
				dataType:"json",
				success: function(data){
					//data : { success:true/false , msg:xxx }
					if (data.success){

						//关联成功后，关掉模态窗口，刷新页面
						$("#bundModal").modal("hide");

						getActivityListAndClueRemarkList();
					}
				}
			});

		})


	});


	//TODO 08、点击解除按钮，解除市场活动关系
	function removeRelation(relationId) {

		//点击我们解除关联的按钮，会解除关联关系，但是在用户点击的时候，我们需要进行确认操作，防止用户的误操作
		if (confirm("您确定解除关系吗？")){
			//发送ajax请求，如果请求成功，刷新列表
			$.ajax({
				url: "workbench/clue/removeRelation.do",
				data: {
					"relationId":relationId
				},
				type: "post",
				dataType:"json",
				success: function(data){
					//data : { success: true/false, msg:xxx }
					if(data.success){
						//请求成功
						//刷新市场活动列表
						getActivityListAndClueRemarkList();
					}
				}
			});
		}

	}
	
	//点击转换按钮，对页面进行跳转操作，跳转至我们的转换页面
	function toClueConvert() {
		//我们需要将我们线索页面中的的一些数据进行传递到我们另一个页面
		window.location.href = "workbench/clue/toClueConvert.do?id=${c.id}&appellation=${c.appellation}&company=${c.company}&fullname=${c.fullname}&owner=${c.owner}"

	}

	//查询我们市场活动未进行关联的数据
	function getUnActivityListById() {

		//发送ajax请求，查询未关联的市场活动列表，未关联的线索和市场活动的关系
		$.ajax({
			url: "workbench/clue/getUnActivityListById.do",
			type: "get",
			dataType:"json",
			data: {
				//将我们需要进行获取未关联的id进行传递
				"clueId":"${c.id}",
				//我们将需要进行模糊查询的数据进行传递
				"name":$.trim($("#searchActivity").val())
			},
			success: function(data){
				//查询成功之后，我们异步更新模态窗口中的内容
				var html = "";

				$.each(data.actList,function (i,n) {
					html += '<tr>';
					html += '<td><input name="flag" value="'+n.id+'" type="checkbox"/></td>';
					html += '<td>'+n.name+'</td>';
					html += '<td>'+n.startDate+'</td>';
					html += '<td>'+n.endDate+'</td>';
					html += '<td>'+n.owner+'</td>';
					html += '</tr>';

				})
				//在父标签中插入我们的数据
				$("#unTbody").html(html);

				//打开模态窗口
				$("#bundModal").modal("show");
				return;

			}
		});
	}


	//根据我们的id删除我们选中的备注列表数据，在我们点击删除按钮之后
	function deleteClueRemarkById(id){
		//在我们点击删除按钮的时候，我们需要让用户进行确认是否将我们的数据进行删除的操作
		if (confirm("删除后数据无法恢复,是否确定删除？")){
			//发送ajax请求，将我们的数据进行删除的操作
			$.ajax({
				url: "workbench/clueRemark/deleteClueRemarkById.do",
				type: "get",
				dataType:"json",
				data: {
					"id":id
				},
				success: function(data){
					if (data.success){
						//删除成功，我们将页面中的标签信息进行删除操作
						$("#"+id).remove();
					}
				}
			});
		}
	}


		
	function getActivityListAndClueRemarkList() {
		//获取线索备注，根据线索id进行获取，一（线索）对多（线索备注）
		//市场活动列表，根据线索id获取，多对多
		$.ajax({
			url: "workbench/clue/getActivityListAndClueRemarkList.do",
			type: "POST",
			dataType:"json",
			data: {
				"clueId":"${c.id}"
			},
			success: function(data){
				//在此处我们需要返回的数据 data：{ success : true/false,msg : xxx ,crList : [] , aList : []}
				//异步刷新
				if (data.success){
					//查询成功，我们为页面的数据，进行赋值的操作
					var clueRemarkHtml = "";
					//显示当前备注信息页面
					$.each(data.crList,function (i,n) {
						clueRemarkHtml += '<div id="'+n.id+'" class="remarkDiv" style="height: 60px;">';
						clueRemarkHtml += '<img title="${c.owner}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
						clueRemarkHtml += '<div style="position: relative; top: -40px; left: 40px;" >';
						//在noteContent中需要一个id，这样可以方便获取标签中的值
						clueRemarkHtml += '<h5 id="n_'+n.id+'">'+n.noteContent+'</h5>';
						clueRemarkHtml += '<font color="gray">线索</font> <font color="gray">-</font> <b>${c.fullname}${c.appellation}-${c.company}</b> <small style="color: gray;" id="s_'+n.id+'"> '+ (n.editFlag == "0" ? n.createTime : n.editTime) +'  由  '+ (n.editFlag == "0" ? n.createBy : n.editBy) +'</small>';
						clueRemarkHtml += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						//对本条数据进行修改的按钮链接
						clueRemarkHtml += '<a onclick="openUpdateModal(\''+n.id+'\')" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: green;"></span></a>';
						clueRemarkHtml += '&nbsp;&nbsp;&nbsp;&nbsp;';
						//对本条数据进行删除的按钮链接
						clueRemarkHtml += '<a onclick="deleteClueRemarkById(\''+n.id+'\')" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: red;"></span></a>';
						clueRemarkHtml += '</div>';
						clueRemarkHtml += '</div>';
						clueRemarkHtml += '</div>';

					})
					//把这条内容重新插入会我们的数据中
					//我们需要将数据插入到我们同一目录中的上方
					$("#remarkDiv").before(clueRemarkHtml);


					//我们在这里需要为我们将获取到的数据，为市场活动进行赋值的操作
					var activityHtml = "";
					$.each(data.aList,function (i,n) {
						activityHtml += '<tr>';
						activityHtml += '<td>'+n.name+'</td>';
						activityHtml += '<td>'+n.startDate+'</td>';
						activityHtml += '<td>'+n.endDate+'</td>';
						activityHtml += '<td>'+n.owner+'</td>';
						//activityHtml += '<td><a href="javascript:void(0);" onclick="removeRelation(\''+n.relationId+'\')"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
						activityHtml += '<td><a href="javascript:void(0);" onclick="removeRelation(\''+n.relationId+'\')"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
						activityHtml += '</tr>';

					})

					//将我们的数据插入到tbody的字标签中
					$("#activityBody").html(activityHtml);

				}else {
					alert("未查询到数据！！！")
				}

			}
		});

	}



	
</script>

</head>
<body>

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="searchActivity" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input id="selectAll" type="checkbox"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="unTbody">
							<%--<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" id="addClueBtn" class="btn btn-primary" data-dismiss="modal">关联</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${c.fullname}${c.appellation} <small>${c.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="toClueConvert();"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.fullname}${c.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${c.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${c.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${c.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${c.editBy}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${c.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${c.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${c.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 40px; left: 40px;">
		<div id="reDiv" class="page-header">
			<h4>备注</h4>
		</div>
		
		<%--<!-- 备注1 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<%--<!-- 备注2 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="activityBody">
						<%--<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
						<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="modal_relevance" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>