package org.conan.service;

import java.util.List;

import org.conan.domain.BoardAttachVO;
import org.conan.domain.BoardVO;
import org.conan.domain.Criteria;
import org.conan.persistence.BoardAttachMapper;
import org.conan.persistence.BoardMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
@Log4j
@Service
//전체 생성자 초기화
//@AllArgsConstructor
public class BoardServiceImpl implements BoardService {
	@Setter(onMethod=@__({@Autowired})) //전체 생성자 초기화하면 사용x
	private BoardMapper mapper;
	
	@Setter(onMethod_=@Autowired)
	private BoardAttachMapper attachMapper;
	
	@Override
	public void register(BoardVO board) {
		log.info("register...."+board);
		mapper.insertSelectKey(board);
		if(board.getAttachList() == null || board.getAttachList().size() <= 0) {
			return;
		}
		
		board.getAttachList().forEach(attach ->{
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});

	}

	@Override
	public BoardVO get(Long bno) {
		log.info("get...."+bno);
		return mapper.read(bno);
	}

	@Transactional
	@Override
	public boolean modify(BoardVO board) {
		log.info("modify.........."+ board);
		// 첨부파일이 게시글보다 우선순위가 높다(cardinality)
		// 첨부파일 작업이 모두 잘 삭제되고, 게시글의 내용이 수정된다면, 
		// 첨부파일 추가 시 충돌이 발생되지 않는다. 
		// 만약 이 부분을 지키지 않을 경우 다른 트랜젝션에 의해 롤백 될 수 있다(방지할 수 있지만, 안전하게 설계).
		
		// 이해를 돕고자 설명 하자면, 
		// *테이블 2개 이상
		// 1순위 : 전체 삭제 
		attachMapper.deleteAll(board.getBno());
		// 2순위 : 전체 수정 (2개 이상)
		boolean modifyResult = (mapper.update(board) == 1);
		
		// 수정 성공 시, 새롭게 추가된 첨부파일을 추가
		// 3순위 : DML 
		if(modifyResult &&  board.getAttachList() != null && board.getAttachList().size() > 0) { 
			board.getAttachList().forEach(attach ->{ 
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		
		return modifyResult;
	}

	@Transactional
	@Override
	public boolean remove(Long bno) {
		log.info("remove..........." + bno);
		attachMapper.deleteAll(bno);
		return mapper.delete(bno) == 1;
	}


	@Override
	public List<BoardVO> getList() {
		log.info("getList.........");
		log.info("service) mapper로 이동=============>");
		return mapper.getList();
	}
	
	@Override
	public List<BoardVO> getList(Criteria cri){
		log.info("getList with criteria : "+cri);
		
		return mapper.getListWithPaging(cri);
	}
	
	@Override
	public int getTotal(Criteria cri) {
		log.info("get total count");
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno){
		log.info("get Attach list by bno" + bno);
		return attachMapper.findByBno(bno);
	}
	
}
