<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="http://code.jquery.com/jquery-latest.js"></script>
</head>
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
<body>
	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple>
	</div>
	<div class="uploadResult">
		<ul></ul>
	</div>
	<button id="uploadBtn">Upload</button>
	<div class='bigPictureWrapper'>
		<div class='bigPicture'></div>
	</div>

	<script type="text/javascript">
function showImage(fileCallPath){
	alert(fileCallPath);
	
	$(".bigPictureWrapper").css("display", "flex").show();
	
	$(".bigPicture")
	.html("<img src = '/display?fileName=" +encodeURI(fileCallPath)+"'>")
	.animate({width:'100%', height:'100%'}, 1000);
	
	 //이미지를 다시 클릭하면 사라지도록 이벤트 처리
	$(".bigPictureWrapper").on("click", function(e){
		$(".bigPicture").animate({width : '0%', height : '0%'}, 1000);
		setTimeout(function(){
			$(".bigPictureWrapper").hide();
		}, 1000);
	});
}//<a>태그에서 직접 showImage() 호출할 수 있도록 document ready외부에 선언

$(document).ready(function(){
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	var maxSize = 5242880; //5MB
	
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
	};
	
	var uploadResult = $(".uploadResult ul");
	function showUploadedFile(uploadResultArr){
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
	    				   + "<span data-file=\'" + fileCallPath + "\' data-type='image'> x </span><li>";
		     }
			uploadResult.append(str);
		   });
		};//showUploadedFile
		
		$(".uploadResult").on("click", "span", function(e){
			var targetFile = $(this).data("file");
			var type = $(this).data("type");
			console.log(targetFile);
			
			$.ajax({
				url : '/deleteFile',
				data : {fileName : targetFile, type : type},
				dataType : 'text',
				type : 'POST',
					success : function(result){
						alert(result);
					}
			}); // $ajax
		});
	
	
	var cloneObj =$(".uploadDiv").clone(); //업로드 전에 아무 내용이 없는<input type='file'>객체가 포함된 <div>복사)
	
	$("#uploadBtn").on("click", function(e){
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
				//alert("Uploaded");
				console.log(result);
				showUploadedFile(result);
			$(".uploadDiv").html(cloneObj.html());//초기화
			}
		}); // $.ajax
	});
	
	
	
});

	
</script>
</body>
</html>