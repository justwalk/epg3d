<%@page contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@page import="sitv.epg.web.tag.help.AbstractUrlGenerator,sitv.epg.zhangjiagang.EpgUserSession"%>
<epg:html>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<%
String[][] highLightStyles = new String[][]{
    {"60","160","45","45","A"},
    {"115","160","45","45","B"},
    {"170","160","45","45","C"},
    {"225","160","45","45","D"},
    {"280","160","45","45","E"},
    {"335","160","45","45","F"},
    {"390","160","45","45","G"},
    {"445","160","45","45","1"},
    {"500","160","45","45","2"},
    {"555","160","45","45","3"},
    {"60","215","45","45","H"},
    {"115","215","45","45","I"},
    {"170","215","45","45","J"},
    {"225","215","45","45","K"},
    {"280","215","45","45","L"},
    {"335","215","45","45","M"},
    {"390","215","45","45","N"},
    {"445","215","45","45","4"},
    {"500","215","45","45","5"},
    {"555","215","45","45","6"},
    {"60","270","45","45","O"},
    {"115","270","45","45","P"},
    {"170","270","45","45","Q"},
    {"225","270","45","45","R"},
    {"280","270","45","45","S"},
    {"335","270","45","45","T"},
    {"390","270","100","45","back"},
    {"500","270","45","45","7"},
    {"555","270","45","45","8"},
    {"60","325","45","45","U"},
    {"115","325","45","45","V"},
    {"170","325","45","45","W"},
    {"225","325","45","45","X"},
    {"280","325","45","45","Y"},
    {"335","325","45","45","Z"},
    {"390","325","100","45","search"},
    {"500","325","45","45","9"},
    {"555","325","45","45","0"}
};
request.setAttribute("highLightStyles",highLightStyles);

String UrlBase = (String)request.getAttribute("urlBase");
String queryStr = EpgUserSession.createFixUrlParams(request);
String UrlNoPage = new StringBuffer(UrlBase).append("?").append(queryStr).toString();
if(UrlNoPage.indexOf("pageIndex=")!=-1){
	UrlNoPage = UrlNoPage.substring(0,UrlNoPage.indexOf("pageIndex=")+10) + "1";
}

request.setAttribute("url", UrlNoPage);

String initals = request.getParameter("initals");
request.setAttribute("initals", initals);

%>
<!-- hot search -->
<epg:query queryName="getSeverialItems" maxRows="8" var="hotSearchs" >
	<epg:param name="categoryCode" value="${templateParams['hotSearch']}" type="java.lang.String"/>
</epg:query>
<!--Search Result searchResultCount -->
<epg:if test="${initals!=null && initals != ''}">
	<epg:if test="${param.searchType == 'all'}">
		<epg:query queryName="searchResultforAll" maxRows="10" var="searchResults"
			   pageBeanVar="allPageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true">
			<epg:param name="initals" value="%${initals}%" type="java.lang.String"/>
			<epg:param name="mainFolder" value="%%" type="java.lang.String"/>
		</epg:query>
		<epg:query queryName="searchResultCount" maxRows="1" var="searchResultsVodCount" >
			<epg:param name="initals" value="%${initals}%" type="java.lang.String"/>
			<epg:param name="mainFolder" value="%电影%" type="java.lang.String"/>
		</epg:query>
		<epg:query queryName="searchResultCount" maxRows="1" var="searchResultsSeriesCount" >
			<epg:param name="initals" value="%${initals}%" type="java.lang.String"/>
			<epg:param name="mainFolder" value="%电视剧%" type="java.lang.String"/>
		</epg:query>
		<epg:set value="${allPageBean.totalCount}" var="allCount"/>
		<epg:set value="${searchResultsVodCount.countAll}" var="vodCount"/>
		<epg:set value="${searchResultsSeriesCount.countAll}" var="seriesCount"/>
	</epg:if>
	<epg:if test="${param.searchType == 'vod'}">
		<epg:query queryName="searchResultforAll" maxRows="10" var="searchResults"
			   pageBeanVar="allPageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true">
			<epg:param name="initals" value="%${initals}%" type="java.lang.String"/>
			<epg:param name="mainFolder" value="%电影%" type="java.lang.String"/>
		</epg:query>
		<epg:query queryName="searchResultCount" maxRows="1" var="searchResultsAllCount" >
			<epg:param name="initals" value="%${initals}%" type="java.lang.String"/>
			<epg:param name="mainFolder" value="%%" type="java.lang.String"/>
		</epg:query>
		<epg:query queryName="searchResultCount" maxRows="1" var="searchResultsSeriesCount" >
			<epg:param name="initals" value="%${initals}%" type="java.lang.String"/>
			<epg:param name="mainFolder" value="%电视剧%" type="java.lang.String"/>
		</epg:query>
		<epg:set value="${searchResultsAllCount.countAll}" var="allCount"/>
		<epg:set value="${allPageBean.totalCount}" var="vodCount"/>
		<epg:set value="${searchResultsSeriesCount.countAll}" var="seriesCount"/>
	</epg:if>
	<epg:if test="${param.searchType == 'series'}">
		<epg:query queryName="searchResultforAll" maxRows="10" var="searchResults"
			   pageBeanVar="allPageBean" pageIndexParamVar="pageIndex" pageTurnIsLoop="true">
			<epg:param name="initals" value="%${initals}%" type="java.lang.String"/>
			<epg:param name="mainFolder" value="%电视剧%" type="java.lang.String"/>
		</epg:query>
		<epg:query queryName="searchResultCount" maxRows="1" var="searchResultsAllCount" >
			<epg:param name="initals" value="%${initals}%" type="java.lang.String"/>
			<epg:param name="mainFolder" value="%%" type="java.lang.String"/>
		</epg:query>
		<epg:query queryName="searchResultCount" maxRows="1" var="searchResultsVodCount" >
			<epg:param name="initals" value="%${initals}%" type="java.lang.String"/>
			<epg:param name="mainFolder" value="%电影%" type="java.lang.String"/>
		</epg:query>
		<epg:set value="${searchResultsAllCount.countAll}" var="allCount"/>
		<epg:set value="${searchResultsVodCount.countAll}" var="vodCount"/>
		<epg:set value="${allPageBean.totalCount}" var="seriesCount"/>
	</epg:if>
</epg:if>
<epg:if test="${initals==null || initals == '' || empty searchResults }">
	<epg:set value="0" var="allCount"/>
	<epg:set value="0" var="vodCount"/>
	<epg:set value="0" var="seriesCount"/>
</epg:if>

<epg:set value="blue" var="onFocusBg"/>
<epg:set value="#ffffff" var="onFocusColor"/>
<epg:set value="searchCategoryBtn" var="defaultBg"/>
<epg:set value="#1978B8" var="defaultColor"/>
<epg:set value="${allPageBean.pageIndex}" var="pageIdx"/>
<epg:set value="${allPageBean.pageCount}" var="pageCount"/>
<epg:set value="${allPageBean.previousUrl}" var="previousUrl"/>
<epg:set value="${allPageBean.nextUrl}" var="nextUrl"/>

<epg:choose>
	<epg:when test="${param.searchType == 'all'}">
		<epg:set value="${onFocusBg}" var="searchTypeBtn_all"/>
		<epg:set value="${onFocusColor}" var="searchTypeTxt_all"/>
	</epg:when>
	<epg:otherwise>
		<epg:set value="${defaultBg}" var="searchTypeBtn_all"/>
		<epg:set value="${defaultColor}" var="searchTypeTxt_all"/>
	</epg:otherwise>
</epg:choose>
<epg:choose>
	<epg:when test="${param.searchType == 'vod'}">
		<epg:set value="${onFocusBg}" var="searchTypeBtn_vod"/>
		<epg:set value="${onFocusColor}" var="searchTypeTxt_vod"/>
	</epg:when>
	<epg:otherwise>
		<epg:set value="${defaultBg}" var="searchTypeBtn_vod"/>
		<epg:set value="${defaultColor}" var="searchTypeTxt_vod"/>
	</epg:otherwise>
</epg:choose>
<epg:choose>
	<epg:when test="${param.searchType == 'series'}">
		<epg:set value="${onFocusBg}" var="searchTypeBtn_series"/>
		<epg:set value="${onFocusColor}" var="searchTypeTxt_series"/>
	</epg:when>
	<epg:otherwise>
		<epg:set value="${defaultBg}" var="searchTypeBtn_series"/>
		<epg:set value="${defaultColor}" var="searchTypeTxt_series"/>
	</epg:otherwise>
</epg:choose>

<epg:navUrl returnTo="home" returnUrlVar="returnUrl"></epg:navUrl>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<style type="text/css">
body{
	color:#FFFFFF;
	font-size:22;
	font-family:"黑体";
}
</style>
<script>
	var pageLoad = false;
function $(_id) {
	return "string" == typeof _id ? document.getElementById(_id) : _id;
}

var previousPageUrl = "${previousUrl}";
var nextPageUrl = "${nextUrl}";
var paramFlag =  false;
if('${param.initals}'!=''){
	paramFlag = true;
}

function pageUp(){
	if(previousPageUrl==""){
		return;
	}
	if(previousPageUrl.indexOf("&pageTurn=pre") == -1){
		previousPageUrl = previousPageUrl+"&pageTurn=pre";
	}
 	document.location.href = previousPageUrl;
}

function pageDown(){
	if(nextPageUrl==""){
		return;
	}
	if(nextPageUrl.indexOf("&pageTurn=next") == -1){
		nextPageUrl = nextPageUrl + "&pageTurn=next";
	}
 	document.location.href = nextPageUrl;
}

var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images";
function menuOnFocus(objId,color){
	if (pageLoad) {
		$(objId).style.backgroundColor = color;
	}
}
//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名
function itemOnFocus(objId,img){
	if (pageLoad) {
		document.getElementById(objId + "_img").src = imgPath + "/" + img + ".png";
		if (document.getElementById(objId + "_span")) {
			document.getElementById(objId + "_span").style.color = "#ffffff";
		}
	}
}
//失去焦点事件
function itemOnBlur(objId){
	if (pageLoad) {
		document.getElementById(objId + "_img").src = imgPath + "/dot.gif";
		if (document.getElementById(objId + "_span")) {
			document.getElementById(objId + "_span").style.color = "#ffffff";
		}
	}
}
function menuOnBlur(objId,color){
	if (pageLoad) {
		$(objId).style.backgroundColor = color;
	}
}

function buttonOnFocus(objId,img,txtColor,txt){
		$(objId + "_img").src = imgPath + "/" + img + ".png";
		if (txt != "" && txt != null) {
			$(txt + "_span").style.color = txtColor;
		}
}

function buttonOnBlur(objId,img,txtColor,txt){
		$(objId + "_img").src = imgPath + "/" + img + ".png";
		if (txt != "" && txt != null) {
			$(txt + "_span").style.color = txtColor;
		}
}

function itemsOnFocus(objId,img,idx){
		$(objId + "_img").src = imgPath + "/" + img + ".png";
		$("playText" + idx + "_span").style.color = "#ffffff";
}

function itemsOnBlur(objId,img,idx){
		$(objId + "_img").src = imgPath + "/" + img + ".png";
		$("playText" + idx + "_span").style.color = "#333";
}

function mapOnFocus(idx){
		$("hightLight" + idx).style.visibility = "visible";
	//alert($("hightLight"+idx).style.visibility);
}

function mapOnBlur(idx){
		$("hightLight" + idx).style.visibility = "hidden";
}


var search = {
	defaultInfo:"请选择影片首字母",
	param:"",
	fixParam:"",
	curIndex:"",
	btnFocus:"",
	pageTurn:"",
	getSearchParam:function(_param, _curIdx){
		if(_param == 'back'){
			this.param = this.param.substring(0,this.param.length-1);
		}else if(_param == 'clear'){
			this.param = "";
		}else {
			this.param += _param;
		}
		//$("info").innerHTML = this.param;
		if(this.param != ""){
			this.fixParam = "&initals="+this.param+"&searchType=all";
		}else{
			this.fixParam = "";
		}
		window.location.href ="${url}"+this.fixParam + "&curIdx=" + _curIdx;
	},
	init:function(param){
		this.curIndex = "${param.curIdx}";
		this.btnFocus = "${param.btnFocus}";
		this.pageTurn = "${param.pageTurn}";
		this.param = param;
		if(this.btnFocus!=""){
			document.getElementById(this.btnFocus+"_a").focus();
		}else if(this.pageTurn!=""){
			document.getElementById(this.pageTurn+"_a").focus();
		}else{
			document.getElementById("searchBtn0_a").focus();
		}
	},
	doSearch:function(){
		if(this.param != ""){
			this.fixParam = "&initals="+this.param+"&searchType=all";
		}else{
			this.fixParam = "";
		}
		window.location.href ="${url}"+this.fixParam ;
	}
};
function back(){
 	document.location.href = "${returnUrl}";
 }
 function exit(){
 	back();
 }
 
 function paramCtrl(param){
 	if(param == "search" && !paramFlag){
 		return;
 	}
 	if(!paramFlag){
 		$("info").innerHTML = "";
 		paramFlag = true;
 	}
 	if (param == "back"){
 		var str = $("info").innerHTML;
 		$("info").innerHTML = str.substring(0,str.length-1);
 	}else if(param == "search"){
		if ($("info").innerHTML == "") return;
 		search.init($("info").innerHTML);
 		search.doSearch();
 	}else{
		$("info").innerHTML += param;
 	}
 	if( $("info").innerHTML =="" ){
 		$("info").innerHTML = "请选择影片首字母";
 		paramFlag = false;
 	}
 }
 
function classify(count,url){
	 if(count!=0) document.location.href = url; 
}
function eventHandler(eventObj)
{
	switch(eventObj.code)
	{
		case "SYSTEM_EVENT_ONLOAD":
			pageLoad = true;
			break;
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
			iPanel.eventFrame.openIndex();
			return 0;
			break;
	 	 case "SITV_KEY_GUIDE":
	 		paramCtrl("search");
		  	return 0;
			break;
		default:
			return 1;
			break;
	}
}
</script>
<epg:body bgcolor="#000000" width="1280" height="720" >
<!-- 背景图片以及头部图片 -->
<epg:img id="main"  defaultSrc="./images/search.jpg" src="../${templateParams['backgroundImg']}"
	     left="0" top="0" width="1280" height="720"/>

<!-- searchResults -->
<epg:grid left="640" top="208" width="580" height="460" row="10" column="1" items="${searchResults}"
 		  var="searchResult" indexVar="idx" posVar="pos" align="left">
	<epg:navUrl obj="${searchResult}" indexUrlVar="indexUrl"/>
	<epg:img id="play${idx}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="580" height="45"
			 src="./images/dot.png" href="${indexUrl}&returnTo=biz" onfocus="itemsOnFocus('play${idx}','focusPlay','${idx}');"
			 onblur="itemsOnBlur('play${idx}','dot','${idx}');" rememberFocus="true"/>
	<epg:text id="playText${idx}" left="${pos[idx-1].x+45}" top="${pos[idx-1].y+11}" width="535" height="45"
			  text="${searchResult.title}"
			  fontFamily="黑体" fontSize="22" color="#333333" align="left" chineseCharNumber="23" dotdotdot=""/>
</epg:grid>

<epg:if test="${searchResults == null}">
	<epg:set value="0" var="pageIdx"/>
	<epg:set value="0" var="pageCount"/>
</epg:if>


<div style="position:absolute;left:0px; top:0px; width:350px; height:85px;">
<epg:img src="./images/logo.png"  width="350" height="85"/>
</div>



<epg:img src="./images/search_btnBg.png" left="0" top="90" width="610" height="600" usemap="mapArea"/>
<!-- letter / back / search -->
<c:forEach items="${highLightStyles}" varStatus="idx" var="highLightStyle">
	<epg:img id="searchBtn${idx.index}"
		  left="${highLightStyle[0]}" top="${highLightStyle[1]}"
		  width="${highLightStyle[2]}" height="${highLightStyle[3]}"
		  href="javascript:paramCtrl('${highLightStyle[4]}');"
		  onfocus="mapOnFocus('${idx.index}');" onblur="mapOnBlur('${idx.index}');"
		   src="./images/dot.png"/>
</c:forEach>
<c:forEach items="${highLightStyles}" var="highLightStyle" varStatus="currentIdx">
	<div id="hightLight${currentIdx.index}" style="position: absolute;left:${highLightStyle[0]}px;top:${highLightStyle[1]}px;width:${highLightStyle[2]}px;height:${highLightStyle[3]}px;visibility:hidden;">
		<epg:img width="${highLightStyle[2]}" height="${highLightStyle[3]}" src="./images/${highLightStyle[4]}.png"/>
	</div>
</c:forEach>


<!-- 收藏,返回 -->
<!-- <epg:img src="./images/dot.gif" id="zz"  left="950" top="47" width="80" height="38"
	href="${context['EPG_MYCOLLECTION_URL']}" onfocus="itemOnFocus('zz','focusMenuTop_2');"  onblur="itemOnBlur('zz');" />
<epg:img id="history" rememberFocus="true" src="./images/dot.png" left="1050" top="47" width="80" height="38"
		 onfocus="buttonOnFocus('history','focusMenuTop_4');" onblur="buttonOnFocus('history','dot');"
		 href="${context['EPG_CONTEXT']}/index/hdvodhistory.do"/>
<epg:img src="./images/dot.gif" id="zn"  left="1150" top="47"width="80" height="38" 
	 href="#" onclick="back()" onfocus="itemOnFocus('zn','focusMenuTop_3');"  onblur="itemOnBlur('zn');" /> -->
<!-- 收藏,返回 -->
<!--<epg:img src="./images/dot.gif" id="zz"  left="950" top="47" width="80" height="38"
	href="${context['EPG_MYCOLLECTION_URL']}" onfocus="itemOnFocus('zz','focusMenuTop_2');"  onblur="itemOnBlur('zz');" />-->
<epg:img id="history" rememberFocus="true" src="./images/dot.png" left="1050" top="47" width="80" height="38"
		 onfocus="buttonOnFocus('history','zizhuFocus');" onblur="buttonOnFocus('history','dot');"
		 href="${context['EPG_SELF_URL']}"/>
<epg:img src="./images/dot.gif" id="zn"  left="1150" top="47"width="80" height="38" 
	 href="#" onclick="back()" onfocus="itemOnFocus('zn','focusMenuTop_3');"  onblur="itemOnBlur('zn');" />
	 
<!-- search params -->
<div style="position: absolute;left:75px;top:102px;width:525px;height:47px;line-height:47px;">
	<epg:if test="${initals==null || initals ==''}"><font id="info" style="font-size:24px;color:#666666;">请选择影片首字母</font></epg:if>
	<epg:if test="${initals!=null && initals !=''}"><font id="info" style="font-size:24px;color:#666666;">${param.initals}</font></epg:if>
</div>

<!-- hot search -->
<epg:grid left="59" top="472" width="541" height="191" row="4" column="2" items="${hotSearchs}" var="hotSearch"
 		  indexVar="idx" posVar="pos">
	<epg:navUrl obj="${hotSearch}" indexUrlVar="indexUrl"/>
	<epg:img id="hotItem${idx}" left="${pos[idx-1].x}" top="${pos[idx-1].y}" width="267" height="42" src="./images/searchCategoryBtn.png"
			 onfocus="buttonOnFocus('hotItem${idx}','searchCategoryBg','#ffffff','hotSearchTxt${idx}');" onblur="buttonOnFocus('hotItem${idx}','searchCategoryBtn','#1978b8','hotSearchTxt${idx}');"
			 href="${indexUrl}&pi=${idx}" rememberFocus="true"/>
	<epg:text id='hotSearchTxt${idx}' left="${pos[idx-1].x}" top="${pos[idx-1].y+9}" width="267" height="42" text="${hotSearch.title}"
			  fontFamily="黑体" fontSize="21" color="#1978b8" chineseCharNumber="12" dotdotdot="…"/>
</epg:grid>
<!-- 单/多剧集、全部 -->
<epg:img id="vod" left="640" top="103" width="130" height="40" src="./images/${searchTypeBtn_vod}.png"
		 onfocus="buttonOnFocus('vod','orange','#ffffff','vodType');"
		 onblur="buttonOnBlur('vod','${searchTypeBtn_vod}','${searchTypeTxt_vod}','vodType');"
		 href="javascript:classify('${vodCount}','${url}&initals=${param.initals}&searchType=vod&btnFocus=vod')"/>
<epg:text id="vodType" left="643" top="112" width="130" height="40" text="电影(${vodCount})" align="center"
		  fontFamily="黑体" fontSize="21" color="${searchTypeTxt_vod}"/>

<epg:img id="series" left="790" top="103" width="130" height="40" src="./images/${searchTypeBtn_series}.png"
		 onfocus="buttonOnFocus('series','orange','#ffffff','seriesType');"
		 onblur="buttonOnBlur('series','${searchTypeBtn_series}','${searchTypeTxt_series}','seriesType');"
		 href="javascript:classify('${seriesCount}','${url}&initals=${param.initals}&searchType=series&btnFocus=series')"/>
<epg:text id="seriesType" left="793" top="112" width="130" height="40" text="剧集(${seriesCount})" align="center"
		  fontFamily="黑体" fontSize="21" color="${searchTypeTxt_series}"/>

<epg:img id="all" left="940" top="103" width="130" height="40" src="./images/${searchTypeBtn_all}.png"
		 onfocus="buttonOnFocus('all','orange','#ffffff','allType');"
		 onblur="buttonOnBlur('all','${searchTypeBtn_all}','${searchTypeTxt_all}','allType');"
		 href="javascript:classify('${allCount}','${url}&initals=${param.initals}&searchType=all&btnFocus=all')"/>
<epg:text id="allType" left="943" top="112" width="130" height="40" text="全部(${allCount})" align="center"
			  fontFamily="黑体" fontSize="21" color="${searchTypeTxt_all}"/>

<!-- pageTurn / pageNum  -->
<epg:img id="pre" src="./images/dot.png" left="640" top="160" width="130" height="32"
		 href="javascript:pageUp();" pageop="up" keyop="pageup"
		 onfocus="buttonOnFocus('pre','prePage_focus');" onblur="buttonOnFocus('pre','dot');"/>
<epg:img id="next" src="./images/dot.png" left="790" top="160" width="130" height="32"
		 href="javascript:pageDown();" pageop="down" keyop="pagedown"
		 onfocus="buttonOnFocus('next','nextPage_focus');" onblur="buttonOnFocus('next','dot');"/>


<div align="right" style="left:945px;top:164px;width:35px;height:19px;position:absolute;">
	<font id="pageIndex" style="font-family:'黑体';font-size:22px;color:#1978b8;">${pageIdx}</font>
</div>
<div align="left" style="left:980px;top:164px;width:80px;height:19px;position:absolute;">
	<font id="pageTotal" style="font-family:'黑体';font-size:22px;color:#646464;">/${pageCount}页</font>
</div>
<!-- 软键盘高亮状态图 -->
<c:forEach items="${highLightStyles}" var="highLightStyle" varStatus="currentIdx">
	<div id="hightLight${currentIdx.index}" style="position: absolute;left:${highLightStyle[0]}px;top:${highLightStyle[1]}px;width:${highLightStyle[2]}px;height:${highLightStyle[3]}px;visibility:hidden;">
		<epg:img width="${highLightStyle[2]}" height="${highLightStyle[3]}" src="./images/${highLightStyle[4]}.png"/>
	</div>
</c:forEach>
</epg:body>
</epg:html>