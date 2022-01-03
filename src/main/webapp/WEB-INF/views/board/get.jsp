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
						<input type="hidden" name="type" value="${cri.type}">
						<input type="hidden" name="keyword" value="${cri.keyword}">
					</form>
						
						<button data-oper="modify" class="btn btn-outline btn-primary btn-sm">Modify</button>
						<button data-oper="list" class="btn btn-outline btn-info btn-sm">List</button>
					</form>



				</div>
				<!-- /.table-responsive -->
			</div>
			<!-- /.panel-body -->
		</div>
		<!-- /.panel -->
	</div>
	<!-- /.col-lg-6 -->
</div>
<!-- /.row -->

<!-- /#page-wrapper -->
<script type="text/javascript" src="/resources/js/reply.js"></script>
<script type="text/javascript">
		console.log(replyService);
		var bnoValue='<c:out value="${board.bno}"/>';
		
		/* //댓글 등록 테스트(replyService)
		replyService.add(
				{reply: "JS Test", replyer:"tester", bno:bnoValue} //댓글 데이터
				,function(result) {
					alert("RESULT : " + result);
				}
		); */
		/* 
		//게시글 조회할 때마다 댓글 추가 확인
		replyService.getList({bno:bnoValue, page:1}, function(list) {
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
	/* 	
		//댓글 수정 테스트(replyService)
		replyService.update({
			rno:11,
			bno: bnoValue,
			reply: "js Modified Reply...."
		}, function(result) {
			alert("수정 완료");
		}); */
		
		//특정 댓글 조회 테스트(replyService)
		replyService.get(11, function(data) {
		console.log(data);
		});
		</script>
	<script type="text/javascript">
	$(document).ready(function(){
		var operForm = $("#operForm");
		$('button[data-oper="modify"]').on("click",function(e){
			operForm.attr("action","/board/modify").submit();
		});
		$('button[data-oper="list"]').on("click",function(e){
			operForm.find("#bno").remove();
			operForm.attr("action","/board/list");
			operForm.submit();
		});
	});
</script>




<%@include file="../includes/footer.jsp"%>
</body>

</html>