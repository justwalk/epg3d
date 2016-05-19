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
<style>
body{
	color:#FFFFFF;
	font-size:22;
	font-family:"黑体";
}
a{outline:none;}
img{border:0px solid black;}
div{position: absolute;}
</style>
<!-- left recommend query -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="1" var="leftCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['leftRecommend']}" type="java.lang.String"/>
</epg:query>

<!-- 预告片-->
<epg:query queryName="getSeverialItems" maxRows="1" var="trailerCategoryItem" >
	<epg:param name="categoryCode" value="${templateParams['trailerCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- contents query -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="12" var="rightCategoryItems"
		   pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true" >
	<epg:param name="categoryCode" value="${templateParams['programCategoryCode']}" type="java.lang.String"  />
</epg:query>
<epg:navUrl returnTo="home" returnUrlVar="returnUrl"/>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script>
	var pageLoad = false;
	var fristFocus = 0;
	if (typeof(iPanel) == 'undefined') {
		pageLoad  = true;
	}
	function iconOnfocus(objId){
		if (pageLoad) {
			fristFocus++;
			document.getElementById(objId+"_img").style.visibility = 'visible';
			document.getElementById("r_"+objId+"_img").style.visibility = 'visible';
		}
	}
	
	function iconOnblur(objId){
		if (pageLoad) {
			document.getElementById(objId+"_img").style.visibility = 'hidden';
			document.getElementById("r_"+objId+"_img").style.visibility = 'hidden';
		}
	}

	function init(){
		var leaveFocusId = "${leaveFocusId}";
		if(leaveFocusId!=""){
			document.getElementById(leaveFocusId+"_a").focus();
		}else{
			document.getElementById("content1_a").focus();
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
 function back(){
 	document.location.href = "${returnUrl}";
 }
 function exit(){
 	back();
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
				pageUp();
				return 0;
	    	break;
	    case "SITV_KEY_PAGEDOWN":
				pageDown();
				return 0;
	    case "SITV_KEY_BACK":
	    	document.location.href = "${returnUrl}";
			return 0;
	    	break;
		case "SITV_KEY_EXIT":
			exit();
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
<epg:body onload="init();" bgcolor="#000000">
<div id="leftDiv">
<epg:img defaultSrc="./images/hanguo2.jpg" src="../${templateParams['backgroundImg']}" width="640" height="720"/>

<!-- pageTurn -->
<epg:img id="pageUpFocus" src="./images/dot.png" left="168" top="174"
	 width="65" height="32" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:img id="pageUp" left="170" top="177" width="65" height="32" src="./images/dot.gif" href="javascript:pageUp();"
 	 	onblur="iconOnblur('pageUpFocus');" onfocus="iconOnfocus('pageUpFocus')" pageop="up" keyop="pageup"/>
<epg:img id="pageDownFocus"src="./images/dot.png" left="243" top="174"
	 width="65" height="32" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:img id="pageDown" left="245" top="177" width="65" height="32" src="./images/dot.gif" href="javascript:pageDown();"
		onblur="iconOnblur('pageDownFocus');" onfocus="iconOnfocus('pageDownFocus')" pageop="down" keyop="pagedown"/>
<epg:text left="334" top="178" width="70" height="24" color="#21101d" fontSize="22" align="left" fontFamily="黑体"
		  text="${pageBean.pageIndex}/${pageBean.pageCount} 页"/>
	
<!-- contents -->
<epg:grid left="170" top="218" width="440" height="431" row="2" column="6" items="${rightCategoryItems}"
		  var="rightCategoryItem" indexVar="curIdx" posVar="positions" hcellspacing="20" vcellspacing="42">
	<epg:navUrl obj="${rightCategoryItem}" indexUrlVar="indexUrl"/>
	
	<epg:img id="contentFocus${curIdx}" src="./images/dot.png" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"
	 	width="65" height="195" style="border:3px solid #0bebff;visibility: hidden;" />
	<epg:img id="content${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="65" height="195"
			onblur="iconOnblur('contentFocus${curIdx}');" onfocus="iconOnfocus('contentFocus${curIdx}')"
			 rememberFocus="true" src="../${rightCategoryItem.still}" href="${indexUrl}&returnTo=bizcat"/>
	
	
	<epg:if test="${pageBean.pageIndex == 1 && curIdx <= 6}">
        <epg:query queryName="queryEpisodeByCode" maxRows="1000" var="episodes">
	    	<epg:param name="seriesCode" value="${rightCategoryItem.itemCode}" type="java.lang.String" />
        </epg:query>
		<epg:text left="${positions[curIdx-1].x+2}" top="${positions[curIdx-1].y+210}" width="65" height="50"
				  color="#999999" dotdotdot="" fontSize="10" fontFamily="黑体">更新至第     集</epg:text>
		<epg:text left="${positions[curIdx-1].x+35}" top="${positions[curIdx-1].y+205}" width="35" height="50"
				  color="#ffc77d" dotdotdot="" fontSize="12" fontFamily="黑体" align="center" text="${episodes[fn:length(episodes)-1].episodeIndex}"/>
	</epg:if>
</epg:grid>

<!-- recommend -->
<epg:navUrl obj="${leftCategoryItems}" indexUrlVar="leftCategoryIndexUrl" playUrlVar="playUrl"/>
<!-- leftContent0 -->
<epg:img id="leftContent0" src="./images/dot.png" left="33" top="174" width="110" height="330" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:if test="${leftCategoryItems != null}">	
	<epg:img id="left0" left="35" top="177" width="110" onblur="iconOnblur('leftContent0');" onfocus="iconOnfocus('leftContent0')" href="${leftCategoryIndexUrl}&pi=1&returnTo=biz" rememberFocus="true" height="330" src="../${leftCategoryItems.icon}" />
</epg:if>

<!-- leftContent1 -->
<epg:img id="leftContent1" src="./images/dot.png" left="40" top="525" width="100" height="32" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:if test="${leftCategoryItems != null}">
	<epg:text left="40" top="529" width="100" height="50" color="#f1d4ff" chineseCharNumber="8" dotdotdot=" " fontSize="20" align="center" fontFamily="黑体" text="${leftCategoryItems.title}"/>
	<epg:img id="leftTitle0" left="42" top="528" width="100"  rememberFocus="true" onblur="iconOnblur('leftContent1');" onfocus="iconOnfocus('leftContent1')" href="${leftCategoryIndexUrl}&pi=1&returnTo=biz" height="32" src="./images/dot.gif" />
</epg:if>

<epg:navUrl obj="${trailerCategoryItem}" playUrlVar="trailerplayUrl"/>
<!-- leftContent2 -->
<epg:img id="leftContent2" src="./images/dot.png" left="40" top="575" width="100" height="32" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:if test="${trailerCategoryItem != null}">
	<epg:img id="foreShow2" src="./images/dot.png" left="42" top="576" onblur="iconOnblur('leftContent2');" onfocus="iconOnfocus('leftContent2')" width="100" height="32" href="${trailerplayUrl}&pi=1&returnTo=biz" rememberFocus="true"/>
</epg:if>

<!-- leftContent3 -->
<epg:img id="leftContent3" src="./images/dot.png" left="40" top="616" width="100" height="32" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:if test="${leftCategoryItems != null}">
	<epg:img id="foreShow3" src="./images/dot.png" left="42" top="619" onblur="iconOnblur('leftContent3');" onfocus="iconOnfocus('leftContent3')" width="100" height="32" href="${leftCategoryIndexUrl}&pi=1&returnTo=biz" rememberFocus="true"/>
</epg:if>

<!-- back -->
<epg:img id="backbd" src="./images/dot.png" left="561" top="86" width="35" height="30" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:img id="back" src="./images/dot.png" left="563" top="89" onblur="iconOnblur('backbd');" onfocus="iconOnfocus('backbd')" width="35" height="30" href="${returnUrl}" />
</div>
<!-- *********************************************************************** -->

<div id="rightDiv">
<epg:img defaultSrc="./images/hanguo2.jpg" src="../${templateParams['backgroundImg']}" width="640" height="720" left="640" top="0"/>

<!-- pageTurn -->
<epg:img id="r_pageUpFocus" src="./images/dot.png" left="808" top="174"
	 width="65" height="32" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:img id="r_pageUp" left="810" top="177" width="65" height="32" src="./images/dot.gif" href="javascript:pageUp();"
 	 	onblur="iconOnblur('pageUpFocus');" onfocus="iconOnfocus('pageUpFocus')" pageop="up" keyop="pageup"/>
<epg:img id="r_pageDownFocus"src="./images/dot.png" left="883" top="174"
	 width="65" height="32" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:img id="r_pageDown" left="885" top="177" width="65" height="32" src="./images/dot.gif" href="javascript:pageDown();"
		onblur="iconOnblur('pageDownFocus');" onfocus="iconOnfocus('pageDownFocus')" pageop="down" keyop="pagedown"/>
<epg:text left="974" top="178" width="70" height="24" color="#21101d" fontSize="22" align="left" fontFamily="黑体"
		  text="${pageBean.pageIndex}/${pageBean.pageCount} 页"/>
	
<!-- contents -->
<epg:grid left="820" top="218" width="440" height="431" row="2" column="6" items="${rightCategoryItems}"
		  var="rightCategoryItem" indexVar="curIdx" posVar="positions" hcellspacing="20" vcellspacing="42">
	<epg:navUrl obj="${rightCategoryItem}" indexUrlVar="indexUrl"/>
	
	<epg:img id="r_contentFocus${curIdx}" src="./images/dot.png" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"
	 	width="65" height="195" style="border:3px solid #0bebff;visibility: hidden;" />
	<epg:img id="r_content${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="65" height="195"
			onblur="iconOnblur('contentFocus${curIdx}');" onfocus="iconOnfocus('contentFocus${curIdx}')"
			 rememberFocus="true" src="../${rightCategoryItem.still}" href="${indexUrl}&returnTo=bizcat"/>
	
	
	<epg:if test="${pageBean.pageIndex == 1 && curIdx <= 6}">
        <epg:query queryName="queryEpisodeByCode" maxRows="1000" var="episodes">
	    	<epg:param name="seriesCode" value="${rightCategoryItem.itemCode}" type="java.lang.String" />
        </epg:query>
		<epg:text left="${positions[curIdx-1].x+2}" top="${positions[curIdx-1].y+210}" width="65" height="50"
				  color="#999999" dotdotdot="" fontSize="10" fontFamily="黑体">更新至第     集</epg:text>
		<epg:text left="${positions[curIdx-1].x+35}" top="${positions[curIdx-1].y+205}" width="35" height="50"
				  color="#ffc77d" dotdotdot="" fontSize="12" fontFamily="黑体" align="center" text="${episodes[fn:length(episodes)-1].episodeIndex}"/>
	</epg:if>
</epg:grid>

<!-- recommend -->
<epg:navUrl obj="${leftCategoryItems}" indexUrlVar="leftCategoryIndexUrl" playUrlVar="playUrl"/>
<!-- leftContent0 -->
<epg:img id="r_leftContent0" src="./images/dot.png" left="683" top="174" width="110" height="330" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:if test="${leftCategoryItems != null}">	
	<epg:img id="r_left0" left="685" top="177" width="110" onblur="iconOnblur('leftContent0');" onfocus="iconOnfocus('leftContent0')" href="${leftCategoryIndexUrl}&pi=1&returnTo=biz" rememberFocus="true" height="330" src="../${leftCategoryItems.icon}" />
</epg:if>

<!-- leftContent1 -->
<epg:img id="r_leftContent1" src="./images/dot.png" left="680" top="525" width="100" height="32" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:if test="${leftCategoryItems != null}">
	<epg:text left="680" top="529" width="100" height="50" color="#f1d4ff" chineseCharNumber="8" dotdotdot=" " fontSize="20" align="center" fontFamily="黑体" text="${leftCategoryItems.title}"/>
	<epg:img id="r_leftTitle0" left="682" top="528" width="100"  rememberFocus="true" onblur="iconOnblur('leftContent1');" onfocus="iconOnfocus('leftContent1')" href="${leftCategoryIndexUrl}&pi=1&returnTo=biz" height="32" src="./images/dot.gif" />
</epg:if>

<epg:navUrl obj="${trailerCategoryItem}" playUrlVar="trailerplayUrl"/>
<!-- leftContent2 -->
<epg:img id="r_leftContent2" src="./images/dot.png" left="680" top="575" width="100" height="32" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:if test="${trailerCategoryItem != null}">
	<epg:img id="r_foreShow2" src="./images/dot.png" left="682" top="576" onblur="iconOnblur('leftContent2');" onfocus="iconOnfocus('leftContent2')" width="100" height="32" href="${trailerplayUrl}&pi=1&returnTo=biz" rememberFocus="true"/>
</epg:if>

<!-- leftContent3 -->
<epg:img id="r_leftContent3" src="./images/dot.png" left="680" top="616" width="100" height="32" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:if test="${leftCategoryItems != null}">
	<epg:img id="r_foreShow3" src="./images/dot.png" left="682" top="619" onblur="iconOnblur('leftContent3');" onfocus="iconOnfocus('leftContent3')" width="100" height="32" href="${leftCategoryIndexUrl}&pi=1&returnTo=biz" rememberFocus="true"/>
</epg:if>

<!-- back -->
<epg:img id="r_backbd" src="./images/dot.png" left="1201" top="86" width="35" height="30" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:img id="r_back" src="./images/dot.png" left="1203" top="89" onblur="iconOnblur('backbd');" onfocus="iconOnfocus('backbd')" width="35" height="30" href="${returnUrl}" />
</div>
</epg:body>
</epg:html>