<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

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
	String rb = request.getParameter("rb");
	request.setAttribute("rb",rb);
%>
<epg:html >
<!-- 首页顶部菜单分类  -->
<epg:query queryName="getSeverialItems" maxRows="5" var="menuCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 二级菜单  -->
<epg:query queryName="getSeverialItems" maxRows="9" var="secondCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['secondCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 最新赛事-->
<epg:query queryName="getSeverialItems" maxRows="8" var="newestCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['newestCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 焦点新闻-->
<epg:query queryName="getSeverialItems" maxRows="10" var="focusCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['focusCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 右上推荐 图片-->
<epg:query queryName="getSeverialItems" maxRows="1" var="rightUpCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['rightUpCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 右下推荐 图片-->
<epg:query queryName="getSeverialItems" maxRows="4" var="rightDownCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['rightDownCategoryCode']}" type="java.lang.String"/>
</epg:query>
<epg:navUrl returnTo="home" returnUrlVar="returnUrl"></epg:navUrl>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>

<style type="text/css">
	body{
		color:#ffffff;
		font-size:22px;
		font-family:黑体;	
	}
	a{outline:none;}
	img{border:0px solid black;}
	
</style>
<script>
var pageLoad = false;
var fristFocus = 0;
if (typeof(iPanel) == 'undefined') {
	pageLoad  = true;
}
var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images";
//获得失去焦点
function menuOnFocus(objId,img){
	if (pageLoad) {
		fristFocus++;
		document.getElementById(objId + "_img").src = imgPath + "/" + img + ".png";
		document.getElementById("r_"+objId + "_img").src = imgPath + "/" + img + ".png";
	}
}

function firstFocus(){
	if("${rightUpCategoryItems.itemType}"=='channel'){
		//media.video.setPosition(856,166,363,205);
		//var serviceOBJ = DVB.services;
		//DVB.playAV(3790000,2301);
	}
	//document.getElementById("categoryList1_a").focus();
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""&&document.getElementById(leaveFocusId+"_a")){
		document.getElementById(leaveFocusId+"_a").focus();
		document.getElementById("r_"+leaveFocusId+"_a").focus();
	}else{
		document.getElementById("categoryList1_a").focus();
		document.getElementById("r_categoryList1_a").focus();
	}

if("${rightUpCategoryItems.itemType}"=='channel'){ 
	var mediaPlayer = new MediaPlayer();
	var mediaID;
	mediaID = mediaPlayer.createPlayerInstance("video",2);
	mediaPlayer.bindPlayerInstance(mediaID);
	mediaPlayer.position="0,857,167,363,205";   //全屏  857 165
	mediaPlayer.source="delivery://371000.6875.64-QAM.1342.258.514";
	mediaPlayer.play();
	mediaPlayer.refresh();
}
}
function closeVideo() {
	if("${rightUpCategoryItems.itemType}"=='channel'){
		mediaPlayer.releasePlayerInstance();  //释放播放  销毁播放器
		mediaPlayer.unBindPlayerInstance();//解除绑定
	}
}

var returnTo = "${param.returnTo}";
function back(){
	if(returnTo!="" && returnTo!="null"){
 		document.location.href = "${context['EPG_CONTEXT']}/biz/${rb}.do?${queryStr}";
 	}else{
 		document.location.href = "${returnUrl}";
 	}
 }
 function exit(){
 	document.location.href = "${returnUrl}";
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
	    	break;
	    case "SITV_KEY_PAGEDOWN":
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

<epg:body  onload="firstFocus()" onunload="closeVideo();" >
<div id="leftDiv">
<!-- 背景图片以及头部图片 -->
<epg:img src="../${templateParams['bgImg']}" width="640" height="720" left="0" />
<!-- 导航 -->
<epg:grid column="5" row="1" left="181" top="75" width="350" height="36" hcellspacing="20" items="${menuCategoryItems}" var="middleMenuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${middleMenuCategoryItem}" indexUrlVar="indexUrl"/>
			<epg:img id="middleMenu${curIdx}" rememberFocus="true" 
			onfocus="menuOnFocus('middleMenu${curIdx}','NBAfocus1');"  onblur="menuOnFocus('middleMenu${curIdx}','dot');" 
			src="./images/dot.png" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="56" height="36" href="${indexUrl}"/>
</epg:grid>
<!-- 退出-->
<epg:img src="./images/dot.png" id="home"  left="552" top="75" width="56" height="36" href="${returnUrl}" onfocus="menuOnFocus('home','NBAfocus1');"  onblur="menuOnFocus('home','dot');"/>

<!-- 二级导航 -->
<epg:grid column="9" row="1" left="56" top="115" width="524" height="36" hcellspacing="20" items="${secondCategoryItems}" var="secondCategoryItem"  indexVar="curIdx" posVar="positions">
		<epg:navUrl obj="${secondCategoryItem}" indexUrlVar="indexUrl"/>
			<epg:img id="secondMenu${curIdx}" rememberFocus="true" 
			onfocus="menuOnFocus('secondMenu${curIdx}','NBAfocus1');"  onblur="menuOnFocus('secondMenu${curIdx}','dot');" 
			src="./images/dot.png" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="56" height="36" href="${indexUrl}"/>
</epg:grid>

<!--最新赛事 -->
<epg:if test="${menuCategoryItems[1]!=null}">
		<epg:navUrl obj="${menuCategoryItems[1]}" indexUrlVar="indexUrl"/>
		<epg:img id="newestMore"  rememberFocus="true" src="./images/dot.png"
		onfocus="menuOnFocus('newestMore','NBAfocus1')" onblur="menuOnFocus('newestMore','dot')" 
		left="366" href="${indexUrl}&returnTo=biz" top="164" width="56" height="36"/>
</epg:if>
<epg:grid column="2" row="10" left="36" top="205" height="192" width="375" posVar="pos" indexVar="idx" vcellspacing="250" hcellspacing="30" items="${newestCategoryItems}" var="newestCategoryItem" >
	<epg:navUrl obj="${newestCategoryItem}" indexUrlVar="indexUrl"></epg:navUrl>
	
	<epg:img id="categoryList${idx}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="186" height="35"   rememberFocus="true" src="./images/dot.gif" 
	 href="${indexUrl}&pi=${idx}"  onfocus="menuOnFocus('categoryList${idx}','NBAfocus3')" onblur="menuOnFocus('categoryList${idx}','dot')"/>
	<epg:text id="categoryList${idx}" left="${pos[idx-1].x+5}" top="${pos[idx-1].y+5}" align="left"  width="194" height="45" color="#ffffff" chineseCharNumber="16" fontSize="12" dotdotdot="…">
	${newestCategoryItems[idx-1].title}</epg:text>
</epg:grid>

<!--焦点新闻 -->
<epg:if test="${menuCategoryItems[2]!=null}">
		<epg:navUrl obj="${menuCategoryItems[2]}" indexUrlVar="indexUrl"/>
		<epg:img id="newsMore"  rememberFocus="true" src="./images/dot.png"
		onfocus="menuOnFocus('newsMore','NBAfocus1')" onblur="menuOnFocus('newsMore','dot')" 
		left="366" href="${indexUrl}&returnTo=biz" top="386" width="56" height="36"/>
</epg:if>
<epg:grid column="2" row="10" left="36" top="424" height="226" width="375" posVar="pos" indexVar="idx" vcellspacing="220" hcellspacing="30" items="${focusCategoryItems}" var="focusCategoryItem" >
	<epg:navUrl obj="${focusCategoryItem}" indexUrlVar="indexUrl"></epg:navUrl>
	<epg:img id="newsList${idx}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="186" height="35" rememberFocus="true" src="./images/dot.gif" 
	 href="${indexUrl}&pi=${idx}"  onfocus="menuOnFocus('newsList${idx}','NBAfocus3')" onblur="menuOnFocus('newsList${idx}','dot')"/>
	<epg:text id="newsList${idx}" left="${pos[idx-1].x}" top="${pos[idx-1].y+5}" align="left"  width="194" height="45" color="#ffffff" chineseCharNumber="16" fontSize="12" dotdotdot="…">
	${focusCategoryItems[idx-1].title}</epg:text>
</epg:grid>
<!-- 右上图片 -->
<epg:if test="${rightUpCategoryItems!=null}">
	<epg:if test="${rightUpCategoryItems.itemType=='channel'}">
		<epg:navUrl obj="${rightUpCategoryItems}" playUrlVar="indexUrl"/>
		<epg:img  src="./images/dot.png" left="428"  top="166" width="181" height="205" href="${indexUrl}"/>
	</epg:if>
	<epg:if test="${rightUpCategoryItems.itemType!='channel'}">
		<epg:navUrl obj="${rightUpCategoryItems}" indexUrlVar="indexUrl"/>
		<epg:img  src="../${rightUpCategoryItems.itemIcon}" left="428"  top="166" width="181" height="205" />
	</epg:if>
</epg:if>
<!-- 右下图片 -->
	<epg:if test="${rightDownCategoryItems[0]!=null}">
		<epg:navUrl obj="${rightDownCategoryItems[0]}" indexUrlVar="indexUrl"/>
		<epg:img id="rightDownCategoryItems1"  rememberFocus="true" src="../${rightDownCategoryItems[0].itemIcon}"
		onfocus="menuOnFocus('rightDown1','NBAfocus2')" onblur="menuOnFocus('rightDown1','dot')" 
		left="428" href="${indexUrl}&returnTo=biz&pi=1" top="389" width="181" height="59"/>
		<epg:img id="rightDown1"   src="./images/dot.png" left="426" top="386" width="184" height="64"/>
	</epg:if>
	<epg:if test="${rightDownCategoryItems[1]!=null}">
		<epg:navUrl obj="${rightDownCategoryItems[1]}" indexUrlVar="indexUrl"/>
		<epg:img id="rightDownCategoryItems1"  rememberFocus="true" src="../${rightDownCategoryItems[1].itemIcon}" 
		onfocus="menuOnFocus('rightDown2','NBAfocus2')" onblur="menuOnFocus('rightDown2','dot')" 
		left="428" href="${indexUrl}&returnTo=biz&pi=2" top="456" width="181" height="59"/>
		<epg:img id="rightDown2"   src="./images/dot.png" left="426" top="453" width="184" height="64"/>
	</epg:if>
	<epg:if test="${rightDownCategoryItems[2]!=null}">
		<epg:navUrl obj="${rightDownCategoryItems[2]}" indexUrlVar="indexUrl"/>
		<epg:img id="rightDownCategoryItems1"  rememberFocus="true" src="../${rightDownCategoryItems[2].itemIcon}" 
		onfocus="menuOnFocus('rightDown3','NBAfocus2')" onblur="menuOnFocus('rightDown3','dot')" 
		left="428" href="${indexUrl}&returnTo=biz&pi=3" top="523" width="181" height="59"/>
		<epg:img id="rightDown3"   src="./images/dot.png" left="426" top="520" width="184" height="64"/>
	</epg:if>
	<epg:if test="${rightDownCategoryItems[3]!=null}">
		<epg:navUrl obj="${rightDownCategoryItems[3]}" indexUrlVar="indexUrl"/>
		<epg:img id="rightDownCategoryItems1"  rememberFocus="true" src="../${rightDownCategoryItems[3].itemIcon}" 
		onfocus="menuOnFocus('rightDown4','NBAfocus2')" onblur="menuOnFocus('rightDown4','dot')" 
		left="428" href="${indexUrl}&returnTo=biz&pi=4" top="590" width="181" height="59"/>
		<epg:img id="rightDown4"   src="./images/dot.png" left="426" top="587" width="184" height="64"/>
	</epg:if>
</div>

<div id="rightDiv">
<!-- 背景图片以及头部图片 -->
<epg:img src="../${templateParams['bgImg']}" width="640" height="720" left="640" />
<!-- 导航 -->
<epg:grid column="5" row="1" left="821" top="75" width="350" height="36" hcellspacing="20" items="${menuCategoryItems}" var="middleMenuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${middleMenuCategoryItem}" indexUrlVar="indexUrl"/>
			<epg:img id="r_middleMenu${curIdx}" rememberFocus="true" 
			onfocus="menuOnFocus('middleMenu${curIdx}','NBAfocus1');"  onblur="menuOnFocus('middleMenu${curIdx}','dot');" 
			src="./images/dot.png" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="56" height="36" href="${indexUrl}"/>
</epg:grid>
<!-- 退出-->
<epg:img src="./images/dot.png" id="r_home"  left="1192" top="75" width="56" height="36" href="${returnUrl}" onfocus="menuOnFocus('home','NBAfocus1');"  onblur="menuOnFocus('home','dot');"/>

<!-- 二级导航 -->
<epg:grid column="9" row="1" left="696" top="115" width="524" height="36" hcellspacing="20" items="${secondCategoryItems}" var="secondCategoryItem"  indexVar="curIdx" posVar="positions">
		<epg:navUrl obj="${secondCategoryItem}" indexUrlVar="indexUrl"/>
			<epg:img id="r_secondMenu${curIdx}" rememberFocus="true" 
			onfocus="menuOnFocus('secondMenu${curIdx}','NBAfocus1');"  onblur="menuOnFocus('secondMenu${curIdx}','dot');" 
			src="./images/dot.png" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="56" height="36" href="${indexUrl}"/>
</epg:grid>

<!--最新赛事 -->
<epg:if test="${menuCategoryItems[1]!=null}">
		<epg:navUrl obj="${menuCategoryItems[1]}" indexUrlVar="indexUrl"/>
		<epg:img id="r_newestMore"  rememberFocus="true" src="./images/dot.png"
		onfocus="menuOnFocus('newestMore','NBAfocus1')" onblur="menuOnFocus('newestMore','dot')" 
		left="1006" href="${indexUrl}&returnTo=biz" top="164" width="56" height="36"/>
</epg:if>
<epg:grid column="2" row="10" left="676" top="205" height="192" width="375" posVar="pos" indexVar="idx" vcellspacing="250" hcellspacing="30" items="${newestCategoryItems}" var="newestCategoryItem" >
	<epg:navUrl obj="${newestCategoryItem}" indexUrlVar="indexUrl"></epg:navUrl>
	
	<epg:img id="r_categoryList${idx}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="186" height="35"   rememberFocus="true" src="./images/dot.gif" 
	 href="${indexUrl}&pi=${idx}"  onfocus="menuOnFocus('categoryList${idx}','NBAfocus3')" onblur="menuOnFocus('categoryList${idx}','dot')"/>
	<epg:text id="r_categoryList${idx}" left="${pos[idx-1].x+5}" top="${pos[idx-1].y+5}" align="left"  width="194" height="45" color="#ffffff" chineseCharNumber="16" fontSize="12" dotdotdot="…">
	${newestCategoryItems[idx-1].title}</epg:text>
</epg:grid>

<!--焦点新闻 -->
<epg:if test="${menuCategoryItems[2]!=null}">
		<epg:navUrl obj="${menuCategoryItems[2]}" indexUrlVar="indexUrl"/>
		<epg:img id="r_newsMore"  rememberFocus="true" src="./images/dot.png"
		onfocus="menuOnFocus('newsMore','NBAfocus1')" onblur="menuOnFocus('newsMore','dot')" 
		left="1006" href="${indexUrl}&returnTo=biz" top="386" width="56" height="36"/>
</epg:if>
<epg:grid column="2" row="10" left="676" top="424" height="226" width="375" posVar="pos" indexVar="idx" vcellspacing="220" hcellspacing="30" items="${focusCategoryItems}" var="focusCategoryItem" >
	<epg:navUrl obj="${focusCategoryItem}" indexUrlVar="indexUrl"></epg:navUrl>
	<epg:img id="r_newsList${idx}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="186" height="35" rememberFocus="true" src="./images/dot.gif" 
	 href="${indexUrl}&pi=${idx}"  onfocus="menuOnFocus('newsList${idx}','NBAfocus3')" onblur="menuOnFocus('newsList${idx}','dot')"/>
	<epg:text id="r_newsList${idx}" left="${pos[idx-1].x}" top="${pos[idx-1].y+5}" align="left"  width="194" height="45" color="#ffffff" chineseCharNumber="16" fontSize="12" dotdotdot="…">
	${focusCategoryItems[idx-1].title}</epg:text>
</epg:grid>
<!-- 右上图片 -->
<epg:if test="${rightUpCategoryItems!=null}">
	<epg:if test="${rightUpCategoryItems.itemType=='channel'}">
		<epg:navUrl obj="${rightUpCategoryItems}" playUrlVar="indexUrl"/>
		<epg:img  src="./images/dot.png" left="1078"  top="166" width="181" height="205" href="${indexUrl}"/>
	</epg:if>
	<epg:if test="${rightUpCategoryItems.itemType!='channel'}">
		<epg:navUrl obj="${rightUpCategoryItems}" indexUrlVar="indexUrl"/>
		<epg:img  src="../${rightUpCategoryItems.itemIcon}" left="1078"  top="166" width="181" height="205" />
	</epg:if>
</epg:if>
<!-- 右下图片 -->
	<epg:if test="${rightDownCategoryItems[0]!=null}">
		<epg:navUrl obj="${rightDownCategoryItems[0]}" indexUrlVar="indexUrl"/>
		<epg:img id="r_rightDownCategoryItems1"  rememberFocus="true" src="../${rightDownCategoryItems[0].itemIcon}"
		onfocus="menuOnFocus('rightDown1','NBAfocus2')" onblur="menuOnFocus('rightDown1','dot')" 
		left="1078" href="${indexUrl}&returnTo=biz&pi=1" top="389" width="181" height="59"/>
		<epg:img id="r_rightDown1"   src="./images/dot.png" left="1066" top="386" width="184" height="64"/>
	</epg:if>
	<epg:if test="${rightDownCategoryItems[1]!=null}">
		<epg:navUrl obj="${rightDownCategoryItems[1]}" indexUrlVar="indexUrl"/>
		<epg:img id="r_rightDownCategoryItems1"  rememberFocus="true" src="../${rightDownCategoryItems[1].itemIcon}" 
		onfocus="menuOnFocus('rightDown2','NBAfocus2')" onblur="menuOnFocus('rightDown2','dot')" 
		left="1078" href="${indexUrl}&returnTo=biz&pi=2" top="456" width="181" height="59"/>
		<epg:img id="r_rightDown2"   src="./images/dot.png" left="1066" top="453" width="184" height="64"/>
	</epg:if>
	<epg:if test="${rightDownCategoryItems[2]!=null}">
		<epg:navUrl obj="${rightDownCategoryItems[2]}" indexUrlVar="indexUrl"/>
		<epg:img id="r_rightDownCategoryItems1"  rememberFocus="true" src="../${rightDownCategoryItems[2].itemIcon}" 
		onfocus="menuOnFocus('rightDown3','NBAfocus2')" onblur="menuOnFocus('rightDown3','dot')" 
		left="1078" href="${indexUrl}&returnTo=biz&pi=3" top="523" width="181" height="59"/>
		<epg:img id="r_rightDown3"   src="./images/dot.png" left="1066" top="520" width="184" height="64"/>
	</epg:if>
	<epg:if test="${rightDownCategoryItems[3]!=null}">
		<epg:navUrl obj="${rightDownCategoryItems[3]}" indexUrlVar="indexUrl"/>
		<epg:img id="r_rightDownCategoryItems1"  rememberFocus="true" src="../${rightDownCategoryItems[3].itemIcon}" 
		onfocus="menuOnFocus('rightDown4','NBAfocus2')" onblur="menuOnFocus('rightDown4','dot')" 
		left="1078" href="${indexUrl}&returnTo=biz&pi=4" top="590" width="181" height="59"/>
		<epg:img id="r_rightDown4"   src="./images/dot.png" left="1066" top="587" width="184" height="64"/>
	</epg:if>
</div>
</epg:body>
</epg:html>