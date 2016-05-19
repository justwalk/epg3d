<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*"%>
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
	
<!-- 导航菜单  -->
<epg:query queryName="getSeverialItems" maxRows="7" var="menuCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 左侧栏目-->
<epg:query queryName="getSeverialItems" maxRows="6" var="leftCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['leftCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 内容-->
<epg:query queryName="getSeverialItemsWithSubjectPic" maxRows="9" var="contentCategoryItems"  pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true" >
	<epg:param name="categoryCode" value="${templateParams['contentCategoryCode']}" type="java.lang.String"/>
</epg:query>

<epg:navUrl returnTo="biz" returnUrlVar="returnBizUrl"></epg:navUrl>
<epg:navUrl returnTo="home" returnUrlVar="returnHomeUrl"></epg:navUrl>
<script src="${context['EPG_CONTEXT']}/js/base.js"></script>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<style>
	a{
	outline:none;
}
</style>

<script>
var pageLoad = false;
var fristFocus = 0;
if (typeof(iPanel) == 'undefined') {
	pageLoad  = true;
}
var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images";
var _indexUrlList = [];
var _itemIconList = [];
var currFocus = "";
<epg:forEach items="${leftCategoryItems}" var="leftItem" varStatus="idx">
	<epg:navUrl obj="${leftItem}" indexUrlVar="indexUrl"/>
	_indexUrlList[${idx.index}]='${indexUrl}';
	_itemIconList[${idx.index}] = imgPath+"/sd_cinemaList_dj_lefePic"+${idx.index}+".png";
</epg:forEach>
function init(){
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""&&document.getElementById(leaveFocusId+"_a")){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		document.getElementById("midContentFocus0_a").focus();
	}
}
function itemOnFocus(id){
	fristFocus++;
	currFocus = id;
}
function itemOnBlur(){
	currFocus = "";
}
var currPage = 1;
function leftCategoryPageChange(downOrUp){
	if(downOrUp=="up"){
		currPage = 1;
		for(var i=0;i<3;i++){
			if(_itemIconList[i]!=null){
				$("left"+i+"_img").style.visibility="visible";
				$("leftUp_img").style.visibility="hidden";
				$("leftDown_img").style.visibility="visible";
				$("leftFocus"+i+"_div").style.visibility="visible";
				$("left"+i+"_img").src= _itemIconList[i];
				$("leftFocus"+i+"_a").href =_indexUrlList[i]+"&leftPageNum=1";
			}else{
				$("left"+i+"_img").style.visibility="hidden";
				$("leftFocus"+i+"_div").style.visibility="hidden";
			}
		}
		$("leftFocus0_a").focus();
	}else if(downOrUp=="down"){
		currPage = 2;
		for(var i=3;i<6;i++){
			if (_itemIconList[i] != null) {
				$("left" + (i - 3) + "_img").style.visibility = "visible";
				$("leftUp_img").style.visibility = "visible";
				$("leftDown_img").style.visibility = "hidden";
				$("leftFocus" + (i - 3) + "_div").style.visibility = "visible";
				$("left" + (i - 3) + "_img").src = _itemIconList[i];
				$("leftFocus" + (i - 3) + "_a").href = _indexUrlList[i] + "&leftPageNum=2";
			}else {
				$("left" + (i - 3) + "_img").style.visibility = "hidden";
				$("leftFocus" + (i - 3) + "_div").style.visibility = "hidden";
			}
		}
		$("leftFocus1_img_img").style.visibility = "hidden";
		$("leftFocus2_img_img").style.visibility = "hidden";
		$("leftFocus0_a").focus();
	}
}

function getfocus(objId){
	if("r_"==objId.substr(0,2)){
		objId=objId.substr(2,objId.length);
	}
	if(pageLoad){
		fristFocus++;
		var id = objId.substring(0,objId.indexOf("_"));
		document.getElementById(id+"_img_img").style.visibility="visible";
		document.getElementById("r_"+id+"_img_img").style.visibility="visible";
	}
}
function outfocus(objId){
	if("r_"==objId.substr(0,2)){
		objId=objId.substr(2,objId.length);
	}
	if(pageLoad){
		var id = objId.substring(0,objId.indexOf("_"));
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
			if (currFocus == "leftFocus0") {
				if (currPage == 2) {
					leftCategoryPageChange("up");
				}else{
					$("menu1_a").focus();
				}
				return 0;
			}
	    	break;
		case "SITV_KEY_DOWN":
			if(fristFocus==0){return 0;break;}
			if(currFocus == "leftFocus2"){
				leftCategoryPageChange("down");
				return 0;
			}
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
				return 0;
	    	break;
	    case "SITV_KEY_PAGEDOWN":
				pageDown();
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
function pageUp(){
  	var previousUrl = "${pageBean.previousUrl}";
	var myPageIndex = "";
	if(previousUrl.indexOf("&pageIndex=")!=-1){
		myPageIndex = previousUrl.substring(previousUrl.indexOf("&pageIndex="),previousUrl.length);
		previousUrl =previousUrl.substring(0,previousUrl.indexOf("&pageIndex="));
	}
	if(previousUrl.indexOf("&leaveFocusId=")!=-1){
		previousUrl = previousUrl.substring(0,previousUrl.indexOf("&leaveFocusId="));
	}
 	document.location.href = previousUrl+"&leaveFocusId=pageUp"+myPageIndex;
 }
 function pageDown(){
 	var nextUrl = "${pageBean.nextUrl}";
	var myPageIndex = "";
	if(nextUrl.indexOf("&pageIndex=")!=-1){
		myPageIndex = nextUrl.substring(nextUrl.indexOf("&pageIndex="),nextUrl.length);
		nextUrl =nextUrl.substring(0,nextUrl.indexOf("&pageIndex="));
	}
	if(nextUrl.indexOf("&leaveFocusId=")!=-1){
		nextUrl = nextUrl.substring(0,nextUrl.indexOf("&leaveFocusId="));
	}
 	document.location.href = nextUrl+"&leaveFocusId=pageDown"+myPageIndex;
 }

</script>

<epg:body onload="init()" bgcolor="#000000"  width="1280" height="720" >

<div id="leftDiv">
<!-- 背景图片以及头部图片 -->
<epg:img src="./images/sd_cinemaList_dj.jpg" id="main"  left="0" top="0" width="640" height="720"/>

<!-- 导航 -->
<epg:grid column="7" row="1" left="100" top="90" width="450" height="39"  hcellspacing="35" items="${menuCategoryItems}" var="menuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:if test="${curIdx==1}">
		<epg:img id="menu${curIdx}" src="./images/dot.gif" width="39" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" href="${returnBizUrl}"
		height="39" left="${positions[curIdx-1].x+20}" top="${positions[curIdx-1].y}"/>
		<epg:img id="menu${curIdx}_img" src="./images/dot.gif" width="39" style="visibility:hidden;border:3px solid #ff9c13" 
		height="39" left="${positions[curIdx-1].x+20}" top="${positions[curIdx-1].y}"/>
	</epg:if>
	<epg:if test="${curIdx == 2 || curIdx == 3 ||  curIdx == 4}">
		<epg:img id="menu${curIdx}" src="./images/dot.gif" width="60" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  href="${indexUrl}"
		height="39" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}"/>
		<epg:img id="menu${curIdx}_img" src="./images/dot.gif" width="60" style="visibility:hidden;border:3px solid #ff9c13" 
		height="39" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}"/>
	</epg:if>
	
	<epg:if test="${curIdx == 5 || curIdx == 6}">
		<epg:img id="menu${curIdx}" src="./images/dot.gif" width="60" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  href="${indexUrl}"
		height="39" left="${positions[curIdx-1].x+10}" top="${positions[curIdx-1].y}"/>
		<epg:img id="menu${curIdx}_img" src="./images/dot.gif" width="70" style="visibility:hidden;border:3px solid #ff9c13" 
		height="39" left="${positions[curIdx-1].x+10}" top="${positions[curIdx-1].y}"/>
	</epg:if>
	
	<epg:if test="${curIdx == 7}">
		<epg:img id="menu${curIdx}" src="./images/dot.gif" width="60" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  href="${indexUrl}"
		height="39" left="${positions[curIdx-1].x+20}" top="${positions[curIdx-1].y}"/>
		<epg:img id="menu${curIdx}_img" src="./images/dot.gif" width="70" style="visibility:hidden;border:3px solid #ff9c13" 
		height="39" left="${positions[curIdx-1].x+20}" top="${positions[curIdx-1].y}"/>
	</epg:if>	
</epg:grid>
<epg:img id="back" src="./images/dot.gif" width="69" rememberFocus="true"  height="30" left="535" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  top="37" href="${returnHomeUrl}"/>
<epg:img id="back_img" src="./images/dot.gif" width="69"  style="visibility:hidden;border:3px solid #ff9c13"  height="30" left="535"  top="37"/>


<!--上下页、确定 -->
<!-- pageTurn -->
<epg:img id="pageUp" left="162" top="160"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  width="65" height="32" src="./images/dot.gif" href="javascript:pageUp();"/>
<epg:img  id="pageUp_img"  left="162" top="160" style="visibility:hidden;border:3px solid #ff9c13"  width="65" height="32" src="./images/dot.gif" />
<epg:img id="pageDown"  left="238" top="160" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  width="65" height="32" src="./images/dot.gif" href="javascript:pageDown();"/>
<epg:img id="pageDown_img"  left="238" top="160" style="visibility:hidden;border:3px solid #ff9c13" width="65" height="32" src="./images/dot.gif" />


<epg:text left="325" top="168" align="center" width="30" height="32" color="#99ccff" fontSize="24" 
	text="${pageBean.pageIndex}"/>

<epg:text id="pageNum" left="355" top="168" width="80" height="32" color="#d8d8d8" fontSize="24" 
	text="/ ${pageBean.pageCount} 页"/>

<epg:grid column="3" row="3" left="165" top="208" width="440" height="460" vcellspacing="20"  hcellspacing="20"  items="${contentCategoryItems}" var="contentCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${contentCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:choose>
		<epg:when test="${!empty contentCategoryItem.icon}">
			<epg:img id="midContent${curIdx-1}" src="../${contentCategoryItem.icon}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="140" height="140" />
		</epg:when>
		<epg:otherwise>
			<epg:img id="midContent${curIdx-1}" src="../${contentCategoryItem.itemIcon}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="140" height="140" />
		</epg:otherwise>
	</epg:choose>
	<epg:img id="midContentFocus${curIdx-1}" rememberFocus="true"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
		src="./images/dot.gif" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="140" height="140" href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=bizcat"/>
	<epg:img id="midContentFocus${curIdx-1}_img" style="visibility:hidden;border:3px solid #ff9c13"
		src="./images/dot.gif" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="140" height="140"/>
	
	
	<div id="midContent${curIdx-1}_titlediv" 
		style="position:absolute;font-size:22px;font-family:'黑体';color:#FFFFFF;opacity:0.7;overflow:hidden;
		text-align:center;background-color:#020000;left:${positions[curIdx-1].x}px;top:${positions[curIdx-1].y+110}px;width:140px;height:30px;z-index:1;">
		<epg:text align="left" left="5"  color="#ffffff" height="22"  chineseCharNumber="11" width="140" fontSize="14" dotdotdot="…">
			${contentCategoryItems[curIdx-1].title}
		</epg:text>
	</div>
</epg:grid>



<!--左侧栏目 -->
<epg:grid column="1" row="6" left="40" top="208" width="100" height="460" vcellspacing="500"   items="${leftCategoryItems}" var="leftCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:if test="${curIdx<4}" >	
		<epg:navUrl obj="${leftCategoryItem}" indexUrlVar="indexUrl"/>
		<epg:img id="left${curIdx-1}" 
		     src="./images/sd_cinemaList_dj_lefePic${curIdx-1}.png" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="100" height="140" />
		<epg:img id="leftFocus${curIdx-1}"  onfocus="getfocus(this.id);itemOnFocus('leftFocus${curIdx-1}');"  onblur="outfocus(this.id);itemOnBlur();"
		     src="./images/dot.gif" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="100" height="140" href="${indexUrl}&leftPageNum=1"/>
			 <epg:img id="leftFocus${curIdx-1}_img" style="visibility:hidden;border:3px solid #ff9c13"
		     src="./images/dot.gif" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="100" height="140"/>
	</epg:if>
</epg:grid>


<!--左侧箭头 -->
<epg:img id="leftUp" style="visibility:hidden;"  src="./images/boultUp.png" width="40" height="17" left="75" top="182" />
<epg:img id="leftDown" style="visibility:visible;"  src="./images/boultDown.png" width="40" height="17" left="75" top="676" />

</div>

<!-- ********************************************************************************************** -->
<div id="rightDiv">
<!-- 背景图片以及头部图片 -->
<epg:img src="./images/sd_cinemaList_dj.jpg" id="main"  left="640" top="0" width="640" height="720"/>

<!-- 导航 -->
<epg:grid column="7" row="1" left="740" top="90" width="450" height="39"  hcellspacing="35" items="${menuCategoryItems}" var="menuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:if test="${curIdx==1}">
		<epg:img id="r_menu${curIdx}" src="./images/dot.gif" width="39" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" href="${returnBizUrl}"
		height="39" left="${positions[curIdx-1].x+20}" top="${positions[curIdx-1].y}"/>
		<epg:img id="r_menu${curIdx}_img" src="./images/dot.gif" width="39" style="visibility:hidden;border:3px solid #ff9c13" 
		height="39" left="${positions[curIdx-1].x+20}" top="${positions[curIdx-1].y}"/>
	</epg:if>
	<epg:if test="${curIdx == 2 || curIdx == 3 ||  curIdx == 4}">
		<epg:img id="r_menu${curIdx}" src="./images/dot.gif" width="60" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  href="${indexUrl}"
		height="39" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}"/>
		<epg:img id="r_menu${curIdx}_img" src="./images/dot.gif" width="60" style="visibility:hidden;border:3px solid #ff9c13" 
		height="39" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}"/>
	</epg:if>
	
	<epg:if test="${curIdx == 5 || curIdx == 6}">
		<epg:img id="r_menu${curIdx}" src="./images/dot.gif" width="60" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  href="${indexUrl}"
		height="39" left="${positions[curIdx-1].x+10}" top="${positions[curIdx-1].y}"/>
		<epg:img id="r_menu${curIdx}_img" src="./images/dot.gif" width="70" style="visibility:hidden;border:3px solid #ff9c13" 
		height="39" left="${positions[curIdx-1].x+10}" top="${positions[curIdx-1].y}"/>
	</epg:if>
	
	<epg:if test="${curIdx == 7}">
		<epg:img id="r_menu${curIdx}" src="./images/dot.gif" width="60" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  href="${indexUrl}"
		height="39" left="${positions[curIdx-1].x+20}" top="${positions[curIdx-1].y}"/>
		<epg:img id="r_menu${curIdx}_img" src="./images/dot.gif" width="70" style="visibility:hidden;border:3px solid #ff9c13" 
		height="39" left="${positions[curIdx-1].x+20}" top="${positions[curIdx-1].y}"/>
	</epg:if>	
</epg:grid>
<epg:img id="r_back" src="./images/dot.gif" width="69" rememberFocus="true"  height="30" left="1175" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  top="37" href="${returnHomeUrl}"/>
<epg:img id="r_back_img" src="./images/dot.gif" width="69"  style="visibility:hidden;border:3px solid #ff9c13"  height="30" left="1175"  top="37"/>

<!--上下页、确定 -->
<!-- pageTurn -->
<epg:img id="r_pageUp" left="802" top="160"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  width="65" height="32" src="./images/dot.gif" href="javascript:pageUp();"/>
<epg:img  id="r_pageUp_img"  left="802" top="160" style="visibility:hidden;border:3px solid #ff9c13"  width="65" height="32" src="./images/dot.gif" />
<epg:img id="r_pageDown"  left="878" top="160" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  width="65" height="32" src="./images/dot.gif" href="javascript:pageDown();"/>
<epg:img id="r_pageDown_img"  left="878" top="160" style="visibility:hidden;border:3px solid #ff9c13" width="65" height="32" src="./images/dot.gif" />


<epg:text left="964" top="168" align="center" width="30" height="32" color="#99ccff" fontSize="24" 
	text="${pageBean.pageIndex}"/>

<epg:text id="pageNum" left="994" top="168" width="80" height="32" color="#d8d8d8" fontSize="24" 
	text="/ ${pageBean.pageCount} 页"/>

<epg:grid column="3" row="3" left="805" top="208" width="440" height="460" vcellspacing="20"  hcellspacing="20"  items="${contentCategoryItems}" var="contentCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${contentCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:choose>
		<epg:when test="${!empty contentCategoryItem.icon}">
			<epg:img id="r_midContent${curIdx-1}" src="../${contentCategoryItem.icon}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="140" height="140" />
		</epg:when>
		<epg:otherwise>
			<epg:img id="r_midContent${curIdx-1}" src="../${contentCategoryItem.itemIcon}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="140" height="140" />
		</epg:otherwise>
	</epg:choose>
	<epg:img id="r_midContentFocus${curIdx-1}" rememberFocus="true"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
		src="./images/dot.gif" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="140" height="140" href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=bizcat"/>
	<epg:img id="r_midContentFocus${curIdx-1}_img" style="visibility:hidden;border:3px solid #ff9c13"
		src="./images/dot.gif" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="140" height="140"/>
	
	
	<div id="r_midContent${curIdx-1}_titlediv" 
		style="position:absolute;font-size:22px;font-family:'黑体';color:#FFFFFF;opacity:0.7;overflow:hidden;
		text-align:center;background-color:#020000;left:${positions[curIdx-1].x}px;top:${positions[curIdx-1].y+110}px;width:140px;height:30px;z-index:1;">
		<epg:text align="left" left="5"  color="#ffffff" height="22"  chineseCharNumber="11" width="140" fontSize="14" dotdotdot="…">
			${contentCategoryItems[curIdx-1].title}
		</epg:text>
	</div>
</epg:grid>
<!--左侧栏目 -->
<epg:grid column="1" row="6" left="680" top="208" width="100" height="460" vcellspacing="500"   items="${leftCategoryItems}" var="leftCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:if test="${curIdx<4}" >	
		<epg:navUrl obj="${leftCategoryItem}" indexUrlVar="indexUrl"/>
		<epg:img id="r_left${curIdx-1}" 
		     src="./images/sd_cinemaList_dj_lefePic${curIdx-1}.png" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="100" height="140" />
		<epg:img id="r_leftFocus${curIdx-1}"  onfocus="getfocus(this.id);itemOnFocus('leftFocus${curIdx-1}');"  onblur="outfocus(this.id);itemOnBlur();"
		     src="./images/dot.gif" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="100" height="140" href="${indexUrl}&leftPageNum=1"/>
		<epg:img id="r_leftFocus${curIdx-1}_img" style="visibility:hidden;border:3px solid #ff9c13"
		     src="./images/dot.gif" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="100" height="140"/>
	</epg:if>
</epg:grid>
<!--左侧箭头 -->
<epg:img id="r_leftUp" style="visibility:hidden;"  src="./images/boultUp.png" width="40" height="17" left="715" top="182" />
<epg:img id="r_leftDown" style="visibility:visible;"  src="./images/boultDown.png" width="40" height="17" left="715" top="676" />



</div>
</epg:body>
</epg:html>