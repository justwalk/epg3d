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
<!-- menu navigation                                -->
<epg:query queryName="getSeverialItems" maxRows="5" var="menus">
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>

<!-- contents -->
<epg:query queryName="getSeverialItems" maxRows="10" var="stars">
	<epg:param name="categoryCode" value="${templateParams['starCategoryCode']}" type="java.lang.String"/>
</epg:query>

<epg:navUrl returnTo="home" returnUrlVar="returnToHomeUrl"></epg:navUrl>
<epg:navUrl returnTo="biz" returnUrlVar="returnUrl"></epg:navUrl>
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
 	document.location.href = "${returnToHomeUrl}";
 }
 function exit(){
 	document.location.href = "${returnToHomeUrl}";
 }
  function eventHandler(eventObj)
{
	switch(eventObj.code)
	{
		case "SYSTEM_EVENT_ONLOAD":
			pageLoad = true;
			break;
		case "SITV_KEY_UP":
			if(fristFocus==0){return 0;break;}
	    	break;
		case "SITV_KEY_DOWN":
			if(fristFocus==0){return 0;break;}
	    	break;
		case "EIS_IRKEY_SELECT":
			if(fristFocus==0){return 0;break;}
			break;
		case "SITV_KEY_LEFT":
			if(fristFocus==0){return 0;break;}
	    	break;
		case "SITV_KEY_RIGHT":
			if(fristFocus==0){return 0;break;}
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
			window.location.href = "${context['EPG_CONTEXT']}/common/logout/logout.jsp";
			return 0;
			break;
		default:
			return 1;
			break;
	}
}
function firstFocus(){
	//document.getElementById("star1_a").focus();
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""&&document.getElementById(leaveFocusId+"_a")){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		document.getElementById("star1_a").focus();
	}
}
</script>
</epg:head>
<epg:body onload="firstFocus()" bgcolor="#000000">

<!-- background -->
<epg:img left="0" top="0" width="1280" height="720" defaultSrc="./images/NBAStarBg.jpg"
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
<epg:img id="home" left="1105" top="75" width="113" height="36" href="${returnUrl}" src="./images/dot.png"
		 onfocus="itemOnFocus('home','NBAfocus1.png');"  onblur="itemOnFocus('home','dot.gif');"/>

<!-- content -->
<epg:grid left="133" top="165" width="1015" height="444" row="2" column="5" items="${stars}" var="star" posVar="pos"
		  indexVar="idx" hcellspacing="35" vcellspacing="36">
	
	<epg:navUrl obj="${star}" indexUrlVar="indexUrl"/>
	<epg:img id="star${idx}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="172" height="208" src="./images/dot.gif"
			 href="${indexUrl}&itemCode=${templateParams['starCategoryCode']}" 
			 onfocus="itemOnFocus('star${idx}','starFocus.png');" onblur="itemOnBlur('star${idx}','dot.gif');"
			 rememberFocus="true"/>
</epg:grid>

<%@include file="NBAMarquen.jsp"%>
</epg:body>
</epg:html>