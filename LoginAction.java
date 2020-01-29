package com.internousdev.mocha.action;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.struts2.interceptor.SessionAware;

import com.internousdev.mocha.dao.CartInfoDAO;//カート情報
import com.internousdev.mocha.dao.UserInfoDAO;//ユーザー情報
import com.internousdev.mocha.dto.CartInfoDTO;//カート情報
import com.internousdev.mocha.dto.UserInfoDTO;//ユーザー情報
import com.internousdev.mocha.util.InputChecker;//入力チェック
import com.opensymphony.xwork2.ActionSupport;
public class LoginAction extends ActionSupport implements SessionAware{

	private String loginUserId;//login.jspで入力されたユーザID
	private String loginPassword;//login.jspで入力されたパスワード
	private boolean keepUserId;//ユーザーID保持チェックボックス
	private List<String> idInputError ;//入力チェックのエラーメッセージを保存
	private List<String> passInputError;//入力パスワードのエラーメッセージを保存
	private UserInfoDTO userDTO;//ユーザ情報
	private List<CartInfoDTO> cartList =new ArrayList<CartInfoDTO>();//カート情報
	private Map<String, Object> session;

	private int totalSumPrice;//カートの合計金額

	static final int IDMINLENGTH =1;//ユーザーIDの最小値
	static final int IDMAXLENGTH = 8;//ユーザーIDの最大値
	static final int PASSMINLENGTH =1;//ユーザーIDの最小値
	static final int PASSMAXLENGTH = 16;//ユーザーIDの最大値

	public String execute() throws SQLException{
		CartInfoDAO cartDAO = new CartInfoDAO();
		UserInfoDAO userDAO = new UserInfoDAO();
		InputChecker inputCheck = new InputChecker();
		idInputError = new ArrayList<String>();
		passInputError = new ArrayList<String>();


		session.remove("keepId");

		//login_user_idはcreateCompleteActionでputされる登録完了したuserID
		if(!(session.containsKey("login_user_id"))) {
			//ユーザ情報画面から来ていないなら
			//入力チェックメソッドを実行
			//ユーザーID入力チェック
			if(StringUtils.isEmpty(loginUserId)) {
				//入力がされていない場合空文字を代入
				loginUserId="";
			}
			idInputError =inputCheck.doCheck("ユーザーID", loginUserId, IDMINLENGTH, IDMAXLENGTH, true, false, false, true, false, false);
			//パスワード入力チェック
			if(StringUtils.isEmpty(loginPassword)) {
				loginPassword="";//空文字代入
			}
			passInputError =inputCheck.doCheck("パスワード", loginPassword, PASSMINLENGTH, PASSMAXLENGTH, true, false, false, true, false, false);
			if(idInputError.size() !=0||passInputError.size() !=0) {
				//入力チェックエラー有りなら
				return ERROR;//login.jspへ
			}

			//入力チェックエラーなしなら
			//会員情報テーブルでログインチェック
			userDTO = userDAO.getLoginUserInfo(loginUserId, loginPassword);
			if(userDTO.getLoginFlg()==0) {//0:失敗 1:成功
				//認証に失敗したなら
				//エラーを返して自画面に遷移
				idInputError.add("ユーザーIDまたはパスワードが異なります。");
				return ERROR;
			}
		}
		else {//入力完了画面から来ていた場合sessionに保存された登録完了情報を取得する
			loginUserId=session.get("login_user_id").toString();
			session.remove("login_user_id");
		}
		//セッションエラーの判定
		//session("userId") 現在ログインしているユーザID
		if(session.get("tmp_UserId")==null&& session.get("userId")==null) {
			//仮ユーザIDとユーザIDの両方が存在しない場合
			return "sessionTimeout";
		}
		//////////カート情報の紐づけ//////////
		//認証成功したらカートテーブルから仮ユーザIdに基づくカート情報を取得
		//仮ユーザIDに基づくカート情報を取得 …①
		cartList = cartDAO.getCartInfoList(session.get("tmp_UserId").toString());
		if(cartList.size()>0) {
		//カート情報があるなら

			for(CartInfoDTO cdto:cartList) {//リストの数だけ繰り返す

				boolean updateCheck=false;
				boolean updateIdCheck=false;
				updateCheck=cartDAO.cartInfoUpdateCount(loginUserId, cdto.getProduct_id(), cdto.getProduct_count());
				//ユーザIDと①で取得した商品IDに一致するカート情報の個数に①で取得したカート情報の個数(引数として指定)を加算…②
				if(updateCheck) {
					//成功したら①のIDのカート情報を削除する…③
					cartDAO.cartInfoDelete(cdto.getId());

				}else {
					updateIdCheck=cartDAO.cartInfoUpdateId(loginUserId, cdto.getId());
					//②の処理の結果が存在しない場合商品IDが一致するカート情報が存在しないので
					//①で取得したカート情報のユーザID(仮ユーザID)を現在ログインしようとしているユーザIDに更新する

				}

				if(updateCheck==false&&updateIdCheck==false) {
					//全て失敗した場合 紐づけ失敗としてエラーページへ
					return "DBerror";//システムエラーページへ
				}
			}
		}

		//カート情報の紐づけに成功したら
		///////【処理】認証情報処理////////
		session.put("userId", loginUserId);//現在のユーザIDをDBから取得したuser_Idに
		session.put("logined", 1);//ログインフラグを１(ログイン済み)に
		session.remove("tmp_UserId");//仮ユーザIDを破棄
		if(keepUserId==true) {
			//ユーザIDの保存がチェックされていれば
			session.put("keepId",true);//keepId false:保持しない true:保持する
		}else {
			session.remove("keepId");
		}

		/////////カートフラグの有無のチェック////////
		//containsKeyで有無のチェックができる
		if(session.get("cartFlg")==null) {
			//無いとき SUCCESSを返すz
			return SUCCESS;//home.jspへ
		}else {
			//ある時は
			//カート情報にある商品情報をDBから取得　次ページに渡す
			//カート情報のユーザID[を元に商品ID,個数を取得
			//その商品IDを元に商品情報を取得する
			cartList = cartDAO.getCartInfo(session.get("userId").toString());
			session.remove("cartFlg");
			totalSumPrice= cartDAO.getTotalSumPrice(loginUserId);
			return "cart";//cart.jspへ
		}

	}

	public String getLoginUserId() {
		return loginUserId;
	}
	public void setLoginUserId(String loginUserId) {
		this.loginUserId = loginUserId;
	}
	public String getLoginPassword() {
		return loginPassword;
	}
	public void setLoginPassword(String loginPassword) {
		this.loginPassword = loginPassword;
	}
	public boolean isKeepUserId() {
		return keepUserId;
	}
	public void setKeepUserId(boolean keepUserId) {
		this.keepUserId = keepUserId;
	}
	public Map<String, Object> getSession() {
		return session;
	}
@Override
	public void setSession(Map<String, Object> session) {
		this.session = session;
	}
	public List<CartInfoDTO> getCartList() {
		return cartList;
	}

	public int getTotalSumPrice() {
		return totalSumPrice;
	}
	public List<String> getIdInputError() {
		return idInputError;
	}
	public List<String> getPassInputError() {
		return passInputError;
	}

}
