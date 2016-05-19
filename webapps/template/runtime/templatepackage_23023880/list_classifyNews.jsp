<%@page contentType="text/html; charset=GBK" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*" %>
<% 
	String pageIndex = request.getParameter("pageIndex");
	request.setAttribute("formerPageIndex", pageIndex);
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
<!-- 菜单-->
<epg:query queryName="getSeverialItems" maxRows="10" var="menuResults">
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 左侧内容(模板参数如果没有绑定则取上下文categoryCode) -->
<epg:set var="categoryCode" value="${templateParams['newsCategoryCode']}"></epg:set>
<epg:if test="${categoryCode==null || categoryCode ==''}">
	<epg:set var="categoryCode" value="${context['EPG_CATEGORY_CODE']}"></epg:set>
</epg:if>
<epg:query queryName="getSeverialItems" maxRows="12" var="newsCategoryItems"  pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true">
	<epg:param name="categoryCode" value="${categoryCode}" type="java.lang.String"/>
</epg:query>
<!-- 右上固定所显示的图片栏目 -->
<epg:query queryName="getSeverialItems" maxRows="2" var="fixTopicImgCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['fixTopicImgCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 右上固定栏目 -->
<epg:query queryName="getSeverialItems" maxRows="2" var="fixTopicCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['fixTopicCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 右下推荐栏目 -->
<epg:query queryName="getSeverialItems" maxRows="3" var="recommendTopicCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['recommendTopicCategoryCode']}" type="java.lang.String"/>
</epg:query>

<epg:navUrl returnTo="home" returnUrlVar="returnHomeUrl"></epg:navUrl>
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
			document.getElementById("newsCategory1_focus_a").focus();
		}
	}
	function getfocus(objId){
		if (pageLoad) {
			fristFocus++;
			var id = objId.substring(0, objId.indexOf("_a"));
			document.getElementById(id + "_img_img").style.visibility = "visible";
		}
	}
	function outfocus(objId){
		if (pageLoad) {
			var id = objId.substring(0, objId.indexOf("_a"));
			document.getElementById(id + "_img_img").style.visibility = "hidden";
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
 	document.location.href = previousUrl+"&leaveFocusId=pu"+myPageIndex;
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
 	document.location.href = nextUrl+"&leaveFocusId=pd"+myPageIndex;
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
			window.location.href = "${context['EPG_CONTEXT']}/common/logout/logout.jsp";
			return 0;
			break;
		default:
			return 1;
			break;
	}
}
</script>


<epg:html>
<epg:body onload="init()" width="1280"  height="720" style="background-repeat:no-repeat;" background="../${templateParams['bgImg']}" defaultBg="./images/list_news.jpg"  bgcolor="#000000">
	<!-- 菜单 (菜单文字切出图片方便dcms绑定) 一个grid滚出来会有焦点难点中,所以用2个-->
	<epg:grid column="10" row="1" left="354" top="81" width="850" height="40"  items="${menuResults}" var="menuResult"  indexVar="curIdx" posVar="positions">
		<epg:if test="${context['EPG_CATEGORY_CODE']==menuResult.itemCode}">
			<epg:img src="./images/curMenu.png" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y-5}" width="85" height="40"/>
			<epg:img src="./images/menuTitle.png" left="354" top="81" width="850" height="30"/>
		</epg:if>
	</epg:grid>
	<epg:grid column="10" row="1" left="354" top="81" width="850" height="40"  items="${menuResults}" var="menuResult"  indexVar="curIdx" posVar="positions">
		<epg:navUrl obj="${menuResult}" indexUrlVar="indexUrl"/>
		<epg:img id="menuCategory${curIdx}_focus" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" src="./images/dot.gif" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y-5}" width="79" height="34" rememberFocus="true"  href="${indexUrl}"/>
		<epg:img id="menuCategory${curIdx}_focus_img" style="visibility:hidden;border:3px solid #ff9c13"  src="./images/dot.gif" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y-5}" width="79" height="34" />
	</epg:grid>
	<!-- 返回 -->
	<epg:img id="back" src="./images/dot.gif" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="1166" top="118" width="83" height="22" href="${returnHomeUrl}"/>
	<epg:img id="back_img" src="./images/dot.gif" style="visibility:hidden;border:3px solid #ff9c13" left="1166" top="118" width="77" height="16"/>
		<!-- 左侧内容 -->
	<epg:grid column="1" row="12" left="83" top="201" width="644" height="450" vcellspacing="6"  items="${newsCategoryItems}" var="newsCategoryItem"  indexVar="curIdx" posVar="positions">
		<epg:navUrl obj="${newsCategoryItem}" indexUrlVar="indexUrl"/>
		<epg:text id="newsCategory${curIdx}" align="left" fontSize="24" chineseCharNumber="25" left="${positions[curIdx-1].x+10}" top="${positions[curIdx-1].y+4}" width="644" height="32" text="${newsCategoryItem.title}"/>
		<epg:img id="newsCategory${curIdx}_focus"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  src="./images/dot.gif" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="644" height="32" rememberFocus="true"  href="${indexUrl}"/>
		<epg:img id="newsCategory${curIdx}_focus_img" style="visibility:hidden;border:3px solid #ff9c13"  src="./images/dot.gif" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="644" height="32" />
	</epg:grid>
	<!-- 翻页 -->
	<epg:img id='pu' src="./images/dot.gif" left="464" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  top="147" width="70" height="17" href="javascript:pageUp();"/>
	<epg:img id='pu_img' src="./images/dot.gif" style="visibility:hidden;border:3px solid #ff9c13"  left="464" top="147" width="70" height="17"/>
	<epg:img id='pd' src="./images/dot.gif" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="545" top="147"  width="70" height="17" href="javascript:pageDown();"/>
	<epg:img id='pd_img' src="./images/dot.gif" style="visibility:hidden;border:3px solid #ff9c13" left="545" top="147"  width="70" height="17"/>
	<epg:text fontSize="24" id="pageCount" align="right" text="${pageBean.pageIndex}/${pageBean.pageCount}" left="632" top="147" width="68" height="23"></epg:text>

	<!-- 右上固定栏目 -->
	<epg:img src="../${fixTopicImgCategoryItems[0].itemIcon}" left="752" top="142" width="470" height="110"/>
	<epg:if test="${fixTopicCategoryItems[0]!=null}">
		<epg:navUrl obj="${fixTopicCategoryItems[0]}" indexUrlVar="indexUrl"/>
		<epg:img id="rightUp1" src="./images/dot.gif" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  left="752" top="142" width="470" height="110" rememberFocus="true"  href="${indexUrl}"/>
	</epg:if>
	<epg:img id="rightUp1_img" src="./images/dot.gif" style="visibility:hidden;border:3px solid #ff9c13"  left="752" top="142" width="464" height="104"/>
	<epg:img src="../${fixTopicImgCategoryItems[1].itemIcon}" left="752" top="265" width="470" height="110" />
	<epg:if test="${fixTopicCategoryItems[1]!=null}">
		<epg:navUrl obj="${fixTopicCategoryItems[1]}" indexUrlVar="indexUrl"/>
		<epg:img id="rightUp2" src="./images/dot.gif" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="752" top="265" width="470" height="110"  rememberFocus="true"  href="${indexUrl}"/>
	</epg:if>
	<epg:img id="rightUp2_img" src="./images/dot.gif" style="visibility:hidden;border:3px solid #ff9c13" left="752" top="265" width="464" height="104"/>
	
	<!-- 右下推荐栏目 -->
	<epg:grid column="1" row="3" vcellspacing="11" left="752" top="411" width="458" height="256"  items="${recommendTopicCategoryItems}" var="recommendTopicCategoryItem"  indexVar="curIdx" posVar="positions">
		<epg:navUrl obj="${recommendTopicCategoryItem}" playUrlVar="playUrl"/>
		<epg:img src="../${recommendTopicCategoryItem.itemIcon}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="458" height="78" />
		<epg:img id="rightDown${curIdx}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" src="./images/dot.gif" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="455" height="75" rememberFocus="true"  href="${playUrl}&pi=${curIdx}"/>
		<epg:img id="rightDown${curIdx}_img"  style="visibility:hidden;border:3px solid #ff9c13" src="./images/dot.gif" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="455" height="75"/>
	</epg:grid>
</epg:body>
</epg:html>