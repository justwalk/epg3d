<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page language="java" import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*" %>
<epg:html>
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
<!-- 首页顶部菜单分类  -->
<epg:query queryName="getSeverialItems" maxRows="5" var="menuCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 二级菜单  -->
<epg:query queryName="getSeverialItems" maxRows="5" var="secondCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['secondCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 内容部分 -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="20" var="contentCategoryItems" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true"  >
	<epg:param name="categoryCode" value="${templateParams['contentCategoryCode']}" type="java.lang.String"  />
</epg:query>
<!-- 右上推荐 图片-->
<epg:query queryName="getSeverialItems" maxRows="1" var="rightUpCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['rightUpCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 右下推荐 图片-->
<epg:query queryName="getSeverialItems" maxRows="1" var="rightDownCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['rightDownCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!--最下跑马灯 -->
<epg:query queryName="getSeverialItems" maxRows="10" var="hotDownResults" >
	<epg:param name="categoryCode" value="${templateParams['hotDownCategoryCode']}" type="java.lang.String"/>
</epg:query>
<epg:navUrl returnTo="home" returnUrlVar="returnToHomeUrl"></epg:navUrl>
<epg:navUrl returnTo="biz" returnUrlVar="returnUrl"></epg:navUrl>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>

<style type="text/css">
	body{
		color:#ffffff;
		font-size:22px;
		font-family:黑体;	
	}
	a{outline:none;}
	img{border:0px solid black;}
</style>
<script>
var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images";
var pageLoad = false;
var fristFocus = 0;
if (typeof(iPanel) == 'undefined') {
	pageLoad  = true;
}
//获得失去焦点
function menuOnFocus(objId,img){
	if (pageLoad) {
		fristFocus++;
		document.getElementById(objId + "_img").src = imgPath + "/" + img + ".png";
	}
}

 function formSubmit(){   
     document.actionForm.submit();   
 }
 
 function firstFocus(){
	if("${rightUpCategoryItems.itemType}"=='channel'){
		//media.video.setPosition(856,166,363,205);
		//var serviceOBJ = DVB.services;
		//DVB.playAV(3790000,2301);
	}
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""&&document.getElementById(leaveFocusId+"_a")){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		document.getElementById("categoryList1_a").focus();
	}
}
 function back(){
 	document.location.href = "${returnToHomeUrl}";
 }
 function exit(){
 	document.location.href = "${returnToHomeUrl}";
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
 	document.location.href = previousUrl+"&leaveFocusId=area_upPage"+myPageIndex;
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
 	document.location.href = nextUrl+"&leaveFocusId=area_downPage"+myPageIndex;
 }
if("${rightUpCategoryItems.itemType}"=='channel'){
	var mediaPlayer = new MediaPlayer();
	var mediaID;
	mediaID = mediaPlayer.createPlayerInstance("video",2);
	mediaPlayer.bindPlayerInstance(mediaID);
	mediaPlayer.position="0,857,136,363,205";   //全屏  857 165
	mediaPlayer.source="delivery://371000.6875.64-QAM.1342.258.514";
	mediaPlayer.play();
	mediaPlayer.refresh();
}
function closeVideo() {
	if("${rightUpCategoryItems.itemType}"=='channel'){
		mediaPlayer.releasePlayerInstance();  //释放播放  销毁播放器
		mediaPlayer.unBindPlayerInstance();//解除绑定
	}
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
	    	break;
	    case "SITV_KEY_PAGEDOWN":
	    	pageDown();
	    	break;
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
			window.location.href = "${context['EPG_CONTEXT']}/common/logout/logout.jsp";
			return 0;
			break;
		default:
			return 1;
			break;
	}
}
</script>

<epg:body  onload="firstFocus()" onunload="closeVideo()"  background="../${templateParams['bgImg']}"  bgcolor='transparent'  width="1280" height="720" >
<form name="actionForm" method="get" action="${pageBean.urlBase}" style=" padding:0px;margin:0px;">
<!-- 导航 -->
<epg:grid column="5" row="1" left="362" top="75" width="700" height="36" hcellspacing="20" items="${menuCategoryItems}" var="middleMenuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${middleMenuCategoryItem}" indexUrlVar="indexUrl"/>
			<epg:img id="middleMenu${curIdx}" rememberFocus="true" 
			onfocus="menuOnFocus('middleMenu${curIdx}','NBAfocus1');"  onblur="menuOnFocus('middleMenu${curIdx}','dot');" 
			src="./images/dot.png" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="113" height="36" href="${indexUrl}"/>
</epg:grid>
<!-- 退出-->
<epg:img src="./images/dot.png" id="home"  left="1105" top="75" width="113" height="36" href="${returnUrl}" onfocus="menuOnFocus('home','NBAfocus1');"  onblur="menuOnFocus('home','dot');"/>

<!-- 二级导航 -->
<epg:grid column="5" row="1" left="158" top="130" width="579" height="36" hcellspacing="10" items="${secondCategoryItems}" var="secondCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${secondCategoryItem}" indexUrlVar="indexUrl"/>
			<epg:img id="secondMenu${curIdx}" rememberFocus="true" 
			onfocus="menuOnFocus('secondMenu${curIdx}','NBAfocus1');"  onblur="menuOnFocus('secondMenu${curIdx}','dot');" 
			src="./images/dot.png" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="113" height="36" href="${indexUrl}"/>
</epg:grid>

<!-- 上下页，输入，确定 -->
<epg:img src="./images/dot.png" id="area_upPage"  left="79" top="172" onfocus="menuOnFocus('area_upPage','NBAFocusPage')" onblur="menuOnFocus('area_upPage','dot')" pageop="up" keyop="pageup"  width="88" height="30" href="javascript:pageUp();"/>
<epg:img src="./images/dot.png" id="area_downPage"  left="182" top="172" onfocus="menuOnFocus('area_downPage','NBAFocusPage')" onblur="menuOnFocus('area_downPage','dot')" pageop="down" keyop="pagedown"  width="88" height="30" href="javascript:pageDown();"/>
<!-- 输入框 -->	
<div style="position:absolute; top:175px;left:350px; width:45px; height:22px; font-size:22px; " >
	<span style="color:#ffffff;font-size:22px;font-family:">到第</span>
</div>
<epg:img src="./images/dot.png" id="NBAfocusBox" left="394" top="172"  width="48" height="30" />
<div style="position:absolute;top:175px; left:397px; width:42px; height:24px; font-size:22px; color:#1978b8" >
<input type="text" id="goPageIndex" maxlength="2" onfocus="menuOnFocus('NBAfocusBox','NBAfocusBox')" onblur="menuOnFocus('NBAfocusBox','dot')" name="pageIndex" style="color:#000000;text-align:center;font-size:20px;width:42px; height:24px;line-height:24px;"/>
</div>
<div style="position:absolute; top:175px;left:442px; width:45px; height:22px; font-size:22px; " >
	<span style="color:#ffffff;font-size:22px;font-family:">页</span>
</div>
<!-- 确认按钮 -->
<epg:img id="button"  href="javascript:formSubmit()" left="489" top="172"  width="64" height="30" onfocus="menuOnFocus('button','NBAfocusFix')" onblur="menuOnFocus('button','dot')"   src="./images/dot.png" />
<epg:input type="hidden" name="protocolType" value="${param.protocolType}"/>
<epg:input type="hidden" name="rtsp_d" value="${param.rtsp_d}"/>
<epg:input type="hidden" name="stbType" value="${param.stbType}"/>
<epg:input type="hidden" name="gotoFlag" value="true"/>
<epg:input type="hidden" name="trailer" value="${param.trailer}"/>
<epg:input type="hidden" name="vmType" value="${param.vmType}"/>
<epg:input type="hidden" name="entry" value="${param.entry}"/>
<epg:if test="${param.leaveFocusId!=null}">
	<epg:input type="hidden" name="leaveFocusId" value="${param.leaveFocusId}"/>
</epg:if>
<div style="position:absolute; top:175px;left:295px; width:79px; height:22px; font-size:22px; " >
	<span id="pageIndex" style="color:#ffffff">${pageBean.pageIndex}/${pageBean.pageCount}</span>
</div>
<!-- 内容部分 -->
<epg:grid column="2" row="10" left="70" top="207" height="446" width="763" posVar="pos" indexVar="idx"  hcellspacing="10" items="${contentCategoryItems}" var="contentCategoryItem" >
	<epg:navUrl obj="${contentCategoryItem}" indexUrlVar="indexUrl"></epg:navUrl>
	<epg:choose>
		<epg:when test="${idx == 1}">
		    <epg:set var="isDefaultfocus" value="true"/>
		</epg:when>
	    <epg:otherwise>
		    <epg:set var="isDefaultfocus" value="false"/>
		</epg:otherwise>
	</epg:choose>
	<epg:img id="categoryList${idx}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="373" height="40" defaultfocus="${isDefaultfocus}"  rememberFocus="true" src="./images/dot.gif" 
	 href="${indexUrl}"  onfocus="menuOnFocus('categoryList${idx}','NBAfocus3')" onblur="menuOnFocus('categoryList${idx}','dot')"/>
	<epg:text id="categoryList${idx}" left="${pos[idx-1].x+10}" top="${pos[idx-1].y+7}" align="left"  width="388" height="26" color="#ffffff" chineseCharNumber="16" fontSize="22" dotdotdot="…">
	${contentCategoryItems[idx-1].title}</epg:text>
</epg:grid>
<!-- 右上图片 -->
<epg:if test="${rightUpCategoryItems!=null}">
	<epg:if test="${rightUpCategoryItems.itemType=='channel'}">
		<epg:navUrl obj="${rightUpCategoryItems}" playUrlVar="indexUrl"/>
		<epg:img  src="./images/dot.png" left="856"  top="133" width="363" height="205" href="${indexUrl}"/>
	</epg:if>
	<epg:if test="${rightUpCategoryItems.itemType!='channel'}">
		<epg:navUrl obj="${rightUpCategoryItems}" indexUrlVar="indexUrl"/>
		<epg:img  src="../${rightUpCategoryItems.itemIcon}" left="856"  top="133" width="363" height="205"/>
	</epg:if>
</epg:if>

<!-- 右下图片 -->
<epg:if test="${rightDownCategoryItems!=null}">
		<epg:navUrl obj="${rightDownCategoryItems}" indexUrlVar="indexUrl"/>
		<epg:img  src="../${rightDownCategoryItems.itemIcon}" left="856"  top="338" width="363" height="311"/>
</epg:if>
</form>	
<%@include file="NBAMarquen.jsp"%>
</epg:body>
</epg:html>