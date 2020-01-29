package com.internousdev.mocha.action;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.struts2.interceptor.SessionAware;

import com.internousdev.mocha.dao.MCategoryDAO;
import com.internousdev.mocha.dto.MCategoryDTO;
import com.internousdev.mocha.util.CommonUtility;
import com.opensymphony.xwork2.ActionSupport;
public class HomeAction extends ActionSupport implements SessionAware{
	private Map<String,Object> session;

	public String execute() throws SQLException{
		CommonUtility comUtil = new CommonUtility();
		List<MCategoryDTO> cateList = new ArrayList<MCategoryDTO>();
		MCategoryDAO mdao = new MCategoryDAO();

		//ログインフラグの有無の判定
		if(session.get("logined")==null)
		{	//ログインフラグがnullであるならば
			//ログインフラグを保持(未ログイン)
			session.put("logined", 0);//0:未ログイン, 1:ログイン済み
		}
		if(session.get("logined").toString().equals("0")&&session.get("tmp_UserId")==null){
			//未ログインかつ仮ユーザIDが存在しないなら
			//ランダムな16桁の仮ユーザIDを取得しsessionに保持
			//tmp_UserId 仮ユーザId
			session.put("tmp_UserId", comUtil.getRamdomValue());
		}

		//カテゴリをセッションに保存する処理を記述
		if(session.get("Category")==null) {
			cateList = mdao.getCategoryInfo();//ListでMカテゴリDTO取得
			session.put("Category", cateList);//セッションにput
		}

		return SUCCESS;
	}

	public Map<String, Object> getSession() {
		return session;
	}
	@Override
	public void setSession(Map<String, Object> session) {
		this.session = session;
	}

}
