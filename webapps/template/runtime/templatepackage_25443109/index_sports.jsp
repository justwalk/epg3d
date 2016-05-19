<%@page contentType="text/html; charset=gbk" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
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
%>

<epg:html>
<!-- 首页顶部菜单分类  -->
<epg:query queryName="getSeverialItems" maxRows="4" var="menuCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 当前栏目分类  -->
<epg:query queryName="getSeverialItems" maxRows="5" var="currentCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['currentCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 赛事  -->
<epg:query queryName="getSeverialItems" maxRows="5" var="gameCategoryItems" >
	<epg:param name="categoryCode" value="${currentCategoryItems[0].itemCode}" type="java.lang.String"/>
</epg:query>
<!-- 新闻  -->
<epg:query queryName="getSeverialItems" maxRows="5" var="newsCategoryItems" >
	<epg:param name="categoryCode" value="${currentCategoryItems[1].itemCode}" type="java.lang.String"/>
</epg:query>
<!-- 右上推荐  -->
<epg:query queryName="getSeverialItems" maxRows="1" var="rightUpCategoryItems" >
	<epg:param name="categoryCode" value="${currentCategoryItems[2].itemCode}" type="java.lang.String"/>
</epg:query>
<!-- 右下推荐  -->
<epg:query queryName="getSeverialItems" maxRows="2" var="rightDownCategoryItems" >
	<epg:param name="categoryCode" value="${currentCategoryItems[3].itemCode}" type="java.lang.String"/>
</epg:query>

<epg:navUrl returnTo="home" returnUrlVar="returnUrl"></epg:navUrl>
<title>体育</title>

<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<style>
	a{
	outline:none;
}
</style>
<script type="text/javascript">
	var pageLoad = false;
	var fristFocus = 0;
	if (typeof(iPanel) == 'undefined') {
		pageLoad  = true;
	}
	function init(){
		var leaveFocusId = "${leaveFocusId}";
		if(leaveFocusId!=""&&document.getElementById(leaveFocusId+"_a")){
			document.getElementById(leaveFocusId+"_a").focus();
		}else{
			document.getElementById("game1_a").focus();
		}
	}
	function getfocus(objId){
		if(pageLoad){
			var id;
			if("r_"==objId.substring(0,2)){
				id = objId.substring(2,objId.indexOf("_"));
			}
			else{
				id = objId.substring(0,objId.indexOf("_"));
			}
			fristFocus++;
			document.getElementById(id+"_img_img").style.visibility="visible";
			document.getElementById("r_"+id+"_img_img").style.visibility="visible";
		}
	}
	function outfocus(objId){
		if(pageLoad){
			var id;
			if("r_"==objId.substring(0,2)){
				id = objId.substring(2,objId.indexOf("_"));
			}
			else{
				id = objId.substring(0,objId.indexOf("_"));
			}
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
	    	window.location.href = "${returnUrl}";
			return 0;
	    	break;
		case "SITV_KEY_EXIT":
			window.location.href = "${returnUrl}";
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
<epg:body onload="init()"  >

<div id="leftDiv">
	<!-- 背景图片以及头部图片 -->
		<epg:img src="../${templateParams['bgImg']}" id="main" width="640" height="720" left="0" />
		
<!-- 顶部菜单  -->
<epg:grid column="4" row="1" left="165" top="90" width="342" height="52" hcellspacing="0" items="${menuCategoryItems}" var="menuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="menu${curIdx}" rememberFocus="true" src="./images/dot.gif" 
	 onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
		left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="85" height="52" href="${indexUrl}"/>
	<epg:img id="menu${curIdx}_img"  src="./images/dot.gif" 
	style="visibility:hidden;border:3px solid #ff9c13" 
		left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="85" height="52"/>
</epg:grid>
<!-- 返回首页 -->
<epg:img id="back" src="./images/dot.gif"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="557" top="96"  width="41" height="34" href="${returnUrl}"/>
<epg:img id="back_img" src="./images/dot.gif" style="visibility:hidden;border:3px solid #ff9c13"  left="557" top="96"  width="41" height="34"/>

<!-- 赛事  -->
<epg:navUrl obj="${currentCategoryItems[0]}" indexUrlVar="gameMoreUrl" />
<epg:img rememberFocus="true" id="gameMore" src="./images/dot.gif" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  left="248" top="156"  width="70" height="42" href="${gameMoreUrl}"/>
<epg:img id="gameMore_img" src="./images/dot.gif" style="visibility:hidden;border:3px solid #ff9c13"  left="248" top="156"  width="70" height="42" />

<epg:grid column="1" left="38" top="210" width="275" height="210" row="5" posVar="positions" hcellspacing="0" items="${gameCategoryItems}" var="game" indexVar="curIdx" >
	<epg:text id="game${curIdx}_text" align="left" left="${positions[curIdx-1].x+10}" top="${positions[curIdx-1].y}" width="267" height="44" fontSize="12" 
		chineseCharNumber="21"  dotdotdot="…"  color="#ffffff">${game.title}</epg:text>
	<epg:navUrl obj="${game}" indexUrlVar="indexUrl" />
	<epg:img  id="game${curIdx}"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-8}" rememberFocus="true"  href="${indexUrl}&pi=${curIdx}"  width="267" height="40"  src="./images/dot.gif" />
	<epg:img  id="game${curIdx}_img" style="visibility:hidden;border:3px solid #ff9c13"  left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-8}"  width="267" height="40"  src="./images/dot.gif" />
</epg:grid>

<!-- 新闻  -->
<epg:navUrl obj="${currentCategoryItems[1]}" indexUrlVar="newsMoreUrl" />
<epg:img rememberFocus="true" id="newsMore" src="./images/dot.gif"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  left="248" top="414"  width="70" height="42" href="${newsMoreUrl}"/>
<epg:img id="newsMore_img" src="./images/dot.gif" style="visibility:hidden;border:3px solid #ff9c13"  left="248" top="414"  width="70" height="42"/>


<epg:grid column="1" left="38" top="470" width="275" height="210" row="5" posVar="positions" hcellspacing="0" items="${newsCategoryItems}" var="news" indexVar="curIdx" >
	<epg:text id="news${curIdx}_text" align="left" left="${positions[curIdx-1].x+10}" top="${positions[curIdx-1].y-3}" width="267" height="44" fontSize="12" 
		chineseCharNumber="21"  dotdotdot="…"  color="#ffffff">${news.title}</epg:text>
	<epg:navUrl obj="${news}" indexUrlVar="indexUrl" />
	<epg:img  id="news${curIdx}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-8}" rememberFocus="true"  href="${indexUrl}&pi=${curIdx}"  width="267" height="40"  src="./images/dot.gif" />
	<epg:img  id="news${curIdx}_img" style="visibility:hidden;border:3px solid #ff9c13"  left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-8}" width="267" height="40"  src="./images/dot.gif" />
</epg:grid>

<!-- 右上推荐  -->
<epg:if test="${rightUpCategoryItems!=null}">
<epg:img  src="../${rightUpCategoryItems.itemIcon}"  left="326" top="163"  width="279" height="236"/>
</epg:if>

<!-- 专题  -->
<epg:navUrl obj="${currentCategoryItems[4]}" indexUrlVar="projectMoreUrl" />
<epg:img rememberFocus="true" id="projectMore" src="./images/dot.gif"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="508" top="414"  width="46" height="42" href="${projectMoreUrl}"/>
<epg:img id="projectMore_img" src="./images/dot.gif" style="visibility:hidden;border:3px solid #ff9c13"  left="508" top="414"  width="46" height="42" />

<!-- 右下推荐  -->
<epg:if test="${rightDownCategoryItems[0]!=null}">
	<epg:navUrl obj="${rightDownCategoryItems[0]}" indexUrlVar="rightDownUrl1" />
	<epg:img  src="../${rightDownCategoryItems[0].itemIcon}" left="336" top="478"  width="260" height="79"/>
	<epg:img rememberFocus="true" id="rightDown1" src="./images/dot.gif" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" href="${rightDownUrl1}&pi=1" left="335" top="475"  width="260" height="79"/>
	<epg:img id="rightDown1_img" src="./images/dot.gif" style="visibility:hidden;border:3px solid #ff9c13"  left="335" top="475"  width="260" height="79"/>
</epg:if>
<epg:if test="${rightDownCategoryItems[1]!=null}">
	<epg:navUrl obj="${rightDownCategoryItems[1]}" indexUrlVar="rightDownUrl2" />
	<epg:img  src="../${rightDownCategoryItems[1].itemIcon}"  left="336" top="581"  width="260" height="79"/>
	<epg:img rememberFocus="true" id="rightDown2"  src="./images/dot.gif" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" href="${rightDownUrl2}&pi=2"  left="335" top="578"  width="260" height="79"/>
	<epg:img  id="rightDown2_img"  src="./images/dot.gif"  style="visibility:hidden;border:3px solid #ff9c13"  left="335" top="578"  width="260" height="79"/>
</epg:if>
</div>

<div id="rightDiv">
	<!-- 背景图片以及头部图片 -->
		<epg:img src="../${templateParams['bgImg']}" id="r_main" width="640" height="720" left="640"/>
		
<!-- 顶部菜单  -->
<epg:grid column="4" row="1" left="805" top="90" width="342" height="52" hcellspacing="0" items="${menuCategoryItems}" var="menuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="r_menu${curIdx}" rememberFocus="true" src="./images/dot.gif" 
	 onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
		left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="85" height="52" href="${indexUrl}"/>
	<epg:img id="r_menu${curIdx}_img"  src="./images/dot.gif" 
	style="visibility:hidden;border:3px solid #ff9c13" 
		left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="85" height="52"/>
</epg:grid>
<!-- 返回首页 -->
<epg:img id="r_back" src="./images/dot.gif"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="1197" top="96"  width="41" height="34" href="${returnUrl}"/>
<epg:img id="r_back_img" src="./images/dot.gif" style="visibility:hidden;border:3px solid #ff9c13"  left="1197" top="96"  width="41" height="34"/>

<!-- 赛事  -->
<epg:navUrl obj="${currentCategoryItems[0]}" indexUrlVar="gameMoreUrl" />
<epg:img rememberFocus="true" id="r_gameMore" src="./images/dot.gif" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  left="888" top="156"  width="70" height="42" href="${gameMoreUrl}"/>
<epg:img id="r_gameMore_img" src="./images/dot.gif" style="visibility:hidden;border:3px solid #ff9c13"  left="888" top="156"  width="70" height="42" />

<epg:grid column="1" left="678" top="210" width="275" height="210" row="5" posVar="positions" hcellspacing="0" items="${gameCategoryItems}" var="game" indexVar="curIdx" >
	<epg:text id="r_game${curIdx}_text" align="left" left="${positions[curIdx-1].x+10}" top="${positions[curIdx-1].y}" width="267" height="44" fontSize="12" 
		chineseCharNumber="21"  dotdotdot="…"  color="#ffffff">${game.title}</epg:text>
	<epg:navUrl obj="${game}" indexUrlVar="indexUrl" />
	<epg:img  id="r_game${curIdx}"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-8}" rememberFocus="true"  href="${indexUrl}&pi=${curIdx}"  width="267" height="40"  src="./images/dot.gif" />
	<epg:img  id="r_game${curIdx}_img" style="visibility:hidden;border:3px solid #ff9c13"  left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-8}"  width="267" height="40"  src="./images/dot.gif" />
</epg:grid>

<!-- 新闻  -->
<epg:navUrl obj="${currentCategoryItems[1]}" indexUrlVar="newsMoreUrl" />
<epg:img rememberFocus="true" id="r_newsMore" src="./images/dot.gif"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  left="888" top="414"  width="70" height="42" href="${newsMoreUrl}"/>
<epg:img id="r_newsMore_img" src="./images/dot.gif" style="visibility:hidden;border:3px solid #ff9c13"  left="888" top="414"  width="70" height="42"/>


<epg:grid column="1" left="678" top="470" width="275" height="210" row="5" posVar="positions" hcellspacing="0" items="${newsCategoryItems}" var="news" indexVar="curIdx" >
	<epg:text id="r_news${curIdx}_text" align="left" left="${positions[curIdx-1].x+10}" top="${positions[curIdx-1].y-3}" width="267" height="44" fontSize="12" 
		chineseCharNumber="21"  dotdotdot="…"  color="#ffffff">${news.title}</epg:text>
	<epg:navUrl obj="${news}" indexUrlVar="indexUrl" />
	<epg:img  id="r_news${curIdx}" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-8}" rememberFocus="true"  href="${indexUrl}&pi=${curIdx}"  width="267" height="40"  src="./images/dot.gif" />
	<epg:img  id="r_news${curIdx}_img" style="visibility:hidden;border:3px solid #ff9c13"  left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-8}" width="267" height="40"  src="./images/dot.gif" />
</epg:grid>

<!-- 右上推荐  -->
<epg:if test="${rightUpCategoryItems!=null}">
<epg:img  src="../${rightUpCategoryItems.itemIcon}"  left="976" top="163"  width="279" height="236"/>
</epg:if>

<!-- 专题  -->
<epg:navUrl obj="${currentCategoryItems[4]}" indexUrlVar="projectMoreUrl" />
<epg:img rememberFocus="true" id="r_projectMore" src="./images/dot.gif"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);" left="1148" top="414"  width="46" height="42" href="${projectMoreUrl}"/>
<epg:img id="r_projectMore_img" src="./images/dot.gif" style="visibility:hidden;border:3px solid #ff9c13"  left="1148" top="414"  width="46" height="42" />

<!-- 右下推荐  -->
<epg:if test="${rightDownCategoryItems[0]!=null}">
	<epg:navUrl obj="${rightDownCategoryItems[0]}" indexUrlVar="rightDownUrl1" />
	<epg:img  src="../${rightDownCategoryItems[0].itemIcon}" left="986" top="478"  width="260" height="79"/>
	<epg:img rememberFocus="true" id="r_rightDown1" src="./images/dot.gif" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" href="${rightDownUrl1}&pi=1" left="975" top="475"  width="260" height="79"/>
	<epg:img id="r_rightDown1_img" src="./images/dot.gif" style="visibility:hidden;border:3px solid #ff9c13"  left="975" top="475"  width="260" height="79"/>
</epg:if>
<epg:if test="${rightDownCategoryItems[1]!=null}">
	<epg:navUrl obj="${rightDownCategoryItems[1]}" indexUrlVar="rightDownUrl2" />
	<epg:img  src="../${rightDownCategoryItems[1].itemIcon}"  left="986" top="581"  width="260" height="79"/>
	<epg:img rememberFocus="true" id="r_rightDown2"  src="./images/dot.gif" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" href="${rightDownUrl2}&pi=2"  left="975" top="578"  width="260" height="79"/>
	<epg:img  id="r_rightDown2_img"  src="./images/dot.gif"  style="visibility:hidden;border:3px solid #ff9c13"  left="975" top="578"  width="260" height="79"/>
</epg:if>
</div>
</epg:body>
</epg:html>