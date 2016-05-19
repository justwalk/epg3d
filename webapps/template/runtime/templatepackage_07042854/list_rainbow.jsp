<%@page contentType="text/html; charset=GBK" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@ page language="java" import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*" %>
<%
	String pageIndex = request.getParameter("pageIndex");
	request.setAttribute("formerPageIndex", pageIndex);
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
<!-- 获取返回首页结果 -->
<epg:query queryName="getSeverialItems" maxRows="1" var="returnindexResults" >
	<epg:param name="categoryCode" value="${templateParams['returnCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 获取栏目内容 -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="12" var="contentResults" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true" >
	   <epg:param name="categoryCode" value="${templateParams['contentCategoryCode']}" type="java.lang.String"/>
</epg:query>
<epg:navUrl obj="${returnindexResults}" indexUrlVar="returnindexResults"/>
<epg:navUrl returnTo="home" returnUrlVar="returnHome"></epg:navUrl>
<meta http-equiv="Content-Type" content="textml; charset=GBK" />
<head>
<style>
body{
 font-size:24px; 
 color:#FFFFFF;
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
 function back(){
 	document.location.href = "${returnindexResults}";
 }
 function exit(){
 	document.location.href = "${returnHome}";
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

var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images/";
	
function init(){
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""&&document.getElementById(leaveFocusId+"_a")){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		document.getElementById("focus_0_a").focus();
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
 	document.location.href = previousUrl+"&leaveFocusId=pageUpfocus"+myPageIndex;
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
 	document.location.href = nextUrl+"&leaveFocusId=pageDownfocus"+myPageIndex;
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

<epg:body  onload="init();" width="1280" height="720" background="../${templateParams['bgImg']}"  style="background-repeat:no-repeat;" defaultBg="./images/tiggerCome.jpg" bgcolor="#000000">
  <!--上下页-->
    <div style="position:absolute; left:168px; top:175px;">
    	<epg:img id="pageUp" src="./images/dot.gif" width="98" height="38"/>
    	<epg:img id="pageUpfocus" src="./images/dot.gif" width="98" height="18"
    	 	href="#" onclick="pageUp()" onfocus="itemOnFocus('pageUp','pageFocus');" onblur="itemOnBlur('pageUp');"/>
    </div>
	<div style="position:absolute; left:280px; top:175px;">
		<epg:img id="pageDown" src="./images/dot.gif" width="98" height="38" />
		<epg:img id="pageDownfocus" src="./images/dot.gif" width="98" height="18" 
			href="#" onclick="pageDown()"  onfocus="itemOnFocus('pageDown','pageFocus');" onblur="itemOnBlur('pageDown');"/>
	</div>
  <div style="position:absolute; left:414px; top:179px; width:108px; height:35px; line-height:35px;">
	<font color="#063787">${pageBean.pageIndex}/${pageBean.pageCount}页</font>
  </div>
   <!--返回首页-->
  	<div style="position:absolute;left:1112px;top:104px; width:82px; height:48px">
	<epg:img id="rainbowIndex" src="./images/dot.gif" width="82" height="48" href="${returnindexResults}" onfocus="itemOnFocus('rainbowIndex','rainbowIndexFocus');" onblur="itemOnBlur('rainbowIndex');"/>
	</div>
  <!--节目海报start-->
  <div id="poster" style="position:absolute;top:220px;left:108px;width:1070px;height:415px;">
    <epg:forEach begin="0" end="11" varStatus="rowStatus">
    	 <epg:if test="${rowStatus.index<=5}">
    	 	<epg:if test="${contentResults[rowStatus.index]!=null}">
	    	 	<div style="position:absolute;left:${rowStatus.index*160+5}px;">
	    	 		<epg:navUrl obj="${contentResults[rowStatus.index]}" indexUrlVar="indexUrl"/>
	    	 		<epg:img id="listImg${rowStatus.index}"  style="border:2px solid #d1821b;" src="../${contentResults[rowStatus.index].poster}"  width="130" height="190"/>
	    	 		<epg:img id="focus_${rowStatus.index}" src="./images/dot.gif"  href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=biz" rememberFocus="true" left="${positions[rowStatus-1].x-10}" top="${positions[rowStatus-1].y-8}" width="155" height="209"   onfocus="itemOnFocus('focus_${rowStatus.index}','nurseryContent');" onblur="itemOnBlur('focus_${rowStatus.index}');" />
	    	 	</div>
			</epg:if>
    	 </epg:if>
    	 <epg:if test="${rowStatus.index>5}">
    		 <epg:if test="${contentResults[rowStatus.index]!=null}">
	    	 	<div style="position:absolute;left:${(rowStatus.index - 6)*160+5}px;top:210px;">
	    	 		<epg:navUrl obj="${contentResults[rowStatus.index]}" indexUrlVar="indexUrl"/>
	    	 		<epg:img id="listImg${rowStatus.index}"  style="border:2px solid #d1821b;" src="../${contentResults[rowStatus.index].poster}"  width="130" height="190"/>
	    	 		<epg:img id="focus_${rowStatus.index}" src="./images/dot.gif"  href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=biz" rememberFocus="true" left="${positions[rowStatus-1].x-10}" top="${positions[rowStatus-1].y-8}" width="155" height="209"   onfocus="itemOnFocus('focus_${rowStatus.index}','nurseryContent');" onblur="itemOnBlur('focus_${rowStatus.index}');" />
	    	 	</div>
    		</epg:if>
    	 </epg:if>
    </epg:forEach>
  </div>
  <!--节目海报end-->
</epg:body>
</epg:html>