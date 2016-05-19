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

<!--左侧推荐-->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="1" var="leftUpCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['leftCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 预告片-->
<epg:query queryName="getSeverialItems" maxRows="1" var="trailerCategoryItem" >
	<epg:param name="categoryCode" value="${templateParams['trailerCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 列表-->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="12" var="rightCategoryItems"
		   pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true" >
	<epg:param name="categoryCode" value="${templateParams['programCategoryCode']}" type="java.lang.String"  />
</epg:query>

<epg:navUrl returnTo="home" returnUrlVar="returnHomeUrl"></epg:navUrl>
<epg:navUrl returnTo="biz" returnUrlVar="returnUrl"></epg:navUrl>
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
			document.getElementById("content1focus_a").focus();
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

<epg:body onload="init()"  bgcolor="#000000"  width="1280" height="720" >
<!-- 背景图片以及头部图片 -->
<div id="leftDiv">
<epg:img defaultSrc="./images/sd_theaterList_sbo.jpg" src="../${templateParams['backgroundImg']}" id="main"  left="0" top="0" width="640" height="720"/>
<epg:img left="130" top="66" width="22" height="45" src="./images/sitvLogo1.png"/>
<epg:img left="359" top="76" width="10" height="18" src="./images/newIcon.png"/>
<epg:img left="409" top="76" width="10" height="18" src="./images/newIcon.png"/>
<!-- 导航 ${leftCategoryItem.title}-->
<epg:grid column="8" row="1" left="170" top="80" width="400" height="38"  hcellspacing="0" items="${menuCategoryItems}" var="menuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:if test="${curIdx==1}">
		<epg:img id="menu${curIdx}" src="./images/dot.gif" width="50"  href="${returnUrl}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
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
<epg:img id="back" src="./images/dot.gif" width="35" height="30" left="579"  top="96" href="${returnHomeUrl}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"/>
<epg:img id="back_img" src="./images/dot.gif" width="35" height="30" left="579" top="96"  style="visibility:hidden;border:3px solid #ff9c13" />
<!-- 海报 -->
<epg:if test="${leftUpCategoryItems!=null}">
	<epg:navUrl obj="${leftUpCategoryItems}" indexUrlVar="leftUpIndexUrl" />
	<epg:img id="leftUp" src="../${leftUpCategoryItems.icon}" left="40" top="150" width="110" height="330"/>
	<epg:img id="leftUpfocus" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" src="./images/dot.gif" left="39" top="147" href="${leftUpIndexUrl}&returnTo=biz&pi=1"  rememberFocus="true" width="110" height="330"/>
	<epg:img id="leftUpfocus_img" style="visibility:hidden;border:3px solid #ff9c13" src="./images/dot.gif" left="39" top="147" width="110" height="330"/>
</epg:if>
<!-- 名称 -->
<epg:text left="40" top="503" width="110" height="50" color="#ffffff" chineseCharNumber="8" dotdotdot=" " fontSize="16"
		  align="center" fontFamily="黑体" text="${leftUpCategoryItems.title}"/>
<epg:img id="lefttitle"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  rememberFocus="true" left="39" top="489" width="110" height="50" href="${leftUpIndexUrl}&returnTo=biz&pi=1"  src="./images/dot.gif" />
<epg:img id="lefttitle_img" style="visibility:hidden;border:3px solid #ff9c13"  left="39" top="489" width="110" height="50" src="./images/dot.gif" />


<!-- 预告片 -->
<epg:navUrl obj="${trailerCategoryItem}" indexUrlVar="trailerIndexUrl" playUrlVar="trailerPlayUrl" />
<epg:img id="lefttrailer" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  rememberFocus="true" left="39" top="542" width="110" height="37" href="${trailerPlayUrl}&returnTo=biz&pi=1"  src="./images/dot.gif" />
<epg:img id="lefttrailer_img" style="visibility:hidden;border:3px solid #ff9c13" left="39" top="542" width="110" height="37"  src="./images/dot.gif" />

<!-- 全集 -->
<epg:img id="leftUp"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  rememberFocus="true" left="39" top="582" width="110" height="37" href="${leftUpIndexUrl}&returnTo=biz&pi=1"  src="./images/dot.gif" />
<epg:img  id="leftUp_img" style="visibility:hidden;border:3px solid #ff9c13"  left="39" top="582" width="110" height="37"  src="./images/dot.gif" />


<!-- pageTurn -->
		
<epg:img id="pageUp" left="174" top="148"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  width="65" height="31" src="./images/dot.gif" href="javascript:pageUp();"/>
<epg:img  id="pageUp_img"  left="174" top="148" style="visibility:hidden;border:3px solid #ff9c13"  width="65" height="31" src="./images/dot.gif" />
<epg:img id="pageDown"  left="250" top="148" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  width="65" height="31" src="./images/dot.gif" href="javascript:pageDown();"/>
<epg:img id="pageDown_img"  left="250" top="148" style="visibility:hidden;border:3px solid #ff9c13" width="65" height="31" src="./images/dot.gif" />

<epg:text left="342" top="154" width="50" height="25" color="#fffccb" fontSize="16" align="left" fontFamily="黑体"
		  text="${pageBean.pageIndex}/${pageBean.pageCount} 页"/>
<!-- contents -->
<epg:grid left="175" top="218" width="440" height="431" row="2" column="6" items="${rightCategoryItems}"
		  var="rightCategoryItem" indexVar="curIdx" posVar="positions" hcellspacing="20" vcellspacing="42">
	<epg:navUrl obj="${rightCategoryItem}" indexUrlVar="indexUrl"/>
	<div id="contentFocus${curIdx}_div" style="position:absolute;visibility:hidden;border:3px solid #0bebff;
			left:${positions[curIdx-1].x-3}px;top:${positions[curIdx-1].y-3}px;width:65px;height:195px;" ></div>
	<epg:img id="content${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="65" height="195"
			 src="../${rightCategoryItem.still}"/>
	<epg:img id="content${curIdx}focus"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="65" height="195"
			rememberFocus="true" src="./images/dot.gif" href="${indexUrl}&returnTo=bizcat"/>
	<epg:img id="content${curIdx}focus_img" style="visibility:hidden;border:3px solid #ff9c13" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="65" height="195"
			src="./images/dot.gif"/>		 
	
    <epg:if test="${pageBean.pageIndex==1}">
	    <epg:query queryName="queryEpisodeByCode" maxRows="1000" var="episodes">
	    	<epg:param name="seriesCode" value="${rightCategoryItem.itemCode}" type="java.lang.String" />
	    </epg:query>
	    <epg:if test="${rightCategoryItem.itemType == 'series'}">
			<epg:text left="${positions[curIdx-1].x+0}" top="${positions[curIdx-1].y+206}" width="65" height="50"
					  color="#794d8a" dotdotdot="" fontSize="16" fontFamily="黑体">更新至第     集</epg:text>
			   <fmt:formatNumber pattern="00" value="${episodes[fn:length(episodes)-1].episodeIndex}" var="episode"/>
			<epg:text left="${positions[curIdx-1].x+60}" top="${positions[curIdx-1].y+201}" width="17" height="50"
					  color="#9c5194" dotdotdot="" fontSize="16" fontFamily="黑体" align="center" text="${episode}"/>
		</epg:if>
	</epg:if>
</epg:grid>
</div>
<!-- **************************************************************** -->
<div id="rightDiv">
<epg:img defaultSrc="./images/sd_theaterList_sbo.jpg" src="../${templateParams['backgroundImg']}" id="r_main"  left="640" top="0" width="640" height="720"/>
<epg:img left="770" top="66" width="22" height="45" src="./images/sitvLogo1.png"/>
<epg:img left="999" top="76" width="10" height="18" src="./images/newIcon.png"/>
<epg:img left="1049" top="76" width="10" height="18" src="./images/newIcon.png"/>
<!-- 导航 ${leftCategoryItem.title}-->
<epg:grid column="8" row="1" left="810" top="80" width="400" height="38"  hcellspacing="0" items="${menuCategoryItems}" var="menuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:if test="${curIdx==1}">
		<epg:img id="r_menu${curIdx}" src="./images/dot.gif" width="50"  href="${returnUrl}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
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
<epg:img id="r_back" src="./images/dot.gif" width="35" height="30" left="1219"  top="96" href="${returnHomeUrl}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"/>
<epg:img id="r_back_img" src="./images/dot.gif" width="35" height="30" left="1219" top="96"  style="visibility:hidden;border:3px solid #ff9c13" />
<!-- 海报 -->
<epg:if test="${leftUpCategoryItems!=null}">
	<epg:navUrl obj="${leftUpCategoryItems}" indexUrlVar="leftUpIndexUrl" />
	<epg:img id="r_leftUp" src="../${leftUpCategoryItems.icon}" left="680" top="150" width="110" height="330"/>
	<epg:img id="r_leftUpfocus" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" src="./images/dot.gif" left="679" top="147" href="${leftUpIndexUrl}&returnTo=biz&pi=1"  rememberFocus="true" width="110" height="330"/>
	<epg:img id="r_leftUpfocus_img" style="visibility:hidden;border:3px solid #ff9c13" src="./images/dot.gif" left="679" top="147" width="110" height="330"/>
</epg:if>
<!-- 名称 -->
<epg:text left="680" top="503" width="110" height="50" color="#ffffff" chineseCharNumber="8" dotdotdot=" " fontSize="16"
		  align="center" fontFamily="黑体" text="${leftUpCategoryItems.title}"/>
<epg:img id="r_lefttitle"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  rememberFocus="true" left="679" top="489" width="110" height="50" href="${leftUpIndexUrl}&returnTo=biz&pi=1"  src="./images/dot.gif" />
<epg:img id="r_lefttitle_img" style="visibility:hidden;border:3px solid #ff9c13"  left="679" top="489" width="110" height="50" src="./images/dot.gif" />


<!-- 预告片 -->
<epg:navUrl obj="${trailerCategoryItem}" indexUrlVar="trailerIndexUrl" playUrlVar="trailerPlayUrl" />
<epg:img id="r_lefttrailer" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  rememberFocus="true" left="679" top="542" width="110" height="37" href="${trailerPlayUrl}&returnTo=biz&pi=1"  src="./images/dot.gif" />
<epg:img id="r_lefttrailer_img" style="visibility:hidden;border:3px solid #ff9c13" left="679" top="542" width="110" height="37"  src="./images/dot.gif" />

<!-- 全集 -->
<epg:img id="r_leftUp"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  rememberFocus="true" left="679" top="582" width="110" height="37" href="${leftUpIndexUrl}&returnTo=biz&pi=1"  src="./images/dot.gif" />
<epg:img  id="r_leftUp_img" style="visibility:hidden;border:3px solid #ff9c13"  left="39" top="582" width="110" height="37"  src="./images/dot.gif" />


<!-- pageTurn -->
		
<epg:img id="r_pageUp" left="814" top="148"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  width="65" height="31" src="./images/dot.gif" href="javascript:pageUp();"/>
<epg:img  id="r_pageUp_img"  left="814" top="148" style="visibility:hidden;border:3px solid #ff9c13"  width="65" height="31" src="./images/dot.gif" />
<epg:img id="r_pageDown"  left="890" top="148" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  width="65" height="31" src="./images/dot.gif" href="javascript:pageDown();"/>
<epg:img id="r_pageDown_img"  left="890" top="148" style="visibility:hidden;border:3px solid #ff9c13" width="65" height="31" src="./images/dot.gif" />

<epg:text left="982" top="154" width="50" height="25" color="#fffccb" fontSize="16" align="left" fontFamily="黑体"
		  text="${pageBean.pageIndex}/${pageBean.pageCount} 页"/>
<!-- contents -->
<epg:grid left="815" top="218" width="440" height="431" row="2" column="6" items="${rightCategoryItems}"
		  var="rightCategoryItem" indexVar="curIdx" posVar="positions" hcellspacing="20" vcellspacing="42">
	<epg:navUrl obj="${rightCategoryItem}" indexUrlVar="indexUrl"/>
	<div id="r_contentFocus${curIdx}_div" style="position:absolute;visibility:hidden;border:3px solid #0bebff;
			left:${positions[curIdx-1].x-3}px;top:${positions[curIdx-1].y-3}px;width:65px;height:195px;" ></div>
	<epg:img id="r_content${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="65" height="195"
			 src="../${rightCategoryItem.still}"/>
	<epg:img id="r_content${curIdx}focus"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="65" height="195"
			rememberFocus="true" src="./images/dot.gif" href="${indexUrl}&returnTo=bizcat"/>
	<epg:img id="r_content${curIdx}focus_img" style="visibility:hidden;border:3px solid #ff9c13" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="65" height="195"
			src="./images/dot.gif"/>		 
	
    <epg:if test="${pageBean.pageIndex==1}">
	    <epg:query queryName="queryEpisodeByCode" maxRows="1000" var="episodes">
	    	<epg:param name="seriesCode" value="${rightCategoryItem.itemCode}" type="java.lang.String" />
	    </epg:query>
	    <epg:if test="${rightCategoryItem.itemType == 'series'}">
			<epg:text left="${positions[curIdx-1].x+0}" top="${positions[curIdx-1].y+206}" width="65" height="50"
					  color="#794d8a" dotdotdot="" fontSize="16" fontFamily="黑体">更新至第     集</epg:text>
			   <fmt:formatNumber pattern="00" value="${episodes[fn:length(episodes)-1].episodeIndex}" var="episode"/>
			<epg:text left="${positions[curIdx-1].x+60}" top="${positions[curIdx-1].y+201}" width="17" height="50"
					  color="#9c5194" dotdotdot="" fontSize="16" fontFamily="黑体" align="center" text="${episode}"/>
		</epg:if>
	</epg:if>
</epg:grid>
</div>
</epg:body>
</epg:html>