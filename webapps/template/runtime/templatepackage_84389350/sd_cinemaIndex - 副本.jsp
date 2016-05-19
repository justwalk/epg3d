<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*"%>
<%
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
<epg:query queryName="getSeverialItems" maxRows="7" var="menuCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String" />
</epg:query>

<!--票房排行推荐-->
<epg:query queryName="getSeverialItems" maxRows="10" var="leftCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['leftCategoryCode']}" type="java.lang.String" />
</epg:query>
<!-- 中间1图推荐-->
<epg:query queryName="getSeverialItems" maxRows="1" var="centerOneCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['centerOneCategoryCode']}" type="java.lang.String" />
</epg:query>
<!-- 中间1文字推荐-->
<epg:query queryName="getSeverialItems" maxRows="2" var="centerOneCharCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['centerOneCharCategory']}" type="java.lang.String" />
</epg:query>

<!-- 中间2图推荐-->
<epg:query queryName="getSeverialItems" maxRows="1" var="centerTwoCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['centerTwoCategoryCode']}" type="java.lang.String" />
</epg:query>
<!-- 中间2文字推荐-->
<epg:query queryName="getSeverialItems" maxRows="2" var="centerTwoCharCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['centerTwoCharCategory']}" type="java.lang.String" />
</epg:query>


<!-- 中间3图推荐-->
<epg:query queryName="getSeverialItems" maxRows="1" var="centerThreeCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['centerThreeCategoryCode']}" type="java.lang.String" />
</epg:query>
<!-- 中间3文字推荐-->
<epg:query queryName="getSeverialItems" maxRows="2" var="centerThreeCharCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['centerThreeCharCategory']}" type="java.lang.String" />
</epg:query>

<!-- 人气最高-->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="6" var="downCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['downCategoryCode']}" type="java.lang.String" />
</epg:query>
<epg:navUrl returnTo="home" returnUrlVar="returnHomeUrl"></epg:navUrl>
<epg:navUrl returnTo="biz" returnUrlVar="returnBizUrl"></epg:navUrl>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<style>
a {
	outline: none;
}
/* 3D */
#left1,#left2,#left3,#left4,#left5,#left6,#left7,#left8,#left9,#left10,
#centerOne1,#centerTwo1,#centerThree1,
#centerOneChar1,#centerOneChar2,#centerTwoChar1,#centerTwoChar2,#centerThreeChar1,#centerThreeChar2{
	overflow: hidden;
	-webkit-transform: rotateY(60deg);
}
#r_left1,#r_left2,#r_left3,#r_left4,#r_left5,#r_left6,#r_left7,#r_left8,#r_left9,#r_left10,
#r_centerOne1,#r_centerTwo1,#r_centerThree1,
#r_centerOne1,#r_centerTwo1,#r_centerThree1,
#r_centerOneChar1,#r_centerOneChar2,#r_centerTwoChar1,#r_centerTwoChar2,#r_centerThreeChar1,#r_centerThreeChar2{
	overflow: hidden;
	-webkit-transform: rotateY(60deg);
}
</style>

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
		// 票房排行 r_left1_a
		if(objId.substr(0,objId.length-3) == "left" || objId.substr(0,objId.length-3) == "r_left"){
			var r_left = document.getElementById("r_"+objId.substr(0,objId.length-2)).style.left;
			var rLeft = r_left.substr(0,r_left.length-2);
			document.getElementById("r_"+objId.substr(0,objId.length-2)).style.left = (parseInt(rLeft)+10)+"px";
		}
		// 中间1
		if(objId.substr(0,objId.length-2) == "centerOne1" || objId.substr(0,objId.length-2) == "centerTwo1" || objId.substr(0,objId.length-2) == "centerThree1"){
			var _showDiv = document.getElementById("r_"+objId.substr(0,objId.length-2)+"_show_div").style.left;
			var showDiv = _showDiv.substr(0,_showDiv.length-2);
			var _img_div = document.getElementById("r_"+objId.substr(0,objId.length-2)+"_img_div").style.left;
			var img_div = _img_div.substr(0,_img_div.length-2);
			var _titlediv = document.getElementById("r_"+objId.substr(0,objId.length-2)+"_titlediv").style.left;
			var titlediv = _titlediv.substr(0,_titlediv.length-2);
			document.getElementById("r_"+objId.substr(0,objId.length-2)+"_show_div").style.left = (parseInt(showDiv)+10)+"px";
			document.getElementById("r_"+objId.substr(0,objId.length-2)+"_img_div").style.left = (parseInt(img_div)+10)+"px";
			document.getElementById("r_"+objId.substr(0,objId.length-2)+"_titlediv").style.left = (parseInt(titlediv)+10)+"px";
			document.getElementById("r_"+objId.substr(0,objId.length-2)+"_show_div").style.zIndex = 110;
			document.getElementById("r_"+objId.substr(0,objId.length-2)+"_img_div").style.zIndex = 112;
			document.getElementById("r_"+objId.substr(0,objId.length-2)+"_titlediv").style.zIndex = 111;
		}
		//人气最高 r_downfocus1_a 
		if(objId.substr(0,objId.length-3) == "downfocus"){
			var num = objId.replace(/[^0-9]/ig,"");	// 提取id里的数字
			var _r_down_img_div = document.getElementById("r_down_img"+num+"_div").style.left;
			var r_down_img_div = _r_down_img_div.substr(0,_r_down_img_div.length-2);
			var _r_downfocus1_img_div = document.getElementById("r_downfocus"+num+"_img_div").style.left;
			var r_downfocus1_img_div = _r_downfocus1_img_div.substr(0,_r_downfocus1_img_div.length-2);
			document.getElementById("r_down_img"+num+"_div").style.left = (parseInt(r_down_img_div)+10)+"px";
			document.getElementById("r_downfocus"+num+"_img_div").style.left = (parseInt(r_down_img_div)+10)+"px";
			document.getElementById("r_down_img"+num+"_div").style.zIndex = 100;
			document.getElementById("r_downfocus"+num+"_img_div").style.zIndex = 101;
		}
		
		if(pageLoad){
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
		// 票房排行 r_left1_a
		if(objId.substr(0,objId.length-3) == "left" || objId.substr(0,objId.length-3) == "r_left"){
			var r_left = document.getElementById("r_"+objId.substr(0,objId.length-2)).style.left;
			var rLeft = r_left.substr(0,r_left.length-2);
			document.getElementById("r_"+objId.substr(0,objId.length-2)).style.left = (parseInt(rLeft)-10)+"px";
		}
		// 中间1
		if(objId.substr(0,objId.length-2) == "centerOne1" || objId.substr(0,objId.length-2) == "centerTwo1" || objId.substr(0,objId.length-2) == "centerThree1"){
			var _showDiv = document.getElementById("r_"+objId.substr(0,objId.length-2)+"_show_div").style.left;
			var showDiv = _showDiv.substr(0,_showDiv.length-2);
			var _img_div = document.getElementById("r_"+objId.substr(0,objId.length-2)+"_img_div").style.left;
			var img_div = _img_div.substr(0,_img_div.length-2);
			var _titlediv = document.getElementById("r_"+objId.substr(0,objId.length-2)+"_titlediv").style.left;
			var titlediv = _titlediv.substr(0,_titlediv.length-2);
			document.getElementById("r_"+objId.substr(0,objId.length-2)+"_show_div").style.left = (parseInt(showDiv)-10)+"px";
			document.getElementById("r_"+objId.substr(0,objId.length-2)+"_img_div").style.left = (parseInt(img_div)-10)+"px";
			document.getElementById("r_"+objId.substr(0,objId.length-2)+"_titlediv").style.left = (parseInt(titlediv)-10)+"px";
		}
		//人气最高 r_downfocus1_a 
		if(objId.substr(0,objId.length-3) == "downfocus"){
			var num = objId.replace(/[^0-9]/ig,"");	// 提取id里的数字
			var _r_down_img_div = document.getElementById("r_down_img"+num+"_div").style.left;
			var r_down_img_div = _r_down_img_div.substr(0,_r_down_img_div.length-2);
			var _r_downfocus1_img_div = document.getElementById("r_downfocus"+num+"_img_div").style.left;
			var r_downfocus1_img_div = _r_downfocus1_img_div.substr(0,_r_downfocus1_img_div.length-2);
			document.getElementById("r_down_img"+num+"_div").style.left = (parseInt(r_down_img_div)-10)+"px";
			document.getElementById("r_downfocus"+num+"_img_div").style.left = (parseInt(r_down_img_div)-10)+"px";
		}
		if(pageLoad){
			var id = objId.substring(0,objId.indexOf("_"));
			document.getElementById(id+"_img_img").style.visibility="hidden";
			document.getElementById("r_"+id+"_img_img").style.visibility="hidden";
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
	
	function init(){
		//$("contentFocus1_a").focus();
		var leaveFocusId = "${leaveFocusId}";
		if(leaveFocusId!=""&& document.getElementById(leaveFocusId+"_a")){
			document.getElementById(leaveFocusId+"_a").focus();
		}else{
			document.getElementById("centerOne1_a").focus();
		}
		
	}
	
	var from = "<%=from%>";
	if (from != "null") {
		iPanel.setGlobalVar("from", from);
	}
</script>

<epg:body onload="init();" bgcolor="#000000" width="1280" height="720">

	<div id="leftDiv">
		<!-- 背景图片以及头部图片 -->
		<epg:img src="./images/sd_cinemaIndex.jpg" id="main" left="0" top="0" width="640" height="720" />

		<!-- 导航 -->
		<epg:grid column="7" row="1" left="110" top="90" width="505" height="39" hcellspacing="35" items="${menuCategoryItems}" var="menuCategoryItem" indexVar="curIdx" posVar="positions">
			<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl" />
			<epg:if test="${curIdx==1}">
				<epg:img id="menu${curIdx}" src="./images/dot.gif" width="35" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" href="${returnBizUrl}" height="39" left="${positions[curIdx-1].x+9}" top="${positions[curIdx-1].y}" />
				<epg:img id="menu${curIdx}_img" src="./images/dot.gif" width="35" style="visibility:hidden;border:3px solid #ff9c13" height="39" left="${positions[curIdx-1].x+9}" top="${positions[curIdx-1].y}" />
			</epg:if>
			<epg:if test="${curIdx!=1}">
				<epg:img id="menu${curIdx}" src="./images/dot.gif" width="62" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" href="${indexUrl}" height="39" left="${positions[curIdx-1].x-30}" top="${positions[curIdx-1].y}" />
				<epg:img id="menu${curIdx}_img" src="./images/dot.gif" width="62" style="visibility:hidden;border:3px solid #ff9c13" height="39" left="${positions[curIdx-1].x-30}" top="${positions[curIdx-1].y}" />
			</epg:if>
		</epg:grid>

		<epg:img id="back" src="./images/dot.gif" width="35" height="30" left="555" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" top="37" href="${returnHomeUrl}" />
		<epg:img id="back_img" src="./images/dot.gif" width="35" style="visibility:hidden;border:3px solid #ff9c13" height="30" left="555" top="37" />

		<!-- 票房排行 -->
		<epg:grid column="1" row="10" left="31" top="219" width="120" height="430" vcellspacing="15" items="${leftCategoryItems}" var="leftCategoryItem" indexVar="curIdx" posVar="positions">
			<epg:navUrl obj="${leftCategoryItem}" indexUrlVar="indexUrl" />
			<epg:text color="#ffffff" id="left${curIdx}" left="${positions[curIdx-1].x-10}" align="left" top="${positions[curIdx-1].y+9}" width="100" fontSize="22" chineseCharNumber="9" dotdotdot="…">
				${leftCategoryItem.title}
				</epg:text>
			<epg:img id="left${curIdx}" src="./images/dot.gif" width="120" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" rememberFocus="true" href="${indexUrl}&pi=${curIdx}" height="30" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y+4}" />
			<epg:img id="left${curIdx}_img" src="./images/dot.gif" width="120" style="visibility:hidden;border:3px solid #ff9c13;" height="30" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y+4}" />
		</epg:grid>

		<!-- 中间1-->
		<epg:if test="${centerOneCategoryItems!=null}">
			<epg:img id="centerOne1_show" src="../${centerOneCategoryItems.itemIcon}" width="140" height="140" left="165" top="176" />
			<div id="centerOne1_titlediv" style="position: absolute; font-size: 22px; color: #FFFFFF; opacity: 0.7; text-align: center; background-color: #020000; left:165px; top: 286px; width: 140px; height: 30px; z-index: 1;">
				<epg:text color="#ffffff" id="centerOne1" left="-30" align="left" width="140" fontSize="22" chineseCharNumber="12" dotdotdot="…">${centerOneCategoryItems.title}</epg:text>
			</div>
			<epg:navUrl obj="${centerOneCategoryItems}" indexUrlVar="indexOneUrl1" />
			<epg:img id="centerOne1" src="./images/dot.gif" width="140" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" rememberFocus="true" href="${indexOneUrl1}&pi=1" height="140" left="164" top="173" />
			<epg:img id="centerOne1_img" style="position:absolute;visibility:hidden;border:3px solid #ff9c13;" src="./images/dot.gif" width="137" height="140" left="164" top="173" />
		</epg:if>
		<epg:grid column="1" row="2" left="165" top="324" width="140" height="54" vcellspacing="10" items="${centerOneCharCategoryItems}" var="centerOneCharCategoryItem" indexVar="curIdx" posVar="positions">
			<epg:navUrl obj="${centerOneCharCategoryItem}" indexUrlVar="indexOneUrl" />
			<epg:text color="#ffffff" id="centerOneChar${curIdx}" left="${positions[curIdx-1].x-30}" align="left" top="${positions[curIdx-1].y}" width="140" fontSize="22" chineseCharNumber="12" dotdotdot="…">${centerOneCharCategoryItem.title}</epg:text>
			<epg:img id="centerOneChar${curIdx}" src="./images/dot.gif" width="140" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" rememberFocus="true" href="${indexOneUrl}&pi=${curIdx}" height="26" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y}" />
			<epg:img id="centerOneChar${curIdx}_img" style="visibility:hidden;border:3px solid #ff9c13;" src="./images/dot.gif" width="140" height="26" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-4}" />
		</epg:grid>

		<!-- 中间2-->
		<epg:if test="${centerTwoCategoryItems!=null}">
			<epg:img id="centerTwo1_show" src="../${centerTwoCategoryItems.itemIcon}" width="140" height="140" left="315" top="176" />
			<div id="centerTwo1_titlediv" style="position: absolute; font-size: 22px; color: #FFFFFF; opacity: 0.7; text-align: center; background-color: #020000; left: 315px; top: 286px; width: 140px; height: 30px; z-index: 1;">
				<epg:text color="#ffffff" id="centerTwo1" left="-30" align="left" width="140" fontSize="22" chineseCharNumber="12" dotdotdot="…">${centerTwoCategoryItems.title}</epg:text>
			</div>
			<epg:navUrl obj="${centerTwoCategoryItems}" indexUrlVar="indexTwoUrl1" />
			<epg:img id="centerTwo1" src="./images/dot.gif" width="140" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" rememberFocus="true" href="${indexTwoUrl1}&pi=1" height="140" left="314" top="173" />
			<epg:img id="centerTwo1_img" style="visibility:hidden;border:3px solid #ff9c13;" src="./images/dot.gif" width="137" height="140" left="314" top="173" />
		</epg:if>
		<epg:grid column="1" row="2" left="315" top="324" width="140" height="54" vcellspacing="10" items="${centerTwoCharCategoryItems}" var="centerTwoCharCategoryItem" indexVar="curIdx" posVar="positions">
			<epg:navUrl obj="${centerTwoCharCategoryItem}" indexUrlVar="indexTwoUrl" />
			<epg:text color="#ffffff" id="centerTwoChar${curIdx}" left="${positions[curIdx-1].x-30}" align="left" top="${positions[curIdx-1].y}" width="140" fontSize="22" chineseCharNumber="12" dotdotdot="…">${centerTwoCharCategoryItem.title}</epg:text>
			<epg:img id="centerTwoChar${curIdx}" src="./images/dot.gif" width="140" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" rememberFocus="true" href="${indexTwoUrl}&pi=${curIdx}" height="26" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y}" />
			<epg:img id="centerTwoChar${curIdx}_img" style="visibility:hidden;border:3px solid #ff9c13;" src="./images/dot.gif" width="140" height="26" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-4}" />
		</epg:grid>

		<!-- 中间3-->
		<epg:if test="${centerThreeCategoryItems!=null}">
			<epg:img id="centerThree1_show" src="../${centerThreeCategoryItems.itemIcon}" width="140" height="140" left="465" top="176" />
			<div id="centerThree1_titlediv" style="position: absolute; font-size: 22px; color: #FFFFFF; opacity: 0.7; text-align: center; background-color: #020000; left: 465px; top: 286px; width: 140px; height: 30px; z-index: 1;">
				<epg:text color="#ffffff" id="centerThree1" left="-30" align="left" width="140" fontSize="22" chineseCharNumber="12" dotdotdot="…">${centerThreeCategoryItems.title}</epg:text>
			</div>
			<epg:navUrl obj="${centerThreeCategoryItems}" indexUrlVar="indexThreeUrl1" />
			<epg:img id="centerThree1" src="./images/dot.gif" width="140" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" rememberFocus="true" href="${indexThreeUrl1}&pi=1" height="140" left="464" top="173" />
			<epg:img id="centerThree1_img" style="visibility:hidden;border:3px solid #ff9c13;" src="./images/dot.gif" width="137" height="140" left="464" top="173" />
		</epg:if>
		<epg:grid column="1" row="2" left="465" top="324" width="140" height="54" vcellspacing="10" items="${centerThreeCharCategoryItems}" var="centerThreeCharCategoryItem" indexVar="curIdx" posVar="positions">
			<epg:navUrl obj="${centerThreeCharCategoryItem}" indexUrlVar="indexThreeUrl" />
			<epg:text color="#ffffff" id="centerThreeChar${curIdx}" left="${positions[curIdx-1].x-30}" align="left" top="${positions[curIdx-1].y}" width="140" fontSize="22" chineseCharNumber="12" dotdotdot="…">${centerThreeCharCategoryItem.title}</epg:text>
			<epg:img id="centerThreeChar${curIdx}" src="./images/dot.gif" width="140" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" rememberFocus="true" href="${indexThreeUrl}&pi=${curIdx}" height="26" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y}" />
			<epg:img id="centerThreeChar${curIdx}_img" style="visibility:hidden;border:3px solid #ff9c13;" src="./images/dot.gif" width="140" height="26" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-4}" />
		</epg:grid>

		<!-- 人气最高-->
		<epg:grid column="6" row="1" left="165" top="453" width="440" height="195" hcellspacing="20" items="${downCategoryItems}" var="downCategoryItem" indexVar="curIdx" posVar="positions">
			<epg:navUrl obj="${downCategoryItem}" indexUrlVar="indexUrl" />
			<epg:img id="down_img${curIdx}" src="../${downCategoryItem.still}" width="65" height="195" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" />
			<epg:img id="downfocus${curIdx}" src="./images/dot.gif" width="65" rememberFocus="true" href="${indexUrl}&pi=${curIdx}" height="195" left="${positions[curIdx-1].x-3}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" top="${positions[curIdx-1].y-3}" />
			<epg:img id="downfocus${curIdx}_img" src="./images/dot.gif" width="65" style="visibility:hidden;border:3px solid #ff9c13;" height="195" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" />
		</epg:grid>
	</div>
	<!-- ********************************************************************************************** -->
	<div id="rightDiv">
		<!-- 背景图片以及头部图片 -->
		<epg:img src="./images/sd_cinemaIndex.jpg" id="r_main" left="640" top="0" width="640" height="720" />

		<!-- 导航 -->
		<epg:grid column="7" row="1" left="750" top="90" width="505" height="39" hcellspacing="35" items="${menuCategoryItems}" var="menuCategoryItem" indexVar="curIdx" posVar="positions">
			<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl" />
			<epg:if test="${curIdx==1}">
				<epg:img id="r_menu${curIdx}" src="./images/dot.gif" width="35" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" href="${returnBizUrl}" height="39" left="${positions[curIdx-1].x+9}" top="${positions[curIdx-1].y}" />
				<epg:img id="r_menu${curIdx}_img" src="./images/dot.gif" width="35" style="visibility:hidden;border:3px solid #ff9c13" height="39" left="${positions[curIdx-1].x+9}" top="${positions[curIdx-1].y}" />
			</epg:if>
			<epg:if test="${curIdx!=1}">
				<epg:img id="r_menu${curIdx}" src="./images/dot.gif" width="62" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" href="${indexUrl}" height="39" left="${positions[curIdx-1].x-30}" top="${positions[curIdx-1].y}" />
				<epg:img id="r_menu${curIdx}_img" src="./images/dot.gif" width="62" style="visibility:hidden;border:3px solid #ff9c13" height="39" left="${positions[curIdx-1].x-30}" top="${positions[curIdx-1].y}" />
			</epg:if>
		</epg:grid>

		<epg:img id="r_back" src="./images/dot.gif" width="35" height="30" left="1195" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" top="37" href="${returnHomeUrl}" />
		<epg:img id="r_back_img" src="./images/dot.gif" width="35" style="visibility:hidden;border:3px solid #ff9c13" height="30" left="1195" top="37" />

		<!-- 票房排行 -->
		<epg:grid column="1" row="10" left="671" top="219" width="120" height="430" vcellspacing="15" items="${leftCategoryItems}" var="leftCategoryItem" indexVar="curIdx" posVar="positions">
			<epg:navUrl obj="${leftCategoryItem}" indexUrlVar="indexUrl" />
			<epg:text color="#ffffff" id="r_left${curIdx}" left="${positions[curIdx-1].x-10}" align="left" top="${positions[curIdx-1].y+9}" width="100" fontSize="22" chineseCharNumber="9" dotdotdot="…">
				${leftCategoryItem.title}
				</epg:text>
			<epg:img id="r_left${curIdx}" src="./images/dot.gif" width="120" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" rememberFocus="true" href="${indexUrl}&pi=${curIdx}" height="30" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y+4}" />
			<epg:img id="r_left${curIdx}_img" src="./images/dot.gif" width="120" style="visibility:hidden;border:3px solid #ff9c13;" height="30" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y+4}" />
		</epg:grid>

		<!-- 中间1-->
		<epg:if test="${centerOneCategoryItems!=null}">
			<epg:img id="r_centerOne1_show" src="../${centerOneCategoryItems.itemIcon}" width="140" height="140" left="805" top="176" />
			<div id="r_centerOne1_titlediv" style="position: absolute; font-size: 22px; color: #FFFFFF; opacity: 0.7; text-align: center; background-color: #020000; left:805px; top: 286px; width: 140px; height: 30px; z-index: 1;">
				<epg:text color="#ffffff" id="r_centerOne1" left="-30" align="left" width="140" fontSize="22" chineseCharNumber="12" dotdotdot="…">${centerOneCategoryItems.title}</epg:text>
			</div>
			<epg:navUrl obj="${centerOneCategoryItems}" indexUrlVar="indexOneUrl1" />
			<epg:img id="r_centerOne1" src="./images/dot.gif" width="140" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" rememberFocus="true" href="${indexOneUrl1}&pi=1" height="140" left="804" top="173" />
			<epg:img id="r_centerOne1_img" style="position:absolute;visibility:hidden;border:3px solid #ff9c13;" src="./images/dot.gif" width="137" height="140" left="804" top="173" />
		</epg:if>
		<epg:grid column="1" row="2" left="805" top="324" width="140" height="54" vcellspacing="10" items="${centerOneCharCategoryItems}" var="centerOneCharCategoryItem" indexVar="curIdx" posVar="positions">
			<epg:navUrl obj="${centerOneCharCategoryItem}" indexUrlVar="indexOneUrl" />
			<epg:text color="#ffffff" id="r_centerOneChar${curIdx}" left="${positions[curIdx-1].x-30}" align="left" top="${positions[curIdx-1].y}" width="140" fontSize="22" chineseCharNumber="12" dotdotdot="…">${centerOneCharCategoryItem.title}</epg:text>
			<epg:img id="r_centerOneChar${curIdx}" src="./images/dot.gif" width="140" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" rememberFocus="true" href="${indexOneUrl}&pi=${curIdx}" height="26" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y}" />
			<epg:img id="r_centerOneChar${curIdx}_img" style="visibility:hidden;border:3px solid #ff9c13;" src="./images/dot.gif" width="140" height="26" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-4}" />
		</epg:grid>

		<!-- 中间2-->
		<epg:if test="${centerTwoCategoryItems!=null}">
			<epg:img id="r_centerTwo1_show" src="../${centerTwoCategoryItems.itemIcon}" width="140" height="140" left="955" top="176" />
			<div id="r_centerTwo1_titlediv" style="position: absolute; font-size: 22px; color: #FFFFFF; opacity: 0.7; text-align: center; background-color: #020000; left:955px; top: 286px; width: 140px; height: 30px; z-index: 1;">
				<epg:text color="#ffffff" id="r_centerTwo1" left="-30" align="left" width="140" fontSize="22" chineseCharNumber="12" dotdotdot="…">${centerTwoCategoryItems.title}</epg:text>
			</div>
			<epg:navUrl obj="${centerTwoCategoryItems}" indexUrlVar="indexTwoUrl1" />
			<epg:img id="r_centerTwo1" src="./images/dot.gif" width="140" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" rememberFocus="true" href="${indexTwoUrl1}&pi=1" height="140" left="954" top="173" />
			<epg:img id="r_centerTwo1_img" style="visibility:hidden;border:3px solid #ff9c13;" src="./images/dot.gif" width="137" height="140" left="954" top="173" />
		</epg:if>
		<epg:grid column="1" row="2" left="955" top="324" width="140" height="54" vcellspacing="10" items="${centerTwoCharCategoryItems}" var="centerTwoCharCategoryItem" indexVar="curIdx" posVar="positions">
			<epg:navUrl obj="${centerTwoCharCategoryItem}" indexUrlVar="indexTwoUrl" />
			<epg:text color="#ffffff" id="r_centerTwoChar${curIdx}" left="${positions[curIdx-1].x-30}" align="left" top="${positions[curIdx-1].y}" width="140" fontSize="22" chineseCharNumber="12" dotdotdot="…">${centerTwoCharCategoryItem.title}</epg:text>
			<epg:img id="r_centerTwoChar${curIdx}" src="./images/dot.gif" width="140" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" rememberFocus="true" href="${indexTwoUrl}&pi=${curIdx}" height="26" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y}" />
			<epg:img id="r_centerTwoChar${curIdx}_img" style="visibility:hidden;border:3px solid #ff9c13;" src="./images/dot.gif" width="140" height="26" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-4}" />
		</epg:grid>

		<!-- 中间3-->
		<epg:if test="${centerThreeCategoryItems!=null}">
			<epg:img id="r_centerThree1_show" src="../${centerThreeCategoryItems.itemIcon}" width="140" height="140" left="1105" top="176" />
			<div id="r_centerThree1_titlediv" style="position: absolute; font-size: 22px; color: #FFFFFF; opacity: 0.7; text-align: center; background-color: #020000; left:1105px; top: 286px; width: 140px; height: 30px; z-index: 1;">
				<epg:text color="#ffffff" id="r_centerThree1" left="-30" align="left" width="140" fontSize="22" chineseCharNumber="12" dotdotdot="…">${centerThreeCategoryItems.title}</epg:text>
			</div>
			<epg:navUrl obj="${centerThreeCategoryItems}" indexUrlVar="indexThreeUrl1" />
			<epg:img id="r_centerThree1" src="./images/dot.gif" width="140" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" rememberFocus="true" href="${indexThreeUrl1}&pi=1" height="140" left="1104" top="173" />
			<epg:img id="r_centerThree1_img" style="visibility:hidden;border:3px solid #ff9c13;" src="./images/dot.gif" width="137" height="140" left="1104" top="173" />
		</epg:if>
		<epg:grid column="1" row="2" left="1105" top="324" width="140" height="54" vcellspacing="10" items="${centerThreeCharCategoryItems}" var="centerThreeCharCategoryItem" indexVar="curIdx" posVar="positions">
			<epg:navUrl obj="${centerThreeCharCategoryItem}" indexUrlVar="indexThreeUrl" />
			<epg:text color="#ffffff" id="r_centerThreeChar${curIdx}" left="${positions[curIdx-1].x-30}" align="left" top="${positions[curIdx-1].y}" width="140" fontSize="22" chineseCharNumber="12" dotdotdot="…">${centerThreeCharCategoryItem.title}</epg:text>
			<epg:img id="r_centerThreeChar${curIdx}" src="./images/dot.gif" width="140" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" rememberFocus="true" href="${indexThreeUrl}&pi=${curIdx}" height="26" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y}" />
			<epg:img id="r_centerThreeChar${curIdx}_img" style="visibility:hidden;border:3px solid #ff9c13;" src="./images/dot.gif" width="140" height="26" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-4}" />
		</epg:grid>

		<!-- 人气最高-->
		<epg:grid column="6" row="1" left="805" top="453" width="440" height="195" hcellspacing="20" items="${downCategoryItems}" var="downCategoryItem" indexVar="curIdx" posVar="positions">
			<epg:navUrl obj="${downCategoryItem}" indexUrlVar="indexUrl" />
			<epg:img id="r_down_img${curIdx}" src="../${downCategoryItem.still}" width="65" height="195" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" />
			<epg:img id="r_downfocus${curIdx}" src="./images/dot.gif" width="65" rememberFocus="true" href="${indexUrl}&pi=${curIdx}" height="195" left="${positions[curIdx-1].x-3}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" top="${positions[curIdx-1].y-3}" />
			<epg:img id="r_downfocus${curIdx}_img" src="./images/dot.gif" width="62" style="visibility:hidden;border:3px solid #ff9c13;" height="195" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" />
		</epg:grid>
	</div>

</epg:body>
</epg:html>