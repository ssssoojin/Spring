package org.conan.controller;

import org.conan.domain.Criteria;
import org.conan.domain.ReplyPageDTO;
import org.conan.domain.ReplyVO;
import org.conan.service.ReplyService;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@RequestMapping("/replies/")
@RestController
@Log4j
@AllArgsConstructor
public class ReplyController {
	private ReplyService service;
	
	//등록
	@PostMapping(value = "/new", consumes="application/json", produces= {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> create(@RequestBody ReplyVO vo) {
		
		log.info("ReplyVO: " + vo);
		int insertCount = service.register(vo);
		
		log.info("Reply INSERT COUNT: " + insertCount);
		
		return insertCount==1 ? new ResponseEntity<> ("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	//특정 게시물의 댓글 목록
	@GetMapping(value="/pages/{bno}/{page}", produces= {
			MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_VALUE
	})
	public ResponseEntity<ReplyPageDTO> getList(
			@PathVariable("page") int page,
			@PathVariable("bno") Long bno
			) {
		Criteria cri = new Criteria(page, 5);
		log.info("1. get Reply List bno : " + bno);
		log.info("댓글 cri : " + cri);
		return new ResponseEntity<>(service.getListPage(cri, bno), HttpStatus.OK);
	}
	//댓글의 조회
	@GetMapping(value="/{rno}", produces= {
			MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_VALUE
	})
	public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno ) {
		log.info("댓글4. controller get으로 옴");
		log.info("get>> rno: " + rno);
		log.info("ReplyVO 반환");
		return new ResponseEntity<>(service.get(rno), HttpStatus.OK);
	}
	//댓글의 삭제
	@DeleteMapping(value="/{rno}", produces = {
			MediaType.TEXT_PLAIN_VALUE
	}) 
	public ResponseEntity<String> remove(@PathVariable("rno") Long rno){
		log.info("remove : " + rno);
		return service.remove(rno) == 1
				? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<> (HttpStatus.INTERNAL_SERVER_ERROR);
	}
	//댓글의 수정
	@RequestMapping(method= {RequestMethod.PUT, RequestMethod.PATCH},
			value="/{rno}",
			consumes="application/json",
			produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> modify(
			@RequestBody ReplyVO vo,
			@PathVariable("rno") Long rno) {
		vo.setRno(rno);
		log.info("rno : " + rno);
		log.info("modify : " + vo);
		
		return service.modify(vo) == 1
				? new ResponseEntity<> ("success", HttpStatus.OK)
						: new ResponseEntity<> (HttpStatus.INTERNAL_SERVER_ERROR);
	}
}
