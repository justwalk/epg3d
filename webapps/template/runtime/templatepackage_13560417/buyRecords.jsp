<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@page import="sitv.epg.config.EpgConfigUtils"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.*"%>
<%@page import="sitv.epg.web.tag.help.AbstractUrlGenerator"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<epg:html>
<%
	String templateRoot = EpgConfigUtils.getInstance().getProperty("navigator.template.root.path");
	request.setAttribute("templateRoot",templateRoot);
%>
<epg:set var="imgPath" 
		 value="${context['EPG_CONTEXT']}/${templateRoot}/${CONTEXT_OBJ['currentTemplatePackageCode']}/images"/>
<epg:set value="./images/dot.gif" var="dot"/>

<%
	String chooseMonth = request.getParameter("chooseMonth");
	
	SimpleDateFormat MM =  new SimpleDateFormat("MM");
	SimpleDateFormat yearMonth =  new SimpleDateFormat("yyyy年");
	String yearStr = yearMonth.format(new Date()).toString();
	request.setAttribute("curYear",yearStr);
	
	Date now = new Date();
	int curMonth = now.getMonth() + 1;
	request.setAttribute("curMonth",curMonth);
	
	if(!StringUtils.isBlank(chooseMonth)){
	    curMonth = Integer.parseInt(chooseMonth);
	}
	
	request.setAttribute("month",curMonth);
	
	Calendar monthOneC = Calendar.getInstance();
	monthOneC.add(monthOneC.MONTH,-1);
    Date dayOne = monthOneC.getTime();
    request.setAttribute("monthOne",checkMonth(MM.format(dayOne).toString()));
    
    Calendar monthTwoC = Calendar.getInstance();
    monthTwoC.add(monthTwoC.MONTH,-2);
    Date dayTwo = monthTwoC.getTime();
    request.setAttribute("monthTwo",checkMonth(MM.format(dayTwo).toString()));
    
	String UrlBase = (String)request.getAttribute("urlBase");
	String queryStr = AbstractUrlGenerator.createFixUrlParamsByUrl(request);
	request.setAttribute("baseUrl",new StringBuffer(UrlBase).append("?").append(queryStr));
%>
<%!
	private boolean compareToTime(Object expired){
    	Date now = new Date();
    	Date expiredTime = (Date) expired;
    	return now.compareTo(expiredTime) < 0 ? true : false;
	}

	private String checkMonth(String month){
	    int idx = month.indexOf("0");
	    String newMonth = "";
	    if(idx != -1){
	        newMonth = month.substring(idx+1);
	    }else{
	        newMonth = month;
	    }
	    return newMonth;
	}
%>

<!-- right up recommend -->
<epg:query queryName="getSeverialItems" maxRows="1" var="rightUpRecommend">
	<epg:param name="categoryCode" value="${templateParams['rightUpRecommend']}" type="java.lang.String"/>
</epg:query>
<epg:query queryName="queryPlayableProgramCode" maxRows="1" var="programName">
	<epg:param name="contentCode" value="${rightUpRecommend.itemCode}" type="java.lang.String" />
</epg:query>

<!-- collects -->
<epg:query queryName="getSevrialCollectionByUserId" maxRows="16" var="collects"
		   pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true">
	<epg:param name="user_id" value="${EPG_USER.userAccount}" type="java.lang.String"/>
</epg:query>
<epg:navUrl returnTo="home" returnUrlVar="returnHomeUrl"/>

<!-- user order info -->
<epg:query queryName="findUserOrderByStbIdAndTime" maxRows="8" var="orders"
		   pageBeanVar="orderPageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true">
	<epg:param name="STB_ID" value="${EPG_USER.userAccount}" type="java.lang.String"/>
	<epg:param name="ORDER_MONTH" value="${month}" type="java.lang.String"/>
</epg:query>

<style type="text/css">
body{
	color:#FFFFFF;
	font-size:22;
	font-family:"黑体";
}
img{border:0px solid black;}
div{position: absolute;}
</style>

<script>
function $(_id) {
	return "string" == typeof _id ? document.getElementById(_id) : _id;
}

function buttonOnFocus(objId,img){
	$(objId+"_img").src= "${imgPath}/"+img+".png";
}

function buttonOnBlur(objId,img){
	$(objId+"_img").src= "${imgPath}/"+img+".png";
}

function monthOnFocus(objId){
	$(objId+"_img").src = "${imgPath}/episodeFocus.png";
	$(objId+"_span").style.color = "#FFFFFF";
}

function monthOnBlur(objId){
	$(objId+"_img").src = "${imgPath}/month.png";
	$(objId+"_span").style.color = "#1978b8";
}

function recOnFocus(objId){
	$(objId).style.visibility = "visible";
	$("recPlay").style.visibility = "visible";
}

function recOnBlur(objId){
	$(objId).style.visibility = "hidden";
	$("recPlay").style.visibility = "hidden";
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
			window.location.href = "${pageBean.previousUrl}";
			return 0;
	    	break;
	    case "SITV_KEY_PAGEDOWN":
			location.href = "${pageBean.nextUrl}";	
			return 0;
	    	break;
	    case "SITV_KEY_BACK":
	    	window.location.href = "${returnHomeUrl}";
			return 0;
	    	break;
		case "SITV_KEY_EXIT":
			window.location.href = "${returnHomeUrl}";
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
<epg:body bgcolor="#000000" width="1280" height="720">

<epg:img src="./images/buyRecordBg.jpg" left="0" top="0" width="1280" height="720"/>
<epg:img src="./images/logo.png" left="0" top="0" width="350" height="85"/>

<epg:img id="search" rememberFocus="true" src="${dot}" left="1050" top="47" width="80" height="38"
		 onfocus="buttonOnFocus('search','focusMenuTop_1');" onblur="buttonOnFocus('search','dot');"
		 href="${context['EPG_SEARCH_URL']}"/>

<epg:img id="home" rememberFocus="true" src="${dot}" left="1150" top="47"width="80" height="38"
	     onfocus="buttonOnFocus('home','focusMenuTop_3');" onblur="buttonOnFocus('home','dot');"
	     href="${returnHomeUrl}"/>

<!--<epg:img id="buyRecords" left="50" top="90" width="391" height="45" href="${context['EPG_SELF_URL']}" src="${dot}"
		 onfocus="buttonOnFocus('buyRecords','buyRecordOnfocus');" onblur="buttonOnBlur('buyRecords','dot');"/>-->
<epg:img id="history" left="50" top="90" width="391" height="45" href="${context['EPG_HISTORY_URL']}" src="${dot}"
		 onfocus="buttonOnFocus('history','historyOnfocus');" onblur="buttonOnBlur('history','dot');"/>
<epg:img id="collect" left="443" top="90" width="391" height="45" href="${context['EPG_MYCOLLECTION_URL']}" src="${dot}"
		 onfocus="buttonOnFocus('collect','collectOnfocus');" onblur="buttonOnBlur('collect','dot');"/>

<epg:choose>
	<epg:when test="${pageBean == null}">
		<epg:set value="0" var="collectCount"/>
	</epg:when>
	<epg:otherwise>
		<epg:set value="${pageBean.totalCount}" var="collectCount"/>
	</epg:otherwise>
</epg:choose>
<epg:text left="1139" top="104" width="80" height="30" text="${collectCount}部"
		  fontFamily="黑体" fontSize="20" color="#fff" align="center"/>

<!-- 本月按次点播历史 -->
<div align="left" style="left:50px;top:140px;width:390px;height:50px;line-height:50px;">
	<font style="font-family:'黑体';font-size:26px;color:#666666;">本月按次点播历史（${curYear}${month}月）</font>
</div>

<!-- pageTurn / pageNum -->
<epg:img id="pre" src="${dot}" left="50" top="190" width="130" height="32"
		 href="${orderPageBean.previousUrl}&chooseMonth=${month}" pageop="up" keyop="pageup"
		 onfocus="buttonOnFocus('pre','prePage_focus');" onblur="buttonOnFocus('pre','dot');"/>
<epg:img id="next" src="${dot}" left="200" top="190" width="130" height="32"
		 href="${orderPageBean.nextUrl}&chooseMonth=${month}" pageop="down" keyop="pagedown"
		 onfocus="buttonOnFocus('next','nextPage_focus');" onblur="buttonOnFocus('next','dot');"/>

<div align="right" style="left:340px;top:194px;width:35px;height:19px;">
	<font id="pageIndex" style="font-family:'黑体';font-size:22px;color:#1978b8;">${orderPageBean.pageIndex}</font>
</div>
<div align="left" style="left:375px;top:194px;width:80px;height:19px;">
	<font id="pageTotal" style="font-family:'黑体';font-size:22px;color:#9c9c9c;">/${orderPageBean.pageCount}页</font>
</div>

<!-- buy records -->
<epg:grid left="50" top="266" width="770" height="400" row="8" column="1" items="${orders}" var="order"
 		  indexVar="idx" posVar="pos">
	<epg:choose>
		<epg:when test="${idx == 1}">
			<epg:set value="true" var="defaultFocus"/>
		</epg:when>
		<epg:otherwise>
			<epg:set value="false" var="defaultFocus"/>
		</epg:otherwise>
	</epg:choose>
	<!-- contentName -->
	<div align="left" style="left:${pos[idx-1].x}px;top:${pos[idx-1].y}px;width:310px;height:50px;line-height:50px;
							 margin:0 10px;">
		<font id="orderTile${idx}" style="font-family:'黑体';font-size:26px;color:#666666;">
			<epg:choose>
				<epg:when test="${fn:length(order.contentName)>12}">
					${fn:substring(order.contentName,0,12)}...
				</epg:when>
				<epg:otherwise>
					${order.contentName}
				</epg:otherwise>
			</epg:choose>
		</font>
	</div>
	<!-- orderTime -->
	<div style="left:${pos[idx-1].x+320}px;top:${pos[idx-1].y}px;width:135px;height:50px;line-height:50px;text-align:center;">
		<fmt:formatDate pattern="yyyy.MM.dd" value="${order.orderTime}" var="date"/>
		<font style="font-size:24px;color:#555;">${date}</font>
	</div>
	<!-- fee -->
	<epg:img left="${pos[idx-1].x+107}" top="${pos[idx-1].y+20}" width="11" height="15" src="./images/symbol.png"/>
	<fmt:formatNumber pattern="0.00" value="${order.fee}" var="fee"/>
	<div style="left:${pos[idx-1].x+477}px;top:${pos[idx-1].y}px;width:90px;height:50px;line-height:50px;text-align:center;">
		<font style="font-size:24px;color:#e74c3c;">${fee}</font>
	</div>
	<!-- status -->
	<epg:navUrl obj="${order}" playUrlVar="playUrl" indexUrlVar="indexUrl" />
	<div style="left:${pos[idx-1].x+570}px;top:${pos[idx-1].y}px;width:100px;height:50px;line-height:50px;text-align:center;">
		<epg:set value="${order.expiredTime}" var="expire"/>
		<epg:set value='<%=compareToTime(pageContext.getAttribute("expire"))%>' var="expired"/>
		<epg:choose>
			<epg:when test="${expired}">
				<font style="font-size:24px;color:#555;">有效</font>
				<epg:set value="play" var="type"/>
				<epg:set value="${playUrl}" var="url"/>
			</epg:when>
			<epg:otherwise>
				<font style="font-size:24px;color:#555;">已过期</font>
				<epg:set value="renew" var="type"/>
				<epg:set value="${indexUrl}" var="url"/>
			</epg:otherwise>
		</epg:choose>
	</div>
	<!-- btn -->
	<epg:img id="${type}${idx}" left="${pos[idx-1].x+345}" top="${pos[idx-1].y+8}" width="80" height="32"
			 src="./images/${type}.png" href="${url}" rememberFocus="true" defaultfocus="${defaultFocus}"
			 onfocus="buttonOnFocus('${type}${idx}','${type}OnFocus');"
			 onblur="buttonOnBlur('${type}${idx}','${type}');"/>
</epg:grid>

<epg:navUrl obj="${rightUpRecommend}" indexUrlVar="indexUrl"/>
<div id="recBg" style="left:833px;top:144px;width:396px;height:226px;background-color:#f79922;visibility:hidden;"></div>
<epg:img left="836" top="147" width="390" height="220" src="../${rightUpRecommend.itemIcon}"
		 href="${indexUrl}" rememberFocus="true" onfocus="recOnFocus('recBg');" onblur="recOnBlur('recBg');"/>
<epg:img left="836" top="266" width="390" height="101" src="./images/playRecommend.png"/>
<div id="recPlay" style="left:836px;top:282px;visibility:hidden;">
	<epg:img width="390" height="85" src="./images/playRecommendOnFocus.png"/>
</div>
<epg:choose>
		<epg:when test="${fn:indexOf(rightUpRecommend.title, 'HD_') != -1}">
			<epg:set value="${fn:substring(rightUpRecommend.title,3,10)}" var="contentName"/>
		</epg:when>
		<epg:otherwise>
			<epg:set value="${rightUpRecommend.title}" var="contentName"/>
		</epg:otherwise>
	</epg:choose>
<epg:text left="910" top="310" width="350" height="62" text="${contentName}"
		  fontFamily="黑体" fontSize="36" color="#ffffff" chineseCharNumber="9" dotdotdot=" "/>

<!-- 最近购买历史查询 -->
<epg:img id="month0" left="853" top="424" width="110" height="32" src="./images/month.png"/>
<epg:img id="month1" left="978" top="424" width="110" height="32" src="./images/month.png"/>
<epg:img id="month2" left="1103" top="424" width="110" height="32" src="./images/month.png"/>
<epg:text id="month0" left="853" top="429" width="110" height="32" text="${monthTwo}月"
		  fontFamily="黑体" fontSize="21" color="#1978b8" align="center"/>
<epg:text id="month1" left="978" top="429" width="110" height="32" text="${monthOne}月"
		  fontFamily="黑体" fontSize="21" color="#1978b8" align="center"/>
<epg:text id="month2" left="1103" top="429" width="110" height="32" text="${curMonth}月"
		  fontFamily="黑体" fontSize="21" color="#1978b8" align="center"/>
<epg:img left="853" top="424" width="110" height="32" src="./images/dot.gif"
		 href="${baseUrl}&chooseMonth=${monthTwo}" onfocus="monthOnFocus('month0');" onblur="monthOnBlur('month0');"/>
<epg:img left="978" top="424" width="110" height="32" src="./images/dot.gif"
		 href="${baseUrl}&chooseMonth=${monthOne}" onfocus="monthOnFocus('month1');" onblur="monthOnBlur('month1');"/>
<epg:img left="1103" top="424" width="110" height="32" src="./images/dot.gif"
		 href="${baseUrl}&chooseMonth=${curMonth}" onfocus="monthOnFocus('month2');" onblur="monthOnBlur('month2');"/>

</epg:body>
</epg:html>