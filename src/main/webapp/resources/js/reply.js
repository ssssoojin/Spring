console.log("Reply Module............");
var replyService={};

/*var replyService= (function() {
	return {name:"AAA"};
})(); //replyService라는 변수에 name이라는 속성, 'AAA'라는 값을 가진 객체 할당
*/
var replyService = (function() {
	function add(reply, callback, error) { //ajax처리 후 동작해야 하는 함수
		console.log("add reply.........");
		//ajax로 replyController초풀
		$.ajax({
			type: 'post',
			url: '/replies/new',
			data : JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",
			success: function(result, status, xhr) {
				if(callback) {callback(result);}
			},
			error : function(xhr, status, er){
				if(error) {error(er);}
			}
		})
	}//add
	function getList(param, callback, error) {
		var bno = param.bno;
		var page = param.page || 1;
		
		$.getJSON("/replies/pages/" + bno + "/" + page + ".json",
			function(data) {
				if(callback) {
					callback(data);
				}
			}).fail(function(xhr, status, err) {
				if(error) {
					error();
				}
			});
	}//getList
	
	function remove(rno, callback, error) {
		$.ajax( {
			type: 'delete',
			url : '/replies/' + rno,
			success : function(result, status, xhr) {
				if(callback) {
					callback(result);
				}
			},
			error : function(xhr, status, er) {
				if(error) {
					error(er);
				}
			}
		});
	}//remove
	
	function update(reply, callback, error) {
		console.log("RNO : " + reply.rno);
		$.ajax({
			type: 'put',
			url : '/replies/' + reply.rno,
			data : JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr) {
				if(callback) {
					callback(result);
				}
			},
			error : function(xhr, status, er) {
				if(error) {
					error(er);
				}
			}
		});
	}//update
	
	function get(rno, callback, error) {
		$.get("/replies/" + rno + ".json", function(result) {
			if(callback) {
				callback(result);
			}
		}).fail(function(xhr, status, err) {
			if(error) {
				error();
			}
		});
	}//get
	
	return {
		add:add,
		getList:getList,
		remove:remove,
		update:update,
		get:get
	};//모듈 패턴으로 외부에 노출하는 정보
})();