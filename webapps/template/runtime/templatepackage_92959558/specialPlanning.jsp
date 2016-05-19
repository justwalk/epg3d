<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
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
<title>特别企划列表页</title>
<epg:html>
<!-- contents -->
<epg:query queryName="getSeverialItems" maxRows="8" var="content" >
	<epg:param name="categoryCode" value="${templateParams['contentCategoryCode']}" type="java.lang.String"/>
</epg:query>

<epg:navUrl returnTo="biz" returnUrlVar="returnUrl"/>
<epg:navUrl returnTo="home" returnUrlVar="returnHomeUrl"></epg:navUrl>
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
<script>
	var pageLoad = false;
	var fristFocus = 0;
	if (typeof(iPanel) == 'undefined') {
		pageLoad  = true;
	}
function $(_id) {
	return "string" == typeof _id ? document.getElementById(_id) : _id;
}
//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名
function itemOnFocus(objId,img,itemId){
	if(pageLoad){
		fristFocus++;
		$(objId+"_img").src = "${imgPath}" + img + ".png";
		if("" != itemId && "undefined" != (typeof itemId) && null != itemId){
			$(itemId + "_span").style.color = "${white}";
		}
	}
}
//失去焦点事件
function itemOnBlur(objId,itemId){
	if(pageLoad){
		$(objId+"_img").src = "${dotPath}";
		if("" != itemId && "undefined" != (typeof itemId) && null != itemId){
			$(itemId + "_span").style.color = "${specialDetColor}";
		}
	}
}

//文字节目获得焦点改变文字和背景div颜色
function textOnFocus(objId){
	if(pageLoad){
		$(objId).style.visibility="visible";
	}
}

//文字节目失去焦点
function textOnBlur(objId){
	if(pageLoad){
		$(objId).style.visibility="hidden";
	}
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
	if("${param.returnTo}"!=""&&"${param.returnTo}"!=null){
		window.location.href = "${returnUrl}";
	}else{
		history.back();
	}
}

function init(){
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""&& document.getElementById(leaveFocusId+"_a")){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		document.getElementById("title1_1_a").focus();
	}	
}
</script>

<epg:body  onload="init();" bgcolor="#000000"  width="1280" height="720" >

<!-- 背景图片 -->
<epg:img src="./images/specialPlanningBg.jpg" id="main"  left="0" top="0" width="1280" height="720"/>

<!-- 返回 -->
<epg:img src="${dot}" id="returnPush" left="941" top="33" width="290" height="60" href="javascript:back();"
	onfocus="itemOnFocus('returnPush','largerReturn');" onblur="itemOnBlur('returnPush');"	/>

<!-- 图片位置 -->
<epg:grid left="105" top="162" width="1069" height="405" row="2" column="4" items="${content}" var="con" indexVar="idx"
		posVar="pos" hcellspacing="43" vcellspacing="135">
	<epg:query queryName="getSeverialItems" maxRows="2" var="contentImg" >
		<epg:param name="categoryCode" value="${content[idx-1].itemCode}" type="java.lang.String"/>
	</epg:query>
	<epg:query queryName="getSeverialItems" maxRows="1" var="posterImg" >
		<epg:param name="categoryCode" value="${contentImg[0].itemCode}" type="java.lang.String"/>
	</epg:query>
	<epg:if test="${!empty posterImg}">
		<epg:img src="../${posterImg.itemIcon}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" id="Poster${idx}"
			width="235" height="135"/>
	</epg:if>
</epg:grid>

<!-- 文字内容 -->
<epg:grid left="102" top="305" width="1075" height="380" row="2" column="4" items="${content}" var="con" indexVar="idx"
		  posVar="pos" hcellspacing="37" vcellspacing="160">
	<epg:query queryName="getSeverialItems" maxRows="2" var="categoryContents" >
		<epg:param name="categoryCode" value="${content[idx-1].itemCode}" type="java.lang.String"/>
	</epg:query>
	<epg:query queryName="getSeverialItems" maxRows="3" var="categoryContent" >
		<epg:param name="categoryCode" value="${categoryContents[1].itemCode}" type="java.lang.String"/>
	</epg:query>
	<epg:if test="${categoryContent[0] != null}">
		<epg:navUrl obj="${categoryContent[0]}" indexUrlVar="content1_indexUrl"/>
		<div id="titleText1_${idx}" style="left:${pos[idx-1].x+3}px;top:${pos[idx-1].y-5}px;width:235px;height:38px;">
			<epg:img src="${dot}"  id="title1_${idx}" width="235" height="38" href="${content1_indexUrl}&returnTo=bizcat"
					 onfocus="itemOnFocus('title1_${idx}','textFocus','span1_${categoryContent[0].id}');"
					 onblur="itemOnBlur('title1_${idx}','span1_${categoryContent[0].id}');"/>
		</div>
		<div id="titleText1_${idx}" style="left:${pos[idx-1].x+10}px;top:${pos[idx-1].y+1}px;width:245px;height:26px;">
			<epg:text id="span1_${categoryContent[0].id}" width="225" height="26" chineseCharNumber="10" dotdotdot="…" 
					  fontSize="22" fontFamily="黑体" color="${specialDetColor}" text="${categoryContent[0].title}"/>
		</div>
	</epg:if>
	<epg:if test="${categoryContent[1] != null}">
		<epg:navUrl obj="${categoryContent[1]}" indexUrlVar="content2_indexUrl"/>
		<div id="titleText2_${idx}" style="left:${pos[idx-1].x+3}px;top:${pos[idx-1].y+26}px;width:235px;height:38px;">
			<epg:img src="${dot}"  id="title2_${idx}" width="235" height="38" href="${content2_indexUrl}&returnTo=bizcat"
					 onfocus="itemOnFocus('title2_${idx}','textFocus','span2_${categoryContent[1].id}');" 
					 onblur="itemOnBlur('title2_${idx}','span2_${categoryContent[1].id}');"/>
		</div>
		<div id="titleText2_${idx}" style="left:${pos[idx-1].x+10}px;top:${pos[idx-1].y+31}px;width:245px;height:26px;">
			<epg:text id="span2_${categoryContent[1].id}" width="225" height="26" chineseCharNumber="10" dotdotdot="…"
					  fontSize="22" fontFamily="黑体" color="${specialDetColor}" text="${categoryContent[1].title}"/>
		</div>
	</epg:if>
	<epg:if test="${categoryContent[2] != null}">
		<epg:navUrl obj="${categoryContent[2]}" indexUrlVar="content3_indexUrl"/>
		<div id="titleText3_${idx}" style="left:${pos[idx-1].x+3}px;top:${pos[idx-1].y+57}px;width:235px;height:38px;">
			<epg:img src="${dot}"  id="title3_${idx}" width="235" height="38" href="${content3_indexUrl}&returnTo=bizcat"
					 onfocus="itemOnFocus('title3_${idx}','textFocus','span3_${categoryContent[2].id}');" 
					 onblur="itemOnBlur('title3_${idx}','span3_${categoryContent[2].id}');"/>
		</div>
		<div id="titleText3_${idx}" style="left:${pos[idx-1].x+10}px;top:${pos[idx-1].y+62}px;width:245px;height:26px;">
			<epg:text id="span3_${categoryContent[2].id}" width="225" height="26" chineseCharNumber="10" dotdotdot="…" 
					  fontSize="22" fontFamily="黑体" color="${specialDetColor}" text="${categoryContent[2].title}"/>
		</div>
	</epg:if>
</epg:grid>

</epg:body>
</epg:html>