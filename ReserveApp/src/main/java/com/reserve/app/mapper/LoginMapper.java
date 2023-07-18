package com.reserve.app.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.reserve.app.entity.LoginEntity;

@Mapper
@Repository
public interface LoginMapper {
	LoginEntity getUserInfo(Map<String,Object> param);
	
	void signup(Map<String,Object> param);
	
	int checkId(Map<String, Object>param);

}
