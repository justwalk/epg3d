<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="java.util.Date"%>
<%@include file="epgUtils.jsp"%>
<title>大片首页</title>
<%
	//新上线、将下线
	Date now=new Date();
	Date nextWeek=new Date(now.getTime()+1000*3600*24*14);
	Date lastWeek=new Date(now.getTime()-1000*3600*24*14);
	request.setAttribute("nextWeek",nextWeek);
	request.setAttribute("lastWeek",lastWeek);
%>
<epg:html>
<!-- 菜单导航  -->
<epg:query queryName="getSeverialItems" maxRows="3" var="menus" >
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 左侧强档好莱坞大图 -->
<epg:query queryName="getSeverialItems" maxRows="1" var="leftImgCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['leftImgCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 左侧强档好莱坞文字 -->
<epg:query queryName="getSeverialItems" maxRows="4" var="leftContentCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['leftContentCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 中间首映华语档大图 -->
<epg:query queryName="getSeverialItems" maxRows="1" var="middleImgCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['middleImgCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 中间首映华语档文字 -->
<epg:query queryName="getSeverialItems" maxRows="4" var="middleContentCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['middleContentCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 右上特别企划图片 -->
<epg:query queryName="getSeverialItems" maxRows="1" var="rightUpImg">
	<epg:param name="categoryCode" value="${templateParams['rightUpCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 右上特别企划文字 -->
<epg:query queryName="getSeverialItems" maxRows="3" var="rightUpCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['rightUpTxtCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 右下特别企划图片 -->
<epg:query queryName="getSeverialItems" maxRows="1" var="rightDownImg">
	<epg:param name="categoryCode" value="${templateParams['rightDownCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 右下特别企划文字 -->
<epg:query queryName="getSeverialItems" maxRows="3" var="rightDownCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['rightDownTxtCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 抢先看图片推荐 -->
<epg:query queryName="getSeverialItems" maxRows="2" var="rushImgCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['rushImgCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 抢先看文字推荐 -->
<epg:query queryName="getSeverialItems" maxRows="5" var="rushContentCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['rushContentCategoryCode']}" type="java.lang.String"/>
</epg:query>

<epg:navUrl returnTo="home" returnUrlVar="returnHome"/>

<style type="text/css">
	body{
		color:#02296d;
		font-size:16px;
		font-family:黑体;	
	}
	a{outline:none;}
	img{border:0px solid black;}
</style>
<script src="${context['EPG_CONTEXT']}/js/base.js"></script>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script>
var imgPath = "${context['EPG_CONTEXT']}/template/${CONTEXT_OBJ['currentTemplatePackageCode']}/images";

function $(_id) {
	return "string" == typeof _id ? document.getElementById(_id) : _id;
}

//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名
function itemOnFocus(objId,img,itemId){
	$(objId+"_img").src="${imgPath}"+img+".png";
	$("r_"+objId+"_img").src="${imgPath}"+img+".png";
	if(typeof(itemId)!="undefined"){
		$(itemId).style.visibility = 'visible';
		$("r_"+itemId).style.visibility = 'visible';
	}
}
//失去焦点事件
function itemOnBlur(objId,itemId){
	$(objId+"_img").src="${dotPath}";
	$("r_"+objId+"_img").src="${dotPath}";
	if(typeof(itemId)!="undefined"){
		$(itemId).style.visibility = 'hidden';
		$("r_"+itemId).style.visibility = 'hidden';
	}
}

//文字节目获得焦点改变文字和背景div颜色
function textOnFocus(objId){
	$(objId).style.visibility="visible";
	$("r_"+objId).style.visibility="visible";
}

//文字节目失去焦点
function textOnBlur(objId){
	$(objId).style.visibility="hidden";
	$("r_"+objId).style.visibility="hidden";
}

//监听事件
function eventHandler(eventObj){
	switch(eventObj.code){
		case "SITV_KEY_UP":
			break;
		case "SITV_KEY_DOWN":
			break;
		case "EIS_IRKEY_SELECT":
			break;
		case "SITV_KEY_LEFT":
			break;
		case "SITV_KEY_RIGHT":
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
			iPanel.eventFrame.openIndex();
			return 0;
			break;
		default:
			return 1;
			break;
	}
}
function back(){
	window.location.href = "${returnHome}";
}

function exit(){
	window.location.href = "${returnHome}";
}

function returnToBizOrHistory(){
	//if("${param.returnTo}"!=""&&"${param.returnTo}"!=null){
		window.location.href = "${returnHome}";
	//}else{
	//	history.back();
	//}
}
</script>

<epg:body bgcolor="#000000" width="1280" height="720" >
<div id="leftDiv">
<!-- 背景图片 -->
<epg:img src="./images/largeBg.jpg" id="main"  left="0" top="0" width="640" height="720"/>

<!-- 菜单导航 -->
<epg:if test="${menus[0] != null}">
		<epg:navUrl obj="${menus[0]}" indexUrlVar="indexUrl"/>
		<epg:img src="${dot}" id="Navigation1"  left="25" top="90" width="152" height="72"
		onfocus="itemOnFocus('Navigation1','largeTop1');"  onblur="itemOnBlur('Navigation1');"
		href="${indexUrl}" />
</epg:if>
<epg:if test="${menus[1] != null}">
		<epg:navUrl obj="${menus[1]}" indexUrlVar="indexUrl"/>
		<epg:img src="${dot}" id="Navigation2"  left="180" top="90" width="153" height="72"
		onfocus="itemOnFocus('Navigation2','largeTop2');"  onblur="itemOnBlur('Navigation2');"
		href="${indexUrl}" />
</epg:if>
<epg:if test="${menus[2] != null}">
		<epg:navUrl obj="${menus[2]}" indexUrlVar="indexUrl"/>
		<epg:img src="${dot}" id="Navigation3"  left="337" top="90" width="130" height="72"
		onfocus="itemOnFocus('Navigation3','largeTop3');"  onblur="itemOnBlur('Navigation3');"
		href="${indexUrl}" />
</epg:if>

<!-- logo&退出 -->
<epg:img src="./images/logo.png"   left="228" top="17"  width="75" height="115"/>
<epg:img src="${dot}"  id="quitPush" left="462" top="33"  width="153" height="58" href="javascript:back();"
	onfocus="itemOnFocus('quitPush','largerQuit');"  onblur="itemOnBlur('quitPush');"	/>

<!-- 左侧强档好莱坞内容 -->
<epg:if test="${leftImgCategoryItems != null}">
	<epg:navUrl obj="${leftImgCategoryItems}" indexUrlVar="indexUrl"/>
	<epg:img id="contentPoster0" src="../${leftImgCategoryItems.itemIcon}" left="32" top="186" width="140" height="300"/>
	<epg:img src="${dot}" id="leftImg0"  left="30" top="183" width="143" height="306" 
	href="${indexUrl}&returnTo=biz" onfocus="itemOnFocus('leftImg0','leftPic','leftText');" 
	onblur="itemOnBlur('leftImg0','leftText');"
	defaultfocus="true" rememberFocus="true"/>
	
	<div id="leftText" style="position:absolute;visibility:hidden;left:30px;top:453px;width:143px;height:45px;" align="center">
		<epg:text  width="143" height="45" align="center"
		  chineseCharNumber="13" dotdotdot="…" fontSize="16" fontFamily="黑体" color="#FFFFFF"
		  text="${leftImgCategoryItems.title}"/>
   	</div>
</epg:if>

<epg:grid left="25" top="519" width="152" height="155" row="4" column="1" items="${leftContentCategoryItems}" var="leftContentCategoryItem"
		  indexVar="idx" posVar="pos" vcellspacing="1">
	<epg:navUrl obj="${leftContentCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="leftRecDot${idx}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="152" height="38"
			onfocus="itemOnFocus('leftRecDot${idx}','longFocus');"  onblur="itemOnBlur('leftRecDot${idx}');"
			 src="${dot}" href="${indexUrl}&returnTo=biz" rememberFocus="true"/>
	<epg:text id="leftRec${idx}" left="${pos[idx-1].x+18}" top="${pos[idx-1].y+6}" width="143" height="35" align="left"
			  chineseCharNumber="10" dotdotdot="…" fontSize="16" fontFamily="黑体" color="#FFFFFF"
			  text="${leftContentCategoryItem.title}"/>
	<div style="position:absolute;left:${pos[idx-1].x+231}px;top:${pos[idx-1].y+6}px;width:66px;height:24px;">
		<epg:choose>
		<epg:when test="${leftContentCategoryItem.validTime > lastWeek && leftContentCategoryItem.expireTime < nextWeek}">
			<epg:img src="./images/upLine.png" width="33" height="24"/>
		</epg:when>
		<epg:when test="${leftContentCategoryItem.validTime > lastWeek}">
			<epg:img src="./images/upLine.png" width="33" height="24"/>
		</epg:when>
		<epg:when test="${leftContentCategoryItem.expireTime < nextWeek}">
			<epg:img src="./images/downLine.png" width="33" height="24"/>
		</epg:when>
		<epg:otherwise>
			<epg:img src="${dot}" width="33" height="24"/>
		</epg:otherwise>
		</epg:choose>
	</div>
</epg:grid>

<!-- 中间首映华语档内容 -->
<epg:if test="${middleImgCategoryItems != null}">
		<epg:navUrl obj="${middleImgCategoryItems}" indexUrlVar="indexUrl"/>
		<epg:img id="contentPoster1" src="../${middleImgCategoryItems.itemIcon}"   left="187" top="186" width="140" height="300"/>
		<epg:img src="${dot}" id="middleImg0"  left="185" top="183" width="143" height="306" 
		href="${indexUrl}&returnTo=biz" rememberFocus="true"
		onfocus="itemOnFocus('middleImg0','leftPic','middleText');"  onblur="itemOnBlur('middleImg0','middleText');"/>
		
		<div id="middleText" style="position:absolute;visibility:hidden;left:185px;top:453px;width:143px;height:45px;" align="center">
			<epg:text  width="143" height="45" align="center"
			  chineseCharNumber="13" dotdotdot="…" fontSize="16" fontFamily="黑体" color="#FFFFFF"
			  text="${middleImgCategoryItems.title}"/>
    	</div>
</epg:if>

<epg:grid left="182" top="524" width="152" height="155" row="4" column="1" items="${middleContentCategoryItems}" var="middleContentCategoryItem"
		  indexVar="idx" posVar="pos" vcellspacing="1">
	<epg:navUrl obj="${middleContentCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="middleRecDot${idx}" left="${pos[idx-1].x-3}" top="${pos[idx-1].y}" width="152" height="38"
			onfocus="itemOnFocus('middleRecDot${idx}','longFocus');"  onblur="itemOnBlur('middleRecDot${idx}');"
			 src="${dot}" href="${indexUrl}&returnTo=biz" rememberFocus="true"/>
	<epg:text id="middleRec${idx}" left="${pos[idx-1].x+18}" top="${pos[idx-1].y+6}" width="152" height="35" align="left"
			  chineseCharNumber="10" dotdotdot="…" fontSize="16" fontFamily="黑体" color="#FFFFFF"
			  text="${middleContentCategoryItem.title}"/>
</epg:grid>

<!-- 右上特别企划 -->
<epg:img src="../${rightUpImg.itemIcon}" left="342" top="186" width="117" height="135"/>
<epg:grid left="338" top="321" width="126" height="104" row="3" column="1" items="${rightUpCategoryItems}" var="rightUpCategoryItem"
		  indexVar="idx" posVar="pos" vcellspacing="1">
	<epg:navUrl obj="${rightUpCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="rightUpRecDot${idx}" left="${pos[idx-1].x-1}" top="${pos[idx-1].y+1}" width="126" height="34"
			onfocus="itemOnFocus('rightUpRecDot${idx}','longFocus');"  onblur="itemOnBlur('rightUpRecDot${idx}');"
			 src="${dot}" href="${indexUrl}&returnTo=biz" rememberFocus="true"/>
	<epg:text id="rightUpRec${idx}" left="${pos[idx-1].x+18}" top="${pos[idx-1].y+6}" width="126" height="35" align="left"
			  chineseCharNumber="9" dotdotdot="…" fontSize="16" fontFamily="黑体" color="#FFFFFF"
			  text="${rightUpCategoryItem.title}"/>
</epg:grid>

<!-- 右下特别企划 -->
<epg:img  src="../${rightDownImg.itemIcon}"   left="342" top="443" width="117" height="135"/>
<epg:grid left="338" top="578" width="126" height="104" row="3" column="1" items="${rightDownCategoryItems}" var="rightDownCategoryItem"
		  indexVar="idx" posVar="pos" vcellspacing="1">
	<epg:navUrl obj="${rightDownCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="rightDownRecDot${idx}" left="${pos[idx-1].x-1}" top="${pos[idx-1].y+1}" width="126" height="34"
			onfocus="itemOnFocus('rightDownRecDot${idx}','longFocus');"  onblur="itemOnBlur('rightDownRecDot${idx}');"
			 src="${dot}" href="${indexUrl}&returnTo=biz" rememberFocus="true"/>
	<epg:text id="rightDownRec${idx}" left="${pos[idx-1].x+18}" top="${pos[idx-1].y+6}" width="126" height="35" align="left"
			  chineseCharNumber="10" dotdotdot="…" fontSize="16" fontFamily="黑体" color="#FFFFFF"
			  text="${rightDownCategoryItem.title}"/>
</epg:grid>

<!-- 抢先看图片推荐 -->
<epg:if test="${rushImgCategoryItems[0] != null}">
	<epg:navUrl obj="${rushImgCategoryItems[0]}" indexUrlVar="indexUrl"/>
	<epg:img  src="../${rushImgCategoryItems[0].itemIcon}"   left="490" top="161" width="126" height="135"/>
	<epg:img  src="./images/rushTitle.png"   left="490" top="266" width="126" height="30"/>
	<epg:img  src="${dot}"  id="rushImg0"   left="489" top="158" width="130" height="138"
		href="${indexUrl}&returnTo=biz" onfocus="itemOnFocus('rushImg0','rushFocus');" onblur="itemOnBlur('rushImg0');" rememberFocus="true"/>
	<epg:text left="493" top="268" width="115" height="30" align="left"
		chineseCharNumber="10" dotdotdot="…" fontSize="16" fontFamily="黑体" color="#FFFFFF" text="${rushImgCategoryItems[0].title}"/>
</epg:if>
<epg:if test="${rushImgCategoryItems[1] != null}">
		<epg:navUrl obj="${rushImgCategoryItems[1]}" indexUrlVar="indexUrl"/>
		<epg:img  src="../${rushImgCategoryItems[1].itemIcon}"   left="490" top="326" width="126" height="135"/>
		<epg:img  src="./images/rushTitle.png"   left="490" top="431" width="126" height="30"/>
		<epg:img  src="${dot}"  id="rushImg1"   left="489" top="323" width="130" height="138"
		href="${indexUrl}&returnTo=biz" onfocus="itemOnFocus('rushImg1','rushFocus');"  onblur="itemOnBlur('rushImg1');"
		rememberFocus="true"/>
		<epg:text left="493" top="433" width="115" height="30" align="left"
			  chineseCharNumber="10" dotdotdot="…" fontSize="16" fontFamily="黑体" color="#FFFFFF"
			  text="${rushImgCategoryItems[1].title}"/>
</epg:if>

<!-- 抢先看文字推荐 -->
<epg:grid left="513" top="480" width="100" height="200" row="5" column="1" items="${rushContentCategoryItems}" var="rushContentCategoryItem"
		  indexVar="idx" posVar="pos" vcellspacing="0">
	<epg:navUrl obj="${rushContentCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="rushContent${idx}" left="${pos[idx-1].x-2}" top="${pos[idx-1].y}" width="100" height="40"
			onfocus="itemOnFocus('rushContent${idx}','longFocus');"  onblur="itemOnBlur('rushContent${idx}');"
			 src="${dot}" href="${indexUrl}&returnTo=biz" rememberFocus="true"/>
	<epg:text id="rushContentRec${idx}" left="${pos[idx-1].x+18}" top="${pos[idx-1].y+8}" width="91" height="35" align="left"
			  chineseCharNumber="8" dotdotdot="…" fontSize="16" fontFamily="黑体" color="#FFFFFF"
			  text="${rushContentCategoryItem.title}"/>
</epg:grid>
</div>

<!-- ************************************************* -->
<div id="rightDiv">
<!-- 背景图片 -->
<epg:img src="./images/largeBg.jpg" id="r_main"  left="640" top="0" width="640" height="720"/>

<!-- 菜单导航 -->
<epg:if test="${menus[0] != null}">
		<epg:navUrl obj="${menus[0]}" indexUrlVar="indexUrl"/>
		<epg:img src="${dot}" id="r_Navigation1"  left="665" top="90" width="152" height="72"
		onfocus="itemOnFocus('Navigation1','largeTop1');"  onblur="itemOnBlur('Navigation1');"
		href="${indexUrl}" />
</epg:if>
<epg:if test="${menus[1] != null}">
		<epg:navUrl obj="${menus[1]}" indexUrlVar="indexUrl"/>
		<epg:img src="${dot}" id="r_Navigation2"  left="820" top="90" width="153" height="72"
		onfocus="itemOnFocus('Navigation2','largeTop2');"  onblur="itemOnBlur('Navigation2');"
		href="${indexUrl}" />
</epg:if>
<epg:if test="${menus[2] != null}">
		<epg:navUrl obj="${menus[2]}" indexUrlVar="indexUrl"/>
		<epg:img src="${dot}" id="r_Navigation3"  left="977" top="90" width="130" height="72"
		onfocus="itemOnFocus('Navigation3','largeTop3');"  onblur="itemOnBlur('Navigation3');"
		href="${indexUrl}" />
</epg:if>

<!-- logo&退出 -->
<epg:img src="./images/logo.png"   left="868" top="17"  width="75" height="115"/>
<epg:img src="${dot}"  id="r_quitPush" left="1102" top="33"  width="153" height="58" href="javascript:back();"
	onfocus="itemOnFocus('quitPush','largerQuit');"  onblur="itemOnBlur('quitPush');"	/>

<!-- 左侧强档好莱坞内容 -->
<epg:if test="${leftImgCategoryItems != null}">
	<epg:navUrl obj="${leftImgCategoryItems}" indexUrlVar="indexUrl"/>
	<epg:img id="r_contentPoster0" src="../${leftImgCategoryItems.itemIcon}" left="682" top="186" width="140" height="300"/>
	<epg:img src="${dot}" id="r_leftImg0"  left="680" top="183" width="143" height="306" 
	href="${indexUrl}&returnTo=biz" onfocus="itemOnFocus('leftImg0','leftPic','leftText');" 
	onblur="itemOnBlur('leftImg0','leftText');"
	defaultfocus="true" rememberFocus="true"/>
	
	<div id="r_leftText" style="position:absolute;visibility:hidden;left:670px;top:453px;width:143px;height:45px;" align="center">
		<epg:text  width="143" height="45" align="center"
		  chineseCharNumber="13" dotdotdot="…" fontSize="16" fontFamily="黑体" color="#FFFFFF"
		  text="${leftImgCategoryItems.title}"/>
   	</div>
</epg:if>

<epg:grid left="665" top="519" width="152" height="155" row="4" column="1" items="${leftContentCategoryItems}" var="leftContentCategoryItem"
		  indexVar="idx" posVar="pos" vcellspacing="1">
	<epg:navUrl obj="${leftContentCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="r_leftRecDot${idx}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="152" height="38"
			onfocus="itemOnFocus('leftRecDot${idx}','longFocus');"  onblur="itemOnBlur('leftRecDot${idx}');"
			 src="${dot}" href="${indexUrl}&returnTo=biz" rememberFocus="true"/>
	<epg:text id="r_leftRec${idx}" left="${pos[idx-1].x+18}" top="${pos[idx-1].y+6}" width="143" height="35" align="left"
			  chineseCharNumber="10" dotdotdot="…" fontSize="16" fontFamily="黑体" color="#FFFFFF"
			  text="${leftContentCategoryItem.title}"/>
	<div style="position:absolute;left:${pos[idx-1].x+231}px;top:${pos[idx-1].y+6}px;width:66px;height:24px;">
		<epg:choose>
		<epg:when test="${leftContentCategoryItem.validTime > lastWeek && leftContentCategoryItem.expireTime < nextWeek}">
			<epg:img src="./images/upLine.png" width="33" height="24"/>
		</epg:when>
		<epg:when test="${leftContentCategoryItem.validTime > lastWeek}">
			<epg:img src="./images/upLine.png" width="33" height="24"/>
		</epg:when>
		<epg:when test="${leftContentCategoryItem.expireTime < nextWeek}">
			<epg:img src="./images/downLine.png" width="33" height="24"/>
		</epg:when>
		<epg:otherwise>
			<epg:img src="${dot}" width="33" height="24"/>
		</epg:otherwise>
		</epg:choose>
	</div>
</epg:grid>

<!-- 中间首映华语档内容 -->
<epg:if test="${middleImgCategoryItems != null}">
		<epg:navUrl obj="${middleImgCategoryItems}" indexUrlVar="indexUrl"/>
		<epg:img id="r_contentPoster1" src="../${middleImgCategoryItems.itemIcon}"   left="837" top="186" width="140" height="300"/>
		<epg:img src="${dot}" id="r_middleImg0"  left="835" top="183" width="143" height="306" 
		href="${indexUrl}&returnTo=biz" rememberFocus="true"
		onfocus="itemOnFocus('middleImg0','leftPic','middleText');"  onblur="itemOnBlur('middleImg0','middleText');"/>
		
		<div id="r_middleText" style="position:absolute;visibility:hidden;left:825px;top:453px;width:143px;height:45px;" align="center">
			<epg:text  width="143" height="45" align="center"
			  chineseCharNumber="13" dotdotdot="…" fontSize="16" fontFamily="黑体" color="#FFFFFF"
			  text="${middleImgCategoryItems.title}"/>
    	</div>
</epg:if>

<epg:grid left="822" top="524" width="152" height="155" row="4" column="1" items="${middleContentCategoryItems}" var="middleContentCategoryItem"
		  indexVar="idx" posVar="pos" vcellspacing="1">
	<epg:navUrl obj="${middleContentCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="r_middleRecDot${idx}" left="${pos[idx-1].x-3}" top="${pos[idx-1].y}" width="152" height="38"
			onfocus="itemOnFocus('middleRecDot${idx}','longFocus');"  onblur="itemOnBlur('middleRecDot${idx}');"
			 src="${dot}" href="${indexUrl}&returnTo=biz" rememberFocus="true"/>
	<epg:text id="r_middleRec${idx}" left="${pos[idx-1].x+18}" top="${pos[idx-1].y+6}" width="152" height="35" align="left"
			  chineseCharNumber="10" dotdotdot="…" fontSize="16" fontFamily="黑体" color="#FFFFFF"
			  text="${middleContentCategoryItem.title}"/>
</epg:grid>

<!-- 右上特别企划 -->
<epg:img src="../${rightUpImg.itemIcon}" left="992" top="186" width="117" height="135"/>
<epg:grid left="998" top="321" width="126" height="104" row="3" column="1" items="${rightUpCategoryItems}" var="rightUpCategoryItem"
		  indexVar="idx" posVar="pos" vcellspacing="1">
	<epg:navUrl obj="${rightUpCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="r_rightUpRecDot${idx}" left="${pos[idx-1].x-1}" top="${pos[idx-1].y+1}" width="126" height="34"
			onfocus="itemOnFocus('rightUpRecDot${idx}','longFocus');"  onblur="itemOnBlur('rightUpRecDot${idx}');"
			 src="${dot}" href="${indexUrl}&returnTo=biz" rememberFocus="true"/>
	<epg:text id="r_rightUpRec${idx}" left="${pos[idx-1].x+18}" top="${pos[idx-1].y+6}" width="126" height="35" align="left"
			  chineseCharNumber="9" dotdotdot="…" fontSize="16" fontFamily="黑体" color="#FFFFFF"
			  text="${rightUpCategoryItem.title}"/>
</epg:grid>

<!-- 右下特别企划 -->
<epg:img  src="../${rightDownImg.itemIcon}"   left="992" top="443" width="117" height="135"/>
<epg:grid left="988" top="578" width="126" height="104" row="3" column="1" items="${rightDownCategoryItems}" var="rightDownCategoryItem"
		  indexVar="idx" posVar="pos" vcellspacing="1">
	<epg:navUrl obj="${rightDownCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="r_rightDownRecDot${idx}" left="${pos[idx-1].x-1}" top="${pos[idx-1].y+1}" width="126" height="34"
			onfocus="itemOnFocus('rightDownRecDot${idx}','longFocus');"  onblur="itemOnBlur('rightDownRecDot${idx}');"
			 src="${dot}" href="${indexUrl}&returnTo=biz" rememberFocus="true"/>
	<epg:text id="r_rightDownRec${idx}" left="${pos[idx-1].x+18}" top="${pos[idx-1].y+6}" width="126" height="35" align="left"
			  chineseCharNumber="10" dotdotdot="…" fontSize="16" fontFamily="黑体" color="#FFFFFF"
			  text="${rightDownCategoryItem.title}"/>
</epg:grid>

<!-- 抢先看图片推荐 -->
<epg:if test="${rushImgCategoryItems[0] != null}">
	<epg:navUrl obj="${rushImgCategoryItems[0]}" indexUrlVar="indexUrl"/>
	<epg:img  src="../${rushImgCategoryItems[0].itemIcon}"   left="1140" top="161" width="126" height="135"/>
	<epg:img  src="./images/rushTitle.png"   left="1140" top="266" width="126" height="30"/>
	<epg:img  src="${dot}"  id="r_rushImg0"   left="1140" top="158" width="130" height="138"
		href="${indexUrl}&returnTo=biz" onfocus="itemOnFocus('rushImg0','rushFocus');" onblur="itemOnBlur('rushImg0');" rememberFocus="true"/>
	<epg:text left="1143" top="268" width="115" height="30" align="left"
		chineseCharNumber="10" dotdotdot="…" fontSize="16" fontFamily="黑体" color="#FFFFFF" text="${rushImgCategoryItems[0].title}"/>
</epg:if>
<epg:if test="${rushImgCategoryItems[1] != null}">
		<epg:navUrl obj="${rushImgCategoryItems[1]}" indexUrlVar="indexUrl"/>
		<epg:img  src="../${rushImgCategoryItems[1].itemIcon}"   left="1140" top="326" width="126" height="135"/>
		<epg:img  src="./images/rushTitle.png"   left="1140" top="431" width="126" height="30"/>
		<epg:img  src="${dot}"  id="r_rushImg1"   left="1140" top="323" width="130" height="138"
		href="${indexUrl}&returnTo=biz" onfocus="itemOnFocus('rushImg1','rushFocus');"  onblur="itemOnBlur('rushImg1');"
		rememberFocus="true"/>
		<epg:text left="1143" top="433" width="115" height="30" align="left"
			  chineseCharNumber="10" dotdotdot="…" fontSize="16" fontFamily="黑体" color="#FFFFFF"
			  text="${rushImgCategoryItems[1].title}"/>
</epg:if>

<!-- 抢先看文字推荐 -->
<epg:grid left="1153" top="480" width="100" height="200" row="5" column="1" items="${rushContentCategoryItems}" var="rushContentCategoryItem"
		  indexVar="idx" posVar="pos" vcellspacing="0">
	<epg:navUrl obj="${rushContentCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="r_rushContent${idx}" left="${pos[idx-1].x-2}" top="${pos[idx-1].y}" width="100" height="40"
			onfocus="itemOnFocus('rushContent${idx}','longFocus');"  onblur="itemOnBlur('rushContent${idx}');"
			 src="${dot}" href="${indexUrl}&returnTo=biz" rememberFocus="true"/>
	<epg:text id="r_rushContentRec${idx}" left="${pos[idx-1].x+18}" top="${pos[idx-1].y+8}" width="91" height="35" align="left"
			  chineseCharNumber="8" dotdotdot="…" fontSize="16" fontFamily="黑体" color="#FFFFFF"
			  text="${rushContentCategoryItem.title}"/>
</epg:grid>
</div>
</epg:body>
</epg:html>