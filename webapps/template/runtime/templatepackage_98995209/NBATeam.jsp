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
<!-- teams category -->
<epg:query queryName="getSeverialItems" maxRows="2" var="teams">
	<epg:param name="categoryCode" value="${templateParams['teamCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- west team -->
<epg:query queryName="getSeverialItems" maxRows="15" var="wesTeams">
	<epg:param name="categoryCode" value="${teams[0].itemCode}" type="java.lang.String"/>
</epg:query>
<!-- east team -->
<epg:query queryName="getSeverialItems" maxRows="15" var="easTeams">
	<epg:param name="categoryCode" value="${teams[1].itemCode}" type="java.lang.String"/>
</epg:query>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>

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
	//document.getElementById("wesTeam1_a").focus();
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""&&document.getElementById(leaveFocusId+"_a")){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		document.getElementById("wesTeam1_a").focus();
	}
}
</script>
</epg:head>
<epg:body  onload="firstFocus()" bgcolor="#000000">

<!-- background -->
<epg:img left="0" top="0" width="1280" height="720" defaultSrc="./images/NBATeamBg.jpg"
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
<epg:navUrl returnTo="home" returnUrlVar="returnUrl"/>
<epg:img id="home" left="1105" top="75" width="113" height="36" href="${returnUrl}" src="./images/dot.png"
		 onfocus="itemOnFocus('home','NBAfocus1.png');"  onblur="itemOnFocus('home','dot.gif');"/>

<!-- west team -->
<epg:grid left="98" top="198" width="524" height="412" row="3" column="5" items="${wesTeams}" var="wesTeam" posVar="pos"
		  indexVar="idx" hcellspacing="15" vcellspacing="13">
	
	<epg:navUrl obj="${wesTeam}" indexUrlVar="indexUrl"/>
	<epg:img id="wesTeam${idx}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="96" height="132" src="./images/dot.gif"
			 href="${indexUrl}&itemCode=${teams[0].itemCode}" 
			 onfocus="itemOnFocus('wesTeam${idx}','teamFocus.png');" onblur="itemOnBlur('wesTeam${idx}','dot.gif');"
			 rememberFocus="true"/>
</epg:grid>

<!-- east team -->
<epg:grid left="660" top="198" width="524" height="412" row="3" column="5" items="${easTeams}" var="easTeam" posVar="pos"
		  indexVar="idx" hcellspacing="15" vcellspacing="13">
	<epg:navUrl obj="${easTeam}" indexUrlVar="indexUrl"/>
	<epg:img id="easTeam${idx}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="96" height="132" src="./images/dot.gif"
			 href="${indexUrl}&itemCode=${teams[1].itemCode}" rememberFocus="true"
			 onfocus="itemOnFocus('easTeam${idx}','teamFocus.png');" onblur="itemOnBlur('easTeam${idx}','dot.gif');"/>
</epg:grid>

<%@include file="NBAMarquen.jsp"%>
</epg:body>
</epg:html>