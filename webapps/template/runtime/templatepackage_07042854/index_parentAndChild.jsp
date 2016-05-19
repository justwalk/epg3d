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
<!-- 获取菜单结果 index-->
<epg:query queryName="getSeverialItems" maxRows="5" var="menuResults" >
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 获取返回首页结果 -->
<epg:query queryName="getSeverialItems" maxRows="1" var="returnindexResults" >
	<epg:param name="categoryCode" value="${templateParams['returnindexCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 获取栏目图片  -->
<epg:query queryName="getSeverialItems" maxRows="9" var="category" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true" >
	   <epg:param name="categoryCode" value="${templateParams['categoryCode']}" type="java.lang.String"/>
</epg:query>
<epg:navUrl returnTo="home" returnUrlVar="returnUrl"></epg:navUrl>
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
 function back(){
 	document.location.href = "${returnindexResults}";
 }
 function exit(){
 	document.location.href = "${returnHome}";
 }



var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images/";

function init()
{		
	showContent();
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!="" && document.getElementById(leaveFocusId+"_a")){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		document.getElementById("listUp0_a").focus();
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
 	document.location.href = previousUrl+"&leaveFocusId=pageUp"+myPageIndex;
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
 	document.location.href = nextUrl+"&leaveFocusId=pageDown"+myPageIndex;
 }

var title = new Array();
function showContent(){
	if("${category[0].title}"!=null&&"${category[0].title}"!=""){
		title[0] = "${category[0].title}";
		if(title[0].substr(0,3)=="HD_"){
			title[0] = title[0].substring(3,title[0].length);
		}
		document.getElementById("listUp0_span").innerHTML = subString(title[0],30,true);
	}
	if("${category[1].title}"!=null&&"${category[1].title}"!=""){
		title[1] = "${category[1].title}";
		if(title[1].substr(0,3)=="HD_"){
			title[1] = title[1].substring(3,title[1].length);
		}
		document.getElementById("listUp1_span").innerHTML = subString(title[1],30,true);
	}
	if("${category[2].title}"!=null&&"${category[2].title}"!=""){
		title[2] = "${category[2].title}";
		if(title[2].substr(0,3)=="HD_"){
			title[2] = title[2].substring(3,title[2].length);
		}
		document.getElementById("listUp2_span").innerHTML = subString(title[2],30,true);
	}
	if("${category[3].title}"!=null&&"${category[3].title}"!=""){
		title[3] = "${category[3].title}";
		if(title[3].substr(0,3)=="HD_"){
			title[3] = title[3].substring(3,title[3].length);
		}
		document.getElementById("listUp3_span").innerHTML = subString(title[3],30,true);
	}
	if("${category[4].title}"!=null&&"${category[4].title}"!=""){
		title[4] = "${category[4].title}";
		if(title[4].substr(0,3)=="HD_"){
			title[4] = title[4].substring(3,title[4].length);
		}
		document.getElementById("listUp4_span").innerHTML = subString(title[4],30,true);
	}
	if("${category[5].title}"!=null&&"${category[5].title}"!=""){
		title[5] = "${category[5].title}";
		if(title[5].substr(0,3)=="HD_"){
			title[5] = title[5].substring(3,title[5].length);
		}
		document.getElementById("listUp5_span").innerHTML = subString(title[5],30,true);
	}
	if("${category[6].title}"!=null&&"${category[6].title}"!=""){
		title[6] = "${category[6].title}";
		if(title[6].substr(0,3)=="HD_"){
			title[6] = title[6].substring(3,title[6].length);
		}
		document.getElementById("listUp6_span").innerHTML = subString(title[6],30,true);
	}
	if("${category[7].title}"!=null&&"${category[7].title}"!=""){
		title[7] = "${category[7].title}";
		if(title[7].substr(0,3)=="HD_"){
			title[7] = title[7].substring(3,title[7].length);
		}
		document.getElementById("listUp7_span").innerHTML = subString(title[7],30,true);
	}
	if("${category[8].title}"!=null&&"${category[8].title}"!=""){
		title[8] = "${category[8].title}";
		if(title[8].substr(0,3)=="HD_"){
			title[8] = title[8].substring(3,title[8].length);
		}
		document.getElementById("listUp8_span").innerHTML = subString(title[8],30,true);
	}
}



//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名，isChangeColor 是否改变文字列表颜色
function itemOnFocus(objId,img){
	if (pageLoad) {
		fristFocus++;
		document.getElementById(objId+"_img").src=imgPath+img+".png";
		if(objId.indexOf("listUp")==0){
			textMov(objId);
		}
	}
}
//失去焦点事件
function itemOnBlur(objId){
	if (pageLoad) {
		document.getElementById(objId+"_img").src=imgPath+"dot.gif";
		if(objId.indexOf("listUp")==0){
			textStop(objId);
		}
	}
}

function textMov(objId){ //左右移动显示文字
	var num = objId.substring(objId.indexOf("p")+1,objId.indexOf("p")+2);
	if(objId!=undefined){
		if(subString(title[num],30,true).indexOf("…")!=-1){
			document.getElementById(objId+"_span").innerHTML = "<marquee direction='left' behavior='alternate' scrollamount='1' scrolldelay='10'>"+title[num]+"</marquee>";
		}else{
			document.getElementById(objId+"_span").innerHTML = subString(title[num],30,true);
		}
	}
}

function textStop(objId){//停止移动文字
	var num = objId.substring(objId.indexOf("p")+1,objId.indexOf("p")+2);
	if(objId!=undefined){
		document.getElementById(objId+"_span").innerHTML = subString(title[num],30,true);
	}
}

//截字
function subString(str, len, hasDot){ 
	var newLength = 0; 
	var newStr = ""; 
	var chineseRegex = /[^\x00-\xff]/g; 
	var singleChar = ""; 
	var strLength = str.replace(chineseRegex,"**").length; 
	for(var i = 0;i < strLength;i++) 
	{ 
		singleChar = str.charAt(i).toString(); 
		if(singleChar.match(chineseRegex) != null) 
		{ 
			newLength += 2; 
		} 
		else 
		{ 
			newLength++; 
		} 
		if(newLength > len) 
		{ 
			break; 
		} 
		newStr += singleChar; 
	} 
	if(hasDot && strLength > len) 
	{ 
		//newStr+="…";
	} 
	return newStr; 
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
</head>

<epg:body onload="init();"  width="1280" height="720" background="../${templateParams['bgImg']}"  style="background-repeat:no-repeat;" defaultBg="./images/animationCastle2.jpg" bgcolor="#000000">
 <div id="main">
 <!-- 栏目文字-->
   	<epg:grid column="1" row="9" left="610" top="248" width="960" height="360" hcellspacing="32" vcellspacing="20" items="${category}" var="categoryItem"  indexVar="rowStatus" posVar="positions">
	 	<epg:if test="${categoryItem!=null}">
	 		<epg:navUrl obj="${categoryItem}" indexUrlVar="indexUrl"/>
	 		<epg:text id="listUp${rowStatus-1}" left="${positions[rowStatus-1].x}" top="${positions[rowStatus-1].y}" rememberFocus="true"  height="33" width="378" text=""/>
   		 	<epg:img id="listUp${rowStatus-1}"  left="${positions[rowStatus-1].x-12}" top="${positions[rowStatus-1].y-2}"  src="./images/dot.gif" href="${indexUrl}" height="33" width="420" onfocus="itemOnFocus('listUp${rowStatus-1}','magicContentFocus');" onblur="itemOnBlur('listUp${rowStatus-1}');"/>
		</epg:if>
    </epg:grid>
  <!--导航条start-->
   <div id="Navigation" style="position:absolute;width:380px;height:595px;left:170px;top:50px;"> 
	<div class="topSelected" style="position:absolute;left:2px;top:4px;">
	<epg:if test="${menuResults[0] != null}">
	<epg:navUrl obj="${menuResults[0]}" indexUrlVar="indexUrl"/>
	<epg:img id="menu0" height="82" width="163" href="${indexUrl}"  src="./images/dot.gif" onfocus="itemOnFocus('menu0','parentAndChildMenuFocus');" onblur="itemOnBlur('menu0');"/>
	</epg:if>
	</div>
	<div class="topSelected" style="position:absolute;left:171px;top:112px;">
	<epg:if test="${menuResults[1] != null}">
	<epg:navUrl obj="${menuResults[1]}" indexUrlVar="indexUrl"/>
	<epg:img id="menu1" height="82" width="163" src="./images/dot.gif" />
	<epg:img id="menu1focus" left="-171" height="82" width="163" href="${indexUrl}" src="./images/dot.gif" onfocus="itemOnFocus('menu1','parentAndChildMenuFocus');" onblur="itemOnBlur('menu1');"/>
	</epg:if>
	</div>
	<div class="topSelected" style="position:absolute;left:239px;top:265px;">
	<epg:if test="${menuResults[2] != null}">
	<epg:navUrl obj="${menuResults[2]}" indexUrlVar="indexUrl"/>
	<epg:img id="menu2" height="82" width="163" src="./images/dot.gif"/>
	<epg:img id="menu2focus" left="-239"  height="82" width="163" href="${indexUrl}" src="./images/dot.gif" onfocus="itemOnFocus('menu2','parentAndChildMenuFocus');" onblur="itemOnBlur('menu2');"/>
	</epg:if>
	</div>
	<div class="topSelected" style="position:absolute;left:174px;top:444px;">
	<epg:if test="${menuResults[3] != null}">
	<epg:navUrl obj="${menuResults[3]}" indexUrlVar="indexUrl"/>
	<epg:img id="menu3" height="82" width="163" src="./images/dot.gif"/>
	<epg:img id="menu3focus" left="-174"  height="82" width="163" href="${indexUrl}"src="./images/dot.gif" onfocus="itemOnFocus('menu3','parentAndChildMenuFocus');" onblur="itemOnBlur('menu3');"/>
	</epg:if>
	</div>
	<div class="topSelected" style="position:absolute;left:4px;top:544px;">
	<epg:if test="${menuResults[4] != null}">
	<epg:navUrl obj="${menuResults[4]}" indexUrlVar="indexUrl"/>
	<epg:img id="menu4"  height="82" width="163" href="${indexUrl}"   src="./images/dot.gif" onfocus="itemOnFocus('menu4','parentAndChildMenuFocus');" onblur="itemOnBlur('menu4');"/>
	</epg:if>
	</div>
  </div>
   <!--导航条end-->
    <!--返回首页-->
  <div style="position:absolute;left:1112px;top:104px; width:82px; height:48px">
	<epg:img id="rainbowIndex" src="./images/dot.gif" width="82" height="48" href="${returnindexResults}" onfocus="itemOnFocus('rainbowIndex','rainbowIndexFocus');" onblur="itemOnBlur('rainbowIndex');"/>
	</div>
   <!--上下页-->
    <div style="position:absolute; left:645px; top:181px;">
    <epg:img id="pageUp" src="./images/dot.gif" width="99" height="43" href="#" onclick="pageUp()"  onfocus="itemOnFocus('pageUp','pageFocus');" onblur="itemOnBlur('pageUp');"/>
    </div>
	<div style="position:absolute; left:757px; top:181px;">
	<epg:img id="pageDown" src="./images/dot.gif" width="99" height="43" href="#" onclick="pageDown()" onfocus="itemOnFocus('pageDown','pageFocus');" onblur="itemOnBlur('pageDown');"/>
	</div>
	<div style="position:absolute; left:892px; top:186px; width:108px; height:33px; line-height:33px;">
		<font color="#063787">${pageBean.pageIndex}/${pageBean.pageCount}页</font>
	</div>
 	
</div>
</epg:body>
</epg:html>