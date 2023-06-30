package com.reserve.app.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.reserve.app.entity.LoginEntity;

@Mapper
public interface LoginMapper {
	LoginEntity getUserInfo(Map<String,Object> param);
}
