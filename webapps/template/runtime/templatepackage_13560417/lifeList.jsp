<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@page import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*"%>
<%
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setDateHeader("Expires", 0); 
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
	String categoryType = request.getParameter("categoryType");//栏目编号
	request.setAttribute("categoryType", categoryType);
%>
<epg:html>

<!-- 高清菜单  -->
<epg:query queryName="getSeverialItems" maxRows="4" var="menuCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 左边推荐大图-->
<epg:query queryName="getSeverialItems" maxRows="1" var="leftPicCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['leftPicCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 左边推荐文字-->
<epg:query queryName="getSeverialItems" maxRows="5" var="leftCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['leftCategoryCode']}" type="java.lang.String"/>
</epg:query>
<!-- 中间内容 -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="20" var="rightCategoryItems" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true"  >
	<epg:param name="categoryCode" value="${context['EPG_CATEGORY_CODE']}" type="java.lang.String"  />
</epg:query>
<epg:navUrl returnTo="home" returnUrlVar="returnUrl"></epg:navUrl>

<style type="text/css">
	body{
		color:#FFFFFF;
		font-size:21;
		font-family:"黑体";
	}
	a{outline:none;}
</style>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script type="text/javascript">
var pageLoad = false;
var fristFocus = 0;
if (typeof(iPanel) == 'undefined') {
	pageLoad  = true;
}
//监听事件
 function back(){
 	document.location.href = "${returnUrl}";
 }
 function exit(){
 	back();
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
				return 0;
	    	break;
	    case "SITV_KEY_PAGEDOWN":
				pageDown();
				return 0;
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
var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images";
var _requester = null; 
var pageSize = 20;	
var pageIndex = 1;	
var pageTotal;
var pageCount="${pageBean.pageCount}";
var categoryList=[];

//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名
function itemOnFocus(objId,img){
	if (pageLoad) {
		fristFocus++;
		document.getElementById(objId+"_img").src=imgPath+"/"+img+".png";
		if (document.getElementById(objId + "_span")) {
			document.getElementById(objId + "_span").style.color = "#ffffff";
		}
	}
}
//失去焦点事件
function itemOnBlur(objId){
	if (pageLoad) {
		document.getElementById(objId+"_img").src=imgPath+"/dot.gif";
		if (document.getElementById(objId + "_span")) {
			document.getElementById(objId + "_span").style.color = "#003333";
		}
	}
}
//中间文字获得焦点
function textOnFocus(objId,color){
	if (pageLoad) {
			fristFocus++;
			document.getElementById(objId+"_span").style.color=color;
			document.getElementById(objId+"_img").src=imgPath+"/selectedtitle.png";
	}
	
}
function textOnBlur(objId,color){
	if (pageLoad) {
		document.getElementById(objId+"_span").style.color=color;
		document.getElementById(objId+"_img").src=imgPath+"/dot.gif";
	}
}

//左边文字节目获得焦点改变文字和背景div颜色
function textOnBlur1(objId,color,divBgColor){
	if (pageLoad) {
			fristFocus++;
			document.getElementById(objId+"_bg").style.background = divBgColor;
			if(typeof(color)!="undefined"){
				document.getElementById(objId+"_span").style.color=color;
			}
	}
}
function textOnFocus1(objId,textColor,divBgColor){
	if (pageLoad) {
		document.getElementById(objId+"_span").style.color=textColor;
		document.getElementById(objId+"_bg").style.background = divBgColor;
	}
}


function buttonOnFocus(objId,img){
	if (pageLoad) {
			fristFocus++;
		document.getElementById(objId+"_img").src=imgPath+"/"+img+".png";
	}
}
function buttonOnBlur(objId,img){
	if (pageLoad) {
		if(img){
			document.getElementById(objId+"_img").src=imgPath+"/"+img+".png";
		}else{
			document.getElementById(objId+"_img").src=imgPath+"/dot.gif";
		}
	}
}


function init()
{		
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		document.getElementById("categoryList0_a").focus();
	}
}
//左侧图片获得焦点
function iconOnfocus(objId,img,itemId){
	if (pageLoad) {
			fristFocus++;
			document.getElementById(objId).style.visibility="visible";
			document.getElementById(itemId).style.opacity="1";
			document.getElementById(itemId).style.backgroundColor="#f79922";
	}
}
function iconOnblur(objId,itemId){
	if (pageLoad) {
		document.getElementById(objId).style.visibility="hidden";
		document.getElementById(itemId).style.opacity="0.8";
		document.getElementById(itemId).style.backgroundColor="#020000";
	}
}

</script>

<epg:body onload="init()"   bgcolor="#000000"  width="1280" height="720" >
<!-- 背景图片以及头部图片 -->
<epg:img id="main"  defaultSrc="./images/lifeIndex.jpg" src="../${templateParams['backgroundImg']}"
	     left="0" top="0" width="1280" height="720"/>

<epg:resource src="./images/dot.gif" realSrcVar="realSrc" />
<div style="position:absolute;left:0px; top:0px; width:1280px; height:140px;">
<epg:img src="./images/logo.png"  width="350" height="85"/>
</div>
<!-- 搜索,自助,指南 -->
<epg:img src="./images/dot.gif" id="ss"  left="950" top="47" width="80" height="38"
	href="${context['EPG_SEARCH_URL']}" onfocus="itemOnFocus('ss','focusMenuTop_1');"  onblur="itemOnBlur('ss');" />
<epg:img src="./images/dot.gif" id="zz"  left="1050" top="47" width="80" height="38"
	href="${context['EPG_SELF_URL']}" onfocus="itemOnFocus('zz','zizhuFocus');"  onblur="itemOnBlur('zz');" />
<epg:img src="./images/dot.gif" id="zn"  left="1150" top="47"width="80" height="38" 
	 href="javascript:back();" onfocus="itemOnFocus('zn','focusMenuTop_3');"  onblur="itemOnBlur('zn');" />

<!-- 高清导航 -->
<epg:grid column="6" row="1" left="350" top="90" width="880" height="45" hcellspacing="20" items="${menuCategoryItems}" var="menuCategoryItem"  indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${menuCategoryItem}" indexUrlVar="indexUrl"/>
	<epg:if test="${curIdx==categoryType}">
		<epg:img src="./images/lifetop${categoryType}.png"  left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="130" height="45"/>
	</epg:if>
	<epg:img id="menu${curIdx}" rememberFocus="true" 	
	onfocus="buttonOnFocus('menu${curIdx}','life${curIdx}');"  onblur="buttonOnBlur('menu${curIdx}');" 
	src="./images/dot.gif" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y}" width="130" height="45" href="${indexUrl}&categoryType=${curIdx}"/>
</epg:grid>

<!-- 左侧内容 -->
	<epg:if test="${leftPicCategoryItems!=null}">
	<epg:navUrl obj="${leftPicCategoryItems}" indexUrlVar="indexUrl"/>
		<div id="contentImg0" style="position:absolute;background-color:#f79922;visibility:hidden;left:46px;top:132px;width:288px;height:304px;" ></div>
		<epg:img id="leftCategory1"  rememberFocus="true" src="../${leftPicCategoryItems.itemIcon}" 
		onblur="iconOnblur('contentImg0','leftItem0');" onfocus="iconOnfocus('contentImg0','orange1','leftItem0')"
		left="50" href="${indexUrl}&returnTo=biz" top="135" width="280" height="300"/>
		<div id="leftItem0"  style="position:absolute;font-size:22;font-family:'黑体';color:#ffffff;text-align:center;background-color:#020000;left:50px;top:392px;width:280px;height:44px;opacity:0.8;" >
			<epg:text left="10" color="#ffffff" top="10" height="22" chineseCharNumber="12" width="280" fontSize="21" dotdotdot="…">
			${leftPicCategoryItems.title}
			</epg:text>
		</div>
	</epg:if>
	<epg:if test="${leftCategoryItems[0]!=null}">
	<epg:navUrl obj="${leftCategoryItems[0]}" indexUrlVar="indexUrl"/>
		<div id="leftCategory2_bgdiv" style="position:absolute;left:50px;top:439px;width:280px;height:44px;" >
		<epg:img id="leftCategory2" rememberFocus="true" src="./images/dot.gif" 
		onfocus="itemOnFocus('leftCategory2','leftFocus')" onblur="itemOnBlur('leftCategory2')" 
		 href="${indexUrl}&returnTo=biz" width="280" height="44"/>
		</div>
		<epg:text left="59" color="#003333" top="447" height="22" id="leftCategory2"
		 chineseCharNumber="12" width="280" fontSize="21"  dotdotdot="…">
			 ${leftCategoryItems[0].title}
		</epg:text>
	</epg:if>
	<epg:if test="${leftCategoryItems[1]!=null}">
	<epg:navUrl obj="${leftCategoryItems[1]}" indexUrlVar="indexUrl"/>
		
		<div id="leftCategory3_bgdiv" style="position:absolute;left:50px;top:485px;width:280px;height:44px;" >
		<epg:img id="leftCategory3" rememberFocus="true" src="./images/dot.gif" 
		onfocus="itemOnFocus('leftCategory3','leftFocus')" onblur="itemOnBlur('leftCategory3')" 
		 href="${indexUrl}&returnTo=biz" width="280" height="44"/>
		</div>
		<epg:text left="59" color="#003333" top="497" height="22" id="leftCategory3"
		 chineseCharNumber="12" width="280"  fontSize="21" dotdotdot="…">
			 ${leftCategoryItems[1].title}
		</epg:text>
	</epg:if>
	<epg:if test="${leftCategoryItems[2]!=null}">
	<epg:navUrl obj="${leftCategoryItems[2]}" indexUrlVar="indexUrl"/>
		
		<div id="leftCategory4_bgdiv" style="position:absolute;left:50px;top:531px;width:280px;height:44px;" >
		<epg:img id="leftCategory4" rememberFocus="true" src="./images/dot.gif" 
		onfocus="itemOnFocus('leftCategory4','leftFocus')" onblur="itemOnBlur('leftCategory4')" 
		 href="${indexUrl}&returnTo=biz" width="280" height="44"/>
		</div>
		
		<epg:text left="59" color="#003333" top="543" height="22" id="leftCategory4"
		 chineseCharNumber="12" width="280"  fontSize="21" dotdotdot="…">
			 ${leftCategoryItems[2].title}
		</epg:text>
	</epg:if>
	<epg:if test="${leftCategoryItems[3]!=null}">
	<epg:navUrl obj="${leftCategoryItems[3]}" indexUrlVar="indexUrl"/>
		<div id="leftCategory5_bgdiv" style="position:absolute;left:50px;top:577px;width:280px;height:44px;" >
		<epg:img id="leftCategory5" rememberFocus="true" src="./images/dot.gif" 
		onfocus="itemOnFocus('leftCategory5','leftFocus')" onblur="itemOnBlur('leftCategory5')" 
		 href="${indexUrl}&returnTo=biz" width="280" height="44"/>
		 </div>
		<epg:text left="59" color="#003333" top="589" height="22" id="leftCategory5"
		 chineseCharNumber="12" width="280"  fontSize="21" dotdotdot="…">
			 ${leftCategoryItems[3].title}
		</epg:text>
	</epg:if>
	<epg:if test="${leftCategoryItems[4]!=null}">
	<epg:navUrl obj="${leftCategoryItems[4]}" indexUrlVar="indexUrl"/>
		<div id="leftCategory6_bgdiv" style="position:absolute;left:50px;top:623px;width:280px;height:44px;" >
		<epg:img id="leftCategory6" rememberFocus="true" src="./images/dot.gif" 
		onfocus="itemOnFocus('leftCategory6','leftFocus')" onblur="itemOnBlur('leftCategory6')" 
		 href="${indexUrl}&returnTo=biz" width="280" height="44"/>
		</div>
		<epg:text left="59" color="#003333" top="636" height="22" id="leftCategory6"
		 chineseCharNumber="12" width="280"  fontSize="21" dotdotdot="…">
			 ${leftCategoryItems[4].title}
		</epg:text>
	</epg:if>	

<!--上下页、确定 -->
<epg:img src="./images/prePage.png" id="area_upPage"  left="350" top="162" onfocus="buttonOnFocus('area_upPage','prePage_focus')" onblur="buttonOnBlur('area_upPage','prePage')"  pageop="up" keyop="pageup" width="130" height="32" href="javascript:pageUp();"/>
<epg:img src="./images/nextPage.png" id="area_downPage"  left="500" top="162" onfocus="buttonOnFocus('area_downPage','nextPage_focus')" onblur="buttonOnBlur('area_downPage','nextPage')" pageop="down" keyop="pagedown"  width="130" height="32" href="javascript:pageDown();"/>

<div style="position:absolute; top:165px; left:665px; width:130px; height:22px; font-size:22px; " >
	<span id="pageIndex" style="color:#1978b8">${pageBean.pageIndex}</span><span id="pageCount" style="color:#646464">/${pageBean.pageCount}页</span>
</div>

<!--中间文字 -->

<div style="position:absolute;left:350px;top:212px;width:880px;height:450px">
<epg:forEach begin="0" end="1" varStatus="colStatus">
<epg:forEach begin="0" end="9" varStatus="rowStatus">
	<epg:if test="${rightCategoryItems[colStatus.index*10+rowStatus.index]!=null}">
	<epg:navUrl obj="${rightCategoryItems[colStatus.index*10+rowStatus.index]}" indexUrlVar="indexUrl"/>
		<epg:if test="${colStatus.index*10+rowStatus.index<10}">
			<epg:img id="categoryList${colStatus.index*10+rowStatus.index}" left="0" top="${rowStatus.index*45}" width="430" height="45" rememberFocus="true" src="./images/dot.gif" 
			 href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=biz"  onfocus="textOnFocus('categoryList${colStatus.index*10+rowStatus.index}','#ffffff')" onblur="textOnBlur('categoryList${colStatus.index*10+rowStatus.index}','#333')"/>
			<epg:text id="categoryList${colStatus.index*10+rowStatus.index}" left="51" top="${rowStatus.index*45+11}" width="388" height="45" color="#333333" chineseCharNumber="16" fontSize="22" dotdotdot="…">
			${rightCategoryItems[colStatus.index*10+rowStatus.index].title}</epg:text>
		</epg:if>
		<epg:if test="${colStatus.index*10+rowStatus.index>=10}">
			<epg:img id="categoryList${colStatus.index*10+rowStatus.index}" left="450" top="${rowStatus.index*45}" width="430" height="45" rememberFocus="true" src="./images/dot.gif" 
			 href="${indexUrl}&pageIndex=${pageBean.pageIndex}&returnTo=biz"  onfocus="textOnFocus('categoryList${colStatus.index*10+rowStatus.index}','#ffffff')" onblur="textOnBlur('categoryList${colStatus.index*10+rowStatus.index}','#333')" />
			<epg:text id="categoryList${colStatus.index*10+rowStatus.index}" left="501" top="${rowStatus.index*45+11}" width="388" height="26" color="#333333" chineseCharNumber="16" fontSize="22" dotdotdot="…">
			${rightCategoryItems[colStatus.index*10+rowStatus.index].title}</epg:text>
		</epg:if>
	</epg:if>
</epg:forEach>
</epg:forEach>
</div>
</epg:body>
</epg:html>





