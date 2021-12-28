package org.conan.test;


import org.conan.domain.BoardVO;
import org.conan.persistence.BoardMapper;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)

@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardMapperTest {
	@Setter(onMethod= @__({@Autowired}))
	private BoardMapper mapper;
		@Test
		public void testGetList() {
			mapper.getList().forEach(board->log.info(board));
		}
		
		@Test
		//게시글 추가
		public void testInsert() {
			BoardVO board = new BoardVO();
			board.setTitle("새로 작성하는 글");
			board.setContent("새로 작성하는 내용");
			board.setWriter("newbie");
			mapper.insert(board);
			log.info(board);
		}
		
		@Test
		//게시물 조회
		public void testRead() {
			BoardVO board = mapper.read(5L);
			log.info(board);
		}
		
		@Test
		//게시물 삭제
		public void testDelete() {
			log.info("DELETE COUNT : "+mapper.delete(5L));
		}
}
