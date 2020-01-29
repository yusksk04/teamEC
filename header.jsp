<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>

<!DOCTYPE html>
<html lang="ja">
<head>
	<meta charset="UTF-8">
	<link rel="stylesheet" type="text/css" href="./css/header.css">
	<title>header画面</title>
</head>
<body>
<header>
	<ul>
		<li><div class="team">Mocha</div></li>
		<!-- 検索窓 -->
		<s:form action="SearchItemAction">
			<s:if test="#session.Category !=null">
					<li>
						<select class="category_box" name="categoryId">
							<s:iterator value="#session.Category" begin="0" status="state">
								<s:if test="(cateId==null&&#state.count==1)||#state.count==cateId">
									<option value=<s:property value="category_id" /> selected><s:property value="category_name"/></option>
								</s:if>
								<s:else>
									<option value=<s:property value="category_id"/>><s:property value="category_name"/></option>
								</s:else>
							</s:iterator>
						</select>
					</li>
			</s:if>
			<li><s:textfield class="serch_box" name="searchProductName" placeholder="検索ワード"/></li>
			<li><input type="submit" class="header_btn" value="商品検索"></li>
		</s:form>
		<!-- メニューバーボタン -->
		<s:if test="#session.logined==0 || #session.logined==null ">
			<s:form action="GoLoginAction">
				<li><input type="submit" class="header_btn" value="ログイン" class="submit_button"></li>
			</s:form>
		</s:if>
		<s:if test="#session.logined==1">
			<s:form action="LogoutAction">
				<li><input type="submit" class="header_btn" value="ログアウト"></li>
			</s:form>
		</s:if>
		<s:form action="CartAction">
				<li><input type="submit" class="header_btn" value="カート"></li>
		</s:form>
		<s:form action="SearchItemAction">
				<li><input type="submit"class="header_btn"  value="商品一覧"></li>
		</s:form>
		<s:if test="#session.logined==1">
			<s:form action="MyPageAction">
				<li><input type="submit"class="header_btn"  value="マイぺージ"></li>
			</s:form>
		</s:if>
	</ul>
</header>

</body>
</html>