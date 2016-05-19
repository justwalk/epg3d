<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*"%>
<%
	EpgUserSession eus = EpgUserSession.findUserSession(request);
	String eusLeaveFocusId = eus.getPlayFocusId() ;
	if(eusLeaveFocusId!=null){
		request.setAttribute("leaveFocusId",eusLeaveFocusId) ;
	}else{
		String myleaveFocusId = request.getParameter("leaveFocusId");
		if(myleaveFocusId!=null&&myleaveFocusId!=""){
			request.setAttribute("leaveFocusId",myleaveFocusId) ;
		}
	}
%>
<epg:html>
<!-- 菜单导航-->
<epg:query queryName="getSeverialItems" maxRows="4" var="menus">
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 二级菜单导航-->
<epg:query queryName="getSeverialItems" maxRows="2" var="Twomenus">
	<epg:param name="categoryCode" value="${templateParams['TwomenuCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 三级级菜单导航-->
<epg:query queryName="getSeverialItems" maxRows="8" var="Threemenus">
	<epg:param name="categoryCode" value="${templateParams['ThreemenuCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!--查询积分榜图推荐位-->
<epg:query queryName="getSeverialItems" maxRows="1" var="StandingsResults" >
	<epg:param name="categoryCode" value="${templateParams['StandingsCategoryCode']}" type="java.lang.String"/>
</epg:query>


<!--当前分组的赛事全场栏目内容-->
<epg:query queryName="getSeverialItems" maxRows="6" var="fullMatchList" >
	<epg:param name="categoryCode" value="${templateParams['fullMatchCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!--当前分组的赛事集锦栏目内容-->
<epg:query queryName="getSeverialItems" maxRows="6" var="highLightsList" >
	<epg:param name="categoryCode" value="${templateParams['highLightsCategoryCode']}" type="java.lang.String"/>
</epg:query>
<epg:navUrl returnTo="home" returnUrlVar="returnUrl"></epg:navUrl>
<epg:navUrl returnTo="biz" returnUrlVar="returnBizUrl"></epg:navUrl>
<style type="text/css">
body{
	color:#FFFFFF;
	font-size:22;
	font-family:"黑体";
}
img{border:0px solid black;}
</style>
<script src="${context['EPG_CONTEXT']}/js/base.js"></script>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script>
var pageLoad = false;
var fristFocus = 0;
if (typeof(iPanel) == 'undefined') {
	pageLoad  = true;
}
//监听事件
function eventHandler(eventObj){
	switch(eventObj.code){
		case "SYSTEM_EVENT_ONLOAD":
			pageLoad = true;
			break;
		case "SITV_KEY_UP":
			break;
		case "SITV_KEY_DOWN":
			break;
		case "EIS_IRKEY_SELECT":
			break;
		case "SITV_KEY_LEFT":
			break;
		case "SITV_KEY_RIGHT":
			break;
		case "SITV_KEY_PAGEUP":
			break;
		case "SITV_KEY_PAGEDOWN":
			break;
		case "SITV_KEY_BACK":
			back();
			return 0;
			break;
		case "SITV_KEY_EXIT":
			exit();
			return 0;
			break;
	  	case "SITV_KEY_MENU":
			iPanel.focus.display = 1;
			iPanel.focus.border = 1;
			iPanel.eventFrame.openIndex();
			return 0;
			break;
		default:
			return 1;
			break;
	}
}

function back(){
	window.location.href = "${returnBizUrl}";
}

function exit(){
	window.location.href = "${returnUrl}";
}

function init(){
	document.getElementById("main").style.display = "block";
	iPanel.focus.display = 1;
	iPanel.focus.border = 1;
	
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""&&document.getElementById(leaveFocusId+"_a")){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		if(document.getElementById("menu2_1_a")){
			document.getElementById("menu2_1_a").focus();
		}else{
			document.getElementById("menu2_a").focus();
		}
	}
}

</script>
<epg:body onload="init()"   bgcolor="#000000"  width="1280" height="720" >
<!-- bg/head -->
<epg:img defaultSrc="./images/GroupBg1.jpg" src="../${templateParams['backgroundImg']}" width="1280" height="720"/>

<!-- 同时显现处理 -->
<div id="main" style="display:none;position:absolute;left:0;top:0;width:1280;height:720;">
<!-- 导航菜单 -->
<epg:grid column="4" row="1" left="386" top="41" width="618" height="38"  items="${menus}" var="menu"  indexVar="curIdx" posVar="positions" hcellspacing="58">
	<epg:navUrl obj="${menu}" indexUrlVar="indexUrl"/>
		<epg:img id="menu${curIdx}" rememberFocus="true" 
			src="./images/dot.gif" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="111" height="38" href="${indexUrl}"/>
</epg:grid>

<!-- 二级导航菜单 -->
<epg:grid column="2" row="1" left="89" top="124" width="712" height="38"  items="${Twomenus}" var="menu"  indexVar="curIdx" posVar="positions" hcellspacing="440">
	<epg:navUrl obj="${menu}" indexUrlVar="indexUrl"/>
		<epg:img id="menu2_${curIdx}" rememberFocus="true" 
			src="./images/dot.gif" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="136" height="38" href="${indexUrl}"/>
</epg:grid>

<!-- 三级导航菜单 -->
<epg:grid column="8" row="1" left="147" top="172" width="986" height="31"  items="${Threemenus}" var="menu"  indexVar="curIdx" posVar="positions" hcellspacing="54">
	<epg:navUrl obj="${menu}" indexUrlVar="indexUrl"/>
		<epg:img id="menu3_${curIdx}" rememberFocus="true" 
			src="./images/dot.gif" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="76" height="31" href="${indexUrl}"/>
</epg:grid>
<!-- back -->
<epg:img id="quitMenu" left="1114" top="41" width="83" height="39" src="./images/dot.gif"  href="${returnUrl}"/>

<!-- 当前组赛程表 -->
<epg:if test="${templateParams['scheduleCategoryCode']==1}">
	<epg:img src="./images/match_A.jpg" left="124" top="215" width="783" height="257"/>
</epg:if>
<epg:if test="${templateParams['scheduleCategoryCode']==2}">
	<epg:img src="./images/match_B.jpg" left="124" top="215" width="783" height="257"/>
</epg:if>
<epg:if test="${templateParams['scheduleCategoryCode']==3}">
	<epg:img src="./images/match_C.jpg" left="124" top="215" width="783" height="257"/>
</epg:if>
<epg:if test="${templateParams['scheduleCategoryCode']==4}">
	<epg:img src="./images/match_D.jpg" left="124" top="215" width="783" height="257"/>
</epg:if>
<epg:if test="${templateParams['scheduleCategoryCode']==5}">
	<epg:img src="./images/match_E.jpg" left="124" top="215" width="783" height="257"/>
</epg:if>
<epg:if test="${templateParams['scheduleCategoryCode']==6}">
	<epg:img src="./images/match_F.jpg" left="124" top="215" width="783" height="257"/>
</epg:if>
<epg:if test="${templateParams['scheduleCategoryCode']==7}">
	<epg:img src="./images/match_G.jpg" left="124" top="215" width="783" height="257"/>
</epg:if>
<epg:if test="${templateParams['scheduleCategoryCode']==8}">
	<epg:img src="./images/match_H.jpg" left="124" top="215" width="783" height="257"/>
</epg:if>


<!-- 当前组积分表 -->
<epg:if test="${StandingsResults!=null}">
	<epg:img src="../${StandingsResults.itemIcon}" left="184" top="521" width="641" height="136"/>
</epg:if>

<!-- 右下推荐图 -->
<epg:img src="./images/GroupPic.jpg" left="873" top="483" width="280" height="140"/>

<!-- 当前组全场&集锦 -->
<epg:grid left="916" top="220" width="88" height="247" row="6" column="1" items="${fullMatchList}" var="list" indexVar="idx"
		  posVar="pos" vcellspacing="11">
	<epg:navUrl obj="${list}" indexUrlVar="indexUrl"/>
	<epg:img src="./images/Overall.png" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="88" height="32" href="${indexUrl}"/>
</epg:grid>
<epg:grid left="1026" top="220" width="88" height="247" row="6" column="1" items="${fullMatchList}" var="list" indexVar="idx"
		  posVar="pos" vcellspacing="11">
	<epg:navUrl obj="${list}" indexUrlVar="indexUrl"/>
	<epg:img src="./images/Highlights.png" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="88" height="32" href="${indexUrl}"/>
</epg:grid>

</div>
</epg:body>
</epg:html>