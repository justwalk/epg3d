
<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@page import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*"%>
<%
	EpgUserSession eus = EpgUserSession.findUserSession(request);
	String eusLeaveFocusId = eus.getPlayFocusId();
	if (eusLeaveFocusId != null) {
		request.setAttribute("leaveFocusId", eusLeaveFocusId);
	} else {
		String myleaveFocusId = request.getParameter("leaveFocusId");
		if (myleaveFocusId != null && myleaveFocusId != "") {
			request.setAttribute("leaveFocusId", myleaveFocusId);
		}
	}
%>
<epg:html>
<!-- 导航菜单  -->
<epg:query queryName="getSeverialItems" maxRows="7" var="menuCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String" />
</epg:query>

<!-- left recommend query -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="1" var="leftCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['leftRecommend']}" type="java.lang.String" />
</epg:query>

<!-- 预告片-->
<epg:query queryName="getSeverialItems" maxRows="1" var="trailerCategoryItem">
	<epg:param name="categoryCode" value="${templateParams['trailerCategoryCode']}" type="java.lang.String" />
</epg:query>

<!-- contents query -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="12" var="rightCategoryItems" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true">
	<epg:param name="categoryCode" value="${templateParams['programCategoryCode']}" type="java.lang.String" />
</epg:query>

<epg:navUrl returnTo="biz" returnUrlVar="returnBizUrl" />
<epg:navUrl returnTo="home" returnUrlVar="returnHomeUrl"></epg:navUrl>
<style>
a {
	outline: none;
}
/* 3D */
#leftrecommend2_text,#pgIndex,#pgAll{
	overflow: hidden;
	/* -webkit-transform: rotateY(60deg); */
}
#r_leftrecommend2_text,#r_pgIndex,#r_pgAll{
	overflow: hidden;
	/* -webkit-transform: rotateY(60deg); */
}
</style>

<script src="${context['EPG_CONTEXT']}/js/base.js"></script>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script type="text/javascript">
var pageLoad = false;
var fristFocus = 0;
if (typeof(iPanel) == 'undefined') {
	pageLoad  = true;
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

/**
 * 获得焦点事件
 */
function getfocus(objId){
	var num = objId.replace(/[^0-9]/ig,"");	// 提取id里的数字
	if("r_" == objId.substr(0,2)){
		objId = objId.substr(2,objId.length)
	}
	//Content
	if(objId.substr(0,12) == "contentFocus"){
		var _div = document.getElementById("r_content"+num+"_div").style.left;
		//var div = _div.substr(0,_div.length-2);
		var div = parseInt(_div);
		var _r_contentFocus = document.getElementById("r_contentFocus"+num+"_div").style.left;
		//var r_contentFocus = _r_contentFocus.substr(0,_r_contentFocus.length-2);
		var r_contentFocus = parseInt(_r_contentFocus);
		var _r_contentFocusImg = document.getElementById("r_contentFocus"+num+"_img_div").style.left;
		//var r_contentFocusImg = _r_contentFocusImg.substr(0,_r_contentFocusImg.length-2);
		var r_contentFocusImg = parseInt(_r_contentFocusImg);
		document.getElementById("r_content"+num+"_div").style.left = (parseInt(div)+10)+"px";
		document.getElementById("r_contentFocus"+num+"_div").style.left = (parseInt(r_contentFocus)+10)+"px";
		document.getElementById("r_contentFocus"+num+"_img_div").style.left = (parseInt(r_contentFocusImg)+10)+"px";
		document.getElementById("r_content"+num+"_div").style.zIndex = 100;
		document.getElementById("r_contentFocus"+num+"_div").style.zIndex = 101;
		document.getElementById("r_contentFocus"+num+"_img_div").style.zIndex = 102;
	}
	
	if(pageLoad){
		fristFocus++;
		var id = objId.substring(0,objId.indexOf("_"));
		document.getElementById(id+"_img_img").style.visibility="visible";
		document.getElementById("r_"+id+"_img_img").style.visibility="visible";
	}
}
/**
 * 失去焦点事件
 */
function outfocus(objId){
	var num = objId.replace(/[^0-9]/ig,"");	// 提取id里的数字
	if("r_" == objId.substr(0,2)){
		objId = objId.substr(2,objId.length)
	}
	//Content
	if(objId.substr(0,12) == "contentFocus"){
		var _div = document.getElementById("r_content"+num+"_div").style.left;
		//var div = _div.substr(0,_div.length-2);
		var div = parseInt(_div);
		var _r_contentFocus = document.getElementById("r_contentFocus"+num+"_div").style.left;
		//var r_contentFocus = _r_contentFocus.substr(0,_r_contentFocus.length-2);
		var r_contentFocus = parseInt(_r_contentFocus);
		var _r_contentFocusImg = document.getElementById("r_contentFocus"+num+"_img_div").style.left;
		//var r_contentFocusImg = _r_contentFocusImg.substr(0,_r_contentFocusImg.length-2);
		var r_contentFocusImg = parseInt(_r_contentFocusImg);
		document.getElementById("r_content"+num+"_div").style.left = (parseInt(div)-10)+"px";
		document.getElementById("r_contentFocus"+num+"_div").style.left = (parseInt(r_contentFocus)-10)+"px";
		document.getElementById("r_contentFocus"+num+"_img_div").style.left = (parseInt(r_contentFocusImg)-10)+"px";
	}
	
	if(pageLoad){
		var id = objId.substring(0,objId.indexOf("_"));
		document.getElementById(id+"_img_img").style.visibility="hidden";
		document.getElementById("r_"+id+"_img_img").style.visibility="hidden";
	}
}


function init(){
	//$("contentFocus1_a").focus();
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""&&document.getElementById(leaveFocusId+"_a")){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		if(document.getElementById("contentFocus1_a")){
			document.getElementById("contentFocus1_a").focus();
		}else{
			document.getElementById("menu1_a").focus();
		}
	}
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
 	document.location.href = previousUrl+"&leaveFocusId=pageUp"+myPageIndex;
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
 	document.location.href = nextUrl+"&leaveFocusId=pageDown"+myPageIndex;
}
</script>

<epg:body onload="init()" bgcolor="#000000">

<div id="leftDiv">
	<!-- 背景图片以及头部图片 -->
	<epg:img src="../${templateParams['backgroundImg']}" id="main" left="0" top="0" width="640" height="720" />
	
	<!-- 导航 -->
	<epg:grid column="7" row="1" left="110" top="90" width="505" height="39" hcellspacing="35" items="${menuCategoryItems}" var="menuCategoryItem" indexVar="curIdx" posVar="positions">
		<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl" />
		<epg:if test="${curIdx==1}">
			<epg:img id="menu${curIdx}" src="./images/dot.gif" width="35" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" href="${returnBizUrl}" height="39" left="${positions[curIdx-1].x+9}" top="${positions[curIdx-1].y}" />
			<epg:img id="menu${curIdx}_img" src="./images/dot.gif" width="35" style="visibility:hidden;border:3px solid #ff9c13" height="39" left="${positions[curIdx-1].x+9}" top="${positions[curIdx-1].y}" />
		</epg:if>
		<epg:if test="${curIdx!=1}">
			<epg:img id="menu${curIdx}" src="./images/dot.gif" width="62" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" href="${indexUrl}" height="39" left="${positions[curIdx-1].x-30}" top="${positions[curIdx-1].y}" />
			<epg:img id="menu${curIdx}_img" src="./images/dot.gif" width="62" style="visibility:hidden;border:3px solid #ff9c13" height="39" left="${positions[curIdx-1].x-30}" top="${positions[curIdx-1].y}" />
		</epg:if>
	</epg:grid>
	<epg:img id="back" src="./images/dot.gif" width="35" height="30" left="555" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" top="37" href="${returnHomeUrl}" />
	<epg:img id="back_img" src="./images/dot.gif" width="35" style="visibility:hidden;border:3px solid #ff9c13" height="30" left="555" top="37" />
	
	<!-- pageTurn -->
	<epg:img id="pageUp" left="164" top="170" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" width="65" height="32" src="./images/dot.gif" href="javascript:pageUp();" />
	<epg:img id="pageUp_img" left="164" top="170" style="visibility:hidden;border:3px solid #ff9c13" width="63" height="32" src="./images/dot.gif" />
	<epg:img id="pageDown" left="239" top="170" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" width="65" height="32" src="./images/dot.gif" href="javascript:pageDown();" />
	<epg:img id="pageDown_img" left="239" top="170" style="visibility:hidden;border:3px solid #ff9c13" width="63" height="32" src="./images/dot.gif" />
	
	<!-- x/xx页 -->
	<epg:text id="pgIndex" left="325" top="175" align="center" width="50" height="32" color="#99ccff" fontSize="16" text="${pageBean.pageIndex}" />
	<epg:text id="pgAll" left="340" top="175" width="100" height="32" color="#d8d8d8" fontSize="16" text="/ ${pageBean.pageCount} 页" />

	<!-- contents -->
	<epg:grid left="165" top="230" width="440" height="420" row="2" column="6" items="${rightCategoryItems}" var="rightCategoryItem" indexVar="curIdx" posVar="positions" hcellspacing="20" vcellspacing="30">
		<epg:navUrl obj="${rightCategoryItem}" indexUrlVar="indexUrl" />
		<epg:img id="content${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="65" height="195" src="../${rightCategoryItem.still}" />
		<epg:img id="contentFocus${curIdx}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="65" height="195" rememberFocus="true" src="./images/dot.gif" href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=bizcat" />
		<epg:img id="contentFocus${curIdx}_img" style="visibility:hidden;border:3px solid #ff9c13" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="65" height="195" src="./images/dot.gif" />
	</epg:grid>

	<!-- recommend -->
	<epg:if test="${leftCategoryItems!=null}">
		<epg:navUrl obj="${leftCategoryItems}" indexUrlVar="playUrl" />
		<epg:img id="leftrecommend1_show" left="36" top="173" width="110" height="330" src="../${leftCategoryItems.icon}" />
		<epg:img id="leftrecommend1" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="34" top="170" width="110" rememberFocus="true" href="${playUrl}&pi=1" height="330" src="./images/dot.gif" />
		<epg:img id="leftrecommend1_img" style="visibility:hidden;border:3px solid #ff9c13" left="34" top="170" width="109" height="330" src="./images/dot.gif" />
		<epg:text id="leftrecommend2_text" left="-10" top="520" width="200" height="50" color="#99ccff" chineseCharNumber="8" dotdotdot=" " fontSize="16" align="center" fontFamily="黑体" text="${leftCategoryItems.title}" />
		<epg:img id="leftrecommend2" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="34" top="521" width="112" rememberFocus="true" href="${playUrl}&pi=1" height="32" src="./images/dot.gif" />
		<epg:img id="leftrecommend2_img" left="34" top="519" width="112" height="32" style="visibility:hidden;border:3px solid #ff9c13" src="./images/dot.gif" />
		<epg:img id="foreShow" src="./images/dot.png" left="34" top="607" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" width="112" height="32" href="${playUrl}&pi=1" rememberFocus="true" />
		<epg:img id="foreShow_img" src="./images/dot.png" left="34" top="607" style="visibility:hidden;border:3px solid #ff9c13" width="112" height="32" />
	</epg:if>
	<epg:if test="${trailerCategoryItem!=null}">
		<epg:navUrl obj="${trailerCategoryItem}" indexUrlVar="trailerplayUrl" />
		<epg:img id="trailer" src="./images/dot.png" left="34" top="565" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" width="112" height="32" href="${trailerplayUrl}&pi=1" rememberFocus="true" />
		<epg:img id="trailer_img" style="visibility:hidden;border:3px solid #ff9c13" src="./images/dot.png" left="34" top="565" width="112" height="32" />
	</epg:if>
</div>
<!-- ********************************************************************************************** -->
<div id="rightDiv">
	<!-- 背景图片以及头部图片 -->
	<epg:img src="../${templateParams['backgroundImg']}" id="r_main" left="640" top="0" width="640" height="720" />
	
	<!-- 导航 -->
	<epg:grid column="7" row="1" left="750" top="90" width="505" height="39" hcellspacing="35" items="${menuCategoryItems}" var="menuCategoryItem" indexVar="curIdx" posVar="positions">
		<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl" />
		<epg:if test="${curIdx==1}">
			<epg:img id="r_menu${curIdx}" src="./images/dot.gif" width="35" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" href="${returnBizUrl}" height="39" left="${positions[curIdx-1].x+9}" top="${positions[curIdx-1].y}" />
			<epg:img id="r_menu${curIdx}_img" src="./images/dot.gif" width="35" style="visibility:hidden;border:3px solid #ff9c13" height="39" left="${positions[curIdx-1].x+9}" top="${positions[curIdx-1].y}" />
		</epg:if>
		<epg:if test="${curIdx!=1}">
			<epg:img id="r_menu${curIdx}" src="./images/dot.gif" width="62" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" href="${indexUrl}" height="39" left="${positions[curIdx-1].x-30}" top="${positions[curIdx-1].y}" />
			<epg:img id="r_menu${curIdx}_img" src="./images/dot.gif" width="62" style="visibility:hidden;border:3px solid #ff9c13" height="39" left="${positions[curIdx-1].x-30}" top="${positions[curIdx-1].y}" />
		</epg:if>
	</epg:grid>
	<epg:img id="r_back" src="./images/dot.gif" width="35" height="30" left="1195" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" top="37" href="${returnHomeUrl}" />
	<epg:img id="r_back_img" src="./images/dot.gif" width="35" style="visibility:hidden;border:3px solid #ff9c13" height="30" left="1195" top="37" />
	
	<!-- pageTurn -->
	<epg:img id="r_pageUp" left="804" top="170" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" width="65" height="32" src="./images/dot.gif" href="javascript:pageUp();" />
	<epg:img id="r_pageUp_img" left="804" top="170" style="visibility:hidden;border:3px solid #ff9c13" width="63" height="32" src="./images/dot.gif" />
	<epg:img id="r_pageDown" left="879" top="170" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" width="65" height="32" src="./images/dot.gif" href="javascript:pageDown();" />
	<epg:img id="r_pageDown_img" left="879" top="170" style="visibility:hidden;border:3px solid #ff9c13" width="63" height="32" src="./images/dot.gif" />
	
	<!-- x/xx页 -->
	<epg:text id="r_pgIndex" left="965" top="175" align="center" width="50" height="32" color="#99ccff" fontSize="16" text="${pageBean.pageIndex}" />
	<epg:text id="r_pgAll" left="980" top="175" width="100" height="32" color="#d8d8d8" fontSize="16" text="/ ${pageBean.pageCount} 页" />

	<!-- contents -->
	<epg:grid left="805" top="230" width="440" height="420" row="2" column="6" items="${rightCategoryItems}" var="rightCategoryItem" indexVar="curIdx" posVar="positions" hcellspacing="20" vcellspacing="30">
		<epg:navUrl obj="${rightCategoryItem}" indexUrlVar="indexUrl" />
		<epg:img id="r_content${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="65" height="195" src="../${rightCategoryItem.still}" />
		<epg:img id="r_contentFocus${curIdx}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="65" height="195" rememberFocus="true" src="./images/dot.gif" href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=bizcat" />
		<epg:img id="r_contentFocus${curIdx}_img" style="visibility:hidden;border:3px solid #ff9c13" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="65" height="195" src="./images/dot.gif" />
	</epg:grid>

	<!-- recommend -->
	<epg:if test="${leftCategoryItems!=null}">
		<epg:navUrl obj="${leftCategoryItems}" indexUrlVar="playUrl" />
		<epg:img id="r_leftrecommend1_show" left="684" top="173" width="110" height="330" src="../${leftCategoryItems.icon}" />
		<epg:img id="r_leftrecommend1" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="682" top="170" width="110" rememberFocus="true" href="${playUrl}&pi=1" height="330" src="./images/dot.gif" />
		<epg:img id="r_leftrecommend1_img" style="visibility:hidden;border:3px solid #ff9c13" left="682" top="170" width="109" height="330" src="./images/dot.gif" />
		<epg:text id="r_leftrecommend2_text" left="630" top="520" width="200" height="50" color="#99ccff" chineseCharNumber="8" dotdotdot=" " fontSize="16" align="center" fontFamily="黑体" text="${leftCategoryItems.title}" />
		<epg:img id="r_leftrecommend2" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="674" top="521" width="112" rememberFocus="true" href="${playUrl}&pi=1" height="32" src="./images/dot.gif" />
		<epg:img id="r_leftrecommend2_img" left="674" top="519" width="112" height="32" style="visibility:hidden;border:3px solid #ff9c13" src="./images/dot.gif" />
		<epg:img id="r_foreShow" src="./images/dot.png" left="674" top="607" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" width="112" height="32" href="${playUrl}&pi=1" rememberFocus="true" />
		<epg:img id="r_foreShow_img" src="./images/dot.png" left="674" top="607" style="visibility:hidden;border:3px solid #ff9c13" width="112" height="32" />
	</epg:if>
	<epg:if test="${trailerCategoryItem!=null}">
		<epg:navUrl obj="${trailerCategoryItem}" indexUrlVar="trailerplayUrl" />
		<epg:img id="r_trailer" src="./images/dot.png" left="674" top="565" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" width="112" height="32" href="${trailerplayUrl}&pi=1" rememberFocus="true" />
		<epg:img id="r_trailer_img" style="visibility:hidden;border:3px solid #ff9c13" src="./images/dot.png" left="674" top="565" width="112" height="32" />
	</epg:if>
</div>
</epg:body>
</epg:html>