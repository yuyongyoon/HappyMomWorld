package com.reserve.app.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository
public interface adminMapper {
	List<Map<String,Object>> getUserList(Map<String,Object> param);
	
	void addUser(HashMap<String,Object> param);
	
	void updateUser(Map<String,Object> param);
	
	int validateId(HashMap<String,Object> param);
}
