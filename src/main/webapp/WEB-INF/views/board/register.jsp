<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<title>Register</title>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<style>
.uploadResult {
	width: 100%;
	background-color: gray;
}

.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center
}

.uploadResult ul li {
	list-style: none;
	padding: 10px;
}

.uploadResult ul li img {
	width: 20px;
}

.uploadResult ul li span {
	color: white
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
	width: 400px;
}
</style>
<%@include file="../includes/header.jsp"%>

<div id="page-wrapper">
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">BOARD REGISTER</h1>
		</div>
		<!-- /.col-lg-12 -->
	</div>
	<!-- /.row -->
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-info">
				<div class="panel-heading">Board Register (게시글 등록)</div>
				<!-- /.panel-heading -->
				<div class="panel-body">
					<form role="form" action="/board/register" method="post">
						<div class = "form-group">
							<label>Title</label><input class="form-control" name="title">
						</div>
						<div class = "form-group">
							<label>Content</label><textarea class="form-control" name="content" rows="3"></textarea>
						</div>
						<div class = "form-group">
							<label>Writer</label><input class="form-control" name="writer">
						</div>
						<button type ="submit" class="btn btn-outline btn-danger">Submit</button>
						<button type ="reset" class="btn btn-outline btn-warning">Reset</button>
					</form>

				</div>
				<!-- /.table-responsive -->
			</div>
			<!-- /.panel-body -->
		</div>
		<!-- /.panel -->
	</div>
	<!-- /.col-lg-6 -->
	
<!--첨부파일 -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-info">
			<div class="panel-heading">File Attach</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
				<div class="form-group uploadDiv">
					<input type="file" name="uploadFile" multiple>
				</div>
				<div class="uploadResult">
		<ul></ul>
	</div>
			</div>
		</div>
	</div>
</div>
</div>
<!-- /.row -->

	

<!-- /#page-wrapper -->
<script>
$(document).ready(function(e){
	var formObj = $("form[role='form']");
	$("button[type='submit']").on("click", function(e){
		e.preventDefault();
		console.log("submit clicked");
	});
	
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	var maxSize = 5242880; // 5MB
	
	function checkExtension(fileName, fileSize){
		if(fileSize >= maxSize){
			alert("파일 사이즈 초과");
			return false;
		}
		
		if(regex.test(fileName)){
			alert("해당 종류의 파일은 업로드할 수 없음.");
			return false;
		}
		return true;
	}
	function showUploadResult(uploadResultArr){
		  if(!uploadResultArr || uploadResultArr.length == 0){return ;}
		  var uploadUL = $(".uploadResult ul");
		  var str = "";
			  $(uploadResultArr).each(function(i, obj){
				     
				   if(!obj.image){//이미지 아닌경우
			       
			       var fileCallPath =  encodeURIComponent( obj.uploadPath+"/"+ obj.uuid +"_"+obj.fileName);
			     //str +="<li><img src='/resources/images/attach.png'>"+obj.fileName+"</li>";
			       var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
			       
			     //첨부파일이 업로드된 후에 생기는 이미지 파일 옆에 'x' 표시를 추가
			       str += "<li><a href='/download?fileName="+fileCallPath+"'><img src='/resources/img/attach.png'>"
			    		   +obj.fileName+"</a>" + "<span data-file=\ '"+ fileCallPath+"\' data-type='file'> x </span>"
			    		   + "<div></li>"

			     }else{//이미지인 경우
			    	// str += "<li>" + obj.fileName + "</li>";//파일 이름 출력
			       var fileCallPath =  encodeURIComponent( obj.uploadPath+ "/s_"+obj.uuid +"_"+obj.fileName);
			       var originPath = obj.uploadPath+ "\\"+obj.uuid +"_"+obj.fileName;
			       originPath = originPath.replace(new RegExp(/\\/g),"/");
			       
			       //첨부파일이 업로드된 후에 생기는 이미지 파일 옆에 'x' 표시를 추가
			       str += "<li><a href=\"javascript:showImage(\'"
		    		   +originPath+"\')\"><img src='/display?fileName="+fileCallPath+"'></a>"
		    				   + "<span data-file=\'" + fileCallPath + "\' data-type='image'> x </span></li>";
			     }
			   });
				uploadUL.append(str);
			};//showUploadedFile
			
			var cloneObj =$(".uploadDiv").clone();
	$("input[type = 'file']").change(function(e){
		var formData = new FormData();
		var inputFile = $("input[name='uploadFile']");
		var files = inputFile[0].files;
		console.log(files);
		
		//add file data to formdata
		for(var i=0; i<files.length; i++){
			if(!checkExtension(files[i].name, files[i].size)){
				return false;
			}
			formData.append("uploadFile", files[i]);
		}
		
		$.ajax({
			url : '/uploadAjaxAction',
			processData : false,// 전달할 데이터를 query string을 만들지 말 것
			contentType : false,// 얘네 두개는 무조건 false줘야하고 의미 몰라도 됨 (필수사항이라고 알기)
			data : formData,//전달할 데이터
			type : 'POST',
			success : function(result){
					console.log(result);
					showUploadResult(result);
					//$(".uploadDiv").html(cloneObj.html());
				}
		});
	});
});
</script>

<%@include file="../includes/footer.jsp"%>
</body>

</html>