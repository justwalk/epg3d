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

<!-- left recommend -->
<epg:query queryName="getSeverialItems" maxRows="3" var="leftCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['leftRecommend']}" type="java.lang.String"/>
</epg:query>
<!-- contents -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="12" var="rightCategoryItems"
		   pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true">
	<epg:param name="categoryCode" value="${templateParams['programCategoryCode']}" type="java.lang.String"  />
</epg:query>
<epg:navUrl returnTo="biz" returnUrlVar="returnUrl"/>

<style type="text/css">
	body{
		color:#FFFFFF;
		font-size:22;
		font-family:"黑体";
	}
	img{border:0px solid black;}
	div{position: absolute;}
</style>

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
			document.getElementById("right1_a").focus();
		}
	}
function pageUp(){
  	var previousUrl = "${pageBean.previousUrl}";
	var myPageIndex = "";
	if(previousUrl.indexOf("&pageIndex=")!=-1){
		myPageIndex = previousUrl.substring(previousUrl.indexOf("&pageIndex="),previousUrl.length);
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

	function eventHandler(eventObj){
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
<epg:img defaultSrc="./images/oumei2.jpg" src="../${templateParams['backgroundImg']}" width="640" height="720"/>

<!-- back-->
<epg:img id="backbd" src="./images/dot.png" left="576" top="65"
	width="35" height="32" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:img id="back" src="./images/dot.png" left="577" top="68"
	onblur="iconOnblur('backbd');" onfocus="iconOnfocus('backbd')"
	width="35" height="32" href="${returnUrl}"/>

<!-- pageTurn -->
<epg:img id="pageUpFocus" src="./images/dot.png" left="172" top="170"
	 	width="65" height="30" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:img id="pageUp" left="174" top="173" width="65" height="30" src="./images/dot.gif" href="javascript:pageUp();"
 	 	onblur="iconOnblur('pageUpFocus');" onfocus="iconOnfocus('pageUpFocus')" pageop="up" keyop="pageup"/>
<epg:img id="pageDownFocus" src="./images/dot.png" left="247" top="170"
	 	width="65" height="30" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:img id="pageDown" left="249" top="173" width="65" height="30" src="./images/dot.gif" href="javascript:pageDown();"
		onblur="iconOnblur('pageDownFocus');" onfocus="iconOnfocus('pageDownFocus')" pageop="down" keyop="pagedown"/>

<epg:text left="327" top="176" width="75" height="32" color="#9e8b43" fontSize="22" fontFamily="黑体" align="left"
		  text="${pageBean.pageIndex}/${pageBean.pageCount} 页"/>

<!-- contents -->
<epg:grid left="174" top="218" width="441" height="431" row="2" column="6" items="${rightCategoryItems}"
		var="rightCategoryItem" indexVar="curIdx" posVar="positions" hcellspacing="20" vcellspacing="38">
	<epg:navUrl obj="${rightCategoryItem}" indexUrlVar="indexUrl"/>
	
	<epg:img id="contentFocus${curIdx}" src="./images/dot.png" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"
		width="65" height="195" style="border:3px solid #0bebff;visibility: hidden;" />
	<epg:img id="right${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="65" height="195"
		onblur="iconOnblur('contentFocus${curIdx}');" onfocus="iconOnfocus('contentFocus${curIdx}')"
		rememberFocus="true" src="../${rightCategoryItem.still}" href="${indexUrl}&returnTo=bizcat"/>
</epg:grid>

<!-- recommend -->
<epg:grid left="32" top="175" width="117" height="471" row="3" column="1" items="${leftCategoryItems}"
		var="leftCategoryItem" indexVar="curIdx" posVar="positions" vcellspacing="34">
	<epg:navUrl obj="${leftCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="leftFocus${curIdx}" src="./images/dot.png" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"
	 	width="117" height="135" style="border:3px solid #0bebff;visibility: hidden;" />
	<epg:img id="left${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="117" height="135"
		onblur="iconOnblur('leftFocus${curIdx}');" onfocus="iconOnfocus('leftFocus${curIdx}')"
		src="../${leftCategoryItem.itemIcon}" href="${indexUrl}&returnTo=biz&pi=${curIdx}" rememberFocus="true"/>
</epg:grid>

<!-- ********************************************* -->
<div id="rightDiv">
<epg:img defaultSrc="./images/oumei2.jpg" src="../${templateParams['backgroundImg']}" width="640" height="720" left="640"/>

<!-- back-->
<epg:img id="r_backbd" src="./images/dot.png" left="1216" top="65"
	width="35" height="32" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:img id="r_back" src="./images/dot.png" left="1217" top="68"
	onblur="iconOnblur('backbd');" onfocus="iconOnfocus('backbd')"
	width="35" height="32" href="${returnUrl}"/>

<!-- pageTurn -->
<epg:img id="r_pageUpFocus" src="./images/dot.png" left="812" top="170"
	 	width="65" height="30" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:img id="r_pageUp" left="814" top="173" width="65" height="30" src="./images/dot.gif" href="javascript:pageUp();"
 	 	onblur="iconOnblur('pageUpFocus');" onfocus="iconOnfocus('pageUpFocus')" pageop="up" keyop="pageup"/>
<epg:img id="r_pageDownFocus" src="./images/dot.png" left="887" top="170"
	 	width="65" height="30" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:img id="r_pageDown" left="889" top="173" width="65" height="30" src="./images/dot.gif" href="javascript:pageDown();"
		onblur="iconOnblur('pageDownFocus');" onfocus="iconOnfocus('pageDownFocus')" pageop="down" keyop="pagedown"/>

<epg:text left="967" top="176" width="75" height="32" color="#9e8b43" fontSize="22" fontFamily="黑体" align="left"
		  text="${pageBean.pageIndex}/${pageBean.pageCount} 页"/>

<!-- contents -->
<epg:grid left="824" top="218" width="441" height="431" row="2" column="6" items="${rightCategoryItems}"
		var="rightCategoryItem" indexVar="curIdx" posVar="positions" hcellspacing="20" vcellspacing="38">
	<epg:navUrl obj="${rightCategoryItem}" indexUrlVar="indexUrl"/>
	
	<epg:img id="r_contentFocus${curIdx}" src="./images/dot.png" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"
		width="65" height="195" style="border:3px solid #0bebff;visibility: hidden;" />
	<epg:img id="r_right${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="65" height="195"
		onblur="iconOnblur('contentFocus${curIdx}');" onfocus="iconOnfocus('contentFocus${curIdx}')"
		rememberFocus="true" src="../${rightCategoryItem.still}" href="${indexUrl}&returnTo=bizcat"/>
</epg:grid>

<!-- recommend -->
<epg:grid left="672" top="175" width="117" height="471" row="3" column="1" items="${leftCategoryItems}"
		var="leftCategoryItem" indexVar="curIdx" posVar="positions" vcellspacing="34">
	<epg:navUrl obj="${leftCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="r_leftFocus${curIdx}" src="./images/dot.png" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"
	 	width="117" height="135" style="border:3px solid #0bebff;visibility: hidden;" />
	<epg:img id="r_left${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="117" height="135"
		onblur="iconOnblur('leftFocus${curIdx}');" onfocus="iconOnfocus('leftFocus${curIdx}')"
		src="../${leftCategoryItem.itemIcon}" href="${indexUrl}&returnTo=biz&pi=${curIdx}" rememberFocus="true"/>
</epg:grid>
</div>
</div>

</epg:body>
</epg:html>