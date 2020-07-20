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

		//TODO、01、我们需要使用方法发送ajax请求，异步获取我们备注信息的操作
		//根据市场活动的id进行查询
		getActivityRemarkList();

		//TODO、02、我们需要解决异步刷新详情列表不显示的问题
		//需要通过添加实践鼠标捕获，鼠标移除的时间
		$("#remarkBody").on("mouseover",".remarkDiv",function () {
			$(this).children("div").children("div").show();
		})
		$("#remarkBody").on("mouseout",".remarkDiv",function () {
			$(this).children("div").children("div").hide();
		})

		//TODO、03、新增市场活动备注详情
		//点击保存按钮后，发送ajax请求
		$("#saveBtn").click(function () {
			$.ajax({
				url: "workbench/activityRemark/saveActivityRemark.do",
				type: "POST",
				dataType:"json",
				data: {
					//我们需要将我们在文本框中输入的文本内容和页面中唯一标识activityId进行传递
					"noteContent":$.trim($("#remark").val()),
					"activityId":"${a.id}"
				},
				success: function(data){
					//清空市场活动列表

					if (data.success){

						var html = "";
						html += '<div id="'+data.ar.id+'" class="remarkDiv" style="height: 60px;">';
						html += '<img title="${a.owner}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
						html += '<div style="position: relative; top: -40px; left: 40px;" >';
						// 给noteContent添加一个id，在方法中获取标签中的值
						html += '<h5 id="n_'+data.ar.id+'" >'+data.ar.noteContent+'</h5>';
						html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${a.name}</b> <small style="color: gray;"> '+ (data.ar.editFlag == "0" ? data.ar.createTime : data.ar.editTime) +'  由  '+ (data.ar.editFlag == "0" ? data.ar.createBy : data.ar.editBy) +'</small>';
						html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						// href="javascript:void(0);"属性：不让它发送href请求操作，但是保持小手
						html += '<a onclick="openUpdateModal(\''+data.ar.id+'\')" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
						html += '&nbsp;&nbsp;&nbsp;&nbsp;';
						html += '<a onclick="deleteActivityRemarkById(\''+data.ar.id+'\')" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
						html += '</div>';
						html += '</div>';
						html += '</div>';

						//将备注信息插入到我们同级标签的下方
						$("#rDiv").after(html);
					}else {
						alert(data.msg)
					}

				}
			});
		})



	});

	//TODO 04、在这里我们需要根据我们市场活动的id，然后对我们的数据进行删除的操作
	function deleteActivityRemarkById(id) {

		//我们需要将这里获取的id，发送到我们的后台进行删除操作
		//在点击删除的时候，我们需要有弹出窗口，让用户是否确定要进行删除的操作
		if (confirm("数据删除无法恢复，是否执行操作！！！")){

			//发送ajax请求，将数据进行我们的传递
			$.ajax({
				url: "workbench/activityRemark/deleteActivityRemarkById.do",
				type: "get",
				dataType:"json",
				data: {
					"id":id
				},
				success: function(data){
					if (data.success){
						//删除成功
						//我们需要将页面中的标签信息进行删除操作
						$("#"+id).remove();
					}else{
						//删除失败
						alert(data.msg)
					}
				}
			});

		}

	}
	
	//TODO 05、获取修改备注信息
	/**
	 * 在我们点击我们备注修改信息后，我们首先要获取我们需要修改的文本数据，
	 * 然后我们将需要修改的数据，赋值到我们的页面中，我们在这里需要进行id的传递
	 * 因为我们在这里进行id的传递是为了，在我们将数据修改成功之后，我们需要将数据发送到后台
	 * 那么此时，这个id可以作为我们的唯一标识，不然后台无法判断我们到底需要对那个数据进行
	 * 我们修改的操作
	 */

	function openUpdateModal(id) {
		//属性的赋值操作
		/**
		 * 我们需要将在备注信息显示页面的id，在这里进行赋值操作，
		 * 然后我们将id数据保存到我们的隐藏域作用域进行传递，
		 * 因为我们在数据修改的时候，只需要显示我们的修改内容页面
		 */
		//向隐藏域中存入市场活动备注的id
		$("#activityRemarkId").val(id);

		//向文件本框中的内容进行赋值
		//val是获取value值的方法
		//html是获取标签中的文本信息
		$("#noteContent").val($("#n_"+id).html());

		//打开修改页面的模态窗口
		$("#editRemarkModal").modal("show");

		}

	//TODO 06、点击更新按钮后对备注信息进行修改的操作
	$(function () {

		$("#updateRemarkBtn").click(function () {
			//首先我们需要判断修改后的备注信息是否为空，如果备注信息为空，则需要给用户进行提示
			if ($("#noteContent").val() == ""){
				alert("修改的数据不能为空！！！")
				return;
			}

			//我们发送ajax请求，将我们的数据进行传递到我们后台进行修改的操作
			//我首先需要从隐藏域中获取我们的id
			var arId = $("#activityRemarkId").val();

			$.ajax({
				url: "workbench/activityRemark/updateActivityRemark.do",
				type: "POST",
				dataType:"json",
				data: {
					"id":arId,
					"noteContent":$("#noteContent").val()
				},
				success: function(data){
					//通过更新，返回修改后的数据，将我们的ar进行返回
					if (data.success){
						//修改成功，进行局部的更新
						//获取noteContent的h5标签对象
						$("#n_"+arId).html(data.ar.noteContent);

						//获取的是创建人/更新人，创建时间/更新时间的small标签对象
						$("#s_"+ arId ).html( data.ar.editTime + "  由  " +  data.ar.editBy);

						//将隐藏域中属性id进行清除
						$("#activityRemarkId").val("");

						//关闭模态窗口
						$("#editRemarkModal").modal("hide");
					}
				}
			});
		})

	})





	function getActivityRemarkList() {
		$.ajax({
			url: "workbench/activityRemark/toActivityRemarkControllerList.do",
			type: "get",
			dataType:"json",
			data: {
				//将我们Activity的id获取到后，去我们ActivityRemarkList中进行查询的操作，将查询到备注信息的结果进行返回
				"activityId":"${a.id}"
			},
			success: function(data){

				//异步刷新
				if (data.success){
					var html = "";
					$.each(data.arList,function (i, n) {

						html += '<div id="'+n.id+'" class="remarkDiv" style="height: 60px;">';
						html += '<img title="${a.owner}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
						html += '<div style="position: relative; top: -40px; left: 40px;" >';
						// 给noteContent添加一个id，在方法中获取标签中的值
						html += '<h5 id="n_'+n.id+'">'+n.noteContent+'</h5>';
						html += '<font color="gray">市场活动</font> <font color="gray">-</font> <b>${a.name}</b> <small style="color: gray;" id="s_'+n.id+'"> '+ (n.editFlag == "0" ? n.createTime : n.editTime) +'  由  '+ (n.editFlag == "0" ? n.createBy : n.editBy) +'</small>';
						html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						// href="javascript:void(0);"属性：不让它发送href请求操作，但是保持小手
						html += '<a onclick="openUpdateModal(\''+n.id+'\')" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
						html += '&nbsp;&nbsp;&nbsp;&nbsp;';
						html += '<a onclick="deleteActivityRemarkById(\''+n.id+'\')" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
						html += '</div>';
						html += '</div>';
						html += '</div>';

					})
					//我们在这里不能直接覆盖，因为我们其他的内容也会被覆盖,所以我们需要使用其他的方法
					//第一种：我们在同级标签的上方进行插入数据
					$("#remarkDiv").before(html);

					//第二种：我们在同级标签的下方进入插入数据
					//$("#rDiv").after(html);

				}else {
					alert(data.msg)
				}
			}
		});
	}


	
</script>

</head>
<body>
	
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改备注</h4>
                </div>
				<%--将我们的id属性保存在隐藏域中--%>
				<input type="hidden" id="activityRemarkId">
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
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
			<h3>市场活动-发传单 <small>2020-10-10 ~ 2020-10-20</small></h3>
		</div>
		
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${a.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${a.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${a.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${a.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${a.editBy};&nbsp;</b><small style="font-size: 10px; color: gray;">${a.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${a.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 30px; left: 40px;">
		<div id="rDiv" class="page-header">
			<h4>备注</h4>
		</div>
		
		<%--<!-- 备注1 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		
		<!-- 备注2 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
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
	<div style="height: 200px;"></div>
</body>
</html>