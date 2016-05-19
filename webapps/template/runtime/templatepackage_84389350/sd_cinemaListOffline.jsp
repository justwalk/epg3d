<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
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
	<!-- 导航菜单  -->
<epg:query queryName="getSeverialItems" maxRows="7" var="menuCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- left recommend query -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="1" var="leftCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['leftRecommend']}" type="java.lang.String"/>
</epg:query>

<!-- 预告片-->
<epg:query queryName="getSeverialItems" maxRows="1" var="trailerCategoryItem" >
	<epg:param name="categoryCode" value="${templateParams['trailerCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- contents query -->
<epg:query queryName="getOldestItemsIncludePic" maxRows="12" var="rightCategoryItems" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true"  >
	<epg:param name="category1" value="ccms_category_300962326304" type="java.lang.String"  /><!-- 欧美 -->
	<epg:param name="category2" value="ccms_category_300962326309" type="java.lang.String"  /><!-- 港台 -->
	<epg:param name="category3" value="ccms_category_300962326314" type="java.lang.String"  /><!-- 内地 -->
</epg:query>

<epg:navUrl returnTo="biz" returnUrlVar="returnBizUrl"/>
<epg:navUrl returnTo="home" returnUrlVar="returnHomeUrl"></epg:navUrl>
<style>
	a{
	outline:none;
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
	function getfocus(objId){
		if(pageLoad){
			fristFocus++;
			var id = objId.substring(0,objId.indexOf("_"));
			document.getElementById(id+"_img_img").style.visibility="visible";
			document.getElementById("r_"+id+"_img_img").style.visibility="visible";
		}
	}
	function outfocus(objId){
		if(pageLoad){
			var id = objId.substring(0,objId.indexOf("_"));
			document.getElementById(id+"_img_img").style.visibility="hidden";
			document.getElementById("r_"+id+"_img_img").style.visibility="hidden";
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
<epg:img src="../${templateParams['backgroundImg']}" width="640" height="720" left="0"></epg:img>
<!-- back src="../${templateParams['backgroundImg']}"-->

<!-- 导航 -->
<epg:grid column="7" row="1" left="110" top="90" width="505" height="39"  hcellspacing="35" items="${menuCategoryItems}" var="menuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:if test="${curIdx==1}">
		<epg:img id="menu${curIdx}" src="./images/dot.gif" width="35" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  href="${returnBizUrl}"
		height="39" left="${positions[curIdx-1].x+10}" top="${positions[curIdx-1].y}"/>
		<epg:img id="menu${curIdx}_img" src="./images/dot.gif" width="35" style="visibility:hidden;border:3px solid #ff9c13" 
		height="39" left="${positions[curIdx-1].x+10}" top="${positions[curIdx-1].y}"/>
	</epg:if>
	<epg:if test="${curIdx!=1}">
		<epg:img id="menu${curIdx}" src="./images/dot.gif" width="62" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"   href="${indexUrl}"
		height="39" left="${positions[curIdx-1].x-35}" top="${positions[curIdx-1].y}"/>
		<epg:img id="menu${curIdx}_img" src="./images/dot.gif" width="62" style="visibility:hidden;border:3px solid #ff9c13" 
		height="39" left="${positions[curIdx-1].x-35}" top="${positions[curIdx-1].y}"/>
	</epg:if>
</epg:grid>
<epg:img id="back" src="./images/dot.gif" width="35"  height="30" left="555" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  top="37" href="${returnHomeUrl}"/>
<epg:img id="back_img" src="./images/dot.gif" width="35" style="visibility:hidden;border:3px solid #ff9c13"  height="30" left="555"  top="37"/>
<!-- pageTurn -->
<epg:img id="pageUp" left="163" top="170"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  width="65" height="32" src="./images/dot.gif" href="javascript:pageUp();"/>
<epg:img  id="pageUp_img"  left="163" top="170" style="visibility:hidden;border:3px solid #ff9c13"  width="65" height="32" src="./images/dot.gif" />
<epg:img id="pageDown"  left="238" top="170" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  width="65" height="32" src="./images/dot.gif" href="javascript:pageDown();"/>
<epg:img id="pageDown_img"  left="238" top="170" style="visibility:hidden;border:3px solid #ff9c13" width="65" height="32" src="./images/dot.gif" />

<epg:text id="pgIndex" left="325" top="175" align="center" width="15" height="32" color="#99ccff" fontSize="16" 
	text="${pageBean.pageIndex}"/>

<epg:text left="340" top="175" width="80" height="32" color="#d8d8d8" fontSize="16" 
	text="/ ${pageBean.pageCount} 页"/>
		
<!-- contents -->
<epg:grid left="165" top="230" width="440" height="420" row="2" column="6" items="${rightCategoryItems}"
		  var="rightCategoryItem" indexVar="curIdx" posVar="positions" hcellspacing="20" vcellspacing="30">
	<epg:navUrl obj="${rightCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="content${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="65" height="195" src="../${rightCategoryItem.still}"/>
	<epg:img id="contentFocus${curIdx}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="65" height="195"
			 rememberFocus="true" src="./images/dot.gif" href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=bizcat"/>
	<epg:img id="contentFocus${curIdx}_img" style="visibility:hidden;border:3px solid #ff9c13" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="65" height="195"src="./images/dot.gif"/>
	
</epg:grid>

<!-- recommend -->
<epg:if test="${leftCategoryItems!=null}">
<epg:navUrl obj="${leftCategoryItems}" indexUrlVar="playUrl"/>
<epg:img left="35" top="173" width="110" height="330" src="../${leftCategoryItems.icon}" />
<epg:img id="leftrecommend1" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="34" top="170" width="110" rememberFocus="true"
 href="${playUrl}&pi=1" height="330" src="./images/dot.gif" />
 <epg:img id="leftrecommend1_img" style="visibility:hidden;border:3px solid #ff9c13" left="34" top="170" width="110"  height="330" src="./images/dot.gif" />

<epg:text left="35" top="520" width="105" height="50" color="#99ccff" chineseCharNumber="8" dotdotdot=" " fontSize="16"
		  align="center" fontFamily="黑体" text="${leftCategoryItems.title}"/>
<epg:img  id="leftrecommend2" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  left="33" top="521" width="111"  rememberFocus="true"
 href="${playUrl}&pi=1" height="32" src="./images/dot.gif" />
<epg:img  id="leftrecommend2_img"  left="33" top="519" width="111" height="32" 
	style="visibility:hidden;border:3px solid #ff9c13"  src="./images/dot.gif" />

<epg:img id="foreShow" src="./images/dot.png" left="33" top="607"
onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
 width="111" height="32" href="${playUrl}&pi=1"
		 rememberFocus="true"/>
<epg:img id="foreShow_img" src="./images/dot.png" left="33" top="607" 
style="visibility:hidden;border:3px solid #ff9c13"
 width="111" height="32"/>
</epg:if>
<epg:if test="${trailerCategoryItem!=null}">
<epg:navUrl obj="${trailerCategoryItem}" indexUrlVar="trailerplayUrl"/>
<epg:img id="trailer" src="./images/dot.png" left="33" top="565"
onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
 width="111" height="32" href="${trailerplayUrl}&pi=1"
		 rememberFocus="true"/>
<epg:img id="trailer_img" style="visibility:hidden;border:3px solid #ff9c13" src="./images/dot.png" left="33" top="565"
 width="111" height="32" />
 </epg:if>
 </div>
 
 
 <div id="rightDiv">
<epg:img src="../${templateParams['backgroundImg']}" width="640" height="720" left="640"></epg:img>
<!-- back src="../${templateParams['backgroundImg']}"-->

<!-- 导航 -->
<epg:grid column="7" row="1" left="750" top="90" width="505" height="39"  hcellspacing="35" items="${menuCategoryItems}" var="menuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:if test="${curIdx==1}">
		<epg:img id="r_menu${curIdx}" src="./images/dot.gif" width="35" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  href="${returnBizUrl}"
		height="39" left="${positions[curIdx-1].x+10}" top="${positions[curIdx-1].y}"/>
		<epg:img id="r_menu${curIdx}_img" src="./images/dot.gif" width="35" style="visibility:hidden;border:3px solid #ff9c13" 
		height="39" left="${positions[curIdx-1].x+10}" top="${positions[curIdx-1].y}"/>
	</epg:if>
	<epg:if test="${curIdx!=1}">
		<epg:img id="r_menu${curIdx}" src="./images/dot.gif" width="62" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"   href="${indexUrl}"
		height="39" left="${positions[curIdx-1].x-35}" top="${positions[curIdx-1].y}"/>
		<epg:img id="r_menu${curIdx}_img" src="./images/dot.gif" width="62" style="visibility:hidden;border:3px solid #ff9c13" 
		height="39" left="${positions[curIdx-1].x-35}" top="${positions[curIdx-1].y}"/>
	</epg:if>
</epg:grid>
<epg:img id="r_back" src="./images/dot.gif" width="35"  height="30" left="1195" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  top="37" href="${returnHomeUrl}"/>
<epg:img id="r_back_img" src="./images/dot.gif" width="35" style="visibility:hidden;border:3px solid #ff9c13"  height="30" left="1195"  top="37"/>
<!-- pageTurn -->
<epg:img id="r_pageUp" left="803" top="170"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  width="65" height="32" src="./images/dot.gif" href="javascript:pageUp();"/>
<epg:img  id="r_pageUp_img"  left="803" top="170" style="visibility:hidden;border:3px solid #ff9c13"  width="65" height="32" src="./images/dot.gif" />
<epg:img id="r_pageDown"  left="878" top="170" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  width="65" height="32" src="./images/dot.gif" href="javascript:pageDown();"/>
<epg:img id="r_pageDown_img"  left="878" top="170" style="visibility:hidden;border:3px solid #ff9c13" width="65" height="32" src="./images/dot.gif" />

<epg:text id="r_pgIndex" left="965" top="175" align="center" width="15" height="32" color="#99ccff" fontSize="16" 
	text="${pageBean.pageIndex}"/>

<epg:text left="980" top="175" width="80" height="32" color="#d8d8d8" fontSize="16" 
	text="/ ${pageBean.pageCount} 页"/>
		
<!-- contents -->
<epg:grid left="805" top="230" width="440" height="420" row="2" column="6" items="${rightCategoryItems}"
		  var="rightCategoryItem" indexVar="curIdx" posVar="positions" hcellspacing="20" vcellspacing="30">
	<epg:navUrl obj="${rightCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="r_content${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="65" height="195" src="../${rightCategoryItem.still}"/>
	<epg:img id="r_contentFocus${curIdx}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="65" height="195"
			 rememberFocus="true" src="./images/dot.gif" href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=bizcat"/>
	<epg:img id="r_contentFocus${curIdx}_img" style="visibility:hidden;border:3px solid #ff9c13" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="65" height="195"src="./images/dot.gif"/>
	
</epg:grid>

<!-- recommend -->
<epg:if test="${leftCategoryItems!=null}">
<epg:navUrl obj="${leftCategoryItems}" indexUrlVar="playUrl"/>
<epg:img left="675" top="173" width="110" height="330" src="../${leftCategoryItems.icon}" />
<epg:img id="r_leftrecommend1" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="674" top="170" width="110" rememberFocus="true"
 href="${playUrl}&pi=1" height="330" src="./images/dot.gif" />
 <epg:img id="r_leftrecommend1_img" style="visibility:hidden;border:3px solid #ff9c13" left="674" top="170" width="110"  height="330" src="./images/dot.gif" />

<epg:text left="675" top="520" width="105" height="50" color="#99ccff" chineseCharNumber="8" dotdotdot=" " fontSize="16"
		  align="center" fontFamily="黑体" text="${leftCategoryItems.title}"/>
<epg:img  id="r_leftrecommend2" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  left="673" top="521" width="111"  rememberFocus="true"
 href="${playUrl}&pi=1" height="32" src="./images/dot.gif" />
<epg:img  id="r_leftrecommend2_img"  left="673" top="519" width="111" height="32" 
	style="visibility:hidden;border:3px solid #ff9c13"  src="./images/dot.gif" />

<epg:img id="r_foreShow" src="./images/dot.png" left="673" top="607"
onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
 width="111" height="32" href="${playUrl}&pi=1"
		 rememberFocus="true"/>
<epg:img id="r_foreShow_img" src="./images/dot.png" left="673" top="607" 
style="visibility:hidden;border:3px solid #ff9c13"
 width="111" height="32"/>
</epg:if>
<epg:if test="${trailerCategoryItem!=null}">
<epg:navUrl obj="${trailerCategoryItem}" indexUrlVar="trailerplayUrl"/>
<epg:img id="r_trailer" src="./images/dot.png" left="673" top="565"
onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
 width="111" height="32" href="${trailerplayUrl}&pi=1"
		 rememberFocus="true"/>
<epg:img id="r_trailer_img" style="visibility:hidden;border:3px solid #ff9c13" src="./images/dot.png" left="673" top="565"
 width="111" height="32" />
 </epg:if>
 </div>
</epg:body>
</epg:html>