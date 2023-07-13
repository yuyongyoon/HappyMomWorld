package com.reserve.app.mapper;

import java.util.List;
import java.util.Map;

public interface UserMapper {
	List<Map<String, Object>> getUserInfo(Map<String, Object> param);
	
	void updateUserInfo(Map<String, Object> param);
	
	void updateUserPwd(Map<String, Object> new_pwd);
	
	int checkOrgPwd(Map<String, Object> org_pwd);
}
