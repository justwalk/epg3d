<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@page import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*"%>
<%@include file="epgUtils.jsp"%>
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
<!-- 推荐-全集 -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="1" var="recs">
	<epg:param name="categoryCode" value="${templateParams['recCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 推荐-预告片 -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="1" var="recs2">
	<epg:param name="categoryCode" value="${templateParams['recCategoryCode2']}" type="java.lang.String"/>
</epg:query>
<!-- programList -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="12" var="contents"
		pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true">
	<epg:param name="categoryCode" value="${templateParams['contentCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- backUrl -->
<epg:query queryName="getSeverialItems" maxRows="1" var="returnObj" >
	<epg:param name="categoryCode" value="${templateParams['backCode']}" type="java.lang.String"/>
</epg:query>
<epg:navUrl obj="${returnObj}" indexUrlVar="returnUrl"/>
<style type="text/css">
	body{
		color:#02296d;
		font-size:22px;
		font-family:黑体;	
	}
	a{outline:none;}
	img{border:0px solid black;} 
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
				setTimeout(function(){
					pageLoad = true;
					
					if(typeof(iPanel)!='undefined'){
						iPanel.focus.display = 1;
						iPanel.focus.border = 1;
					}
					init();
				},1500);
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
				back();
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
	function getfocus(objId){
		if(pageLoad){
			fristFocus++;
			//var id = objId.substring(0,objId.indexOf("_"));
			//document.getElementById(id+"_img_img").style.visibility="visible";
		}
	}
	function outfocus(objId){
		if(pageLoad){
			//var id = objId.substring(0,objId.indexOf("_"));
			//document.getElementById(id+"_img_img").style.visibility="hidden";
		}
	}
	
	function init(){
		var leaveFocusId = "${leaveFocusId}";
		if(leaveFocusId!=""&& document.getElementById(leaveFocusId+"_a")){
			document.getElementById(leaveFocusId+"_a").focus();
		}else{
			document.getElementById("contentFocus1_a").focus();
		}
	}

	function end(){
		iPanel.focus.display = 0;
		iPanel.focus.border = 0;
	}

	function back(){
		returnToBizOrHistory();
	}

	function exit(){
		window.location.href = "${returnHomeUrl}";
	}
	
	function returnToBizOrHistory(){
		if("${param.returnTo}"!=""&&"${param.returnTo}"!=null){
			window.location.href = "${returnUrl}";
		}else{
			history.back();
		}
	}
</script>

<epg:body bgcolor="#000000" onload="init();" onunload="end();" width="1280" height="720">

<epg:img src="./images/premiereChinaBg.jpg" left="0" top="0" width="1280" height="720"/>

<!-- exit -->
<epg:img left="1132" top="68" width="83" height="35" src="${dot}" href="${returnUrl}"/>

<!-- pageTurn -->
<epg:img id="pageUp" src="${dot}" left="335" top="169" width="130" height="34"  href="javascript:pageUp();" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
		 pageop="up" keyop="pageup"/>
<epg:img id="pageDown" src="${dot}" left="485" top="169" width="130" height="34" href="javascript:pageDown()" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
		 pageop="down" keyop="pagedown"/>
<epg:text left="659" top="172" width="53" height="25" text="${pageBean.pageIndex}/${pageBean.pageCount}"
			  fontFamily="黑体" fontSize="24" color="#fffccb" align="center"/>

<!-- contents -->
<epg:grid left="335" top="235" width="880" height="420" row="2" column="6" items="${contents}"
 		  var="content" indexVar="idx" posVar="pos">
	<epg:navUrl obj="${content}" indexUrlVar="indexUrl"/>
	<epg:choose>
		<epg:when test="${idx == 1}">
			<epg:set value="true" var="defaultFocus"/>
		</epg:when>
		<epg:otherwise>
			<epg:set value="false" var="defaultFocus"/>
		</epg:otherwise>
	</epg:choose>
	<epg:img id="content${idx}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="130" height="195" src="../${content.still}"/>
	<epg:img id="contentFocus${idx}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="136" height="201" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" 
		href="${indexUrl}" rememberFocus="true" src="./images/dot.gif"/>
</epg:grid>
<!-- rec -->

<epg:navUrl obj="${recs2}" playUrlVar="playUrl"/>
<epg:navUrl obj="${recs}" indexUrlVar="indexUrl"/>
<epg:if test="${!empty recs}">
	<epg:img left="66" top="169" width="220" height="330"  src="../${recs.icon}"/>
	<epg:img id="icon" left="63" top="166" width="226" height="336" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" 
		href="${indexUrl}" rememberFocus="true" src="./images/dot.gif"/>
	<epg:text left="65" top="523" width="220" height="49" text="${recs.title}" fontFamily="黑体" fontSize="26" color="#ffd6cc" align="center" chineseCharNumber="8" dotdotdot="..."/>
</epg:if>
<epg:if test="${!empty recs2}">
	<epg:img id="prevue" left="66" top="575" width="220" height="37"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);" href="${playUrl}" rememberFocus="true" src="${dot}"/>
</epg:if>
<epg:if test="${!empty recs}">
	<epg:img id="positive" left="66" top="618" width="220" height="37" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" href="${indexUrl}" rememberFocus="true" src="${dot}"/>
</epg:if>
</epg:body>
</epg:html>