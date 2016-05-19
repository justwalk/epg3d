<%@page contentType="text/html; charset=gbk" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@ page language="java" import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*" %>
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
<!-- 首页菜单分类  -->
<epg:query queryName="getSeverialItems" maxRows="4" var="homeCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['homeCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 菜单分类  -->
<epg:query queryName="getSeverialItems" maxRows="5" var="menuCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 当前栏目分类  -->
<epg:query queryName="getSeverialItems" maxRows="9" var="currentCategoryItems" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true">
	<epg:param name="categoryCode" value="${templateParams['currentCategoryCode']}" type="java.lang.String"/>
</epg:query>
<epg:navUrl returnTo="home" returnUrlVar="homeUrl"></epg:navUrl>
<epg:navUrl returnTo="biz" returnUrlVar="returnUrl"></epg:navUrl>
<title>体育</title>
<style>
	a{
	outline:none;
}
</style>
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
		document.getElementById("menu0_a").focus();
	}
}
function getfocus(objId){
	if(pageLoad){
		fristFocus++;
		//var id = objId.substring(0,objId.indexOf("_"));
		document.getElementById(objId+"_img_img").style.visibility="visible";
	}
}
function outfocus(objId){
	if(pageLoad){
		//var id = objId.substring(0,objId.indexOf("_"));
		document.getElementById(objId+"_img_img").style.visibility="hidden";
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
 	document.location.href = previousUrl+"&leaveFocusId=area_upPage"+myPageIndex;
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
 	document.location.href = nextUrl+"&leaveFocusId=area_downPage"+myPageIndex;
 }
 
//监听事件
function eventHandler(eventObj)
{
	switch(eventObj.code)
	{
		case "SYSTEM_EVENT_ONLOAD":
		pageLoad = true;
		break;
		case "EIS_IRKEY_BACK":
		window.location.href="${homeUrl}";
		return 0;
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
	    	window.location.href = "${returnUrl}";
			return 0;
	    	break;
		case "SITV_KEY_EXIT":
			window.location.href = "${homeUrl}";
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
<epg:body onload="init()" defaultBg="./images/list_sports_game.jpg"  background="../${templateParams['bgImg']}" style="background-repeat:no-repeat;" bgcolor="#000000" width="1280" height="720" >
	
<!-- 顶部菜单  -->
<epg:if test="${homeCategoryItems[templateParams['numCategoryCode']] !=null}">
	<epg:navUrl obj="${homeCategoryItems[templateParams['numCategoryCode']]}" indexUrlVar="indexUrl"/>
<epg:img id="menu0"  src="./images/dot.gif" 
	 onfocus="getfocus('menu0');" onblur="outfocus('menu0');"
	 rememberFocus="true"
		left="87" top="156" width="170" height="52" href="${indexUrl}"/>
<epg:img id="menu0_img"  src="./images/dot.gif" 
	style="visibility:hidden;border:3px solid #ff9c13" 
		left="87" top="156" width="170" height="52"/>
</epg:if>
<epg:if test="${menuCategoryItems[1] !=null}">
	<epg:navUrl obj="${menuCategoryItems[1]}" indexUrlVar="indexUrl"/>
	<epg:img id="menu1"  src="./images/dot.gif" 
		rememberFocus="true"
		 onfocus="getfocus('menu1');" onblur="outfocus('menu1');"
		left="87" top="252" width="170" height="52" href="${indexUrl}"/>
	<epg:img id="menu1_img"  src="./images/dot.gif" 
	style="visibility:hidden;border:3px solid #ff9c13" 
		left="87" top="252" width="170" height="52"/>
</epg:if>
<epg:if test="${menuCategoryItems[0] !=null}">
	<epg:navUrl obj="${menuCategoryItems[0]}" indexUrlVar="indexUrl"/>
	<epg:img id="menu2"  src="./images/dot.gif" 
	 onfocus="getfocus('menu2');" onblur="outfocus('menu2');" rememberFocus="true"
		left="87" top="348" width="170" height="52" href="${indexUrl}"/>
	<epg:img id="menu2_img"  src="./images/dot.gif" 
	style="visibility:hidden;border:3px solid #ff9c13" 
		left="87" top="348" width="170" height="52"/>
</epg:if>
<epg:if test="${menuCategoryItems[4] !=null}">
	<epg:navUrl obj="${menuCategoryItems[4]}" indexUrlVar="indexUrl"/>
	<epg:img id="menu3"  src="./images/dot.gif" 
	 onfocus="getfocus('menu3');" onblur="outfocus('menu3');" rememberFocus="true"
		left="87" top="444" width="170" height="52" href="${indexUrl}"/>
	<epg:img id="menu3_img"  src="./images/dot.gif" 
	style="visibility:hidden;border:3px solid #ff9c13" 
		left="87" top="444" width="170" height="52"/>
</epg:if>

<!-- 内容  -->
<epg:grid column="1" left="357" top="222" width="635" height="440" row="9" posVar="positions" hcellspacing="0" items="${currentCategoryItems}" var="current" indexVar="curIdx" >
	<epg:text id="current${curIdx}_text" align="left" left="${positions[curIdx-1].x+20}" top="${positions[curIdx-1].y-4}" width="534" height="44" fontSize="24" 
		chineseCharNumber="21"  dotdotdot="…"  color="#ffffff">${current.title}</epg:text>
	<epg:navUrl obj="${current}" indexUrlVar="indexUrl" />
	<epg:img  id="current${curIdx}_img" style="visibility:hidden;border:3px solid #ff9c13"  left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-14}" width="635" height="40"  src="./images/dot.gif" />
	<epg:img  id="current${curIdx}"  onfocus="getfocus('current${curIdx}');" onblur="outfocus('current${curIdx}');" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-14}" rememberFocus="true"  href="${indexUrl}"  width="635" height="40"  src="./images/dot.gif" />
</epg:grid>

<!-- 上下页 -->
<epg:img id="area_upPage"  onfocus="getfocus('area_upPage');" onblur="outfocus('area_upPage');" src="./images/dot.gif" left="465" top="167" width="98" height="34"  href="#" onclick="pageUp()"/>
<epg:img id="area_upPage_img" style="visibility:hidden;border:3px solid #ff9c13" src="./images/dot.gif" left="465" top="167" width="98" height="34"/>
<epg:img  id="area_downPage" onfocus="getfocus('area_downPage');" onblur="outfocus('area_downPage');"  src="./images/dot.gif" left="580" top="167" width="98" height="34" href="#" onclick="pageDown()"/>
<epg:img  id="area_downPage_img" style="visibility:hidden;border:3px solid #ff9c13" src="./images/dot.gif" left="580" top="167" width="98" height="34"/>

<epg:text  left="703" top="173" fontSize="24" width="100" color="#ffffff">${pageBean.pageIndex}/${pageBean.pageCount}</epg:text>

</epg:body>
</epg:html>