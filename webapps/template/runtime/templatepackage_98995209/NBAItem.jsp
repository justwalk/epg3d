<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@ page language="java" import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*" %>
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
<epg:html >
<!-- menu navigation -->
<epg:query queryName="getSeverialItems" maxRows="5" var="menus">
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- news -->
<epg:query queryName="getSeverialItems" maxRows="11" var="news">
	<epg:param name="categoryCode" value="${templateParams['newsCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- competition -->
<epg:query queryName="getSeverialItems" maxRows="11" var="competitions">
	<epg:param name="categoryCode" value="${templateParams['competitionCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- get category itemIcon -->
<epg:choose>
	<epg:when test="${empty templateParams['targetCategoryCode']}">
		<epg:set value="${context['EPG_CATEGORY_CODE']}" var="targetCategoryCode"/>
	</epg:when>
	<epg:otherwise>
		<epg:set value="${templateParams['targetCategoryCode']}" var="targetCategoryCode"/>
	</epg:otherwise>
</epg:choose>
<epg:query queryName="getFirstCategoryByItemCode" maxRows="1" var="category">
	<epg:param name="itemCode" value="${targetCategoryCode}" type="java.lang.String"/>
</epg:query>

<epg:navUrl returnTo="home" returnUrlVar="returnToHomeUrl"></epg:navUrl>

<script src="${context['EPG_CONTEXT']}/js/event.js"></script>

<epg:head>
<style type="text/css">
body{
	color:#FFFFFF;
	font-size:22;
	font-family:"黑体";
}
img{border:0px solid black;}
div{position: absolute;}
</style>
<script>
var pageLoad = false;
var fristFocus = 0;
if (typeof(iPanel) == 'undefined') {
	pageLoad  = true;
}
var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images/";
function $(id){
	return document.getElementById(id);
}

function itemOnFocus(objId, imgName){
	if (pageLoad) {
		fristFocus++;
		$(objId + "_img").src = imgPath + imgName;
	}
}

function itemOnBlur(objId, imgName){
	if (pageLoad) {
		$(objId + "_img").src = imgPath + imgName;
	}
}
function back(){
	history.back();
}
function exit(){
	document.location.href = "${returnToHomeUrl}";
}

function eventHandler(eventObj){
	switch(eventObj.code)
	{
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
			exit();
			return 0;
			break;
		default:
			return 1;
			break;
	}
}
function firstFocus(){
	//document.getElementById("news1_a").focus();
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""&&document.getElementById(leaveFocusId+"_a")){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		if(document.getElementById("news1_a")!=null){
			document.getElementById("news1_a").focus();
		}else{
			document.getElementById("menu1_a").focus();
		}
	}
}
</script>
</epg:head>
<epg:body onload="firstFocus()" bgcolor="#000000">

<!-- background -->
<epg:img left="0" top="0" width="1280" height="720" defaultSrc="./images/NBATeamDetailBg.jpg"
		src="../${templateParams['backgroundImg']}"/>

<!-- 导航 -->
<epg:grid left="362" top="75" width="700" height="36" row="1" column="5" items="${menus}" var="menu" hcellspacing="20"
		indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${menu}" indexUrlVar="indexUrl"/>
	<epg:img id="menu${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="113" height="36"
		src="./images/dot.png" rememberFocus="true" href="${indexUrl}"
		onfocus="itemOnFocus('menu${curIdx}','NBAfocus1.png');" onblur="itemOnFocus('menu${curIdx}','dot.gif');"/>
</epg:grid>

<!-- 退出-->
<epg:img id="home" left="1105" top="75" width="113" height="36" href="javascript:back();"  src="./images/dot.png"
		onfocus="itemOnFocus('home','NBAfocus1.png');"  onblur="itemOnFocus('home','dot.gif');"/>

<!-- news -->
<epg:grid left="71" top="167" width="373" height="476" row="11" column="1" items="${news}" var="new" posVar="pos"
		indexVar="idx" vcellspacing="15">

	<epg:navUrl obj="${new}" indexUrlVar="indexUrl"/>
	<epg:text left="${pos[idx-1].x}" top="${pos[idx-1].y+6}" width="373" height="35" text="${new.title}" fontFamily="黑体"
		fontSize="22" color="#FFFFFF" chineseCharNumber="16" dotdotdot=" " align="left"/>
	<epg:img id="news${idx}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="373" height="35" src="./images/dot.gif"
		href="${indexUrl}" rememberFocus="true"
		onfocus="itemOnFocus('news${idx}','NBAfocus3.png');" onblur="itemOnBlur('news${idx}','dot.gif');"/>
</epg:grid>

<!-- competition -->
<epg:grid left="469" top="167" width="373" height="476" row="11" column="1" items="${competitions}" var="competition"
		posVar="pos" indexVar="idx" vcellspacing="15">
	<epg:navUrl obj="${competition}" indexUrlVar="indexUrl"/>
	<epg:text left="${pos[idx-1].x}" top="${pos[idx-1].y+6}" width="373" height="35" text="${competition.title}"
		fontFamily="黑体" fontSize="22" color="#FFFFFF" chineseCharNumber="16" dotdotdot=" " align="left"/>
	<epg:img id="competitions${idx}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="373" height="35"
		src="./images/dot.gif" href="${indexUrl}" rememberFocus="true"
		onfocus="itemOnFocus('competitions${idx}','NBAfocus3.png');"
		onblur="itemOnBlur('competitions${idx}','dot.gif');"/>
</epg:grid>

<%-- 
<!-- query category itemIcon -->
<epg:query queryName="getSeverialItems" maxRows="1000" var="items">
	<epg:param name="categoryCode" value="${param.itemCode}" type="java.lang.String"/>
</epg:query>
<!-- item detail img -->
<epg:forEach items="${items}" var="item" varStatus="idx">
	<epg:if test="${item.itemCode == context['EPG_CATEGORY_CODE']}">
		<epg:set value="${item.itemIcon}" var="itemIcon"/>
	</epg:if>
</epg:forEach>
--%>
<epg:img left="876" top="194" width="320" height="432" src="../${category.itemIcon}"/>

<%@include file="NBAMarquen.jsp"%>
</epg:body>
</epg:html>