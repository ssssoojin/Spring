<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- jQuery -->
    <script src="/resources/vendor/jquery/jquery.min.js"></script>
</head>
<body>
<%@include file="../includes/header.jsp"%>

<!-- jQuery에서 제공하는 최신 버전의 jQuery URL -->
<!-- <script src="http://code.jquery.com/jquery-latest.js"></script>  -->

    
<script type="text/javascript">
$(document).ready(function(){
	var result='<c:out value="${result}"/>';
	checkModal(result);
	<!-- 모달결과  --> 
	function checkModal(result){
		if(result === ''){
			return;
		}
		if(parseInt(result)>0){
			$(".modal-body").html("게시글" + parseInt(result)+" 번이 등록되었습니다.");
		}
		$("#myModal").modal("show");
		
	}
	
	$("#regBtn").on("click",function(){
		self.location = "/board/register";
	})//버튼 클릭시 등록창으로 이동
});	
</script>

<div id="page-wrapper">
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">Board List Page</h1>
		</div>
		<!-- /.col-lg-12 -->
	</div>
	<!-- /.row -->
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">게시글 목록
				<button id='regBtn' type="button" class="btn btn-outline btn-success btn-xs pull-right">글쓰기</button>
				</div>
				<!-- /.panel-heading -->
				<div class="panel-body">
					<table width="100%"
						class="table table-striped table-bordered table-hover"
						id="dataTables-example">
						<thead>
							<tr>
								<th>#번호</th>
								<th>제목</th>
								<th>작성자</th>
								<th>작성일</th>
								<th>수정일</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="vo" items="${list}">
								<tr class="odd gradeX">
									<td>${vo.bno }</td>
									<td><a href="/board/get?bno=${vo.bno}">${vo.title }</a></td>
									<td>${vo.content }</td>
									<td class="center">${vo.regDate }</td>
									<td class="center">${vo.updateDate }</td>
								</tr>
							</c:forEach>

						</tbody>
					</table>

					<!-- modal fade -->
					<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
						aria-labelledby="myModallabel" aria-hidden="true">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal"
										aria-hidden="true">&times;</button>
									<h4 class="modal-title" id="myModalLabel">Modal title</h4>
								</div>
								<div class="modal-body">처리가 완료되었습니다.</div>
								<div class="modal-footer">
									<button type="button" class="btn btn-info"
										data-dismiss="modal">Close</button>
									<button type="button" class="btn btn-primary">Save
										Changes</button>
								</div>
							</div>
						</div>
					</div>
					<!-- /.modal fade -->

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


<%@include file="../includes/footer.jsp"%>
</body>

</html>
