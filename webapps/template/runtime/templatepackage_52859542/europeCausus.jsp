<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<epg:html>
<style type="text/css">
body{
	color:#FFFFFF;
	font-size:22;
	font-family:"黑体";
}
img{border:0px solid black;}
div{position: absolute;}
</style>
<!-- left recommend -->
<epg:query queryName="getSeverialItems" maxRows="3" var="leftCategoryItems">
	<epg:param name="categoryCode" value="${templateParams['leftRecommend']}" type="java.lang.String"/>
</epg:query>
<!-- contents -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="12" var="rightCategoryItems"
		   pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true">
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



<epg:body bgcolor="#000000">
<epg:img defaultSrc="./images/oumei2.jpg" src="../${templateParams['backgroundImg']}" width="1280" height="720"/>

<!-- back-->
<epg:img id="backbd" src="./images/dot.png" left="1152" top="65"
	width="70" height="32" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:img id="back" src="./images/dot.png" left="1155" top="68"
	onblur="iconOnblur('backbd');" onfocus="iconOnfocus('backbd')"
	width="70" height="32" href="${returnUrl}" rememberFocus="true"/>

<!-- pageTurn -->
<epg:img id="pageUp" src="./images/dot.png" left="345" top="170"
	 	width="130" height="30" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:img left="348" top="173" width="130" height="30" src="./images/dot.gif" href="${pageBean.previousUrl}"
 	 	onblur="iconOnblur('pageUp');" onfocus="iconOnfocus('pageUp')" pageop="up" keyop="pageup"/>
<epg:img id="pageDown" src="./images/dot.png" left="495" top="170"
	 	width="130" height="30" style="border:3px solid #0bebff;visibility: hidden;" />
<epg:img left="498" top="173" width="130" height="30" src="./images/dot.gif" href="${pageBean.nextUrl}"
		onblur="iconOnblur('pageDown');" onfocus="iconOnfocus('pageDown')" pageop="down" keyop="pagedown"/>

<epg:text left="654" top="176" width="150" height="32" color="#9e8b43" fontSize="22" fontFamily="黑体" align="left"
		  text="${pageBean.pageIndex}/${pageBean.pageCount} 页"/>

<!-- contents -->
<epg:grid left="348" top="218" width="882" height="431" row="2" column="6" items="${rightCategoryItems}"
		var="rightCategoryItem" indexVar="curIdx" posVar="positions" hcellspacing="20" vcellspacing="38">
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
	<epg:img id="right${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="130" height="195"
		onblur="iconOnblur('contentFocus${curIdx}');" onfocus="iconOnfocus('contentFocus${curIdx}')"
		rememberFocus="true" defaultfocus="${isDefaultFocus}" src="../${rightCategoryItem.still}" href="${indexUrl}&returnTo=bizcat"/>
</epg:grid>

<!-- recommend -->
<epg:grid left="64" top="175" width="235" height="471" row="3" column="1" items="${leftCategoryItems}"
		var="leftCategoryItem" indexVar="curIdx" posVar="positions" vcellspacing="34">
	<epg:navUrl obj="${leftCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="leftFocus${curIdx}" src="./images/dot.png" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}"
	 	width="235" height="135" style="border:3px solid #0bebff;visibility: hidden;" />
	<epg:img id="left${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="235" height="135"
		onblur="iconOnblur('leftFocus${curIdx}');" onfocus="iconOnfocus('leftFocus${curIdx}')"
		src="../${leftCategoryItem.itemIcon}" href="${indexUrl}&returnTo=biz&pi=${curIdx}" rememberFocus="true"/>
</epg:grid>

</epg:body>
</epg:html>