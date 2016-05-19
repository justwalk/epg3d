<%@page contentType="text/html; charset=GBK" pageEncoding="UTF-8"%> 
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@page import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*"%>
<%@page import="sitv.epg.web.context.EpgContext"%>
<%@page import="sitv.epg.nav.url.NavigatorFactory"%>
<%@page import="java.util.Map"%>
<%
	String leaveFocusId = request.getParameter("leaveFocusId");
	if(leaveFocusId!=null&&leaveFocusId!=""){
		
		EpgUserSession eus = EpgUserSession.findUserSession(request);
		eus.setPlayFocusId(leaveFocusId);
		request.setAttribute("leaveFocusId",eus.getPlayFocusId()) ;
	}
%>
<html>
<!-- 如果pageCode为空或不存在，那将取得专题首页的数据 www155ewe-->
<epg:if test="${empty  context['EPG_PAGE_CODE'] }">
	<epg:query queryName="getSubjectPageBySubjectCode" maxRows="1" var="result" >
		<epg:param name="subjectCode" value="${context['EPG_SUBJECT_CODE']}" type="java.lang.String"/>
	</epg:query>
</epg:if>

<!-- 如果pageCode存在，根据subjectCode和pageCode 得到数据  -->
<epg:if test="${!empty  context['EPG_PAGE_CODE'] }">
	<epg:query queryName="getSubjectPageBySubjectCodeAndPageCode" maxRows="1" var="result" >
		<epg:param name="pageCode" value="${context['EPG_PAGE_CODE']}" type="java.lang.String"/>
	</epg:query>
</epg:if>

<!-- 根据paeCode查询所对应的所有热点  -->
<epg:query queryName="getSubjectAreaByPageCode"  maxRows="100" var="resultMaps">
	<epg:param name="pageCode" value="${result.pageCode}" type="java.lang.String"/>
</epg:query>
	 
<!-- 返回 -->
<epg:navUrl returnTo="${param.returnTo}" returnUrlVar="returnBizUrl"></epg:navUrl>

<epg:choose>
  <epg:when test="${empty result.highDefition}">
	  <epg:set var="defition" value="${fn:split('720,576',',')}" />
  </epg:when>
  <epg:otherwise>
  	  <epg:set var="defition" value="${fn:split(result.highDefition,',')}" />
  </epg:otherwise>
</epg:choose>	
<%
	String resourceRoot = sitv.epg.config.EpgConfigUtils.getInstance().getProperty("resource.root.path");
	request.setAttribute("resourceRoot", resourceRoot);	
	
%>
<script src="${context['EPG_CONTEXT']}/js/base.js"></script>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script type="text/javascript">
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
			break;
		case "SITV_KEY_PAGEDOWN":
			break;
		case "SITV_KEY_BACK":
			back();
			return 0;
			break;
		case "SITV_KEY_EXIT":
			back();
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
function returnToBizOrHistory(){
	//if("${param.returnTo}"!=""&&"${param.returnTo}"!=null){
	//	window.location.href="${returnBizUrl}";
	//}else{
		history.back();
	//}
}

function getfocus(objId){
	var id = objId.substring(0,objId.indexOf("_"));
	//document.getElementById(id+"_img_img").style.visibility="visible";
	//document.getElementById("r_"+id+"_img_img").style.visibility="visible";
}
function outfocus(objId){
	var id = objId.substring(0,objId.indexOf("_"));
	//document.getElementById(id+"_img_img").style.visibility="hidden";
	//document.getElementById("r_"+id+"_img_img").style.visibility="hidden";
}

function init(){
	var tags = document.getElementsByTagName("area");
 	for(var i=0;i<tags.length;i++){
		var coord = document.getElementById("ID"+i).getAttribute("coords").split(",");
		coord[0]=Math.floor(coord[0]/2);
		coord[2]=Math.floor(coord[2]/2);
		document.getElementById("ID"+i).coords=coord;
	}
	
	iPanel.focus.display = 1;
	iPanel.focus.border = 1;
	iPanel.focus.defaultFocusColor = "#FF0000";
	document.getElementById("ID0").focus();
	
	
}
function end(){
	iPanel.focus.display = 0;
	iPanel.focus.border = 0;
}
function setCoords(){
	var tags = document.getElementsByTagName("area");
	for(var i=0;i<tags.length;i++){
		var coord = document.getElementById("ID"+i).coords.split(",");
		coord[0]=coord[0]/2
		coord[2]=coord[2]/2
		document.getElementById("ID"+i).coords=coord;
	}
}
</script>
<epg:body bgcolor="#000000" onload="init();" onunload="end();">
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
	<tr><td height="100%" align="center" valign="middle">
	<table cellspacing="0" cellpadding="0" width="${defition[0]}" height="${defition[1]}" >
		<tr>
			<td valign="top"><img src="${context['EPG_CONTEXT']}/${resourceRoot}${result.background}" width="640" height="${defition[1]}" usemap="#subjectMap" /></td>
			<td valign="top"><img src="${context['EPG_CONTEXT']}/${resourceRoot}${result.background}" width="640" height="${defition[1]}"/></td>
		</tr>
	</table>
	</td></tr>
</table>
<epg:map name="subjectMap">
		<epg:forEach var="resultMap" items="${resultMaps}" varStatus="status" >
			<epg:navUrl obj="${resultMap}" indexUrlVar="indexUrl" />
			<epg:if test="${resultMap.objType=='url' && resultMap.objCode=='backurl'}">
				<%
					String bizCode = (String)((Map)request.getAttribute("context")).get("EPG_BUSINESS_CODE");
					String backURL = NavigatorFactory.createBusinessIndexUrl(bizCode,request);
					request.setAttribute("backURL",backURL);
				%>
				<epg:set var="indexUrl" value="${backURL}"/>
			</epg:if>
			<epg:choose>
				<epg:when test="${status.index == 0 }">	
					<epg:if test="${empty context['EPG_PAGE_CODE'] }">
						<epg:area id="ID${status.index}"  coords="${resultMap.location}"  href="${indexUrl}&returnTo=biz&pageCode=${result.pageCode}" rememberFocus="true" />
					</epg:if>
					<epg:if test="${!empty context['EPG_PAGE_CODE'] }">
						<epg:area id="ID${status.index}"  coords="${resultMap.location}"  href="${indexUrl}&returnTo=biz&pageCode=${context['EPG_PAGE_CODE']}" rememberFocus="true" />
					</epg:if>
				</epg:when>
				<epg:otherwise>					
					<epg:if test="${empty context['EPG_PAGE_CODE'] }">
						<epg:area id="ID${status.index}"  coords="${resultMap.location}"  href="${indexUrl}&returnTo=biz&pageCode=${result.pageCode}"/>
					</epg:if>
					<epg:if test="${!empty context['EPG_PAGE_CODE'] }">
						<epg:area id="ID${status.index}"  coords="${resultMap.location}"  href="${indexUrl}&returnTo=biz&pageCode=${context['EPG_PAGE_CODE']}"/>
					</epg:if>
				</epg:otherwise>
			</epg:choose>
		</epg:forEach>
	</epg:map>
	<!-- ***************************************** -->
</epg:body>
</html>