<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@page import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	String from = request.getParameter("from");
	EpgUserSession eus = EpgUserSession.findUserSession(request);
	String eusLeaveFocusId = eus.getPlayFocusId();
	if (eusLeaveFocusId != null) {
		request.setAttribute("leaveFocusId", eusLeaveFocusId);
	} else {
		String myleaveFocusId = request.getParameter("leaveFocusId");
		if (myleaveFocusId != null && myleaveFocusId != "") {
			request.setAttribute("leaveFocusId", myleaveFocusId);
		}
	}
%>
<epg:html>
<!-- 导航菜单  -->
<epg:query queryName="getSeverialItems" maxRows="8" var="menuCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String" />
</epg:query>

<!--左上推荐-->
<epg:query queryName="getSeverialItems" maxRows="1" var="leftUpCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['leftUpCategoryCode']}" type="java.lang.String" />
</epg:query>

<!--左下推荐-->
<epg:query queryName="getSeverialItems" maxRows="4" var="leftDownCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['leftDownCategoryCode']}" type="java.lang.String" />
</epg:query>

<!-- 中间推荐-->
<epg:query queryName="getSeverialItems" maxRows="9" var="middleCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['middleCategoryCode']}" type="java.lang.String" />
</epg:query>

<!-- 右上大图推荐-->
<epg:query queryName="getSeverialItems" maxRows="2" var="rightBigCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['rightBigCategoryCode']}" type="java.lang.String" />
</epg:query>
<!-- 右上小图推荐-->
<epg:query queryName="getSeverialItems" maxRows="2" var="rightSmallCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['rightSmallCategoryCode']}" type="java.lang.String" />
</epg:query>
<!-- 右下推荐-->
<epg:query queryName="getSeverialItems" maxRows="2" var="rightDownCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['rightDownCategoryCode']}" type="java.lang.String" />
</epg:query>

<epg:navUrl returnTo="home" returnUrlVar="returnHomeUrl"></epg:navUrl>
<epg:navUrl returnTo="biz" returnUrlVar="returnBizUrl"></epg:navUrl>
<script src="${context['EPG_CONTEXT']}/js/base.js"></script>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>

<script type="text/javascript">
var pageLoad = false;
var fristFocus = 0;
if (typeof(iPanel) == 'undefined') {
	pageLoad  = true;
}
function getfocus(objId){
	if("r_" == objId.substr(0,2)){
		objId = objId.substr(2,objId.length)
	}
	if (pageLoad) {
		fristFocus++;
		var id = objId.substring(0,objId.indexOf("_"));
		document.getElementById(id+"_img_img").style.visibility="visible";
		document.getElementById("r_"+id+"_img_img").style.visibility="visible";
	}
}
function outfocus(objId){
	if("r_" == objId.substr(0,2)){
		objId = objId.substr(2,objId.length)
	}
	if (pageLoad) {
		var id = objId.substring(0,objId.indexOf("_"));
		document.getElementById(id+"_img_img").style.visibility="hidden";
		document.getElementById("r_"+id+"_img_img").style.visibility="hidden";
	}
}
function init(){
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		document.getElementById("middle1focus_a").focus();
	}
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
	    	window.location.href = "${returnHomeUrl}";
			return 0;
	    	break;
		case "SITV_KEY_EXIT":
			var ipanelOrSiTV = iPanel.getGlobalVar("from");
			if(ipanelOrSiTV == "iPanel"){
				var cardId = CA.card.serialNumber;
				if(cardId == "" || typeof(cardId) == "undefined"){
					window.location.href = "ui://index.htm";
				}else{
					window.setTimeout('window.location.href = "ui://index.htm";',8000);
					window.location.href = "http://192.168.11.162/portaltest2013/index.htm?STB_ID=" + HardwareInfo.STB.serialnumber + "&type=512&smid=" + cardId;
				}
			}else{
				window.location.href = "${returnHomeUrl}";
			}
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

var from = "<%=from%>";
if (from != "null") {
	iPanel.setGlobalVar("from", from);
}
</script>

<epg:body onload="init()" bgcolor="#000000" width="1280" height="720">

<div id="leftDiv">
	<!-- 背景图片以及头部图片 -->
	<epg:img defaultSrc="./images/sd_theaterIndex.jpg" src="../${templateParams['backgroundImg']}" id="main" left="0" top="0" width="640" height="720" />
	<epg:img left="130" top="66" width="23" height="45" src="./images/sitvLogo1.png" />
	<epg:img left="359" top="76" width="11" height="18" src="./images/newIcon.png" />
	<epg:img left="409" top="76" width="11" height="18" src="./images/newIcon.png" />
	
	<!-- 导航 ${leftCategoryItem.title}-->
	<epg:grid column="8" row="1" left="170" top="80" width="400" height="38" hcellspacing="0" items="${menuCategoryItems}" var="menuCategoryItem" indexVar="curIdx" posVar="positions">
		<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl" />
		<epg:if test="${curIdx==1}">
			<epg:img id="menu${curIdx}" src="./images/dot.gif" width="50" href="${returnBizUrl}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" height="38" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" />
			<epg:img id="menu${curIdx}_img" src="./images/dot.gif" width="50" style="visibility:hidden;border:3px solid #ff9c13" height="38" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" />
		</epg:if>
		<epg:if test="${curIdx!=1}">
			<epg:img id="menu${curIdx}" src="./images/dot.gif" width="50" href="${indexUrl}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" height="38" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" />
			<epg:img id="menu${curIdx}_img" src="./images/dot.gif" width="50" style="visibility:hidden;border:3px solid #ff9c13" height="38" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" />
		</epg:if>
	</epg:grid>
	
	<!-- 返回 -->
	<epg:img id="back" src="./images/dot.gif" width="35" height="30" left="579" top="96" href="${returnHomeUrl}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" />
	<epg:img id="back_img" src="./images/dot.gif" width="35" height="30" left="577" top="96" style="visibility:hidden;border:3px solid #ff9c13" />

	<!-- 左边推荐 -->
	<epg:if test="${leftUpCategoryItems!=null}">
		<epg:navUrl obj="${leftUpCategoryItems}" indexUrlVar="indexUrl" />
		<epg:img id="leftUp" src="../${leftUpCategoryItems.itemIcon}" left="25" top="152" width="140" height="300" />
		<epg:img id="leftUpfocus" src="./images/dot.gif" left="24" top="149" rememberFocus="true" href="${indexUrl}&returnTo=biz&pi=1" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" width="140" height="300" />
		<epg:img id="leftUpfocus_img" src="./images/dot.gif" left="24" top="149" width="138" height="300" style="visibility:hidden;border:3px solid #ff9c13" />
	</epg:if>
	<epg:grid column="1" row="4" left="60" top="452" width="140" height="208" vcellspacing="0" items="${leftDownCategoryItems}" var="leftCategoryItem" indexVar="curIdx" posVar="positions">
		<epg:navUrl obj="${leftCategoryItem}" indexUrlVar="indexUrl" />
		<epg:text color="#ffffff" left="${positions[curIdx-1].x}" align="left" top="${positions[curIdx-1].y+12}" width="105" fontFamily="黑体" fontSize="16" chineseCharNumber="9" dotdotdot="…">
			${leftCategoryItem.title}
		</epg:text>
		<epg:img id="left${curIdx}focus" src="./images/dot.gif" width="140" rememberFocus="true" href="${indexUrl}&returnTo=biz&pi=${curIdx}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" height="52" left="${positions[curIdx-1].x-37}" top="${positions[curIdx-1].y-3}" />
		<epg:img id="left${curIdx}focus_img" src="./images/dot.gif" width="140" style="visibility:hidden;border:3px solid #ff9c13" height="52" left="${positions[curIdx-1].x-37}" top="${positions[curIdx-1].y-3}" />
	</epg:grid>
	
	<!-- 中间 -->
	<epg:navUrl obj="${menuCategoryItems[7]}" indexUrlVar="indexUrl7" />
	<epg:img id="more" src="./images/dot.gif" width="216" height="35" left="171" top="149" rememberFocus="true" href="${indexUrl7}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" />
	<epg:img id="more_img" src="./images/dot.gif" width="214" height="35" left="171" top="149" style="visibility:hidden;border:3px solid #ff9c13" />

	<epg:grid column="1" row="9" left="183" top="193" width="210" height="468" vcellspacing="0" items="${middleCategoryItems}" var="middleCategoryItem" indexVar="curIdx" posVar="positions">
		<epg:navUrl obj="${middleCategoryItem}" indexUrlVar="indexUrl" />
		<epg:text color="#ffffff" left="${positions[curIdx-1].x}" align="left" top="${positions[curIdx-1].y+12}" width="196" fontFamily="黑体" fontSize="16" chineseCharNumber="13" dotdotdot="…">
			${middleCategoryItem.title}
		</epg:text>
		<epg:choose>
			<epg:when test="${curIdx <= 2}">
				<epg:text id="mid_rit${curIdx}" left="${positions[curIdx-1].x+142}" align="left" top="${positions[curIdx-1].y+18}" width="74" height="50" color="#794d8a" dotdotdot="" fontSize="16" fontFamily="黑体">火热上线</epg:text>
			</epg:when>
			<epg:when test="${curIdx == 9}">
				<epg:text id="mid_rit${curIdx}" left="${positions[curIdx-1].x+142}" align="left" top="${positions[curIdx-1].y+18}" width="74" height="50" color="#794d8a" dotdotdot="" fontSize="16" fontFamily="黑体">即将下线</epg:text>
			</epg:when>
			<epg:otherwise>
				<epg:if test="${middleCategoryItem.itemType == 'series'}">
					<epg:query queryName="queryEpisodeByCode" maxRows="1000" var="episodes">
						<epg:param name="seriesCode" value="${middleCategoryItem.itemCode}" type="java.lang.String" />
					</epg:query>
					<epg:query queryName="querySeriesByCode" var="series">
						<epg:param name="contentCode" value="${middleCategoryItem.itemCode}" type="java.lang.String" />
					</epg:query>
					<epg:if test="${series.episodeNumber > fn:length(episodes)}">
						<fmt:formatNumber pattern="00" value="${fn:length(episodes)}" var="episode" />
						<div id="mid_rit${curIdx}" style="position:absolute;left:${positions[curIdx-1].x+142}px;top:${positions[curIdx-1].y+12}px;">
							<span style="font-size: 16px; font-family: 黑体; border: 0px; color: #794d8a" color="#794d8a">更新至</span><span style="font-size: 22px; font-family: 黑体; color: #9c5194">${episodes[fn:length(episodes)-1].episodeIndex}</span><span
								style="font-size: 16px; font-family: 黑体; border: 0px; color: #794d8a">集</span>
						</div>
					</epg:if>
					<epg:if test="${series.episodeNumber == fn:length(episodes)}">
						<epg:text id="mid_rit${curIdx}" left="${positions[curIdx-1].x+142}" align="left" top="${positions[curIdx-1].y+18}" width="74" height="50" color="#794d8a" dotdotdot="" fontSize="16" fontFamily="黑体">已完结</epg:text>
					</epg:if>
				</epg:if>
			</epg:otherwise>
		</epg:choose>
		<epg:img id="middle${curIdx}focus" src="./images/dot.gif" width="210" rememberFocus="true" href="${indexUrl}&returnTo=biz&pi=${curIdx}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" height="52" left="${positions[curIdx-1].x-11}" top="${positions[curIdx-1].y-3}" />
		<epg:img id="middle${curIdx}focus_img" src="./images/dot.gif" width="210" style="visibility:hidden;border:3px solid #ff9c13" height="52" left="${positions[curIdx-1].x-11}" top="${positions[curIdx-1].y-3}" />
	</epg:grid>
	<!-- 右上大图 -->
	<epg:grid column="1" row="2" left="398" top="152" width="140" height="300" vcellspacing="20" items="${rightBigCategoryItems}" var="rightBigCategoryItem" indexVar="curIdx" posVar="positions">
		<epg:navUrl obj="${rightBigCategoryItem}" indexUrlVar="indexUrl" />
		<epg:img id="rightBig${curIdx}" src="../${rightBigCategoryItem.itemIcon}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="140" height="140" />
		<epg:img id="rightBig${curIdx}focus" src="./images/dot.gif" width="140" height="140" rememberFocus="true" href="${indexUrl}&returnTo=biz&pi=${curIdx}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" />
		<epg:img id="rightBig${curIdx}focus_img" src="./images/dot.gif" width="140" height="140" style="visibility:hidden;border:3px solid #ff9c13" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" />
	</epg:grid>
	<!-- 右上小图 -->
	<epg:grid column="1" row="2" left="548" top="152" width="68" height="300" vcellspacing="20" items="${rightSmallCategoryItems}" var="rightSmallCategoryItem" indexVar="curIdx" posVar="positions">
		<epg:navUrl obj="${rightSmallCategoryItem}" indexUrlVar="indexUrl" />
		<epg:img id="rightSmall${curIdx}" src="../${rightSmallCategoryItem.itemIcon}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="68" height="140" />
		<epg:img id="rightSmall${curIdx}focus" src="./images/dot.gif" width="68" height="140" rememberFocus="true" href="${indexUrl}&returnTo=biz&pi=${curIdx}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" />
		<epg:img id="rightSmall${curIdx}focus_img" src="./images/dot.gif" width="68" height="140" style="visibility:hidden;border:3px solid #ff9c13" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" />
	</epg:grid>
	<!-- 右下图 -->
	<epg:grid column="1" row="2" left="413" top="472" width="203" height="186" vcellspacing="22" items="${rightDownCategoryItems}" var="rightDownCategoryItem" indexVar="curIdx" posVar="positions">
		<epg:navUrl obj="${rightDownCategoryItem}" indexUrlVar="indexUrl" />
		<epg:img id="rightDown${curIdx}" src="../${rightDownCategoryItem.itemIcon}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="203" height="84" />
		<epg:img id="rightDown${curIdx}focus" src="./images/dot.gif" width="203" height="84" rememberFocus="true" href="${indexUrl}&returnTo=biz&pi=${curIdx}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" />
		<epg:img id="rightDown${curIdx}focus_img" src="./images/dot.gif" width="203" height="84" style="visibility:hidden;border:3px solid #ff9c13" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" />
	</epg:grid>
</div>
<div id="rightDiv">
	<!-- 背景图片以及头部图片 -->
	<epg:img defaultSrc="./images/sd_theaterIndex.jpg" src="../${templateParams['backgroundImg']}" id="r_main" left="640" top="0" width="640" height="720" />
	<epg:img left="770" top="66" width="23" height="45" src="./images/sitvLogo1.png" />
	<epg:img left="999" top="76" width="11" height="18" src="./images/newIcon.png" />
	<epg:img left="1049" top="76" width="11" height="18" src="./images/newIcon.png" />
	
	<!-- 导航 ${leftCategoryItem.title}-->
	<epg:grid column="8" row="1" left="810" top="80" width="400" height="38" hcellspacing="0" items="${menuCategoryItems}" var="menuCategoryItem" indexVar="curIdx" posVar="positions">
		<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl" />
		<epg:if test="${curIdx==1}">
			<epg:img id="r_menu${curIdx}" src="./images/dot.gif" width="50" href="${returnBizUrl}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" height="38" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" />
			<epg:img id="r_menu${curIdx}_img" src="./images/dot.gif" width="50" style="visibility:hidden;border:3px solid #ff9c13" height="38" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" />
		</epg:if>
		<epg:if test="${curIdx!=1}">
			<epg:img id="r_menu${curIdx}" src="./images/dot.gif" width="50" href="${indexUrl}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" height="38" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" />
			<epg:img id="r_menu${curIdx}_img" src="./images/dot.gif" width="50" style="visibility:hidden;border:3px solid #ff9c13" height="38" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" />
		</epg:if>
	</epg:grid>
	
	<!-- 返回 -->
	<epg:img id="r_back" src="./images/dot.gif" width="35" height="30" left="1219" top="96" href="${returnHomeUrl}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" />
	<epg:img id="r_back_img" src="./images/dot.gif" width="35" height="30" left="1217" top="96" style="visibility:hidden;border:3px solid #ff9c13" />

	<!-- 左边推荐 -->
	<epg:if test="${leftUpCategoryItems!=null}">
		<epg:navUrl obj="${leftUpCategoryItems}" indexUrlVar="indexUrl" />
		<epg:img id="r_leftUp" src="../${leftUpCategoryItems.itemIcon}" left="673" top="152" width="140" height="300" />
		<epg:img id="r_leftUpfocus" src="./images/dot.gif" left="672" top="149" rememberFocus="true" href="${indexUrl}&returnTo=biz&pi=1" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" width="140" height="300" />
		<epg:img id="r_leftUpfocus_img" src="./images/dot.gif" left="672" top="149" width="138" height="300" style="visibility:hidden;border:3px solid #ff9c13" />
	</epg:if>
	<epg:grid column="1" row="4" left="700" top="452" width="140" height="208" vcellspacing="0" items="${leftDownCategoryItems}" var="leftCategoryItem" indexVar="curIdx" posVar="positions">
		<epg:navUrl obj="${leftCategoryItem}" indexUrlVar="indexUrl" />
		<epg:text color="#ffffff" left="${positions[curIdx-1].x}" align="left" top="${positions[curIdx-1].y+12}" width="105" fontFamily="黑体" fontSize="16" chineseCharNumber="9" dotdotdot="…">
			${leftCategoryItem.title}
		</epg:text>
		<epg:img id="r_left${curIdx}focus" src="./images/dot.gif" width="140" rememberFocus="true" href="${indexUrl}&returnTo=biz&pi=${curIdx}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" height="52" left="${positions[curIdx-1].x-37}" top="${positions[curIdx-1].y-3}" />
		<epg:img id="r_left${curIdx}focus_img" src="./images/dot.gif" width="140" style="visibility:hidden;border:3px solid #ff9c13" height="52" left="${positions[curIdx-1].x-37}" top="${positions[curIdx-1].y-3}" />
	</epg:grid>
	
	<!-- 中间 -->
	<epg:navUrl obj="${menuCategoryItems[7]}" indexUrlVar="indexUrl7" />
	<epg:img id="r_more" src="./images/dot.gif" width="216" height="35" left="811" top="149" rememberFocus="true" href="${indexUrl7}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" />
	<epg:img id="r_more_img" src="./images/dot.gif" width="214" height="35" left="811" top="149" style="visibility:hidden;border:3px solid #ff9c13" />

	<epg:grid column="1" row="9" left="823" top="193" width="210" height="468" vcellspacing="0" items="${middleCategoryItems}" var="middleCategoryItem" indexVar="curIdx" posVar="positions">
		<epg:navUrl obj="${middleCategoryItem}" indexUrlVar="indexUrl" />
		<epg:text color="#ffffff"  left="${positions[curIdx-1].x}" align="left" top="${positions[curIdx-1].y+12}" width="196" fontFamily="黑体" fontSize="16" chineseCharNumber="13" dotdotdot="…">
			${middleCategoryItem.title}
		</epg:text>
		<epg:choose>
			<epg:when test="${curIdx <= 2}">
				<epg:text id="r_mid_rit${curIdx}" left="${positions[curIdx-1].x+142}" align="left" top="${positions[curIdx-1].y+18}" width="74" height="50" color="#794d8a" dotdotdot="" fontSize="16" fontFamily="黑体">火热上线</epg:text>
			</epg:when>
			<epg:when test="${curIdx == 9}">
				<epg:text id="r_mid_rit${curIdx}" left="${positions[curIdx-1].x+142}" align="left" top="${positions[curIdx-1].y+18}" width="74" height="50" color="#794d8a" dotdotdot="" fontSize="16" fontFamily="黑体">即将下线</epg:text>
			</epg:when>
			<epg:otherwise>
				<epg:if test="${middleCategoryItem.itemType == 'series'}">
					<epg:query queryName="queryEpisodeByCode" maxRows="1000" var="episodes">
						<epg:param name="seriesCode" value="${middleCategoryItem.itemCode}" type="java.lang.String" />
					</epg:query>
					<epg:query queryName="querySeriesByCode" var="series">
						<epg:param name="contentCode" value="${middleCategoryItem.itemCode}" type="java.lang.String" />
					</epg:query>
					<epg:if test="${series.episodeNumber > fn:length(episodes)}">
						<fmt:formatNumber pattern="00" value="${fn:length(episodes)}" var="episode" />
						<div id="r_mid_rit${curIdx}" style="position:absolute;left:${positions[curIdx-1].x+142}px;top:${positions[curIdx-1].y+12}px;">
							<span style="font-size: 16px; font-family: 黑体; border: 0px; color: #794d8a" color="#794d8a">更新至</span><span style="font-size: 22px; font-family: 黑体; color: #9c5194">${episodes[fn:length(episodes)-1].episodeIndex}</span><span
								style="font-size: 16px; font-family: 黑体; border: 0px; color: #794d8a">集</span>
						</div>
					</epg:if>
					<epg:if test="${series.episodeNumber == fn:length(episodes)}">
						<epg:text id="r_mid_rit${curIdx}" left="${positions[curIdx-1].x+142}" align="left" top="${positions[curIdx-1].y+18}" width="74" height="50" color="#794d8a" dotdotdot="" fontSize="16" fontFamily="黑体">已完结</epg:text>
					</epg:if>
				</epg:if>
			</epg:otherwise>
		</epg:choose>
		<epg:img id="r_middle${curIdx}focus" src="./images/dot.gif" width="210" rememberFocus="true" href="${indexUrl}&returnTo=biz&pi=${curIdx}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" height="52" left="${positions[curIdx-1].x-11}" top="${positions[curIdx-1].y-3}" />
		<epg:img id="r_middle${curIdx}focus_img" src="./images/dot.gif" width="210" style="visibility:hidden;border:3px solid #ff9c13" height="52" left="${positions[curIdx-1].x-11}" top="${positions[curIdx-1].y-3}" />
	</epg:grid>
	<!-- 右上大图 -->
	<epg:grid column="1" row="2" left="1046" top="152" width="140" height="300" vcellspacing="20" items="${rightBigCategoryItems}" var="rightBigCategoryItem" indexVar="curIdx" posVar="positions">
		<epg:navUrl obj="${rightBigCategoryItem}" indexUrlVar="indexUrl" />
		<epg:img id="r_rightBig${curIdx}" src="../${rightBigCategoryItem.itemIcon}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="140" height="140" />
		<epg:img id="r_rightBig${curIdx}focus" src="./images/dot.gif" width="140" height="140" rememberFocus="true" href="${indexUrl}&returnTo=biz&pi=${curIdx}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" />
		<epg:img id="r_rightBig${curIdx}focus_img" src="./images/dot.gif" width="140" height="140" style="visibility:hidden;border:3px solid #ff9c13" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" />
	</epg:grid>
	<!-- 右上小图 -->
	<epg:grid column="1" row="2" left="1188" top="152" width="68" height="300" vcellspacing="20" items="${rightSmallCategoryItems}" var="rightSmallCategoryItem" indexVar="curIdx" posVar="positions">
		<epg:navUrl obj="${rightSmallCategoryItem}" indexUrlVar="indexUrl" />
		<epg:img id="r_rightSmall${curIdx}" src="../${rightSmallCategoryItem.itemIcon}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="68" height="140" />
		<epg:img id="r_rightSmall${curIdx}focus" src="./images/dot.gif" width="68" height="140" rememberFocus="true" href="${indexUrl}&returnTo=biz&pi=${curIdx}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" />
		<epg:img id="r_rightSmall${curIdx}focus_img" src="./images/dot.gif" width="68" height="140" style="visibility:hidden;border:3px solid #ff9c13" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" />
	</epg:grid>
	<!-- 右下图 -->
	<epg:grid column="1" row="2" left="1053" top="472" width="203" height="186" vcellspacing="22" items="${rightDownCategoryItems}" var="rightDownCategoryItem" indexVar="curIdx" posVar="positions">
		<epg:navUrl obj="${rightDownCategoryItem}" indexUrlVar="indexUrl" />
		<epg:img id="r_rightDown${curIdx}" src="../${rightDownCategoryItem.itemIcon}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="203" height="84" />
		<epg:img id="r_rightDown${curIdx}focus" src="./images/dot.gif" width="203" height="84" rememberFocus="true" href="${indexUrl}&returnTo=biz&pi=${curIdx}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" />
		<epg:img id="r_rightDown${curIdx}focus_img" src="./images/dot.gif" width="203" height="84" style="visibility:hidden;border:3px solid #ff9c13" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" />
	</epg:grid>
</div>
</epg:body>
</epg:html>