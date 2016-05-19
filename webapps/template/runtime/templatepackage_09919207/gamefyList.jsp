<%@page contentType="text/html; charset=gbk" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
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

<!--查询得到菜单的编排参数-->
<epg:query queryName="getSeverialItems" maxRows="6" var="menuResults" >
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!--查询得到二级菜单的编排参数-->
<epg:query queryName="getSeverialItems" maxRows="10" var="subMenuResults" >
	<epg:param name="categoryCode" value="${templateParams['subMenuCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!--本栏目的内容 -->
<epg:query queryName="getSeverialItems" maxRows="9" var="categoryResults" pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true">
	<epg:param name="categoryCode" value="${templateParams['thisCategoryCode']}" type="java.lang.String"/>
</epg:query>
<epg:navUrl returnTo="home" returnUrlVar="returnUrl"></epg:navUrl>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<style>
	img{	
		border:0px;
	}
	a{ 
	display:block;	
	}
	body{
		color:#FFFFFF;
		font-size:24px;
		font-family:黑体;	
		margin:0;
		padding:0;
	}
</style>


<script>
	var pageLoad = false;
		var fristFocus = 0;
if (typeof(iPanel) == 'undefined') {
	pageLoad  = true;
}
//var path = "${context['EPG_CONTEXT']}<%=request.getAttribute("Path")%>";
//var imgPath = path.substring(0,path.indexOf("/index"))+"/images";
var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images/";
function $(_id) {
	return "string" == typeof _id ? document.getElementById(_id) : _id;
}


//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名，isChangeColor 是否改变文字列表颜色
function itemOnFocus(objId,img){
	if (pageLoad==true) {
		fristFocus++;
		if (img != null && img != "") {
			document.getElementById(objId + "_img").src = imgPath + img + ".png";
		}
		if (objId.indexOf("menu") != -1 && objId.indexOf("menu5") == -1) {
			document.getElementById(objId + "_span").style.color = "#ffffff";
		}
		else if (objId.indexOf("catText") != -1) {
			document.getElementById(objId + "_span").style.color = "#f04a23";
		}
	}
}
//失去焦点事件
function itemOnBlur(objId,color){
	if(pageLoad==true) {
		if (color != null && color != "") {
				if (objId.indexOf("menu") != -1) {
					document.getElementById(objId + "_span").style.color = color;
					document.getElementById(objId + "_img").src = imgPath + "dot.gif";
				}
		}else {
			if (objId.indexOf("menu") != -1) {
				if (objId.indexOf("menu5") == -1) {
					document.getElementById(objId + "_span").style.color = "#606060";
				}
				document.getElementById(objId + "_img").src = imgPath + "dot.gif";
			}
			else if(objId.indexOf("subMenu") != -1) {
					document.getElementById(objId + "_img").src = imgPath + "dot.gif";
			}else if(objId.indexOf("catText") != -1) {
				document.getElementById(objId + "_span").style.color = "#606060";
			}else if (objId.indexOf("area_upPage") != -1) {
				document.getElementById(objId + "_img").src = imgPath + "games_pageUp.png";
			}else if (objId.indexOf("area_downPage") != -1) {
				document.getElementById(objId + "_img").src = imgPath + "games_pageDown.png";
			}
		}
	}
}

function init()
{		
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!=""&&document.getElementById(leaveFocusId + "_a")){
		document.getElementById(leaveFocusId + "_a").focus();
	}else{
		document.getElementById("menu0_a").focus();
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

function back(){
	<epg:navUrl returnTo="biz" returnUrlVar="returnBizUrl"/>
 	document.location.href = "${returnBizUrl}";
 }
 function exit(){
	 document.location.href = "${returnUrl}";
 }




function eventHandler(eventObj)
{
	switch(eventObj.code)
	{
		case "SYSTEM_EVENT_ONLOAD":
			setTimeout(function(){
				pageLoad = true;
				init();
				if(typeof(iPanel)!='undefined'){
					iPanel.focus.display = 1;
					iPanel.focus.border = 1;
					iPanel.focus.defaultFocusColor = "#f04a23";
				}
			},1500);
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
			window.location.href = "${context['EPG_CONTEXT']}/common/logout/logout.jsp";
			return 0;
			break;
		default:
			return 1;
			break;
	}
}
function clear(){
	pageLoad = false;
}
</script>
<epg:body   onunload="clear();"  defaultBg="./images/gameList.jpg"  background="../${templateParams['bgImg']}"  bgcolor="#000000" width="1280" height="720" >
<!--<epg:if test="${templateParams['thisCategoryCode']} == categoryResults.categoryCode}">
		<epg:img left="63" top="117" width="1153" height="35" src="./images/WLH_nav${idx}.png"/>
</epg:if>-->

<!-- 风云赛场列表页 -->
<epg:if test="${templateParams['orderFlag'] == '0'}">

<!-- 顶部菜单  -->
	<epg:navUrl obj="${menuResults[0]}" indexUrlVar="index0Url"/>
	<epg:img id="menu0" rememberFocus="true" src="./images/dot.gif"  onfocus="itemOnFocus('menu0','gamesTopFocus')" onblur="itemOnBlur('menu0','#ffffff');"  left="319" top="55" width="150" height="60" href="${index0Url}"/>
	<epg:text id="menu0" left="347" top="73" width="155" height="37" text="${menuResults[0].title}"
				  fontFamily="黑体" fontSize="24" color="#ffffff" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${menuResults[1]}" indexUrlVar="index1Url"/>
	<epg:img id="menu1" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu1','gamesTopFocus')" onblur="itemOnBlur('menu1');" left="471" top="55" width="150" height="60" href="${index1Url}"/>
	<epg:text id="menu1" left="499" top="73" width="155" height="37" text="${menuResults[1].title}"
				  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${menuResults[2]}" indexUrlVar="index2Url"/>
	<epg:img id="menu2" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu2','gamesTopFocus')" onblur="itemOnBlur('menu2');" left="623" top="55" width="150" height="60" href="${index2Url}"/>
	<epg:text id="menu2" left="649" top="73" width="155" height="37" text="${menuResults[2].title}"
				  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${menuResults[3]}" indexUrlVar="index3Url"/>
	<epg:img id="menu3" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu3','gamesTopFocus')" onblur="itemOnBlur('menu3');" left="775" top="55" width="150" height="60" href="${index3Url}"/>
	<epg:text id="menu3" left="801" top="73" width="155" height="37" text="${menuResults[3].title}"
				  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${menuResults[4]}" indexUrlVar="index4Url"/>
	<epg:img id="menu4" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu4','gamesTopFocus')" onblur="itemOnBlur('menu4');" left="927" top="55" width="150" height="60" href="${index4Url}"/>
	<epg:text id="menu4" left="953" top="73" width="155" height="37" text="${menuResults[4].title}"
				  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>
	
	<epg:navUrl returnTo="biz" returnUrlVar="returnBizUrl"/>
	<epg:img id="menu5" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu5','gameBackFocus')" onblur="itemOnBlur('menu5');" left="1079" top="55" width="151" height="60" href="${returnBizUrl}"/>


<!-- 二级菜单  -->
	<epg:navUrl obj="${subMenuResults[0]}" indexUrlVar="index0Url"/>
	<epg:img id="subMenu0" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('subMenu0','gamesTopFocus')" onblur="itemOnBlur('subMenu0');" left="167" top="115" width="150" height="50" href="${index0Url}"/>
	<epg:text id="subMenu0" left="193" top="127" width="155" height="37" text="${subMenuResults[0].title}"
			  fontFamily="黑体" fontSize="22" color="#efefef" chineseCharNumber="9"/>

	<epg:navUrl obj="${subMenuResults[1]}" indexUrlVar="index1Url"/>
	<epg:img id="subMenu1" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('subMenu1','gamesTopFocus')" onblur="itemOnBlur('subMenu1');" left="319" top="115" width="150" height="50" href="${index1Url}"/>
	<epg:text id="subMenu1" left="363" top="127" width="155" height="37" text="${subMenuResults[1].title}"
			  fontFamily="黑体" fontSize="22" color="#efefef" chineseCharNumber="9"/>

	<epg:navUrl obj="${subMenuResults[2]}" indexUrlVar="index2Url"/>
	<epg:img id="subMenu2" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('subMenu2','gamesTopFocus')" onblur="itemOnBlur('subMenu2');" left="471" top="115" width="150" height="50" href="${index2Url}"/>
	<epg:text id="subMenu2" left="508" top="127" width="155" height="37" text="${subMenuResults[2].title}"
				  fontFamily="黑体" fontSize="22" color="#efefef" chineseCharNumber="9"/>
</epg:if>

<!-- 游戏攻略列表页 -->
<epg:if test="${templateParams['orderFlag'] == '1'}">

<!-- 顶部菜单  -->
	<epg:navUrl obj="${menuResults[0]}" indexUrlVar="index0Url"/>
	<epg:img id="menu0" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu0','gamesTopFocus')" onblur="itemOnBlur('menu0');"  left="319" top="55" width="150" height="60" href="${index0Url}"/>
	<epg:text id="menu0" left="347" top="73" width="155" height="37" text="${menuResults[0].title}"
				  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${menuResults[1]}" indexUrlVar="index1Url"/>
	<epg:img id="menu1" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu1','gamesTopFocus')" onblur="itemOnBlur('menu1','#ffffff');" left="471" top="55" width="150" height="60" href="${index1Url}"/>
	<epg:text id="menu1" left="499" top="73" width="155" height="37" text="${menuResults[1].title}"
				  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${menuResults[2]}" indexUrlVar="index2Url"/>
	<epg:img id="menu2" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu2','gamesTopFocus')" onblur="itemOnBlur('menu2');" left="623" top="55" width="150" height="60" href="${index2Url}"/>
	<epg:text id="menu2" left="649" top="73" width="155" height="37" text="${menuResults[2].title}"
				  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${menuResults[3]}" indexUrlVar="index3Url"/>
	<epg:img id="menu3" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu3','gamesTopFocus')" onblur="itemOnBlur('menu3');" left="775" top="55" width="150" height="60" href="${index3Url}"/>
	<epg:text id="menu3" left="801" top="73" width="155" height="37" text="${menuResults[3].title}"
				  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${menuResults[4]}" indexUrlVar="index4Url"/>
	<epg:img id="menu4" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu4','gamesTopFocus')" onblur="itemOnBlur('menu4');" left="927" top="55" width="150" height="60" href="${index4Url}"/>
	<epg:text id="menu4" left="953" top="73" width="155" height="37" text="${menuResults[4].title}"
				  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>
	
	
	<epg:navUrl returnTo="biz" returnUrlVar="returnBizUrl"/>
	<epg:img id="menu5" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu5','gameBackFocus')" onblur="itemOnBlur('menu5');" left="1079" top="55" width="151" height="60" href="${returnBizUrl}"/>

<!-- 二级菜单 -->
	<epg:navUrl obj="${subMenuResults[0]}" indexUrlVar="index0Url"/>
	<epg:img id="subMenu0" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('subMenu0','gamesTopFocus')" onblur="itemOnBlur('subMenu0');" left="167" top="115" width="150" height="50" href="${index0Url}"/>
	<epg:text id="subMenu0" left="173" top="127" width="155" height="37" text="${subMenuResults[0].title}"
				  fontFamily="黑体" fontSize="22" color="#efefef" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${subMenuResults[1]}" indexUrlVar="index1Url"/>
	<epg:img id="subMenu1" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('subMenu1','gamesTopFocus')" onblur="itemOnBlur('subMenu1');" left="319" top="115" width="150" height="50" href="${index1Url}"/>
	<epg:text id="subMenu1" left="328" top="127" width="155" height="37" text="${subMenuResults[1].title}"
				  fontFamily="黑体" fontSize="22" color="#efefef" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${subMenuResults[2]}" indexUrlVar="index2Url"/>
	<epg:img id="subMenu2" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('subMenu2','gamesTopFocus')" onblur="itemOnBlur('subMenu2');" left="471" top="115" width="150" height="50" href="${index2Url}"/>
	<epg:text id="subMenu2" left="505" top="127" width="155" height="37" text="${subMenuResults[2].title}"
				  fontFamily="黑体" fontSize="22" color="#efefef" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${subMenuResults[3]}" indexUrlVar="index3Url"/>
	<epg:img id="subMenu3" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('subMenu3','gamesTopFocus')" onblur="itemOnBlur('subMenu3');" left="623" top="115" width="150" height="50" href="${index3Url}"/>
	<epg:text id="subMenu3" left="655" top="127" width="155" height="37" text="${subMenuResults[3].title}"
				  fontFamily="黑体" fontSize="22" color="#efefef" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${subMenuResults[4]}" indexUrlVar="index4Url"/>
	<epg:img id="subMenu4" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('subMenu4','gamesTopFocus')" onblur="itemOnBlur('subMenu4');" left="776" top="115" width="150" height="50" href="${index4Url}"/>
	<epg:text id="subMenu4" left="803" top="127" width="155" height="37" text="${subMenuResults[4].title}"
				  fontFamily="黑体" fontSize="22" color="#efefef" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${subMenuResults[5]}" indexUrlVar="index5Url"/>
	<epg:img id="subMenu5" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('subMenu5','gamesTopFocus')" onblur="itemOnBlur('subMenu5');" left="927" top="115" width="150" height="50" href="${index5Url}"/>
	<epg:text id="subMenu5" left="979" top="127" width="155" height="37" text="${subMenuResults[5].title}"
				  fontFamily="黑体" fontSize="22" color="#efefef" chineseCharNumber="9"/>

</epg:if>

<!-- 游戏八卦列表页 -->
<epg:if test="${templateParams['orderFlag'] == '2'}">

<!-- 顶部菜单  -->
	<epg:navUrl obj="${menuResults[0]}" indexUrlVar="index0Url"/>
	<epg:img id="menu0" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu0','gamesTopFocus')" onblur="itemOnBlur('menu0');"  left="319" top="55" width="150" height="60" href="${index0Url}"/>
	<epg:text id="menu0" left="347" top="73" width="155" height="37" text="${menuResults[0].title}"
				  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${menuResults[1]}" indexUrlVar="index1Url"/>
	<epg:img id="menu1" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu1','gamesTopFocus')" onblur="itemOnBlur('menu1');" left="471" top="55" width="150" height="60" href="${index1Url}"/>
	<epg:text id="menu1" left="499" top="73" width="155" height="37" text="${menuResults[1].title}"
				  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${menuResults[2]}" indexUrlVar="index2Url"/>
	<epg:img id="menu2" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu2','gamesTopFocus')" onblur="itemOnBlur('menu2','#ffffff');" left="623" top="55" width="150" height="60" href="${index2Url}"/>
	<epg:text id="menu2" left="649" top="73" width="155" height="37" text="${menuResults[2].title}"
				  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${menuResults[3]}" indexUrlVar="index3Url"/>
	<epg:img id="menu3" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu3','gamesTopFocus')" onblur="itemOnBlur('menu3');" left="775" top="55" width="150" height="60" href="${index3Url}"/>
	<epg:text id="menu3" left="801" top="73" width="155" height="37" text="${menuResults[3].title}"
				  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${menuResults[4]}" indexUrlVar="index4Url"/>
	<epg:img id="menu4" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu4','gamesTopFocus')" onblur="itemOnBlur('menu4');" left="927" top="55" width="150" height="60" href="${index4Url}"/>
	<epg:text id="menu4" left="953" top="73" width="155" height="37" text="${menuResults[4].title}"
				  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>

	<epg:navUrl returnTo="biz" returnUrlVar="returnBizUrl"/>
	<epg:img id="menu5" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu5','gameBackFocus')" onblur="itemOnBlur('menu5');" left="1079" top="55" width="151" height="60" href="${returnBizUrl}"/>

<!-- 二级菜单 -->
	<epg:navUrl obj="${subMenuResults[0]}" indexUrlVar="index0Url"/>
	<epg:img id="subMenu0" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('subMenu0','gamesTopFocus')" onblur="itemOnBlur('subMenu0');" left="623" top="115" width="150" height="50" href="${index0Url}"/>
	<epg:text id="subMenu0" left="649" top="127" width="155" height="37" text="${subMenuResults[0].title}"
				  fontFamily="黑体" fontSize="22" color="#efefef" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${subMenuResults[1]}" indexUrlVar="index1Url"/>
	<epg:img id="subMenu1" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('subMenu1','gamesTopFocus')" onblur="itemOnBlur('subMenu1');" left="776" top="115" width="150" height="50" href="${index1Url}"/>
	<epg:text id="subMenu1" left="803" top="127" width="155" height="37" text="${subMenuResults[1].title}"
				  fontFamily="黑体" fontSize="22" color="#efefef" chineseCharNumber="9"/>

</epg:if>

<!-- 休闲娱乐列表页 -->
<epg:if test="${templateParams['orderFlag'] == '3'}">

<!-- 顶部菜单  -->
	<epg:navUrl obj="${menuResults[0]}" indexUrlVar="index0Url"/>
	<epg:img id="menu0" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu0','gamesTopFocus')" onblur="itemOnBlur('menu0');"  left="319" top="55" width="150" height="60" href="${index0Url}"/>
	<epg:text id="menu0" left="347" top="73" width="155" height="37" text="${menuResults[0].title}"
				  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${menuResults[1]}" indexUrlVar="index1Url"/>
	<epg:img id="menu1" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu1','gamesTopFocus')" onblur="itemOnBlur('menu1');" left="471" top="55" width="150" height="60" href="${index1Url}"/>
	<epg:text id="menu1" left="499" top="73" width="155" height="37" text="${menuResults[1].title}"
				  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${menuResults[2]}" indexUrlVar="index2Url"/>
	<epg:img id="menu2" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu2','gamesTopFocus')" onblur="itemOnBlur('menu2');" left="623" top="55" width="150" height="60" href="${index2Url}"/>
	<epg:text id="menu2" left="649" top="73" width="155" height="37" text="${menuResults[2].title}"
				  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${menuResults[3]}" indexUrlVar="index3Url"/>
	<epg:img id="menu3" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu3','gamesTopFocus')" onblur="itemOnBlur('menu3','#ffffff');" left="775" top="55" width="150" height="60" href="${index3Url}"/>
	<epg:text id="menu3" left="801" top="73" width="155" height="37" text="${menuResults[3].title}"
				  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${menuResults[4]}" indexUrlVar="index4Url"/>
	<epg:img id="menu4" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu4','gamesTopFocus')" onblur="itemOnBlur('menu4');" left="927" top="55" width="150" height="60" href="${index4Url}"/>
	<epg:text id="menu4" left="953" top="73" width="155" height="37" text="${menuResults[4].title}"
				  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>

	<epg:navUrl returnTo="biz" returnUrlVar="returnBizUrl"/>
	<epg:img id="menu5" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu5','gameBackFocus')" onblur="itemOnBlur('menu5');" left="1079" top="55" width="151" height="60" href="${returnBizUrl}"/>

<!-- 二级菜单 -->
	<epg:navUrl obj="${subMenuResults[0]}" indexUrlVar="index0Url"/>
	<epg:img id="subMenu0" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('subMenu0','gamesTopFocus')" onblur="itemOnBlur('subMenu0');" left="623" top="115" width="150" height="50" href="${index0Url}"/>
	<epg:text id="subMenu0" left="653" top="127" width="155" height="37" text="${subMenuResults[0].title}"
				  fontFamily="黑体" fontSize="22" color="#efefef" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${subMenuResults[1]}" indexUrlVar="index1Url"/>
	<epg:img id="subMenu1" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('subMenu1','gamesTopFocus')" onblur="itemOnBlur('subMenu1');" left="776" top="115" width="150" height="50" href="${index1Url}"/>
	<epg:text id="subMenu1" left="805" top="127" width="155" height="37" text="${subMenuResults[1].title}"
				  fontFamily="黑体" fontSize="22" color="#efefef" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${subMenuResults[2]}" indexUrlVar="index2Url"/>
	<epg:img id="subMenu2" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('subMenu2','gamesTopFocus')" onblur="itemOnBlur('subMenu2');" left="927" top="115" width="150" height="50" href="${index2Url}"/>
	<epg:text id="subMenu2" left="957" top="127" width="155" height="37" text="${subMenuResults[2].title}"
				  fontFamily="黑体" fontSize="22" color="#efefef" chineseCharNumber="9"/>

</epg:if>

<!-- 特别呈现列表页 -->
<epg:if test="${templateParams['orderFlag'] == '4'}">

<!-- 顶部菜单  -->
	<epg:navUrl obj="${menuResults[0]}" indexUrlVar="index0Url"/>
	<epg:img id="menu0" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu0','gamesTopFocus')" onblur="itemOnBlur('menu0');"  left="319" top="55" width="150" height="60" href="${index0Url}"/>
	<epg:text id="menu0" left="347" top="73" width="155" height="37" text="${menuResults[0].title}"
				  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${menuResults[1]}" indexUrlVar="index1Url"/>
	<epg:img id="menu1" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu1','gamesTopFocus')" onblur="itemOnBlur('menu1');" left="471" top="55" width="150" height="60" href="${index1Url}"/>
	<epg:text id="menu1" left="499" top="73" width="155" height="37" text="${menuResults[1].title}"
				  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${menuResults[2]}" indexUrlVar="index2Url"/>
	<epg:img id="menu2" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu2','gamesTopFocus')" onblur="itemOnBlur('menu2');" left="623" top="55" width="150" height="60" href="${index2Url}"/>
	<epg:text id="menu2" left="649" top="73" width="155" height="37" text="${menuResults[2].title}"
				  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${menuResults[3]}" indexUrlVar="index3Url"/>
	<epg:img id="menu3" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu3','gamesTopFocus')" onblur="itemOnBlur('menu3');" left="775" top="55" width="150" height="60" href="${index3Url}"/>
	<epg:text id="menu3" left="801" top="73" width="155" height="37" text="${menuResults[3].title}"
				  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${menuResults[4]}" indexUrlVar="index4Url"/>
	<epg:img id="menu4" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu4','gamesTopFocus')" onblur="itemOnBlur('menu4','#ffffff');" left="927" top="55" width="150" height="60" href="${index4Url}"/>
	<epg:text id="menu4" left="953" top="73" width="155" height="37" text="${menuResults[4].title}"
				  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>

	<epg:navUrl returnTo="biz" returnUrlVar="returnBizUrl"/>
	<epg:img id="menu5" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu5','gameBackFocus')" onblur="itemOnBlur('menu5');" left="1079" top="55" width="151" height="60" href="${returnBizUrl}"/>

<!-- 二级菜单 -->
	<epg:navUrl obj="${subMenuResults[0]}" indexUrlVar="index0Url"/>
	<epg:img id="subMenu0" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('subMenu0','gamesTopFocus')" onblur="itemOnBlur('subMenu0');" left="776" top="115" width="150" height="50" href="${index0Url}"/>
	<epg:text id="subMenu0" left="803" top="127" width="155" height="37" text="${subMenuResults[0].title}"
				  fontFamily="黑体" fontSize="22" color="#efefef" chineseCharNumber="9"/>
	
	<epg:navUrl obj="${subMenuResults[1]}" indexUrlVar="index1Url"/>
	<epg:img id="subMenu1" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('subMenu1','gamesTopFocus')" onblur="itemOnBlur('subMenu1');" left="927" top="115" width="152" height="50" href="${index1Url}"/>
	<epg:text id="subMenu1" left="953" top="127" width="155" height="37" text="${subMenuResults[1].title}"
				  fontFamily="黑体" fontSize="22" color="#efefef" chineseCharNumber="9"/>

</epg:if>

<!-- 翻页相关 -->
<epg:text id="shouepage" left="387" top="190" width="131" height="45" color="#ffffff" align="center">${pageBean.pageIndex}/${pageBean.pageCount}页</epg:text>
<epg:img id='area_upPage' src="./images/games_pageUp.png" left="50" top="183" width="151" height="45" onfocus="itemOnFocus('area_upPage','games_pageUpFocus')" onblur="itemOnBlur('area_upPage');" href="javascript:pageUp();"/>
<epg:img id='area_downPage' src="./images/games_pageDown.png" left="204" top="183" width="151" height="45" onfocus="itemOnFocus('area_downPage','games_pageDownFocus')" onblur="itemOnBlur('area_downPage');" href="javascript:pageDown();"/>

<!-- 9条文字列表/最新资讯 -->
<epg:grid column="1" row="9" left="100" top="233" width="1000" height="399" vcellspacing="14" items="${categoryResults}" var="categoryResult" indexVar="curIdx" posVar="positions">
	<epg:if test="${categoryResult != null}">
		<epg:navUrl obj="${categoryResult}" indexUrlVar="indexUrl"/>
		<epg:img id='icon${curIdx}' src="./images/gamefy_icon.png" left="66" top="${positions[curIdx-1].y+12}" width="25" height="25"/>
		<epg:text id="catText${curIdx}" chineseCharNumber="35" left="100" width="1156" top="${positions[curIdx-1].y+12}" align="left" height="40" color="#606060" fontSize="26" >${categoryResult.title}</epg:text>
		<epg:img id="catText${curIdx}" src="./images/dot.gif" rememberFocus="true" left="60" top="${positions[curIdx-1].y+6}" onfocus="itemOnFocus('catText${curIdx}')" onblur="itemOnBlur('catText${curIdx}');" width="1155" height="40" href="${indexUrl}"/>
	</epg:if>
</epg:grid>

</epg:body>
</epg:html>