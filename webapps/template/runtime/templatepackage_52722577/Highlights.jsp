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

<!-- 内容部分 -->
<epg:query queryName="getSeverialItems" maxRows="9" var="lists"
		   pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true">
	<epg:param name="categoryCode" value="${templateParams['programCategoryCode']}" type="java.lang.String"/>
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
	iPanel.focus.defaultFocusColor = "#ff4800";
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
			pageUp();
			return 0;
			break;
		case "SITV_KEY_PAGEDOWN":
			pageDown();
			return 0;
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

function pageUp(){
  	var previousUrl = "${pageBean.previousUrl}";
	var myPageIndex = "";
	if(previousUrl.indexOf("&pageIndex=")!=-1){
		myPageIndex = previousUrl.substring(previousUrl.indexOf("&pageIndex="),previousUrl.length);
		previousUrl =previousUrl.substring(0,previousUrl.indexOf("&pageIndex="));
	}
	if(previousUrl.indexOf("&leaveFocusId=")!=-1){
		previousUrl = previousUrl.substring(0,previousUrl.indexOf("&leaveFocusId="));
	}
 	document.location.href = previousUrl+"&leaveFocusId=area_upPage"+myPageIndex;
}
function pageDown(){
 	var nextUrl = "${pageBean.nextUrl}";
	var myPageIndex = "";
	if(nextUrl.indexOf("&pageIndex=")!=-1){
		myPageIndex = nextUrl.substring(nextUrl.indexOf("&pageIndex="),nextUrl.length);
		nextUrl =nextUrl.substring(0,nextUrl.indexOf("&pageIndex="));
	}
	if(nextUrl.indexOf("&leaveFocusId=")!=-1){
		nextUrl = nextUrl.substring(0,nextUrl.indexOf("&leaveFocusId="));
	}
 	document.location.href = nextUrl+"&leaveFocusId=area_downPage"+myPageIndex;
}

function init(){
	document.getElementById("main").style.display = "block";
	iPanel.focus.display = 1;
	iPanel.focus.border = 1;
	
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""&&document.getElementById(leaveFocusId+"_a")){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		if(document.getElementById("listContent1_a")){
			document.getElementById("listContent1_a").focus();
		}else{
			document.getElementById("menu4_a").focus();
		}
	}
}
</script>
<epg:body onload="init()"   bgcolor="#000000"  width="1280" height="720" >
<!-- bg/head -->
<epg:img defaultSrc="./images/HighlightsBg.jpg" src="../${templateParams['backgroundImg']}" width="1280" height="720"/>

<!-- 同时显现处理 -->
<div id="main" style="display:none;position:absolute;left:0;top:0;width:1280;height:720;">

<!-- 导航菜单 -->
<epg:grid column="4" row="1" left="386" top="41" width="618" height="38"  items="${menus}" var="menu"  indexVar="curIdx" posVar="positions" hcellspacing="58">
	<epg:navUrl obj="${menu}" indexUrlVar="indexUrl"/>
		<epg:img id="menu${curIdx}" rememberFocus="true" 
			src="./images/dot.gif" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="111" height="38" href="${indexUrl}"/>
</epg:grid>

<!-- back -->
<epg:img id="quitMenu" left="1114" top="41" width="83" height="39" src="./images/dot.gif"  href="${returnUrl}"/>

<!--上下页-->
<epg:img src="./images/dot.gif" id="area_upPage"  left="113" top="131"  width="88" height="32" href="javascript:pageUp();"/>
<epg:img src="./images/dot.gif" id="area_downPage"  left="223" top="131"  width="88" height="32" href="javascript:pageDown();"/>
<div style="position:absolute; top:131px; left:333px; width:100px; height:22px; font-size:26px; " >
	<span style="color:#16442d">${pageBean.pageIndex}/${pageBean.pageCount}</span>
</div>

<!-- contents -->
<epg:grid left="165" top="190" width="950" height="460" row="3" column="3" items="${lists}" var="list" indexVar="idx"
		posVar="pos" hcellspacing="55" vcellspacing="20">
	<epg:navUrl obj="${list}" indexUrlVar="indexUrl"/>
	<epg:img id="listContent${idx}" src="../${list.itemIcon}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="280" height="140" href="${indexUrl}"/>
</epg:grid>

</div>
</epg:body>
</epg:html>