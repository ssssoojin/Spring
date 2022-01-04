<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<title>Get</title>
<%@include file="../includes/header.jsp"%>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<!-- 푸터에 있음 -->
<div id="page-wrapper">
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">BOARD GET</h1>
		</div>
		<!-- /.col-lg-12 -->
	</div>
	<!-- /.row -->
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">Board Get (게시글 조회)</div>
				<!-- /.panel-heading -->
				<div class="panel-body">

					<div class="form-group">
						<label>Bno</label><input class="form-control" name="bno"
							value='<c:out value="${board.bno}"/>' readonly="readonly">
					</div>
					<div class="form-group">
						<label>Title</label><input class="form-control" name="title"
							value='<c:out value="${board.title}"/>' readonly="readonly">
						<%-- <label>Title</label><input class="form-control" name="title" value="${board.title}"/> --%>
					</div>
					<div class="form-group">
						<label>Content</label>
						<textarea class="form-control" name="content" rows="3"
							readonly="readonly">${board.content}</textarea>
					</div>
					<div class="form-group">
						<label>Writer</label><input class="form-control" name="writer"
							value='<c:out value="${board.writer}"/>' readonly="readonly">
					</div>


					<%-- <button data-oper="modify" class="btn btn-default" onclick="location.href='/board/modify?bno=<c:out value="${board.bno}"/>'">Modify</button>
					<button data-oper="list" class="btn btn-default" onclick="location.href='/board/list'">List</button> --%>


					<!-- <button data-oper='modify' class="btn btn-outline btn-primary">Modify</button>
                  <button data-oper='list' class="btn btn-outline btn-success">List</button> -->
					<form id='operForm' action="/board/modify" method="get">
						<input type="hidden" id="bno" name="bno" value="${board.bno}">
						<input type="hidden" name="pageNum" value="${cri.pageNum}">
						<input type="hidden" name="amount" value="${cri.amount}">
						<input type="hidden" name="type" value="${cri.type}"> <input
							type="hidden" name="keyword" value="${cri.keyword}">

						<button data-oper="modify"
							class="btn btn-outline btn-primary btn-sm">Modify</button>
						<button data-oper="list" class="btn btn-outline btn-info btn-sm">List</button>
					</form>
				</div>
				<!-- /.panel-body -->
			</div>

			<!-- /.panel -->
		</div>
		<!-- /.col-lg-12 -->
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">
				<i class= "fa fa-comments fa-fw"></i>Reply <button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">New Reply</button>
			</div>
				<!-- /.panel-heading -->
				
				<div class="panel-body">
					<ul class="chat">
						<!-- start reply -->
						<li class="left clearfix" data-rno='12'>
							<div>
								<div class="header">
									<strong class="primary-font">user00</strong> <small
										class="pull-right text-muted">2021-05-18 13:13</small>
								</div>
								<p>Good job!</p>
							</div>
						</li>
						<!--  end reply -->
					</ul>
					<!--  ./end ul -->
				</div>
				<!-- /.row -->
				</div>
				</div>
<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
			</div>
			<div class="modal-body">
				<div class = "form-group">
					<label>Reply</label>
					<input class="form-control" name="reply" value="New Reply!!!">
				</div>
				<div class = "form-group">
					<label>Replyer</label>
					<input class="form-control" name="replyer" value="replyer">
				</div>
				<div class = "form-group">
					<label>Reply date</label>
					<input class= "form-control" name="replyDate" value="">
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" id = "modalModBtn" class="btn btn-warning">Modify</button>
				<button type="button" id = "modalRemoveBtn" class="btn btn-danger">Remove</button>
				<button type="button" id = "modalRegisterBtn" class="btn btn-primary">Register</button>
				<button type="button" id = "modalCloseBtn" class="btn btn-default" data-dismiss="modal">Close</button>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
<!-- /.modal -->
				<!-- /#page-wrapper -->
				
<script type="text/javascript" src="/resources/js/reply.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	console.log(replyService);
	var bnoValue = '<c:out value="${board.bno}"/>';

	//댓글 등록 테스트(replyService)
	/*replyService.add(
			{reply: "JS Test", replyer:"tester", bno:bnoValue} //댓글 데이터
			,function(result) {
				alert("RESULT : " + result);
			}
	); */

	//게시글 조회할 때마다 댓글 추가 확인
	/*replyService.getList({bno:bnoValue, page:1}, function(list) {
		for(var i=0, len=list.length || 0; i<len; i++) {
			console.log(list[i]);
		}
	}); */

	//댓글 삭제 테스트(replyService)
	/* replyService.remove(3, function(count) {
		console.log(count);
		if(count==="success") {
			alert("REMOVED");
		}
	}, function(err) {
		alert('ERROR....');
	}); */

	//댓글 수정 테스트(replyService)
	/*replyService.update({
		rno:11,
		bno: bnoValue,
		reply: "js Modified Reply...."
	}, function(result) {
		alert("수정 완료");
	}); */

	//특정 댓글 조회 테스트(replyService)
 replyService.get(11, function(data) {
	 console.log("aaaaaa");
	console.log(data);
	});

	var replyUL = $(".chat");
	showList(1);

	function showList(page) //해당 게시글의 댓글을 가져온 후 <li>태그를 만들어서 화면에 출력
		{replyService.getList( { bno : bnoValue, page : page || 1}, function(list) {
			var str = "";
			if (list == null || list.length == 0) {
				replyUL.html("");
				return;
			}
			for (var i = 0, len = list.length || 0; i < len; i++) {
				str += "<li class='left cleafix' data-rno='"+list[i].rno+"'>";
				str += "    <div><div class='header'><strong class='primary-font'>" + list[i].replyer + "</strong>";
				str += "        <small class='pull-right text-muted'>" + replyService.displayTime(list[i].replyDate) + "</small></div>";
				str += "            <p>" + list[i].reply + "</p></div></li>";
			}
			replyUL.html(str);
	});//function call
}//showList
	var modal = $(".modal");
	var modalInputReply = modal.find("input[name='reply']");
	var modalInputReplyer = modal.find("input[name='replyer']");
	var modalInputReplyDate = modal.find("input[name='replyDate']");
	
	var modalModBtn = $("#modalModBtn");
	var modalRemoveBtn = $("#modalRemoveBtn");
	var modalRegisterBtn = $("#modalRegisterBtn");
	
	$("#addReplyBtn").on("click", function(e) {
		modal.find("input").val("");
		modalInputReplyDate.closest("div").hide();
		modal.find("button[id!='modalCloseBtn']").hide();
		
		modalRegisterBtn.show();
		$(".modal").modal("show");
	});
	modalRegisterBtn.on("click", function(e) {
		var reply ={
				reply: modalInputReply.val(),
				replyer: modalInputReplyer.val(),
				bno: bnoValue
		};
		replyService.add(reply, function (result){
			alert(result); //댓글 등록이 정상임을 팝업으로 알림
			modal.find("input").val(""); //댓글 등록이 정상적으로 이뤄지면, 내용을 지움
			modal.modal("hide"); //모달창 닫음
			
			showList(1);
		});
	});
	 $(".chat").on("click", "li", function(e){
			var rno= $(this).data("rno");
			modalInputReplyDate.closest("div").show();
			replyService.get(rno, function(reply){
				modalInputReply.val(reply.reply);
				modalInputReplyer.val(reply.replyer);
				modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly", "readonly");
				modal.data("rno", reply.rno);
				
				modal.find("button[id != 'modalCloseBtn']").hide();
				modalModBtn.show();
				modalRemoveBtn.show();
				
				$(".modal").modal("show");
				
			});
	  }) ;// 'chat'을 이용해 이벤트를 걸고 실제 이벤트 대상은 <li>태그가 되도록
	// 댓글 수정
	modalModBtn.on("click", function(e){
		var reply = {rno:modal.data("rno"), reply: modalInputReply.val()};
		replyService.update(reply, function(result){
			alert(result);
			modal.modal("hide");
			showList(1);
		});
	});
		
	// 댓글 삭제
	modalRemoveBtn.on("click", function(result){
		var rno = modal.data("rno");
		replyService.remove(rno, function(result){
			alert(result);
			modal.modal("hide");
			showList(1);
		});
	});

});
</script>
<script type="text/javascript">
	$(document).ready(function() {
		var operForm = $("#operForm");
		$('button[data-oper="modify"]').on(
				"click",function(e) {
					operForm.attr("action","/board/modify").submit();
				});
		$('button[data-oper="list"]').on(
				"click",function(e) {
					operForm.find("#bno").remove();
					operForm.attr("action","/board/list");
					operForm.submit();
				});
	});
</script>



<%@include file="../includes/footer.jsp"%>
</body>
</html>