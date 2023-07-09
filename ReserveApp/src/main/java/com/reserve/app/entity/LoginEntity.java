package com.reserve.app.entity;


import java.util.Collection;
import java.util.Collections;
import java.util.Objects;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

public class LoginEntity implements UserDetails {

	private static final long serialVersionUID = -4933654282176875823L;
	private String id;
	private String password;
	private String user_role;
	private String name;
	private String phone_number;
	private String due_date;
	private String hospital;
	private String branch_code;
	
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		return Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + this.user_role));
	}
	
	@Override
	public String getPassword() {
		return this.password;
	}
	
	@Override
	public String getUsername() {
		return this.id;
	}
	
	@Override
	public boolean isAccountNonExpired() {
		return true;
	}
	
	@Override
	public boolean isAccountNonLocked() {
		return true;
	}
	
	@Override
	public boolean isCredentialsNonExpired() {
		return true;
	}
	
	@Override
	public boolean isEnabled() {
		return true;
	}
	
	public String getId() {
		return id;
	}
	
	public void setId(String id) {
		this.id = id;
	}
	
	public void setPassword(String password) {
		this.password = password;
	}
	
	public String getUser_role() {
		return user_role;
	}
	
	public void setUser_role(String user_role) {
		this.user_role = user_role;
	}
	
	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getPhone_number() {
		return phone_number;
	}
	
	public void setPhone_number(String phone_number) {
		this.phone_number = phone_number;
	}
	
	public String getDue_date() {
		return due_date;
	}
	
	public void setDue_date(String due_date) {
		this.due_date = due_date;
	}
	
	public String getHospital() {
		return hospital;
	}
	
	public void setHospital(String hospital) {
		this.hospital = hospital;
	}
	
	public String getBranch_code() {
		return branch_code;
	}
	
	public void setBranch_code(String branch_code) {
		this.branch_code = branch_code;
	}

	@Override
	public String toString() {
		return "LoginEntity [id=" + id + ", password=" + password + ", user_role=" + user_role + ", name=" + name
				+ ", phone_number=" + phone_number + ", due_date=" + due_date + ", hospital=" + hospital
				+ ", branch_code=" + branch_code + "]";
	}

	@Override
	public int hashCode() {
		return Objects.hash(branch_code, due_date, hospital, id, name, password, phone_number, user_role);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		LoginEntity other = (LoginEntity) obj;
		return Objects.equals(branch_code, other.branch_code) && Objects.equals(due_date, other.due_date)
				&& Objects.equals(hospital, other.hospital) && Objects.equals(id, other.id)
				&& Objects.equals(name, other.name) && Objects.equals(password, other.password)
				&& Objects.equals(phone_number, other.phone_number) && Objects.equals(user_role, other.user_role);
	}
}

