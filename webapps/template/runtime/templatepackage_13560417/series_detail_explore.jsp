<%@page contentType="text/html; charset=GBK" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*"%>
<%
	String leaveFocusId = request.getParameter("leaveFocusId");
	if(leaveFocusId!=null&&leaveFocusId!=""){
		
		EpgUserSession eus = EpgUserSession.findUserSession(request);
		eus.setPlayFocusId(leaveFocusId);
		request.setAttribute("leaveFocusId",eus.getPlayFocusId()) ;
	}
%>
<html>
<epg:set var="imgPath"
		 value="${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images/"/>
<epg:set value="./images/dot.gif" var="dot"/>
<epg:set value="dot.gif" var="dotStr"/>
<epg:set value="#1978b8" var="defColor"/>
<epg:set value="#FFFFFF" var="WhiteColor"/>
<epg:set value="#333333" var="BlackColor"/>
<epg:set value="2" var="bodyType"/><%-- 内容 类型   1、正片   2、预告片  3、片花 --%>

<!-- 查询剧集内容信息 -->
<epg:query queryName="querySeriesByCode" var="series">
	<epg:param name="contentCode" value="${context['EPG_CONTENT_CODE']}" type="java.lang.String" />
</epg:query>
<!-- 查询剧集集数信息 -->
<epg:query queryName="queryEpisodeByCode" maxRows="999" var="episodeAll">
	<epg:param name="seriesCode" value="${context['EPG_CONTENT_CODE']}" type="java.lang.String" />
</epg:query>
<epg:query queryName="queryEpisodeByCode" maxRows="15" var="episodes"
		   pageBeanVar="pageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true">
	<epg:param name="seriesCode" value="${context['EPG_CONTENT_CODE']}" type="java.lang.String" />
</epg:query>
<!-- 查询用户观看历史 -->
<epg:query queryName="userCouldMarkSeries" var="userHistory">
	<epg:param name="USER_ID" value="${EPG_USER.userAccount}" type="java.lang.String" />
	<epg:param name="CONTENT_CODE" value="${context['EPG_CONTENT_CODE']}" type="java.lang.String" />
</epg:query>
<epg:set value="1" var="hisPlayNum"/>
<epg:if test="${!empty userHistory}"><epg:set value="${userHistory.episodeIndex}" var="hisPlayNum"/></epg:if>

<!-- get tag, hdType(1 高清) -->
<epg:set var="tags" value="${fn:split(series.tags, ',')}"/>
<epg:set var="tag" value="${tags[0]}"/>
<epg:if test="${tag=='高清'}"><epg:set var="tag" value="${tags[1]}"/></epg:if>
<epg:set var="hdType" value="1"></epg:set>
<epg:if test="${series.hdType == 0}"><epg:set var="hdType" value="0"/></epg:if>

<!-- 猜你喜欢第一个取推荐栏目 -->
<epg:query queryName="getSeverialItemsIncludePic" maxRows="1" var="firstGuess" >
	<epg:param name="categoryCode" value="${templateParams['guessCategoryCode']}" type="java.lang.String"/>
</epg:query>
<epg:navUrl obj="${firstGuess}" indexUrlVar="firstGuessUrl"/>
<epg:resource src="../${firstGuess.still}" realSrcVar="firstGuessImg"/>

<!--猜你喜欢  -->
<epg:set var="tags" value="${fn:split(series.tags, ',')}"></epg:set>
<epg:set var="tag" value="${tags[0]}"></epg:set>
<epg:if test="${tag=='高清'}">
	<epg:set var="tag" value="${tags[1]}"></epg:set>
</epg:if>

<epg:query queryName="getSeverialItemsByTagsRandomIncludePic" maxRows="4" var="bottomCategoryItems">
	<epg:param name="tags" value="${tag}" type="java.lang.String"/>
	<epg:param name="selfCode" value="${series.contentCode}" type="java.lang.String"/>
	<epg:param name="mainFolder" value="${series.mainFolder}" type="java.lang.String"/>
</epg:query>
<!-- 精彩预告 -->
<epg:query queryName="queryRelContentByRelCodeAndBodyType" maxRows="1" var="relContent" >
	<epg:param name="relCode" value="${series.relCode}" type="java.lang.String"/>
	<epg:param name="bodyType" value="${bodyType}" type="java.lang.Integer"/>
</epg:query>

<epg:navUrl returnTo="home" returnUrlVar="returnUrl"/>

<style type="text/css">
div{position: absolute;}
body{
		font-size:22px;
		font-family:"黑体";
	}
</style>
<script src="${context['EPG_CONTEXT']}/js/ajax.js"></script>
<script>
var offset = 1;
var hdStr = "HD_";
var title = "";
var len = 0;
var limitLen = 10;

var playUrl = "";
var episodes = [
	<epg:forEach items="${episodeAll}" var="episode" varStatus="idx">
		<epg:navUrl obj="${episode}" playUrlVar="playUrl"/>
		{"playUrl":"${playUrl}","episodeNum":"${episode.episodeIndex}"}<epg:if test="${!idx.last}">,</epg:if>
	</epg:forEach>
];

// collection
var collectAjax = null;
var contentTitle = encodeURIComponent("${series.title}");
var contentStill = encodeURIComponent("${series.still}");
var collectionReqUrl = "${context['EPG_CONTEXT']}/addMyCollection.do?userMac=${EPG_USER.userAccount}&contentType=series" +
			   "&contentCode=${series.contentCode}&contentName=" + contentTitle + "&still=" + contentStill + 
			   "&bizCode=${context['EPG_BUSINESS_CODE']}&categoryCode=${context['EPG_CATEGORY_CODE']}&hdType=${hdType}";


var isDebug = true;
function msg(str, needShow){
	if(isDebug && needShow == 1) alert(str);
}

function $(_id) {
	return "string" == typeof _id ? document.getElementById(_id) : _id;
}
var imgPath = "${imgPath}";
// 高亮处理-----------------------------------------------
function itemOnFocus(objId, img, txtId, color){
	$(objId + "_img").src = "${imgPath}" + img;
	if((typeof txtId) != 'undefined'){
		$(txtId + "_span").style.color = color;
	}
}

function itemOnBlur(objId, img, txtId, color){
	$(objId + "_img").src= "${imgPath}" + img;
	if((typeof txtId) != 'undefined'){
		$(txtId + "_span").style.color = color;
	}
}


function getLen(s) {
	var l = 0;
	var a = s.split("");
	for (var i = 0; i < a.length; i++) {
		if (a[i].charCodeAt(0) < 299) {
			l++;
		} else {
			l += 2;
		}
	}
	return l;
}

// 播放历史记录-----------------------------------------------
function playHistory(epiNum){
	var episodeNum = parseInt(epiNum);
	var idx = 0;
	for(var i = 0; i < episodes.length;i++){
		if(episodes[i].episodeNum == episodeNum){
			idx = i;
			break;
		}
	}
	playUrl = episodes[idx].playUrl + "&seriesCode=${context['EPG_CONTENT_CODE']}&episodeIndex=" + episodeNum;
	window.location.href = playUrl;
}

// 收藏-----------------------------------------------
function addCollection(){
	if(collectAjax != null){
		collectAjax.cancel();
	}
	collectAjax = new AJAX_OBJ(collectionReqUrl, addColResponse);
	collectAjax.requestData();
}

function addColResponse(xmlHttpResponse){
	var result = eval("("+xmlHttpResponse.responseText+")");
	displayDiv("none");
	if(result.collectResult=='collectSuccess'){
		$("collectSuccess").style.display = "block";
		$("tsBtn").style.display = "block";
		$("successTs_span").innerHTML ="收藏夹中共有<font color=#00fcff>"+result.totalCount+"</font>部片子";
	}else if(result.collectResult=='collectExist'){
		$("collectFail").style.display = "block";
		$("tsBtn").style.display = "block";
		$("failTs_span").innerHTML ="您已经收藏过此节目。";
	}else if(result.collectResult=='collectLimit'){
		$("collectFail").style.display = "block";
		$("tsBtn").style.display = "block";
		$("failTs_span").innerHTML ="收藏节目数量超出最大限制。";
	}else{
		$("collectFail").style.display = "block";
		$("tsBtn").style.display = "block";
		$("failTs_span").innerHTML ="节目收藏失败。";
	}
	setTimeout('$("enter_a").focus()',400);
}

//收藏提示消失
function hiddenTip(){
	$("failTs_span").innerHTML ="";
	$("successTs_span").innerHTML ="";
	$("collectSuccess").style.display = "none";
	$("collectFail").style.display = "none";
	$("tsBtn").style.display = "none";
	displayDiv("block");	
	$("collection_a").focus();
}
//弹窗时隐藏层下a
function displayDiv(_set){
	 var el = [];
     el = document.getElementsByTagName('a'); 
     for(var i=0,len=el.length; i<len ;i++){
     	if(el[i].id !="Collection_a" && el[i].id !="enter_a"){
     		$(el[i].id).style.display = _set;
     	}
     }
}
//获取字符长度
function strlen(s) { 
	var l = 0; 
	var a = s.split(""); 
	for (var i=0;i<a.length;i++) { 
	if (a[i].charCodeAt(0)<299) { 
	l++; 
	} else { 
	l+=2; 
	} 
	} 
	return l; 
}
//海报焦点事件---
function textOnFocus(objId,img,itemId){
	document.getElementById("posterImg"+objId+"_img").src=imgPath+"/"+img+".png";
	document.getElementById(itemId).style.visibility="visible";
	var textContent = document.getElementById("posterImg"+objId+"_span").innerHTML;
	var textLen = strlen(textContent);
	textContent = textContent.replace(/^\s+|\s+$/g,"");
	if(textContent.substring(0,3)=="HD_"){
		textContent = textContent.substring(3,textLen);
	}
	if(strlen(textContent)<=10){
	    document.getElementById(itemId).style.height="31px"; 
	 	document.getElementById(itemId).style.top="633px";
		 
	}else if(strlen(textContent)>10&&strlen(textContent)<=20){
	     document.getElementById(itemId).style.height="56px"; 
		 document.getElementById(itemId).style.top="607px";
	}else {
	     document.getElementById(itemId).style.height="56px"; 
		 document.getElementById(itemId).style.top="607px";
		 textContent = textContent.substring(0,8)+"…";
	}
	document.getElementById("posterImg"+objId+"_span").innerHTML = textContent;
}
function textOnBlur(objId,itemId){
	document.getElementById(objId+"_img").src=imgPath+"/dot.gif";
	document.getElementById(itemId).style.visibility="hidden";
}


</script>
<epg:body bgcolor="#000000" width="1280" height="720">
<!-- bg & img -->
<epg:img left="0" top="0" width="1280" height="720" src="./images/exploreDetailBg.jpg"/>
<epg:img src="./images/logo.png" left="0" top="0" width="350" height="85"/>
<epg:img left="628" top="206" width="2" height="204" src="./images/seriesDet_explore_dotdotdot.png"/>
<epg:img left="908" top="206" width="2" height="204" src="./images/seriesDet_explore_dotdotdot.png"/>
<!-- 搜索,自助,指南 -->
<epg:img src="${dot}" id="ss" left="951" top="47" width="80" height="38"
		 href="${context['EPG_SEARCH_URL']}" 
		 onfocus="itemOnFocus('ss','focusMenuTop_1.png');" onblur="itemOnBlur('ss','${dotStr}');"/>
<epg:img src="${dot}" id="zz" left="1051" top="47" width="80" height="38"
		 href="${context['EPG_SELF_URL']}" 
		 onfocus="itemOnFocus('zz','zizhuFocus.png');" onblur="itemOnBlur('zz','${dotStr}');"/>
<epg:img src="${dot}" id="zn" left="1151" top="47"width="80" height="38" 
		 href="javascript:history.back();" 
		 onfocus="itemOnFocus('zn','focusMenuTop_3.png');" onblur="itemOnBlur('zn','${dotStr}');"/>
<!-- poster -->
<epg:img left="80" top="101" width="220" height="330" src="${series.icon}"/>
<!-- 节目详情 -->
<div style="left:80px;top:441px;width:224px;height:224px;line-height:28px;">
	<span style="font-family:'黑体';font-size:21px;color:${BlackColor};">${series.summaryMedium}</span>
</div>
<!-- title -->
<epg:text left="350" top="101" width="865" height="40" text="${series.title}"
		  fontFamily="黑体" fontSize="32" color="#e74c3c"/>
<!-- play history -->
<epg:img id="playHistory" left="350" top="151" width="130" height="30" src="./images/seriesPlayNoFocus.png"
		 onfocus="itemOnFocus('playHistory','seriesPlay.png','hisPlayNum','${WhiteColor}');"
		 onblur="itemOnBlur('playHistory','seriesPlayNoFocus.png','hisPlayNum','${defColor}');"
		 href="javascript:playHistory('${hisPlayNum}');" defaultfocus="true"/>
<epg:text id="hisPlayNum" left="388" top="155" width="85" height="35" text="第${hisPlayNum}集" align="center"
		  fontFamily="黑体" fontSize="21" color="${defColor}"/>
<!-- 精彩预告 -->
<epg:navUrl obj="${relContent}" playUrlVar="indexUrl"/>
<epg:img id="preview" left="490" top="151" width="130" height="30" src="./images/preview.png" href="${indexUrl}"
		 onfocus="itemOnFocus('preview','previewFocus.png');" onblur="itemOnBlur('preview','preview.png');"/>
<!-- collection -->
<epg:img id="collection" left="630" top="151" width="130" height="30" src="./images/addNoFocus.png"
		 onfocus="itemOnFocus('collection','addFocus.png');" onblur="itemOnBlur('collection','addNoFocus.png');"
		 href="javascript:addCollection();"/>
<!-- pageTurn -->
<epg:img id="pre" left="770" top="151" width="130" height="30" src="./images/uppage.png" href="${pageBean.previousUrl}"
		 onfocus="itemOnFocus('pre','uppageFocus.png');" onblur="itemOnBlur('pre','uppage.png');"
		 pageop="up" keyop="pageup"/>
<epg:img id="next" left="910" top="151" width="130" height="30" src="./images/downpage.png" href="${pageBean.nextUrl}"
		 onfocus="itemOnFocus('next','downpageFocus.png');" onblur="itemOnBlur('next','downpage.png');"
		 pageop="down" keyop="pagedown"/>
<epg:text left="1050" top="155" width="35" height="28" text="${pageBean.pageIndex}" align="right"
		  fontFamily="黑体" fontSize="22" color="${defColor}"/>
<epg:text left="1086" top="155" width="80" height="28" text="/${pageBean.pageCount}页" align="left"
		  fontFamily="黑体" fontSize="22" color="${BlackColor}"/>
<epg:text left="1162" top="155" width="100" height="28" text="共   集" align="left"
		  fontFamily="黑体" fontSize="22" color="${BlackColor}"/>
<epg:text left="1184" top="155" width="35" height="28" text="${fn:length(episodeAll)}" align="center"
		  fontFamily="黑体" fontSize="22" color="${defColor}"/>
<!-- episodes -->
<epg:grid left="350" top="195" width="838" height="225" row="5" column="3" items="${episodes}" var="episode" indexVar="idx"
		  posVar="pos" hcellspacing="3">
	<epg:navUrl obj="${episode}" playUrlVar="playUrl"/>
	<epg:img id="episode${idx}" src="${dot}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="278" height="45"
			 onfocus="itemOnFocus('episode${idx}','seriesDet_explorePlay.png','episodeTxt${idx}','${WhiteColor}');"
			 onblur="itemOnBlur('episode${idx}','${dotStr}','episodeTxt${idx}','${BlackColor}');"
			 href="${playUrl}" rememberFocus="true"/>
	<fmt:formatNumber pattern="000" value="${episode.episodeIndex}" var="episodeNum"/>
	<epg:text id="episodeTxt${idx}" left="${pos[idx-1].x+26}" top="${pos[idx-1].y+11}" width="270" align="left"
			  fontFamily="黑体" fontSize="22" color="${BlackColor}" text="${episodeNum}&nbsp;${episode.title}"/>
</epg:grid>
<!-- 猜你喜欢 -->
<epg:if test="${firstGuess!=null}">
	<epg:img id="posterImg0" src="./images/dot.gif" left="347" top="465" width="136" height="201" />
	<epg:navUrl obj="${firstGuess}" indexUrlVar="indexUrl1" ></epg:navUrl>
	<epg:img id="poster1" src="../${firstGuess.still}" left="350" 
		top="468" width="130" height="195"/>
	<epg:img id="poster1focus" src="./images/dot.gif" left="350" 
		top="468" width="130" height="195"  href="${indexUrl1}&returnTo=${param.returnTo}" onfocus="textOnFocus('0','orange3','categoryList0_titlediv');" 
		onblur="textOnBlur('posterImg0','categoryList0_titlediv');"/>
	<div id="categoryList0_titlediv" style="position:absolute;font-size:22;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#f79922;visibility:hidden;left:350px;top:633px;width:130px;height:31px;z-index:1;" >
	    <div  id="posterImg0"   align="center"  style="position:absolute;left:0px;top:3px;width:130px;height:26px"  >  														
	  	  <span  id="posterImg0_span"  style="color:#ffffff;font-size:22;"  >${firstGuess.title}</span>
	    </div>
	</div>
</epg:if>


<epg:if test="${bottomCategoryItems[0]!=null}">
	<epg:img id="posterImg1" src="./images/dot.gif" left="527" top="465" width="136" height="201" />
	<epg:navUrl obj="${bottomCategoryItems[0]}" indexUrlVar="indexUrl2" ></epg:navUrl>
	<epg:img id="poster2" src="../${bottomCategoryItems[0].still}" left="530" 
		top="468" width="130" height="195"/>
	<epg:img id="poster2focus" src="./images/dot.gif" left="530" 
		top="468" width="130" height="195"  href="${indexUrl2}&returnTo=${param.returnTo}" onfocus="textOnFocus('1','orange3','categoryList1_titlediv');" 
		onblur="textOnBlur('posterImg1','categoryList1_titlediv');"/>
	<div id="categoryList1_titlediv" style="position:absolute;font-size:22;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#f79922;visibility:hidden;left:530px;top:633px;width:130px;height:31px;z-index:1;" >
	    <div  id="posterImg1"   align="center"  style="position:absolute;left:0px;top:3px;width:130px;height:26px"  >  														
	  	  <span  id="posterImg1_span"  style="color:#ffffff;font-size:22;"  >${bottomCategoryItems[0].title}</span>
	    </div>  	
	</div>
</epg:if>
	
<epg:if test="${bottomCategoryItems[1]!=null}">
	<epg:img id="posterImg2" src="./images/dot.gif" left="707" top="465" width="136" height="201" />
	<epg:navUrl obj="${bottomCategoryItems[1]}" indexUrlVar="indexUrl3" ></epg:navUrl>
	<epg:img id="poster3" src="../${bottomCategoryItems[1].still}" left="710" 
		top="468" width="130" height="195" />
	<epg:img id="poster3focus" src="./images/dot.gif" left="710" 
		top="468" width="130" height="195"  href="${indexUrl3}&returnTo=${param.returnTo}" onfocus="textOnFocus('2','orange3','categoryList2_titlediv');" 
		onblur="textOnBlur('posterImg2','categoryList2_titlediv');"/>		
	<div id="categoryList2_titlediv" style="position:absolute;font-size:22;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#f79922;visibility:hidden;left:710px;top:633px;width:130px;height:31px;z-index:1;" >
	    <div  id="posterImg2"   align="center"  style="position:absolute;left:0px;top:3px;width:130px;height:26px"  >  														
	  	  <span  id="posterImg2_span"  style="color:#ffffff;font-size:22;"  >${bottomCategoryItems[1].title}</span>
	    </div>  	
	</div>
</epg:if>
<epg:if test="${bottomCategoryItems[2]!=null}">
	<epg:img id="posterImg3" src="./images/dot.gif" left="887" top="465" width="136" height="201" />
	<epg:navUrl obj="${bottomCategoryItems[2]}" indexUrlVar="indexUrl4" ></epg:navUrl>
	<epg:img id="poster4" src="../${bottomCategoryItems[2].still}" left="890" 
		top="468" width="130" height="195"/>
	<epg:img id="poster4focus" src="./images/dot.gif" left="890" 
		top="468" width="130" height="195"  href="${indexUrl4}&returnTo=${param.returnTo}" onfocus="textOnFocus('3','orange3','categoryList3_titlediv');" 
		onblur="textOnBlur('posterImg3','categoryList3_titlediv');"/>
	<div id="categoryList3_titlediv" style="position:absolute;font-size:22;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#f79922;visibility:hidden;left:890px;top:633px;width:130px;height:31px;z-index:1;" >
	    <div  id="posterImg3"   align="center"  style="position:absolute;left:0px;top:3px;width:130px;height:26px"  >  														
	  	  <span  id="posterImg3_span"  style="color:#ffffff;font-size:22;"  >${bottomCategoryItems[2].title}</span>
	    </div>  	
	</div>
</epg:if>
<epg:if test="${bottomCategoryItems[3]!=null}">
	<epg:img id="posterImg4" src="./images/dot.gif" left="1067" top="465" width="136" height="201" />
	<epg:navUrl obj="${bottomCategoryItems[3]}" indexUrlVar="indexUrl5" ></epg:navUrl>
	<epg:img id="poster5" src="../${bottomCategoryItems[3].still}" left="1070" 
		top="468" width="130" height="195"/>
	<epg:img id="poster5focus" src="./images/dot.gif" left="1070" 
		top="468" width="130" height="195"  href="${indexUrl5}&returnTo=${param.returnTo}" onfocus="textOnFocus('4','orange3','categoryList4_titlediv');" 
		onblur="textOnBlur('posterImg4','categoryList4_titlediv');"/>
	<div id="categoryList4_titlediv" style="position:absolute;font-size:22;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#f79922;visibility:hidden;left:1070px;top:633px;width:130px;height:31px;z-index:1;" >
	    <div  id="posterImg4"   align="center"  style="position:absolute;left:0px;top:3px;width:130px;height:26px"  >  														
	  	  <span  id="posterImg4_span"  style="color:#ffffff;font-size:22;"  >${bottomCategoryItems[3].title}</span>
	    </div>  	
	</div>
</epg:if>	
<!-- 收藏提示框 -->
<div id="collectSuccess" style="display:none;" >
	<epg:img id="tip"  src="./images/collectSuccess.png" left="0" top="0" width="1280" height="720"/>
	<epg:text id="successTs" fontSize="22"  color="#565656" left="400" top="327" width="480" height="30" align="center" chineseCharNumber="17" text=""></epg:text>
</div>
<div id="collectFail" style="display:none;" >
	<epg:img id="tip"  src="./images/collectFail.png"  left="0" top="0" width="1280" height="720"/>
	<epg:text id="failTs" fontSize="22"  color="#565656" left="400" top="327" width="480" height="30" align="center" chineseCharNumber="17" text=""></epg:text>
</div>
<div id="tsBtn" style="display:none;" >
	<epg:img id="Collection"   left="481" top="412"  onfocus="itemOnFocus('Collection','enterColl.png');"  onblur="itemOnFocus('Collection','${dotStr}');"  src="./images/dot.gif" width="130" height="40"  href="${context['EPG_MYCOLLECTION_URL']}" />
	<epg:img id="enter"   left="671" top="412"  onfocus="itemOnFocus('enter','closeWin.png');"  onblur="itemOnFocus('enter','${dotStr}');"  src="./images/dot.gif" width="130" height="40"  href="javascript:hiddenTip()" />
</div>
</epg:body>
</html>