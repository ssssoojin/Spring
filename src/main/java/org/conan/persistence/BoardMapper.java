package org.conan.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Select;
import org.conan.domain.BoardVO;

public interface BoardMapper {
	//@Select("select * from tbl_board where bno>0")
	public List<BoardVO> getList();
	public void insert(BoardVO board);
	public BoardVO read(long bno);
	public int delete(long bno);
	public int update(BoardVO board);
	public void insertSelectKey(BoardVO board);
}
