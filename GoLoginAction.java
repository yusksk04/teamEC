package com.internousdev.mocha.action;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.struts2.interceptor.SessionAware;

import com.opensymphony.xwork2.ActionSupport;
public class GoLoginAction extends ActionSupport implements SessionAware{
	private String cartPage;
	private Map<String, Object>session;
	public String execute() {
		if(!(StringUtils.isEmpty(cartPage)) &&cartPage.equals("true")) {//cart.jspから来ていた場合
			session.put("cartFlg", 1);
		}
		return SUCCESS;
	}
	public String getCartpage() {
		return cartPage;
	}
	public void setCartpage(String cartpage) {
		this.cartPage = cartpage;
	}
	public String getCartPage() {
		return cartPage;
	}
	public void setCartPage(String cartPage) {
		this.cartPage = cartPage;
	}
	public Map<String, Object> getSession() {
		return session;
	}
	@Override
	public void setSession(Map<String, Object> session) {
		this.session = session;
	}

}
