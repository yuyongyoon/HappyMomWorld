package com.reserve.app.interceptor;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.executor.Executor;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.plugin.Interceptor;
import org.apache.ibatis.plugin.Intercepts;
import org.apache.ibatis.plugin.Invocation;
import org.apache.ibatis.plugin.Signature;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.RowBounds;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;

import com.reserve.app.entity.LoginEntity;

@Intercepts({
	@Signature(type=Executor.class, method="update", args= {MappedStatement.class, Object.class}), //insert, update 때 사용
	@Signature(type=Executor.class, method="query", args= {MappedStatement.class, Object.class, RowBounds.class, ResultHandler.class}) //select 때문에 추가
})
public class MybatisInterceptor implements Interceptor {
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public Object intercept(Invocation invocation) throws Throwable {
		Object[] args = invocation.getArgs();
		Object param = args[1];
	
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String userName = null;
		String branchCode = null;
	
		if (authentication != null && authentication.isAuthenticated()) {
			userName = authentication.getName();
			Object principal = authentication.getPrincipal();
			if (principal instanceof UserDetails) {
				branchCode = ((LoginEntity) ((UserDetails) principal)).getBranch_code();
			}
		}
	
		if (userName != null && param instanceof HashMap) {
			((HashMap) param).put("login_id", userName);
			((HashMap) param).put("branch_code", branchCode);
		} else if (userName != null) {
			Map<String, Object> newParam = new HashMap<>();
			newParam.put("login_id", userName);
			args[1] = newParam;
		}
	
		return invocation.proceed();
	}
}
