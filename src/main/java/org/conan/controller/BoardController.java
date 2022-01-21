package org.conan.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.conan.domain.BoardAttachVO;
import org.conan.domain.BoardVO;
import org.conan.domain.Criteria;
import org.conan.domain.PageDTO;
import org.conan.service.BoardService;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {
	private BoardService service;
	
	@GetMapping("/list")
	public void list(Criteria cri, Model model) {

		log.info("list: " + cri);
		log.info("controller) BoardServiceImpl의 getList로===================>");
		log.info("list에 getList(cri)-->리턴값이 boardVO임");
		model.addAttribute("list", service.getList(cri));
		// model.addAttribute("pageMaker", new PageDTO(cri, 123));

		int total = service.getTotal(cri);
		log.info("total: " + total);
		model.addAttribute("pageMaker", new PageDTO(cri, total));

	}
	
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info("register : "+ board);
		if(board.getAttachList() != null) {
			board.getAttachList().forEach(attach -> log.info(attach));
		}
		service.register(board);
		rttr.addFlashAttribute("result",board.getBno()); //result로 번호 보내주기
		return "redirect:/board/list"; //redirect:를 하지 않는 경우, 새로고침시 도배
	}
	/*
	 * @ModelAttribute : 자동으로 Model 의 데이터를 지정한 이름으로 담아줌.
	 * 사용하지 않아도 파라미터인 객체는 전달이 되지만, 좀 더 명시적으로 이름을 지정하기 위해 사용.
	 * ModelAttribute("cri") Criteria cri  ==  model.addAttribute("cri", cri)
	 */
	
	// 상세보기, 수정화면
		@GetMapping({"/get", "/modify"})
		public void get(@RequestParam("bno") Long bno, 
				@ModelAttribute("cri") Criteria cri,  //추가
				Model model) 
		{
			log.info("/get or modify");
			model.addAttribute("board", service.get(bno));
		}
		
		// 수정처리
		@PreAuthorize("principal.username == #board.writer")
		@PostMapping("/modify")
		public String modify(
				BoardVO board, 
				@ModelAttribute("cri") Criteria cri,  //추가
				RedirectAttributes rttr) 
		{
			log.info("modify: " + board);

			if (service.modify(board)) {
				rttr.addFlashAttribute("result", "success");
			}
			rttr.addAttribute("pageNum", cri.getPageNum());
			rttr.addAttribute("amount", cri.getAmount());
			rttr.addAttribute("type", cri.getType());  
			rttr.addAttribute("keyword", cri.getKeyword());  

			return "redirect:/board/list";
		}	
		
		// 삭제 처리
		 @PreAuthorize("principal.username == #writer")
		@PostMapping("/remove")
		public String remove(
				
				@RequestParam("bno") Long bno,
				@ModelAttribute("cri") Criteria cri,  
				RedirectAttributes rttr) 
		{
			log.info("remove..." + bno);
			List<BoardAttachVO> attachList = service.getAttachList(bno);
			if (service.remove(bno)) {
				deleteFiles(attachList);  // 첨부파일 삭제
				rttr.addFlashAttribute("result", "success");
			}
	
			rttr.addAttribute("pageNum", cri.getPageNum());
			rttr.addAttribute("amount", cri.getAmount());
			rttr.addAttribute("type", cri.getType());  
			rttr.addAttribute("keyword", cri.getKeyword()); 

			return "redirect:/board/list";
		}
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/register")
	public void register() {

	}
	//게시물 번호를 이용해서 첨부파일과 관련된 데이터를 JSON으로 반환하도록 처리
	@GetMapping(value = "/getAttachList",
			produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>>getAttachList(Long bno){
		log.info("getAttachList" + bno);
		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
	}
	//서버에 업로드된 파일들을 삭제하기 위한 메소드
//	BoardController 는 데이터베이스 삭제를 먼저 호출하고, 이후 파일을 삭제해야 합니다.
//	파일 삭제 시, 해당 게시물의 첨부파일 목록이 필요합니다.
//
//	<작업순서>
//	1. 게시물의 첨부파일 정보를 준비
//	2. 데이터베이스에서 해당 게시물과 첨부파일 데이터 삭제
//	3. 첨부파일 목록을 이용해서 해당 폴더에서 썸네일 이미지와 일반 파일 삭제.

	private void deleteFiles(List<BoardAttachVO> attachList) {
		if(attachList == null || attachList.size() == 0) {
			return;
		}
		log.info("delete attach files........");
		log.info(attachList);
		
		attachList.forEach(attach -> {
			try {
				Path file = Paths.get("c:\\upload\\"+attach.getUploadPath()+"\\"+attach.getUuid()+"_"+attach.getFileName());
				Files.deleteIfExists(file);
				if(Files.probeContentType(file).startsWith("image")) {
					Path thumbNail = Paths.get("c:\\upload\\"+attach.getUploadPath()+"\\s_"+attach.getUuid()+"_"+attach.getFileName());
					Files.delete(thumbNail);
				}
			} catch(Exception e) {
				log.error("delete file error" + e.getMessage());
			}
		});
	}

	
	
}
