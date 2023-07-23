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
	
	void addBranchInfo(Map<String,Object> param);
	
	void updateBranchInfo(Map<String, Object> param);
	
	void deleteBranchInfo(Map<String, Object> param);
	
	List<Map<String,Object>> getReservationMasterData(Map<String,Object> param);
	
	void addReservationMasterData(List<Map<String,Object>> param);
	
	void deleteReservationMasterData(Map<String,Object> param);
	
	int getCntBranchReservationInfo(Map<String,Object> param);
	
	Map<String, Object> getBranchReservationInfo(Map<String,Object> param);
	
	int getCntbranchReservationInfo(Map<String,Object> param);
	
	int addbranchReservationInfo(Map<String,Object> param);
	
	int updatebranchReservationInfo(Map<String,Object> param);
}
