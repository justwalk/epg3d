<%@page contentType="text/html; charset=gbk" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>

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
		font-size:24px;
		font-family:黑体;	
		margin:0;
		padding:0;
	}
</style>

<script src="${context['EPG_CONTEXT']}/js/event.js"></script> 
<script>
//var path = "${context['EPG_CONTEXT']}<%=request.getAttribute("Path")%>";
//var imgPath = path.substring(0,path.indexOf("/index"))+"/images/";
var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images/";
function $(_id) {
	return "string" == typeof _id ? document.getElementById(_id) : _id;
}

function init(){
	//document.getElementById("newsText1_a").focus();
}


//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名，isChangeColor 是否改变文字列表颜色
function itemOnFocus(objId,img){
	if(objId.indexOf("menu")!=-1&&objId.indexOf("menu5")==-1){
		document.getElementById(objId+"_span").style.color = "#ffffff";
	}else if(objId.indexOf("newsText")!=-1||objId.indexOf("gameText")!=-1){
		document.getElementById(objId+"_span").style.color = "#f04a23";
	}
	if(img!=null&&img!=""){
		document.getElementById(objId+"_img").src=imgPath+img+".png";
	}
}
//失去焦点事件
function itemOnBlur(objId){
	if(objId.indexOf("menu")!=-1){
		if(objId.indexOf("menu5")==-1){
			document.getElementById(objId+"_span").style.color = "#606060";
		}
		document.getElementById(objId+"_img").src=imgPath+"dot.gif";
	}else if(objId.indexOf("subMenu")!=-1){
		document.getElementById(objId+"_img").src=imgPath+"dot.gif";
	}else if(objId.indexOf("newsText")!=-1||objId.indexOf("gameText")!=-1){
		document.getElementById(objId+"_span").style.color = "#606060";
	}else if(objId.indexOf("moreNews")!=-1){
		document.getElementById(objId+"_img").src=imgPath+"gamesNewMore.png";
	}else if(objId.indexOf("moreGames")!=-1){
		document.getElementById(objId+"_img").src=imgPath+"gameBackLook.png";
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
  function eventHandler(eventObj)
{
	switch(eventObj.code)
	{
		case "SITV_KEY_UP":
	    	break;
		case "SITV_KEY_DOWN":
	    	break;
		case "EIS_IRKEY_SELECT":
			break;
		case "SITV_KEY_LEFT":
	    	break;
		case "SITV_KEY_RIGHT":
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
</script>
<epg:body onload="init()" defaultBg="./images/gamesIndex.jpg" background="../${templateParams['bgImg']}"  bgcolor="#000000" width="1280" height="720" >
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
<epg:img id="menu4" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu4','gamesTopFocus')" onblur="itemOnBlur('menu4');" left="927" top="55" width="150" height="60" href="${index4Url}"/>
<epg:text id="menu4" left="953" top="73" width="155" height="37" text="${menuResults[4].title}"
			  fontFamily="黑体" fontSize="24" color="#606060" chineseCharNumber="9"/>

	<epg:img id="menu5" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('menu5','gameExitFocus')" onblur="itemOnBlur('menu5');" left="1079" top="55" width="151" height="60" href="${returnBizUrl}"/>

<!-- 二级菜单  -->
<!-- 返回视频点播 -->
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

<epg:navUrl obj="${subMenuResults[3]}" indexUrlVar="index3Url"/>
<epg:img id="subMenu3" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('subMenu3','gamesTopFocus')" onblur="itemOnBlur('subMenu3');" left="623" top="115" width="150" height="50" href="${index3Url}"/>
<epg:text id="subMenu3" left="649" top="127" width="155" height="37" text="${subMenuResults[3].title}"
			  fontFamily="黑体" fontSize="22" color="#efefef" chineseCharNumber="9"/>

<epg:navUrl obj="${subMenuResults[4]}" indexUrlVar="index4Url"/>
<epg:img id="subMenu4" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('subMenu4','gamesTopFocus')" onblur="itemOnBlur('subMenu4');" left="776" top="115" width="150" height="50" href="${index4Url}"/>
<epg:text id="subMenu4" left="803" top="127" width="155" height="37" text="${subMenuResults[4].title}"
			  fontFamily="黑体" fontSize="22" color="#efefef" chineseCharNumber="9"/>

<epg:navUrl obj="${subMenuResults[5]}" indexUrlVar="index5Url"/>
<epg:img id="subMenu5" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('subMenu5','gamesTopFocus')" onblur="itemOnBlur('subMenu5');" left="927" top="115" width="150" height="50" href="${index5Url}"/>
<epg:text id="subMenu5" left="953" top="127" width="155" height="37" text="${subMenuResults[5].title}"
			  fontFamily="黑体" fontSize="22" color="#efefef" chineseCharNumber="9"/>

<epg:navUrl obj="${subMenuResults[6]}" indexUrlVar="index6Url"/>
<epg:img id="subMenu6" rememberFocus="true" src="./images/dot.gif" onfocus="itemOnFocus('subMenu6','gamesTopFocus')" onblur="itemOnBlur('subMenu6');" left="1078" top="115" width="152" height="50" href="${index6Url}"/>
<epg:text id="subMenu6" left="1088" top="127" width="155" height="37" text="${subMenuResults[6].title}"
			  fontFamily="黑体" fontSize="22" color="#efefef" chineseCharNumber="9"/>

<!-- 更多最新资讯 -->
<epg:navUrl obj="${subMenuResults[0]}" indexUrlVar="indexUrl"/>
<epg:img id="moreNews" rememberFocus="true" src="./images/gamesNewMore.png" onfocus="itemOnFocus('moreNews','gamesNewMoreFocus')" onblur="itemOnBlur('moreNews');" left="50" top="185" width="736" height="50" href="${indexUrl}"/>

<!-- 4条文字列表/最新资讯 -->
<epg:grid column="1" row="4" left="204" top="243" width="712" height="182"  items="${newsRecommand}" var="newsResult" indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${newsResult}" indexUrlVar="indexUrl"/>
	<epg:text id="newsText${curIdx}" chineseCharNumber="20" left="107" align="left" top="${positions[curIdx-1].y}" height="40" color="#606060" fontSize="26" >${newsResult.title}</epg:text>
	<epg:img id="newsText${curIdx}" src="./images/dot.gif" left="62" top="${positions[curIdx-1].y-7}" onfocus="itemOnFocus('newsText${curIdx}')" onblur="itemOnBlur('newsText${curIdx}');" width="712" height="41" href="${indexUrl}"/>
</epg:grid>

<!-- 更多赛事回看 -->
<epg:navUrl obj="${subMenuResults[3]}" indexUrlVar="indexUrl"/>
<epg:img id="moreGames" rememberFocus="true" src="./images/gameBackLook.png" onfocus="itemOnFocus('moreGames','gameBackLookFocus')" onblur="itemOnBlur('moreGames');" left="50" top="432" width="736" height="50" href="${indexUrl}"/>


<!-- 4条文字列表/赛事回看 -->
<epg:grid column="1" row="4" left="204" top="490" width="712" height="182" items="${gamesRecommand}" var="gameResult" indexVar="curIdx" posVar="positions">
	<epg:navUrl obj="${gameResult}" indexUrlVar="indexUrl"/>
	<epg:text id="gameText${curIdx}" chineseCharNumber="20" left="107" align="left" top="${positions[curIdx-1].y}" height="40" color="#606060" fontSize="26">${gameResult.title}</epg:text>
	<epg:img id="gameText${curIdx}" src="./images/dot.gif" left="62" top="${positions[curIdx-1].y-7}" onfocus="itemOnFocus('gameText${curIdx}')" onblur="itemOnBlur('gameText${curIdx}');" width="712" height="41" href="${indexUrl}"/>
</epg:grid>

<!-- 右上推荐 图片-->
<epg:if test="${hotPicRecommand[0] != null}">
<epg:navUrl obj="${hotPicRecommand[0]}" indexUrlVar="indexUrl"/>
<epg:img id="hotPic0" rememberFocus="true" src="../${hotPicRecommand[0].itemIcon}" left="811" top="225" width="200" height="115" href="${indexUrl}"/>
</epg:if>

<epg:if test="${hotPicRecommand[1] != null}">
<epg:navUrl obj="${hotPicRecommand[1]}" indexUrlVar="indexUrl"/>
<epg:img id="hotPic1" rememberFocus="true" src="../${hotPicRecommand[1].itemIcon}" left="1018" top="225" width="200" height="115" href="${indexUrl}"/>
</epg:if>

<!-- 更多精彩专题 -->
<epg:navUrl obj="${menuResults[4]}" indexUrlVar="indexUrl"/>
<epg:img id="moreSubjects" rememberFocus="true" src="./images/dot.gif" left="811" top="362" width="406" height="33" href="${indexUrl}"/>

<!-- 右下推荐 图片-->
<epg:if test="${subjectPicResult != null}">
<epg:navUrl obj="${subjectPicResult}" indexUrlVar="indexUrl"/>
<epg:img id="subjectPic" rememberFocus="true" src="../${subjectPicResult.itemIcon}" left="814" top="402" width="400" height="225" href="${indexUrl}"/>
</epg:if>
</epg:body>
</epg:html>