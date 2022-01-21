<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="en">
<title>Modify</title>
<style>
.uploadResult {
	width: 100%;
	background-color: #fcf8e3;
}

.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}

.uploadResult ul li {
	list-style: none;
	padding: 10px;
	align-content: center;
	text-align: center;
}

.uploadResult ul li img {
	width: 100px;
}

.uploadResult ul li span {
	color: white;
}

.bigPictureWrapper {
	position: absolute;
	display: none;
	justify-content: center;
	align-items: center;
	top: 0%;
	width: 100%;
	height: 100%;
	background-color: gray;
	z-index: 100;
	background: rgba(255, 255, 255, 0.5);
}

.bigPicture {
	position: relative;
	display: flex;
	justify-content: center;
	align-items: center;
}

.bigPicture img {
	width: 600px;
}
</style>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<!-- 푸터에 있음 -->
<%@include file="../includes/header.jsp"%>
<%@include file="../includes/footer.jsp"%>

<div id="page-wrapper">
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">BOARD MODIFY</h1>
		</div>
		<!-- /.col-lg-12 -->
	</div>
	<!-- /.row -->
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">Board Modify (게시글 수정)</div>
				<!-- /.panel-heading -->
				<div class="panel-body">
					<form role="form" action="/board/modify" method="post">
						<input type="hidden" name="pageNum" value="${cri.pageNum}">
						<input type="hidden" name="amount" value="${cri.amount}">
						<input type="hidden" name="type" value="${cri.type}"> <input
							type="hidden" name="keyword" value="${cri.keyword}">

						<div class="form-group">
							<label>Bno</label><input class="form-control" name="bno"
								value='<c:out value="${board.bno}"/>' readonly="readonly">
						</div>
						<div class="form-group">
							<label>Title</label><input class="form-control" name="title"
								value='<c:out value="${board.title}"/>'>
							<%-- <label>Title</label><input class="form-control" name="title" value="${board.title}"/> --%>
						</div>
						<div class="form-group">
							<label>Content</label>
							<textarea class="form-control" name="content" rows="3">${board.content}</textarea>
						</div>
						<div class="form-group">
							<label>Writer</label><input class="form-control" name="writer"
								value='<c:out value="${board.writer}"/>' readonly="readonly">
						</div>
						<div class="form-group">
							<label>regDate</label><input class="form-control" name="regDate"
								value='<fmt:formatDate value="${board.regDate}" pattern="yyyy/MM/dd"/>'
								readonly="readonly">
						</div>
						<div class="form-group">
							<label>updateDate</label><input class="form-control"
								name="updateDate"
								value='<fmt:formatDate value="${board.updateDate}" pattern="yyyy/MM/dd"/>'
								readonly="readonly">
						</div>

						 <!-- 로그인한 사용자와 게시물의 작성자인 경우만 수정과 삭제 버튼이 보이도록 검증-->
                <sec:authentication property="principal" var="pinfo"/>
                    <sec:authorize access="isAuthenticated()">
                        <c:if test="${pinfo.username eq board.writer }">
                    <button type="submit" data-oper='modify' class="btn btn-default">Modify</button> 
                    <button type="submit" data-oper='remove' class="btn btn-danger">Remove</button>
                        </c:if>
                    </sec:authorize>
                    <button type="submit" data-oper='list' class="btn btn-info">List</button>
                    
                        <!--  csrf 공격 방어를 위해 동적 생성 -->
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token }" />
					</form>
				</div>
				<!-- /.table-responsive -->
			</div>
			<!-- /.panel-body -->
		</div>
		<!-- /.panel -->
	</div>
	<!-- /.col-lg-6 -->
	<!-- /.row -->


	<!-- 첨부파일 -->
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-info">

				<div class="panel-heading">Files</div>
				<!-- /.panel-heading -->
				<div class="panel-body">
					<div class="form-group uploadDiv">
						<input type="file" name='uploadFile' multiple="multiple">
					</div>
					<div class='uploadResult'>
						<ul>
						</ul>
					</div>
				</div>
				<!--  end panel-body -->
			</div>
			<!--  end panel-body -->
		</div>
		<!-- end panel -->
	</div>
	<!-- /.row -->
</div>
<div class='bigPictureWrapper'>
	<div class='bigPicture'></div>
</div>

<!-- /#page-wrapper -->

<script type="text/javascript">
	$(document).ready(function() {
		
		 var formObj = $("form");
		 
			$('button').on("click", function(e) {
				e.preventDefault();//전송을 막음
				var operation = $(this).data("oper");
				console.log("operation : "+operation);
				
				if (operation === 'remove') {
					
					formObj.attr("action", "/board/remove");
					
				} else if (operation === 'list') {
					formObj.attr("action", "/board/list").attr("method", "get");

					//수정/삭제 취소 후, 목록 페이지로 이동
					//pageNum 과 amount 만 사용하므로,
					//<form> 태그에서 필요한 부분만 잠시 복사(clone) 해서 보관해 두고, 
					//<form> 태그 안에 내용은 지워(empty)버립니다.
					//이후에 다시 필요한 태그들만 추가해서 '/board/list' 를 호출
					formObj.attr("action", "/board/list").attr("method", "get");

					var pageNumTag = $("input[name='pageNum']").clone(); //잠시 보관용
					var amountTag = $("input[name='amount']").clone();
					var keywordTag = $("input[name='keyword']").clone();
					var typeTag = $("input[name='type']").clone();

					formObj.empty(); //제거

					formObj.append(pageNumTag); //필요한 태그들만 추가
					formObj.append(amountTag);
					formObj.append(keywordTag);
					formObj.append(typeTag);
					
				} else if (operation === 'modify') {
				      console.log("submit clicked");
				      
				      var str = "";
				      
				      $(".uploadResult ul li").each(function(i,obj){
				         var jobj = $(obj);
				         console.dir(jobj);
				         
				         str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
				         str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
				         str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
				         str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
				      });
				      formObj.append(str);
				   }

				formObj.submit();
		});
			
		var bno = '<c:out value = "${board.bno}"/>';
		
		$.getJSON("/board/getAttachList", {bno:bno}, function(arr){
			console.log(arr);
			var str = "";
			
			$(arr).each(function(i, obj){
			
				if(!obj.fileType){
					// 일반 파일
					 var fileCallPath =  encodeURIComponent( obj.uploadPath+"/"+ obj.uuid +"_"+obj.fileName);            
			          
					  str += "<li data-path='" + obj.uploadPath + "' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"'>";
			          str += "<div>";
			          str += "<span> "+ obj.fileName+"</span>";
			          str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
			          str += "<img src='/resources/img/attach.png'></a>";
			          str += "</div>";
			          str +"</li>";
				}else {
					// 이미지 파일
					var fileCallPath =  encodeURIComponent( obj.uploadPath+ "/s_"+obj.uuid +"_"+obj.fileName);
					  str += "<li data-path='" + obj.uploadPath + "' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"'>";
			          str += "<div>";
			          str += "<span> "+ obj.fileName+"</span>";
			          str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
			          str += "<img src='/display?fileName="+fileCallPath+"'>";
			          str += "</div>";
			          str +"</li>";
				}
			});
		
			$(".uploadResult ul").html(str);
		});
			 // 첨부파일의 x버튼을 클릭하면 사용자의 확인을 거쳐 화면상에서 사라지게 함
			$(".uploadResult").on("click", "button", function(e){
				console.log("delete file");
				
				if(confirm("이 파일을 삭제하시겠어요? ")){
					var targetLi = $(this).closest("li");
					targetLi.remove();
				}
			});
		
		
			 var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
			  var maxSize = 5242880; //5MB
			  
			  function checkExtension(fileName, fileSize){
			    
			    if(fileSize >= maxSize){
			      alert("파일 사이즈 초과");
			      return false;
			    }
			    
			    if(regex.test(fileName)){
			      alert("해당 종류의 파일은 업로드할 수 없습니다.");
			      return false;
			    }
			    return true;
			  }
			  var cloneObj = $(".uploadDiv").clone();

			  var csrfHeaderName = "${_csrf.headerName}";
			    var csrfTokenValue = "${_csrf.token}";
			  $("input[type='file']").change(function(e){

			    var formData = new FormData();
			    
			    var inputFile = $("input[name='uploadFile']");
			    
			    var files = inputFile[0].files;
			    
			    for(var i = 0; i < files.length; i++){

			      if(!checkExtension(files[i].name, files[i].size) ){
			        return false;
			      }
			      formData.append("uploadFile", files[i]);
			      
			    }
			    
			    $.ajax({
			      url: '/uploadAjaxAction',
			      processData: false, 
			      contentType: false,
			      beforeSend: function(xhr){
			            xhr.setRequestHeader(csrfHeaderName, csrfTokenValue)},
			      data:formData,
			      type: 'POST',
			      dataType:'json',
			        success: function(result){
			          console.log(result); 
			          showUploadFile(result); //업로드 결과 처리 함수 

			      }
			    }); //$.ajax
			    
			  });  
		  
	            var uploadResult = $(".uploadResult ul");
		  function showUploadFile(uploadResultArr){
	            
	            if(!uploadResultArr || uploadResultArr.length == 0){return;}
	            var str = "" ;
	            $(uploadResultArr).each(function(i,obj){
	               
	               if(!obj.image){//이미지 아님 클릭하면 다운로드 경로로 이동하여 다운함.
	                   var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
	                  
	                   str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename = '"+obj.fileName+"' data-type ='"+obj.image+"'><div>";
	                   str += "<span>"+obj.fileName+"<span>";
	                   str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' class ='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
	                   str += "<img src='/resources/images/attach.png'></a>";
	                   str += "</div></li>";
	               
	                  /* str += "<li><div><a href='/download?fileName="+fileCallPath+"'><img src='/resources/images/attach.png'>"+ obj.fileName+"</a>"
	                        +"<span data-file=\' "+fileCallPath+"\' data-type='file'>X</span></div></li>"; */
	               }else{//이미지         
	                  //str += "<li>" +obj.fileName+"</li>";
	                  var fileCallPath = 
	                     encodeURIComponent(obj.uploadPath+"/S_"+obj.uuid+"_"+obj.fileName);
	                  
	                  str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename = '"+obj.fileName+"' data-type ='"+obj.image+"'><div>";
	                  str += "<span>"+obj.fileName+"<span>";
	                  str += "<button type='button'  data-file=\'"+fileCallPath+"\' data-type='image' class = 'btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
	                  str += "<img src='/display?fileName="+fileCallPath+"'>";
	                  str += "</div></li>";
	                  
	                  /* var originPath = obj.uploadPath +"/"+obj.uuid + "_" +obj.fileName;
	                  originPath = originPath.replace(new RegExp(/\\/g),"/");
	                  str += "<li><a href=\"javascript:showImage(\'"+originPath+"\')\"><img src='/display?fileName="+fileCallPath+"'></a>"
	                        +"<span data-file=\'"+fileCallPath+"\' data-type='image'>X</span></li>"; */
	               }
	            });
	            uploadResult.append(str);
	            //uploadResult.append(str);
	         }

		  $(".uploadResult").on("click", "button", function(e){
			  console.log("delete file");
			  
			  var targetFile = $(this).data("file");
			  var type = $(this).data("type");
			  var targetLi = $(this).closest("li");
			  
			  $.ajax({
			  	url : 'deleteFile',
			  	 beforeSend: function(xhr){
			            xhr.setRequestHeader(csrfHeaderName, csrfTokenValue)},
			  	data : {fileName : targetFile, type : type},
			  	dataType : 'text',
			  	type : 'POST',
			  		success : function(result) {
			  			alert(result);
			  			targetLi.remove();
			  		}
			  });//$.ajax
		  });//uploadResult
		
	});
</script>

</body>


</html>