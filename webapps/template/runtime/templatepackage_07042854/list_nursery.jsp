<%@page contentType="text/html; charset=gbk" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@ page language="java" import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*" %>
<% 
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setDateHeader("Expires", 0); 
%>
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
<%-- 科目菜单 --%>
<epg:query queryName="getSeverialItems" maxRows="6" var="menuCatItems" >
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 获取内容图片  -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="14" var="contentResults" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true" >
	   <epg:param name="categoryCode" value="${templateParams['contentCategoryCode']}" type="java.lang.String"/>
</epg:query>
<epg:navUrl returnTo="biz" returnUrlVar="returnUrl"/>
<epg:navUrl returnTo="home" returnUrlVar="returnHomeUrl"/>
<meta http-equiv="Content-Type" content="textml; charset=GBK" />
<style>
	body{ color:#000000;font-size:23px;}
</style>

<style type="text/css">
	
	form{
		margin:0px;
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
var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images/";

function init(){
	//document.getElementById("focus_0_a").focus();
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""&&document.getElementById(leaveFocusId+"_a")){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		document.getElementById("focus_0F_a").focus();
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
		document.getElementById(objId+"_img").src=imgPath+img+".png";
	}
}
//失去焦点事件
function itemOnBlur(objId){
	if (pageLoad) {
		fristFocus++;
		document.getElementById(objId+"_img").src=imgPath+"dot.gif";
	}
}
 function back(){
 	document.location.href = "${returnUrl}";
 }
 function exit(){
 	document.location.href = "${returnHomeUrl}";
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
<epg:body onload="init();"  defaultBg="./images/chinese.jpg" background="../${templateParams['bgImg']}"  style="background-repeat:no-repeat;" width="1280" height="720" bgcolor="#000000">
<!--菜单-->
<form id="pageform"  method="get" name="pageform" action="${pageBean.urlBase}" >
<!-- 返回课程表 -->
<div   style="position:absolute; top:14px; left:1120px; width:95px; height:79px;" >	
  	<epg:img id="backToNursery"  src="./images/dot.gif" href="${returnUrl}" width="95" height="79" onfocus="itemOnFocus('backToNursery','backToNursery');" onblur="itemOnBlur('backToNursery');"/>	
</div>
	
<div  id="menu" style="position:absolute; top:125px; left:140px; width:1000px; height:42px; " >
	<div   style="position:absolute; top:0px; left:0px; width:147px; height:42px;" >
	<epg:if test="${menuCatItems[0]!=null}">	
		<epg:navUrl obj="${menuCatItems[0]}" indexUrlVar="indexUrl"/>
		<epg:img id="menu0" src="./images/dot.gif"  href="${indexUrl}" rememberFocus="true" width="147" height="42" onfocus="itemOnFocus('menu0','nurseryMenuFocus');" onblur="itemOnBlur('menu0');" />
	</epg:if>
	</div>
	<div   style="position:absolute; top:0px; left:164px; width:147px; height:42px;" >
	<epg:if test="${menuCatItems[1]!=null}">	
		<epg:navUrl obj="${menuCatItems[1]}" indexUrlVar="indexUrl"/>
		<epg:img id="menu1"  src="./images/dot.gif"  href="${indexUrl}" rememberFocus="true" width="147" height="42" onfocus="itemOnFocus('menu1','nurseryMenuFocus');" onblur="itemOnBlur('menu1');"/>
	</epg:if>
	</div>
	<div   style="position:absolute; top:0px; left:339px; width:147px; height:42px;" >
	<epg:if test="${menuCatItems[2]!=null}">	
		<epg:navUrl obj="${menuCatItems[2]}" indexUrlVar="indexUrl"/>
		<epg:img id="menu2"  src="./images/dot.gif"  href="${indexUrl}" rememberFocus="true" width="147" height="42" onfocus="itemOnFocus('menu2','nurseryMenuFocus');" onblur="itemOnBlur('menu2');" />
	</epg:if>
	</div>
	<div   style="position:absolute; top:0px; left:513px; width:147px; height:42px;" >
	<epg:if test="${menuCatItems[3]!=null}">	
		<epg:navUrl obj="${menuCatItems[3]}" indexUrlVar="indexUrl"/>
		<epg:img id="menu3" src="./images/dot.gif"  href="${indexUrl}" rememberFocus="true" width="147" height="42" onfocus="itemOnFocus('menu3','nurseryMenuFocus');" onblur="itemOnBlur('menu3');"/>
	</epg:if>
	</div>
	<div   style="position:absolute; top:0px; left:688px; width:147px; height:42px;" >
	<epg:if test="${menuCatItems[4]!=null}">	
		<epg:navUrl obj="${menuCatItems[4]}" indexUrlVar="indexUrl"/>
		<epg:img id="menu4" src="./images/dot.gif"  href="${indexUrl}" rememberFocus="true" width="147" height="42" onfocus="itemOnFocus('menu4','nurseryMenuFocus');" onblur="itemOnBlur('menu4');"/>
	</epg:if>
	</div>
	<div   style="position:absolute; top:0px; left:852px; width:147px; height:42px;" >
	<epg:if test="${menuCatItems[5]!=null}">	
		<epg:navUrl obj="${menuCatItems[5]}" indexUrlVar="indexUrl"/>
		<epg:img id="menu5" src="./images/dot.gif"  href="${indexUrl}" rememberFocus="true" width="147" height="42" onfocus="itemOnFocus('menu5','nurseryMenuFocus');" onblur="itemOnBlur('menu5');"/>
	</epg:if>
	</div>
 </div>
<div  id="page_control" style="position:absolute; top:177px; left:0px; width:1200px; height:50px; " >
	<div  style="position:absolute; top:0px; left:133px; width:103px; height:50px;" >
	 	<epg:img src="./images/dot.gif" width="103" height="50" id="pageUp"/>
		<epg:img src="./images/dot.gif" width="103" height="30" id="pageUpF" 
	 		href="#" onclick="pageUp()" onfocus="itemOnFocus('pageUp','pageFocus');" onblur="itemOnBlur('pageUp');"/>
	</div>
	<div  style="position:absolute; top:0px; left:245px; width:103px; height:50px;" >
		<epg:img src="./images/dot.gif" width="103" height="50" id="pageDown"/>
		<epg:img src="./images/dot.gif" width="103" height="30" id="pageDownF" 
			href="#" onclick="pageDown()" onfocus="itemOnFocus('pageDown','pageFocus');" onblur="itemOnBlur('pageDown');"/>
	</div>
	<div id="p_p"   style="position:absolute; top:11px; left:377px; width:93px; height:35px;" >
	<font color="#0c5899" style="font-size: 26px;font-weight: bold;">${pageBean.pageIndex}/${pageBean.pageCount}页</font>
	</div>	
</div> 
 <!-- 内容部分 -->
 <epg:grid column="7" left="93" top="228" width="1013" vcellspacing="0" hcellspacing="110" height="423" row="2" 
		posVar="positions" items="${contentResults}" var="rightCategoryItem" indexVar="curIdx" >
		<epg:navUrl obj="${rightCategoryItem}" indexUrlVar="indexUrl"/>
		<epg:img id="start_${curIdx-1}" style="border:1px solid #63391d;" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="130" height="195"  src="../${rightCategoryItem.poster}" />
		<epg:img id="focus_${curIdx-1}"src="./images/dot.gif"
			left="${positions[curIdx-1].x-11}" top="${positions[curIdx-1].y-10}" width="155" height="219"/>
		<epg:img id="focus_${curIdx-1}F" src="./images/dot.gif"  href="${indexUrl}" rememberFocus="true" 
			left="${positions[curIdx-1].x-11}" top="${positions[curIdx-1].y-10}" width="155" height="119"  
			onfocus="itemOnFocus('focus_${curIdx-1}','nurseryContent');" onblur="itemOnBlur('focus_${curIdx-1}');" />
</epg:grid>
  </form>
</epg:body>
</epg:html>