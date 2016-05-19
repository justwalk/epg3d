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

<!-- 中间内容 -->
<epg:query queryName="getSeverialItemsWithSubjectPic" maxRows="12" var="rightCategoryItems" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true"  >
	<epg:param name="categoryCode" value="${templateParams['rightCategoryCode']}" type="java.lang.String"  />
</epg:query>
<epg:navUrl returnTo="biz" returnUrlVar="returnUrl"/>
<epg:navUrl returnTo="home" returnUrlVar="returnHomeUrl"/>
<style type="text/css">
	body{
		color:#FFFFFF;
		font-size:22;
		font-family:"黑体";
	}
	a{display:block;outline:none}
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
	    	pageUp();
	    	break;
	    case "SITV_KEY_PAGEDOWN":
	    	pageDown();
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
function pageUp(){
  	var previousUrl = "${pageBean.previousUrl}";
	var myPageIndex = "";
	if(previousUrl.indexOf("&pageIndex=")!=-1){
		myPageIndex = previousUrl.substring(previousUrl.indexOf("&pageIndex="),previousUrl.length);
			previousUrl = previousUrl.substring(0,previousUrl.indexOf("&pageIndex="));
	}
	if(previousUrl.indexOf("&leaveFocusId=")!=-1){
		previousUrl = previousUrl.substring(0,previousUrl.indexOf("&leaveFocusId="));
	}
 	document.location.href = previousUrl+"&leaveFocusId=area_upPage"+myPageIndex;
 }
 function pageDown(){
 	var nextUrl = "${pageBean.nextUrl}";
	var myPageIndex = "";
	if(nextUrl.indexOf("&pageIndex=")!=-1){
		myPageIndex = nextUrl.substring(nextUrl.indexOf("&pageIndex="),nextUrl.length);
		nextUrl = nextUrl.substring(0,nextUrl.indexOf("&pageIndex="));
	}
	if(nextUrl.indexOf("&leaveFocusId=")!=-1){
		nextUrl = nextUrl.substring(0,nextUrl.indexOf("&leaveFocusId="));
	}
 	document.location.href = nextUrl+"&leaveFocusId=area_downPage"+myPageIndex;
 }
var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images";
var _requester = null; 
var pageSize = 12;	
var pageIndex = 1;	
var pageTotal;
var pageCount="${pageBean.pageCount}";
var categoryList=[];


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

function buttonOnFocus(objId,img){
	if (pageLoad) {
		fristFocus++;
		$(objId + "_img").src = imgPath + "/" + img + ".png";
	}
}
function buttonOnBlur(objId,img){
	if (pageLoad) {
		$(objId + "_img").src = imgPath + "/" + img + ".png";
	}
}


function init()
{		
		var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		document.getElementById("contentPoster0_a").focus();
	}
}

//文字节目获得焦点改变文字和背景div颜色
function textOnFocus(objId){
	$(objId).style.visibility="visible";
}

//文字节目失去焦点
function textOnBlur(objId){
	$(objId).style.visibility="hidden";
}

</script>

<epg:body  onload="init()" bgcolor="#000000"  width="1280" height="720" >
<!-- 背景图片 -->
<epg:img src="./images/Plan.jpg" id="main"  left="0" top="0" width="1280" height="720"/>


<epg:img src="./images/dot.gif" left="1102" top="55"  width="73" height="43" href="${returnUrl}" onfocus="itemOnFocus('backHome','exclusiveReturn');"  onblur="itemOnBlur('backHome');"/>
<epg:img src="./images/dot.gif" id="backHome"  left="1095" width="95" height="105"/>
<div id="returnBack" style="position:absolute;border:4px solid #fb7806;visibility:hidden;left:1097px;top:53px;width:73px;height:43px;" ></div>
<!--上下页-->
<epg:img src="./images/pagUp.png" id="area_upPage"  left="797" top="131" onfocus="buttonOnFocus('area_upPage','pagUp_1')" onblur="buttonOnBlur('area_upPage','pagUp')" pageop="up" keyop="pageup"  width="128" height="36" href="javascript:pageUp();"/>
<epg:img src="./images/pagDown.png" id="area_downPage"  left="940" top="131" onfocus="buttonOnFocus('area_downPage','pagDown_1')" onblur="buttonOnBlur('area_downPage','pagDown')" pageop="down" keyop="pagedown"  width="128" height="36" href="javascript:pageDown();"/>
<div style="position:absolute; top:133px; left:1110px; width:90px; height:22px; font-size:26px; " >
	<span style="color:#5e2904">${pageBean.pageIndex}/${pageBean.pageCount} 页</span>
</div>

<!--海报内容  -->
	<epg:if test="${rightCategoryItems[0] != null}">
				<epg:navUrl obj="${rightCategoryItems[0]}" indexUrlVar="indexUrl"/>
				<epg:img src="./images/dot.gif" id="contentImg0"  left="49" top="180" width="292" height="152"/>
				<epg:if test="${rightCategoryItems[0].icon != null}">
					<epg:img src="../${rightCategoryItems[0].icon}"  left="55" top="186" width="280" height="140"  id="contentPoster0" rememberFocus="true"
				href="${indexUrl}" onfocus="itemOnFocus('contentImg0','orange11','posterDiv1');"  onblur="itemOnBlur('contentImg0','posterDiv1');"/>
				</epg:if>
				<epg:if test="${rightCategoryItems[0].icon == null}">
					<epg:img src="../${rightCategoryItems[0].itemIcon}"  left="55" top="186" width="280" height="140"  id="contentPoster0"
				href="${indexUrl}" onfocus="itemOnFocus('contentImg0','orange11','posterDiv1');"  onblur="itemOnBlur('contentImg0','posterDiv1');"/>
				</epg:if>
			<div id="posterDiv1" style="position:absolute;left:55px;top:296px;width:280px;height:30px;background-color:#020000;opacity:0.7;" >
			<epg:text left="10" color="#ffffff" top="1" height="22" id="leftCategory${curIdx}"chineseCharNumber="12" width="280" fontSize="21" dotdotdot="…">
			${rightCategoryItems[0].title}
			</epg:text>
			</div>
	</epg:if>
	<epg:if test="${rightCategoryItems[1] != null}">
				<epg:navUrl obj="${rightCategoryItems[1]}" indexUrlVar="indexUrl"/>
				<epg:img src="./images/dot.gif" id="contentImg1"  left="344" top="180" width="292" height="152"/>
				<epg:if test="${rightCategoryItems[1].icon != null}">
					<epg:img src="../${rightCategoryItems[1].icon}"  left="350" top="186" width="280" height="140" id="contentPoster1" rememberFocus="true"
				href="${indexUrl}" onfocus="itemOnFocus('contentImg1','orange11','posterDiv2');"  onblur="itemOnBlur('contentImg1','posterDiv2');"/>
				</epg:if>
				<epg:if test="${rightCategoryItems[1].icon == null}">
					<epg:img src="../${rightCategoryItems[1].itemIcon}"  left="350" top="186" width="280" height="140" id="contentPoster1"
				href="${indexUrl}" onfocus="itemOnFocus('contentImg1','orange11','posterDiv2');"  onblur="itemOnBlur('contentImg1','posterDiv2');"/>
				</epg:if>
			<div id="posterDiv2" style="position:absolute;left:350px;top:296px;width:280px;height:30px;background-color:#020000;opacity:0.7;" >
			<epg:text left="10" color="#ffffff" top="1" height="22" id="leftCategory${curIdx}"chineseCharNumber="12" width="280" fontSize="21" dotdotdot="…">
			${rightCategoryItems[1].title}
			</epg:text>
			</div>
	</epg:if>
	<epg:if test="${rightCategoryItems[2] != null}">
				<epg:navUrl obj="${rightCategoryItems[2]}" indexUrlVar="indexUrl"/>
				<epg:img src="./images/dot.gif" id="contentImg2"  left="639" top="180" width="292" height="152"/>
				<epg:if test="${rightCategoryItems[2].icon != null}">
					<epg:img src="../${rightCategoryItems[2].icon}"  left="645" top="186" width="280" height="140" id="contentPoster2" rememberFocus="true"
				href="${indexUrl}" onfocus="itemOnFocus('contentImg2','orange11','posterDiv3');"  onblur="itemOnBlur('contentImg2','posterDiv3');"/>
				</epg:if>
				<epg:if test="${rightCategoryItems[2].icon == null}">
					<epg:img src="../${rightCategoryItems[2].itemIcon}"  left="645" top="186" width="280" height="140" id="contentPoster2"
				href="${indexUrl}" onfocus="itemOnFocus('contentImg2','orange11','posterDiv3');"  onblur="itemOnBlur('contentImg2','posterDiv3');"/>
				</epg:if>
			<div id="posterDiv3" style="position:absolute;left:645px;top:296px;width:280px;height:30px;background-color:#020000;opacity:0.7;" >
			<epg:text left="10" color="#ffffff" top="1" height="22" id="leftCategory${curIdx}"chineseCharNumber="12" width="280" fontSize="21" dotdotdot="…">
			${rightCategoryItems[2].title}
			</epg:text>
			</div>
	</epg:if>
	<epg:if test="${rightCategoryItems[3] != null}">
				<epg:navUrl obj="${rightCategoryItems[3]}" indexUrlVar="indexUrl"/>
				<epg:img src="./images/dot.gif" id="contentImg3"  left="934" top="180" width="292" height="152"/>
				<epg:if test="${rightCategoryItems[3].icon != null}">
					<epg:img src="../${rightCategoryItems[3].icon}"  left="940" top="186" width="280" height="140" id="contentPoster3" rememberFocus="true"
				href="${indexUrl}" onfocus="itemOnFocus('contentImg3','orange11','posterDiv4');"  onblur="itemOnBlur('contentImg3','posterDiv4');"/>
				</epg:if>
				<epg:if test="${rightCategoryItems[3].icon == null}">
					<epg:img src="../${rightCategoryItems[3].itemIcon}"  left="940" top="186" width="280" height="140" id="contentPoster3"
				href="${indexUrl}" onfocus="itemOnFocus('contentImg3','orange11','posterDiv4');"  onblur="itemOnBlur('contentImg3','posterDiv4');"/>
				</epg:if>
			<div id="posterDiv4" style="position:absolute;left:940px;top:296px;width:280px;height:30px;background-color:#020000;opacity:0.7;" >
			<epg:text left="10" color="#ffffff" top="1" height="22" id="leftCategory${curIdx}"chineseCharNumber="12" width="280" fontSize="21" dotdotdot="…">
			${rightCategoryItems[3].title}
			</epg:text>
			</div>
	</epg:if>
	<epg:if test="${rightCategoryItems[4] != null}">
				<epg:navUrl obj="${rightCategoryItems[4]}" indexUrlVar="indexUrl"/>
				<epg:img src="./images/dot.gif" id="contentImg4"  left="49" top="340" width="292" height="152"/>
				<epg:if test="${rightCategoryItems[4].icon != null}">
					<epg:img src="../${rightCategoryItems[4].icon}"  left="55" top="346" width="280" height="140" id="contentPoster4" rememberFocus="true"
				href="${indexUrl}" onfocus="itemOnFocus('contentImg4','orange11','posterDiv5');"  onblur="itemOnBlur('contentImg4','posterDiv5');"/>
				</epg:if>
				<epg:if test="${rightCategoryItems[4].icon == null}">
					<epg:img src="../${rightCategoryItems[4].itemIcon}"  left="55" top="346" width="280" height="140" id="contentPoster4"
				href="${indexUrl}" onfocus="itemOnFocus('contentImg4','orange11','posterDiv5');"  onblur="itemOnBlur('contentImg4','posterDiv5');"/>
				</epg:if>
			<div id="posterDiv5" style="position:absolute;left:55px;top:456px;width:280px;height:30px;background-color:#020000;opacity:0.7;" >
			<epg:text left="10" color="#ffffff" top="1" height="22" id="leftCategory${curIdx}"chineseCharNumber="12" width="280" fontSize="21" dotdotdot="…">
			${rightCategoryItems[4].title}
			</epg:text>
			</div>
	</epg:if>
	<epg:if test="${rightCategoryItems[5] != null}">
				<epg:navUrl obj="${rightCategoryItems[5]}" indexUrlVar="indexUrl"/>
				<epg:img src="./images/dot.gif" id="contentImg5"  left="344" top="340" width="292" height="152"/>
				<epg:if test="${rightCategoryItems[5].icon != null}">
					<epg:img src="../${rightCategoryItems[5].icon}"  left="350" top="346" width="280" height="140" id="contentPoster5" rememberFocus="true"
				href="${indexUrl}" onfocus="itemOnFocus('contentImg5','orange11','posterDiv6');"  onblur="itemOnBlur('contentImg5','posterDiv6');"/>
				</epg:if>
				<epg:if test="${rightCategoryItems[5].icon == null}">
					<epg:img src="../${rightCategoryItems[5].itemIcon}"  left="350" top="346" width="280" height="140" id="contentPoster5"
				href="${indexUrl}" onfocus="itemOnFocus('contentImg5','orange11','posterDiv6');"  onblur="itemOnBlur('contentImg5','posterDiv6');"/>
				</epg:if>
			<div id="posterDiv6" style="position:absolute;left:350px;top:456px;width:280px;height:30px;background-color:#020000;opacity:0.7;" >
			<epg:text left="10" color="#ffffff" top="1" height="22" id="leftCategory${curIdx}"chineseCharNumber="12" width="280" fontSize="21" dotdotdot="…">
			${rightCategoryItems[5].title}
			</epg:text>
			</div>
	</epg:if>
	<epg:if test="${rightCategoryItems[6] != null}">
				<epg:navUrl obj="${rightCategoryItems[6]}" indexUrlVar="indexUrl"/>
				<epg:img src="./images/dot.gif" id="contentImg6"  left="639" top="340" width="292" height="152"/>
				<epg:if test="${rightCategoryItems[6].icon != null}">
					<epg:img src="../${rightCategoryItems[6].icon}"  left="645" top="346" width="280" height="140" id="contentPoster6" rememberFocus="true"
				href="${indexUrl}" onfocus="itemOnFocus('contentImg6','orange11','posterDiv7');"  onblur="itemOnBlur('contentImg6','posterDiv7');"/>
				</epg:if>
				<epg:if test="${rightCategoryItems[6].icon == null}">
					<epg:img src="../${rightCategoryItems[6].itemIcon}"  left="645" top="346" width="280" height="140" id="contentPoster6"
				href="${indexUrl}" onfocus="itemOnFocus('contentImg6','orange11','posterDiv7');"  onblur="itemOnBlur('contentImg6','posterDiv7');"/>
				</epg:if>
			<div id="posterDiv7" style="position:absolute;left:645px;top:456px;width:280px;height:30px;background-color:#020000;opacity:0.7;" >
			<epg:text left="10" color="#ffffff" top="1" height="22" id="leftCategory${curIdx}"chineseCharNumber="12" width="280" fontSize="21" dotdotdot="…">
			${rightCategoryItems[6].title}
			</epg:text>
			</div>
	</epg:if>
	<epg:if test="${rightCategoryItems[7] != null}">
				<epg:navUrl obj="${rightCategoryItems[7]}" indexUrlVar="indexUrl"/>
				<epg:img src="./images/dot.gif" id="contentImg7"  left="934" top="340" width="292" height="152"/>
				<epg:if test="${rightCategoryItems[7].icon != null}">
					<epg:img src="../${rightCategoryItems[7].icon}"  left="940" top="346" width="280" height="140" id="contentPoster7" rememberFocus="true"
				href="${indexUrl}" onfocus="itemOnFocus('contentImg7','orange11','posterDiv8');"  onblur="itemOnBlur('contentImg7','posterDiv8');"/>
				</epg:if>
				<epg:if test="${rightCategoryItems[7].icon == null}">
					<epg:img src="../${rightCategoryItems[7].itemIcon}"  left="940" top="346" width="280" height="140" id="contentPoster7"
				href="${indexUrl}" onfocus="itemOnFocus('contentImg7','orange11','posterDiv8');"  onblur="itemOnBlur('contentImg7','posterDiv8');"/>
				</epg:if>
			<div id="posterDiv8" style="position:absolute;left:940px;top:456px;width:280px;height:30px;background-color:#020000;opacity:0.7;" >
			<epg:text left="10" color="#ffffff" top="1" height="22" id="leftCategory${curIdx}"chineseCharNumber="12" width="280" fontSize="21" dotdotdot="…">
			${rightCategoryItems[7].title}
			</epg:text>
			</div>
	</epg:if>
	<epg:if test="${rightCategoryItems[8] != null}">
				<epg:navUrl obj="${rightCategoryItems[8]}" indexUrlVar="indexUrl"/>
				<epg:img src="./images/dot.gif" id="contentImg8"  left="49" top="500" width="292" height="152"/>
				<epg:if test="${rightCategoryItems[8].icon != null}">
					<epg:img src="../${rightCategoryItems[8].icon}"  left="55" top="506" width="280" height="140" id="contentPoster8" rememberFocus="true"
				href="${indexUrl}" onfocus="itemOnFocus('contentImg8','orange11','posterDiv9');"  onblur="itemOnBlur('contentImg8','posterDiv9');"/>
				</epg:if>
				<epg:if test="${rightCategoryItems[8].icon == null}">
					<epg:img src="../${rightCategoryItems[8].itemIcon}"  left="55" top="506" width="280" height="140" id="contentPoster8"
				href="${indexUrl}" onfocus="itemOnFocus('contentImg8','orange11','posterDiv9');"  onblur="itemOnBlur('contentImg8','posterDiv9');"/>
				</epg:if>
			<div id="posterDiv9" style="position:absolute;left:55px;top:616px;width:280px;height:30px;background-color:#020000;opacity:0.7;" >
			<epg:text left="10" color="#ffffff" top="1" height="22" id="leftCategory${curIdx}"chineseCharNumber="12" width="280" fontSize="21" dotdotdot="…">
			${rightCategoryItems[8].title}
			</epg:text>
			</div>
	</epg:if>
	<epg:if test="${rightCategoryItems[9] != null}">
				<epg:navUrl obj="${rightCategoryItems[9]}" indexUrlVar="indexUrl"/>
				<epg:img src="./images/dot.gif" id="contentImg9"  left="344" top="500" width="292" height="152"/>
				<epg:if test="${rightCategoryItems[9].icon != null}">
					<epg:img src="../${rightCategoryItems[9].icon}"  left="350" top="506" width="280" height="140" id="contentPoster9" rememberFocus="true"
				href="${indexUrl}" onfocus="itemOnFocus('contentImg9','orange11','posterDiv10');"  onblur="itemOnBlur('contentImg9','posterDiv10');"/>
				</epg:if>
				<epg:if test="${rightCategoryItems[9].icon == null}">
					<epg:img src="../${rightCategoryItems[9].itemIcon}"  left="350" top="506" width="280" height="140" id="contentPoster9"
				href="${indexUrl}" onfocus="itemOnFocus('contentImg9','orange11','posterDiv10');"  onblur="itemOnBlur('contentImg9','posterDiv10');"/>
				</epg:if>
			<div id="posterDiv10" style="position:absolute;left:350px;top:616px;width:280px;height:30px;background-color:#020000;opacity:0.7;" >
			<epg:text left="10" color="#ffffff" top="1" height="22" id="leftCategory${curIdx}"chineseCharNumber="12" width="280" fontSize="21" dotdotdot="…">
			${rightCategoryItems[9].title}
			</epg:text>
			</div>
	</epg:if>
	<epg:if test="${rightCategoryItems[10] != null}">
				<epg:navUrl obj="${rightCategoryItems[10]}" indexUrlVar="indexUrl"/>
				<epg:img src="./images/dot.gif" id="contentImg10"  left="639" top="500" width="292" height="152"/>
				<epg:if test="${rightCategoryItems[10].icon != null}">
					<epg:img src="../${rightCategoryItems[10].icon}"  left="645" top="506" width="280" height="140" id="contentPoster10" rememberFocus="true"
				href="${indexUrl}" onfocus="itemOnFocus('contentImg10','orange11','posterDiv11');"  onblur="itemOnBlur('contentImg10','posterDiv11');"/>
				</epg:if>
				<epg:if test="${rightCategoryItems[10].icon == null}">
					<epg:img src="../${rightCategoryItems[10].itemIcon}"  left="645" top="506" width="280" height="140" id="contentPoster10"
				href="${indexUrl}" onfocus="itemOnFocus('contentImg10','orange11','posterDiv11');"  onblur="itemOnBlur('contentImg10','posterDiv11');"/>
				</epg:if>
			<div id="posterDiv11" style="position:absolute;left:645px;top:616px;width:280px;height:30px;background-color:#020000;opacity:0.7;" >
			<epg:text left="10" color="#ffffff" top="1" height="22" id="leftCategory${curIdx}"chineseCharNumber="12" width="280" fontSize="21" dotdotdot="…">
			${rightCategoryItems[10].title}
			</epg:text>
			</div>
	</epg:if>
	<epg:if test="${rightCategoryItems[11] != null}">
				<epg:navUrl obj="${rightCategoryItems[11]}" indexUrlVar="indexUrl"/>
				<epg:img src="./images/dot.gif" id="contentImg11"  left="934" top="500" width="292" height="152"/>
				<epg:if test="${rightCategoryItems[11].icon != null}">
					<epg:img src="../${rightCategoryItems[11].icon}"  left="940" top="506" width="280" height="140" id="contentPoster11" rememberFocus="true"
				href="${indexUrl}" onfocus="itemOnFocus('contentImg11','orange11','posterDiv12');"  onblur="itemOnBlur('contentImg11','posterDiv12');"/>
				</epg:if>
				<epg:if test="${rightCategoryItems[11].icon == null}">
					<epg:img src="../${rightCategoryItems[11].itemIcon}"  left="940" top="506" width="280" height="140" id="contentPoster11"
				href="${indexUrl}" onfocus="itemOnFocus('contentImg11','orange11','posterDiv12');"  onblur="itemOnBlur('contentImg11','posterDiv12');"/>
				</epg:if>
			<div id="posterDiv12" style="position:absolute;left:940px;top:616px;width:280px;height:30px;background-color:#020000;opacity:0.7;" >
			<epg:text left="10" color="#ffffff" top="1" height="22" id="leftCategory${curIdx}"chineseCharNumber="12" width="280" fontSize="21" dotdotdot="…">
			${rightCategoryItems[11].title}
			</epg:text>
			</div>
	</epg:if>

</epg:body>
</epg:html>