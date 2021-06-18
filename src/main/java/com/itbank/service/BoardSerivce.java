package com.itbank.service;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.itbank.admin_board.CoboardDAO;
import com.itbank.admin_board.CoboardDTO;
import com.itbank.admin_board.Paging;
import com.itbank.admin_board.boardDAO;
import com.itbank.admin_board.boardDTO;

@Service
public class BoardSerivce {

	@Autowired private boardDAO dao;
	@Autowired private CoboardDAO c_dao;
	
	public List<boardDTO> list(Paging paging,HashMap<String, Object>param) {
		// TODO Auto-generated method stub
		param.put("offset", paging.getOffset());
		param.put("perPage",paging.getPerPage());
		return dao.list(param);
	}
	public int insert(boardDTO dto) {
		// TODO Auto-generated method stub
		if(dto.getFile().isEmpty()) {
		dto.setBoard_file("");
		return dao.insert(dto);
		}
		dto.ready();
		return dao.insert(dto);
	}
	public boardDTO selectOne(int board_number) {
		// TODO Auto-generated method stub
		boardDTO dto = dao.selectOne(board_number);
		return dto;
	}
	public int update(boardDTO dto) {
		// TODO Auto-generated method stub
		if(dto.getFile().isEmpty()) {
			dto.setBoard_file("");
			return dao.update(dto);
		}
		dto.ready();
		return dao.update(dto);
		
	}
	public int boardCount() {
		// TODO Auto-generated method stub
		return dao.boardCount();
	}
	public int delete(int board_number) {
		// TODO Auto-generated method stub
		return dao.delete(board_number);
	}
	public String summernote(MultipartFile multipartFile, HashMap<String, String> jm) {
		String fileRoot = "D:\\upload\\";	//저장될 외부 파일 경로
		String originalFileName = multipartFile.getOriginalFilename();	//오리지날 파일명
		String extension = originalFileName.substring(originalFileName.lastIndexOf("."));	//파일 확장자				
		String savedFileName = UUID.randomUUID() + extension;	//저장될 파일 명
		File targetFile = new File(fileRoot + savedFileName);
		try {
			multipartFile.transferTo(targetFile);
		} catch (IllegalStateException | IOException e) {
			targetFile.delete();	//저장된 파일 삭제
			jm.put("responseCode", "error");
			e.printStackTrace();
		}
		return savedFileName;
	}
	public boardDTO next(int board_number) {
		// TODO Auto-generated method stub
		return dao.next(board_number);
	}
	public boardDTO prev(int board_number) {
		// TODO Auto-generated method stub
		return dao.prev(board_number);
	}
/////////--------------------------사내 게시판 -------------------------------------------------////////////////////////////////////
	
	
	public List<CoboardDTO> clist(Paging paging, HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		
		param.put("offset", paging.getOffset());
		param.put("perPage",paging.getPerPage());
		return c_dao.clist(param);
	}
	public int cboardCount() {
		// TODO Auto-generated method stub
		return c_dao.cboardCount();
	}
	public CoboardDTO cselectOne(int board_number) {
		// TODO Auto-generated method stub
		return c_dao.cselectOne(board_number);
	}
	public CoboardDTO cnext(int board_number) {
		// TODO Auto-generated method stub
		return c_dao.cnext(board_number);
	}
	public CoboardDTO cprev(int board_number) {
		// TODO Auto-generated method stub
		return c_dao.cprev(board_number);
	}
	public int cupdate(CoboardDTO dto) {
		// TODO Auto-generated method stub
		return c_dao.cupdate(dto);
	}

}
