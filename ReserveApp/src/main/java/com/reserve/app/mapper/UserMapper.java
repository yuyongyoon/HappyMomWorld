package com.reserve.app.mapper;


import java.util.List;
import java.util.Map;

public interface UserMapper {
	Map<String, Object> getUserInfo(Map<String, Object> param);
	
	void updateUserInfo(Map<String, Object> param);
	
	int checkOrgPwd(Map<String, Object> param);
	
	int updateUserPwd(Map<String, Object> param);
	
	List<Map<String, Object>> getReservation(Map<String, Object> param);
	
	Map<String, Object> getMassageCnt(Map<String, Object> param);
	
	void removeReservation (Map<String, Object> param);
	
	List<Map<String, Object>> getAvailableDate(Map<String, Object> param);
	
	int getReservationCnt();
	
	void changeMagCnt(Map<String, Object> param);
	
	void saveCancelLog(Map<String,Object> param);
	
	Map<String, Object> getAvailableData(Map<String, Object> param);
	
	Map<String, Object> reservationTimeInfo(Map<String, Object> param);
	
	void saveReservation(Map<String, Object> param);
}
