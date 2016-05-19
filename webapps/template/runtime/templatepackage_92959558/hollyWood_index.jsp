<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@page import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*"%>
<%@include file="epgUtils.jsp"%>

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
<!-- navigation -->
<epg:query queryName="getSeverialItems" maxRows="6" var="navigations" >
	<epg:param name="categoryCode" value="${templateParams['navigationCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- recommend -->
<epg:query queryName="getSeverialItems" maxRows="6" var="recommends" >
	<epg:param name="categoryCode" value="${templateParams['recommendCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- brandZone -->
<epg:query queryName="getSeverialItems" maxRows="6" var="brandZones" >
	<epg:param name="categoryCode" value="${templateParams['brandCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- specialReport -->
<epg:query queryName="getSeverialItems" maxRows="1" var="srPartOne" >
	<epg:param name="categoryCode" value="${templateParams['specialReportPartOne']}" type="java.lang.String"/>
</epg:query>
<epg:query queryName="getSeverialItems" maxRows="3" var="srPartTwo" >
	<epg:param name="categoryCode" value="${templateParams['specialReportPartTwo']}" type="java.lang.String"/>
</epg:query>
<epg:query queryName="getSeverialItems" maxRows="1" var="srPartThree" >
	<epg:param name="categoryCode" value="${templateParams['specialReportPartThree']}" type="java.lang.String"/>
</epg:query>
<epg:query queryName="getSeverialItems" maxRows="3" var="srPartFour" >
	<epg:param name="categoryCode" value="${templateParams['specialReportPartFour']}" type="java.lang.String"/>
</epg:query>

<!-- backUrl -->
<epg:query queryName="getSeverialItems" maxRows="1" var="returnObj" >
	<epg:param name="categoryCode" value="${templateParams['backCode']}" type="java.lang.String"/>
</epg:query>
<epg:navUrl obj="${returnObj}" indexUrlVar="returnUrl"/>
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
<script type="text/javascript">
	var pageLoad = false;
	var fristFocus = 0;
	if (typeof(iPanel) == 'undefined') {
		pageLoad  = true;
	}
	//监听事件
	function eventHandler(eventObj)
	{
		switch(eventObj.code)
		{
			case "SYSTEM_EVENT_ONLOAD":
				setTimeout(function(){
					pageLoad = true;
					
					if(typeof(iPanel)!='undefined'){
						iPanel.focus.display = 1;
						iPanel.focus.border = 1;
					}
					init();
				},1500);
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
				iPanel.eventFrame.openIndex();
				return 0;
				break;
			default:
				return 1;
				break;
		}
	}

	function getfocus(objId){
		if(pageLoad){
			fristFocus++;
			//var id = objId.substring(0,objId.indexOf("_"));
			//document.getElementById(id+"_img_img").style.visibility="visible";
		}
	}
	function outfocus(objId){
		if(pageLoad){
			//var id = objId.substring(0,objId.indexOf("_"));
			//document.getElementById(id+"_img_img").style.visibility="hidden";
		}
	}
	
	function init(){
		var leaveFocusId = "${leaveFocusId}";
		if(leaveFocusId!=""&& document.getElementById(leaveFocusId+"_a")){
			document.getElementById(leaveFocusId+"_a").focus();
		}else{
			document.getElementById("recommendFocus1_a").focus();
		}
	}
	function end(){
		iPanel.focus.display = 0;
		iPanel.focus.border = 0;
	}

	function back(){
		window.location.href = "${returnUrl}";
	}

	function exit(){
		window.location.href = "${returnUrl}";
	}
	
	function returnToBizOrHistory(){
		//if("${param.returnTo}"!=""&&"${param.returnTo}"!=null){
			window.location.href = "${returnUrl}";
		//}else{
		//	history.back();
		//}
	}
	
</script>
<epg:body bgcolor="#000000" onload="init();" onunload="end();" width="1280" height="720">
<epg:img src="./images/hollyWood_bg.jpg" left="0" top="0" width="1280" height="720"/>

<!-- exit -->
<epg:img id="exit" left="1141" top="55" width="73" height="32" src="${dot}" href="javascript:back();"/>

<!-- navigation -->
<epg:grid left="63" top="117" width="1153" height="35" row="1" column="6" items="${navigations}" var="navigation" indexVar="idx" posVar="pos" hcellspacing="16">
	<epg:if test="${context['EPG_BUSINESS_CODE'] == navigation.itemCode}">
		<epg:img left="63" top="117" width="1153" height="35" src="./images/WLH_nav${idx}.png"/>
	</epg:if>
	<epg:navUrl obj="${navigation}" indexUrlVar="indexUrl"/>
	<epg:img id="menu${idx}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="184" height="35" src="${dot}" href="${indexUrl}"/>
</epg:grid>

<!-- recommend -->
<epg:grid left="63" top="174" width="880" height="301" row="2" column="3" items="${recommends}" var="recommend" indexVar="idx" posVar="pos" hcellspacing="20" vcellspacing="20">
	<epg:navUrl obj="${recommend}" indexUrlVar="indexUrl"/>
	<epg:choose>
		<epg:when test="${idx == 1}">
			<epg:set value="true" var="defaultFocus"/>
		</epg:when>
		<epg:otherwise>
			<epg:set value="false" var="defaultFocus"/>
		</epg:otherwise>
	</epg:choose>
	<epg:img id="recommend${idx}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="280" height="140" src="../${recommend.itemIcon}" />
	<epg:img id="recommendFocus${idx}" left="${pos[idx-1].x-3}" top="${pos[idx-1].y-3}" width="286" height="146" 
		onfocus="getfocus(this.id);" onblur="outfocus(this.id);" rememberFocus="true" defaultfocus="${defaultFocus}" 
		src="./images/dot.gif" href="${indexUrl}&pi=${idx}&returnTo=biz" />
	<epg:img  src="./images/rushTitle.png" left="${pos[idx-1].x}" top="${pos[idx-1].y+103}" width="280" height="37"/>
	<epg:text left="${pos[idx-1].x+7}" top="${pos[idx-1].y+110}" width="280" height="37" align="left"
		chineseCharNumber="10" dotdotdot="…" fontSize="22" fontFamily="黑体" color="#FFFFFF" 
		text="${recommend.title}"/>
</epg:grid>

<!-- brandZone -->
<epg:grid left="67" top="522" width="860" height="140" row="1" column="6" items="${brandZones}" var="brandZone" indexVar="idx" posVar="pos" hcellspacing="10">
	<epg:navUrl obj="${brandZone}" indexUrlVar="indexUrl"/>
	<epg:img left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="135" height="140" src="./images/p${idx-1}.png" href="${indexUrl}&pi=${idx}" rememberFocus="true" id="brandZone${idx}"/>
</epg:grid>

<!-- specialReport One -->
<epg:if test="${srPartOne!=null}">
	<epg:navUrl obj="${srPartOne}" indexUrlVar="indexUrl"/>
	<epg:img id="special1" left="982" top="204" width="235" height="135" src="../${srPartOne.itemIcon}" />
	<epg:img id="special1Focus" left="979" top="201" width="241" height="141" 
		onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
		rememberFocus="true" src="./images/dot.gif" href="${indexUrl}&pi=1&returnTo=biz"/>
	<epg:if test="${srPartTwo[0]!=null}">
		<epg:img left="982" top="302" width="235" height="37" src="./images/HLW_rightShadow.png" />
		<epg:text left="1013" top="309" width="235" height="37" text="${srPartTwo[0].title}" fontFamily="黑体" fontSize="22" color="#C0C0C0" chineseCharNumber="9" dotdotdot="..."/>
	</epg:if>
</epg:if>

<!-- specialReport Two -->
<epg:if test="${srPartTwo[1]!=null}">
	<epg:navUrl obj="${srPartTwo[1]}" indexUrlVar="indexUrl"/>
	<epg:img id="special2" left="982" top="343" width="235" height="37" src="${dot}" rememberFocus="true" href="${indexUrl}&pi=2&returnTo=biz"/>
	<epg:text left="1013" top="350" width="235" height="37" text="${srPartTwo[1].title}" fontFamily="黑体" fontSize="22" color="#C0C0C0" chineseCharNumber="9" dotdotdot="..."/>
</epg:if>

<epg:if test="${srPartTwo[2]!=null}">
	<epg:navUrl obj="${srPartTwo[2]}" indexUrlVar="indexUrl"/>
	<epg:img id="special3" left="982" top="384" width="235" height="37" src="${dot}" rememberFocus="true" href="${indexUrl}&pi=3&returnTo=biz"/>
	<epg:text left="1013" top="391" width="235" height="37" text="${srPartTwo[2].title}" fontFamily="黑体" fontSize="22" color="#C0C0C0" chineseCharNumber="9" dotdotdot="..."/>
</epg:if>

<!-- specialReport Three -->
<epg:if test="${srPartThree!=null}">
	<epg:navUrl obj="${srPartThree}" indexUrlVar="indexUrl"/>
	<epg:img id="special4" left="982" top="431" width="235" height="135" src="../${srPartThree.itemIcon}" />
	<epg:img id="special4Focus" left="979" top="428" width="241" height="141" 
		onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
		rememberFocus="true" src="./images/dot.gif" href="${indexUrl}&pi=1&returnTo=biz"/>
	<epg:if test="${srPartFour[0]!=null}">
		<epg:img left="982" top="529" width="235" height="37" src="./images/HLW_rightShadow.png" />
		<epg:text left="1013" top="536" width="235" height="37" text="${srPartFour[0].title}" fontFamily="黑体" fontSize="22" color="#C0C0C0" chineseCharNumber="9" dotdotdot="..."/>
	</epg:if>
</epg:if>

<!-- specialReport Four -->
<epg:if test="${srPartFour[1]!=null}">
	<epg:navUrl obj="${srPartFour[1]}" indexUrlVar="indexUrl"/>
	<epg:img id="special5" left="982" top="570" width="235" height="37" src="${dot}" rememberFocus="true" href="${indexUrl}&pi=2&returnTo=biz"/>
	<epg:text left="1013" top="577" width="235" height="37" text="${srPartFour[1].title}" fontFamily="黑体" fontSize="22" color="#C0C0C0" chineseCharNumber="9" dotdotdot="..."/>
</epg:if>

<epg:if test="${srPartFour[2]!=null}">
	<epg:navUrl obj="${srPartFour[2]}" indexUrlVar="indexUrl"/>
	<epg:img id="special6" left="982" top="611" width="235" height="37" src="${dot}" rememberFocus="true" href="${indexUrl}&pi=3&returnTo=biz"/>
	<epg:text left="1013" top="618" width="235" height="37" text="${srPartFour[2].title}" fontFamily="黑体" fontSize="22" color="#C0C0C0" chineseCharNumber="9" dotdotdot="..."/>
</epg:if>
</epg:body>
</epg:html>