<%@page contentType="text/html; charset=GBK" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
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
<!-- menu -->
<epg:query queryName="getSeverialItems" maxRows="6" var="menuCategoryItems" >
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!--列表栏目分类  -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="6" var="contentResults" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true" >
	   <epg:param name="categoryCode" value="${templateParams['mainCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!-- 栏目下的前两条内容 -->
<epg:query queryName="getSeverialItems" maxRows="2" var="contentList0" >
	<epg:param name="categoryCode" value="${contentResults[0].itemCode}" type="java.lang.String"/>
</epg:query>

<epg:query queryName="getSeverialItems" maxRows="2" var="contentList1" >
	<epg:param name="categoryCode" value="${contentResults[1].itemCode}" type="java.lang.String"/>
</epg:query>

<epg:query queryName="getSeverialItems" maxRows="2" var="contentList2" >
	<epg:param name="categoryCode" value="${contentResults[2].itemCode}" type="java.lang.String"/>
</epg:query>

<epg:query queryName="getSeverialItems" maxRows="2" var="contentList3" >
	<epg:param name="categoryCode" value="${contentResults[3].itemCode}" type="java.lang.String"/>
</epg:query>

<epg:query queryName="getSeverialItems" maxRows="2" var="contentList4" >
	<epg:param name="categoryCode" value="${contentResults[4].itemCode}" type="java.lang.String"/>
</epg:query>

<epg:query queryName="getSeverialItems" maxRows="2" var="contentList5" >
	<epg:param name="categoryCode" value="${contentResults[5].itemCode}" type="java.lang.String"/>
</epg:query>

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
<epg:navUrl returnTo="home" returnUrlVar="returnHomeUrl"></epg:navUrl>
<epg:navUrl returnTo="biz" returnUrlVar="returnBizUrl"/>
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

function $(_id) {
	return "string" == typeof _id ? document.getElementById(_id) : _id;
}

//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名
function itemOnFocus(objId,img,color){
	if (pageLoad) {
		fristFocus++;
		$(objId+"_focus"+"_img").src=imgPath+"/"+img+".png";
		if(typeof(color)!="undefined"){
			document.getElementById(objId+"_span").style.color=color;
		}
	}
}
//失去焦点事件
function itemOnBlur(objId,color){
	if (pageLoad) {
		$(objId+"_focus"+"_img").src=imgPath+"/dot.gif";
		if(typeof(color)!="undefined"){
			document.getElementById(objId+"_span").style.color=color;
		}
	}
}
function init()
{
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		document.getElementById("ContentFocus0_a").focus();
	}
}
</script>
<epg:body onload="init()"  background="../${templateParams['bgImg']}" defaultBg="./images/yule3.jpg"  width="1280" height="720" bgcolor="#000000" style="background-repeat:no-repeat;">
<!--导航条start-->
		<epg:navUrl returnTo="biz" returnUrlVar="returnbizUrl"/>
			<epg:img id="menu5_focus" onfocus="itemOnFocus('menu5','newsMenuFocus0');"  onblur="itemOnBlur('menu5');"  
			src="./images/dot.gif" left="255" top="35" width="136" height="76" href="${returnbizUrl}" />
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

<epg:navUrl returnTo="biz" returnUrlVar="returnbizUrl"/>
<epg:img id="back_focus" onfocus="itemOnFocus('back','focusBackHome')" onblur="itemOnBlur('back')"  src="./images/dot.gif" left="1132" top="76" width="100" height="60" href="${returnBizUrl}" />
	


<!-- 栏目内容图片 -->
	<epg:if test="${contentResults[0]!=null}">
	<epg:navUrl obj="${contentResults[0]}" indexUrlVar="indexUrl" />
	<epg:img   left="120" top="179" src="../${contentResults[0].itemIcon}" width="250" height="130"/>
	<epg:img id="picFocus0" src="./images/dot.gif" rememberFocus="true"  left="113" top="176" width="263"  height="138" href="${indexUrl}"
	 onfocus="itemOnFocus('picFocus0','selectedImg');"  onblur="itemOnBlur('picFocus0');"/>
	 <epg:img id="picFocus0_focus" src="./images/dot.gif" width="273"  height="148" left="108" top="171"/>
	 
	</epg:if>
	<epg:if test="${contentList0[0]!=null}">
	<epg:navUrl obj="${contentList0[0]}" indexUrlVar="indexUrl"/>
	<epg:img id="ContentFocus0" src="./images/dot.gif" rememberFocus="true"   left="376" top="175" width="250"  height="68"  href="${indexUrl}&pi=1" 
	onfocus="itemOnFocus('ContentFocus0','focusContent','#FFFFFF');"  onblur="itemOnBlur('ContentFocus0','#fcb393');"/>
	 <epg:img id="ContentFocus0_focus" src="./images/dot.gif" left="371" top="170" width="260"  height="78"/>
	<epg:text  id="ContentFocus0" fontSize="22" color="#fcb393" dotdotdot="…" left="382" top="182" text="${contentList0[0].title}" chineseCharNumber="22"  height="57" width="245"/>
	</epg:if>
	<epg:if test="${contentList0[1]!=null}">
	<epg:navUrl obj="${contentList0[1]}" indexUrlVar="indexUrl"/>
	<epg:img id="ContentFocus1" src="./images/dot.gif" rememberFocus="true"  left="376" top="246" width="250" height="68"   href="${indexUrl}&pi=2"  
	onfocus="itemOnFocus('ContentFocus1','focusContent','#FFFFFF');"  onblur="itemOnBlur('ContentFocus1','#fcb393');"/>
	 <epg:img id="ContentFocus1_focus" src="./images/dot.gif" left="371" top="241" width="260" height="78"/>
	<epg:text id="ContentFocus1" fontSize="22" color="#fcb393" dotdotdot="…" left="382" top="252" text="${contentList0[1].title}" chineseCharNumber="22"  height="57" width="245"/>
	</epg:if>
	
	<epg:if test="${contentResults[1]!=null}">
	<epg:navUrl obj="${contentResults[1]}" indexUrlVar="indexUrl" />
	<epg:img   left="659" top="179" src="../${contentResults[1].itemIcon}" width="250" height="130"/>
	<epg:img id="picFocus1" src="./images/dot.gif" rememberFocus="true"  left="653" top="176" width="263"  height="138" href="${indexUrl}"
	 onfocus="itemOnFocus('picFocus1','selectedImg');"  onblur="itemOnBlur('picFocus1');"/>
	<epg:img id="picFocus1_focus" src="./images/dot.gif" left="648" top="171" width="273"  height="148"/>
	</epg:if>
	<epg:if test="${contentList1[0]!=null}">
	<epg:navUrl obj="${contentList1[0]}" indexUrlVar="indexUrl"/>
	<epg:img id="ContentFocus2" src="./images/dot.gif" rememberFocus="true"  left="916" top="175" width="250" height="68"  href="${indexUrl}&pi=1"  
	onfocus="itemOnFocus('ContentFocus2','focusContent','#FFFFFF');"  onblur="itemOnBlur('ContentFocus2','#fcb393');"/>
	<epg:img id="ContentFocus2_focus" src="./images/dot.gif" left="911" top="170" width="260" height="78"/>
	<epg:text  id="ContentFocus2" fontSize="22" color="#fcb393" dotdotdot="…" left="922" top="182" text="${contentList1[0].title}" chineseCharNumber="22"  height="57" width="245"/>
	</epg:if>
	<epg:if test="${contentList1[1]!=null}">
	<epg:navUrl obj="${contentList1[1]}" indexUrlVar="indexUrl"/>
	<epg:img id="ContentFocus3" src="./images/dot.gif" rememberFocus="true"  left="916" top="246" width="250" height="68" href="${indexUrl}&pi=2"   
	onfocus="itemOnFocus('ContentFocus3','focusContent','#FFFFFF');"  onblur="itemOnBlur('ContentFocus3','#fcb393');"/>
	<epg:img id="ContentFocus3_focus" src="./images/dot.gif" left="911" top="241" width="260" height="78"/>
	<epg:text id="ContentFocus3" fontSize="22" color="#fcb393" dotdotdot="…" left="922" top="252" text="${contentList1[1].title}" chineseCharNumber="22"  height="57" width="245"/>
	</epg:if>
	
	<epg:if test="${contentResults[2]!=null}">
	<epg:navUrl obj="${contentResults[2]}" indexUrlVar="indexUrl" />
	<epg:img   left="120" top="346" src="../${contentResults[2].itemIcon}" width="250" height="130"/>
	<epg:img id="picFocus2" src="./images/dot.gif" rememberFocus="true"  left="113" top="343"  width="263"  height="138" href="${indexUrl}"
	 onfocus="itemOnFocus('picFocus2','selectedImg');"  onblur="itemOnBlur('picFocus2');"/>
	<epg:img id="picFocus2_focus" src="./images/dot.gif" left="108" top="338"  width="273"  height="148"/>
	</epg:if>
	<epg:if test="${contentList2[0]!=null}">
	<epg:navUrl obj="${contentList2[0]}" indexUrlVar="indexUrl"/>
	<epg:img id="ContentFocus4" src="./images/dot.gif" rememberFocus="true"  left="376" top="340" width="250"  height="68"  href="${indexUrl}&pi=1"
	onfocus="itemOnFocus('ContentFocus4','focusContent','#FFFFFF');"  onblur="itemOnBlur('ContentFocus4','#fcb393');"/>
	<epg:img id="ContentFocus4_focus" src="./images/dot.gif" left="371" top="335" width="260"  height="78"/>
	<epg:text  id="ContentFocus4" fontSize="22" color="#fcb393" dotdotdot="…" left="382" top="347" text="${contentList2[0].title}" chineseCharNumber="22"  height="57" width="245"/>
	</epg:if>
	<epg:if test="${contentList2[1]!=null}">
	<epg:navUrl obj="${contentList2[1]}" indexUrlVar="indexUrl"/>
	<epg:img id="ContentFocus5" src="./images/dot.gif" rememberFocus="true" left="376" top="411" width="250" height="68"  href="${indexUrl}&pi=2" 
	onfocus="itemOnFocus('ContentFocus5','focusContent','#FFFFFF');"  onblur="itemOnBlur('ContentFocus5','#fcb393');"/>
	<epg:img id="ContentFocus5_focus" src="./images/dot.gif" left="371" top="406" width="260" height="78" />
	<epg:text id="ContentFocus5" fontSize="22" color="#fcb393" dotdotdot="…" left="382" top="417" text="${contentList2[1].title}" chineseCharNumber="22"  height="57" width="245"/>
	</epg:if>
	
	<epg:if test="${contentResults[3]!=null}">
	<epg:navUrl obj="${contentResults[3]}" indexUrlVar="indexUrl" />
	<epg:img   left="659" top="346" src="../${contentResults[3].itemIcon}" width="250" height="130"/>
	<epg:img id="picFocus3" src="./images/dot.gif" rememberFocus="true" left="653" top="343" width="263"  height="138"  href="${indexUrl}"
	 onfocus="itemOnFocus('picFocus3','selectedImg');"  onblur="itemOnBlur('picFocus3');"/>
	<epg:img id="picFocus3_focus" src="./images/dot.gif" left="648" top="338" width="273"  height="148"  />
	</epg:if>
	<epg:if test="${contentList3[0]!=null}">
	<epg:navUrl obj="${contentList3[0]}" indexUrlVar="indexUrl"/>
	<epg:img id="ContentFocus6" src="./images/dot.gif" rememberFocus="true" left="916" top="340" width="250" height="68" href="${indexUrl}&pi=1"  
	onfocus="itemOnFocus('ContentFocus6','focusContent','#FFFFFF');"  onblur="itemOnBlur('ContentFocus6','#fcb393');"/>
	<epg:img id="ContentFocus6_focus" src="./images/dot.gif" left="911" top="335" width="260" height="78"/>
	<epg:text  id="ContentFocus6" fontSize="22" color="#fcb393" dotdotdot="…" left="922" top="347" text="${contentList3[0].title}" chineseCharNumber="22"  height="57" width="245"/>
	</epg:if>
	<epg:if test="${contentList3[1]!=null}">
	<epg:navUrl obj="${contentList3[1]}" indexUrlVar="indexUrl"/>
	<epg:img id="ContentFocus7" src="./images/dot.gif" rememberFocus="true" left="916" top="411" width="250"   height="68" href="${indexUrl}&pi=2" 
	onfocus="itemOnFocus('ContentFocus7','focusContent','#FFFFFF');"  onblur="itemOnBlur('ContentFocus7','#fcb393');"/>
	<epg:img id="ContentFocus7_focus" src="./images/dot.gif"  left="911" top="406" width="260"   height="78" />
	<epg:text id="ContentFocus7" fontSize="22" color="#fcb393" dotdotdot="…" left="922" top="417" text="${contentList3[1].title}" chineseCharNumber="22"  height="57" width="245"/>
	</epg:if>
	
	<epg:if test="${contentResults[4]!=null}">
	<epg:navUrl obj="${contentResults[4]}" indexUrlVar="indexUrl" />
	<epg:img   left="120" top="513" src="../${contentResults[4].itemIcon}" width="250" height="130"/>
	<epg:img id="picFocus4" src="./images/dot.gif" rememberFocus="true" left="113" top="510" width="263"  height="138"  href="${indexUrl}"
	 onfocus="itemOnFocus('picFocus4','selectedImg');"  onblur="itemOnBlur('picFocus4');"/>
	<epg:img id="picFocus4_focus" src="./images/dot.gif"  left="108" top="505" width="273"  height="148"/>
	</epg:if>
	<epg:if test="${contentList4[0]!=null}">
	<epg:navUrl obj="${contentList4[0]}" indexUrlVar="indexUrl"/>
	<epg:img id="ContentFocus8" src="./images/dot.gif" rememberFocus="true" left="376" top="510" width="250" height="68"  href="${indexUrl}&pi=1"  
	onfocus="itemOnFocus('ContentFocus8','focusContent','#FFFFFF');"  onblur="itemOnBlur('ContentFocus8','#fcb393');"/>
	<epg:img id="ContentFocus8_focus" src="./images/dot.gif"  left="371" top="505" width="260" height="78" />
	<epg:text  id="ContentFocus8" fontSize="22" color="#fcb393" dotdotdot="…" left="382" top="517" text="${contentList4[0].title}" chineseCharNumber="22"  height="57" width="245"/>
	</epg:if>
	<epg:if test="${contentList4[1]!=null}">
	<epg:navUrl obj="${contentList4[1]}" indexUrlVar="indexUrl"/>
	<epg:img id="ContentFocus9" src="./images/dot.gif" rememberFocus="true" left="376" top="581" width="250"   height="68"  href="${indexUrl}&pi=2" 
	onfocus="itemOnFocus('ContentFocus9','focusContent','#FFFFFF');"  onblur="itemOnBlur('ContentFocus9','#fcb393');"/>
	<epg:img id="ContentFocus9_focus" src="./images/dot.gif" left="371" top="576" width="260"   height="78"   />
	<epg:text id="ContentFocus9" fontSize="22" color="#fcb393" dotdotdot="…" left="382" top="587" text="${contentList4[1].title}" chineseCharNumber="22"  height="57" width="245"/>
	</epg:if>
	
	<epg:if test="${contentResults[5]!=null}">
	<epg:navUrl obj="${contentResults[5]}" indexUrlVar="indexUrl" />
	<epg:img   left="659" top="513" src="../${contentResults[5].itemIcon}" width="250" height="130"/>
	<epg:img id="picFocus5" src="./images/dot.gif" rememberFocus="true" left="653" top="510" width="263"  height="138"  href="${indexUrl}"
	 onfocus="itemOnFocus('picFocus5','selectedImg');"  onblur="itemOnBlur('picFocus5');"/>
	<epg:img id="picFocus5_focus" src="./images/dot.gif" left="648" top="505" width="273"  height="148"   />
	</epg:if>
	<epg:if test="${contentList5[0]!=null}">
	<epg:navUrl obj="${contentList5[0]}" indexUrlVar="indexUrl"/>
	<epg:img id="ContentFocus10" src="./images/dot.gif" rememberFocus="true" left="916" top="510" width="250" height="68"  href="${indexUrl}&pi=1"  
	onfocus="itemOnFocus('ContentFocus10','focusContent','#FFFFFF');"  onblur="itemOnBlur('ContentFocus10','#fcb393');"/>
	<epg:img id="ContentFocus10_focus" src="./images/dot.gif" left="911" top="505" width="260" height="78" />
	<epg:text  id="ContentFocus10" fontSize="22" color="#fcb393" dotdotdot="…" left="922" top="517" text="${contentList5[0].title}" chineseCharNumber="22"  height="57" width="245"/>
	</epg:if>
	<epg:if test="${contentList5[1]!=null}">
	<epg:navUrl obj="${contentList5[1]}" indexUrlVar="indexUrl"/>
	<epg:img id="ContentFocus11" src="./images/dot.gif" rememberFocus="true" left="916" top="581" width="250"  height="68" href="${indexUrl}&pi=2" 
	onfocus="itemOnFocus('ContentFocus11','focusContent','#FFFFFF');"  onblur="itemOnBlur('ContentFocus11','#fcb393');"/>
	<epg:img id="ContentFocus11_focus" src="./images/dot.gif" left="911" top="576" width="260"  height="78"/>
	<epg:text id="ContentFocus11" fontSize="22" color="#fcb393" dotdotdot="…" left="922" top="587" text="${contentList5[1].title}" chineseCharNumber="22"  height="57" width="245"/>
	</epg:if>
	
</epg:body>
</epg:html>