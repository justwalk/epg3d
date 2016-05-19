<%@page contentType="text/html; charset=gbk" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*"%>
<%@page import="java.util.*,java.text.*"%>

<% 

	String leaveFocusId = request.getParameter("leaveFocusId");
	if(leaveFocusId!=null&&leaveFocusId!=""){
		EpgUserSession eus = EpgUserSession.findUserSession(request);
		eus.setPlayFocusId(leaveFocusId) ;
	}
%>
<html>
<!-- 查询节目信息 -->
<epg:query queryName="queryProgramDetailByCode" var="program">
	<epg:param name="contentCode" value="${context['EPG_CONTENT_CODE']}" type="java.lang.String" />
</epg:query>
<epg:resource realSrcVar="proBtnImg" src="./images/HYD_HDplay.png"/>
<epg:if test="${program.hdType == 1}">
	<epg:resource realSrcVar="proBtnImg" src="./images/HYD_HDplay.png"/>
</epg:if>

<epg:set value="2" var="bodyType"/>
<epg:set value="1" var="ProgramBodyType"/>

<epg:set value="1" var="hdType"/>
<epg:set value="0" var="sdType"/>
<epg:set value="${program.relCode}" var="relCode"/>

<epg:set value="true" var="haveRelCode"/>
<epg:if test="${empty relCode}">
	<epg:set value="false" var="haveRelCode"/>
	<epg:navUrl obj="${program}" playUrlVar="proPlayUrl"/>
</epg:if>

<!-- 精彩预告 -->
<epg:query queryName="queryRelContentByRelCodeAndBodyType" maxRows="1" var="prevue" >
	<epg:param name="relCode" value="${relCode}" type="java.lang.String"/>
	<epg:param name="bodyType" value="${bodyType}" type="java.lang.Integer"/>
</epg:query>
<!-- HD正片 -->
<epg:query queryName="queryRelContentByRelCodeAndType" maxRows="1" var="HDContent" >
	<epg:param name="relCode" value="${relCode}" type="java.lang.String"/>
	<epg:param name="bodyType" value="${ProgramBodyType}" type="java.lang.Integer"/>
	<epg:param name="videoType" value="${hdType}" type="java.lang.Integer"/>
</epg:query>
<!-- SD正片 -->
<epg:query queryName="queryRelContentByRelCodeAndType" maxRows="1" var="SDContent" >
	<epg:param name="relCode" value="${relCode}" type="java.lang.String"/>
	<epg:param name="bodyType" value="${ProgramBodyType}" type="java.lang.Integer"/>
	<epg:param name="videoType" value="${sdType}" type="java.lang.Integer"/>
</epg:query>

<!-- check relCodeFlag -->
<epg:set value="false" var="prevue_showFlag"/>
<epg:set value="false" var="hd_showFlag"/>
<epg:set value="false" var="sd_showFlag"/>
<epg:if test="${prevue.relCodeFlag == 1}">
	<epg:set value="true" var="prevue_showFlag"/>
	<epg:navUrl obj="${prevue}" playUrlVar="playUrl"/>
</epg:if>

<epg:if test="${HDContent.relCodeFlag == 1}">
	<epg:set value="true" var="hd_showFlag"/>
	<epg:navUrl obj="${HDContent}" playUrlVar="HDPlayUrl"/>
	
	<!-- 高清节目信息 -->
	<epg:query queryName="queryProgramDetailByCode" var="HDProgram">
		<epg:param name="contentCode" value="${HDContent.contentCode}" type="java.lang.String" />
	</epg:query>
	<fmt:formatNumber pattern="0.00" value="${HDProgram.suggestedPrice}" var="HDPrice"/>
</epg:if>

<epg:if test="${SDContent.relCodeFlag == 1}">
	<epg:set value="true" var="sd_showFlag"/>
	<epg:navUrl obj="${SDContent}" playUrlVar="SDPlayUrl"/>
	
	<!-- 标清节目信息 -->
	<epg:query queryName="queryProgramDetailByCode" var="SDProgram">
		<epg:param name="contentCode" value="${SDContent.contentCode}" type="java.lang.String" />
	</epg:query>
	<fmt:formatNumber pattern="0.00" value="${SDProgram.suggestedPrice}" var="SDPrice"/>
</epg:if>

<%
	int time = 7; // 订购有效期7天
	SimpleDateFormat sdf =  new SimpleDateFormat("yyyy年MM月dd日HH时");
	Date now = new Date();
	
	Calendar cal = Calendar.getInstance();
	cal.setTime(now);
	
	Calendar startCal = Calendar.getInstance();
	startCal.set(Calendar.YEAR, cal.get(Calendar.YEAR));
	startCal.set(Calendar.MONTH, cal.get(Calendar.MONTH));
	
	Calendar endCal = Calendar.getInstance();
	endCal.setTime(startCal.getTime());
	endCal.add(Calendar.DAY_OF_MONTH, time);
	
	String expireTime = sdf.format(endCal.getTime());
	
	request.setAttribute("expireTime",expireTime);
%>

<epg:set value="./images/dot.gif" var="dot"/>

<style>
	img{border:0px;}
	body{color:#FFFFFF;font-size:22;font-family:"黑体";}
	div{position: absolute;}
	#proTitle{left:363px;top:132px;width:348px;height:35px;font-weight:bold;}
	#detail{left:360px;top:341px;width:825px;height:122px;line-height:42px;}
	#tipLayer,#orderTipLayer,#btnLayer_0,#btnLayer_1,#btnLayer_2,#btnLayer_3{visibility:hidden;}
	#tipTitle{left:550px;top:178px;width:385px;height:45px;text-align:center;font-size:36px;font-weight:bold;}
	#timeSpan{left:630px;top:249px;width:230px;height:30px;font-size:24;text-align:center;}
	#dateStr{left:630px;top:279px;width:230px;height:30px;font-size:24;text-align:center;}
	#price{left:654px;top:342px;width:173px;height:28px;font-size:20;text-align:center;}
	#errorInfo{left:277px;top:470px;width:745px;height:30px;font-size:24;color:red;text-align:center;}
</style>

<script src="${context['EPG_CONTEXT']}/js/ajax.js"></script>
<script>
var RESULT_SUCCESS = "success";
var RESULT_FAILED = "failed";
var RESULT_ERROR = "error";
var NEED_LOGIN = "need login";
var NEED_LOGIN_INFO = "尊敬的用户，由于您较长时间未操作，系统将重新登陆……";
var AUTH_ERROR_INFO = "尊敬的用户，鉴权失败，对您造成的不便尽请谅解！";
var ORDER_FAILED_INFO = "尊敬的用户，订购失败，对您造成的不便尽请谅解！";
var currFocusId = "";
var idx = 0;
var playUrl = new Array("${HDPlayUrl}","${SDPlayUrl}");
var price = new Array("${HDPrice}","${SDPrice}");
var contentCode = new Array("${HDProgram.contentCode}","${SDProgram.contentCode}");
var contentType = new Array("${HDProgram.contentType}","${SDProgram.contentType}");
var authAjax = null;
var orderAjax = null;

var interval = 30;
var haveRelCode = ${haveRelCode};
var btnJson = [{"isShow":${hd_showFlag},"left":369,"width":155},
			   {"isShow":${sd_showFlag},"left":554,"width":155},
			   {"isShow":${prevue_showFlag},"left":739,"width":116}];

function $(id){
	return document.getElementById(id);
}

function closeTip(type){
	$("errorInfo").innerHTML = "";
	if(type == 0){
		$("tipLayer").style.visibility = "hidden";
	}else{
		$("orderTipLayer").style.visibility = "hidden";
	}
	displayDiv("block");
	$(currFocusId).focus();
}

function serviceAuth(_hdType, _currFocusId){
	idx = _hdType;
	currFocusId = _currFocusId;
	<epg:navUrl obj="${program}" playUrlVar="playUrl1" ></epg:navUrl>
	if(haveRelCode){
		window.location.href = playUrl[idx];
	}else{
		window.location.href = "${playUrl1}";
	}
	//callServiceAuth();
}


function doLogin(){
	iPanel.mainFrame.location = "${context['EPG_CONTEXT']}/index/hdvod.do";
}

function init(){
	if(haveRelCode){
		showRelContent();
	}else{
		contentCode[0] = "${context['EPG_CONTENT_CODE']}";
		contentType[0] = "${program.contentType}";
		$("btn0Txt_span").innerHTML = "${program.suggestedPrice}";
		$("btn0Img_img").src = "${proBtnImg}";
		$("btnLayer_0").style.visibility = "visible";
		$("btnLayer_3").style.left = "554px";
		$("btnLayer_3").style.visibility = "visible";
	}
	iPanel.focus.display = 1;
	iPanel.focus.border = 1;
	document.getElementById("ID0").focus();
}
function end(){
	iPanel.focus.display = 0;
	iPanel.focus.border = 0;
}

function showRelContent(){
	var leftIdx = 0;
	var divNames = new Array();
	for(var i=0; i < btnJson.length; i++){
		if(btnJson[i].isShow){
			$("btnLayer_" + i).style.left = btnJson[leftIdx].left + "px";
			leftIdx++;
			$("btnLayer_" + i).style.visibility = "visible";
			divNames[i] = "btnLayer_" + i;
		}
	}
	var lastBtnLeft = getIntVal($(divNames[divNames.length-1]).style.left) + 
					  getIntVal($(divNames[divNames.length-1]).style.width) + interval + "px";
	$("btnLayer_3").style.left = lastBtnLeft;
	$("btnLayer_3").style.visibility = "visible";
}

function getIntVal(_val){
	var val = _val+"";
	var idx = val.indexOf("px");
	if(idx != -1){
		val = val.substring(0, idx);
	}
	return parseInt(val);
}

//弹窗时隐藏层下a
function displayDiv(_set){
	 var el = [];
     el = document.getElementsByTagName('a'); 
     for(var i=0,len=el.length; i<len ;i++){
     	if(el[i].id !="order_a" && el[i].id !="authOrderTip_a" && el[i].id !="backButton_a"){
     		$(el[i].id).style.display = _set;
     	}
     }
}

//监听事件
function eventHandler(eventObj)
{
	switch(eventObj.code)
	{
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
			return 0;
	    	break;
	    case "SITV_KEY_PAGEDOWN":
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
 	returnToBizOrHistory();
}

function exit(){
 	window.location.href = "${returnUrl}";
}

function returnToBizOrHistory(){
	//if("${param.returnTo}"!=""&&"${param.returnTo}"!=null){
		//window.location.href = "${returnUrl}";
	//}else{
		history.back();
	//}
}

</script>

<epg:body bgcolor="#000000" onload="init();" onunload="end();">

<epg:img left="0" top="0" width="1280" height="720" src="./images/HYD_detailBg.jpg"/>

<!-- icon -->
<epg:img left="85" top="134" width="220" height="330" src="../${program.icon}"/>

<!-- title -->
<div id="proTitle">
	<epg:text text="${program.title}" width="348" fontSize="30" color="#ffffcc"/>
</div>

<!-- time -->
<epg:text left="366" top="193" width="80" height="22" text="片长：" color="#ababab"/>
<epg:text left="436" top="193" width="540" height="22" text="${program.displayRunTime}分钟"/>
<!-- director -->
<epg:text left="366" top="236" width="80" height="22" text="导演：" color="#ababab"/>
<epg:text left="436" top="236" width="540" height="22" chineseCharNumber="17" dotdotdot="…">
	<epg:choose>
		<epg:when test="${program.director != null}">
			${program.director}
		</epg:when>
		<epg:otherwise>
			无
		</epg:otherwise>
	</epg:choose>
</epg:text>
<!-- actor -->
<epg:text left="366" top="279" width="80" height="22" text="主演：" color="#ababab"/>
<epg:text left="436" top="279" width="540" height="22" chineseCharWidth="27" dotdotdot="…">
	<epg:choose>
		<epg:when test="${program.actors != null}">
			${program.actors}
		</epg:when>
		<epg:otherwise>
			无
		</epg:otherwise>
	</epg:choose>
</epg:text>

<!-- detail -->
<div id="detail">
	<epg:if test="${fn:length(program.summaryMedium)>100}">
		<font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${fn:substring(program.summaryMedium,0,100)}……</font>
	</epg:if>
	<epg:if test="${fn:length(program.summaryMedium)<100}">
		<font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${program.summaryMedium}</font>
	</epg:if>
</div>

<!-- button -->
<div id="btnLayer_0" style="left:369;width:155px;">
	<epg:img id="btn0Img" left="0" top="513" width="155" height="34" src="./images/HYD_HDplay.png"
			 href="javascript:serviceAuth(0,'btn0Img');" defaultfocus="true"/>
	<epg:text id="btn0Txt" left="17" top="518" width="40" height="34" text="${HDProgram.suggestedPrice}" fontSize="24"
			  align="center"/>
</div>

<div id="btnLayer_1" style="left:554;width:155px;">
	<epg:img id="btn1Img" left="0" top="513" width="155" height="34" src="./images/HYD_SDplay.png"
			 href="javascript:serviceAuth(1,'btn1Img');"/>
	<epg:text left="12" top="518" width="40" height="34" text="${SDProgram.suggestedPrice}" fontSize="24" align="center"/>
</div>

<div id="btnLayer_2" style="left:739;width:116px;">
	<epg:img id="btn2Img" left="0" top="513" width="116" height="34" src="./images/HYD_preview.png" href="${playUrl}"
			 rememberFocus="true"/>
</div>

<div id="btnLayer_3" style="left:885;width:97px;">
	<epg:navUrl returnTo="biz" returnUrlVar="returnUrl"/>
	<epg:img id="btn3Img" left="0" top="513" width="97" height="34" src="./images/HYD_return.png" href="javascript:back();"/>
</div>

<!-- tip -->
<div id="tipLayer">
	<epg:img left="0" top="0" width="1280" height="720" src="./images/HYD_tip.png"/>
	<!-- still -->
	<epg:img left="405" top="186" width="130" height="195" src="../${program.still}"/>
	<!-- tip title -->
	<div id="tipTitle">
		<epg:choose>
			<epg:when test="${fn:length(program.title) > 9}">
				<epg:set value="${fn:substring(program.title, 0, 9)}..." var="title"/>
			</epg:when>
			<epg:otherwise>
				<epg:set value="${program.title}" var="title"/>
			</epg:otherwise>
		</epg:choose>
		《${title}》
	</div>
	<!-- time span -->
	<div id="timeSpan">有效期至</div>
	<div id="dateStr">${expireTime}</div>
	<!-- price -->
	<div id="price">价格：￥${proPrice} 元</div>
	<epg:img id="order" left="461" top="513" width="120" height="34" src="${dot}" href="#"/>
	<epg:img id="authOrderTip" left="701" top="513" width="120" height="34" src="${dot}" href="javascript:closeTip(0);"/>
</div>

<div id="orderTipLayer">
	<epg:img left="0" top="0" width="1280" height="720" src="./images/orderTip.png"/>
	<epg:img id="backButton" left="572" top="412" width="132" height="42" src="${dot}" href="javascript:closeTip(1);"/>
</div>

<!-- error info -->
<div id="errorInfo"></div>

</epg:body>
</html>