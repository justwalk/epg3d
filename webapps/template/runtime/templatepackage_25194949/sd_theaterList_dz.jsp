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

<!-- 左上图片推荐 -->
<epg:query queryName="getSeverialItems" maxRows="1" var="leftUpCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['leftUpCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 左中文字推荐-->
<epg:query queryName="getSeverialItems" maxRows="3" var="leftCenterCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['leftCenterCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 左下文字热荐-->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="2" var="leftDownCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['leftDownCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- contents query -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="12" var="rightCategoryItems"
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

<epg:body onload="init()" bgcolor="#000000"  width="1280" height="720">
<div id="leftDiv">
	<epg:img defaultSrc="./images/sd_theaterList_dz.jpg" src="../${templateParams['backgroundImg']}" id="main"  left="0" top="0" width="640" height="720"/>

<epg:img left="130" top="66" width="22" height="45" src="./images/sitvLogo2.png"/>
<epg:img left="359" top="76" width="10" height="18" src="./images/newIcon.png"/>
<epg:img left="409" top="76" width="10" height="18" src="./images/newIcon.png"/>

<epg:grid column="8" row="1" left="170" top="80" width="400" height="38"  hcellspacing="0" items="${menuCategoryItems}" var="menuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:if test="${curIdx==1}">
		<epg:img id="menu${curIdx}" src="./images/dot.gif" width="50"  href="${returnBizUrl}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
			height="38" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"/>
		<epg:img id="menu${curIdx}_img" src="./images/dot.gif" width="50" style="visibility:hidden;border:3px solid #ff9c13" 
			height="38" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"/>
	</epg:if>
	<epg:if test="${curIdx!=1}">
		<epg:img id="menu${curIdx}" src="./images/dot.gif" width="50" href="${indexUrl}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
			height="38" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"/>
		<epg:img id="menu${curIdx}_img" src="./images/dot.gif" width="50"  style="visibility:hidden;border:3px solid #ff9c13" 
			height="38" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"/>
	</epg:if>
</epg:grid>
<epg:img id="back" src="./images/dot.gif" width="35" height="30" left="579" top="96" href="${returnHomeUrl}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"/>
<epg:img id="back_img" src="./images/dot.gif" width="35" height="30" left="579" top="96"  style="visibility:hidden;border:3px solid #ff9c13" />

<!-- pageTurn -->
<epg:img id="pageUp" left="175" top="151"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  width="63" height="26" src="./images/dot.gif" href="javascript:pageUp();"/>
<epg:img  id="pageUp_img"  left="175" top="151" style="visibility:hidden;border:3px solid #ff9c13"  width="63" height="26" src="./images/dot.gif" />
<epg:img id="pageDown"  left="250" top="151" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  width="63" height="26" src="./images/dot.gif" href="javascript:pageDown();"/>
<epg:img id="pageDown_img"  left="250" top="151" style="visibility:hidden;border:3px solid #ff9c13" width="63" height="26" src="./images/dot.gif" />


<epg:text left="340" top="153"  align="left" width="100" height="32" color="#fffccb" fontSize="14" 
	text="${pageBean.pageIndex}/${pageBean.pageCount}页"/>

		
<!-- contents -->
<epg:grid left="175" top="202" width="440" height="420" row="2" column="6" items="${rightCategoryItems}"
		  var="rightCategoryItem" indexVar="curIdx" posVar="positions" hcellspacing="20" vcellspacing="30">
	<epg:navUrl obj="${rightCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="content${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="65" height="195" src="../${rightCategoryItem.still}"/>
	<epg:img id="contentFocus${curIdx}" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="65" height="195"
		onfocus="getfocus(this.id);" onblur="outfocus(this.id);" rememberFocus="true" src="./images/dot.gif" href="${indexUrl}&returnTo=bizcat"/>
	<epg:img id="contentFocus${curIdx}_img" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="65" height="195"
		style="visibility:hidden;border:3px solid #ff9c13" src="./images/dot.gif"/>
</epg:grid>	

<!-- recommend 
<epg:navUrl obj="${leftUpCategoryItems}" playUrlVar="playUrl"/>
<epg:img left="77" top="237" width="205" 
 href="${playUrl}&pi=1" height="83" src="./images/dot.gif" />
-->
<!-- 左上推荐 -->
<epg:if test="${leftUpCategoryItems!=null}">
	<!--<epg:img left="75" top="235" width="220" height="90" src="../${leftUpCategoryItems.itemIcon}" />-->
	<epg:text color="#926740" left="48" align="left" top="234" width="100" fontSize="14" fontFamily="黑体">${leftUpCategoryItems.title}</epg:text>
</epg:if>
<!-- 左中推荐 -->
<epg:grid column="1" row="3" left="42" top="355" width="109" height="108" vcellspacing="10" items="${leftCenterCategoryItems}" var="leftCenterCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${leftCenterCategoryItem}" indexUrlVar="indexUrl"/>
		<epg:text color="#ffe8b6" id="leftCenter${curIdx}" left="${positions[curIdx-1].x}" align="left" top="${positions[curIdx-1].y}" 
			width="234" fontSize="14" chineseCharNumber="10" dotdotdot="…">${leftCenterCategoryItem.title}</epg:text>
		<epg:img id="leftCenter${curIdx}" src="./images/dot.gif" width="109" rememberFocus="true" href="${indexUrl}&pi=${curIdx}&returnTo=biz"
			onfocus="getfocus(this.id);" onblur="outfocus(this.id);" 
			height="38" left="${positions[curIdx-1].x-5}" top="${positions[curIdx-1].y-10}"/>
		<epg:img id="leftCenter${curIdx}_img" src="./images/dot.gif" width="109"
			height="38" style="visibility:hidden;border:3px solid #ff9c13" left="${positions[curIdx-1].x-5}" top="${positions[curIdx-1].y-10}"/>
</epg:grid>
<!-- 左下推荐 -->
<epg:grid column="1" row="2" left="25" top="488" width="134" height="134" vcellspacing="6" items="${leftDownCategoryItems}" var="leftDownCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${leftDownCategoryItem}" indexUrlVar="indexUrl"/>
		<epg:img id="leftDown${curIdx}" src="../${leftDownCategoryItem.itemIcon}" width="134" 
			height="64" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}"/>
		<epg:img id="leftDown${curIdx}" src="./images/dot.gif" width="134" rememberFocus="true" href="${indexUrl}&pi=${curIdx}&returnTo=biz"
			onfocus="getfocus(this.id);" onblur="outfocus(this.id);" 
			height="64" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"/>
		<epg:img id="leftDown${curIdx}_img" src="./images/dot.gif" width="134"  
			height="64" style="visibility:hidden;border:3px solid #ff9c13" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"/>
</epg:grid>
</div>

<!-- ******************************************************I -->

<div id="r_leftDiv">
	<epg:img defaultSrc="./images/sd_theaterList_dz.jpg" src="../${templateParams['backgroundImg']}" id="r_main"  left="640" top="0" width="640" height="720"/>

<epg:img left="770" top="66" width="22" height="45" src="./images/sitvLogo2.png"/>
<epg:img left="999" top="76" width="10" height="18" src="./images/newIcon.png"/>
<epg:img left="1049" top="76" width="10" height="18" src="./images/newIcon.png"/>

<epg:grid column="8" row="1" left="810" top="80" width="400" height="38"  hcellspacing="0" items="${menuCategoryItems}" var="menuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:if test="${curIdx==1}">
		<epg:img id="r_menu${curIdx}" src="./images/dot.gif" width="50"  href="${returnBizUrl}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
			height="38" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"/>
		<epg:img id="r_menu${curIdx}_img" src="./images/dot.gif" width="50" style="visibility:hidden;border:3px solid #ff9c13" 
			height="38" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"/>
	</epg:if>
	<epg:if test="${curIdx!=1}">
		<epg:img id="r_menu${curIdx}" src="./images/dot.gif" width="50" href="${indexUrl}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
			height="38" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"/>
		<epg:img id="r_menu${curIdx}_img" src="./images/dot.gif" width="50"  style="visibility:hidden;border:3px solid #ff9c13" 
			height="38" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"/>
	</epg:if>
</epg:grid>
<epg:img id="r_back" src="./images/dot.gif" width="35" height="30" left="1219" top="96" href="${returnHomeUrl}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"/>
<epg:img id="r_back_img" src="./images/dot.gif" width="35" height="30" left="1219" top="96"  style="visibility:hidden;border:3px solid #ff9c13" />

<!-- pageTurn -->
<epg:img id="r_pageUp" left="815" top="151"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  width="63" height="26" src="./images/dot.gif" href="javascript:pageUp();"/>
<epg:img  id="r_pageUp_img"  left="815" top="151" style="visibility:hidden;border:3px solid #ff9c13"  width="63" height="26" src="./images/dot.gif" />
<epg:img id="r_pageDown"  left="890" top="151" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  width="63" height="26" src="./images/dot.gif" href="javascript:pageDown();"/>
<epg:img id="r_pageDown_img"  left="890" top="151" style="visibility:hidden;border:3px solid #ff9c13" width="63" height="26" src="./images/dot.gif" />


<epg:text left="980" top="153"  align="left" width="100" height="32" color="#fffccb" fontSize="14" 
	text="${pageBean.pageIndex}/${pageBean.pageCount}页"/>

		
<!-- contents -->
<epg:grid left="815" top="202" width="440" height="420" row="2" column="6" items="${rightCategoryItems}"
		  var="rightCategoryItem" indexVar="curIdx" posVar="positions" hcellspacing="20" vcellspacing="30">
	<epg:navUrl obj="${rightCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="r_content${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="65" height="195" src="../${rightCategoryItem.still}"/>
	<epg:img id="r_contentFocus${curIdx}" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="65" height="195"
		onfocus="getfocus(this.id);" onblur="outfocus(this.id);" rememberFocus="true" src="./images/dot.gif" href="${indexUrl}&returnTo=bizcat"/>
	<epg:img id="r_contentFocus${curIdx}_img" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="65" height="195"
		style="visibility:hidden;border:3px solid #ff9c13" src="./images/dot.gif"/>
</epg:grid>	

<!-- recommend 
<epg:navUrl obj="${leftUpCategoryItems}" playUrlVar="playUrl"/>
<epg:img left="77" top="237" width="205" 
 href="${playUrl}&pi=1" height="83" src="./images/dot.gif" />
-->
<!-- 左上推荐 -->
<epg:if test="${leftUpCategoryItems!=null}">
	<!--<epg:img left="75" top="235" width="220" height="90" src="../${leftUpCategoryItems.itemIcon}" />-->
	<epg:text color="#926740" left="688" align="left" top="234" width="100" fontSize="14" fontFamily="黑体">${leftUpCategoryItems.title}</epg:text>
</epg:if>
<!-- 左中推荐 -->
<epg:grid column="1" row="3" left="682" top="355" width="109" height="108" vcellspacing="10" items="${leftCenterCategoryItems}" var="leftCenterCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${leftCenterCategoryItem}" indexUrlVar="indexUrl"/>
		<epg:text color="#ffe8b6" id="r_leftCenter${curIdx}" left="${positions[curIdx-1].x}" align="left" top="${positions[curIdx-1].y}" 
			width="234" fontSize="14" chineseCharNumber="10" dotdotdot="…">${leftCenterCategoryItem.title}</epg:text>
		<epg:img id="r_leftCenter${curIdx}" src="./images/dot.gif" width="109" rememberFocus="true" href="${indexUrl}&pi=${curIdx}&returnTo=biz"
			onfocus="getfocus(this.id);" onblur="outfocus(this.id);" 
			height="38" left="${positions[curIdx-1].x-5}" top="${positions[curIdx-1].y-10}"/>
		<epg:img id="r_leftCenter${curIdx}_img" src="./images/dot.gif" width="109"
			height="38" style="visibility:hidden;border:3px solid #ff9c13" left="${positions[curIdx-1].x-5}" top="${positions[curIdx-1].y-10}"/>
</epg:grid>
<!-- 左下推荐 -->
<epg:grid column="1" row="2" left="665" top="488" width="134" height="134" vcellspacing="6" items="${leftDownCategoryItems}" var="leftDownCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${leftDownCategoryItem}" indexUrlVar="indexUrl"/>
		<epg:img id="r_leftDown${curIdx}" src="../${leftDownCategoryItem.itemIcon}" width="134" 
			height="64" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}"/>
		<epg:img id="r_leftDown${curIdx}" src="./images/dot.gif" width="134" rememberFocus="true" href="${indexUrl}&pi=${curIdx}&returnTo=biz"
			onfocus="getfocus(this.id);" onblur="outfocus(this.id);" 
			height="64" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"/>
		<epg:img id="r_leftDown${curIdx}_img" src="./images/dot.gif" width="134"  
			height="64" style="visibility:hidden;border:3px solid #ff9c13" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"/>
</epg:grid>
</div>
</epg:body>
</epg:html>