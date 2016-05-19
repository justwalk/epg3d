<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@page import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*"%>
<% 
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setDateHeader("Expires", 0); 
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
<epg:query queryName="queryUserHistoryByUserId" maxRows="18" var="historys">
	<epg:param name="USER_ID" value="${EPG_USER.userAccount}" type="java.lang.String"/>
</epg:query>
<epg:query queryName="getSevrialCollectionByUserId" maxRows="999" var="collects"  pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true">
	<epg:param name="user_id" value="${EPG_USER.userAccount}" type="java.lang.String"/>
</epg:query>
<!-- head button -->
<epg:navUrl returnTo="home" returnUrlVar="returnHomeUrl"></epg:navUrl>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<style type="text/css">
body{
	color:#FFFFFF;
	font-size:22;
	font-family:"黑体";
}
img{border:0px solid black;}
a{outline:none;}
</style>
<script>

var pageLoad = false;
var fristFocus = 0;
if (typeof(iPanel) == 'undefined') {
	pageLoad  = true;
}
function $(_id) {
	return "string" == typeof _id ? document.getElementById(_id) : _id;
}

var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images";
function menuOnFocus(objId,color){
	if (pageLoad) {
		fristFocus++;
		$(objId).style.backgroundColor = color;
		if(objId == "menuBg3"){
			$("collectInfoBg_img").src = imgPath + "/collectCountOnFocus.png";
		}
	}
}

function menuOnBlur(objId,color){
	if (pageLoad) {
		$(objId).style.backgroundColor = color;
		if(objId == "menuBg3"){
			$("collectInfoBg_img").src = imgPath + "/collectCount.png";
		}
	}
}

function buttonOnFocus(objId,img,txtName){
	if (pageLoad) {
		fristFocus++;
		$(objId+"_img").src=imgPath+"/"+img+".png";
		if(txtName != "" && txtName != null){
			$(txtName+"_span").style.color = "#ffffff";
		}
	}
}

function buttonOnBlur(objId,img,txtName){
	if (pageLoad) {
		fristFocus++;
		$(objId+"_img").src=imgPath+"/"+img+".png";
		if(txtName != "" && txtName != null){
			$(txtName+"_span").style.color = "#333";
		}
	}
}

//监听事件
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
	    	window.location.href = "${returnHomeUrl}";
			return 0;
	    	break;
		case "SITV_KEY_EXIT":
			window.location.href = "${returnHomeUrl}";
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
function init()
{		
	//var leaveFocusId = "${leaveFocusId}";
	//if(leaveFocusId!=""){
	//	document.getElementById(leaveFocusId+"_a").focus();
	//}else{
		document.getElementById("historyFocus1_a").focus();
	//}
}
</script>
<epg:body bgcolor="#000000" onload="init();" width="1280" defaultBg="./images/histroy.jpg"  height="720" style="background-repeat:no-repeat;" >

<div style="position:absolute;left:0px; top:0px; width:350px; height:85px;">
<epg:img src="./images/logo.png"  width="350" height="85"/>
</div>

<epg:img id="search" rememberFocus="true" src="./images/dot.png" left="1051" top="47" width="80" height="38"
		 onfocus="buttonOnFocus('search','focusMenuTop_1');" onblur="buttonOnFocus('search','dot');"
		 href="${context['EPG_SEARCH_URL']}"/>
<!--		 
<epg:img src="./images/dot.gif" id="zz"  left="1051" top="47" width="80" height="38"
	href="${context['EPG_MYCOLLECTION_URL']}" onfocus="buttonOnFocus('zz','focusMenuTop_2');"  onblur="buttonOnFocus('zz','dot');" />
	-->	 

<epg:img id="back" rememberFocus="true" src="./images/dot.png" left="1152" top="47"width="80" height="38"
	     onfocus="buttonOnFocus('back','focusMenuTop_3');" onblur="buttonOnFocus('back','dot');"
	     href="${returnHomeUrl}"/>
		 
<!--<epg:img id="buyRecords" left="50" top="90" width="391" height="45" href="${context['EPG_SELF_URL']}" src="./images/dot.gif"
		 onfocus="buttonOnFocus('buyRecords','buyRecordOnfocus');" onblur="buttonOnBlur('buyRecords','dot');"/>-->
<epg:img id="history" left="50" top="90" width="391" height="45" href="${context['EPG_HISTORY_URL']}" src="./images/dot.gif"
		 onfocus="buttonOnFocus('history','historyOnfocus');" onblur="buttonOnBlur('history','dot');"/>
<epg:img id="collect" left="443" top="90" width="391" height="45" href="${context['EPG_MYCOLLECTION_URL']}" src="./images/dot.gif"
		 onfocus="buttonOnFocus('collect','collectOnfocus');" onblur="buttonOnBlur('collect','dot');"/>

		 
		 
<epg:navUrl obj="${historys[0]}" delectHistoryUrlVar="delectHistoryUrl"/>
<epg:img id="clear" left="50" top="166" width="130" height="32" href="${delectHistoryUrl}" src="./images/dot.gif"
		 onfocus="buttonOnFocus('clear','clearOnfocus');" onblur="buttonOnBlur('clear','dot');"/>


<epg:choose>
	<epg:when test="${pageBean == null}">
		<epg:set value="0" var="collectCount"/>
	</epg:when>
	<epg:otherwise>
		<epg:set value="${pageBean.totalCount}" var="collectCount"/>
	</epg:otherwise>
</epg:choose>
<epg:text left="746" top="104" width="80" height="30" text="${collectCount}部"
		  fontFamily="黑体" fontSize="20" color="#fff" align="center"/>
<!-- contents column 1 -->
<epg:grid left="50" top="223" width="580" height="405" row="9" column="1" items="${historys}" var="history"
 		  indexVar="idx" posVar="pos" begin="0" length="9" align="left">
	<epg:navUrl obj="${history}" indexUrlVar="indexUrl"/>
	
	<epg:img id="historyBg${idx}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="580" height="45"
			 src="./images/dot.png"/>
	<epg:text id="history${idx}" left="${pos[idx-1].x+50}" top="${pos[idx-1].y+12}" width="580" height="45"
			  text="${history.contentName}" align="left" fontFamily="黑体" fontSize="22" color="#333"/>
	<epg:img id="historyFocus${idx}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="40" height="45" src="./images/dot.png"
			 href="${indexUrl}" onfocus="buttonOnFocus('historyBg${idx}','historyPlay','history${idx}');"
			 onblur="buttonOnBlur('historyBg${idx}','dot','history${idx}');" rememberFocus="true"/>
</epg:grid>

<!-- contents column 2 -->
<epg:grid left="650" top="223" width="580" height="405" row="9" column="1" items="${historys}" var="history"
 		  indexVar="idx" posVar="pos" begin="9" length="9" align="left">
	<epg:navUrl obj="${history}" indexUrlVar="indexUrl"/>
	<epg:img id="historyBg${idx+9}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="580" height="45"
			 src="./images/dot.png"/>
	<epg:text id="history${idx+9}" left="${pos[idx-1].x+50}" top="${pos[idx-1].y+12}" width="580" height="45"
			  text="${history.contentName}" align="left" fontFamily="黑体" fontSize="22" color="#333"/>
	<epg:img  id="historyFocus${idx+9}"  left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="40" height="45" src="./images/dot.png"
			 href="${indexUrl}" onfocus="buttonOnFocus('historyBg${idx+9}','historyPlay','history${idx+9}');"
			 onblur="buttonOnBlur('historyBg${idx+9}','dot','history${idx+9}');" rememberFocus="true"/>
</epg:grid>

</epg:body>
</epg:html>