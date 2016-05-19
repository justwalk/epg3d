<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<head linkcolor="#16442d" visitedcolor="#946705"></head>
<epg:html viewSize="1280*720">
<!-- 菜单导航-->
<epg:query queryName="getSeverialItems" maxRows="4" var="menus">
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>


<!--查询左侧推荐位图-->
<epg:query queryName="getSeverialItems" maxRows="1" var="leftPicResults" >
	<epg:param name="categoryCode" value="${templateParams['leftCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!--查询右侧推荐位图-->
<epg:query queryName="getSeverialItems" maxRows="1" var="rightPicResults" >
	<epg:param name="categoryCode" value="${templateParams['rightCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- vote -->
<epg:query queryName="getSeverialItems" maxRows="1" var="vote" >
	<epg:param name="categoryCode" value="${templateParams['voteCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 获取投票选择项 -->
<epg:query queryName="getEpgVoteWithChooseByVoteCodeAndType" maxRows="2" var="voteItems">
	<epg:param name="VOTE_CODE" value="${vote.itemCode}" type="java.lang.String"/>
	<epg:param name="TYPE" value="${templateParams['voteType']}" type="java.lang.String"/>
</epg:query>
<style type="text/css">
body{
	color:#FFFFFF;
	font-size:22;
	font-family:"黑体";
}
img{border:0px solid black;}
</style>

<epg:body viewSize="1280*720" onload="init()"   bgcolor="#000000"  width="1280" height="720" >
<!-- bg/head -->
<epg:img defaultSrc="./images/GuessBg.jpg" src="../${templateParams['backgroundImg']}" width="1280" height="720"/>

<!-- back -->
<epg:navUrl returnTo="biz" returnUrlVar="returnUrl"/>
<epg:img id="quitMenu" left="1114" top="41" width="83" height="39" src="./images/dot.gif"  href="${returnUrl}"/>

<!-- 竞猜题目 -->
<epg:if test="${voteItems[0] != null}">
	<epg:text left="0" top="0" width="556" height="78" chineseCharWidth="22"
			needBlank="true" multi="true" output="false" lines="descript"
			lineNum="3">${voteItems[0].name}</epg:text>
		<epg:forEach items="${descript}" varStatus="status"
			var="descriptContent" begin="0" end="1">
					<epg:text left="357" top="215" width="577" height="75" fontSize="30" multi="false" color="#530251"
						text="${descriptContent.content}" />
		</epg:forEach>
</epg:if>
<!-- 竞猜选项 -->
<epg:if test="${voteItems[0]!=null}">
	<epg:navUrl obj="${voteItems[0]}" voteUrlVar="vote0Url"/>
	<epg:text id="list0" color="#FFFFFF" left="425" top="335" width="197" height="39" align="center" chineseCharNumber="5">A ${voteItems[0].chooseName}</epg:text>
	<epg:img  left="423" top="327" width="197" height="39" src="./images/dot.gif"  href="${vote0Url}&needLimit=true&voteMethod=good&needEnterMobile=1&returnUrl=${returnUrl}&bizType=ojs&macAddress=${EPG_USER.stbMac}"/>
</epg:if> 
<epg:if test="${voteItems[1]!=null}">
	<epg:navUrl obj="${voteItems[1]}" voteUrlVar="vote1Url"/>
	<epg:text id="list1" color="#FFFFFF" left="664" top="335" width="197" height="39" align="center" chineseCharNumber="5">B ${voteItems[1].chooseName}</epg:text>
	<epg:img  left="661" top="327" width="197" height="39" src="./images/dot.gif"  href="${vote1Url}&needLimit=true&voteMethod=good&needEnterMobile=1&returnUrl=${returnUrl}&bizType=ojs&macAddress=${EPG_USER.stbMac}"/>
</epg:if>
<!-- 中奖尾号 -->
<epg:if test="${voteItems[0]!=null}">							
							<epg:text id="des" left="830" top="200" color="#666666" chineseCharNumber="5">${voteItems[0].descript}</epg:text>
</epg:if>
<!-- 左侧推荐图 -->
<epg:if test="${leftPicResults!=null}">
	<epg:img src="../${leftPicResults.itemIcon}" left="77" top="146" width="226" height="487"/>
</epg:if>
<!-- 右侧推荐图 -->
<epg:if test="${rightPicResults!=null}">
	<epg:img src="../${rightPicResults.itemIcon}" left="977" top="146" width="226" height="487"/>
</epg:if>
</epg:body>
</epg:html>