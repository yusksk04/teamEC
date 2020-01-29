<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>

<!DOCTYPE html>
<html lang="ja">
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" type="text/css" href="./css/style.css">
	<link rel="stylesheet" type="text/css" href="./css/inputForm.css">
	<title>login画面</title>
</head>
<header>
	<%@ include file="header.jsp" %>
</header>
<body>
	<h1>ログイン画面</h1>
	<s:if test="idInputError.size()!=0">
		<div class="error">
			<s:iterator value="idInputError">
				<s:property/><br>
			</s:iterator>
		</div>
	</s:if>
	<s:if test="passInputError.size()!=0">
		<div class="error">
			<s:iterator value="passInputError">
				<s:property/><br>
			</s:iterator>
		</div>
	</s:if>
	<div class="input_form">

	<!-- 入力フォーム ここから-->
		<s:form action="LoginAction">
		<table class="input_table">
			<tr>
				<th>ユーザーID</th>
				<s:if test="#session.keepId==true">
				 	<td><s:textfield cssClass="input_login" name="loginUserId" value="%{#session.userId}" autocomplete="off" placeholder="ユーザーID"/></td>
				</s:if>
				<s:else>
					<td><s:textfield cssClass="input_login" name="loginUserId" value="%{loginUserId}" autocomplete="off" placeholder="ユーザーID"/></td>
				</s:else>
			</tr>
			<tr>
				<th>パスワード</th>
				<td><s:password cssClass="input_login" name="loginPassword"  placeholder="パスワード"/></td>
			</tr>
		</table>
			<div class="checkbox_box">
				<s:if test="#session.keepId==true">
					<s:checkbox cssClass="checkbox" name="keepUserId" fieldValue="true" value="true"/>
				</s:if>
				<s:else>
					<s:checkbox cssClass="checkbox" name="keepUserId" Value="false"/>
				</s:else>
				<s:label value="ユーザーID保存"/>
			</div>
			<div class="submit_btn_box"><input  class="submit_btn" type="submit" value="ログイン"/></div>
		</s:form>

<!-- 	ここまで -->
		<s:form action="CreateUserAction">
			<div class="submit_btn_box"><input class="submit_btn" type="submit" value="新規ユーザー登録"/></div>
		</s:form>
		<s:form action="ResetPasswordAction">
			<div class="submit_btn_box"><input class="submit_btn" type="submit" value="パスワード再設定"/></div>
		</s:form>
	</div>
</body>
</html>