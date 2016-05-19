<%@page contentType="text/html; charset=gbk" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@ page language="java" import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*" %>
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

<!--查询得到菜单的编排参数-->
<epg:query queryName="getSeverialItems" maxRows="6" var="menuResults" >
	<epg:param name="categoryCode" value="${templateParams['menuCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!--查询得到二级菜单栏目的编排参数-->
<epg:query queryName="getSeverialItems" maxRows="7" var="subMenuResults" >
	<epg:param name="categoryCode" value="${templateParams['subMenuCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!--左上方最新资讯即每日邮报栏目内容 -->
<epg:query queryName="getSeverialItems" maxRows="4" var="newsRecommand" >
	<epg:param name="categoryCode" value="${templateParams['newsCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!--左下方赛事回看栏目内容-->
<epg:query queryName="getSeverialItems" maxRows="4" var="gamesRecommand" >
	<epg:param name="categoryCode" value="${templateParams['gamesCategoryCode']}" type="java.lang.String"/>
</epg:query>

<!--右上方图片推荐-->
<epg:query queryName="getSeverialItems" maxRows="2" var="hotPicRecommand" >
	<epg:param name="categoryCode" value="${templateParams['hotPicRecommand']}" type="java.lang.String"/>
</epg:query>

<!--右下方图片推荐-->
<epg:query queryName="getSeverialItems" maxRows="1" var="subjectPicResult" >
	<epg:param name="categoryCode" value="${templateParams['subjectPicRecommand']}" type="java.lang.String"/>
</epg:query>
<epg:navUrl returnTo="home" returnUrlVar="returnBizUrl"/>
<style>
	img{	
		border:0px;
	}
	a{ 
	display:block;	
	}
	body{
		color:#FFFFFF;
		font-size:12px;
		font-family:黑体;	
		margin:0;
		padding:0;
	}
</style>

<script src="${context['EPG_CONTEXT']}/js/event.js"></script> 
<script>
var pageLoad = false;
var fristFocus = 0;

if (typeof(iPanel) == 'undefined') {
	pageLoad  = true;
}
//var path = "${context['EPG_CONTEXT']}<%=request.getAttribute("Path")%>";
//var imgPath = path.substring(0,path.indexOf("/index"))+"/images/";
var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images/";
function $(_id) {
	return "string" == typeof _id ? document.getElementById(_id) : _id;
}

function init(){
	var leaveFocusId = "${leaveFocusId}";
	if(leaveFocusId!="" && document.getElementById(leaveFocusId+"_a")){
		document.getElementById(leaveFocusId+"_a").focus();
		fristFocus++;
	}else{
		document.getElementById("newsText1_a").focus();
		fristFocus++;
	}
}


//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名，isChangeColor 是否改变文字列表颜色
function itemOnFocus(objId,img){
	if (pageLoad) {
		fristFocus++;
		if (objId.indexOf("menu") != -1 && objId.indexOf("menu5") == -1) {
			document.getElementById(objId + "_span").style.color = "#ffffff";
			document.getElementById("r_"+objId + "_span").style.color = "#ffffff";
		}
		else 
			if (objId.indexOf("newsText") != -1 || objId.indexOf("gameText") != -1) {
				document.getElementById(objId + "_span").style.color = "#f04a23";
				document.getElementById("r_"+objId + "_span").style.color = "#f04a23";
			}
		if (img != null && img != "") {
			document.getElementById(objId + "_img").src = imgPath + img + ".png";
			document.getElementById("r_"+objId + "_img").src = imgPath + img + ".png";
		}
	}
}
//失去焦点事件
function itemOnBlur(objId){
	if (pageLoad) {
		if (objId.indexOf("menu") != -1) {
			if (objId.indexOf("menu5") == -1) {
				document.getElementById(objId + "_span").style.color = "#606060";
				document.getElementById("r_"+objId + "_span").style.color = "#606060";
			}
			document.getElementById(objId + "_img").src = imgPath + "dot.gif";
			document.getElementById("r_"+objId + "_img").src = imgPath + "dot.gif";
		}
		else 
			if (objId.indexOf("subMenu") != -1) {
				document.getElementById(objId + "_img").src = imgPath + "dot.gif";
				document.getElementById("r_"+objId + "_img").src = imgPath + "dot.gif";
			}
			else 
				if (objId.indexOf("newsText") != -1 || objId.indexOf("gameText") != -1) {
					document.getElementById(objId + "_span").style.color = "#606060";
					document.getElementById("r_"+objId + "_span").style.color = "#606060";
				}
				else 
					if (objId.indexOf("moreNews") != -1) {
						document.getElementById(objId + "_img").src = imgPath + "gamesNewMore.png";
						document.getElementById("r_"+objId + "_img").src = imgPath + "gamesNewMore.png";
					}
					else 
						if (objId.indexOf("moreGames") != -1) {
							document.getElementById(objId + "_img").src = imgPath + "gameBackLook.png";
							document.getElementById("r_"+objId + "_img").src = imgPath + "gameBackLook.png";
						}
	}
}

function back(){
 	document.location.href = "${returnBizUrl}";
}
function exit(){
	back();
}

if(typeof(iPanel)!='undefined'){
	iPanel.focus.display = 1;
	iPanel.focus.border = 1;
	iPanel.focus.defaultFocusColor = "#f04a23";
}
function eventHandler(eventObj){
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
			window.location.href = "${context['EPG_CONTEXT']}/common/logout/logout.jsp";
			return 0;
			break;
		default:
			return 1;
			break;
	}
}
</script>
<epg:body onload="init()" bgcolor="#000000">
<div id="leftDiv">
<!-- 背景图片以及头部图片 -->
	<epg:img src="../${templateParams['bgImg']}" width="640" height="720" left="0" />
<!-- 顶部菜单  -->
<epg:navUrl obj="${menuResults[0]}" indexUrlVar="index0Url"/>
<epg:img id="menu0" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu0','gamesTopFocus')" onblur="itemOnBlur('menu0');"  left="160" top="55" width="75" height="60" href="${index0Url}"/>
<epg:text id="menu0" left="173" top="73" width="77" height="37" text="${menuResults[0].title}"
			  fontFamily="黑体" fontSize="14" color="#606060" chineseCharNumber="9"/>

<epg:navUrl obj="${menuResults[1]}" indexUrlVar="index1Url"/>
<epg:img id="menu1" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu1','gamesTopFocus')" onblur="itemOnBlur('menu1');" left="235" top="55" width="75" height="60" href="${index1Url}"/>
<epg:text id="menu1" left="250" top="73" width="77" height="37" text="${menuResults[1].title}"
			  fontFamily="黑体" fontSize="14" color="#606060" chineseCharNumber="9"/>

<epg:navUrl obj="${menuResults[2]}" indexUrlVar="index2Url"/>
<epg:img id="menu2" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu2','gamesTopFocus')" onblur="itemOnBlur('menu2');" left="311" top="55" width="75" height="60" href="${index2Url}"/>
<epg:text id="menu2" left="325" top="73" width="77" height="37" text="${menuResults[2].title}"
			  fontFamily="黑体" fontSize="14" color="#606060" chineseCharNumber="9"/>

<epg:navUrl obj="${menuResults[3]}" indexUrlVar="index3Url"/>
<epg:img id="menu3" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu3','gamesTopFocus')" onblur="itemOnBlur('menu3');" left="387" top="55" width="75" height="60" href="${index3Url}"/>
<epg:text id="menu3" left="400" top="73" width="77" height="37" text="${menuResults[3].title}"
			  fontFamily="黑体" fontSize="14" color="#606060" chineseCharNumber="9"/>

<epg:navUrl obj="${menuResults[4]}" indexUrlVar="index4Url"/>
<epg:img id="menu4" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu4','gamesTopFocus')" onblur="itemOnBlur('menu4');" left="463" top="55" width="75" height="60" href="${index4Url}"/>
<epg:text id="menu4" left="476" top="73" width="77" height="37" text="${menuResults[4].title}"
			  fontFamily="黑体" fontSize="14" color="#606060" chineseCharNumber="9"/>

	<epg:img id="menu5" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu5','gameExitFocus')" onblur="itemOnBlur('menu5');" left="540" top="55" width="75" height="60" href="${returnBizUrl}"/>

<!-- 二级菜单  -->
<!-- 返回视频点播 -->
<epg:navUrl obj="${subMenuResults[0]}" indexUrlVar="index0Url"/>
<epg:img id="subMenu0" src="./images/dot.gif" onfocus="itemOnFocus('subMenu0','gamesTopFocus')" onblur="itemOnBlur('subMenu0');" left="83" top="115" width="75" height="50" href="${index0Url}&leaveFocusId=subMenu0"/>
<epg:text id="subMenu0" left="96" top="127" width="77" height="37" text="${subMenuResults[0].title}"
			  fontFamily="黑体" fontSize="12" color="#efefef" chineseCharNumber="9"/>

<epg:navUrl obj="${subMenuResults[1]}" indexUrlVar="index1Url"/>
<epg:img id="subMenu1" src="./images/dot.gif" onfocus="itemOnFocus('subMenu1','gamesTopFocus')" onblur="itemOnBlur('subMenu1');" left="160" top="115" width="75" height="50" href="${index1Url}&leaveFocusId=subMenu2"/>
<epg:text id="subMenu1" left="181" top="127" width="77" height="37" text="${subMenuResults[1].title}"
			  fontFamily="黑体" fontSize="12" color="#efefef" chineseCharNumber="9"/>

<epg:navUrl obj="${subMenuResults[2]}" indexUrlVar="index2Url"/>
<epg:img id="subMenu2" src="./images/dot.gif" onfocus="itemOnFocus('subMenu2','gamesTopFocus')" onblur="itemOnBlur('subMenu2');" left="235" top="115" width="75" height="50" href="${index2Url}&leaveFocusId=subMenu1"/>
<epg:text id="subMenu2" left="254" top="127" width="77" height="37" text="${subMenuResults[2].title}"
			  fontFamily="黑体" fontSize="12" color="#efefef" chineseCharNumber="9"/>

<epg:navUrl obj="${subMenuResults[3]}" indexUrlVar="index3Url"/>
<epg:img id="subMenu3"  src="./images/dot.gif" onfocus="itemOnFocus('subMenu3','gamesTopFocus')" onblur="itemOnBlur('subMenu3');" left="312" top="115" width="75" height="50" href="${index3Url}&leaveFocusId=subMenu0"/>
<epg:text id="subMenu3" left="325" top="127" width="77" height="37" text="${subMenuResults[3].title}"
			  fontFamily="黑体" fontSize="12" color="#efefef" chineseCharNumber="9"/>

<epg:navUrl obj="${subMenuResults[4]}" indexUrlVar="index4Url"/>
<epg:img id="subMenu4" src="./images/dot.gif" onfocus="itemOnFocus('subMenu4','gamesTopFocus')" onblur="itemOnBlur('subMenu4');" left="388" top="115" width="75" height="50" href="${index4Url}&leaveFocusId=subMenu0"/>
<epg:text id="subMenu4" left="410" top="127" width="77" height="37" text="${subMenuResults[4].title}"
			  fontFamily="黑体" fontSize="12" color="#efefef" chineseCharNumber="9"/>

<epg:navUrl obj="${subMenuResults[5]}" indexUrlVar="index5Url"/>
<epg:img id="subMenu5" src="./images/dot.gif" onfocus="itemOnFocus('subMenu5','gamesTopFocus')" onblur="itemOnBlur('subMenu5');" left="463" top="115" width="75" height="50" href="${index5Url}&leaveFocusId=subMenu1"/>
<epg:text id="subMenu5" left="476" top="127" width="77" height="37" text="${subMenuResults[5].title}"
			  fontFamily="黑体" fontSize="12" color="#efefef" chineseCharNumber="9"/>

<epg:navUrl obj="${subMenuResults[6]}" indexUrlVar="index6Url"/>
<epg:img id="subMenu6"  src="./images/dot.gif" onfocus="itemOnFocus('subMenu6','gamesTopFocus')" onblur="itemOnBlur('subMenu6');" left="539" top="115" width="76" height="50" href="${index6Url}&leaveFocusId=subMenu1"/>
<epg:text id="subMenu6" left="544" top="127" width="77" height="37" text="${subMenuResults[6].title}"
			  fontFamily="黑体" fontSize="12" color="#efefef" chineseCharNumber="9"/>

<!-- 更多最新资讯 -->
<epg:navUrl obj="${subMenuResults[0]}" indexUrlVar="indexUrl"/>
<epg:img id="moreNews" src="./images/gamesNewMore.png" onfocus="itemOnFocus('moreNews','gamesNewMoreFocus')" onblur="itemOnBlur('moreNews');" left="25" top="185" width="184" height="50" href="${indexUrl}&leaveFocusId=subMenu0"/>

<!-- 4条文字列表/最新资讯 -->
<epg:grid column="1" row="4" left="102" top="243" width="356" height="182"  items="${newsRecommand}" var="newsResult" indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${newsResult}" indexUrlVar="indexUrl"/>
	<epg:text id="newsText${curIdx}" chineseCharNumber="20" left="54" align="left" top="${positions[curIdx-1].y}" height="40" color="#606060" fontSize="16" >${newsResult.title}</epg:text>
	<epg:img id="newsText${curIdx}" src="./images/dot.gif" rememberFocus="true" left="31" top="${positions[curIdx-1].y-7}" onfocus="itemOnFocus('newsText${curIdx}')" onblur="itemOnBlur('newsText${curIdx}');" width="356" height="41" href="${indexUrl}"/>
</epg:grid>

<!-- 更多赛事回看 -->
<epg:navUrl obj="${subMenuResults[3]}" indexUrlVar="indexUrl"/>
<epg:img id="moreGames" src="./images/gameBackLook.png" onfocus="itemOnFocus('moreGames','gameBackLookFocus')" onblur="itemOnBlur('moreGames');" left="25" top="432" width="184" height="50" href="${indexUrl}&leaveFocusId=subMenu0"/>


<!-- 4条文字列表/赛事回看 -->
<epg:grid column="1" row="4" left="102" top="490" width="356" height="182" items="${gamesRecommand}" var="gameResult" indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${gameResult}" indexUrlVar="indexUrl"/>
	<epg:text id="gameText${curIdx}" chineseCharNumber="20" left="53" align="left" top="${positions[curIdx-1].y}" height="40" color="#606060" fontSize="16">${gameResult.title}</epg:text>
	<epg:img id="gameText${curIdx}" src="./images/dot.gif" rememberFocus="true" left="31" top="${positions[curIdx-1].y-7}" onfocus="itemOnFocus('gameText${curIdx}')" onblur="itemOnBlur('gameText${curIdx}');" width="356" height="41" href="${indexUrl}"/>
</epg:grid>

<!-- 右上推荐 图片-->
<epg:if test="${hotPicRecommand[0] != null}">
<epg:navUrl obj="${hotPicRecommand[0]}" indexUrlVar="indexUrl"/>
<epg:img id="hotPic0" rememberFocus="true" src="../${hotPicRecommand[0].itemIcon}" left="405" top="225" width="100" height="115" href="${indexUrl}"/>
</epg:if>

<epg:if test="${hotPicRecommand[1] != null}">
<epg:navUrl obj="${hotPicRecommand[1]}" indexUrlVar="indexUrl"/>
<epg:img id="hotPic1" rememberFocus="true" src="../${hotPicRecommand[1].itemIcon}" left="509" top="225" width="100" height="115" href="${indexUrl}"/>
</epg:if>

<!-- 更多精彩专题 -->
<epg:navUrl obj="${menuResults[4]}" indexUrlVar="indexUrl"/>
<epg:img id="moreSubjects" src="./images/dot.gif" left="405" top="362" width="203" height="33" href="${indexUrl}&leaveFocusId=subMenu0"/>

<!-- 右下推荐 图片-->
<epg:if test="${subjectPicResult != null}">
<epg:navUrl obj="${subjectPicResult}" indexUrlVar="indexUrl"/>
<epg:img id="subjectPic" rememberFocus="true" src="../${subjectPicResult.itemIcon}" left="407" top="402" width="200" height="225" href="${indexUrl}"/>
</epg:if>
</div>

<div id="rightDiv">
<!-- 背景图片以及头部图片 -->
	<epg:img src="../${templateParams['bgImg']}" width="640" height="720" left="640" />
<!-- 顶部菜单  -->
<epg:navUrl obj="${menuResults[0]}" indexUrlVar="index0Url"/>
<epg:img id="r_menu0" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu0','gamesTopFocus')" onblur="itemOnBlur('menu0');"  left="800" top="55" width="75" height="60" href="${index0Url}"/>
<epg:text id="r_menu0" left="813" top="73" width="77" height="37" text="${menuResults[0].title}"
			  fontFamily="黑体" fontSize="14" color="#606060" chineseCharNumber="9"/>

<epg:navUrl obj="${menuResults[1]}" indexUrlVar="index1Url"/>
<epg:img id="r_menu1" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu1','gamesTopFocus')" onblur="itemOnBlur('menu1');" left="875" top="55" width="75" height="60" href="${index1Url}"/>
<epg:text id="r_menu1" left="890" top="73" width="77" height="37" text="${menuResults[1].title}"
			  fontFamily="黑体" fontSize="14" color="#606060" chineseCharNumber="9"/>

<epg:navUrl obj="${menuResults[2]}" indexUrlVar="index2Url"/>
<epg:img id="r_menu2" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu2','gamesTopFocus')" onblur="itemOnBlur('menu2');" left="951" top="55" width="75" height="60" href="${index2Url}"/>
<epg:text id="r_menu2" left="965" top="73" width="77" height="37" text="${menuResults[2].title}"
			  fontFamily="黑体" fontSize="14" color="#606060" chineseCharNumber="9"/>

<epg:navUrl obj="${menuResults[3]}" indexUrlVar="index3Url"/>
<epg:img id="r_menu3" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu3','gamesTopFocus')" onblur="itemOnBlur('menu3');" left="1027" top="55" width="75" height="60" href="${index3Url}"/>
<epg:text id="r_menu3" left="1040" top="73" width="77" height="37" text="${menuResults[3].title}"
			  fontFamily="黑体" fontSize="14" color="#606060" chineseCharNumber="9"/>

<epg:navUrl obj="${menuResults[4]}" indexUrlVar="index4Url"/>
<epg:img id="r_menu4" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu4','gamesTopFocus')" onblur="itemOnBlur('menu4');" left="1103" top="55" width="75" height="60" href="${index4Url}"/>
<epg:text id="r_menu4" left="1116" top="73" width="77" height="37" text="${menuResults[4].title}"
			  fontFamily="黑体" fontSize="14" color="#606060" chineseCharNumber="9"/>

<epg:img id="r_menu5" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu5','gameExitFocus')" onblur="itemOnBlur('menu5');" left="1200" top="55" width="75" height="60" href="${returnBizUrl}"/>

<!-- 二级菜单  -->
<!-- 返回视频点播 -->
<epg:navUrl obj="${subMenuResults[0]}" indexUrlVar="index0Url"/>
<epg:img id="r_subMenu0" src="./images/dot.gif" onfocus="itemOnFocus('subMenu0','gamesTopFocus')" onblur="itemOnBlur('subMenu0');" left="723" top="115" width="75" height="50" href="${index0Url}&leaveFocusId=subMenu0"/>
<epg:text id="r_subMenu0" left="736" top="127" width="77" height="37" text="${subMenuResults[0].title}"
			  fontFamily="黑体" fontSize="12" color="#efefef" chineseCharNumber="9"/>

<epg:navUrl obj="${subMenuResults[1]}" indexUrlVar="index1Url"/>
<epg:img id="r_subMenu1" src="./images/dot.gif" onfocus="itemOnFocus('subMenu1','gamesTopFocus')" onblur="itemOnBlur('subMenu1');" left="800" top="115" width="75" height="50" href="${index1Url}&leaveFocusId=subMenu2"/>
<epg:text id="r_subMenu1" left="821" top="127" width="77" height="37" text="${subMenuResults[1].title}"
			  fontFamily="黑体" fontSize="12" color="#efefef" chineseCharNumber="9"/>

<epg:navUrl obj="${subMenuResults[2]}" indexUrlVar="index2Url"/>
<epg:img id="r_subMenu2" src="./images/dot.gif" onfocus="itemOnFocus('subMenu2','gamesTopFocus')" onblur="itemOnBlur('subMenu2');" left="875" top="115" width="75" height="50" href="${index2Url}&leaveFocusId=subMenu1"/>
<epg:text id="r_subMenu2" left="894" top="127" width="77" height="37" text="${subMenuResults[2].title}"
			  fontFamily="黑体" fontSize="12" color="#efefef" chineseCharNumber="9"/>

<epg:navUrl obj="${subMenuResults[3]}" indexUrlVar="index3Url"/>
<epg:img id="r_subMenu3"  src="./images/dot.gif" onfocus="itemOnFocus('subMenu3','gamesTopFocus')" onblur="itemOnBlur('subMenu3');" left="952" top="115" width="75" height="50" href="${index3Url}&leaveFocusId=subMenu0"/>
<epg:text id="r_subMenu3" left="965" top="127" width="77" height="37" text="${subMenuResults[3].title}"
			  fontFamily="黑体" fontSize="12" color="#efefef" chineseCharNumber="9"/>

<epg:navUrl obj="${subMenuResults[4]}" indexUrlVar="index4Url"/>
<epg:img id="r_subMenu4" src="./images/dot.gif" onfocus="itemOnFocus('subMenu4','gamesTopFocus')" onblur="itemOnBlur('subMenu4');" left="1028" top="115" width="75" height="50" href="${index4Url}&leaveFocusId=subMenu0"/>
<epg:text id="r_subMenu4" left="1050" top="127" width="77" height="37" text="${subMenuResults[4].title}"
			  fontFamily="黑体" fontSize="12" color="#efefef" chineseCharNumber="9"/>

<epg:navUrl obj="${subMenuResults[5]}" indexUrlVar="index5Url"/>
<epg:img id="r_subMenu5" src="./images/dot.gif" onfocus="itemOnFocus('subMenu5','gamesTopFocus')" onblur="itemOnBlur('subMenu5');" left="1103" top="115" width="75" height="50" href="${index5Url}&leaveFocusId=subMenu1"/>
<epg:text id="r_subMenu5" left="1116" top="127" width="77" height="37" text="${subMenuResults[5].title}"
			  fontFamily="黑体" fontSize="12" color="#efefef" chineseCharNumber="9"/>

<epg:navUrl obj="${subMenuResults[6]}" indexUrlVar="index6Url"/>
<epg:img id="r_subMenu6"  src="./images/dot.gif" onfocus="itemOnFocus('subMenu6','gamesTopFocus')" onblur="itemOnBlur('subMenu6');" left="1179" top="115" width="76" height="50" href="${index6Url}&leaveFocusId=subMenu1"/>
<epg:text id="r_subMenu6" left="1184" top="127" width="77" height="37" text="${subMenuResults[6].title}"
			  fontFamily="黑体" fontSize="12" color="#efefef" chineseCharNumber="9"/>

<!-- 更多最新资讯 -->
<epg:navUrl obj="${subMenuResults[0]}" indexUrlVar="indexUrl"/>
<epg:img id="r_moreNews" src="./images/gamesNewMore.png" onfocus="itemOnFocus('moreNews','gamesNewMoreFocus')" onblur="itemOnBlur('moreNews');" left="665" top="185" width="184" height="50" href="${indexUrl}&leaveFocusId=subMenu0"/>

<!-- 4条文字列表/最新资讯 -->
<epg:grid column="1" row="4" left="742" top="243" width="356" height="182"  items="${newsRecommand}" var="newsResult" indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${newsResult}" indexUrlVar="indexUrl"/>
	<epg:text id="r_newsText${curIdx}" chineseCharNumber="20" left="694" align="left" top="${positions[curIdx-1].y}" height="40" color="#606060" fontSize="16" >${newsResult.title}</epg:text>
	<epg:img id="r_newsText${curIdx}" src="./images/dot.gif" rememberFocus="true" left="671" top="${positions[curIdx-1].y-7}" onfocus="itemOnFocus('newsText${curIdx}')" onblur="itemOnBlur('newsText${curIdx}');" width="356" height="41" href="${indexUrl}"/>
</epg:grid>

<!-- 更多赛事回看 -->
<epg:navUrl obj="${subMenuResults[3]}" indexUrlVar="indexUrl"/>
<epg:img id="r_moreGames" src="./images/gameBackLook.png" onfocus="itemOnFocus('moreGames','gameBackLookFocus')" onblur="itemOnBlur('moreGames');" left="665" top="432" width="184" height="50" href="${indexUrl}&leaveFocusId=subMenu0"/>


<!-- 4条文字列表/赛事回看 -->
<epg:grid column="1" row="4" left="742" top="490" width="356" height="182" items="${gamesRecommand}" var="gameResult" indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${gameResult}" indexUrlVar="indexUrl"/>
	<epg:text id="r_gameText${curIdx}" chineseCharNumber="20" left="693" align="left" top="${positions[curIdx-1].y}" height="40" color="#606060" fontSize="16">${gameResult.title}</epg:text>
	<epg:img id="r_gameText${curIdx}" src="./images/dot.gif" rememberFocus="true" left="671" top="${positions[curIdx-1].y-7}" onfocus="itemOnFocus('gameText${curIdx}')" onblur="itemOnBlur('gameText${curIdx}');" width="356" height="41" href="${indexUrl}"/>
</epg:grid>

<!-- 右上推荐 图片-->
<epg:if test="${hotPicRecommand[0] != null}">
<epg:navUrl obj="${hotPicRecommand[0]}" indexUrlVar="indexUrl"/>
<epg:img id="r_hotPic0" rememberFocus="true" src="../${hotPicRecommand[0].itemIcon}" left="1055" top="225" width="100" height="115" href="${indexUrl}"/>
</epg:if>

<epg:if test="${hotPicRecommand[1] != null}">
<epg:navUrl obj="${hotPicRecommand[1]}" indexUrlVar="indexUrl"/>
<epg:img id="r_hotPic1" rememberFocus="true" src="../${hotPicRecommand[1].itemIcon}" left="1159" top="225" width="100" height="115" href="${indexUrl}"/>
</epg:if>

<!-- 更多精彩专题 -->
<epg:navUrl obj="${menuResults[4]}" indexUrlVar="indexUrl"/>
<epg:img id="r_moreSubjects" src="./images/dot.gif" left="1045" top="362" width="203" height="33" href="${indexUrl}&leaveFocusId=subMenu0"/>

<!-- 右下推荐 图片-->
<epg:if test="${subjectPicResult != null}">
<epg:navUrl obj="${subjectPicResult}" indexUrlVar="indexUrl"/>
<epg:img id="r_subjectPic" rememberFocus="true" src="../${subjectPicResult.itemIcon}" left="1057" top="402" width="200" height="225" href="${indexUrl}"/>
</epg:if>
</div>
</epg:body>
</epg:html>