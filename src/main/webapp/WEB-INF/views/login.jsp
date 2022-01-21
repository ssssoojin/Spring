<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<link rel="stylesheet" href="/resources/css/login.css">
<script src="https://kit.fontawesome.com/51db22a717.js" crossorigin="anonymous"></script>

<script
  src="https://code.jquery.com/jquery-3.4.1.js"
  integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU="
  crossorigin="anonymous"></script>
</head>
<body>
<div class="main-container">
		<div class="main-wrap">
		<header>
			<div class="sel-lang-wrap">
				<select class="lang-select">
					<option>한국어</option>
					<option>English</option>
				</select>
			</div>
			<div class="logo-wrap">
				<img src="/resources/images/loginlogo.png">
			</div>
		</header>
		<form id="login_form" method="post">
		<section class="login-input-section-wrap">
		<h2><c:out value="${error}"/></h2>
		<h2><c:out value="${logout}"/></h2>
			<div class="login-input-wrap">	
				<input placeholder="아이디" type="text" name="username" value="admin"></input>
			</div>
			<div class="login-input-wrap password-wrap">	
				<input placeholder="비밀번호" type="password" name="password" value="admin"></input>
			</div>
			<div class="login-stay-sign-in">
				 <input type="checkbox" name="remember-me">로그인 유지
			</div>
			<%--  <c:if test = "${msg == false }">
                <div class = "login_warn">사용자 ID 또는 비밀번호를 잘못 입력하셨습니다.</div>
            </c:if> --%>
			<div class="login-button-wrap">
				<input type="button" class="login_button" value="로그인">
				<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }" />
			</div>
			<div class="join-button-wrap">
				<input type="button" class="join_button" value="회원가입">
			</div>
		</section>
		</form>
		<footer>
			<div class="copyright-wrap">
			<span>Color Custom </span>
			<p>©2022 All Rights Reserved.</p>
			</div>
		</footer>
		</div>
	</div>
	
	
 
<script>
 
    /* 로그인 버튼 클릭 메서드 */
    $(".login_button").click(function(){
    	  /* 로그인 메서드 서버 요청 */
        $("#login_form").attr("action", "/login");
        $("#login_form").submit();
    });
    /*회원가입 버튼 클릭 메서드 */
    $(".join_button").click(function(){
    	  /* 로그인 메서드 서버 요청 */
    	 location.href="/member/join";
    });
 
</script>
</body>
</html>