package org.conan.domain;

import lombok.ToString;

@ToString
public class Criteria {
	private int pageNum; //페이지 번호
	private int amount; //한 페이지에 출력되는 데이터 수
	
	
	//public Criteria() { this.page = 1; this.perPageNum = 10; }
	
	public Criteria() {this(1,10);}
	
	public Criteria(int pageNum, int amount) {
		super();
		this.pageNum = pageNum; // mySQL에서 limit을 고려함
		this.amount = amount;
	}
	public int getPageNum() {
		return pageNum;
	}
	public void setPageNum(int pageNum) {
		if(pageNum <= 0) {
			this.pageNum = 1;
			return;
		}else {
			this.pageNum = pageNum;
		}
	}
	public int getAmount() {
		return amount;
	}
	public void setAmount(int amount) {
		this.amount = amount;
	}
	public int getPageStart() { //limit 구문에서 시작 위치 지정
		return (this.pageNum - 1)*this.amount;
	}
	
}
