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
<epg:html>
	<!-- 导航菜单  -->
<epg:query queryName="getSeverialItems" maxRows="8" var="menuCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- contents query -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="16" var="contentCategoryItems"
		   pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true" >
	<epg:param name="categoryCode" value="${templateParams['programCategoryCode']}" type="java.lang.String"  />
</epg:query>

<epg:navUrl returnTo="biz" returnUrlVar="returnBizUrl"/>
<epg:navUrl returnTo="home" returnUrlVar="returnHomeUrl"/>
<script src="${context['EPG_CONTEXT']}/js/base.js"></script>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<style>
	a{
	outline:none;
}
</style>
<script type="text/javascript">
	var pageLoad = false;
	var fristFocus = 0;
	if (typeof(iPanel) == 'undefined') {
		pageLoad  = true;
	}
	function getfocus(objId){
		if (pageLoad) {
				fristFocus++;
			var id = objId.substring(0,objId.indexOf("_"));
			document.getElementById(id+"_img_img").style.visibility="visible";
			document.getElementById("r_"+id+"_img_img").style.visibility="visible";
		}
	}
	function outfocus(objId){
		if (pageLoad) {
			var id = objId.substring(0,objId.indexOf("_"));
			document.getElementById(id+"_img_img").style.visibility="hidden";
			document.getElementById("r_"+id+"_img_img").style.visibility="hidden";
		}
	}
	function init(){
		var leaveFocusId = "${leaveFocusId}";
		if(leaveFocusId!=""){
			document.getElementById(leaveFocusId+"_a").focus();
		}else{
			document.getElementById("contentFocus1_a").focus();
		}
	}

function pageUp(){
  	var previousUrl = "${pageBean.previousUrl}";
	var myPageIndex = "";
	if(previousUrl.indexOf("&pageIndex=")!=-1){
		myPageIndex = previousUrl.substring(previousUrl.indexOf("&pageIndex="),previousUrl.length);
		previousUrl = previousUrl.substring(0,previousUrl.indexOf("&pageIndex="));
	}
	if(previousUrl.indexOf("&leaveFocusId=")!=-1){
		previousUrl = previousUrl.substring(0,previousUrl.indexOf("&leaveFocusId="));
		
	}
 	document.location.href = previousUrl+"&leaveFocusId=pageUp"+myPageIndex;
 }
 function pageDown(){
 	var nextUrl = "${pageBean.nextUrl}";
	var myPageIndex = "";
	if(nextUrl.indexOf("&pageIndex=")!=-1){
		myPageIndex = nextUrl.substring(nextUrl.indexOf("&pageIndex="),nextUrl.length);
		nextUrl = nextUrl.substring(0,nextUrl.indexOf("&pageIndex="));
	}
	if(nextUrl.indexOf("&leaveFocusId=")!=-1){
		nextUrl = nextUrl.substring(0,nextUrl.indexOf("&leaveFocusId="));
	}
 	document.location.href = nextUrl+"&leaveFocusId=pageDown"+myPageIndex;
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
				pageUp();
				return 0;
	    	break;
	    case "SITV_KEY_PAGEDOWN":
				pageDown();
				return 0;
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
</script>

<epg:body onload="init()" bgcolor="#000000" width="1280">
<div id="leftDiv">
<epg:img src="../${templateParams['bgImg']}" width="640" height="720"/>
<epg:img left="130" top="66" width="22" height="45" src="./images/sitvLogo1.png"/>
<epg:img left="359" top="76" width="10" height="18" src="./images/newIcon.png"/>
<epg:img left="409" top="76" width="10" height="18" src="./images/newIcon.png"/>
<!-- 导航 -->
<epg:grid column="8" row="1" left="170" top="80" width="400" height="38"  hcellspacing="0" items="${menuCategoryItems}" var="menuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:if test="${curIdx==1}">
		<epg:img id="menu${curIdx}" src="./images/dot.gif" width="50" href="${returnBizUrl}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
		height="38" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"/>
		<epg:img id="menu${curIdx}_img" src="./images/dot.gif" width="50" style="visibility:hidden;border:3px solid #ff9c13" 
		height="38" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"/>
	</epg:if>
	<epg:if test="${curIdx!=1}">
		<epg:img id="menu${curIdx}" src="./images/dot.gif" width="50"  href="${indexUrl}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
		height="38" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"/>
		<epg:img id="menu${curIdx}_img" src="./images/dot.gif" width="50"  style="visibility:hidden;border:3px solid #ff9c13" 
		height="38" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"/>
	</epg:if>
</epg:grid>
<epg:img id="back" src="./images/dot.gif" width="35" height="30" left="579" top="96" href="${returnHomeUrl}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"/>
<epg:img id="back_img" src="./images/dot.gif" width="35" height="30" left="579" top="96"  style="visibility:hidden;border:3px solid #ff9c13" />

<!-- pageTurn -->
<epg:img id="pageUp" left="25" top="151"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  width="63" height="26" src="./images/dot.gif" href="javascript:pageUp();"/>
<epg:img  id="pageUp_img"  left="25" top="151" style="visibility:hidden;border:3px solid #ff9c13"  width="63" height="26" src="./images/dot.gif" />
<epg:img id="pageDown"  left="100" top="151" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  width="63" height="26" src="./images/dot.gif" href="javascript:pageDown();"/>
<epg:img id="pageDown_img"  left="100" top="151" style="visibility:hidden;border:3px solid #ff9c13" width="63" height="26" src="./images/dot.gif" />


<epg:text left="192" top="153"  align="left" width="100" height="32" color="#fffccb" fontSize="24" 
	text="${pageBean.pageIndex}/${pageBean.pageCount}页"/>

		
<!-- contents -->
<epg:grid left="25" top="202" width="590" height="420" row="2" column="8" items="${contentCategoryItems}"
		  var="contentCategoryItem" indexVar="curIdx" posVar="positions" hcellspacing="20" vcellspacing="30">
	<epg:navUrl obj="${contentCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="content${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="65" height="195" src="../${contentCategoryItem.still}"/>
	<epg:img id="contentFocus${curIdx}" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="65" height="195"
			onfocus="getfocus(this.id);" onblur="outfocus(this.id);" rememberFocus="true" defaultfocus="${isDefaultFocus}" src="./images/dot.gif" href="${indexUrl}&returnTo=bizcat"/>
	<epg:img id="contentFocus${curIdx}_img" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="65" height="195"
			style="visibility:hidden;border:3px solid #ff9c13" src="./images/dot.gif" />
</epg:grid>
</div>
<!-- **************************** -->
<div id="r_rightDiv">
<epg:img src="../${templateParams['bgImg']}" width="640" height="720" left="640"/>
<epg:img left="770" top="66" width="22" height="45" src="./images/sitvLogo1.png"/>
<epg:img left="999" top="76" width="10" height="18" src="./images/newIcon.png"/>
<epg:img left="1049" top="76" width="10" height="18" src="./images/newIcon.png"/>
<!-- 导航 -->
<epg:grid column="8" row="1" left="810" top="80" width="400" height="38"  hcellspacing="0" items="${menuCategoryItems}" var="menuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:if test="${curIdx==1}">
		<epg:img id="r_menu${curIdx}" src="./images/dot.gif" width="50" href="${returnBizUrl}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
		height="38" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"/>
		<epg:img id="r_menu${curIdx}_img" src="./images/dot.gif" width="50" style="visibility:hidden;border:3px solid #ff9c13" 
		height="38" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"/>
	</epg:if>
	<epg:if test="${curIdx!=1}">
		<epg:img id="r_menu${curIdx}" src="./images/dot.gif" width="50"  href="${indexUrl}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
		height="38" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"/>
		<epg:img id="r_menu${curIdx}_img" src="./images/dot.gif" width="50"  style="visibility:hidden;border:3px solid #ff9c13" 
		height="38" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"/>
	</epg:if>
</epg:grid>
<epg:img id="r_back" src="./images/dot.gif" width="35" height="30" left="1219" top="96" href="${returnHomeUrl}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"/>
<epg:img id="r_back_img" src="./images/dot.gif" width="35" height="30" left="1219" top="96"  style="visibility:hidden;border:3px solid #ff9c13" />

<!-- pageTurn -->
<epg:img id="r_pageUp" left="665" top="151"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  width="63" height="26" src="./images/dot.gif" href="javascript:pageUp();"/>
<epg:img  id="r_pageUp_img"  left="665" top="151" style="visibility:hidden;border:3px solid #ff9c13"  width="63" height="26" src="./images/dot.gif" />
<epg:img id="r_pageDown"  left="740" top="151" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  width="63" height="26" src="./images/dot.gif" href="javascript:pageDown();"/>
<epg:img id="r_pageDown_img"  left="740" top="151" style="visibility:hidden;border:3px solid #ff9c13" width="63" height="26" src="./images/dot.gif" />


<epg:text left="832" top="153"  align="left" width="100" height="32" color="#fffccb" fontSize="24" 
	text="${pageBean.pageIndex}/${pageBean.pageCount}页"/>

		
<!-- contents -->
<epg:grid left="675" top="202" width="590" height="420" row="2" column="8" items="${contentCategoryItems}"
		  var="contentCategoryItem" indexVar="curIdx" posVar="positions" hcellspacing="20" vcellspacing="30">
	<epg:navUrl obj="${contentCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="r_content${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="65" height="195" src="../${contentCategoryItem.still}"/>
	<epg:img id="r_contentFocus${curIdx}" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="65" height="195"
			onfocus="getfocus(this.id);" onblur="outfocus(this.id);" rememberFocus="true" defaultfocus="${isDefaultFocus}" src="./images/dot.gif" href="${indexUrl}&returnTo=bizcat"/>
	<epg:img id="r_contentFocus${curIdx}_img" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="65" height="195"
			style="visibility:hidden;border:3px solid #ff9c13" src="./images/dot.gif" />
</epg:grid>
</div>
</epg:body>
</epg:html>