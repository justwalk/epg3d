<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
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

<!-- 中间内容 -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="20" var="rightCategoryItems" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true"  >
	<epg:param name="categoryCode" value="${templateParams['rightCategoryCode']}" type="java.lang.String"  />
</epg:query>
<epg:navUrl returnTo="home" returnUrlVar="returnUrl"></epg:navUrl>
<style type="text/css">
	body{
		color:#FFFFFF;
		font-size:21;
		font-family:"黑体";
	}
	a{outline:none;}
</style>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script type="text/javascript">
var pageLoad = false;
var fristFocus = 0;
if (typeof(iPanel) == 'undefined') {
	pageLoad  = true;
}
//监听事件
 function back(){
 	document.location.href = "${returnUrl}";
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
var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images";
var _requester = null; 
var pageSize = 20;	
var pageIndex = 1;	
var pageTotal;
var pageCount="${pageBean.pageCount}";
var categoryList=[];


//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名
function itemOnFocus(objId,img){
	if (pageLoad) {
		fristFocus++;
		document.getElementById(objId+"_img").src=imgPath+"/"+img+".png";
		document.getElementById("r_"+objId+"_img").src=imgPath+"/"+img+".png";
		if (document.getElementById(objId + "_span")) {
			document.getElementById(objId + "_span").style.color = "#ffffff";
			document.getElementById("r_"+objId + "_span").style.color = "#ffffff";
			
		}
	}
}
//失去焦点事件
function itemOnBlur(objId){
	if (pageLoad) {
		document.getElementById(objId+"_img").src=imgPath+"/dot.gif";
		document.getElementById("r_"+objId+"_img").src=imgPath+"/dot.gif";
		if (document.getElementById(objId + "_span")) {
			document.getElementById(objId + "_span").style.color = "#003333";
			document.getElementById("r_"+objId + "_span").style.color = "#003333";
		}
	}
}
//中间文字获得焦点
function textOnFocus(objId,color){
	if (pageLoad) {
			fristFocus++;
			document.getElementById(objId+"_span").style.color=color;
			document.getElementById(objId+"_img").src=imgPath+"/selectedtitle.png";
			document.getElementById("r_"+objId+"_span").style.color=color;
			document.getElementById("r_"+objId+"_img").src=imgPath+"/selectedtitle.png";
	}
	
}
function textOnBlur(objId,color){
	if (pageLoad) {
		document.getElementById(objId+"_span").style.color=color;
		document.getElementById(objId+"_img").src=imgPath+"/dot.gif";
		
		document.getElementById("r_"+objId+"_span").style.color=color;
		document.getElementById("r_"+objId+"_img").src=imgPath+"/dot.gif";
	}
}

//左边文字节目获得焦点改变文字和背景div颜色
function textOnBlur1(objId,color,divBgColor){
	if (pageLoad) {
			fristFocus++;
			document.getElementById(objId+"_bg").style.background = divBgColor;
			document.getElementById("r_"+objId+"_bg").style.background = divBgColor;
			if(typeof(color)!="undefined"){
				document.getElementById(objId+"_span").style.color=color;
				document.getElementById("r_"+objId+"_span").style.color=color;
			}
	}
}
function textOnFocus1(objId,textColor,divBgColor){
	if (pageLoad) {
		document.getElementById(objId+"_span").style.color=textColor;
		document.getElementById(objId+"_bg").style.background = divBgColor;
		
		document.getElementById("r_"+objId+"_span").style.color=textColor;
		document.getElementById("r_"+objId+"_bg").style.background = divBgColor;
	}
}


function buttonOnFocus(objId,img){
	if (pageLoad) {
			fristFocus++;
		document.getElementById(objId+"_img").src=imgPath+"/"+img+".png";
		document.getElementById("r_"+objId+"_img").src=imgPath+"/"+img+".png";
	}
}
function buttonOnBlur(objId,img){
	if (pageLoad) {
		if(img){
			document.getElementById(objId+"_img").src=imgPath+"/"+img+".png";
			document.getElementById("r_"+objId+"_img").src=imgPath+"/"+img+".png";
		}else{
			document.getElementById(objId+"_img").src=imgPath+"/dot.gif";
			document.getElementById("r_"+objId+"_img").src=imgPath+"/dot.gif";
		}
	}
}


function init()
{		
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		document.getElementById("categoryList0_a").focus();
	}
}
//左侧图片获得焦点
function iconOnfocus(objId,img,itemId){
	if (pageLoad) {
			fristFocus++;
			document.getElementById(objId).style.visibility="visible";
			document.getElementById(itemId).style.opacity="1";
			document.getElementById(itemId).style.backgroundColor="#f79922";
			
			document.getElementById("r_"+objId).style.visibility="visible";
			document.getElementById("r_"+itemId).style.opacity="1";
			document.getElementById("r_"+itemId).style.backgroundColor="#f79922";
	}
}
function iconOnblur(objId,itemId){
	if (pageLoad) {
		document.getElementById(objId).style.visibility="hidden";
		document.getElementById(itemId).style.opacity="0.8";
		document.getElementById(itemId).style.backgroundColor="#020000";
		
		document.getElementById("r_"+objId).style.visibility="hidden";
		document.getElementById("r_"+itemId).style.opacity="0.8";
		document.getElementById("r_"+itemId).style.backgroundColor="#020000";
	}
}

</script>
<epg:body onload="init()"   bgcolor="#000000"  width="1280" height="720" >
<div id="leftDiv">
<!-- 背景图片以及头部图片 -->
<epg:img id="main"  defaultSrc="./images/operaIndex.jpg" src="../${templateParams['backgroundImg']}"
	     left="0" top="0" width="640" height="720"/>

<div style="position:absolute;left:0px; top:0px; width:640px; height:140px;">
<epg:img src="./images/logo.png"  width="175" height="85"/>
</div>
<epg:resource src="./images/dot.gif" realSrcVar="realSrc" />

<!-- 搜索,自助,指南 -->
<epg:img src="./images/dot.gif" id="ss"  left="475" top="47" width="40" height="38"
	href="${context['EPG_SEARCH_URL']}" onfocus="itemOnFocus('ss','focusMenuTop_1');"  onblur="itemOnBlur('ss');" />
<epg:img src="./images/dot.gif" id="zz"  left="525" top="47" width="40" height="38"
	href="${context['EPG_SELF_URL']}" onfocus="itemOnFocus('zz','zizhuFocus');"  onblur="itemOnBlur('zz');" />
<epg:img src="./images/dot.gif" id="zn"  left="575" top="47"width="40" height="38" 
	 href="javascript:back();" onfocus="itemOnFocus('zn','focusMenuTop_3');"  onblur="itemOnBlur('zn');" />
<!--上下页、确定 -->
<epg:img src="./images/prePage.png" id="area_upPage"  left="25" top="152" onfocus="buttonOnFocus('area_upPage','prePage_focus')" onblur="buttonOnBlur('area_upPage','prePage')"  pageop="up" keyop="pageup" width="65" height="32" href="javascript:pageUp();"/>
<epg:img src="./images/nextPage.png" id="area_downPage"  left="100" top="152" onfocus="buttonOnFocus('area_downPage','nextPage_focus')" onblur="buttonOnBlur('area_downPage','nextPage')" pageop="down" keyop="pagedown"  width="65" height="32" href="javascript:pageDown();"/>

<div style="position:absolute; top:155px; left:181px; width:65px; height:22px; font-size:22px; " >
	<span id="pageIndex" style="color:#1978b8">${pageBean.pageIndex}</span><span id="pageCount" style="color:#646464">/${pageBean.pageCount}页</span>
</div>

<!--中间文字 -->
<div style="position:absolute;left:25px;top:210px;width:590px;height:405px">
<epg:forEach begin="0" end="1" varStatus="colStatus">
<epg:forEach begin="0" end="9" varStatus="rowStatus">
	<epg:if test="${rightCategoryItems[colStatus.index*10+rowStatus.index]!=null}">
	<epg:navUrl obj="${rightCategoryItems[colStatus.index*10+rowStatus.index]}" indexUrlVar="indexUrl"/>
		<epg:if test="${colStatus.index*10+rowStatus.index<10}">
			<epg:img id="categoryList${colStatus.index*10+rowStatus.index}" left="0" top="${rowStatus.index*45}" width="290" height="45" rememberFocus="true" src="./images/dot.gif" 
			 href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=biz"  onfocus="textOnFocus('categoryList${colStatus.index*10+rowStatus.index}','#ffffff')" onblur="textOnBlur('categoryList${colStatus.index*10+rowStatus.index}','#333')"/>
			<epg:text id="categoryList${colStatus.index*10+rowStatus.index}" left="25" top="${rowStatus.index*45+15}" width="194" height="45" color="#333333" chineseCharNumber="16" fontSize="14" dotdotdot="…">
			${rightCategoryItems[colStatus.index*10+rowStatus.index].title}</epg:text>
		</epg:if>
		<epg:if test="${colStatus.index*10+rowStatus.index>=10}">
			<epg:img id="categoryList${colStatus.index*10+rowStatus.index}" left="300" top="${rowStatus.index*45}" width="290" height="45" rememberFocus="true" src="./images/dot.gif" 
			 href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=biz"  onfocus="textOnFocus('categoryList${colStatus.index*10+rowStatus.index}','#ffffff')" onblur="textOnBlur('categoryList${colStatus.index*10+rowStatus.index}','#333')" />
			<epg:text id="categoryList${colStatus.index*10+rowStatus.index}" left="325" top="${rowStatus.index*45+15}" width="194" height="26" color="#333333" chineseCharNumber="16" fontSize="14" dotdotdot="…">
			${rightCategoryItems[colStatus.index*10+rowStatus.index].title}</epg:text>
		</epg:if>
	</epg:if>
</epg:forEach>
</epg:forEach>
</div>
</div>

<!-- ********************************************************* -->
<div id="rightDiv">
<!-- 背景图片以及头部图片 -->
<epg:img id="r_main"  defaultSrc="./images/operaIndex.jpg" src="../${templateParams['backgroundImg']}"
	     left="640" top="0" width="640" height="720"/>

<div style="position:absolute;left:640px; top:0px; width:640px; height:140px;">
<epg:img src="./images/logo.png"  width="175" height="85"/>
</div>
<epg:resource src="./images/dot.gif" realSrcVar="realSrc" />

<!-- 搜索,自助,指南 -->
<epg:img src="./images/dot.gif" id="r_ss"  left="1115" top="47" width="40" height="38"
	href="${context['EPG_SEARCH_URL']}" onfocus="itemOnFocus('ss','focusMenuTop_1');"  onblur="itemOnBlur('ss');" />
<epg:img src="./images/dot.gif" id="r_zz"  left="1165" top="47" width="40" height="38"
	href="${context['EPG_SELF_URL']}" onfocus="itemOnFocus('zz','zizhuFocus');"  onblur="itemOnBlur('zz');" />
<epg:img src="./images/dot.gif" id="r_zn"  left="1215" top="47"width="40" height="38" 
	 href="javascript:back();" onfocus="itemOnFocus('zn','focusMenuTop_3');"  onblur="itemOnBlur('zn');" />
<!--上下页、确定 -->
<epg:img src="./images/prePage.png" id="r_area_upPage"  left="665" top="152" onfocus="buttonOnFocus('area_upPage','prePage_focus')" onblur="buttonOnBlur('area_upPage','prePage')"  pageop="up" keyop="pageup" width="65" height="32" href="javascript:pageUp();"/>
<epg:img src="./images/nextPage.png" id="r_area_downPage"  left="740" top="152" onfocus="buttonOnFocus('area_downPage','nextPage_focus')" onblur="buttonOnBlur('area_downPage','nextPage')" pageop="down" keyop="pagedown"  width="65" height="32" href="javascript:pageDown();"/>

<div style="position:absolute; top:155px; left:821px; width:65px; height:22px; font-size:22px; " >
	<span id="r_pageIndex" style="color:#1978b8">${pageBean.pageIndex}</span><span id="r_pageCount" style="color:#646464">/${pageBean.pageCount}页</span>
</div>

<!--中间文字 -->
<div style="position:absolute;left:665px;top:210px;width:590px;height:405px">
<epg:forEach begin="0" end="1" varStatus="colStatus">
<epg:forEach begin="0" end="9" varStatus="rowStatus">
	<epg:if test="${rightCategoryItems[colStatus.index*10+rowStatus.index]!=null}">
	<epg:navUrl obj="${rightCategoryItems[colStatus.index*10+rowStatus.index]}" indexUrlVar="indexUrl"/>
		<epg:if test="${colStatus.index*10+rowStatus.index<10}">
			<epg:img id="r_categoryList${colStatus.index*10+rowStatus.index}" left="0" top="${rowStatus.index*45}" width="290" height="45" rememberFocus="true" src="./images/dot.gif" 
			 href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=biz"  onfocus="textOnFocus('categoryList${colStatus.index*10+rowStatus.index}','#ffffff')" onblur="textOnBlur('categoryList${colStatus.index*10+rowStatus.index}','#333')"/>
			<epg:text id="r_categoryList${colStatus.index*10+rowStatus.index}" left="25" top="${rowStatus.index*45+15}" width="194" height="45" color="#333333" chineseCharNumber="16" fontSize="14" dotdotdot="…">
			${rightCategoryItems[colStatus.index*10+rowStatus.index].title}</epg:text>
		</epg:if>
		<epg:if test="${colStatus.index*10+rowStatus.index>=10}">
			<epg:img id="r_categoryList${colStatus.index*10+rowStatus.index}" left="300" top="${rowStatus.index*45}" width="290" height="45" rememberFocus="true" src="./images/dot.gif" 
			 href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=biz"  onfocus="textOnFocus('categoryList${colStatus.index*10+rowStatus.index}','#ffffff')" onblur="textOnBlur('categoryList${colStatus.index*10+rowStatus.index}','#333')" />
			<epg:text id="r_categoryList${colStatus.index*10+rowStatus.index}" left="325" top="${rowStatus.index*45+15}" width="194" height="26" color="#333333" chineseCharNumber="16" fontSize="14" dotdotdot="…">
			${rightCategoryItems[colStatus.index*10+rowStatus.index].title}</epg:text>
		</epg:if>
	</epg:if>
</epg:forEach>
</epg:forEach>
</div>
</div>
</epg:body>
</epg:html>





