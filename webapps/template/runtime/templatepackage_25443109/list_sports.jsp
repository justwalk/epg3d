<%@page contentType="text/html; charset=gbk" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<% 
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setDateHeader("Expires", 0); 
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
<epg:navUrl returnTo="home" returnUrlVar="homeUrl"></epg:navUrl>

<epg:navUrl returnTo="biz" returnUrlVar="returnUrl"></epg:navUrl>
<title>体育</title>

<script src="${context['EPG_CONTEXT']}/js/base.js"></script>
<script src="${context['EPG_CONTEXT']}/js/ajax.js"></script>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script>
	function eventHandler(eventObj)
	{
		switch(eventObj.code)
		{	
			case "EIS_IRKEY_BACK":
				window.location.href="${homeUrl}";
				return 0;
				break;
			case "EIS_IRKEY_UP":
		    	break;
			case "EIS_IRKEY_DOWN":
		    	break;
			case "EIS_IRKEY_SELECT":
				break;
			case "EIS_IRKEY_RIGHT":
		    	break;
			case "EIS_IRKEY_LEFT":
		    	break;
		    case "EIS_CA_SMARTCARD_EVULSION":
				iPanel.focus.display = 1;
				iPanel.focus.border = 1;
				window.location.href = "${context['EPG_CONTEXT']}/common/logout/logout.jsp";
				return 0;
				break;
			case "EIS_IRKEY_PAGE_UP":
		    	break;
		    case "EIS_IRKEY_PAGE_DOWN":
		    	break;
			case "EIS_IRKEY_EXIT":
				window.location.href = "${returnUrl}";
				return 0;
				break;
			default:
				return 1;
				break;
		}
	}
	function init(){	
		if(${gameCategoryItems[0]!=null}){
			//document.getElementById("game1_a").focus();
		}else{
			//document.getElementById("menu1_a").focus();
		}
	}
</script>
<epg:body onload="init()" defaultBg="./images/index_sports.jpg"  background="../${templateParams['bgImg']}" style="background-repeat:no-repeat;" bgcolor="#000000" width="1280" height="720" >
	
<!-- 顶部菜单  -->
<epg:grid column="4" row="1" left="329" top="90" width="683" height="52" hcellspacing="0" items="${menuCategoryItems}" var="menuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="menu${curIdx}"  rememberFocus="true" src="./images/dot.gif" 
		left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="170" height="52" href="${indexUrl}"/>
</epg:grid>
<!-- 返回首页 -->
<epg:img id="back" src="./images/dot.gif"  left="1117" top="99"  width="83" height="34" href="${returnUrl}"/>

<!-- 赛事  -->
<epg:navUrl obj="${currentCategoryItems[0]}" indexUrlVar="gameMoreUrl" />
<epg:img id="gameMore" src="./images/dot.gif"  left="499" top="159"  width="139" height="42" href="${gameMoreUrl}"/>
<epg:grid column="1" left="75" top="210" width="550" height="210" row="5" posVar="positions" hcellspacing="0" items="${gameCategoryItems}" var="game" indexVar="curIdx" >
	<epg:text id="game${curIdx}_text" align="left" left="${positions[curIdx-1].x+20}" top="${positions[curIdx-1].y}" width="534" height="44" fontSize="24" 
		chineseCharNumber="21"  dotdotdot="…"  color="#ffffff">${game.title}</epg:text>
	<epg:navUrl obj="${game}" indexUrlVar="indexUrl" />
	<epg:img  id="game${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y-8}" rememberFocus="true"  href="${indexUrl}"  width="534" height="40"  src="./images/dot.gif" />
</epg:grid>

<!-- 新闻  -->
<epg:navUrl obj="${currentCategoryItems[1]}" indexUrlVar="newsMoreUrl" />
<epg:img id="newsMore" src="./images/dot.gif"  left="499" top="417"  width="139" height="42" href="${newsMoreUrl}"/>
<epg:grid column="1" left="75" top="470" width="550" height="210" row="5" posVar="positions" hcellspacing="0" items="${newsCategoryItems}" var="news" indexVar="curIdx" >
	<epg:text id="news${curIdx}_text" align="left" left="${positions[curIdx-1].x+20}" top="${positions[curIdx-1].y}" width="534" height="44" fontSize="24" 
		chineseCharNumber="21"  dotdotdot="…"  color="#ffffff">${news.title}</epg:text>
	<epg:navUrl obj="${news}" indexUrlVar="indexUrl" />
	<epg:img  id="news${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y-8}" rememberFocus="true"  href="${indexUrl}"  width="534" height="40"  src="./images/dot.gif" />
</epg:grid>

<!-- 右上推荐  -->
<epg:if test="${rightUpCategoryItems!=null}">
<epg:img  src="../${rightUpCategoryItems.itemIcon}"  left="652" top="163"  width="558" height="236"/>
</epg:if>

<!-- 专题  -->
<epg:navUrl obj="${currentCategoryItems[4]}" indexUrlVar="projectMoreUrl" />
<epg:img id="projectMore" src="./images/dot.gif"  left="1020" top="417"  width="92" height="42" href="${projectMoreUrl}"/>

<!-- 右下推荐  -->
<epg:if test="${rightDownCategoryItems[0]!=null}">
<epg:navUrl obj="${rightDownCategoryItems[0]}" indexUrlVar="rightDownUrl1" />
<epg:img  src="../${rightDownCategoryItems[0].itemIcon}" href="${rightDownUrl1}" left="672" top="478"  width="520" height="79"/>
</epg:if>
<epg:if test="${rightDownCategoryItems[1]!=null}">
<epg:navUrl obj="${rightDownCategoryItems[1]}" indexUrlVar="rightDownUrl2" />
<epg:img  src="../${rightDownCategoryItems[1].itemIcon}" href="${rightDownUrl2}"  left="672" top="581"  width="520" height="79"/>
</epg:if>
</epg:body>
</epg:html>