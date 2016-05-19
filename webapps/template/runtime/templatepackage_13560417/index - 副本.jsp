<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
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
<epg:query queryName="getSeverialItems" maxRows="7" var="jiChuMenuCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['hdMenuCategoryCode']}" type="java.lang.String" />
</epg:query>

<epg:query queryName="getSeverialItems" maxRows="8" var="zhuTiMenuCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['sdMenuCategoryCode']}" type="java.lang.String" />
</epg:query>

<!-- 左边大图推荐-->
<epg:query queryName="getSeverialItems" maxRows="1" var="leftPicCategoryCode">
	<epg:param name="categoryCode" value="${templateParams['leftPicCategoryItems']}" type="java.lang.String" />
</epg:query>
<!-- 左边文字推荐-->
<epg:query queryName="getSeverialItems" maxRows="3" var="leftCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['leftCategoryCode']}" type="java.lang.String" />
</epg:query>

<!-- 中图推荐：${templateParams['centerCategoryCode']}-->
<epg:query queryName="getSeverialItems" maxRows="6" var="centerCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['centerCategoryCode']}" type="java.lang.String" />
</epg:query>
<!-- 右上推荐-->
<epg:query queryName="getSeverialItems" maxRows="2" var="rightUpCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['rightUpCategoryCode']}" type="java.lang.String" />
</epg:query>

<!-- 右下推荐-->
<epg:query queryName="getSeverialItems" maxRows="1" var="rightDownCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['rightDownCategoryCode']}" type="java.lang.String" />
</epg:query>
<script src="${context['EPG_CONTEXT']}/js/ajax.js"></script>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>

<style type="text/css">
body {
	color: #02296d;
	font-size: 22px;
	font-family: 黑体;
}

a {
	outline: none;
}

img {
	border: 0px solid black;
}

div * {
	overflow: hidden;
}
/* 3D */
#leftContent0,#lf1,#lf2,#lf3,#midContent0,#midContent1,#midContent2,#midContent3,#midContent4,#midContent5,#midContent6,#rightUpContent0,#rightUpContent1,#rightDownContent0
{
	overflow: hidden;
	-webkit-transform: rotateY(60deg);
}

#r_leftContent0,#r_lf1,#r_lf2,#r_lf3,#r_midContent0,#r_midContent1,#r_midContent2,#r_midContent3,#r_midContent4,#r_midContent5,#r_midContent6,#r_rightUpContent0,#r_rightUpContent1,#r_rightDownContent0
{
	overflow: hidden;
	-webkit-transform: rotateY(60deg);
}
</style>
<script>
var pageLoad = false;
var fristFocus = 0;
if (typeof(iPanel) == 'undefined') {
	pageLoad  = true;
}
var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images";

//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名
function menuOnFocus(objId,focusImg){
	if (pageLoad) {
		fristFocus++;
		document.getElementById(objId+"_img").src=imgPath+"/"+focusImg+".png";
		document.getElementById("r_"+objId+"_img").src=imgPath+"/"+focusImg+".png";	//3D
	}
}
//失去焦点事件
function menuOnBlur(objId){
	if (pageLoad) {
		document.getElementById(objId+"_img").src=imgPath+"/dot.gif";
		document.getElementById("r_"+objId+"_img").src=imgPath+"/dot.gif";	//3D
	}
}

//海报获得焦点
function iconOnfocus(objId,num){
	var _imgDiv = document.getElementById("r_"+objId+"_imgDiv").style.left;
	//var imgDiv = _imgDiv.substr(0, _imgDiv.length-2);
	var imgDiv = parseInt(_imgDiv);
	//左上
	
	if(objId == "leftContent0"){
		var _lfDiv = document.getElementById("r_lfContent0_div").style.left;
		//var lfDiv = _lfDiv.substr(0, _lfDiv.length-2);
		var lfDiv = parseInt(_lfDiv);
		document.getElementById("r_lfContent0_div").style.left = (parseInt(lfDiv)+20)+"px";
		document.getElementById("r_"+objId+"_Focustitlediv").style.left = (parseInt(lfDiv)+20)+"px";
		
	}
	//中
	if("midContent" == objId.substr(0, objId.length-1) || "rightUpContent" == objId.substr(0, objId.length-1) ||"rightDownContent" == objId.substr(0, objId.length-1)){
	
		
		var _div = document.getElementById("r_"+objId+"_div").style.left;
//         var div = _div.substr(0, _div.length-2);
		var div = parseInt(_div);
		var _focusDiv = document.getElementById("r_"+objId+"_Focustitlediv").style.left;
// 		var focusDiv = _focusDiv.substr(0,_focusDiv.length-2);
		var focusDiv = parseInt(_focusDiv);
		document.getElementById("r_"+objId+"_div").style.left = (parseInt(div)+20)+"px";	//3D
		document.getElementById("r_"+objId+"_Focustitlediv").style.left = (parseInt(div)+20)+"px";	//3D
	}
	
	if (pageLoad) {
		
		fristFocus++;
		document.getElementById(objId+"_imgDiv").style.visibility = 'visible';	//焦点边框
		document.getElementById("r_"+objId+"_imgDiv").style.visibility = 'visible';	//3D
		document.getElementById("r_"+objId+"_imgDiv").style.left = (parseInt(imgDiv)+20)+"px";	//3D
		if(typeof(num)!="undefined"){
			document.getElementById(objId+"_titlediv").style.visibility = 'hidden';	//未选中时文字
			document.getElementById(objId+"_Focustitlediv").style.visibility = 'visible';	//文字焦点背景
			/* 3D */
			document.getElementById("r_"+objId+"_titlediv").style.visibility = 'hidden';
			document.getElementById("r_"+objId+"_Focustitlediv").style.visibility = 'visible';
		}
	}
}

function iconOnblur(objId,num){
	var _imgDiv = document.getElementById("r_"+objId+"_imgDiv").style.left;
	//var imgDiv = _imgDiv.substr(0, _imgDiv.length-2);
	var imgDiv = parseInt(_imgDiv);
	if(objId == "leftContent0"){
		var _lfDiv = document.getElementById("r_lfContent0_div").style.left;
// 		var lfDiv = _lfDiv.substr(0, _lfDiv.length-2);
		var lfDiv = parseInt(_lfDiv);
		document.getElementById("r_lfContent0_div").style.left = (parseInt(lfDiv)-20)+"px";
		document.getElementById("r_"+objId+"_Focustitlediv").style.left = (parseInt(lfDiv)-20)+"px";
	}
	
 	if("midContent" == objId.substr(0, objId.length-1) || "rightUpContent" == objId.substr(0, objId.length-1) ||"rightDownContent" == objId.substr(0, objId.length-1)){
		var _div = document.getElementById("r_"+objId+"_div").style.left;
// 		var div = _div.substr(0, _div.length-2);
		var div = parseInt(_div);
		var _focusDiv = document.getElementById("r_"+objId+"_Focustitlediv").style.left;
// 		var focusDiv = _focusDiv.substr(0,_focusDiv.length-2);
		var focusDiv = parseInt(_focusDiv);
		document.getElementById("r_"+objId+"_div").style.left = (parseInt(div)-20)+"px";	//3D
		document.getElementById("r_"+objId+"_Focustitlediv").style.left = (parseInt(div)-20)+"px";	//3D
	}
	
	if (pageLoad) {
		document.getElementById(objId+"_imgDiv").style.visibility = 'hidden';
		document.getElementById("r_"+objId+"_imgDiv").style.visibility = 'hidden';	//3D
		document.getElementById("r_"+objId+"_imgDiv").style.left = (parseInt(imgDiv)-20)+"px";	//3D
		if(typeof(num)!="undefined"){
			document.getElementById(objId+"_titlediv").style.visibility = 'visible';
			document.getElementById(objId+"_Focustitlediv").style.visibility = 'hidden';
			/* 3D */
			document.getElementById("r_"+objId+"_titlediv").style.visibility = 'visible';
			document.getElementById("r_"+objId+"_Focustitlediv").style.visibility = 'hidden';
		}
	}
}


//文字节目失去焦点
function textOnBlur(objId,color,divBgColor){
 	var _obj = document.getElementById("r_"+objId+"_text").style.left;
 	var _objbg = document.getElementById("r_"+objId+"_bg").style.left;
 	document.getElementById("r_"+objId+"_text").style.left = (parseInt(_obj)-10)+"px";	//3D
 	document.getElementById("r_"+objId+"_bg").style.left = (parseInt(_objbg)-10)+"px";	//3D
	
	if (pageLoad) {
		document.getElementById(objId+"_bg").style.background = divBgColor;
		document.getElementById("r_"+objId+"_bg").style.background = divBgColor;	//3D
		/* if(typeof(color)!="undefined"){
			document.getElementById(objId+"_span").style.color=color;
			document.getElementById("r_"+objId+"_span").style.color=color;	//3D
		} */
	}
}

//文字节目获得焦点改变文字和背景div颜色
function textOnFocus(objId,textColor,divBgColor){
	var _obj = document.getElementById("r_"+objId+"_text").style.left;
 	var _objbg = document.getElementById("r_"+objId+"_bg").style.left;
    document.getElementById("r_"+objId+"_text").style.left = (parseInt(_obj)+10)+"px";	//3D
 	document.getElementById("r_"+objId+"_bg").style.left = (parseInt(_objbg)+10)+"px";	//3D
	
	if (pageLoad) {
		fristFocus++;
		//document.getElementById(objId+"_span").style.color=textColor;
		document.getElementById(objId+"_bg").style.background = divBgColor;
		/* 3D */
		//document.getElementById("r_"+objId+"_span").style.color=textColor;
		document.getElementById("r_"+objId+"_bg").style.background = divBgColor;
	}
}

function init(){
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""&&document.getElementById(leaveFocusId+"_a")){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		document.getElementById("lfContent0_a").focus();
	}
}
function back(){
 	//document.location.href = SysSetting.getEnv("portalIndexUrl");
	iPanel.eventFrame.openIndex();
 }
 function exit(){
 	back();
  	//document.location.href = "http://192.168.11.153/epg/1.html";
 }
 
if("${rightDownCategoryItems.itemType}"=="channel"){
	var mediaPlayer = new MediaPlayer();
	var mediaID;
	mediaID = mediaPlayer.createPlayerInstance("video",2);
	mediaPlayer.bindPlayerInstance(mediaID);
	mediaPlayer.position="0,857,167,363,205";   //全屏  857 165
	mediaPlayer.source="delivery://371000.6875.64-QAM.1342.258.514";
	mediaPlayer.play();
	mediaPlayer.refresh();
}


function closeVideo() {
	if ("${rightDownCategoryItems.itemType}" == "channel") {
		mediaPlayer.releasePlayerInstance(); //释放播放  销毁播放器
		mediaPlayer.unBindPlayerInstance();//解除绑定
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
			//window.location.href = "${context['EPG_CONTEXT']}/common/logout/logout.jsp";
			iPanel.eventFrame.openIndex();
			return 0;
			break;
		default:
			return 1;
			break;
	}
}
</script>

<epg:body onload="init()" onunload="closeVideo();" bgcolor="#000000" width="1280" height="720">

	<div id="leftDiv">
		<!-- 背景图片以及头部图片 -->
		<epg:img src="./images/index.jpg" id="main" width="640" height="720" />
		<epg:img src="./images/logo.png" width="175" height="85" />

		<!-- HD导航 -->
		<epg:grid column="7" row="1" left="26" top="97" width="334" height="94" hcellspacing="4" items="${jiChuMenuCategoryItems}" var="jiChuMenuCategoryItem" indexVar="curIdx" posVar="positions">
			<epg:navUrl obj="${jiChuMenuCategoryItem}" indexUrlVar="indexUrl" />
			<epg:img id="jichumenu${curIdx}" src="./images/dot.gif" width="46" href="${indexUrl}" onfocus="menuOnFocus('jichumenu${curIdx}','jiChufocusMenu${curIdx}');"
				onblur="menuOnBlur('jichumenu${curIdx}');" height="94" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" />
		</epg:grid>

		<!-- SD导航 -->
		<epg:grid column="4" row="2" left="362" top="97" width="254" height="94" vcellspacing="4" hcellspacing="4" items="${zhuTiMenuCategoryItems}" var="zhuTiMenuCategoryItem" indexVar="curIdx"
			posVar="positions">
			<epg:navUrl obj="${zhuTiMenuCategoryItem}" indexUrlVar="indexUrl" />
			<epg:img id="zhutimenu${curIdx}" src="./images/dot.gif" width="62" href="${indexUrl}" onfocus="menuOnFocus('zhutimenu${curIdx}','zhutifocusMenu${curIdx}');"
				onblur="menuOnBlur('zhutimenu${curIdx}');" height="45" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" />
		</epg:grid>
		
		<!-- 右上角按钮 -->
		<epg:img src="./images/dot.gif" id="ss" left="475" top="52" width="40" height="38" href="${context['EPG_SEARCH_URL']}" onfocus="menuOnFocus('ss','focusMenuTop_1');" onblur="menuOnBlur('ss');" />
		<epg:img src="./images/dot.gif" id="zz" left="525" top="52" width="40" height="38" href="${context['EPG_SELF_URL']}" onfocus="menuOnFocus('zz','zizhuFocus');" onblur="menuOnBlur('zz');" />
		<epg:img src="./images/dot.gif" id="zn" left="575" top="52" width="40" height="38" href="javascript:back();" onfocus="menuOnFocus('zn','exit');" onblur="menuOnBlur('zn');" />

		<!-- 左侧5推荐 -->
		<epg:if test="${leftPicCategoryCode != null}">
			<epg:navUrl obj="${leftPicCategoryCode}" indexUrlVar="indexUrl" />
			<div id="leftContent0_imgDiv" style="position: absolute; background-color: #f79922; visibility: hidden; left: 24px; top: 224px; width: 143px; height: 306px;"></div>
			<epg:img id="lfContent0" onblur="iconOnblur('leftContent0',1);" left="25" top="227" onfocus="iconOnfocus('leftContent0',1)" src="../${leftPicCategoryCode.itemIcon}" width="140" height="300"
				rememberFocus="true" href="${context['EPG_CONTEXT']}/3DPlay/play.html" />
			<div id="leftContent0_titlediv"
				style="position: absolute; font-size: 22px; font-family: '黑体'; color: #cccccc; text-align: center; background-color: #265cb6; left: 25px; top: 484px; width: 140px; height: 45px; z-index: 1; opacity: 0.8;">
				<epg:text color="#ffffff" width="140" left="2" top="11" chineseCharNumber="12" dotdotdot="…">${leftPicCategoryCode.title}</epg:text>
			</div>
			<div id="leftContent0_Focustitlediv"
				style="visibility: hidden; position: absolute; font-size: 22px; font-family: '黑体'; color: #cccccc; text-align: center; background-color: #f79922; left:25px; top: 484px; width: 140px; height: 45px; z-index: 1; opacity: 1;">
				<epg:text color="#ffffff" width="140" left="2" top="10" chineseCharNumber="12" dotdotdot="…">${leftPicCategoryCode.title}</epg:text>
			</div>
		</epg:if>
		
		
		
		
		
		<!-- 左边文字推荐 -->
		<epg:if test="${leftCategoryItems[0] !=null}">
			<epg:navUrl obj="${leftCategoryItems[0]}" indexUrlVar="indexUrl" />
			<div id="lf1_bg" style="position: absolute; left: 25px; top: 527px; width: 140px; height: 40px;">
				<epg:img id="lf1" width="140" height="40" rememberFocus="true" href="${context['EPG_CONTEXT']}/3DPlay/play3D.html" onblur="textOnBlur('lf1','#02296d','#c0d9ea');" onfocus="textOnFocus('lf1','#ffffff','#f79922')"
					src="./images/dot.gif" />
			</div>
		</epg:if>
		<epg:if test="${leftCategoryItems[0] != null}">
			<epg:text id="lf1_text"  left="25" top="536" color="#02296d" width="134" chineseCharNumber="12" dotdotdot="…">${leftCategoryItems[0].title}</epg:text>
		</epg:if>

		<epg:if test="${leftCategoryItems[1] !=null}">
			<epg:navUrl obj="${leftCategoryItems[1]}" indexUrlVar="indexUrl" />
			<div id="lf2_bg" style="position: absolute; left: 25px; top: 569px; width: 140px; height: 40px;">
				<epg:img id="lf2" width="140" height="40" rememberFocus="true" href="${context['EPG_CONTEXT']}/3DPlay/play3D.html" onblur="textOnBlur('lf2','#02296d','#c0d9ea');" onfocus="textOnFocus('lf2','#ffffff','#f79922')"
					src="./images/dot.gif" />
			</div>
		</epg:if>
		<epg:if test="${leftCategoryItems[1] != null}">
			<epg:text id="lf2_text"  left="25" top="576" color="#02296d" width="134" chineseCharNumber="12" dotdotdot="…">${leftCategoryItems[1].title}</epg:text>
		</epg:if>

		<epg:if test="${leftCategoryItems[2] !=null}">
			<epg:navUrl obj="${leftCategoryItems[2]}" indexUrlVar="indexUrl" />
			<div id="lf3_bg" style="position: absolute; left: 25px; top: 611px; width: 140px; height: 40px;">
				<epg:img id="lf3" width="140" height="40" rememberFocus="true" href="${context['EPG_CONTEXT']}/3DPlay/play3D.html" onblur="textOnBlur('lf3','#02296d','#c0d9ea');" onfocus="textOnFocus('lf3','#ffffff','#f79922')"
					src="./images/dot.gif" />
			</div>
		</epg:if>
		<epg:if test="${leftCategoryItems[2] != null}">
			<epg:text id="lf3_text" left="25" top="619" color="#02296d" width="134" chineseCharNumber="12" dotdotdot="…">${leftCategoryItems[2].title}</epg:text>
		</epg:if>

		<!-- 中推荐 -->
		<epg:grid column="2" row="3" left="175" top="226" width="240" height="426" vcellspacing="10" hcellspacing="10" items="${centerCategoryItems}" var="centerCategoryItem" indexVar="curIdx"
			posVar="positions">
			<epg:navUrl obj="${centerCategoryItem}" indexUrlVar="indexUrl" />
			<div id="midContent${curIdx-1}_imgDiv"
				style="position:absolute;background-color:#f79922;visibility:hidden;left:${positions[curIdx-1].x-3}px;top:${positions[curIdx-1].y-3}px;width:121px;height:141px;"></div>
			<epg:img id="midContent${curIdx-1}" src="../${centerCategoryItem.itemIcon}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="118" height="135" />
			<epg:img id="midContentFocus${curIdx-1}" onblur="iconOnblur('midContent${curIdx-1}',1)" onfocus="iconOnfocus('midContent${curIdx-1}',1)" rememberFocus="true" src="./images/dot.gif"
				left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="121" height="146" href="${context['EPG_CONTEXT']}/3DPlay/play3D.html" />
			<div id="midContent${curIdx-1}_titlediv"
				style="position:absolute;font-size:22px;font-family:'黑体';color:#FFFFFF;opacity:0.8;
						text-align:center;background-color:#020000;left:${positions[curIdx-1].x}px;top:${positions[curIdx-1].y+105}px;width:115px;height:30px;z-index:1;">
				<epg:text  align="left" left="2" top="3" color="#ffffff" height="22" chineseCharNumber="10" width="115" fontSize="22" dotdotdot="…">
					${centerCategoryItem.title}
				</epg:text>
			</div>
			<div id="midContent${curIdx-1}_Focustitlediv"
				style="position:absolute;visibility:hidden;font-size:22px;font-family:'黑体';color:#FFFFFF;opacity:1;
						text-align:center;background-color:#f79922;left:${positions[curIdx-1].x}px;top:${positions[curIdx-1].y+93}px;width:118px;height:42px;z-index:1;">
				<epg:text align="left" left="2" color="#ffffff" top="10" height="22" chineseCharNumber="10" width="118" fontSize="22" dotdotdot="…">
					${centerCategoryItem.title}
				</epg:text>
			</div>
		</epg:grid>

		<!-- 右上推荐 -->
		<epg:grid column="2" row="1" left="425" top="224" width="190" height="190" hcellspacing="10" items="${rightUpCategoryItems}" var="rightUpCategoryItem" indexVar="curIdx" posVar="positions">
			<epg:navUrl obj="${rightUpCategoryItem}" indexUrlVar="indexUrl" />
			<div id="rightUpContent${curIdx-1}_imgDiv"
				style="position:absolute;background-color:#f79922;visibility:hidden;left:${positions[curIdx-1].x-3}px;top:${positions[curIdx-1].y-3}px;width:96px;height:196px;"></div>
			<epg:img id="rightUpContent${curIdx-1}" src="../${rightUpCategoryItem.itemIcon}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="93" height="190" />
			<epg:img id="rightUpContentFocus${curIdx-1}" onblur="iconOnblur('rightUpContent${curIdx-1}',1)" onfocus="iconOnfocus('rightUpContent${curIdx-1}',1)" rememberFocus="true" src="./images/dot.gif"
				left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="93" height="190" href="${context['EPG_CONTEXT']}/3DPlay/play3D.html" />
			<div id="rightUpContent${curIdx-1}_titlediv"
				style="position:absolute;font-size:22px;font-family:'黑体';color:#FFFFFF;opacity:0.8;
						text-align:center;background-color:#020000;left:${positions[curIdx-1].x}px;top:${positions[curIdx-1].y+160}px;width:91px;height:30px;z-index:1;">
				<epg:text top="3" align="left" left="2" color="#ffffff" height="22" chineseCharNumber="8" width="91" fontSize="22" dotdotdot="…">
					${rightUpCategoryItem.title}
				</epg:text>
			</div>
			<div id="rightUpContent${curIdx-1}_Focustitlediv"
				style="position:absolute;visibility:hidden;font-size:22px;font-family:'黑体';color:#FFFFFF;opacity:1;
						text-align:center;background-color:#f79922;left:${positions[curIdx-1].x}px;top:${positions[curIdx-1].y+148}px;width:91px;height:42px;z-index:1;">
				<epg:text align="left" left="2" color="#ffffff" top="10" height="22" chineseCharNumber="8" width="91" fontSize="22" dotdotdot="…">
					${rightUpCategoryItem.title}
				</epg:text>
			</div>
		</epg:grid>

		<epg:if test="${rightDownCategoryItems != null}">
			<epg:if test="${rightDownCategoryItems.itemType=='channel'}">
				<epg:navUrl obj="${rightDownCategoryItems}" playUrlVar="indexUrl" />
				<epg:img src="./images/dot.png" left="425" top="434" width="190" height="215" href="${context['EPG_CONTEXT']}/3DPlay/play3D.html" />
			</epg:if>
			<epg:if test="${rightDownCategoryItems.itemType!='channel'}">
				<epg:navUrl obj="${rightDownCategoryItems}" indexUrlVar="indexUrl" />
				<div id="rightDownContent0_imgDiv" style="position: absolute; background-color: #f79922; visibility: hidden; left: 424px; top: 431px; width: 193px; height: 221px;"></div>
				<epg:img id="rightDownContent0" onblur="iconOnblur('rightDownContent0',1);" left="425" top="434" onfocus="iconOnfocus('rightDownContent0',1)" src="../${rightDownCategoryItems.itemIcon}"
					rememberFocus="true" width="190" height="215" href="${context['EPG_CONTEXT']}/3DPlay/play3D.html" />
				<div id="rightDownContent0_titlediv"
					style="position: absolute; font-size: 22px; font-family: '黑体'; color: #cccccc; text-align: center; background-color: #000000; left: 425px; top: 619px; width: 190px; height: 30px; z-index: 1; opacity: 0.8;">
					<epg:text  color="#ffffff" width="190" left="2" top="3" chineseCharNumber="16" dotdotdot="…">${rightDownCategoryItems.title}</epg:text>
				</div>
				<div id="rightDownContent0_Focustitlediv"
					style="position: absolute; visibility: hidden; font-size: 22px; font-family: '黑体'; color: #cccccc; text-align: center; background-color: #f79922; left: 425px; top: 607px; width: 190px; height: 42px; z-index: 1; opacity: 1;">
					<epg:text color="#ffffff" width="190" left="2" top="10" chineseCharNumber="16" dotdotdot="…">${rightDownCategoryItems.title}</epg:text>
				</div>
			</epg:if>
		</epg:if>
	</div>
	<!-- ********************************************************************************************************* -->
	<div id="rightDiv">
		<!-- 背景图片以及头部图片 -->
		<epg:img src="./images/index.jpg" id="r_main" left="640" top="0" width="640" height="720" />
		<epg:img src="./images/logo.png" left="640" top="10" width="175" height="85" />

		<!-- HD导航 -->
		<epg:grid column="7" row="1" left="666" top="97" width="334" height="94" hcellspacing="4" items="${jiChuMenuCategoryItems}" var="jiChuMenuCategoryItem" indexVar="curIdx" posVar="positions">
			<epg:navUrl obj="${jiChuMenuCategoryItem}" indexUrlVar="indexUrl" />
			<epg:img id="r_jichumenu${curIdx}" src="./images/dot.gif" width="46" href="${indexUrl}" onfocus="menuOnFocus('jichumenu${curIdx}','jiChufocusMenu${curIdx}');"
				onblur="menuOnBlur('jichumenu${curIdx}');" height="94" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" />
		</epg:grid>

		<!-- SD导航 -->
		<epg:grid column="4" row="2" left="1002" top="97" width="254" height="94" vcellspacing="4" hcellspacing="4" items="${zhuTiMenuCategoryItems}" var="zhuTiMenuCategoryItem" indexVar="curIdx"
			posVar="positions">
			<epg:navUrl obj="${zhuTiMenuCategoryItem}" indexUrlVar="indexUrl" />
			<epg:img id="r_zhutimenu${curIdx}" src="./images/dot.gif" width="62" href="${indexUrl}" onfocus="menuOnFocus('zhutimenu${curIdx}','zhutifocusMenu${curIdx}');"
				onblur="menuOnBlur('zhutimenu${curIdx}');" height="45" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" />
		</epg:grid>

		<epg:img src="./images/dot.gif" id="r_ss" left="1115" top="52" width="40" height="38" href="${context['EPG_SEARCH_URL']}" onfocus="menuOnFocus('ss','focusMenuTop_1');" onblur="menuOnBlur('ss');" />
		<epg:img src="./images/dot.gif" id="r_zz" left="1165" top="52" width="40" height="38" href="${context['EPG_SELF_URL']}" onfocus="menuOnFocus('zz','zizhuFocus');" onblur="menuOnBlur('zz');" />
		<epg:img src="./images/dot.gif" id="r_zn" left="1215" top="52" width="40" height="38" href="javascript:back();" onfocus="menuOnFocus('zn','exit');" onblur="menuOnBlur('zn');" />

		<!-- 左侧5推荐 -->
		<epg:if test="${leftPicCategoryCode != null}">
			<epg:navUrl obj="${leftPicCategoryCode}" indexUrlVar="indexUrl" />
			<div id="r_leftContent0_imgDiv" style="position: absolute; background-color: #f79922; visibility: hidden; left: 655px; top: 224px; width: 143px; height: 306px;"></div>
			<epg:img id="r_lfContent0" onblur="iconOnblur('leftContent0',1);" left="655" top="227" onfocus="iconOnfocus('leftContent0',1)" src="../${leftPicCategoryCode.itemIcon}" width="140" height="300"
				rememberFocus="true" href="${context['EPG_CONTEXT']}/3DPlay/play.html" />
			<div id="r_leftContent0_titlediv"
				style="position: absolute; font-size: 22px; font-family: '黑体'; color: #cccccc; text-align: center; background-color: #265cb6; left: 655px; top: 484px; width: 140px; height: 45px; z-index: 1; opacity: 0.8;">
				<epg:text color="#ffffff" width="140" left="2" top="11" chineseCharNumber="12" dotdotdot="…">${leftPicCategoryCode.title}</epg:text>
			</div>
			
			<div id="r_leftContent0_Focustitlediv"
				style="visibility: hidden; position: absolute; font-size: 22px; font-family: '黑体'; color: #cccccc; text-align: center; background-color: #f79922; left: 655px; top: 484px; width: 140px; height: 45px; z-index: 1; opacity: 1;">
				<epg:text color="#ffffff" width="140" left="2" top="10" chineseCharNumber="12" dotdotdot="…">${leftPicCategoryCode.title}</epg:text>
			</div>
		</epg:if>

		<!-- 右侧文字推荐 -->
		<epg:if test="${leftCategoryItems[0] !=null}">
			<epg:navUrl obj="${leftCategoryItems[0]}" indexUrlVar="indexUrl" />
			<div id="r_lf1_bg" style="position: absolute; left: 665px; top: 527px; width: 140px; height: 40px;">
				<epg:img id="r_lf1" width="140" height="40" rememberFocus="true" href="${context['EPG_CONTEXT']}/3DPlay/play3D.html" onblur="textOnBlur('lf1','#02296d','#c0d9ea');" onfocus="textOnFocus('lf1','#ffffff','#f79922')"
					src="./images/dot.gif" />
			</div>
		</epg:if>
		<epg:if test="${leftCategoryItems[0] != null}">
			<epg:text id="r_lf1_text" left="665" top="536" color="#02296d" width="134" chineseCharNumber="12" dotdotdot="…">${leftCategoryItems[0].title}</epg:text>
		</epg:if>
		

		<epg:if test="${leftCategoryItems[1] !=null}">
			<epg:navUrl obj="${leftCategoryItems[1]}" indexUrlVar="indexUrl" />
			<div id="r_lf2_bg" style="position: absolute; left: 665px; top: 569px; width: 140px; height: 40px;">
				<epg:img id="r_lf2" width="140" height="40" rememberFocus="true" href="${context['EPG_CONTEXT']}/3DPlay/play3D.html" onblur="textOnBlur('lf2','#02296d','#c0d9ea');" onfocus="textOnFocus('lf2','#ffffff','#f79922')"
					src="./images/dot.gif" />
			</div>
		</epg:if>
		<epg:if test="${leftCategoryItems[1] != null}">
			<epg:text id="r_lf2_text" left="665" top="576" color="#02296d" width="134" chineseCharNumber="12" dotdotdot="…">${leftCategoryItems[1].title}</epg:text>
		</epg:if>

		<epg:if test="${leftCategoryItems[2] !=null}">
			<epg:navUrl obj="${leftCategoryItems[2]}" indexUrlVar="indexUrl" />
			<div id="r_lf3_bg" style="position: absolute; left: 665px; top: 611px; width: 140px; height: 40px;">
				<epg:img id="r_lf3" width="140" height="40" rememberFocus="true" href="${context['EPG_CONTEXT']}/3DPlay/play3D.html" onblur="textOnBlur('lf3','#02296d','#c0d9ea');" onfocus="textOnFocus('lf3','#ffffff','#f79922')"
					src="./images/dot.gif" />
			</div>
		</epg:if>
		<epg:if test="${leftCategoryItems[2] != null}">
			<epg:text id="r_lf3_text" left="665" top="619" color="#02296d" width="134" chineseCharNumber="12" dotdotdot="…">${leftCategoryItems[2].title}</epg:text>
		</epg:if>

		<!-- 中推荐 -->
		<epg:grid column="2" row="3" left="805" top="226" width="240" height="426" vcellspacing="10" hcellspacing="10" items="${centerCategoryItems}" var="centerCategoryItem" indexVar="curIdx"
			posVar="positions">
			<epg:navUrl obj="${centerCategoryItem}" indexUrlVar="indexUrl" />
			<div id="r_midContent${curIdx-1}_imgDiv"
				style="position:absolute;background-color:#f79922;visibility:hidden;left:${positions[curIdx-1].x-3}px;top:${positions[curIdx-1].y-3}px;width:121px;height:141px;"></div>
			<epg:img id="r_midContent${curIdx-1}" src="../${centerCategoryItem.itemIcon}" left="${positions[curIdx-1].x-2}" top="${positions[curIdx-1].y}" width="118" height="135" />
			<epg:img id="r_midContentFocus${curIdx-1}" onblur="iconOnblur('midContent${curIdx-1}',1)" onfocus="iconOnfocus('midContent${curIdx-1}',1)" rememberFocus="true" src="./images/dot.gif"
				left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="121" height="146" href="${context['EPG_CONTEXT']}/3DPlay/play3D.html" />
			<div id="r_midContent${curIdx-1}_titlediv"
				style="position:absolute;font-size:22px;font-family:'黑体';color:#FFFFFF;opacity:0.8;
						text-align:center;background-color:#020000;left:${positions[curIdx-1].x}px;top:${positions[curIdx-1].y+105}px;width:115px;height:30px;z-index:1;">
				<epg:text align="left" left="2" top="3" color="#ffffff" height="22" chineseCharNumber="10" width="115" fontSize="22" dotdotdot="…">
					${centerCategoryItem.title}
				</epg:text>
			</div>
			<div id="r_midContent${curIdx-1}_Focustitlediv"
				style="position:absolute;visibility:hidden;font-size:22px;font-family:'黑体';color:#FFFFFF;opacity:1;
						text-align:center;background-color:#f79922;left:${positions[curIdx-1].x}px;top:${positions[curIdx-1].y+93}px;width:118px;height:42px;z-index:0;">
				<epg:text align="left" left="2" color="#ffffff" top="10" height="22" chineseCharNumber="10" width="118" fontSize="22" dotdotdot="…">
					${centerCategoryItem.title}
				</epg:text>
			</div>
		</epg:grid>

		<!-- 右上推荐 -->
		<epg:grid column="2" row="1" left="1055" top="224" width="190" height="190" hcellspacing="10" items="${rightUpCategoryItems}" var="rightUpCategoryItem" indexVar="curIdx" posVar="positions">
			<epg:navUrl obj="${rightUpCategoryItem}" indexUrlVar="indexUrl" />
			<div id="r_rightUpContent${curIdx-1}_imgDiv"
				style="position:absolute;background-color:#f79922;visibility:hidden;left:${positions[curIdx-1].x-3}px;top:${positions[curIdx-1].y-3}px;width:96px;height:196px;"></div>
			<epg:img id="r_rightUpContent${curIdx-1}" src="../${rightUpCategoryItem.itemIcon}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="93" height="190" />
			<epg:img id="r_rightUpContentFocus${curIdx-1}" onblur="iconOnblur('rightUpContent${curIdx-1}',1)" onfocus="iconOnfocus('rightUpContent${curIdx-1}',1)" rememberFocus="true" src="./images/dot.gif"
				left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="93" height="190" href="${context['EPG_CONTEXT']}/3DPlay/play3D.html" />
			<div id="r_rightUpContent${curIdx-1}_titlediv"
				style="position:absolute;font-size:22px;font-family:'黑体';color:#FFFFFF;opacity:0.8;
						text-align:center;background-color:#020000;left:${positions[curIdx-1].x}px;top:${positions[curIdx-1].y+160}px;width:93px;height:30px;z-index:1;">
				<epg:text top="3" align="left" left="2" color="#ffffff" height="22" chineseCharNumber="8" width="93" fontSize="22" dotdotdot="…">
					${rightUpCategoryItem.title}
				</epg:text>
			</div>
			<div id="r_rightUpContent${curIdx-1}_Focustitlediv"
				style="position:absolute;visibility:hidden;font-size:22px;font-family:'黑体';color:#FFFFFF;opacity:1;
						text-align:center;background-color:#f79922;left:${positions[curIdx-1].x}px;top:${positions[curIdx-1].y+148}px;width:93px;height:42px;z-index:1;">
				<epg:text align="left" left="2" color="#ffffff" top="10" height="22" chineseCharNumber="8" width="93" fontSize="22" dotdotdot="…">
					${rightUpCategoryItem.title}
				</epg:text>
			</div>
		</epg:grid>

		<epg:if test="${rightDownCategoryItems != null}">
			<epg:if test="${rightDownCategoryItems.itemType=='channel'}">
				<epg:navUrl obj="${rightDownCategoryItems}" playUrlVar="indexUrl" />
				<epg:img src="./images/dot.png" left="1055" top="434" width="190" height="215" href="${context['EPG_CONTEXT']}/3DPlay/play3D.html" />
			</epg:if>
			<epg:if test="${rightDownCategoryItems.itemType!='channel'}">
				<epg:navUrl obj="${rightDownCategoryItems}" indexUrlVar="indexUrl" />
				<div id="r_rightDownContent0_imgDiv" style="position: absolute; background-color: #f79922; visibility: hidden; left: 1055px; top: 431px; width: 193px; height: 221px;"></div>
				<epg:img id="r_rightDownContent0" onblur="iconOnblur('rightDownContent0',1);" left="1055" top="434" onfocus="iconOnfocus('rightDownContent0',1)" src="../${rightDownCategoryItems.itemIcon}"
					rememberFocus="true" width="190" height="215" href="${context['EPG_CONTEXT']}/3DPlay/play3D.html" />
				<div id="r_rightDownContent0_titlediv"
					style="position: absolute; font-size: 22px; font-family: '黑体'; color: #cccccc; text-align: center; background-color: #000000; left: 1055px; top: 619px; width: 190px; height: 30px; z-index: 1; opacity: 0.8;">
					<epg:text color="#ffffff" width="190" left="2" top="3" chineseCharNumber="16" dotdotdot="…">${rightDownCategoryItems.title}</epg:text>
				</div>
				<div id="r_rightDownContent0_Focustitlediv"
					style="position: absolute; visibility: hidden; font-size: 22px; font-family: '黑体'; color: #cccccc; text-align: center; background-color: #f79922; left: 1055px; top: 607px; width: 190px; height: 42px; z-index: 1; opacity: 1;">
					<epg:text color="#ffffff" width="190" left="2" top="10" chineseCharNumber="16" dotdotdot="…">${rightDownCategoryItems.title}</epg:text>
				</div>
			</epg:if>
		</epg:if>
	</div>

</epg:body>

</epg:html>