<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
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
<!-- 查询NBA导航 -->
<epg:query queryName="getSeverialItems" maxRows="5" var="menuCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!--查询咨询下所有栏目 -->
<epg:query queryName="getSeverialItems" maxRows="3" var="infomationItems" >
	<epg:param name="categoryCode" value="${templateParams['infomationCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 查询咨询下专题的前18条数据 -->
<epg:query queryName="getSeverialItems" maxRows="18" var="subjectItems" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true">
	<epg:param name="categoryCode" value="${infomationItems[2].itemCode}" type="java.lang.String"/>
</epg:query>

<epg:navUrl returnTo="home" returnUrlVar="returnToHomeUrl"></epg:navUrl>
<epg:navUrl returnTo="biz" returnUrlVar="returnUrl"></epg:navUrl>
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
var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images";
var pageLoad = false;
function $(id){
	return document.getElementById(id);
}

var isRightFocus = false;
var isLeftFocus = false;
var varReghtCode = "";
var varLeftCode = "";
var fristFocus = 0;
if (typeof(iPanel) == 'undefined') {
	pageLoad  = true;
}
//获取焦点事件
function itemOnFocus(objId,img,idx){
	if (pageLoad) {
		fristFocus++;
		$(objId).src = imgPath + "/" + img;
		if (objId.indexOf('infomation') != -1) {
			if (idx == 1) {
				var nextId = idx + 1;
				isRightFocus = true;
				varReghtCode = "infomation" + nextId + "_a";
			}
			else 
				if (idx == 2) {
					var nextId = idx + 1;
					var upId = idx - 1;
					isRightFocus = true;
					varReghtCode = "infomation" + nextId + "_a";
					isLeftFocus = true;
					varLeftCode = "infomation" + upId + "_a";
				}
				else 
					if (idx == 3) {
						var upId = idx - 1;
						isLeftFocus = true;
						varLeftCode = "infomation" + upId + "_a";
					}
					else {
						isRightFocus = false;
						isLeftFocus = false;
						varReghtCode = "";
						varLeftCode = "";
					}
		}
	}
}
//失去焦点事件
function itemOnBlur(objId,img){
	if (pageLoad) {
		$(objId).src = imgPath + "/" + img;
		isRightFocus = false;
		isLeftFocus = false;
		varReghtCode = "";
		varLeftCode = "";
	}
}
 function back(){
 	document.location.href = "${returnToHomeUrl}";
 }
 function exit(){
 	document.location.href = "${returnToHomeUrl}";
 }
 
 function myInit()
{		
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""&&document.getElementById(leaveFocusId+"_a")){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		document.getElementById("subject1_a").focus();
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


<epg:body onload="myInit();" bgcolor="#000000" >
<!-- 背景图片 -->
<epg:img defaultSrc="./images/infomationSubjectBgImg.jpg"  src="../${templateParams['bgImg']}" id="infomationBgImg"  left="0" top="0" width="1280" height="720"/>
<!-- 二级菜单选中图标 -->
<epg:img defaultSrc="./images/infomation3.png" src="" id="newsImg"  left="787" top="134" width="149" height="29"/>


<!-- 导航 -->
<epg:grid left="362" top="75" width="700" height="36" row="1" column="5" items="${menuCategoryItems}" var="menu" hcellspacing="20"
		   indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${menu}" indexUrlVar="indexUrl"/>
	<epg:img src="./images/dot.png" href="${indexUrl}"  id="menu${curIdx}" rememberFocus="true" 
	         left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="113" height="36"
			 onfocus="itemOnFocus('menu${curIdx}_img','NBAfocus1.png');" onblur="itemOnFocus('menu${curIdx}_img','dot.gif');"/>
</epg:grid>

<!-- 退出-->
<epg:img src="./images/dot.png"  href="${returnUrl}" id="home" left="1105" top="75" width="113" height="36" 
		 onfocus="itemOnFocus('home_img','NBAfocus1.png');"  onblur="itemOnFocus('home_img','dot.gif');"/>

<!-- 新闻，排行，专题 -->
<epg:grid column="3" row="1" left="347" top="134" height="29" width="589" hcellspacing="71" items="${infomationItems}" var="infomationItem" posVar="pos" indexVar="idx" >
	<epg:navUrl obj="${infomationItem}" indexUrlVar="indexUrl"/>
	<epg:img src="./images/dot.gif"  href="${indexUrl}"  id="infomation${idx}" rememberFocus="true" 
	         left="${pos[idx-1].x}" top="130" width="113" height="36"
	         onfocus="itemOnFocus('infomation${idx}_img','infomationFocus.png',${idx});" onblur="itemOnBlur('infomation${idx}_img','dot.gif');"/>
</epg:grid>

<!-- 上,下页 -->
<epg:img src="./images/infomationUpPage.png" left="80" top="178" width="83" height="24"/>
<epg:img src="./images/dot.gif" id="area_upPage"  left="79" top="176" width="85" height="29"  
         onfocus="itemOnFocus('area_upPage_img','NBAFocusPage.png');" onblur="itemOnBlur('area_upPage_img','dot.gif');"  pageop="up" keyop="pageup" href="javascript:pageUp();"/>
<epg:img src="./images/infomationDownPage.png" left="180" top="178" width="83" height="24"/>
<epg:img src="./images/dot.gif" id="area_downPage" left="179" top="176" width="85" height="29" 
         onfocus="itemOnFocus('area_downPage_img','NBAFocusPage.png');" onblur="itemOnBlur('area_downPage_img','dot.gif');" pageop="down" keyop="pagedown" href="javascript:pageDown();"/>
<div style="position:absolute; top:182px; left:280px; width:76px; height:32px;  " >
	<span id="pageIndex" style="color:#ffffff;font-size:18px; font-family: 黑体;">${pageBean.pageIndex}</span><span id="pageCount" style="color:#ffffff;font-size:18px;font-family: 黑体;">/${pageBean.pageCount}</span>
</div>

<!-- 内容部分 -->
<epg:grid column="3" row="10" left="60" top="190" height="680" width="1150" posVar="pos" indexVar="idx" vcellspacing="10" cellpadding="20" items="${subjectItems}" var="subjectItem" >
	<epg:navUrl obj="${subjectItem}" indexUrlVar="indexUrl"></epg:navUrl>
	<epg:choose>
		<epg:when test="${idx == 1}">
		    <epg:set var="isDefaultfocus" value="true"/>
		</epg:when>
	    <epg:otherwise>
		    <epg:set var="isDefaultfocus" value="false"/>
		</epg:otherwise>
	</epg:choose>
	<epg:img src="../${subjectItem.itemIcon}" left="${pos[idx-1].x}"  top="${pos[idx-1].y}" width="363" height="59"/>
	<epg:img src="./images/dot.gif" href="${indexUrl}" id="subject${idx}" rememberFocus="true"
	         left="${pos[idx-1].x}"  top="${pos[idx-1].y}" width="365" height="60" defaultfocus="${isDefaultfocus}" 
			 onfocus="itemOnFocus('subject${idx}_img','infomationSubjectFocus.png');" onblur="itemOnBlur('subject${idx}_img','dot.gif');"/>
</epg:grid>

<!-- 跑马灯 -->
<%@include file="NBAMarquen.jsp"%>
</epg:body>
</epg:html>