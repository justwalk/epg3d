<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*"%>
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
<!--菜单导航-->
<epg:query queryName="getSeverialItems" maxRows="4" var="menus" >
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!--查询得到左上方焦点新闻-->
<epg:query queryName="getSeverialItems" maxRows="6" var="newsRecommandResults">
	<epg:param name="categoryCode" value="${templateParams['leftUpRecommandCategory']}" type="java.lang.String"/>
</epg:query>

<!--查询得到右上方赛事直播回看-->
<epg:query queryName="getSeverialItems" maxRows="6" var="ssLiveRecommandResults" >
	<epg:param name="categoryCode" value="${templateParams['ssLiveCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!--查询得到右上方赛事图片 ssPicCategoryCode -->
<epg:query queryName="getSeverialItems" maxRows="1" var="ssResults" >
	<epg:param name="categoryCode" value="${templateParams['ssPicCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!--查询射手榜图推荐位-->
<epg:query queryName="getSeverialItems" maxRows="1" var="ScorersResults" >
	<epg:param name="categoryCode" value="${templateParams['ScorersCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!--查询中间推荐位图-->
<epg:query queryName="getSeverialItems" maxRows="1" var="MiddleResults" >
	<epg:param name="categoryCode" value="${templateParams['MiddleCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!--查询助攻榜图推荐位-->
<epg:query queryName="getSeverialItems" maxRows="1" var="AssistsResults" >
	<epg:param name="categoryCode" value="${templateParams['AssistsCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!--查询得到右下图推荐位-->
<epg:query queryName="getSeverialItems" maxRows="1" var="jcResults" >
	<epg:param name="categoryCode" value="${templateParams['rightDownCategoryCode']}" type="java.lang.String"/>
</epg:query>

<epg:navUrl returnTo="home" returnUrlVar="returnUrl"></epg:navUrl>
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

<script>
var pageLoad = false;
var fristFocus = 0;
if (typeof(iPanel) == 'undefined') {
	pageLoad  = true;
}

//监听事件
function eventHandler(eventObj){
	switch(eventObj.code){
		case "SYSTEM_EVENT_ONLOAD":
			pageLoad = true;
			break;
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
	window.location.href = "${returnUrl}";
}

function exit(){
	window.location.href = "${returnUrl}";
}

function itemOnFocus(objId){
	document.getElementById(objId+"_span").style.color = "#946705";
}
//失去焦点事件
function itemOnBlur(objId){
	document.getElementById(objId+"_span").style.color = "#16442d";
}

function init(){
	document.getElementById("main").style.display = "block";
	iPanel.focus.display = 1;
	iPanel.focus.border = 1;
	
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""&&document.getElementById(leaveFocusId+"_a")){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		if(document.getElementById("listText1_a")){
			document.getElementById("listText1_a").focus();
		}else{
			document.getElementById("menu1_a").focus();
		}
	}
}
</script>
<epg:body onload="init()"   bgcolor="#000000"  width="1280" height="720" >
<!-- bg/head -->
<epg:img defaultSrc="./images/WorldCupBg.jpg" src="../${templateParams['backgroundImg']}" width="1280" height="720"/>

<!-- 同时显现处理 -->
<div id="main" style="display:none;position:absolute;left:0;top:0;width:1280;height:720;">
<!-- 导航菜单 -->
<epg:grid column="4" row="1" left="386" top="41" width="618" height="38"  items="${menus}" var="menu"  indexVar="curIdx" posVar="positions" hcellspacing="58">
	<epg:navUrl obj="${menu}" indexUrlVar="indexUrl"/>
	<epg:img id="menu${curIdx}" rememberFocus="true" 
		src="./images/dot.gif" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="111" height="38" href="${indexUrl}"/>
</epg:grid>

<!-- back -->
<epg:img id="quitMenu" left="1114" top="41" width="83" height="39" src="./images/dot.gif"  href="${returnUrl}"/>

<!-- 焦点新闻 -->
<epg:grid left="77" top="171" width="733" height="248" row="6" column="1" items="${newsRecommandResults}" var="list" indexVar="idx"
		posVar="pos" vcellspacing="10">
	<epg:navUrl obj="${list}" indexUrlVar="indexUrl"/>
	<epg:text color="#16442d" left="${pos[idx-1].x}" top="${pos[idx-1].y+3}" align="left" height="33" id="listText${idx}"  width="733" fontSize="24"
		text="${list.title}" href="${indexUrl}" onfocus="itemOnFocus('listText${idx}')" onblur="itemOnBlur('listText${idx}')"/>
</epg:grid>
<!-- 更多 -->
<epg:navUrl obj="${menus[2]}" indexUrlVar="indexUrl"/>
<epg:img id="newsMore" src="./images/dot.gif" left="243" top="128" width="86" height="30" href="${indexUrl}"/>


<!-- 赛事回看 -->
<epg:grid left="1107" top="172" width="89" height="248" row="6" column="1" items="${ssLiveRecommandResults}" var="list" indexVar="idx"
		posVar="pos" vcellspacing="10">
	<epg:navUrl obj="${list}" indexUrlVar="indexUrl"/>
	<epg:img src="./images/lookBack.png" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="89" height="33" href="${indexUrl}"/>
</epg:grid>

<!-- 赛事预告底图 -->
<epg:if test="${ssResults!=null}">
	<epg:img src="../${ssResults.itemIcon}" left="834" top="164" width="266" height="262"/>
</epg:if>

<!-- 射手榜推荐图 -->
<epg:if test="${ScorersResults!=null}">
	<epg:img src="../${ScorersResults.itemIcon}" left="63" top="483" width="243" height="198"/>
</epg:if>
<!-- 助攻榜推荐图 -->
<epg:if test="${AssistsResults!=null}">
	<epg:img src="../${AssistsResults.itemIcon}" left="321" top="483" width="243" height="198"/>
</epg:if>
<!-- 中间推荐图 -->
<epg:if test="${MiddleResults!=null}">
	<epg:navUrl obj="${MiddleResults}" indexUrlVar="indexUrlMd"/>
	<epg:img src="../${MiddleResults.itemIcon}" left="579" top="441" width="240" height="240" href="${indexUrlMd}"/>
</epg:if>

<!-- 右下竞猜推荐 -->
<epg:if test="${jcResults!= null}">
	<epg:navUrl obj="${jcResults}" indexUrlVar="indexUrljc"/>
	<epg:img src="../${jcResults.itemIcon}" left="834" top="441"  width="382" height="240" href="${indexUrljc}" />
</epg:if>

</div>
</epg:body>
</epg:html>