<%@page contentType="text/html; charset=GBK" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*" %>
<% 
	String pageIndex = request.getParameter("pageIndex");
	request.setAttribute("formerPageIndex", pageIndex);
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

<!-- 内容栏目 -->
<epg:query queryName="getSeverialItems" maxRows="12" var="newsCategoryItems"  pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true">
	<epg:param name="categoryCode" value="${templateParams['newsCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 右上固定栏目 -->
<epg:query queryName="getSeverialItems" maxRows="1" var="rightUpCategoryItem">
	<epg:param name="categoryCode" value="${templateParams['rightUpCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 右下推荐栏目 -->
<epg:query queryName="getSeverialItems" maxRows="1" var="rightDownCategoryItem">
	<epg:param name="categoryCode" value="${templateParams['rightDownCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 标题栏目 -->
<epg:query queryName="getSeverialItems" maxRows="1" var="titleCategoryItem">
	<epg:param name="categoryCode" value="${templateParams['titleCategoryCode']}" type="java.lang.String"/>
</epg:query>
<style>
	body{
		color: #000000;
	}
</style>
<epg:navUrl returnTo="home" returnUrlVar="returnHomeUrl"></epg:navUrl>
<epg:navUrl returnTo="biz" returnUrlVar="returnBizUrl"></epg:navUrl>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script type="text/javascript">
	var pageLoad = false;
	var fristFocus = 0;
	if (typeof(iPanel) == 'undefined') {
		pageLoad  = true;
	}
	function init(){
		var leaveFocusId = "${leaveFocusId}";
		if(leaveFocusId!=""&&document.getElementById(leaveFocusId+"_a")){
			document.getElementById(leaveFocusId+"_a").focus();
		}else{
			document.getElementById("newsCategory1_focus_a").focus();
		}
	}
	function getfocus(objId){
		if (pageLoad) {
			fristFocus++;
			var id = objId.substring(0, objId.indexOf("_a"));
			document.getElementById(id + "_img_img").style.visibility = "visible";
		}
	}
	function outfocus(objId){
		if (pageLoad) {
			var id = objId.substring(0, objId.indexOf("_a"));
			document.getElementById(id + "_img_img").style.visibility = "hidden";
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
 	document.location.href = previousUrl+"&leaveFocusId=pu"+myPageIndex;
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
 	document.location.href = nextUrl+"&leaveFocusId=pd"+myPageIndex;
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
			pageUp()
			return 0;
	    	break;
	    case "SITV_KEY_PAGEDOWN":
			pageDown()
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
			window.location.href = "${context['EPG_CONTEXT']}/common/logout/logout.jsp";
			return 0;
			break;
		default:
			return 1;
			break;
	}
}
</script>

<epg:html>
<epg:body onload="init()" width="1280"  height="720" style="background-repeat:no-repeat;" background="../${templateParams['bgImg']}" defaultBg="./images/list_hotTopic.jpg"  bgcolor="#000000">
	
	<!-- 左侧内容 -->
	<epg:grid column="1" row="12" left="83" top="201" width="644" height="450" vcellspacing="6"  items="${newsCategoryItems}" var="newsCategoryItem"  indexVar="curIdx" posVar="positions">
		<epg:navUrl obj="${newsCategoryItem}" indexUrlVar="indexUrl"/>
		<epg:text id="newsCategory${curIdx}" align="left" fontSize="24" chineseCharNumber="25" left="${positions[curIdx-1].x+10}" top="${positions[curIdx-1].y+4}" width="644" height="32" text="${newsCategoryItem.title}"/>
		<epg:img id="newsCategory${curIdx}_focus" src="./images/dot.gif" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="644" height="32" rememberFocus="true"  href="${indexUrl}"/>
		<epg:img id="newsCategory${curIdx}_focus_img" src="./images/dot.gif" style="visibility:hidden;border:3px solid #ff9c13" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="644" height="32"/>
	</epg:grid>
	 
	<!-- 翻页 -->
	
	<epg:img id='pu' src="./images/dot.gif" left="464" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  top="147" width="70" height="17" href="javascript:pageUp();"/>
	<epg:img id='pu_img' src="./images/dot.gif" style="visibility:hidden;border:3px solid #ff9c13"  left="464" top="147" width="70" height="17"/>
	<epg:img id='pd' src="./images/dot.gif" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="545" top="147"  width="70" height="17" href="javascript:pageDown();"/>
	<epg:img id='pd_img' src="./images/dot.gif" style="visibility:hidden;border:3px solid #ff9c13" left="545" top="147"  width="70" height="17"/>
	<epg:text fontSize="24" id="pageCount" align="right" text="${pageBean.pageIndex}/${pageBean.pageCount}" left="632" top="147" width="68" height="23"></epg:text>

	<!-- 标题 -->
	<epg:text fontSize="24" id="title" align="center" text="${titleCategoryItem.title}" left="475" top="72" width="327" height="40"></epg:text>
	
	<!-- 返回 -->
	<epg:img id='back' src="./images/dot.gif" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="1127" top="68" width="71" height="30" href="${returnBizUrl}"/>
	<epg:img id='back_img' src="./images/dot.gif" style="visibility:hidden;border:3px solid #ff9c13" left="1127" top="68" width="71" height="30"/>
	
	<!-- 右上固定栏目 -->
	<epg:img src="../${rightUpCategoryItem.itemIcon}" left="751" top="142" width="454" height="275" />
	
	<!-- 右下推荐栏目 -->
	<epg:img src="../${rightDownCategoryItem.itemIcon}" left="745" top="435" width="456" height="218" />

</epg:body>
</epg:html>