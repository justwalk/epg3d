<%@page contentType="text/html; charset=GBK" pageEncoding="UTF-8"%>
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
<!-- 获取菜单结果 -->
<epg:query queryName="getSeverialItems" maxRows="5" var="menuResults" >
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 获取返回首页结果 -->
<epg:query queryName="getSeverialItems" maxRows="1" var="returnindexResults" >
	<epg:param name="categoryCode" value="${templateParams['returnindexCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 获取栏目图片  -->
<!--<epg:query queryName="getSeverialItems" maxRows="6" var="category" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true" >
	<epg:param name="categoryCode" value="${templateParams['categoryCode']}" type="java.lang.String"/>
</epg:query>-->
<!-- 获取栏目图片  -->
<epg:query queryName="getSeverialItemsWithSubjectPic" maxRows="6" var="category" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true" >
	<epg:param name="categoryCode" value="${templateParams['categoryCode']}" type="java.lang.String"/>
</epg:query>

<epg:navUrl returnTo="home" returnUrlVar="returnHome"></epg:navUrl>
<epg:navUrl obj="${returnindexResults}" indexUrlVar="returnindexResults"/>
<meta http-equiv="Content-Type" content="textml; charset=GBK" />
<head>
<style>
a{
	text-decoration:none;
	display:block;
	color:#093d61;
}
body{
 font-size:24px; 
 color:#093d61;
 margin:0;
 padding:0;
 }
 a{display:block;outline:none}
</style>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script type="text/javascript">
var pageLoad = false;
var fristFocus = 0;
if (typeof(iPanel) == 'undefined') {
	pageLoad  = true;
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

function back(){
	document.location.href = "${returnindexResults}";
}
function exit(){
	document.location.href = "${returnHome}";
}

var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images/";

function init(){ 
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""&&document.getElementById(leaveFocusId+"_a")){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		if(document.getElementById("focus_0_a")){
			document.getElementById("focus_0_a").focus();
		}else{
			document.getElementById("rainbowIndex_a").focus();
		}
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
 	document.location.href = previousUrl+"&leaveFocusId=pageUpF"+myPageIndex;
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
 	document.location.href = nextUrl+"&leaveFocusId=pageDownF"+myPageIndex;
 }


//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名，isChangeColor 是否改变文字列表颜色
function itemOnFocus(objId,img){
	if (pageLoad) {
		fristFocus++;
		document.getElementById(objId+"_img").src=imgPath+img+".png";
	}
}
//失去焦点事件
function itemOnBlur(objId){
	if (pageLoad) {
		document.getElementById(objId+"_img").src=imgPath+"dot.gif";
	}
}

</script>
</head>

<epg:body onload="init();"  width="1280" height="720" background="../${templateParams['bgImg']}"  style="background-repeat:no-repeat;" defaultBg="./images/animationCastle2.jpg" bgcolor="#000000">
 <div id="main">
  <!--导航条start-->
   <div id="Navigation" style="position:absolute;width:530px;height:52px;left:323px;top:108px;"> 
	<div class="topSelected" style="position:absolute;left:3px;">
	<epg:if test="${menuResults[0] != null}">
	<epg:navUrl obj="${menuResults[0]}" indexUrlVar="indexUrl"/>
	<epg:img id="menu0" height="52" width="99" href="${indexUrl}"  src="./images/dot.gif" onfocus="itemOnFocus('menu0','cartoonCastleMenuFocus');" onblur="itemOnBlur('menu0');"/>
	</epg:if>
	</div>
	<div class="topSelected" style="position:absolute;left:114px;">
	<epg:if test="${menuResults[1] != null}">
	<epg:navUrl obj="${menuResults[1]}" indexUrlVar="indexUrl"/>
	<epg:img id="menu1" height="52" width="84" href="${indexUrl}"  src="./images/dot.gif" onfocus="itemOnFocus('menu1','cartoonCastleMenuFocus');" onblur="itemOnBlur('menu1');" />
	</epg:if>
	</div>
	<div class="topSelected" style="position:absolute;left:199px;">
	<epg:if test="${menuResults[2] != null}">
	<epg:navUrl obj="${menuResults[2]}" indexUrlVar="indexUrl"/>
	<epg:img id="menu2" height="52" width="81" href="${indexUrl}"  src="./images/dot.gif" onfocus="itemOnFocus('menu2','cartoonCastleMenuFocus');" onblur="itemOnBlur('menu2');"/>
	</epg:if>
	</div>
	<div class="topSelected" style="position:absolute;left:281px;">
	<epg:if test="${menuResults[3] != null}">
	<epg:navUrl obj="${menuResults[3]}" indexUrlVar="indexUrl"/>
	<epg:img id="menu3" height="52" width="85" href="${indexUrl}"  src="./images/dot.gif" onfocus="itemOnFocus('menu3','cartoonCastleMenuFocus');" onblur="itemOnBlur('menu3');"/>
	</epg:if>
	</div>
	<div class="topSelected" style="position:absolute;left:380px;">
	<epg:if test="${menuResults[4] != null}">
	<epg:navUrl obj="${menuResults[4]}" indexUrlVar="indexUrl"/>
	<epg:img id="menu4" height="52" width="99" href="${indexUrl}" src="./images/dot.gif" onfocus="itemOnFocus('menu4','cartoonCastleMenuFocus');" onblur="itemOnBlur('menu4');"/>
	</epg:if>
	</div>
  </div>
   <!--导航条end-->
    <!--返回首页-->
    <div style="position:absolute;left:1112px;top:104px; width:82px; height:48px">
	<epg:img id="rainbowIndex" src="./images/dot.gif" width="82" height="48" href="${returnindexResults}" onfocus="itemOnFocus('rainbowIndex','rainbowIndexFocus');" onblur="itemOnBlur('rainbowIndex');"/>
	</div>
   <!--上下页-->
    <div style="position:absolute; left:171px; top:175px;">
   		<epg:img id="pageUp" src="./images/dot.gif" width="91" height="43"/>
    	<epg:img id="pageUpF" src="./images/dot.gif" width="91" height="33" 
   			href="#" onclick="pageUp()" onfocus="itemOnFocus('pageUp','pageFocus');" onblur="itemOnBlur('pageUp');"/>
    </div>
	<div style="position:absolute; left:283px; top:175px;">
		<epg:img id="pageDown" src="./images/dot.gif" width="91" height="43"/>
		<epg:img id="pageDownF" src="./images/dot.gif" width="91" height="33" 
			href="#" onclick="pageDown()" onfocus="itemOnFocus('pageDown','pageFocus');" onblur="itemOnBlur('pageDown');"/>
	</div>
	<div style="position:absolute; left:417px; top:179px; width:108px; height:33px; line-height:33px;">
		<font color="#063787">${pageBean.pageIndex}/${pageBean.pageCount}页</font>
	</div>
 	<!-- 栏目图片 -->
   	<epg:grid column="3" row="2" left="154" top="250" width="910" height="325" hcellspacing="32" vcellspacing="20" items="${category}" var="categoryItem"  indexVar="rowStatus" posVar="positions">
	 	<epg:if test="${categoryItem!=null}">
	 		<epg:navUrl obj="${categoryItem}" indexUrlVar="indexUrl"/>
	 		<epg:choose>
	 			<epg:when test="${!empty categoryItem.icon}">
	 				<epg:img id="listUp${rowStatus-1}" left="${positions[rowStatus-1].x}" top="${positions[rowStatus-1].y}"  style="border:2px solid #d1821b;" 
						src="../${categoryItem.icon}"  width="280" height="140"/>
	 			</epg:when>
	 			<epg:otherwise>
	 				<epg:img id="listUp${rowStatus-1}" left="${positions[rowStatus-1].x}" top="${positions[rowStatus-1].y}"  style="border:2px solid #d1821b;" 
						src="../${categoryItem.itemIcon}"  width="280" height="140"/>
	 			</epg:otherwise>
	 		</epg:choose>
	 		<epg:img left="${positions[rowStatus-1].x+2}" top="${positions[rowStatus-1].y+112}" width="280" height="30"
				src="./images/album_shadow.png"/>
			<epg:text left="${positions[rowStatus-1].x+10}" top="${positions[rowStatus-1].y+110}" width="280" height="30" text="${categoryItem.title}"
				align="left" fontFamily="微软雅黑" fontSize="22" color="#ffffff" chineseCharNumber="12" dotdotdot="..."/>
			<epg:img id="focus_${rowStatus-1}" src="./images/dot.gif"  href="${indexUrl}&returnTo=bizcat" rememberFocus="true" left="${positions[rowStatus-1].x-14}" top="${positions[rowStatus-1].y-14}" width="313" height="172" 
				onfocus="itemOnFocus('focus_${rowStatus-1}','cartoonFocus');" onblur="itemOnBlur('focus_${rowStatus-1}');" />
		</epg:if>
    </epg:grid>
</div>
</epg:body>
</epg:html>