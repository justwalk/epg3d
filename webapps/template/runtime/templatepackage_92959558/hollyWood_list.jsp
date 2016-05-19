<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@page import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*"%>
<%@include file="epgUtils.jsp"%>
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
<!-- navigation -->
<epg:query queryName="getSeverialItems" maxRows="6" var="navigations">
	<epg:param name="categoryCode" value="${templateParams['navigationCategoryCode']}" type="java.lang.String"/>
</epg:query>

<epg:set value="${templateParams['programCategoryCode']}" var="contentCode"/>
<epg:if test="${empty contentCode}">
	<epg:set value="${context['EPG_CATEGORY_CODE']}" var="contentCode"/>
</epg:if>

<!-- programList -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="16" var="programLists" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true">
	<epg:param name="categoryCode" value="${contentCode}" type="java.lang.String"/>
</epg:query>

<!-- backUrl -->
<epg:query queryName="getSeverialItems" maxRows="1" var="returnObj" >
	<epg:param name="categoryCode" value="${templateParams['backCode']}" type="java.lang.String"/>
</epg:query>
<epg:navUrl obj="${returnObj}" indexUrlVar="returnUrl"/>
<style>
	a{outline:none;}
</style>
<script src="${context['EPG_CONTEXT']}/js/base.js"></script>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script type="text/javascript">
	var pageLoad = false;
	var fristFocus = 0;
	if (typeof(iPanel) == 'undefined') {
		pageLoad  = true;
	}
	//监听事件
	function eventHandler(eventObj)
	{
		switch(eventObj.code)
		{
			case "SYSTEM_EVENT_ONLOAD":
				setTimeout(function(){
					pageLoad = true;
					init();
					if(typeof(iPanel)!='undefined'){
						iPanel.focus.display = 1;
						iPanel.focus.border = 1;
					}
				},1500);
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
				back();
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
function pageUp(){
  	var previousUrl = "${pageBean.previousUrl}";
	var myPageIndex = "";
	if(previousUrl.indexOf("&pageIndex=")!=-1){
		myPageIndex = previousUrl.substring(previousUrl.indexOf("&pageIndex="),previousUrl.length);
		previousUrl =previousUrl.substring(0,previousUrl.indexOf("&pageIndex="));
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
		nextUrl =nextUrl.substring(0,nextUrl.indexOf("&pageIndex="));
	}
	if(nextUrl.indexOf("&leaveFocusId=")!=-1){
		nextUrl = nextUrl.substring(0,nextUrl.indexOf("&leaveFocusId="));
	}
 	document.location.href = nextUrl+"&leaveFocusId=pageDown"+myPageIndex;
 }
	function getfocus(objId){
		if(pageLoad){
			fristFocus++;
			//var id = objId.substring(0,objId.indexOf("_"));
			//document.getElementById(id+"_img_img").style.visibility="visible";
		}
	}
	function outfocus(objId){
		if(pageLoad){
			//var id = objId.substring(0,objId.indexOf("_"));
			//document.getElementById(id+"_img_img").style.visibility="hidden";
		}
	}
	
	function init(){
		var leaveFocusId = "${leaveFocusId}";
		if(leaveFocusId!=""&& document.getElementById(leaveFocusId+"_a")){
			document.getElementById(leaveFocusId+"_a").focus();
		}else{
			document.getElementById("listFocus1_a").focus();
		}
	}
	function end(){
		iPanel.focus.display = 0;
		iPanel.focus.border = 0;
	}

	function back(){
		returnToBizOrHistory();
	}

	function exit(){
		window.location.href = "${returnHomeUrl}";
	}
	
	function returnToBizOrHistory(){
		//if("${param.returnTo}"!=""&&"${param.returnTo}"!=null){
			window.location.href = "${returnUrl}";
		//}else{
		//	history.back();
		//}
	}
</script>
<epg:body bgcolor="#000000" onload="init();" onunload="end();" width="1280" height="720">
<epg:img src="./images/HLW_listBg.jpg" left="0" top="0" width="1280" height="720"/>

<!-- exit -->
<epg:img left="1141" top="55" width="73" height="32" src="${dot}" href="${returnUrl}"/>

<!-- navigation -->
<epg:forEach items="${navigations}" varStatus="curIdx" var="bizCode">
	<epg:if test="${context['EPG_CATEGORY_CODE'] == bizCode.itemCode}">
		<epg:img left="63" top="117" width="1153" height="35" src="./images/WLH_nav${curIdx.index+1}.png"/>
	</epg:if>
</epg:forEach>
<epg:grid left="63" top="117" width="1153" height="35" row="1" column="6" items="${navigations}" var="navigation"
		indexVar="idx" posVar="pos" hcellspacing="16">
 	<epg:navUrl obj="${navigation}" indexUrlVar="indexUrl"/>
	<epg:img id="nav${idx}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="184" height="35"
		src="${dot}" href="${indexUrl}"/>
</epg:grid>

<epg:img id="pageUp" src="${dot}" left="51" top="178" width="130" height="29" href="javascript:pageUp();" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
	pageop="up" keyop="pageup"/>
<epg:img id="pageDown" src="${dot}" left="201" top="178" width="130" height="29" href="javascript:pageDown()" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
	pageop="down" keyop="pagedown"/>
<epg:text left="351" top="180" width="130" height="29" text="${pageBean.pageIndex}/${pageBean.pageCount} 页"
	fontFamily="黑体" fontSize="24" color="#ABB0B7" align="center"/>

<!-- programList -->
<epg:grid left="52" top="217" width="1179" height="420" row="2" column="8" items="${programLists}"
		var="programList" indexVar="idx" posVar="pos" vcellspacing="30" hcellspacing="20">
	<epg:navUrl obj="${programList}" indexUrlVar="indexUrl"/>
	<epg:choose>
		<epg:when test="${idx == 1}">
			<epg:set value="true" var="defaultFocus"/>
		</epg:when>
		<epg:otherwise>
			<epg:set value="false" var="defaultFocus"/>
		</epg:otherwise>
	</epg:choose>
	<epg:img id="list${idx}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="130" height="195" src="../${programList.still}"/>
	<epg:img id="listFocus${idx}" left="${pos[idx-1].x-3}" top="${pos[idx-1].y-3}" width="136" height="201"
		href="${indexUrl}&returnTo=bizcat" rememberFocus="true"
		onfocus="getfocus(this.id);" onblur="outfocus(this.id);" src="./images/dot.gif"/>
</epg:grid>

</epg:body>
</epg:html>