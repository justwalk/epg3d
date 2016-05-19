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

<%--该栏目下的内容 
<epg:query queryName="getSeverialItems" maxRows="10" var="contentLists" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true" >
	<epg:param name="categoryCode" value="${context['EPG_CATEGORY_CODE']}" type="java.lang.String"/>
</epg:query>
 --%>

<epg:query queryName="getSeverialItems" maxRows="10" var="contentLists" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true" >
	<epg:param name="categoryCode" value="${templateParams['leftCategoryCode']}" type="java.lang.String"/>
</epg:query>

 
<!-- 音乐固定栏目写死! -->
<!-- 港台 category_42255690 -> 固定栏目[0]~港台[0]康熙来了  固定栏目[1]~港台[2] 大学生了没   固定栏目[2]~港台[3] ss小燕之夜 -->
<epg:query queryName="getSeverialItems" maxRows="3" var="rightCategoryItems1" >
	<epg:param name="categoryCode" value="ccms_category_300962326657" type="java.lang.String"/>
</epg:query>

<!-- 内地 category_02098289 -> 固定栏目[5]~内地[1] 我是歌手  -->
<epg:query queryName="getSeverialItems" maxRows="6" var="rightCategoryItems2" >
	<epg:param name="categoryCode" value="ccms_category_300962326663" type="java.lang.String"/>
</epg:query>

<!-- 海外 category_32909625 -> 固定栏目[3]~海外[1] RunningMan  固定栏目[4]~海外[2] StarKing -->
<epg:query queryName="getSeverialItems" maxRows="6" var="rightCategoryItems3" >
	<epg:param name="categoryCode" value="ccms_category_300962326682" type="java.lang.String"/>
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

//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名
function menuOnFocus(objId,focusImg){
	if (pageLoad) {
		fristFocus++;
		$(objId+"_img").src=imgPath+"/"+focusImg+".png";
	}
}
//失去焦点事件
function menuOnBlur(objId){
	if (pageLoad) {
		$(objId+"_img").src=imgPath+"/dot.gif";
	}
}

function init(){	
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""&&document.getElementById(leaveFocusId+"_a")){
		document.getElementById(leaveFocusId+"_a").focus();
	}else{
		document.getElementById("wordsFocus1_a").focus();
	}
}
</script>
<epg:body onload="init()"  defaultBg="./images/yule6.jpg" background="../${templateParams['bgImg']}" width="1280" height="720" bgcolor="#000000" style="background-repeat:no-repeat;">
	<epg:resource src="./images/play.png" realSrcVar="realSrc1"/>
	<epg:resource src="./images/dot.gif" realSrcVar="realSrc3"/>
<!--导航条start-->
		<epg:navUrl returnTo="biz" returnUrlVar="returnbizUrl"/>
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
<epg:img id="back_focus" onfocus="itemOnFocus('back','focusBackHome')" onblur="itemOnBlur('back')"  src="./images/dot.gif" left="1132" top="76" width="100" height="60" href="${returnBizUrl}" />
<!-- 10条文字列表/播放-->
<div id="programListCategoryItem" style="position:absolute;top:171px;left:93px;width:546px;height:480px;">
    <epg:forEach begin="0" end="9" varStatus="rowStatus">
    		<epg:if test="${contentLists[rowStatus.index]!=null}">
    			<epg:navUrl obj="${contentLists[rowStatus.index]}" indexUrlVar="indexUrl" ></epg:navUrl>			    			    	
			    	<epg:img id="wordsFocus${rowStatus.index+1}_focus" src="./images/dot.gif" left="0" top="${rowStatus.index*48}"  width="546"   height="48" />
			    	<epg:img id="wordsFocus${rowStatus.index+1}" src="./images/dot.gif" width="546"   height="48" rememberFocus="true"
			    	href="${indexUrl}" onfocus="itemOnFocus('wordsFocus${rowStatus.index+1}','liFocus','#FFFFFF');"  onblur="itemOnBlur('wordsFocus${rowStatus.index+1}','#fcb393');" 
					 left="0" top="${rowStatus.index*48+5}"/>
					<epg:img id="play${rowStatus.index+1}" left="16" top="${rowStatus.index*48}"   src="./images/play.png"  width="45" height="45"/>
			    	<epg:text id="wordsFocus${rowStatus.index+1}" fontSize="24" color="#fcb393" text="${contentLists[rowStatus.index].title}" left="65" top="${rowStatus.index*48+8}" width="420" height="42" chineseCharNumber="16" dotdotdot="…"  align="left"/>
			</epg:if>
  </epg:forEach>
 </div>
		
<!-- 右侧推荐栏目 -->
	<epg:navUrl obj="${rightCategoryItems1[0]}" indexUrlVar="indexUrl" ></epg:navUrl>
	<epg:img   src="../${rightCategoryItems1[0].itemIcon}" left="662" top="170" style="border:4px solid #b86668;" width="250" height="130"/>
	<epg:img id="rightPic0_focus" src="./images/dot.gif" rememberFocus="true" left="654" top="166" width="273"  height="148" href="${indexUrl}"
	 onfocus="itemOnFocus('rightPic0','selectedImg');"  onblur="itemOnBlur('rightPic0');"/>
	 
	<epg:navUrl obj="${rightCategoryItems1[1]}" indexUrlVar="indexUrl" ></epg:navUrl>
	<epg:img   src="../${rightCategoryItems1[1].itemIcon}" left="936" top="170" style="border:4px solid #b86668;" width="250" height="130"/>
	<epg:img id="rightPic1_focus" src="./images/dot.gif" left="928" top="166" width="273"  height="148"/>
	<epg:img id="rightPic1" src="./images/dot.gif" rememberFocus="true" left="928" top="166" width="273"  height="148" href="${indexUrl}"
	 onfocus="itemOnFocus('rightPic1','selectedImg');"  onblur="itemOnBlur('rightPic1');"/>
	
	<epg:navUrl obj="${rightCategoryItems1[2]}" indexUrlVar="indexUrl" ></epg:navUrl>
	<epg:img   src="../${rightCategoryItems1[2].itemIcon}" left="662" top="340" style="border:4px solid #b86668;" width="250" height="130"/>
	<epg:img id="rightPic2_focus" src="./images/dot.gif" rememberFocus="true" left="654" top="336" width="273"  height="148"  href="${indexUrl}"
	 onfocus="itemOnFocus('rightPic2','selectedImg');"  onblur="itemOnBlur('rightPic2');"/>
	
	<epg:navUrl obj="${rightCategoryItems3[1]}" indexUrlVar="indexUrl" ></epg:navUrl>
	<epg:img   src="../${rightCategoryItems3[1].itemIcon}" left="936" top="340" style="border:4px solid #b86668;" width="250" height="130"/>
	<epg:img id="rightPic3_focus" src="./images/dot.gif" rememberFocus="true" left="928" top="336" width="273"  height="148"  href="${indexUrl}"
	 onfocus="itemOnFocus('rightPic3','selectedImg');"  onblur="itemOnBlur('rightPic3');"/>
	
	<epg:navUrl obj="${rightCategoryItems3[0]}" indexUrlVar="indexUrl" ></epg:navUrl>
	<epg:img  src="../${rightCategoryItems3[0].itemIcon}" left="662" top="510" style="border:4px solid #b86668;" width="250" height="130"/>
	<epg:img id="rightPic4_focus" src="./images/dot.gif" rememberFocus="true" left="654" top="506" width="273"  height="148" href="${indexUrl}"
	 onfocus="itemOnFocus('rightPic4','selectedImg');"  onblur="itemOnBlur('rightPic4');"/>
	
	<epg:navUrl obj="${rightCategoryItems2[1]}" indexUrlVar="indexUrl" ></epg:navUrl>
	<epg:img  src="../${rightCategoryItems2[1].itemIcon}" left="936" top="510" style="border:4px solid #b86668;" width="250" height="130"/>
	<epg:img id="rightPic5_focus" src="./images/dot.gif" rememberFocus="true" left="928" top="506" width="273"  height="148" href="${indexUrl}"
	 onfocus="itemOnFocus('rightPic5','selectedImg');"  onblur="itemOnBlur('rightPic5');"/>	
	
</epg:body>
</epg:html>