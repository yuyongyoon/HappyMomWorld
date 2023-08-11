package com.reserve.app.mapper;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository
public interface AdminMapper {
	List<Map<String,Object>> getUserList(Map<String,Object> param);
	
	void resetPassword(Map<String, Object> insertId);

	void updateAccount(Map<String, Object> param);

	int checkId(Map<String,Object> param);

	List<Map<String, Object>> getBranchNameList(Map<String, Object> param);
	
	List<Map<String,Object>> getBranchList(Map<String,Object> param);
		
	void addBranchToMng(Map<String,Object> param);
	
	void addBranchToInfo(Map<String,Object> param);
	
	void addBranchToUser(Map<String,Object> param);
	
	void addBranchInToRsv(Map<String,Object> param);
	
	void updateBranchInfo(Map<String, Object> param);
	
	void deleteBranchInfo(Map<String, Object> param);
	
	void resetMngPwd(Map<String, Object> param);

	void updateManager(Map<String, Object> param);
	
	List<Map<String,Object>> getReservationMasterData(Map<String,Object> param);
	
	void addReservationMasterData(List<Map<String,Object>> param);
	
	void deleteReservationMasterData(Map<String,Object> param);
	
	Map<String, Object> getBranchReservationInfo(Map<String,Object> param);
	
	int addbranchReservationInfo(Map<String,Object> param);
	
	int updatebranchReservationInfo(Map<String,Object> param);
	
	List<Map<String,Object>> getCalendarEvent(Map<String,Object> param);
	
	List<Map<String,Object>> getRsvUserList(Map<String,Object> param);
	
	Map<String,Object> getSeletedDateReservationList(Map<String,Object> param);
	
	Map<String, Object> getBranchInfo(Map<String,Object> param);
	
	void saveBranchInfo(Map<String,Object> param);

	List<Map<String,Object>> getNonConfirmData(Map<String,Object> param);
	
	List<Map<String,Object>> getReservationList(Map<String,Object> param);
	
	void updateReservationByAdmin(Map<String, Object> param);
	
	void removeReservationByAdmin (Map<String, Object> param);
	
	void changeMagCnt(Map<String, Object> param);
	
	void saveCancelLog(Map<String,Object> param);
	
	void updateRsvStatus(Map<String,Object> param);
	
	Map<String, Object> getRsvLastMonth(Map<String,Object> param);
	
	List<Map<String,Object>> getRecentJoinData(Map<String,Object> param);
	
	List<Map<String,Object>> getRecentRsvData(Map<String,Object> param);
	
	List<Map<String,Object>> getNonRsvData(Map<String,Object> param);
	
	int getMsgLogCnt(Map<String,Object> param);
	
	void updateMsgLog(Map<String,Object> param);
	
	void saveMsgLog(Map<String,Object> param);
	
	Map<String,Object> getMainUrl(Map<String,Object> param);
	
	void updateUrl(Map<String,Object> param);
}
