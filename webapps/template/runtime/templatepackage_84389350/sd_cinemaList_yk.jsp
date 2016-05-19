 <%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@page import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*"%>
<%
	String menu2Num = request.getParameter("menu2Num");//年级编号
	request.setAttribute("menu2Num", menu2Num);

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
<!-- 获取二级栏目 -->
<epg:query queryName="getSeverialItems" maxRows="6" var="menu2Results">
	   <epg:param name="categoryCode" value="${templateParams['categoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 获取栏目 -->
<epg:forEach items="${menu2Results}" var="menu2Result" varStatus="idx">
	<epg:if test="${menu2Num != null}">
		<!-- 获取结果 -->
		<epg:query queryName="getSeverialItems" maxRows="1" var="currentCategoryItem">
			<epg:param name="categoryCode" value="${menu2Results[menu2Num-1].itemCode}" type="java.lang.String"/>
		</epg:query>
	</epg:if>
	<epg:if test="${menu2Num == null}">
		<!-- 获取结果 -->
		<epg:query queryName="getSeverialItems" maxRows="1" var="currentCategoryItem">
			<epg:param name="categoryCode" value="${menu2Results[0].itemCode}" type="java.lang.String"/>
		</epg:query>
	</epg:if>
</epg:forEach>
<epg:query queryName="getSeverialItemsIncludePic" maxRows="12" var="rightCategoryItems" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true" >
	<epg:param name="categoryCode" value="${currentCategoryItem.itemCode}" type="java.lang.String"/>
</epg:query>


<!-- left recommend query -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="1" var="leftCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['leftRecommend']}" type="java.lang.String"/>
</epg:query>
<epg:navUrl returnTo="home" returnUrlVar="returnHomeUrl"/>
<epg:navUrl returnTo="biz" returnUrlVar="returnBizUrl"/>
<script src="${context['EPG_CONTEXT']}/js/base.js"></script>
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
	function getfocus(objId){
		if(pageLoad){
			fristFocus++;
			var id = objId.substring(0,objId.indexOf("_"));
			document.getElementById(id+"_img_img").style.visibility="visible";
			document.getElementById("r_"+id+"_img_img").style.visibility="visible";
		}
	}
	function outfocus(objId){
		if(pageLoad){
			var id = objId.substring(0,objId.indexOf("_"));
			document.getElementById(id+"_img_img").style.visibility="hidden";
			document.getElementById("r_"+id+"_img_img").style.visibility="hidden";
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
				pageUp();
	    	break;
	    case "SITV_KEY_PAGEDOWN":
				pageDown();
	    	break;
	    case "SITV_KEY_BACK":
	    	window.location.href = "${returnHomeUrl}";
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
function init(){
	//$("contentFocus1_a").focus();
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""&&document.getElementById(leaveFocusId+"_a")){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		document.getElementById("contentFocus1_a").focus();
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


<epg:body  onload="init()" bgcolor="#000000">
<div id="leftDiv">
<epg:img  src="./images/sd_cinemaList_yk.jpg" width="640" height="720"/>

<!-- back src="../${templateParams['backgroundImg']}"-->

<epg:grid column="7" row="1" left="110" top="90" width="505" height="39"  hcellspacing="35" items="${menuCategoryItems}" var="menuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:if test="${curIdx==1}">
		<epg:img id="menu${curIdx}" src="./images/dot.gif" width="35" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" href="${returnBizUrl}"
		height="39" left="${positions[curIdx-1].x+10}" top="${positions[curIdx-1].y}"/>
		<epg:img id="menu${curIdx}_img" src="./images/dot.gif" width="35" style="visibility:hidden;border:3px solid #ff9c13" 
		height="39" left="${positions[curIdx-1].x+10}" top="${positions[curIdx-1].y}"/>
	</epg:if>
	<epg:if test="${curIdx!=1}">
		<epg:img id="menu${curIdx}" src="./images/dot.gif" width="62" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" href="${indexUrl}"
		height="39" left="${positions[curIdx-1].x-30}" top="${positions[curIdx-1].y}"/>
		<epg:img id="menu${curIdx}_img" src="./images/dot.gif" width="62" style="visibility:hidden;border:3px solid #ff9c13" 
		height="39" left="${positions[curIdx-1].x-30}" top="${positions[curIdx-1].y}"/>
	</epg:if>
</epg:grid>
<epg:img id="back" src="./images/dot.gif" width="35"  height="30" left="555" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  top="37" href="${returnHomeUrl}"/>
<epg:img id="back_img" src="./images/dot.gif" width="35" style="visibility:hidden;border:3px solid #ff9c13"  height="30" left="555"  top="37"/>

<!-- 二级栏目 -->
     <epg:grid column="6" row="1" left="165" top="137" width="440" height="32" hcellspacing="20" vcellspacing="0" items="${menu2Results}" var="menu2CategoryItem"  indexVar="rowStatus" posVar="positions">
 		<epg:navUrl obj="${menu2CategoryItem}" indexUrlVar="indexUrl"/>
 		<epg:if test="${menu2Num ==null && rowStatus==1}">
	 		<epg:img id="menu2bg${rowStatus}" left="${positions[rowStatus-1].x}" top="${positions[rowStatus-1].y}" 
		 		 src="./images/2menu1_cur.png"   width="78" height="36"/>
 		</epg:if>
 		<epg:if test="${menu2Num ==null && rowStatus!=1}">
	 		<epg:img id="menu2bg${rowStatus}" left="${positions[rowStatus-1].x+22}" top="${positions[rowStatus-1].y}" 
		 		 src="./images/2menu${rowStatus}.png"  width="40" height="35"/>
 		</epg:if>
 		<epg:if test="${menu2Num !=null && menu2Num==rowStatus}">
	 		<epg:img id="menu2bg${rowStatus}" left="${positions[rowStatus-1].x}" top="${positions[rowStatus-1].y}" 
		 		 src="./images/2menu${menu2Num}_cur.png"  width="65" height="36"/>
 		</epg:if>
 		<epg:if test="${menu2Num !=null && menu2Num!=rowStatus}">
	 		<epg:img id="menu2bg${rowStatus}" left="${positions[rowStatus-1].x+10}" top="${positions[rowStatus-1].y}" 
		 		 src="./images/2menu${rowStatus}.png"  width="40" height="35"/>
 		</epg:if>
 		<epg:img id="menu2${rowStatus}" left="${positions[rowStatus-1].x-3}" top="${positions[rowStatus-1].y}" 
		onfocus="getfocus(this.id);" onblur="outfocus(this.id);" 
	 		href="${indexUrl}&menu2Num=${rowStatus}" src="./images/dot.gif"  width="39" height="32"/>
		<epg:img id="menu2${rowStatus}_img" left="${positions[rowStatus-1].x-3}" top="${positions[rowStatus-1].y}" 
	 		style="visibility:hidden;border:3px solid #ff9c13" src="./images/dot.gif"  width="78" height="32"/>
    </epg:grid>



<!-- pageTurn -->
<epg:img id="pageUp" left="163" top="185"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  width="65" height="32" src="./images/dot.gif" href="javascript:pageUp();"/>
<epg:img  id="pageUp_img"  left="163" top="185" style="visibility:hidden;border:3px solid #ff9c13"  width="65" height="32" src="./images/dot.gif" />
<epg:img id="pageDown"  left="238" top="185" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  width="65" height="32" src="./images/dot.gif" href="javascript:pageDown();"/>
<epg:img id="pageDown_img"  left="238" top="185" style="visibility:hidden;border:3px solid #ff9c13" width="65" height="32" src="./images/dot.gif" />


<epg:text left="325" top="190" align="center" width="15" height="32" color="#99ccff" fontSize="22" 
	text="${pageBean.pageIndex}"/>

<epg:text left="340" top="190" width="80" height="32" color="#d8d8d8" fontSize="22" 
	text="/ ${pageBean.pageCount} 页"/>
		
<!-- contents -->
<epg:grid left="165" top="235" width="440" height="420" row="2" column="6" items="${rightCategoryItems}"
		  var="rightCategoryItem" indexVar="curIdx" posVar="positions" hcellspacing="20" vcellspacing="30">
	<epg:navUrl obj="${rightCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="content${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="65" height="195" src="../${rightCategoryItem.still}"/>
	<epg:img id="contentFocus${curIdx}" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="65" height="195"
			onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
			 rememberFocus="true" src="./images/dot.gif" href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=bizcat"/>
	<epg:img id="contentFocus${curIdx}_img" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="65" height="195"
			style="visibility:hidden;border:3px solid #ff9c13" src="./images/dot.gif"/>
</epg:grid>

<!-- recommend -->
<epg:navUrl obj="${leftCategoryItems}" playUrlVar="playUrl"/>
<epg:if test="${leftCategoryItems != null}">
	<epg:img left="35" top="235" width="110" height="330" src="../${leftCategoryItems.icon}" />
	<epg:img id="leftrecommend" left="34" top="232" width="110" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" rememberFocus="true" href="${playUrl}&pi=1" height="389" src="./images/dot.gif" />
	<epg:img id="leftrecommend_img" left="34" top="232" width="110" style="visibility:hidden;border:3px solid #ff9c13" height="389" src="./images/dot.gif" />
</epg:if>
<div  style="position:absolute;font-size:16px;font-family:'黑体';color:#cccccc;text-align:center; background-color:#000000;left:35px;top:565px;width:110px;height:59px;z-index:1;">
	<epg:text width="110" height="59" top="12" color="#99ccff" chineseCharNumber="8" dotdotdot=" " fontSize="18" align="center" fontFamily="黑体" text="${leftCategoryItems.title}"/>
</div>
</div>

<div id="rightDiv">
	<epg:img  src="./images/sd_cinemaList_yk.jpg" left="640" width="640" height="720"/>

<!-- back src="../${templateParams['backgroundImg']}"-->

<epg:grid column="7" row="1" left="750" top="90" width="505" height="39"  hcellspacing="35" items="${menuCategoryItems}" var="menuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:if test="${curIdx==1}">
		<epg:img id="r_menu${curIdx}" src="./images/dot.gif" width="35" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" href="${returnBizUrl}"
		height="39" left="${positions[curIdx-1].x+10}" top="${positions[curIdx-1].y}"/>
		<epg:img id="r_menu${curIdx}_img" src="./images/dot.gif" width="35" style="visibility:hidden;border:3px solid #ff9c13" 
		height="39" left="${positions[curIdx-1].x+10}" top="${positions[curIdx-1].y}"/>
	</epg:if>
	<epg:if test="${curIdx!=1}">
		<epg:img id="r_menu${curIdx}" src="./images/dot.gif" width="62" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" href="${indexUrl}"
		height="39" left="${positions[curIdx-1].x-30}" top="${positions[curIdx-1].y}"/>
		<epg:img id="r_menu${curIdx}_img" src="./images/dot.gif" width="62" style="visibility:hidden;border:3px solid #ff9c13" 
		height="39" left="${positions[curIdx-1].x-30}" top="${positions[curIdx-1].y}"/>
	</epg:if>
</epg:grid>
<epg:img id="r_back" src="./images/dot.gif" width="35"  height="30" left="1195" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  top="37" href="${returnHomeUrl}"/>
<epg:img id="r_back_img" src="./images/dot.gif" width="35" style="visibility:hidden;border:3px solid #ff9c13"  height="30" left="1195"  top="37"/>

<!-- 二级栏目 -->
     <epg:grid column="6" row="1" left="805" top="137" width="440" height="32" hcellspacing="20" vcellspacing="0" items="${menu2Results}" var="menu2CategoryItem"  indexVar="rowStatus" posVar="positions">
 		<epg:navUrl obj="${menu2CategoryItem}" indexUrlVar="indexUrl"/>
 		<epg:if test="${menu2Num ==null && rowStatus==1}">
	 		<epg:img id="r_menu2bg${rowStatus}" left="${positions[rowStatus-1].x}" top="${positions[rowStatus-1].y}" 
		 		 src="./images/2menu1_cur.png"   width="78" height="36"/>
 		</epg:if>
 		<epg:if test="${menu2Num ==null && rowStatus!=1}">
	 		<epg:img id="r_menu2bg${rowStatus}" left="${positions[rowStatus-1].x+22}" top="${positions[rowStatus-1].y}" 
		 		 src="./images/2menu${rowStatus}.png"  width="40" height="35"/>
 		</epg:if>
 		<epg:if test="${menu2Num !=null && menu2Num==rowStatus}">
	 		<epg:img id="r_menu2bg${rowStatus}" left="${positions[rowStatus-1].x}" top="${positions[rowStatus-1].y}" 
		 		 src="./images/2menu${menu2Num}_cur.png"  width="65" height="36"/>
 		</epg:if>
 		<epg:if test="${menu2Num !=null && menu2Num!=rowStatus}">
	 		<epg:img id="r_menu2bg${rowStatus}" left="${positions[rowStatus-1].x+10}" top="${positions[rowStatus-1].y}" 
		 		 src="./images/2menu${rowStatus}.png"  width="40" height="35"/>
 		</epg:if>
 		<epg:img id="r_menu2${rowStatus}" left="${positions[rowStatus-1].x-3}" top="${positions[rowStatus-1].y}" 
		onfocus="getfocus(this.id);" onblur="outfocus(this.id);" 
	 		href="${indexUrl}&menu2Num=${rowStatus}" src="./images/dot.gif"  width="39" height="32"/>
		<epg:img id="r_menu2${rowStatus}_img" left="${positions[rowStatus-1].x-3}" top="${positions[rowStatus-1].y}" 
	 		style="visibility:hidden;border:3px solid #ff9c13" src="./images/dot.gif"  width="78" height="32"/>
    </epg:grid>



<!-- pageTurn -->
<epg:img id="r_pageUp" left="803" top="185"  onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  width="65" height="32" src="./images/dot.gif" href="javascript:pageUp();"/>
<epg:img  id="r_pageUp_img"  left="803" top="185" style="visibility:hidden;border:3px solid #ff9c13"  width="65" height="32" src="./images/dot.gif" />
<epg:img id="r_pageDown"  left="878" top="185" onfocus="getfocus(this.id);" onblur="outfocus(this.id);"  width="65" height="32" src="./images/dot.gif" href="javascript:pageDown();"/>
<epg:img id="r_pageDown_img"  left="878" top="185" style="visibility:hidden;border:3px solid #ff9c13" width="65" height="32" src="./images/dot.gif" />


<epg:text left="965" top="190" align="center" width="15" height="32" color="#99ccff" fontSize="22" 
	text="${pageBean.pageIndex}"/>

<epg:text left="980" top="190" width="80" height="32" color="#d8d8d8" fontSize="22" 
	text="/ ${pageBean.pageCount} 页"/>
		
<!-- contents -->
<epg:grid left="805" top="235" width="440" height="420" row="2" column="6" items="${rightCategoryItems}"
		  var="rightCategoryItem" indexVar="curIdx" posVar="positions" hcellspacing="20" vcellspacing="30">
	<epg:navUrl obj="${rightCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:img id="r_content${curIdx}" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="65" height="195" src="../${rightCategoryItem.still}"/>
	<epg:img id="r_contentFocus${curIdx}" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="65" height="195"
			onfocus="getfocus(this.id);" onblur="outfocus(this.id);"
			 rememberFocus="true" src="./images/dot.gif" href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=bizcat"/>
	<epg:img id="r_contentFocus${curIdx}_img" left="${positions[curIdx-1].x-3}" top="${positions[curIdx-1].y-3}" width="65" height="195"
			style="visibility:hidden;border:3px solid #ff9c13" src="./images/dot.gif"/>
</epg:grid>

<!-- recommend -->
<epg:navUrl obj="${leftCategoryItems}" playUrlVar="playUrl"/>
<epg:if test="${leftCategoryItems != null}">
	<epg:img left="675" top="235" width="110" height="330" src="../${leftCategoryItems.icon}" />
	<epg:img id="r_leftrecommend" left="674" top="232" width="110" onfocus="getfocus(this.id);" onblur="outfocus(this.id);" rememberFocus="true" href="${playUrl}&pi=1" height="389" src="./images/dot.gif" />
	<epg:img id="r_leftrecommend_img" left="674" top="232" width="110" style="visibility:hidden;border:3px solid #ff9c13" height="389" src="./images/dot.gif" />
</epg:if>
<div  style="position:absolute;font-size:16px;font-family:'黑体';color:#cccccc;text-align:center; background-color:#000000;left:675px;top:565px;width:110px;height:59px;z-index:1;">
	<epg:text width="110" height="59" top="12" color="#99ccff" chineseCharNumber="8" dotdotdot=" " fontSize="18" align="center" fontFamily="黑体" text="${leftCategoryItems.title}"/>
</div>
</div>

</epg:body>
</epg:html>