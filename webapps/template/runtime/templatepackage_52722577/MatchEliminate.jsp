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
<head linkcolor="#16442d" visitedcolor="#946705"></head>
<epg:html>
<!-- 菜单导航-->
<epg:query queryName="getSeverialItems" maxRows="4" var="menus">
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 二级菜单导航-->
<epg:query queryName="getSeverialItems" maxRows="2" var="Twomenus">
	<epg:param name="categoryCode" value="${templateParams['TwomenuCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!--淘汰赛图推荐位-->
<epg:query queryName="getSeverialItems" maxRows="1" var="EliminateResults" >
	<epg:param name="categoryCode" value="${templateParams['EliminateCategoryCode']}" type="java.lang.String"/>
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
		if(document.getElementById("menu2_2_a")){
			document.getElementById("menu2_2_a").focus();
		}else{
			document.getElementById("menu2_a").focus();
		}
	}
}

</script>
<epg:body onload="init()"   bgcolor="#000000"  width="1280" height="720" >
<!-- bg/head -->
<epg:img defaultSrc="./images/EliminateBg.jpg" src="../${templateParams['backgroundImg']}" width="1280" height="720"/>

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

<!-- back -->
<epg:img id="quitMenu" left="1114" top="41" width="83" height="39" src="./images/dot.gif"  href="${returnUrl}"/>
<!-- 淘汰赛推荐图 -->
<epg:if test="${EliminateResults!=null}">
	<epg:img src="../${EliminateResults.itemIcon}" left="64" top="164" width="1153" height="510"/>
</epg:if>

</div>
</epg:body>
</epg:html>