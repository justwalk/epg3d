<%@page contentType="text/html; charset=GBK" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%request.getSession().removeAttribute("PlayBackURL");%>
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
%>
<epg:html>
<head>
	<title>八卦</title>
</head>
<epg:query queryName="getSeverialItems" maxRows="6" var="menuCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>
<epg:query queryName="getSeverialItems" maxRows="10" var="contents" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true">
	<epg:param name="categoryCode" value="${templateParams['categoryCode']}" type="java.lang.String"/>
</epg:query>
<epg:query queryName="getSeverialItemsIncludePic" maxRows="6" var="recommandItems" >
	<epg:param name="categoryCode" value="${templateParams['rightCategoryCode']}" type="java.lang.String"/>
</epg:query>
<epg:navUrl returnTo="home" returnUrlVar="returnHomeUrl"></epg:navUrl>
<epg:navUrl returnTo="biz" returnUrlVar="returnBizUrl"/>
<style type="text/css">
	img{border:0px solid black;}
	body{
		color:#FFFFFF;
		font-size:24;
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
 	document.location.href = "${returnBizUrl}";
}
function exit(){
	document.location.href = "${returnHomeUrl}";
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
 	document.location.href = previousUrl+"&leaveFocusId=up_focus"+myPageIndex;
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
 	document.location.href = nextUrl+"&leaveFocusId=down_focus"+myPageIndex;
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

function init()
{
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""&&document.getElementById(leaveFocusId+"_a")){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		document.getElementById("content1_a").focus();
	}
}
//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名
function itemOnFocus(objId,img,color){
	if (pageLoad) {
		fristFocus++;
		document.getElementById(objId+"_focus"+"_img").src=imgPath+"/"+img+".png";
		if(typeof(color)!='undefined'){
			document.getElementById(objId+"_text_span").style.color=color;
		}
	}
}

//失去焦点事件
function itemOnBlur(objId,color){
	if (pageLoad) {
		document.getElementById(objId+"_focus"+"_img").src=imgPath+"/dot.gif";
		if(typeof(color)!='undefined'){
			document.getElementById(objId+"_text_span").style.color=color;
		}
	}
}

</script>

<epg:body onload="init();" background="../${templateParams['bgImg']}" defaultBg="./images/yule2.jpg" style="background-repeat:no-repeat;"  background="../${templateParams['bgImg']}"  bgcolor="#000000"  width="1280" height="720"  >
<!--导航条start-->
			<epg:img id="menu5_focus"   onfocus="itemOnFocus('menu5','newsMenuFocus0');"  onblur="itemOnBlur('menu5');"  
			src="./images/dot.gif" left="255" top="35" width="136" height="76" href="${returnBizUrl}" />
  		<epg:if test="${menuCategoryItems[1]!=null}">
			<epg:navUrl obj="${menuCategoryItems[1]}" indexUrlVar="menu0Url"/>
			<epg:img id="menu0_focus" onfocus="itemOnFocus('menu0','newsMenuFocus1');"  onblur="itemOnBlur('menu0');" 
				src="./images/dot.gif" href="${menu0Url}" left="398" top="35" width="136" height="76"/>
		</epg:if>
		<epg:if test="${menuCategoryItems[2]!=null}">
			<epg:navUrl obj="${menuCategoryItems[2]}" indexUrlVar="menu1Url"/>
			<epg:img id="menu1_focus" onfocus="itemOnFocus('menu1','newsMenuFocus2');"  onblur="itemOnBlur('menu1');" 
				src="./images/dot.gif" href="${menu1Url}" left="545" top="35" width="136" height="76"/>
		</epg:if>
		<epg:if test="${menuCategoryItems[3]!=null}">
			<epg:navUrl obj="${menuCategoryItems[3]}" indexUrlVar="menu2Url"/>
			<epg:img id="menu2_focus" onfocus="itemOnFocus('menu2','newsMenuFocus3');"  onblur="itemOnBlur('menu2');" 
				src="./images/dot.gif" href="${menu2Url}" left="687" top="35" width="136" height="76"/>
		</epg:if>
		<epg:if test="${menuCategoryItems[4]!=null}">
			<epg:navUrl obj="${menuCategoryItems[4]}" indexUrlVar="menu3Url"/>
			<epg:img id="menu3_focus" onfocus="itemOnFocus('menu3','newsMenuFocus4');"  onblur="itemOnBlur('menu3');" 
				src="./images/dot.gif" href="${menu3Url}" left="832" top="35" width="136" height="76"/>
		</epg:if>
		<epg:if test="${menuCategoryItems[5]!=null}">
			<epg:navUrl obj="${menuCategoryItems[5]}" indexUrlVar="menu4Url"/>
			<epg:img id="menu4_focus" onfocus="itemOnFocus('menu4','newsMenuFocus5');"  onblur="itemOnBlur('menu4');" 
				src="./images/dot.gif" href="${menu4Url}" left="977" top="35" width="136" height="76"/>
		</epg:if>

<!-- 上下页&返回 -->
<epg:text left="566" top="125" width="150" height="29" fontSize="24" color="#ffffff" align="left" text="${pageBean.pageIndex}/${pageBean.pageCount}页" />

<epg:img id="up_focus" onfocus="itemOnFocus('up','gossipPageup')" onblur="itemOnBlur('up')" src="./images/dot.gif" left="260" top="117" width="127" height="47" href="javascript:pageUp();" />


<epg:img id="down_focus" onfocus="itemOnFocus('down','gossipPagedown')" onblur="itemOnBlur('down')"   src="./images/dot.gif" left="390" top="117"  width="127" height="47"  href="javascript:pageDown();" />


<epg:img id="back_focus"   onfocus="itemOnFocus('back','focusBackHome')" onblur="itemOnBlur('back')"  src="./images/dot.gif" left="1132" top="76" width="100" height="60" href="${returnBizUrl}" />
	



<epg:grid column="1" row="10"  left="192" top="178" width="496" height="480" posVar="positions" hcellspacing="35" items="${contents}" var="content" indexVar="curIdx" >
<epg:if test="${context['EPG_CATEGORY_CODE']!=null}">
	<epg:navUrl obj="${content}" indexUrlVar="indexUrl" />
	<epg:img id="content${curIdx}" rememberFocus="true" onfocus="itemOnFocus('content${curIdx}','liFocus','#ffffff')" onblur="itemOnBlur('content${curIdx}','#fcb393')"     href="${indexUrl}"  left="${positions[curIdx-1].x-30}" top="${positions[curIdx-1].y-10}" width="455" height="25"  src="./images/dot.gif" />
	<epg:img id="content${curIdx}_focus" src="./images/dot.gif"  left="${positions[curIdx-1].x-25}" top="${positions[curIdx-1].y}" width="465" height="35"/>
	
	<epg:text id="content${curIdx}_text" left="${positions[curIdx-1].x}" top="${positions[curIdx-1].y+4}" width="496" height="40" fontSize="24"  chineseCharNumber="16"  dotdotdot="…"  color="#fcb393">${content.title}</epg:text>
</epg:if>
</epg:grid>
<epg:if test="${pageBean.pageIndex==1}">
	<epg:img id="c_1" left="143" top="180" src="./images/1.png" width="33" height="37" />
	<epg:img id="c_2" left="143" top="230" src="./images/2.png" width="33" height="37" />
	<epg:img id="c_3" left="143" top="280" src="./images/3.png" width="33" height="37" />
</epg:if>
<epg:grid column="3" row="2" left="668" top="176" width="402" height="364" posVar="positions" hcellspacing="78" vcellspacing="115" items="${recommandItems}" var="recommand" indexVar="curIdx" >
	<epg:navUrl obj="${recommand}"  indexUrlVar="indexUrl" />
	<epg:img id="recommand${curIdx}" left="${positions[curIdx-1].x-2}" top="${positions[curIdx-1].y}"  src="../${recommand.poster}" width="130" height="195"/>
	<epg:img id="recommandF${curIdx}" left="${positions[curIdx-1].x-12}" top="${positions[curIdx-1].y-8}" rememberFocus="true" onfocus="itemOnFocus('recommandF${curIdx}','posterFocus')" onblur="itemOnBlur('recommandF${curIdx}')"    src="./images/dot.gif" width="150" height="206" href="${indexUrl}&pi=${curIdx}" />
	<epg:img id="recommandF${curIdx}_focus" src="./images/dot.gif"  left="${positions[curIdx-1].x-12}" top="${positions[curIdx-1].y-9}" width="150" height="215"/>
</epg:grid>
</epg:body>
</epg:html>