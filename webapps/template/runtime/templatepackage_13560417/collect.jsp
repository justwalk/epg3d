<%@page contentType="text/html; charset=UTF-8" pageEncoding="utf-8"%>
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
<!-- collects test:00034cb019c7-->

<epg:query queryName="getSevrialCollectionByUserId" maxRows="16" var="collects"  pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true">
	<epg:param name="user_id" value="${EPG_USER.userAccount}" type="java.lang.String"/>
</epg:query>
<epg:navUrl returnTo="home" returnUrlVar="returnHomeUrl"></epg:navUrl>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>

<style type="text/css">
body{
	color:#FFFFFF;
	font-size:22;
	font-family:"黑体";
}
img{border:0px solid black;}
.textLayer{z-index:2;}
a{outline:none;}
div{position:absolute;}
</style>
<script>

var pageLoad = false;
var fristFocus = 0;
if (typeof(iPanel) == 'undefined') {
	pageLoad  = true;
}
var fontArr = document.getElementsByTagName("font");

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
		hiddenItems(0);
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

function buttonOnFocus(objId,img){
	if (pageLoad) {
		fristFocus++;
		$(objId+"_img").src=imgPath+"/"+img+".png";
		hiddenItems(0);
	}
}

function buttonOnBlur(objId,img){
	if (pageLoad) {
		$(objId+"_img").src=imgPath+"/"+img+".png";
	}
}

function hiddenItems(curIdx){
	for(var i=1;i<=fontArr.length;i++){
		if(i!=curIdx){
			$("shadow"+i).style.backgroundColor = "#000000";
			$("shadow"+i).style.opacity = "0.8";
			$("shadow"+i).style.visibility = "hidden";
			$("contentName"+i).style.visibility = "hidden";
			$("delete"+i).style.visibility = "hidden";
			$("delete"+i).style.visibility = "hidden";
			$("orangeBg"+i).style.visibility = "hidden";
		}
	}
}

function itemsOnFocus(objId,img,idx){
	if (pageLoad) {
		fristFocus++;
		$("shadow"+idx).style.backgroundColor = "#f79922";
		$("shadow"+idx).style.opacity = "1";
		$("delete"+idx).style.visibility = "visible";
		$("shadow"+idx).style.visibility = "visible";
		$("orangeBg"+idx).style.visibility = "visible";
		if($("contentName"+idx) != null){
			$("contentName"+idx).style.visibility = "visible";
		}
		hiddenItems(idx);
	}
}

function itemsOnBlur(objId,img,idx){
}

function deleteOnFocus(objId,idx){
	if (pageLoad) {
		fristFocus++;
		$(objId+"_img").src=imgPath+"/deleteOnfocus.png";
		$("shadow"+idx).style.backgroundColor = "#000000";
		$("shadow"+idx).style.opacity = "0.8";
		$("shadow"+idx).style.visibility = "hidden";
		$("contentName"+idx).style.visibility = "hidden";
		$("orangeBg"+idx).style.visibility = "hidden";
	}
}

function deleteOnBlur(objId,idx){
	if (pageLoad) {
		$(objId+"_img").src=imgPath+"/delete.png";
	}
}

function init(){
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""&&document.getElementById(leaveFocusId+"_a")){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		document.getElementById("collect1_a").focus();
	}
}
function back(){
 	document.location.href = "${returnHomeUrl}";
 }
 function exit(){
 	back();
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
 	document.location.href = previousUrl+"&leaveFocusId=pre"+myPageIndex;
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
 	document.location.href = nextUrl+"&leaveFocusId=next"+myPageIndex;
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
<epg:body onload="init();" background="../${templateParams['backgroundImg']}"  style="background-repeat:no-repeat;" defaultBg="./images/collect.jpg"  bgcolor="#000000" width="1280"  height="720" >
<div style="position:absolute;left:0px; top:0px; width:350px; height:85px;">
<epg:img src="./images/logo.png"  width="350" height="85"/>
<epg:resource src="./images/delete.png" realSrcVar="delPng"/>
</div>  
<epg:img id="search" rememberFocus="true" src="./images/dot.png" left="1050" top="47" width="80" height="38"
		 onfocus="buttonOnFocus('search','focusMenuTop_1');" onblur="buttonOnFocus('search','dot');"
		 href="${context['EPG_SEARCH_URL']}"/>  

<!--<epg:img id="buyRecords" left="50" top="90" width="391" height="45" href="${context['EPG_SELF_URL']}" src="./images/dot.gif"
		 onfocus="buttonOnFocus('buyRecords','buyRecordOnfocus');" onblur="buttonOnBlur('buyRecords','dot');"/>-->
<epg:img id="history" left="50" top="90" width="391" height="45" href="${context['EPG_HISTORY_URL']}" src="./images/dot.gif"
		 onfocus="buttonOnFocus('history','historyOnfocus');" onblur="buttonOnBlur('history','dot');"/>
<epg:img id="collect" left="443" top="90" width="391" height="45" href="${context['EPG_MYCOLLECTION_URL']}" src="./images/dot.gif"
		 onfocus="buttonOnFocus('collect','collectOnfocus');" onblur="buttonOnBlur('collect','dot');"/>
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

<epg:img id="home" rememberFocus="true" src="./images/dot.png" left="1150" top="47"width="80" height="38"
	     onfocus="buttonOnFocus('home','focusMenuTop_3');" onblur="buttonOnFocus('home','dot');"
	     href="#" onclick="back()"/>
<!-- collects -->
<epg:grid left="50" top="188" width="1180" height="441" row="2" column="8" items="${collects}" var="collect"
 		  indexVar="idx" posVar="pos" hcellspacing="20" vcellspacing="51">
 	
	<epg:navUrl obj="${collect}" indexUrlVar="indexUrl" delectCollectionUrlVar="delectCollectUrl"/>
	<div id="delete${idx}" style="left:${pos[idx-1].x}px;top:${pos[idx-1].y+200}px;width:130px;height:32px;position:absolute;visibility:hidden;">
		<a id="delete${idx}_a"  href="${delectCollectUrl}&bizCode=${context['EPG_BUSINESS_CODE']}" onfocus="deleteOnFocus('delete${idx}','${idx}');" onblur="deleteOnBlur('delete${idx}','${idx}');">
		<img id="delete${idx}_img" src="${delPng}" width="130" height="32"/></a>
	</div>
	<div id="orangeBg${idx}" style="position:absolute;left:${pos[idx-1].x-3}px;top:${pos[idx-1].y-3}px;width:136px;height:201px;background-color:#f79922;visibility:hidden;"></div>
	<epg:img id="collect${idx}" rememberFocus="true" src="../${collect.still}"
			left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="130" height="195" href="${indexUrl}&returnTo=biz"
				onfocus="itemsOnFocus('focus${idx}','focusFrame',${idx});"
				onblur="itemsOnBlur('focus${idx}','dot',${idx});" />
	<epg:choose>
		<epg:when test="${fn:indexOf(collect.contentName, 'HD_') != -1}">
			<epg:set value="${fn:substring(collect.contentName,3,10)}" var="contentName"/>
		</epg:when>
		<epg:otherwise>
			<epg:set value="${collect.contentName}" var="contentName"/>
		</epg:otherwise>
	</epg:choose>
	<epg:choose>
		<epg:when test="${fn:length(contentName)>5}">
			<epg:set value="${pos[idx-1].y+143}" var="textTop"/>
			<epg:set value="${pos[idx-1].y+140}" var="bgTop"/>
			<epg:set value="55" var="bgHeight"/>
		</epg:when>
		<epg:otherwise>
			<epg:set value="${pos[idx-1].y+158}" var="textTop"/>
			<epg:set value="${pos[idx-1].y+140}" var="bgTop"/>
			<epg:set value="55" var="bgHeight"/>
		</epg:otherwise>
	</epg:choose>
	<div id="shadow${idx}" style="left:${pos[idx-1].x}px;top:${bgTop}px;width:130px;height:${bgHeight}px;position:absolute;background-color:#000000;opacity:0.8;visibility:hidden;"></div>
	<div id="contentName${idx}" align="center" style="left:${pos[idx-1].x}px;top:${textTop}px;width:130px;height:26px;line-height:25px;visibility:hidden;vertical-align:center;">
		<font style="color:#ffffff">${fn:substring(contentName,0,10)}</font>
	</div>
</epg:grid>

<!-- pageTurn / pageNum  -->
<epg:img id="pre" src="./images/dot.gif" left="50" top="146" width="130" height="32"
		 href="#" onclick="pageUp()" pageop="up" keyop="pageup"
		 onfocus="buttonOnFocus('pre','prePage_focus');" onblur="buttonOnFocus('pre','dot');"/>
<epg:img id="next" src="./images/dot.gif" left="200" top="146" width="130" height="32"
		 href="#" onclick="pageDown()" pageop="down" keyop="pagedown"
		 onfocus="buttonOnFocus('next','nextPage_focus');" onblur="buttonOnFocus('next','dot');"/>

<div align="right" style="left:355px;top:150px;width:35px;height:19px;position:absolute;">
	<span id="pageIndex" style="font-family:'黑体';font-size:22px;color:#1a9ede">${pageBean.pageIndex}</span>
</div>
<div align="left" style="left:390px;top:150px;width:80px;height:19px;position:absolute;">
	<span id="pageTotal" style="font-family:'黑体';font-size:22px;color:#646464;">/${pageBean.pageCount}页</span>
</div>

</epg:body>
</epg:html>