package org.conan.service;

import java.util.List;

import org.conan.domain.BoardVO;
import org.conan.persistence.BoardMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
@Log4j
@Service
//전체 생성자 초기화
//@AllArgsConstructor
public class BoardServiceImpl implements BoardService {
	@Setter(onMethod=@__({@Autowired})) //전체 생성자 초기화하면 사용x
	private BoardMapper mapper;
	
	@Override
	public void register(BoardVO board) {
		mapper.insert(board);
	}

	@Override
	public BoardVO get(Long bno) {
		log.info("get...."+bno);
		return mapper.read(bno);
	}

	@Override
	public boolean modify(BoardVO board) {
		log.info("modify...."+board);
		return mapper.update(board)==1;
	}

	@Override
	public boolean remove(Long bno) {
		log.info("remove...."+bno);
		return mapper.delete(bno)==1;
	}

	@Override
	public List<BoardVO> getList() {
		log.info("getList.........");
		return mapper.getList();
	}

}