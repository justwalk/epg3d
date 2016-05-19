 <%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<epg:html>
<style>
body{
	color:#FFFFFF;
	font-size:22;
	font-family:"黑体";
}
a{outline:none;}
img{border:0px solid black;}
div{position: absolute;}
</style>
<!-- left recommend query -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="1" var="leftCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['leftRecommend']}" type="java.lang.String"/>
</epg:query>

<!-- 预告片-->
<epg:query queryName="getSeverialItems" maxRows="1" var="trailerCategoryItem" >
	<epg:param name="categoryCode" value="${templateParams['trailerCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- contents query -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="12" var="rightCategoryItems"
		   pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true" >
	<epg:param name="categoryCode" value="${templateParams['programCategoryCode']}" type="java.lang.String"  />
</epg:query>
<epg:navUrl returnTo="biz" returnUrlVar="returnUrl"/>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script>
	function iconOnfocus(objId){
		document.getElementById(objId+"_img").style.visibility = 'visible';
	}
	
	function iconOnblur(objId){
		document.getElementById(objId+"_img").style.visibility = 'hidden';
	}
 function pageUp(){
 	document.location.href = "${pageBean.previousUrl}";
 }
 function pageDown(){
 	document.location.href = "${pageBean.nextUrl}";
 }
 function back(){
 	document.location.href = "${returnUrl}";
 }
 function exit(){
 	back();
 }

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
	    	pageUp();
	    	break;
	    case "SITV_KEY_PAGEDOWN":
	    	pageDown();
	    	break;
	    case "SITV_KEY_BACK":
	    	document.location.href = "${returnUrl}";
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
<epg:body bgcolor="#000000">
<epg:img defaultSrc="./images/hanguo2.jpg" src="../${templateParams['backgroundImg']}" width="1280" height="720"/>

<!-- pageTurn -->
<epg:img id="pageUp" src="./images/dot.png" left="336" top="174"
	 width="130" height="32" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:img left="339" top="177" width="130" height="32" src="./images/dot.gif" href="${pageBean.previousUrl}"
 	 	onblur="iconOnblur('pageUp');" onfocus="iconOnfocus('pageUp')" pageop="up" keyop="pageup"/>
<epg:img id="pageDown" src="./images/dot.png" left="486" top="174"
	 width="130" height="32" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:img left="489" top="177" width="130" height="32" src="./images/dot.gif" href="${pageBean.nextUrl}"
		onblur="iconOnblur('pageDown');" onfocus="iconOnfocus('pageDown')" pageop="down" keyop="pagedown"/>
<epg:text left="669" top="178" width="100" height="24" color="#21101d" fontSize="24" align="left" fontFamily="黑体"
		  text="${pageBean.pageIndex}/${pageBean.pageCount} 页"/>
	
<!-- contents -->
<epg:grid left="339" top="218" width="880" height="431" row="2" column="6" items="${rightCategoryItems}"
		  var="rightCategoryItem" indexVar="curIdx" posVar="positions" hcellspacing="20" vcellspacing="42">
	<epg:navUrl obj="${rightCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:choose>
		<epg:when test="${curIdx==1}"> 
 			<epg:set var="isDefaultFocus" value="true"/>
    	</epg:when>
    	<epg:otherwise>
    		<epg:set var="isDefaultFocus" value="false"/>
    	</epg:otherwise>
    </epg:choose>
	<epg:img id="contentFocus${curIdx}" src="./images/dot.png" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"
	 	width="130" height="195" style="border:3px solid #0bebff;visibility: hidden;" />
	<epg:img id="content${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="130" height="195"
			onblur="iconOnblur('contentFocus${curIdx}');" onfocus="iconOnfocus('contentFocus${curIdx}')"
			 rememberFocus="true" defaultfocus="${isDefaultFocus}" src="../${rightCategoryItem.still}" href="${indexUrl}&returnTo=bizcat"/>
	
	
	<epg:if test="${pageBean.pageIndex == 1 && curIdx <= 6}">
        <epg:query queryName="queryEpisodeByCode" maxRows="1000" var="episodes">
	    	<epg:param name="seriesCode" value="${rightCategoryItem.itemCode}" type="java.lang.String" />
        </epg:query>
		<epg:text left="${positions[curIdx-1].x+8}" top="${positions[curIdx-1].y+210}" width="130" height="50"
				  color="#999999" dotdotdot="" fontSize="15" fontFamily="黑体">更新至第     集</epg:text>
		<epg:text left="${positions[curIdx-1].x+70}" top="${positions[curIdx-1].y+205}" width="35" height="50"
				  color="#ffc77d" dotdotdot="" fontSize="24" fontFamily="黑体" align="center" text="${episodes[fn:length(episodes)-1].episodeIndex}"/>
	</epg:if>
</epg:grid>

<!-- recommend -->
<epg:navUrl obj="${leftCategoryItems}" indexUrlVar="leftCategoryIndexUrl" playUrlVar="playUrl"/>
<!-- leftContent0 -->
<epg:img id="leftContent0" src="./images/dot.png" left="66" top="174" width="220" height="330" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:if test="${leftCategoryItems != null}">	
	<epg:img left="69" top="177" width="220" onblur="iconOnblur('leftContent0');" onfocus="iconOnfocus('leftContent0')" href="${leftCategoryIndexUrl}&pi=1&returnTo=biz" height="330" src="../${leftCategoryItems.icon}" />
</epg:if>

<!-- leftContent1 -->
<epg:img id="leftContent1" src="./images/dot.png" left="80" top="525" width="200" height="32" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:if test="${leftCategoryItems != null}">
	<epg:text left="80" top="529" width="200" height="50" color="#f1d4ff" chineseCharNumber="8" dotdotdot=" " fontSize="26" align="center" fontFamily="黑体" text="${leftCategoryItems.title}"/>
	<epg:img left="83" top="528" width="200"  rememberFocus="true" onblur="iconOnblur('leftContent1');" onfocus="iconOnfocus('leftContent1')" href="${leftCategoryIndexUrl}&pi=1&returnTo=biz" height="32" src="./images/dot.gif" />
</epg:if>

<epg:navUrl obj="${trailerCategoryItem}" playUrlVar="trailerplayUrl"/>
<!-- leftContent2 -->
<epg:img id="leftContent2" src="./images/dot.png" left="80" top="575" width="200" height="32" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:if test="${trailerCategoryItem != null}">
	<epg:img id="foreShow2" src="./images/dot.png" left="83" top="576" onblur="iconOnblur('leftContent2');" onfocus="iconOnfocus('leftContent2')" width="200" height="32" href="${trailerplayUrl}&pi=1&returnTo=biz" rememberFocus="true"/>
</epg:if>

<!-- leftContent3 -->
<epg:img id="leftContent3" src="./images/dot.png" left="80" top="616" width="200" height="32" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:if test="${leftCategoryItems != null}">
	<epg:img id="foreShow3" src="./images/dot.png" left="83" top="619" onblur="iconOnblur('leftContent3');" onfocus="iconOnfocus('leftContent3')" width="200" height="32" href="${leftCategoryIndexUrl}&pi=1&returnTo=biz" rememberFocus="true"/>
</epg:if>

<!-- back -->
<epg:img id="backbd" src="./images/dot.png" left="1123" top="86" width="69" height="30" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:img id="back" src="./images/dot.png" left="1126" top="89" onblur="iconOnblur('backbd');" onfocus="iconOnfocus('backbd')" width="69" height="30" href="${returnUrl}" rememberFocus="true"/>

</epg:body>
</epg:html>