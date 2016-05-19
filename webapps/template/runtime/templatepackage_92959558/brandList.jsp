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
<!-- contents -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="16" var="contents"
		   pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true">
	<epg:param name="categoryCode" value="${context['EPG_CATEGORY_CODE']}" type="java.lang.String"/>
</epg:query>
<!-- query current category -->
<epg:query queryName="getFirstCategoryByItemCode" maxRows="1" var="category">
	<epg:param name="categoryCode" value="${context['EPG_CATEGORY_CODE']}" type="java.lang.String"/>
</epg:query>
<epg:navUrl returnTo="biz" returnUrlVar="returnUrl"/>
<style type="text/css">
	body{
		color:#02296d;
		font-size:22px;
		font-family:黑体;	
	}
	a{outline:none;}
	img{border:0px solid black;} 
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
	function eventHandler(eventObj){
		switch(eventObj.code){
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
function back(){
	window.location.href = "${returnUrl}";
}
function exit(){
	window.location.href = "${returnUrl}";
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
			if (document.getElementById("content1_a")){
				document.getElementById("content1_a").focus();
			}else{
				document.getElementById("exit_a").focus();
			}	
		}
	}

	function end(){
		iPanel.focus.display = 0;
		iPanel.focus.border = 0;
	}
</script>
<epg:body bgcolor="#000000" onload="init();" onunload="end();" width="1280" height="720">

<!-- brandZone -->
<epg:query queryName="getSeverialItems" maxRows="6" var="brandZones" >
	<epg:param name="categoryCode" value="${templateParams['brandCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- logo & bg -->
<epg:img src="./images/brandZongBg.jpg" left="0" top="0" width="1280" height="720"/>

<!-- logo -->
<epg:forEach items="${brandZones}" varStatus="curIdx" var="brandZoneCode">
	<epg:if test="${context['EPG_CATEGORY_CODE'] == brandZoneCode.itemCode}">
		<epg:img left="79" top="64" width="295" height="70" src="./images/HLW_logo${curIdx.index}.png"/>
	</epg:if>
</epg:forEach> 

<!-- exit -->
<epg:img id="exit" left="1127" top="83" width="108" height="34" src="${dot}" href="javascript:back();"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);"/>

<epg:img id="pageUp" src="${dot}" left="51" top="168" width="130" height="30"
		  href="javascript:pageUp();" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" pageop="up" keyop="pageup"/>
<epg:img id="pageDown" src="${dot}" left="201" top="168" width="130" height="30"
		  href="javascript:pageDown()" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" pageop="down" keyop="pagedown"/>
<epg:text left="380" top="171" width="76" height="32" text="${pageBean.pageIndex}/${pageBean.pageCount}页"
			  fontFamily="黑体" fontSize="22" color="#ebebeb" align="center"/>

<!-- contents -->
<epg:grid left="51" top="217" width="1180" height="420" row="2" column="8" items="${contents}"
 		  var="content" indexVar="idx" posVar="pos" hcellspacing="20" vcellspacing="30">
	<epg:navUrl obj="${content}" indexUrlVar="indexUrl"/>
	<epg:choose>
		<epg:when test="${idx == 1}">
			<epg:set value="true" var="defaultFocus"/>
		</epg:when>
		<epg:otherwise>
			<epg:set value="false" var="defaultFocus"/>
		</epg:otherwise>
	</epg:choose>
	<epg:img left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="130" height="195" src="../${content.still}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
			 href="${indexUrl}&returnTo=biz" rememberFocus="true"  id="content${idx}"/>
</epg:grid>

</epg:body>
</epg:html>