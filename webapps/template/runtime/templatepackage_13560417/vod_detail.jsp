<%@page contentType="text/html; charset=GBK" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@page import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*"%>
<%
	String leaveFocusId = request.getParameter("leaveFocusId");
	if (leaveFocusId != null && leaveFocusId != "") {
		EpgUserSession eus = EpgUserSession.findUserSession(request);
		eus.setPlayFocusId(leaveFocusId);
	}
%>
<html>

<!-- 查询节目信息-->
<epg:query queryName="queryProgramDetailByCode" var="program">
	<epg:param name="contentCode" value="${context['EPG_CONTENT_CODE']}" type="java.lang.String" />
</epg:query>

<epg:set value="1" var="ProgramBodyType" />
<epg:set value="1" var="hdType" />
<epg:set value="0" var="sdType" />
<epg:if test="${program.relCode!=null}">
	<!-- HD正片 -->
	<epg:query queryName="queryRelContentByRelCodeAndType" maxRows="1" var="HDrelContent">
		<epg:param name="relCode" value="${program.relCode}" type="java.lang.String" />
		<epg:param name="bodyType" value="${ProgramBodyType}" type="java.lang.Integer" />
		<epg:param name="videoType" value="${hdType}" type="java.lang.Integer" />
		<epg:param name="type" value="vod" type="java.lang.String" />
	</epg:query>
	<!-- SD正片 -->
	<epg:query queryName="queryRelContentByRelCodeAndType" maxRows="1" var="SDrelContent">
		<epg:param name="relCode" value="${program.relCode}" type="java.lang.String" />
		<epg:param name="bodyType" value="${ProgramBodyType}" type="java.lang.Integer" />
		<epg:param name="videoType" value="${sdType}" type="java.lang.Integer" />
		<epg:param name="type" value="vod" type="java.lang.String" />
	</epg:query>
</epg:if>

<!-- 右下方推荐随机内容  -->
<epg:set var="tags" value="${fn:split(program.tags, ',')}"></epg:set>
<epg:set var="tag" value="${tags[0]}"></epg:set>
<epg:if test="${tag=='高清'}">
	<epg:set var="tag" value="${tags[1]}"></epg:set>
</epg:if>
<epg:query queryName="getSeverialItemsByTagsRandomIncludePic" maxRows="5" var="bottomCategoryItems">
	<epg:param name="tags" value="${tag}" type="java.lang.String" />
	<epg:param name="selfCode" value="${program.contentCode}" type="java.lang.String" />
	<epg:param name="mainFolder" value="${program.mainFolder}" type="java.lang.String" />
</epg:query>
<!-- tag: ${tag} -->
<!-- selfCode: ${program.contentCode} -->
<!-- mainFolder: ${program.mainFolder} -->

<!-- 播放、收藏、返回 -->
<epg:navUrl obj="${program}" playUrlVar="playUrl"></epg:navUrl>
<epg:navUrl returnTo="${param.returnTo}" returnUrlVar="returnUrl"></epg:navUrl>
<epg:navUrl returnTo="home" returnUrlVar="returnToHomeUrl"></epg:navUrl>

<!-- 节目简介与主演 -->
<epg:text left="0" top="0" width="850" height="210" chineseCharWidth="22" multi="true" output="false" lines="summarys" lineNum="3">${program.summaryMedium}</epg:text>

<!-- 回点播首页 -->
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>

<style>
img {
	border: 0px;
}

#info_span {
	display: block;
	line-height: 41px;
	height: 35px;
}

body {
	color: #FFFFFF;
	font-size: 22;
	font-family: "黑体";
}

a {
	outline: none;
}
</style>
<script src="${context['EPG_CONTEXT']}/js/ajax.js"></script>
<script type="text/javascript">
	var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images";
	var _level = "${program.reserve1}";
	var _ajaxObj = null;
	var leaveFocusId;
	function $(_id) {
		return "string" == typeof _id ? document.getElementById(_id) : _id;
	}
	function returnToBizOrHistory() {
		if ("${param.returnTo}" != "" && "${param.returnTo}" != null) {
			window.location.href = "${returnUrl}";
		} else {
			history.back();
		}
	}
	function init() {
		setTimeout('$("play_a").focus()', 400);
	}
	
	//收藏AJAX
	function addCollection() {
		$("addCol_img").src = imgPath + "/dot.gif";
		$("r_addCol_img").src = imgPath + "/dot.gif";
		var encodeContentName = encodeURIComponent("${program.title}");
		var encodeContentImg = encodeURIComponent("${program.still}");
		var ajax_url = "${context['EPG_CONTEXT']}/addMyCollection.do?userMac=${EPG_USER.userAccount}&contentType=vod&contentCode=${program.contentCode}&contentName="
				+ encodeContentName
				+ "&still="
				+ encodeContentImg
				+ "&bizCode=${context['EPG_BUSINESS_CODE']}&categoryCode=${context['EPG_CATEGORY_CODE']}&hdType=${program.hdType}";
		_ajaxObj = new AJAX_OBJ(ajax_url, addColResponse);
		_ajaxObj.requestData();
	}
	
	function addColResponse(xmlHttpResponse) {
		var result = eval("(" + xmlHttpResponse.responseText + ")");
		displayDiv("none");
		if (result.collectResult == 'collectSuccess') {
			$("collectSuccess").style.display = "block";
			$("tsBtn").style.display = "block";
			$("successTs_span").innerHTML = "收藏夹中共有<font color=#00fcff>" + result.totalCount + "</font>部片子";
			$("r_collectSuccess").style.display = "block";
			$("r_tsBtn").style.display = "block";
			$("r_successTs_span").innerHTML = "收藏夹中共有<font color=#00fcff>" + result.totalCount + "</font>部片子";
		} else if (result.collectResult == 'collectExist') {
			$("collectFail").style.display = "block";
			$("tsBtn").style.display = "block";
			$("failTs_span").innerHTML = "您已经收藏过此节目。";
			$("r_collectFail").style.display = "block";
			$("r_tsBtn").style.display = "block";
			$("r_failTs_span").innerHTML = "您已经收藏过此节目。";
		} else if (result.collectResult == 'collectLimit') {
			$("collectFail").style.display = "block";
			$("tsBtn").style.display = "block";
			$("failTs_span").innerHTML = "收藏节目数量超出最大限制。";
			$("r_collectFail").style.display = "block";
			$("r_tsBtn").style.display = "block";
			$("r_failTs_span").innerHTML = "收藏节目数量超出最大限制。";
		} else {
			$("collectFail").style.display = "block";
			$("tsBtn").style.display = "block";
			$("failTs_span").innerHTML = "节目收藏失败。";
			$("r_collectFail").style.display = "block";
			$("r_tsBtn").style.display = "block";
			$("r_failTs_span").innerHTML = "节目收藏失败。";
		}
		setTimeout('$("enter_a").focus()', 400);
	}

	//收藏提示消失
	function hiddenTip() {
		$("failTs_span").innerHTML = "";
		$("successTs_span").innerHTML = "";
		$("collectSuccess").style.display = "none";
		$("collectFail").style.display = "none";
		$("tsBtn").style.display = "none";
		displayDiv("block");
		$("r_failTs_span").innerHTML = "";
		$("r_successTs_span").innerHTML = "";
		$("r_collectSuccess").style.display = "none";
		$("r_collectFail").style.display = "none";
		$("r_tsBtn").style.display = "none";
	}

	//弹窗时隐藏层下a
	function displayDiv(_set) {
		var el = [];
		el = document.getElementsByTagName('a');
		for ( var i = 0, len = el.length; i < len; i++) {
			if (el[i].id != "Collection_a" && el[i].id != "enter_a") {
				$(el[i].id).style.display = _set;
			}
		}
	}

	//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名
	function itemOnFocus(objId, img) {
		if("r_" == objId.substr(0,2)){
			objId = objId.substr(2,objId.length)
		}
		leaveFocusId = objId;
		$(objId + "_img").src = imgPath + "/" + img + ".png";
		$("r_" + objId + "_img").src = imgPath + "/" + img + ".png";
	}
	//失去焦点事件
	function itemOnBlur(objId) {
		if("r_" == objId.substr(0,2)){
			objId = objId.substr(2,objId.length)
		}
		$(objId + "_img").src = imgPath + "/dot.gif";
		$("r_" + objId + "_img").src = imgPath + "/dot.gif";
	}

	//获取字符长度
	function len(s) {
		var l = 0;
		var a = s.split("");
		for ( var i = 0; i < a.length; i++) {
			if (a[i].charCodeAt(0) < 299) {
				l++;
			} else {
				l += 2;
			}
		}
		return l;
	}

	//海报焦点事件
	function textOnFocus(objId, img, itemId, title) {
		document.getElementById("posterImg" + objId + "_img").src = imgPath + "/" + img + ".png";
		document.getElementById(itemId).style.visibility = "visible";
		document.getElementById("r_posterImg" + objId + "_img").src = imgPath + "/" + img + ".png";		//3D
		document.getElementById("r_"+itemId).style.visibility = "visible";								//3D
		var textContent = title;	//document.getElementById("posterImg"+objId+"_span").innerHTML;
		var textLen = len(textContent);
		textContent = textContent.replace(/^\s+|\s+$/g, "");
		if (textContent.substring(0, 3) == "HD_") {
			textContent = textContent.substring(3, textLen);
		}
		if (len(textContent) <= 10) {
			document.getElementById(itemId).style.height = "31px";
			document.getElementById(itemId).style.top = "632px";
			document.getElementById("r_"+itemId).style.height = "31px";	//3D
			document.getElementById("r_"+itemId).style.top = "632px";	//3D
		} else if (len(textContent) > 10 && len(textContent) <= 20) {
			document.getElementById(itemId).style.height = "56px";
			document.getElementById(itemId).style.top = "607px";
			document.getElementById("r_"+itemId).style.height = "56px";		//3D
			document.getElementById("r_"+itemId).style.top = "607px";		//3D
		} else {
			document.getElementById(itemId).style.height = "56px";
			document.getElementById(itemId).style.top = "607px";
			document.getElementById("r_"+itemId).style.height = "56px";		//3D
			document.getElementById("r_"+itemId).style.top = "607px";		//3D
			textContent = textContent.substring(0, 8) + "…";
		}
		document.getElementById("posterImg" + objId + "_span").innerHTML = textContent;
		document.getElementById("r_posterImg" + objId + "_span").innerHTML = textContent;	//3D
	}
	function textOnBlur(objId, itemId) {
		document.getElementById(objId + "_img").src = imgPath + "/dot.gif";
		document.getElementById(itemId).style.visibility = "hidden";
		document.getElementById("r_"+objId + "_img").src = imgPath + "/dot.gif";	//3D
		document.getElementById("r_"+itemId).style.visibility = "hidden";			//3D
	}

	function back() {
		returnToBizOrHistory();
	}
	function exit() {
		document.location.href = "${returnToHomeUrl}";
	}

	function eventHandler(eventObj) {
		switch (eventObj.code) {
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
</script>
<epg:body onload="init();" bgcolor="#000000" width="1280" height="720">
<div id="leftDiv">
	<epg:img src="./images/vod_detail.jpg" id="main" left="0" top="0" width="640" height="720" />
	<epg:img src="./images/logo.png" left="0" top="0" width="175" height="85" />
	<epg:if test="${fn:startsWith(program.title,'HD_') == true }">
		<epg:img src="./images/hd_cinema_title.png" left="115" top="42" width="59" height="44" />
	</epg:if>
	<epg:if test="${fn:startsWith(program.title,'HD_') != true }">
		<epg:img src="./images/sd_cinema_title.png" left="115" top="42" width="59" height="44" />
	</epg:if>
	<!-- 节目名 -->
	<epg:text id="theName" fontSize="22" color="#e74c3c" left="175" top="101" width="310" height="50" align="left" chineseCharNumber="17" text="${program.title}"></epg:text>

	<!-- 地区 -->
	<epg:text id="text1_l" fontSize="22" color="#333333" left="175" top="193" width="86" height="32" align="left" text="地区："></epg:text>
	<epg:text id="text1_r" fontSize="22" color="#333333" left="235" top="193" width="546" height="32" chineseCharNumber="17" align="left" text="${program.countryOfOrigin}"></epg:text>

	<!-- 年份 -->
	<epg:text id="text2_l" fontSize="22" color="#333333" left="175" top="225" width="86" height="32" align="left" text="年份："></epg:text>
	<epg:text id="text2_r" fontSize="22" color="#333333" left="235" top="225" width="546" height="32" chineseCharNumber="17" align="left" text="${program.year}"></epg:text>

	<!-- 片长 -->
	<epg:text id="text3_l" fontSize="22" color="#333333" left="175" top="258" width="86" height="32" align="left" text="片长："></epg:text>
	<epg:text id="text3_r" fontSize="22" color="#333333" left="235" top="258" width="546" height="32" chineseCharNumber="17" align="left" text="${program.displayRunTime}分钟"></epg:text>
	
	<!-- 导演 -->
	<epg:text id="text4_l" fontSize="20" color="#333333" left="22" top="433" width="80" height="27" align="left" text="导演："></epg:text>
	<epg:if test="${program.director!=null}">
		<epg:text id="directorImg" fontSize="18" color="#333333" left="80" top="433" width="200" height="30" chineseCharNumber="9" align="left" dotdotdot="…" text="${program.director}"></epg:text>
	</epg:if>
	
	<!-- 主演 -->
	<epg:text id="text5_l" fontSize="20" color="#333333" left="22" top="465" width="80" height="27" align="left" text="主演："></epg:text>
	<epg:set var="actors" value="${fn:replace(program.actors, '，',',')}"></epg:set>
	<epg:set var="actors" value="${fn:split(actors, ',')}"></epg:set>

	<epg:if test="${actors==''}">
		<epg:text fontSize="20" color="#333333" left="68" top="465" width="67" height="22" align="left" text="无"></epg:text>
	</epg:if>
	<epg:text id="text5_r_1" fontSize="18" color="#333333" left="80" top="465" chineseCharNumber="9" dotdotdot="…" width="200" height="22" align="left" text="${actors[0]}"></epg:text>
	<epg:text id="text5_r_2" fontSize="18" color="#333333" left="80" top="505" chineseCharNumber="9" dotdotdot="…" width="200" height="22" align="left" text="${actors[1]}"></epg:text>
	<epg:text id="text5_r_3" fontSize="18" color="#333333" left="80" top="545" chineseCharNumber="9" dotdotdot="…" width="200" height="22" align="left" text="${actors[2]}"></epg:text>
	<epg:text id="text5_r_4" fontSize="18" color="#333333" left="80" top="585" chineseCharNumber="9" dotdotdot="…" width="200" height="22" align="left" text="${actors[3]}"></epg:text>

	<!-- 播放收藏 -->
	<epg:img id="play" onblur="itemOnBlur('play');" left="175" top="151" onfocus="itemOnFocus('play','playFocus')" src="./images/dot.gif" width="65" height="30" href="${context['EPG_CONTEXT']}/3DPlay/play.html" /><!-- ${playUrl} -->
	<epg:if test="${program.hdType=='1'}">
		<epg:if test="${SDrelContent!=null}">
			<epg:if test="${SDrelContent.relCodeFlag==1}">
				<epg:navUrl obj="${SDrelContent}" indexUrlVar="SDplayUrl" />
				<epg:img onblur="itemOnBlur('goHDorSDFocus');" left="245" top="151" onfocus="itemOnFocus('goHDorSDFocus','goSDFocus')" src="./images/goSDBtn.png" width="65" height="30" href="${SDplayUrl}" />

				<epg:navUrl obj="${program}" addCollectionUrlVar="addCollectionUrl" />
				<epg:img onblur="itemOnBlur('addCol');" left="315" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="./images/addColBtn.png" width="65" height="30" href="javascript:addCollection()" />
				<epg:img id="addCol" left="315" top="151" src="./images/dot.gif" width="65" height="30" />
			</epg:if>
			<epg:if test="${SDrelContent.relCodeFlag==0}">
				<epg:navUrl obj="${program}" addCollectionUrlVar="addCollectionUrl" />
				<epg:img onblur="itemOnBlur('addCol');" left="245" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="./images/addColBtn.png" width="65" height="30" href="javascript:addCollection()" />
				<epg:img id="addCol" left="245" top="151" src="./images/dot.gif" width="65" height="30" />
			</epg:if>
		</epg:if>
		<epg:if test="${SDrelContent==null}">
			<epg:navUrl obj="${program}" addCollectionUrlVar="addCollectionUrl" />
			<epg:img onblur="itemOnBlur('addCol');" left="245" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="./images/addColBtn.png" width="65" height="30" href="javascript:addCollection()" />
			<epg:img id="addCol" left="245" top="151" src="./images/dot.gif" width="65" height="30" />
		</epg:if>
	</epg:if>

	<epg:if test="${program.hdType=='0'}">
		<epg:if test="${HDrelContent!=null}">
			<epg:if test="${HDrelContent.relCodeFlag==1}">
				<epg:navUrl obj="${HDrelContent}" indexUrlVar="HDplayUrl" />
				<epg:img onblur="itemOnBlur('goHDorSDFocus');" left="245" top="151" onfocus="itemOnFocus('goHDorSDFocus','goHDFocus')" src="./images/goHDBtn.png" width="65" height="30" href="${HDplayUrl}" />

				<epg:navUrl obj="${program}" addCollectionUrlVar="addCollectionUrl" />
				<epg:img onblur="itemOnBlur('addCol');" left="315" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="./images/addColBtn.png" width="65" height="30" href="javascript:addCollection()" />
				<epg:img id="addCol" left="315" top="151" src="./images/dot.gif" width="65" height="30" />
			</epg:if>
			<epg:if test="${HDrelContent.relCodeFlag==0}">
				<epg:navUrl obj="${program}" addCollectionUrlVar="addCollectionUrl" />
				<epg:img onblur="itemOnBlur('addCol');" left="245" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="./images/addColBtn.png" width="65" height="30" href="javascript:addCollection()" />
				<epg:img id="addCol" left="245" top="151" src="./images/dot.gif" width="65" height="30" />
			</epg:if>
		</epg:if>
		<epg:if test="${HDrelContent==null}">
			<epg:navUrl obj="${program}" addCollectionUrlVar="addCollectionUrl" />
			<epg:img onblur="itemOnBlur('addCol');" left="245" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="./images/addColBtn.png" width="65" height="30" href="javascript:addCollection()" />
			<epg:img id="addCol" left="245" top="151" src="./images/dot.gif" width="65" height="30" />
		</epg:if>
	</epg:if>
	<epg:img id="goHDorSDFocus" left="245" top="151" src="./images/dot.gif" width="65" height="30" />
	
	<!-- 内容详情 -->
	<epg:text fontSize="16" color="#333333" id="info" left="175" top="287" width="850" height="35" align="left" text="${summarys[0].content}"></epg:text>
	<epg:text fontSize="16" color="#333333" id="info" left="175" top="320" width="850" height="35" align="left" text="${summarys[1].content}"></epg:text>
	<epg:text fontSize="16" color="#333333" id="info" left="175" top="353" width="850" height="35" align="left" text="${summarys[2].content}"></epg:text>
	
	<!-- 内容海报 -->
	<epg:img id="poster" left="40" top="93" width="110" height="330" src="../${program.icon}" />
	<!-- 看过此片的人还关注 -->
	<epg:if test="${bottomCategoryItems[0]!=null}">
		<epg:img id="posterImg0" src="./images/dot.gif" left="174" top="465" width="68" height="201" />
		<epg:navUrl obj="${bottomCategoryItems[0]}" indexUrlVar="indexUrl1"></epg:navUrl>
		<epg:img id="poster1" src="../content/201406/07/133997.jpg" left="175" top="468" width="65" height="195" />
		<epg:img id="poster1focus" src="./images/dot.gif" left="175" top="468" width="65" height="195" href="${indexUrl1}&returnTo=biz" onfocus="textOnFocus('0','orange3','categoryList0_titlediv','一九四二');" onblur="textOnBlur('posterImg0','categoryList0_titlediv');" />
		<div id="categoryList0_titlediv" style="position: absolute; font-size: 22; font-family: '黑体'; color: #FFFFFF; text-align: center; background-color: #f79922; visibility: hidden; left:175px; top: 633px; width:65px; height: 31px; z-index: 1;">
			<div id="posterImg0" align="center" style="position: absolute; left:-33px; top: 3px; width:130px; height: 26px">
				<span id="posterImg0_span" style="color: #ffffff; font-size: 22;"></span>
			</div>
		</div>
	</epg:if>

	<epg:if test="${bottomCategoryItems[1]!=null}">
		<epg:img id="posterImg1" src="./images/dot.gif" left="264" top="465" width="68" height="201" />
		<epg:navUrl obj="${bottomCategoryItems[1]}" indexUrlVar="indexUrl2"></epg:navUrl>
		<epg:img id="poster2" src="../content/201406/07/133947.jpg" left="265" top="463" width="65" height="195" />
		<epg:img id="poster2focus" src="./images/dot.gif" left="265" top="468" width="65" height="195" href="${indexUrl2}&returnTo=biz" onfocus="textOnFocus('1','orange3','categoryList1_titlediv','止杀令');" onblur="textOnBlur('posterImg1','categoryList1_titlediv');" />
		<div id="categoryList1_titlediv" style="position: absolute; font-size: 22; font-family: '黑体'; color: #FFFFFF; text-align: center; background-color: #f79922; visibility: hidden; left:265px; top: 633px; width:65px; height: 31px; z-index: 1;">
			<div id="posterImg1" align="center" style="position: absolute; left:-33px; top: 3px; width:130px; height: 26px">
				<span id="posterImg1_span" style="color: #ffffff; font-size: 22; height: 26px"></span>
			</div>
		</div>
	</epg:if>

	<epg:if test="${bottomCategoryItems[2]!=null}">
		<epg:img id="posterImg2" src="./images/dot.gif" left="354" top="465" width="68" height="201" />
		<epg:navUrl obj="${bottomCategoryItems[2]}" indexUrlVar="indexUrl3"></epg:navUrl>
		<epg:img id="poster3" src="../content/201406/07/154911.jpg" left="355" top="458" width="65" height="195" />
		<epg:img id="poster3focus" src="./images/dot.gif" left="355" top="468" width="65" height="195" href="${indexUrl3}&returnTo=biz" onfocus="textOnFocus('2','orange3','categoryList2_titlediv','正骨');" onblur="textOnBlur('posterImg2','categoryList2_titlediv');" />
		<div id="categoryList2_titlediv" style="position: absolute; font-size: 22; font-family: '黑体'; color: #FFFFFF; text-align: center; background-color: #f79922; visibility: hidden; left:355px; top: 633px; width:65px; height: 31px; z-index: 1;">
			<div id="posterImg2" align="center" style="position: absolute; left:-33px; top: 3px; width:130px; height: 26px">
				<span id="posterImg2_span" style="color: #ffffff; font-size: 22;"></span>
			</div>
		</div>
	</epg:if>
	
	<epg:if test="${bottomCategoryItems[3]!=null}">
		<epg:img id="posterImg3" src="./images/dot.gif" left="444" top="465" width="68" height="201" />
		<epg:navUrl obj="${bottomCategoryItems[3]}" indexUrlVar="indexUrl4"></epg:navUrl>
		<epg:img id="poster4" src="../content/201406/07/149850.jpg" left="445" top="463" width="65" height="195" />
		<epg:img id="poster4focus" src="./images/dot.gif" left="445" top="468" width="65" height="195" href="${indexUrl4}&returnTo=biz" onfocus="textOnFocus('3','orange3','categoryList3_titlediv','初到东京');" onblur="textOnBlur('posterImg3','categoryList3_titlediv');" />
		<div id="categoryList3_titlediv" style="position: absolute; font-size: 22; font-family: '黑体'; color: #FFFFFF; text-align: center; background-color: #f79922; visibility: hidden; left:445px; top: 633px; width:65px; height: 31px; z-index: 1;">
			<div id="posterImg3" align="center" style="position: absolute; left:-33px; top: 3px; width:130px; height: 26px">
				<span id="posterImg3_span" style="color: #ffffff; font-size: 22;"></span>
			</div>
		</div>
	</epg:if>
	
	<epg:if test="${bottomCategoryItems[4]!=null}">
		<epg:img id="posterImg4" src="./images/dot.gif" left="534" top="465" width="68" height="201" />
		<epg:navUrl obj="${bottomCategoryItems[4]}" indexUrlVar="indexUrl5"></epg:navUrl>
		<epg:img id="poster5" src="../content/201406/07/150115.jpg" left="535" top="468" width="65" height="195" />
		<epg:img id="poster5focus" src="./images/dot.gif" left="535" top="468" width="65" height="195" href="${indexUrl5}&returnTo=biz" onfocus="textOnFocus('4','orange3','categoryList4_titlediv','亨利的罪行');" onblur="textOnBlur('posterImg4','categoryList4_titlediv');" />
		<div id="categoryList4_titlediv" style="position: absolute; font-size: 22; font-family: '黑体'; color: #FFFFFF; text-align: center; background-color: #f79922; visibility: hidden; left:535px; top: 633px; width:65px; height: 31px; z-index: 1;">
			<div id="posterImg4" align="center" style="position: absolute; left:-33px; top: 3px; width:130px; height: 26px">
				<span id="posterImg4_span" style="color: #ffffff; font-size: 22;"></span>
			</div>
		</div>
	</epg:if>

	<!-- 搜索,收藏,历史,返回 -->
	<epg:img src="./images/dot.gif" id="ss" left="475" top="47" width="40" height="38" href="${context['EPG_SEARCH_URL']}" onfocus="itemOnFocus('ss','focusMenuTop_1');" onblur="itemOnBlur('ss');" />

	<epg:img src="./images/dot.gif" id="zz" left="525" top="47" width="40" height="38" href="${context['EPG_SELF_URL']}" onfocus="itemOnFocus('zz','zizhuFocus');" onblur="itemOnBlur('zz');" />

	<epg:img src="./images/dot.gif" id="zn" left="575" top="47" width="40" height="38" href="javascript:back();" onfocus="itemOnFocus('zn','focusMenuTop_3');" onblur="itemOnBlur('zn');" />

	<!-- 收藏提示框 -->
	<div id="collectSuccess" style="display: none;">
		<epg:img id="tip" src="./images/collectSuccess.png" left="0" top="0" width="640" height="720" />
		<epg:text id="successTs" fontSize="22" color="#565656" left="200" top="327" width="240" height="30" align="center" chineseCharNumber="17" text=""></epg:text>
	</div>
	<div id="collectFail" style="display: none;">
		<epg:img id="tip" src="./images/collectFail.png" left="0" top="0" width="640" height="720" />
		<epg:text id="failTs" fontSize="22" color="#565656" left="200" top="327" width="240" height="30" align="center" chineseCharNumber="17" text=""></epg:text>
	</div>
	<div id="tsBtn" style="display: none;">
		<epg:img id="Collection" left="241" top="412" onfocus="itemOnFocus('Collection','enterColl');" onblur="itemOnBlur('Collection');" src="./images/dot.gif" width="65" height="40" href="${context['EPG_MYCOLLECTION_URL']}" />
		<epg:img id="enter" left="336" top="412" onfocus="itemOnFocus('enter','closeWin');" onblur="itemOnBlur('enter');" src="./images/dot.gif" width="65" height="40" href="javascript:hiddenTip()" />
	</div>
</div>
<div id="rightDiv">
	<epg:img src="./images/vod_detail.jpg" id="r_main" left="640" top="0" width="640" height="720" />
	<epg:img src="./images/logo.png" left="640" top="0" width="175" height="85" />
	<epg:if test="${fn:startsWith(program.title,'HD_') == true }">
		<epg:img src="./images/hd_cinema_title.png" left="755" top="42" width="59" height="44" />
	</epg:if>
	<epg:if test="${fn:startsWith(program.title,'HD_') != true }">
		<epg:img src="./images/sd_cinema_title.png" left="755" top="42" width="59" height="44" />
	</epg:if>
	<!-- 节目名 -->
	<epg:text id="r_theName" fontSize="22" color="#e74c3c" left="815" top="101" width="310" height="50" align="left" chineseCharNumber="17" text="${program.title}"></epg:text>

	<!-- 地区 -->
	<epg:text id="r_text1_l" fontSize="22" color="#333333" left="815" top="193" width="86" height="32" align="left" text="地区："></epg:text>
	<epg:text id="r_text1_r" fontSize="22" color="#333333" left="875" top="193" width="546" height="32" chineseCharNumber="17" align="left" text="${program.countryOfOrigin}"></epg:text>

	<!-- 年份 -->
	<epg:text id="r_text2_l" fontSize="22" color="#333333" left="815" top="225" width="86" height="32" align="left" text="年份："></epg:text>
	<epg:text id="r_text2_r" fontSize="22" color="#333333" left="875" top="225" width="546" height="32" chineseCharNumber="17" align="left" text="${program.year}"></epg:text>

	<!-- 片长 -->
	<epg:text id="r_text3_l" fontSize="22" color="#333333" left="815" top="258" width="86" height="32" align="left" text="片长："></epg:text>
	<epg:text id="r_text3_r" fontSize="22" color="#333333" left="875" top="258" width="546" height="32" chineseCharNumber="17" align="left" text="${program.displayRunTime}分钟"></epg:text>
	
	<!-- 导演 -->
	<epg:text id="r_text4_l" fontSize="21" color="#333333" left="662" top="433" width="80" height="27" align="left" text="导演："></epg:text>
	<epg:if test="${program.director!=null}">
		<epg:text id="r_directorImg" fontSize="18" color="#333333" left="720" top="433" width="200" height="30" chineseCharNumber="9" align="left" dotdotdot="…" text="${program.director}"></epg:text>
	</epg:if>
	
	<!-- 主演 -->
	<epg:text id="r_text5_l" fontSize="21" color="#333333" left="662" top="465" width="80" height="27" align="left" text="主演："></epg:text>
	
	<epg:set var="actors" value="${fn:replace(program.actors, '，',',')}"></epg:set>
	<epg:set var="actors" value="${fn:split(actors, ',')}"></epg:set>

	<epg:if test="${actors==''}">
		<epg:text fontSize="21" color="#333333" left="708" top="465" width="67" height="22" align="left" text="无"></epg:text>
	</epg:if>
	<epg:text id="r_text5_r_1" fontSize="18" color="#333333" left="720" top="465" chineseCharNumber="9" dotdotdot="…" width="200" height="22" align="left" text="${actors[0]}"></epg:text>
	<epg:text id="r_text5_r_2" fontSize="18" color="#333333" left="720" top="505" chineseCharNumber="9" dotdotdot="…" width="200" height="22" align="left" text="${actors[1]}"></epg:text>
	<epg:text id="r_text5_r_3" fontSize="18" color="#333333" left="720" top="545" chineseCharNumber="9" dotdotdot="…" width="200" height="22" align="left" text="${actors[2]}"></epg:text>
	<epg:text id="r_text5_r_4" fontSize="18" color="#333333" left="720" top="585" chineseCharNumber="9" dotdotdot="…" width="200" height="22" align="left" text="${actors[3]}"></epg:text>

	<!-- 播放收藏 -->
	<!-- 1 -->
	<epg:img id="r_play" onblur="itemOnBlur('play');" left="815" top="151" onfocus="itemOnFocus('play','playFocus')" src="./images/dot.gif" width="65" height="30" href="${context['EPG_CONTEXT']}/3DPlay/play.html" /><!-- ${playUrl} -->
	<epg:if test="${program.hdType=='1'}">
		<epg:if test="${SDrelContent!=null}">
			<epg:if test="${SDrelContent.relCodeFlag==1}">
				<epg:navUrl obj="${SDrelContent}" indexUrlVar="SDplayUrl" />
				<epg:img onblur="itemOnBlur('goHDorSDFocus');" left="885" top="151" onfocus="itemOnFocus('goHDorSDFocus','goSDFocus')" src="./images/goSDBtn.png" width="65" height="30" href="${SDplayUrl}" />

				<epg:navUrl obj="${program}" addCollectionUrlVar="addCollectionUrl" />
				<epg:img onblur="itemOnBlur('addCol');" left="955" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="./images/addColBtn.png" width="65" height="30" href="javascript:addCollection()" />
				<epg:img id="r_addCol" left="955" top="151" src="./images/dot.gif" width="65" height="30" />
			</epg:if>
			<epg:if test="${SDrelContent.relCodeFlag==0}">
				<epg:navUrl obj="${program}" addCollectionUrlVar="addCollectionUrl" />
				<epg:img onblur="itemOnBlur('addCol');" left="885" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="./images/addColBtn.png" width="65" height="30" href="javascript:addCollection()" />
				<epg:img id="r_addCol" left="885" top="151" src="./images/dot.gif" width="65" height="30" />
			</epg:if>
		</epg:if>
		<epg:if test="${SDrelContent==null}">
			<epg:navUrl obj="${program}" addCollectionUrlVar="addCollectionUrl" />
			<epg:img onblur="itemOnBlur('addCol');" left="885" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="./images/addColBtn.png" width="65" height="30" href="javascript:addCollection()" />
			<epg:img id="r_addCol" left="885" top="151" src="./images/dot.gif" width="65" height="30" />
		</epg:if>
	</epg:if>
	
	<!-- 0 -->
	<epg:if test="${program.hdType=='0'}">
		<epg:if test="${HDrelContent!=null}">
			<epg:if test="${HDrelContent.relCodeFlag==1}">
				<epg:navUrl obj="${HDrelContent}" indexUrlVar="HDplayUrl" />
				<epg:img onblur="itemOnBlur('goHDorSDFocus');" left="885" top="151" onfocus="itemOnFocus('goHDorSDFocus','goHDFocus')" src="./images/goHDBtn.png" width="65" height="30" href="${HDplayUrl}" />

				<epg:navUrl obj="${program}" addCollectionUrlVar="addCollectionUrl" />
				<epg:img onblur="itemOnBlur('addCol');" left="955" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="./images/addColBtn.png" width="65" height="30" href="javascript:addCollection()" />
				<epg:img id="r_addCol" left="955" top="151" src="./images/dot.gif" width="65" height="30" />
			</epg:if>
			<epg:if test="${HDrelContent.relCodeFlag==0}">
				<epg:navUrl obj="${program}" addCollectionUrlVar="addCollectionUrl" />
				<epg:img onblur="itemOnBlur('addCol');" left="885" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="./images/addColBtn.png" width="65" height="30" href="javascript:addCollection()" />
				<epg:img id="r_addCol" left="885" top="151" src="./images/dot.gif" width="65" height="30" />
			</epg:if>
		</epg:if>
		<epg:if test="${HDrelContent==null}">
			<epg:navUrl obj="${program}" addCollectionUrlVar="addCollectionUrl" />
			<epg:img onblur="itemOnBlur('addCol');" left="885" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="./images/addColBtn.png" width="65" height="30" href="javascript:addCollection()" />
			<epg:img id="r_addCol" left="885" top="151" src="./images/dot.gif" width="65" height="30" />
		</epg:if>
	</epg:if>
	<epg:img id="r_goHDorSDFocus" left="885" top="151" src="./images/dot.gif" width="65" height="30" />
	
	<!-- 内容详情 -->
	<epg:text fontSize="16" color="#333333" id="r_info" left="815" top="295" width="850" height="35" align="left" text="${summarys[0].content}"></epg:text>
	<epg:text fontSize="16" color="#333333" id="r_info" left="815" top="328" width="850" height="35" align="left" text="${summarys[1].content}"></epg:text>
	<epg:text fontSize="16" color="#333333" id="r_info" left="815" top="361" width="850" height="35" align="left" text="${summarys[2].content}"></epg:text>
	
	<!-- 内容海报 -->
	<epg:img id="r_poster" left="672" top="93" width="110" height="330" src="../${program.icon}" />
	
	<!-- 看过此片的人还关注 -->
	<epg:if test="${bottomCategoryItems[0]!=null}">
		<epg:img id="r_posterImg0" src="./images/dot.gif" left="814" top="465" width="68" height="201" />
		<epg:navUrl obj="${bottomCategoryItems[0]}" indexUrlVar="indexUrl1"></epg:navUrl>
		<epg:img id="r_poster1" src="../content/201406/07/133997.jpg" left="815" top="468" width="65" height="195" />
		<epg:img id="r_poster1focus" src="./images/dot.gif" left="815" top="468" width="65" height="195" href="${indexUrl1}&returnTo=biz" onfocus="textOnFocus('0','orange3','categoryList0_titlediv','一九四二');" onblur="textOnBlur('posterImg0','categoryList0_titlediv');" />
		<div id="r_categoryList0_titlediv" style="position: absolute; font-size: 22; font-family: '黑体'; color: #FFFFFF; text-align: center; background-color: #f79922; visibility: hidden; left:815px; top: 633px; width:65px; height: 31px; z-index: 1;">
			<div id="r_posterImg0" align="center" style="position: absolute; left:-41px; top: 3px; width:130px; height: 26px">
				<span id="r_posterImg0_span" style="color: #ffffff; font-size: 22;"></span>
			</div>
		</div>
	</epg:if>

	<epg:if test="${bottomCategoryItems[1]!=null}">
		<epg:img id="r_posterImg1" src="./images/dot.gif" left="912" top="465" width="68" height="201" />
		<epg:navUrl obj="${bottomCategoryItems[1]}" indexUrlVar="indexUrl2"></epg:navUrl>
		<epg:img id="r_poster2" src="../content/201406/07/133947.jpg" left="913" top="463" width="65" height="195" />
		<epg:img id="r_poster2focus" src="./images/dot.gif" left="913" top="468" width="65" height="195" href="${indexUrl2}&returnTo=biz" onfocus="textOnFocus('1','orange3','categoryList1_titlediv','止杀令');" onblur="textOnBlur('posterImg1','categoryList1_titlediv');" />
		<div id="r_categoryList1_titlediv" style="position: absolute; font-size: 22; font-family: '黑体'; color: #FFFFFF; text-align: center; background-color: #f79922; visibility: hidden; left:913px; top: 633px; width:65px; height: 31px; z-index: 1;">
			<div id="r_posterImg1" align="center" style="position: absolute; left:-33px; top: 3px; width:130px; height: 26px">
				<span id="r_posterImg1_span" style="color: #ffffff; font-size: 22; height: 26px"></span>
			</div>
		</div>
	</epg:if>

	<epg:if test="${bottomCategoryItems[2]!=null}">
		<epg:img id="r_posterImg2" src="./images/dot.gif" left="1004" top="465" width="68" height="201" />
		<epg:navUrl obj="${bottomCategoryItems[2]}" indexUrlVar="indexUrl3"></epg:navUrl>
		<epg:img id="r_poster3" src="../content/201406/07/154911.jpg" left="1005" top="458" width="65" height="195" />
		<epg:img id="r_poster3focus" src="./images/dot.gif" left="1005" top="468" width="65" height="195" href="${indexUrl3}&returnTo=biz" onfocus="textOnFocus('2','orange3','categoryList2_titlediv','正骨');" onblur="textOnBlur('posterImg2','categoryList2_titlediv');" />
		<div id="r_categoryList2_titlediv" style="position: absolute; font-size: 22; font-family: '黑体'; color: #FFFFFF; text-align: center; background-color: #f79922; visibility: hidden; left:1005px; top: 633px; width:65px; height: 31px; z-index: 1;">
			<div id="r_posterImg2" align="center" style="position: absolute; left:-31px; top: 3px; width:130px; height: 26px">
				<span id="r_posterImg2_span" style="color: #ffffff; font-size: 22;"></span>
			</div>
		</div>
	</epg:if>
	
	<epg:if test="${bottomCategoryItems[3]!=null}">
		<epg:img id="r_posterImg3" src="./images/dot.gif" left="1092" top="465" width="68" height="201" />
		<epg:navUrl obj="${bottomCategoryItems[3]}" indexUrlVar="indexUrl4"></epg:navUrl>
		<epg:img id="r_poster4" src="../content/201406/07/149850.jpg" left="1093" top="463" width="65" height="195" />
		<epg:img id="r_poster4focus" src="./images/dot.gif" left="1093" top="468" width="65" height="195" href="${indexUrl4}&returnTo=biz" onfocus="textOnFocus('3','orange3','categoryList3_titlediv','初到东京');" onblur="textOnBlur('posterImg3','categoryList3_titlediv');" />
		<div id="r_categoryList3_titlediv" style="position: absolute; font-size: 22; font-family: '黑体'; color: #FFFFFF; text-align: center; background-color: #f79922; visibility: hidden; left:1093px; top: 633px; width:65px; height: 31px; z-index: 1;">
			<div id="r_posterImg3" align="center" style="position: absolute; left:-33px; top: 3px; width:130px; height: 26px">
				<span id="r_posterImg3_span" style="color: #ffffff; font-size: 22;"></span>
			</div>
		</div>
	</epg:if>
	
	<epg:if test="${bottomCategoryItems[4]!=null}">
		<epg:img id="r_posterImg4" src="./images/dot.gif" left="1174" top="465" width="68" height="201" />
		<epg:navUrl obj="${bottomCategoryItems[4]}" indexUrlVar="indexUrl5"></epg:navUrl>
		<epg:img id="r_poster5" src="../content/201406/07/150115.jpg" left="1175" top="468" width="65" height="195" />
		<epg:img id="r_poster5focus" src="./images/dot.gif" left="1175" top="468" width="65" height="195" href="${indexUrl5}&returnTo=biz" onfocus="textOnFocus('4','orange3','categoryList4_titlediv','亨利的罪行');" onblur="textOnBlur('posterImg4','categoryList4_titlediv');" />
		<div id="r_categoryList4_titlediv" style="position: absolute; font-size: 22; font-family: '黑体'; color: #FFFFFF; text-align: center; background-color: #f79922; visibility: hidden; left:1175px; top: 633px; width:65px; height: 31px; z-index: 1;">
			<div id="r_posterImg4" align="center" style="position: absolute; left:-41px; top: 3px; width:130px; height: 26px">
				<span id="r_posterImg4_span" style="color: #ffffff; font-size: 22;"></span>
			</div>
		</div>
	</epg:if>

	<!-- 搜索,收藏,历史,返回 -->
	<epg:img src="./images/dot.gif" id="r_ss" left="1115" top="47" width="40" height="38" href="${context['EPG_SEARCH_URL']}" onfocus="itemOnFocus('ss','focusMenuTop_1');" onblur="itemOnBlur('ss');" />
	<epg:img src="./images/dot.gif" id="r_zz" left="1165" top="47" width="40" height="38" href="${context['EPG_SELF_URL']}" onfocus="itemOnFocus('zz','zizhuFocus');" onblur="itemOnBlur('zz');" />
	<epg:img src="./images/dot.gif" id="r_zn" left="1215" top="47" width="40" height="38" href="javascript:back();" onfocus="itemOnFocus('zn','focusMenuTop_3');" onblur="itemOnBlur('zn');" />

	<!-- 收藏提示框 -->
	<div id="r_collectSuccess" style="display: none;">
		<epg:img id="r_tip" src="./images/collectSuccess.png" left="648" top="0" width="640" height="720" />
		<epg:text id="r_successTs" fontSize="22" color="#565656" left="848" top="327" width="240" height="30" align="center" chineseCharNumber="17" text=""></epg:text>
	</div>
	<div id="r_collectFail" style="display: none;">
		<epg:img id="r_tip" src="./images/collectFail.png" left="648" top="0" width="640" height="720" />
		<epg:text id="r_failTs" fontSize="22" color="#565656" left="848" top="327" width="240" height="30" align="center" chineseCharNumber="17" text=""></epg:text>
	</div>
	<div id="r_tsBtn" style="display:none;">
		<epg:img id="r_Collection" left="881" top="412" onfocus="itemOnFocus('Collection','enterColl');" onblur="itemOnBlur('Collection');" src="./images/dot.gif" width="65" height="40" href="${context['EPG_MYCOLLECTION_URL']}" />
		<epg:img id="r_enter" left="976" top="412" onfocus="itemOnFocus('enter','closeWin');" onblur="itemOnBlur('enter');" src="./images/dot.gif" width="65" height="40" href="javascript:hiddenTip()" />
	</div>
</div>

</epg:body>
</html>