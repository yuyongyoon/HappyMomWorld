package com.reserve.app.mapper;


import java.util.List;
import java.util.Map;

public interface UserMapper {
	List<Map<String, Object>> getUserInfo(Map<String, Object> param);
	
	void updateUserInfo(Map<String, Object> param);
	
	int checkOrgPwd(Map<String, Object> param);
	
	int updateUserPwd(Map<String, Object> param);
	
	List<Map<String, Object>> selectBranch(Map<String, Object> param);
	
	
}
