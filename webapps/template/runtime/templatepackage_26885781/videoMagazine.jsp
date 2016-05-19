<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="java.util.*,java.text.*" %>
<%@ page language="java" import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*" %>
<epg:html>
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
<!-- 高清菜单  -->
<epg:query queryName="getSeverialItems" maxRows="12" var="menuCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>


<!-- 中间内容 -->
<epg:query queryName="getSeverialItemsWithSubjectPic" maxRows="19" var="rightCategoryItems" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true"  >
	<epg:param name="categoryCode" value="${templateParams['rightCategoryCode']}" type="java.lang.String"  />
</epg:query>
<epg:navUrl returnTo="biz" returnUrlVar="returnUrl"/>
<epg:navUrl returnTo="home" returnUrlVar="returnHomeUrl"/>
<style type="text/css">
	body{
		color:#02296d;
		font-size:22px;
		font-family:黑体;	
	}
	a{outline:none;}
	img{border:0px solid black;}
</style>
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
			window.location.href = "${returnHomeUrl}";
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
var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images";

function $(_id) {
	return "string" == typeof _id ? document.getElementById(_id) : _id;
}
//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名
function itemOnFocus(objId,img,itemId){
	if (pageLoad) {
		fristFocus++;
		$(objId + "_img").src = imgPath + "/" + img + ".png";
		if (typeof(itemId) != "undefined") {
			$(itemId).style.opacity = "1";
			$(itemId).style.backgroundColor = "#fb7806";
		}
	}
}
//失去焦点事件
function itemOnBlur(objId,itemId){
	if (pageLoad) {
		$(objId + "_img").src = imgPath + "/dot.gif";
		if (typeof(itemId) != "undefined") {
			$(itemId).style.opacity = "0.7";
			$(itemId).style.backgroundColor = "#020000";
		}
	}
}
//导航菜单获得焦点
function iconOnfocus(objId){
	if (pageLoad) {
		fristFocus++;
		$(objId + "_img").src = imgPath + "/topMenuBg.png";
	}
}
function iconOnblur(objId){
	if (pageLoad) {
		$(objId + "_img").src = imgPath + "/dot.gif";
	}
}

//文字节目获得焦点改变文字和背景div颜色
function textOnFocus(objId){
	if (pageLoad) {
		fristFocus++;
		$(objId).style.visibility = "visible";
	}
}

//文字节目失去焦点
function textOnBlur(objId){
	if (pageLoad) {
		$(objId).style.visibility = "hidden";
	}
}

function init()
{		
		//document.getElementById("categoryList0_a").focus();
		var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		document.getElementById("menu1_a").focus();
	}
}
</script>

<epg:body onload="init()" bgcolor="#000000"  width="1280" height="720" >
<!-- 背景图片以及头部图片 -->
<epg:img src="./images/Video.jpg" id="main"  left="0" top="0" width="1280" height="720"/>
<!-- 导航菜单 -->
<epg:grid column="12" row="1" left="49" top="157" width="1180" height="46" hcellspacing="4" items="${menuCategoryItems}" var="menuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="menu${curIdx}" onfocus="iconOnfocus('menu${curIdx}')" onblur="iconOnblur('menu${curIdx}')" 
	rememberFocus="true" src="./images/dot.gif" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="99" height="110" href="${indexUrl}"/>
</epg:grid>
<!-- 导航底图 -->
<epg:grid column="12" row="1" left="49" top="157" width="1180" height="46" hcellspacing="4" items="${menuCategoryItems}" var="menuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img  src="../${menuCategoryItems[curIdx-1].itemIcon}" left="${positions[curIdx-1].x+3}" top="${positions[curIdx-1].y+10}" width="80" height="80"/>
</epg:grid>

<epg:img src="./images/dot.gif" left="1102" top="55"  width="73" height="43" href="${returnUrl}" onfocus="itemOnFocus('backHome','exclusiveReturn');"  onblur="itemOnBlur('backHome');"/>
<epg:img src="./images/dot.gif" id="backHome"  left="1095" width="95" height="105"/>
<!-- 内容部分 -->
<div style="position:absolute;left:52px;top:316px;width:882px;height:402px">
	<epg:forEach begin="0" end="1" varStatus="rowStatus">
		<epg:forEach begin="0" end="3" varStatus="colStatus">
			<epg:if test="${rightCategoryItems[rowStatus.index*4+colStatus.index]!=null}">
				<epg:navUrl obj="${rightCategoryItems[rowStatus.index*4+colStatus.index]}" indexUrlVar="indexUrl"/>
				<epg:if test="${rowStatus.index*4+colStatus.index<4}">	
					<epg:img src="./images/dot.gif" id="contentImg${rowStatus.index*4+colStatus.index}"  left="${colStatus.index*295}" top="${rowStatus.index}" width="292" height="152"/>	
					<epg:if test="${rightCategoryItems[rowStatus.index*4+colStatus.index].icon!=null}">
						<epg:img id="categoryList${rowStatus.index*4+colStatus.index}"  src="../${rightCategoryItems[rowStatus.index*4+colStatus.index].icon}"  
						 onfocus="itemOnFocus('contentImg${rowStatus.index*4+colStatus.index}','orange11','posterDiv${rowStatus.index*4+colStatus.index}');"  onblur="itemOnBlur('contentImg${rowStatus.index*4+colStatus.index}','posterDiv${rowStatus.index*4+colStatus.index}');"
						 left="${colStatus.index*295+6}" rememberFocus="true" href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=biz"  top="${rowStatus.index+6}"   width="280" height="140"/>
					</epg:if>
					<epg:if test="${rightCategoryItems[rowStatus.index*4+colStatus.index].icon==null}">
						<epg:img id="categoryList${rowStatus.index*4+colStatus.index}"  src="../${rightCategoryItems[rowStatus.index*4+colStatus.index].itemIcon}"  
						 onfocus="itemOnFocus('contentImg${rowStatus.index*4+colStatus.index}','orange11','posterDiv${rowStatus.index*4+colStatus.index}');"  onblur="itemOnBlur('contentImg${rowStatus.index*4+colStatus.index}','posterDiv${rowStatus.index*4+colStatus.index}');"
						 left="${colStatus.index*295+6}" rememberFocus="true" href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=biz"  top="${rowStatus.index+6}"   width="280" height="140"/>
					</epg:if>
					<div id="posterDiv${rowStatus.index*4+colStatus.index}" style="position:absolute;left:${colStatus.index*295+6}px;top:${rowStatus.index+116}px;width:280px;height:30px;background-color:#020000;opacity:0.7;" >
						<epg:text left="10" color="#ffffff" top="1" height="22" id="leftCategory${curIdx}"chineseCharNumber="12" width="280" fontSize="21" dotdotdot="…">
						${rightCategoryItems[rowStatus.index*4+colStatus.index].title}
						</epg:text>
					</div>
				</epg:if>
				<epg:if test="${rowStatus.index*4+colStatus.index>=4}">
					<epg:img src="./images/dot.gif" id="contentImg${rowStatus.index*4+colStatus.index}"  left="${colStatus.index*295}" top="${rowStatus.index+154}" width="292" height="152"/>
					<epg:if test="${rightCategoryItems[rowStatus.index*4+colStatus.index].icon!=null}">
						<epg:img id="categoryList${rowStatus.index*4+colStatus.index}" src="../${rightCategoryItems[rowStatus.index*4+colStatus.index].icon}" 
						 onfocus="itemOnFocus('contentImg${rowStatus.index*4+colStatus.index}','orange11','posterDiv${rowStatus.index*4+colStatus.index}');"  onblur="itemOnBlur('contentImg${rowStatus.index*4+colStatus.index}','posterDiv${rowStatus.index*4+colStatus.index}');"
						 left="${colStatus.index*295+6}" rememberFocus="true" href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=biz" top="${160+rowStatus.index}"  width="280" height="140"/>
					</epg:if>
					<epg:if test="${rightCategoryItems[rowStatus.index*4+colStatus.index].icon==null}">
						<epg:img id="categoryList${rowStatus.index*4+colStatus.index}" src="../${rightCategoryItems[rowStatus.index*4+colStatus.index].itemIcon}" 
						 onfocus="itemOnFocus('contentImg${rowStatus.index*4+colStatus.index}','orange11','posterDiv${rowStatus.index*4+colStatus.index}');"  onblur="itemOnBlur('contentImg${rowStatus.index*4+colStatus.index}','posterDiv${rowStatus.index*4+colStatus.index}');"
						 left="${colStatus.index*295+6}" rememberFocus="true" href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=biz" top="${160+rowStatus.index}"  width="280" height="140"/>
					</epg:if>
					<div id="posterDiv${rowStatus.index*4+colStatus.index}" style="position:absolute;left:${colStatus.index*295+6}px;top:${rowStatus.index+270}px;width:280px;height:30px;background-color:#020000;opacity:0.7;" >
						<epg:text left="10" color="#ffffff" top="1" height="22" id="leftCategory${curIdx}"chineseCharNumber="12" width="280" fontSize="21" dotdotdot="…">
						${rightCategoryItems[rowStatus.index*4+colStatus.index].title}
						</epg:text>
					</div>
				</epg:if>
			</epg:if>
		</epg:forEach>
	</epg:forEach>
</div>
</epg:body>
</epg:html>