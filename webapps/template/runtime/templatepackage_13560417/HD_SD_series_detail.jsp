<%@page contentType="text/html; charset=GBK" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@page import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*"%>
<%
	String leaveFocusId = request.getParameter("leaveFocusId");
	if (leaveFocusId != null && leaveFocusId != "") {
		EpgUserSession eus = EpgUserSession.findUserSession(request);
		eus.setPlayFocusId(leaveFocusId);
	}
%>
<html>
<!-- 查询剧集内容信息 -->
<epg:query queryName="querySeriesByCode" var="series">
	<epg:param name="contentCode" value="${context['EPG_CONTENT_CODE']}" type="java.lang.String" />
</epg:query>

<epg:set value="1" var="ProgramBodyType" />
<epg:set value="1" var="hdType" />
<epg:set value="0" var="sdType" />
<epg:if test="${series.relCode!=null}">
	<!-- HD正片 -->
	<epg:query queryName="queryRelContentByRelCodeAndType" maxRows="1" var="HDrelContent">
		<epg:param name="relCode" value="${series.relCode}" type="java.lang.String" />
		<epg:param name="bodyType" value="${ProgramBodyType}" type="java.lang.Integer" />
		<epg:param name="videoType" value="${hdType}" type="java.lang.Integer" />
		<epg:param name="type" value="series" type="java.lang.String" />
	</epg:query>
	<!-- SD正片 -->
	<epg:query queryName="queryRelContentByRelCodeAndType" maxRows="1" var="SDrelContent">
		<epg:param name="relCode" value="${series.relCode}" type="java.lang.String" />
		<epg:param name="bodyType" value="${ProgramBodyType}" type="java.lang.Integer" />
		<epg:param name="videoType" value="${sdType}" type="java.lang.Integer" />
		<epg:param name="type" value="series" type="java.lang.String" />
	</epg:query>
</epg:if>
<!-- HD剧集集数信息 -->
<epg:query queryName="queryEpisodeByCode" maxRows="40" var="episodes" pageBeanVar="pageBean" pageIndexParamVar="pageIndex2">
	<epg:param name="seriesCode" value="${context['EPG_CONTENT_CODE']}" type="java.lang.String" />
</epg:query>
<epg:query queryName="queryEpisodeByCode" maxRows="999" var="renewNum" pageBeanVar="pageBean1" pageIndexParamVar="pageIndex1">
	<epg:param name="seriesCode" value="${context['EPG_CONTENT_CODE']}" type="java.lang.String" />
</epg:query>

<!-- 查询用户观看历史 -->
<epg:query queryName="userCouldMarkSeries" var="userHistory">
	<epg:param name="USER_ID" value="${EPG_USER.userAccount}" type="java.lang.String" />
	<epg:param name="CONTENT_CODE" value="${context['EPG_CONTENT_CODE']}" type="java.lang.String" />
</epg:query>

<!-- 右下方推荐随机内容  -->
<epg:set var="tags" value="${fn:split(series.tags, ',')}"></epg:set>
<epg:set var="tag" value="${tags[0]}"></epg:set>
<epg:if test="${tag=='高清'}">
	<epg:set var="tag" value="${tags[1]}"></epg:set>
</epg:if>

<epg:query queryName="getSeverialItemsByTagsRandomIncludePic" maxRows="5" var="bottomCategoryItems">
	<epg:param name="tags" value="${tag}" type="java.lang.String" />
	<epg:param name="selfCode" value="${series.contentCode}" type="java.lang.String" />
	<epg:param name="mainFolder" value="${series.mainFolder}" type="java.lang.String" />
</epg:query>

<!-- 收藏、返回 -->
<epg:navUrl obj="${series}" addCollectionUrlVar="addColUrl"></epg:navUrl>
<epg:navUrl returnTo="${param.returnTo}" returnUrlVar="returnUrl"></epg:navUrl>
<epg:navUrl returnTo="home" returnUrlVar="returnHomeUrl"></epg:navUrl>

<!--  剧集剧情信息分割为7行 -->
<epg:text left="0" top="0" width="295" height="220" chineseCharWidth="24" multi="true" output="false" lines="summarys" lineNum="7">${series.summaryMedium}</epg:text>


<style>
img {
	border: 0px;
}

#info_span {
	display: block;
	line-height: 41px;
	height: 35px;
}

body {
	color: #FFFFFF;
	font-size: 22;
	font-family: "黑体";
}

a {
	outline: none;
	text-decoration: none;
}
</style>
<script src="${context['EPG_CONTEXT']}/js/ajax.js"></script>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>

<script type="text/javascript">
var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images";
var _level = "${series.reserve1}";
var _ajaxObj = null;
var _index = 0;
var _pageIndex = 1;
var _episodeIndex = 1;
var leaveFocusId;
var _playUrlList = [];//播放链接
var _episodeNumList = [];//集数号码
var pagAllNum = 0;//按键监听页面数
<epg:forEach items="${renewNum}" var="episode" varStatus="idx">
	<epg:navUrl obj="${episode}" playUrlVar="playUrl"/>
	_playUrlList[${idx.index}]='${context['EPG_CONTEXT']}/3DPlay/play.html';
	_episodeNumList[${idx.index}] = '${episode.episodeIndex}';
</epg:forEach>
var totalNums = ${fn:length(renewNum)};//总集数
var pageNums = 40;//每页的集数
var totalPage = 1;
var lastPageNums = totalNums / pageNums == 0 ? totalNums / pageNums : totalNums % pageNums;
if(lastPageNums > 0) {
	totalPage = parseInt(totalNums / pageNums) + 1;
} else {
	totalPage = totalNums / pageNums;
}

function $(_id) {
	return "string" == typeof _id ? document.getElementById(_id) : _id;
}

function focusCurId(objId,img,color){
	if(objId=="play"){
		$("playTitle_span").style.color="#ffffff";
		$("playTitle").style.zIndex="10";
		
		$("r_playTitle_span").style.color="#ffffff";
		$("r_playTitle").style.zIndex="10";
	}
	$(objId+"_img").src=imgPath+"/"+img+".png";
	$("r_"+objId+"_img").src=imgPath+"/"+img+".png";
}
function blurCurId(objId,color){
	if(objId=="play"){
		$("playTitle_span").style.color="#1978b8";
		$("playTitle").style.zIndex="1";
		$("r_playTitle_span").style.color="#1978b8";
		$("r_playTitle").style.zIndex="1";
	}
	$(objId+"_img").src=imgPath+"/dot.gif";
	$("r_"+objId+"_img").src=imgPath+"/dot.gif";
}
function changeColor(flag,objId,img){
	leaveFocusId = "episode"+objId; 
	if(flag==0){
		$(objId+"_div").style.zIndex=10;
		if ("pageUp" == objId) {
			if ($("pageUp") != null) {
				$("pageUp").style.zIndex = 10;
				if (pagAllNum != 0) {
					$("pageUp_span").style.color = "#ffffff";
					$("r_pageUp_span").style.color = "#ffffff";
				}
			}
		}
		if ("pageDown" == objId) {
			if($("pageDown")!=null){
				$("pageDown").style.zIndex=10;
				if (pagAllNum != 1) {
					$("pageDown_span").style.color = "#ffffff";
					$("r_pageDown_span").style.color = "#ffffff";
				}
			}
		}
		if ("pageDown1" == objId) {
			if($("pageDown1")!=null){
				$("pageDown1").style.zIndex=10;
				if (pagAllNum != 2) {
					$("pageDown1_span").style.color="#ffffff";
					$("r_pageDown1_span").style.color="#ffffff";
				}
			}
		}
		if ("pageDown2" == objId) {
			if ($("pageDown2") != null) {
				$("pageDown2").style.zIndex = 10;
				if (pagAllNum != 3) {
					$("pageDown2_span").style.color = "#ffffff";
					$("r_pageDown2_span").style.color = "#ffffff";
				}
			}
		}
		$(objId+"_img").src=imgPath+"/"+img+".png";
	}else if(flag==1){
		$(objId+"_div").style.zIndex=0;
		if ("pageUp" == objId) {
			if ($("pageUp") != null) {
				$("pageUp").style.zIndex = 0;
				if (pagAllNum != 0) {
					$("pageUp_span").style.color = "#1978b8";
					$("r_pageUp_span").style.color = "#1978b8";
				}
			}
		}
		if ("pageDown" == objId) {
			if ($("pageDown") != null) {
				$("pageDown").style.zIndex = 0;
				if (pagAllNum != 1) {
					$("pageDown_span").style.color = "#1978b8";
					$("r_pageDown_span").style.color = "#1978b8";
				}
			}
		}
		if ("pageDown1" == objId) {
			if ($("pageDown1") != null) {
				$("pageDown1").style.zIndex = 0;
				if (pagAllNum != 2) {
					$("pageDown1_span").style.color = "#1978b8";
					$("r_pageDown1_span").style.color = "#1978b8";
				}
			}
		}
		if ("pageDown2" == objId) {
			if ($("pageDown2") != null) {
				$("pageDown2").style.zIndex = 0;
				if (pagAllNum != 3) {
					$("pageDown2_span").style.color = "#1978b8";
					$("r_pageDown2_span").style.color = "#1978b8";
				}
			}
		}
		//$(objId+"Focus_img").src=imgPath+"/currNumFocus.png";
		$(objId+"_img").src=imgPath+"/"+img+".png";
		$("r_"+objId+"_img").src=imgPath+"/"+img+".png";
	}
}
//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名
function itemOnFocus(objId,img){
	leaveFocusId = objId; 
	$(objId+"_img").src=imgPath+"/"+img+".png";
	$("r_"+objId+"_img").src=imgPath+"/"+img+".png";
}
//失去焦点事件
function itemOnBlur(objId){
	$(objId+"_img").src=imgPath+"/dot.gif";
	$("r_"+objId+"_img").src=imgPath+"/dot.gif";
}
	

//获取字符长度
function len(s) { 
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

//海报焦点事件
function textOnFocus(objId,img,itemId,title){
	document.getElementById("posterImg"+objId+"_img").src=imgPath+"/"+img+".png";
	document.getElementById(itemId).style.visibility="visible";
	document.getElementById("r_posterImg"+objId+"_img").src=imgPath+"/"+img+".png";
	document.getElementById("r_"+itemId).style.visibility="visible";
	
	var textContent = title; //document.getElementById("posterImg"+objId+"_span").innerHTML;
	var textLen = len(textContent);
	textContent = textContent.replace(/^\s+|\s+$/g,"");
	if(textContent.substring(0,3)=="HD_"){
		textContent = textContent.substring(3,textLen);
	}
	if(len(textContent)<=10){
	    document.getElementById(itemId).style.height="31px"; 
	 	document.getElementById(itemId).style.top="633px";
		 
	}else if(len(textContent)>10&&len(textContent)<=20){
	     document.getElementById(itemId).style.height="56px"; 
		 document.getElementById(itemId).style.top="607px";
	}else {
	     document.getElementById(itemId).style.height="56px"; 
		 document.getElementById(itemId).style.top="607px";
		 textContent = textContent.substring(0,8)+"…";
	}
	document.getElementById("posterImg"+objId+"_span").innerHTML = textContent;
	document.getElementById("r_posterImg"+objId+"_span").innerHTML = textContent;
}
function textOnBlur(objId,itemId){
	document.getElementById(objId+"_img").src=imgPath+"/dot.gif";
	document.getElementById(itemId).style.visibility="hidden";
	document.getElementById("r_"+objId+"_img").src=imgPath+"/dot.gif";
	document.getElementById("r_"+itemId).style.visibility="hidden";
}
//播放视频
function playBefore(idx){
	var id1=parseInt(idx);
	var index = 0;
	for(var j=0; j<_episodeNumList.length;j++){
		if(_episodeNumList[j]==id1){
			index = j;
			break;
		}
	}
	window.location.href=_playUrlList[index];//+"&returnTo=${returnTo}&seriesCode=${context['EPG_CONTENT_CODE']}&episodeIndex="+id1;
}

//收藏AJAX
function addCollection(){
	$("addCol_img").src=imgPath+"/dot.gif";
	var encodeContentName = encodeURIComponent("${series.title}");
	var encodeContentImg = encodeURIComponent("${series.still}");
	var ajax_url = "${context['EPG_CONTEXT']}/addMyCollection.do?userMac=${EPG_USER.userAccount}&contentType=series&contentCode=${series.contentCode}&contentName="+encodeContentName+"&still="+encodeContentImg+"&bizCode=${context['EPG_BUSINESS_CODE']}&categoryCode=${context['EPG_CATEGORY_CODE']}&hdType=${series.hdType}";
	_ajaxObj = new AJAX_OBJ(ajax_url,addColResponse);
	_ajaxObj.requestData();
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
	//$("addCol_a").focus();
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

function getActors(baseUrl, actors, starringTags){
	var actorStr = "";
	var starringTagStr = "";
	var actorsLen = actors.indexOf("<br>");
	var starringTagsLen = starringTags.indexOf("<br>");
	if(actorsLen != -1){
		actorStr = actors.substring(0,actorsLen);
	}else{
		actorStr = actors;
	}
	if(starringTagsLen != -1){
		starringTagStr = starringTags.substring(0,starringTagsLen);
	}else{
		starringTagStr = starringTags;
	}
	var url = baseUrl + "&protagonist=" + encodeURIComponent(actorStr) + "&currentActor=" + encodeURIComponent(starringTagStr)+ "&hdType=${hdType}";
	window.location.href = url;
}
var isInit = 0;
//初始化
function init(){
	var historyIndex = 0;
	for(i=1;i<=40;i++){
		if ($("currepisodeFocus" + i + "_img") != null) {
			$("currepisodeFocus" + i + "_img").style.visibility = 'hidden';
			$("episode" + i + "_span").style.color = "#1978b8";
		}
	}
	if("${userHistory.episodeIndex}"!=""&&"${userHistory.episodeIndex}"!=null){
		for (i = 0; i < _episodeNumList.length; i++) {
			if(_episodeNumList[i]=="${userHistory.episodeIndex}"){
				historyIndex = i+1;
			}
		}
		if(historyIndex>0&&historyIndex<=40&&pagAllNum==0){
			$("pageUp_span").style.color = "#ffffff";
			
			$("episode"+historyIndex+"_span").style.color = "#ffffff";
			$("currepisodeFocus"+historyIndex+"_img").style.visibility = 'visible';
		}else if("${userHistory.episodeIndex}"!=""&&"${userHistory.episodeIndex}"!=null&&historyIndex>40&&historyIndex<=80){
			if (isInit == 0) {
				isInit = 1;
				pageUpDown(1);
			}
			if(pagAllNum==1){
				$("pageDown_span").style.color = "#ffffff";
				$("episode"+(historyIndex-40)+"_span").style.color = "#ffffff";
				$("currepisodeFocus"+(historyIndex-40)+"_img").style.visibility = 'visible';
			}
		}else if("${userHistory.episodeIndex}"!=""&&"${userHistory.episodeIndex}"!=null&&historyIndex>80&&historyIndex<=120){
			if (isInit == 0) {
				isInit = 1;
				pageNext(2);
			}
			if(pagAllNum==2){
				$("pageDown1_span").style.color = "#ffffff";
				$("episode"+(historyIndex-80)+"_span").style.color = "#ffffff";
				$("currepisodeFocus"+(historyIndex-80)+"_img").style.visibility = 'visible';
			}
		}else if("${userHistory.episodeIndex}"!=""&&"${userHistory.episodeIndex}"!=null&&historyIndex>120){
			if (isInit == 0) {
				isInit = 1;
				pageNext(3);
			}
			if(pagAllNum==3){
				$("pageDown2_span").style.color = "#ffffff";
				$("episode"+(historyIndex-120)+"_span").style.color = "#ffffff";
				$("currepisodeFocus"+(historyIndex-120)+"_img").style.visibility = 'visible';
			}
		}
	}else if("${userHistory.episodeIndex}"==""&&pagAllNum==0){
		$("pageUp_span").style.color = "#ffffff";
		$("episode1_span").style.color = "#ffffff";
		$("currepisodeFocus1_img").style.visibility = 'visible';
	}

}	

//主演获得焦点
function starringOnFocus(objId,img){
	$(objId+"_img").src=imgPath+"/"+img+".png";
	$(objId+"_span").style.color="#ffffff";
	$("r_"+objId+"_img").src=imgPath+"/"+img+".png";
	$("r_"+objId+"_span").style.color="#ffffff";
}
function starringOnBlur(objId){
	$(objId+"_img").src=imgPath+"/vodtextBg.png";
	$(objId+"_span").style.color="#1978b8";
	
	$("r_"+objId+"_img").src=imgPath+"/vodtextBg.png";
	$("r_"+objId+"_span").style.color="#1978b8";
}
//集数选中状态
function setOnFocus(objId){
	$(objId+"_img").src=imgPath+"/episodeFocus.png";
	$("r_"+objId+"_img").src=imgPath+"/episodeFocus.png";
	var episode = objId.substring(objId.indexOf("episodeFocus")+12,objId.length);
	$("episode"+episode+"_span").style.color = "#ffffff";
}
function setOnBlur(objId){
	$(objId+"_img").src = imgPath+"/dot.gif";
	$("r_"+objId+"_img").src = imgPath+"/dot.gif";
	var episode = objId.substring(objId.indexOf("episodeFocus")+12,objId.length);
	if($("currepisodeFocus"+episode+"_img").style.visibility!="visible"){
		$("episode"+episode+"_span").style.color = "#1978b8";
	}
}

function resetHtml(){
	for(var i=0;i<40;i++){
			$("episode"+(i+1)+"_div").style.visibility = 'visible';
			$("episode"+(i+1)).style.visibility = 'visible';
	}
	
}

//集数翻页
function pageNext(num){
	pagAllNum=num;
	
	if(num==0){
		if ($("pageUpFocus_img") != null) {
			$("pageUpFocus_img").src = imgPath + "/currNumFocus.png";
			$("pageUp_span").style.color = "#ffffff";
		}
		if ($("pageDownFocus_img") != null) {
			$("pageDownFocus_img").src = imgPath + "/seriesNum.png";
			$("pageDown_span").style.color = "#1978b8";
		}
		if ($("pageDown1Focus_img") != null) {
			$("pageDown1Focus_img").src = imgPath + "/seriesNum.png";
			$("pageDown1_span").style.color = "#1978b8";
		}
		if ($("pageDown2Focus_img") != null) {
			$("pageDown2Focus_img").src = imgPath + "/seriesNum.png";
			$("pageDown2_span").style.color = "#1978b8";
		}
	}else if(num==1){
		if ($("pageDownFocus_img") != null) {
			$("pageDownFocus_img").src = imgPath + "/currNumFocus.png";
			$("pageDown_span").style.color = "#ffffff";
		}
		if ($("pageUpFocus_img") != null) {
			$("pageUpFocus_img").src = imgPath + "/seriesNum.png";
			$("pageUp_span").style.color = "#1978b8";
		}
		if ($("pageDown1Focus_img") != null) {
			$("pageDown1Focus_img").src = imgPath + "/seriesNum.png";
			$("pageDown1_span").style.color = "#1978b8";
		}
		if ($("pageDown2Focus_img") != null) {
			$("pageDown2Focus_img").src = imgPath + "/seriesNum.png";
			$("pageDown2_span").style.color = "#1978b8";
		}
	}else if(num==2){
		if ($("pageDownFocus_img") != null) {
			$("pageDownFocus_img").src = imgPath + "/seriesNum.png";
			$("pageDown_span").style.color = "#1978b8";
		}
		if ($("pageUpFocus_img") != null) {
			$("pageUpFocus_img").src = imgPath + "/seriesNum.png";
			$("pageUp_span").style.color = "#1978b8";
		}
		if ($("pageDown1Focus_img") != null) {
			$("pageDown1Focus_img").src=imgPath+"/currNumFocus.png";
			$("pageDown1_span").style.color = "#ffffff";
		}
		if ($("pageDown2Focus_img") != null) {
			$("pageDown2Focus_img").src=imgPath+"/seriesNum.png";
			$("pageDown2_span").style.color = "#1978b8";
		}
	}else if(num==3){
		if ($("pageDownFocus_img") != null) {
			$("pageDownFocus_img").src = imgPath + "/seriesNum.png";
			$("pageDown_span").style.color = "#1978b8";
		}
		if ($("pageUpFocus_img") != null) {
			$("pageUpFocus_img").src = imgPath + "/seriesNum.png";
			$("pageUp_span").style.color = "#1978b8";
		}
		if ($("pageDown1Focus_img") != null) {
			$("pageDown1Focus_img").src = imgPath + "/seriesNum.png";
			$("pageDown1_span").style.color = "#1978b8";
		}
		if ($("pageDown2Focus_img") != null) {
			$("pageDown2Focus_img").src = imgPath + "/currNumFocus.png";
			$("pageDown2_span").style.color = "#ffffff";
		}
	}
	for(var i=0;i<40;i++){
		if(_episodeNumList[num*40+i]==null){
			$("episodeFocus" +(i+1)+ "_img").src = imgPath+"/dot.gif";
			$("episode"+(i+1)+"_div").style.visibility = 'hidden';
			$("episode"+(i+1)).style.visibility = 'hidden';
			$("episodeFocus"+(i+1)+"_a").style.visibility = 'hidden';
		}else{
			$("episode"+(i+1)+"_div").style.visibility = 'visible';
			$("episode"+(i+1)).style.visibility = 'visible';
			$("episodeFocus"+(i+1)+"_a").style.visibility = 'visible';
			$("episode"+(i+1)+"_span").innerHTML = _episodeNumList[num*40+i];
			$("episodeFocus"+(i+1)+"_a").href = "javascript:playBefore('"+_episodeNumList[num*40+i]+"')";
		}
	}
}

//按键监听上下页
function pageUpDown(num){
	resetHtml();
	pagAllNum = num;
	if(num==0){
		if ($("pageUpFocus_img") != null) {
			$("pageUpFocus_img").src = imgPath + "/currNumFocus.png";
			$("pageUp_span").style.color = "#ffffff";
		}
		if ($("pageDownFocus_img") != null) {
			$("pageDownFocus_img").src = imgPath + "/seriesNum.png";
			$("pageDown_span").style.color = "#1978b8";
		}
		if ($("pageDown1Focus_img") != null) {
			$("pageDown1Focus_img").src = imgPath + "/seriesNum.png";
			$("pageDown1_span").style.color = "#1978b8";
		}
		if ($("pageDown2Focus_img") != null) {
			$("pageDown2Focus_img").src = imgPath + "/seriesNum.png";
			$("pageDown2_span").style.color = "#1978b8";
		}
	}else if(num==1){
		if ($("pageDownFocus_img") != null) {
			$("pageDownFocus_img").src = imgPath + "/currNumFocus.png";
			$("pageDown_span").style.color = "#ffffff";
		}
		if ($("pageUpFocus_img") != null) {
			$("pageUpFocus_img").src = imgPath + "/seriesNum.png";
			$("pageUp_span").style.color = "#1978b8";
		}
		if ($("pageDown1Focus_img") != null) {
			$("pageDown1Focus_img").src = imgPath + "/seriesNum.png";
			$("pageDown1_span").style.color = "#1978b8";
		}
		if ($("pageDown2Focus_img") != null) {
			$("pageDown2Focus_img").src = imgPath + "/seriesNum.png";
			$("pageDown2_span").style.color = "#1978b8";
		}
	}else if(num==2){
		if ($("pageDownFocus_img") != null) {
			$("pageDownFocus_img").src = imgPath + "/seriesNum.png";
			$("pageDown_span").style.color = "#1978b8";
		}
		if ($("pageUpFocus_img") != null) {
			$("pageUpFocus_img").src = imgPath + "/seriesNum.png";
			$("pageUp_span").style.color = "#1978b8";
		}
		if ($("pageDown1Focus_img") != null) {
			$("pageDown1Focus_img").src=imgPath+"/currNumFocus.png";
			$("pageDown1_span").style.color = "#ffffff";
		}
		if ($("pageDown2Focus_img") != null) {
			$("pageDown2Focus_img").src=imgPath+"/seriesNum.png";
			$("pageDown2_span").style.color = "#1978b8";
		}
	}else if(num==3){
		if ($("pageDownFocus_img") != null) {
			$("pageDownFocus_img").src = imgPath + "/seriesNum.png";
			$("pageDown_span").style.color = "#1978b8";
		}
		if ($("pageUpFocus_img") != null) {
			$("pageUpFocus_img").src = imgPath + "/seriesNum.png";
			$("pageUp_span").style.color = "#1978b8";
		}
		if ($("pageDown1Focus_img") != null) {
			$("pageDown1Focus_img").src = imgPath + "/seriesNum.png";
			$("pageDown1_span").style.color = "#1978b8";
		}
		if ($("pageDown2Focus_img") != null) {
			$("pageDown2Focus_img").src = imgPath + "/currNumFocus.png";
			$("pageDown2_span").style.color = "#ffffff";
		}
	}
	for(var i=0;i<40;i++){
		if(_episodeNumList[num*40+i]==null){
			$("episodeFocus" +(i+1)+ "_img").src = imgPath+"/dot.gif";
			$("episode"+(i+1)+"_div").style.visibility = 'hidden';
			$("episode"+(i+1)).style.visibility = 'hidden';
			$("episodeFocus"+(i+1)+"_a").style.visibility = 'hidden';
		}else{
			$("episode"+(i+1)+"_div").style.visibility = 'visible';
			$("episode"+(i+1)).style.visibility = 'visible';
			$("episodeFocus"+(i+1)+"_a").style.visibility = 'visible';
			$("episode"+(i+1)+"_span").innerHTML = _episodeNumList[num*40+i];
			$("episodeFocus"+(i+1)+"_a").href = "javascript:playBefore('"+_episodeNumList[num*40+i]+"')";
		}
	}
	//$("play_a").focus();
}
function pagUp(){
	if(pagAllNum==0){
	}else{
		pagAllNum--;
		pageUpDown(pagAllNum);
		init();
	}
}
function pagDown(){
	var downNum=Math.ceil(totalNums/40)-1;
	if(pagAllNum>=downNum){
	}else{
		pagAllNum++;
		pageUpDown(pagAllNum);
		init();
	}
}

//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名
function menuOnFocus(objId,focusImg){
	document.getElementById(objId+"_img").src=imgPath+"/"+focusImg+".png";
}
//失去焦点事件
function menuOnBlur(objId){
	document.getElementById(objId+"_img").src=imgPath+"/dot.gif";
}

function goUp(){
	pagUp();
	init();
} 
function goDown(){
 	pagDown();
	init();
}
function goNext(num){
 	pageNext(num);
	init();
}
 
function eventHandler(eventObj){
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
			pagUp();
			return 0;
	    	break;
	    case "SITV_KEY_PAGEDOWN":
			pagDown();
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

function back(){
 	returnToBizOrHistory();
}

function exit(){
 	window.location.href = "${returnHomeUrl}";
}

function returnToBizOrHistory(){
	history.back();
}

</script>
<epg:body onload="init();" bgcolor="#000000" width="1280" height="720">
<div id="leftDiv">
	<!-- 背景图片以及头部图片 -->
	<epg:img src="./images/HD_SD_series_detail.jpg" id="main" left="0" top="0" width="640" height="720" />
	<epg:img src="./images/logo.png" left="0" top="0" width="175" height="85" />

	<!-- 播放收藏 -->
	<!-- 提示上次观看到的集数 -->
	<epg:if test="${userHistory.episodeIndex!=null}">
		<div style="position: absolute; left: 385px; top: 156px; width: 90px; height: 25px;">
			<font color="#333333" style="font-size: 12px">上次看到</font> <font color="#2e7eb9" style="font-size: 12px"> <epg:if test="${userHistory.episodeIndex!=null}">${userHistory.episodeIndex}</epg:if>
			</font><font color="#333333" style="font-size: 12px">/${series.episodeNumber}</font>
		</div>
	</epg:if>
	<!-- 更新至多少集 -->
	<epg:if test="${fn:length(renewNum)<series.episodeNumber}">
		<div style="position: absolute; left: 385px; top: 113px; width: 90px; height: 25px;">
			<font color="#333333" style="font-size: 12px">更新至第</font><font color="#2e7eb9" style="font-size: 12px">${renewNum[fn:length(renewNum)-1].episodeIndex}</font><font color="#333333" style="font-size: 12px">集</font>
		</div>
	</epg:if>
	
	<!-- 第几集按钮 -->
	<epg:if test="${userHistory.episodeIndex!=null}">
		<epg:text fontSize="12" color="#1978b8" id="playTitle" left="195" top="156" width="42" height="35" align="left" text="第${userHistory.episodeIndex}集"></epg:text>
		<epg:img id="play" onblur="blurCurId('play');" left="175" top="151" onfocus="focusCurId('play','seriesPlay')" src="./images/dot.gif" width="65" height="30" href="#" onclick="javascript:playBefore('${userHistory.episodeIndex}')" />
	</epg:if>
	<epg:if test="${userHistory.episodeIndex==null}">
		<epg:text fontSize="12" color="#1978b8" id="playTitle" left="195" top="156" width="42" height="35" align="left" text="第${episodes[0].episodeIndex}集"></epg:text>
		<epg:img id="play" onblur="blurCurId('play');" left="175" top="151" onfocus="focusCurId('play','seriesPlay')" src="./images/dot.gif" width="65" height="30" href="#" onclick="javascript:playBefore('1')" />
	</epg:if>
	
	<!-- 收藏，高标清按钮 -->
	<epg:if test="${series.hdType=='1'}">
		<epg:if test="${SDrelContent!=null}">
			<epg:if test="${SDrelContent.relCodeFlag==1}">
				<epg:navUrl obj="${SDrelContent}" indexUrlVar="SDplayUrl" />
				<epg:img onblur="itemOnBlur('goHDorSDFocus');" left="245" top="151" onfocus="itemOnFocus('goHDorSDFocus','goSDFocus')" src="./images/goSDBtn.png" width="65" height="30" href="${SDplayUrl}" />
				<epg:navUrl obj="${series}" addCollectionUrlVar="addCollectionUrl" />
				<epg:img onblur="itemOnBlur('addCol');" left="315" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="./images/addColBtn.png" width="65" height="30" href="javascript:addCollection()" />
				<epg:img id="addCol" left="315" top="151" src="./images/dot.gif" width="65" height="30" />
			</epg:if>
			<epg:if test="${SDrelContent.relCodeFlag==0}">
				<epg:navUrl obj="${series}" addCollectionUrlVar="addCollectionUrl" />
				<epg:img onblur="itemOnBlur('addCol');" left="245" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="./images/addColBtn.png" width="65" height="30" href="javascript:addCollection()" />
				<epg:img id="addCol" left="245" top="151" src="./images/dot.gif" width="65" height="30" />
			</epg:if>
		</epg:if>
		<epg:if test="${SDrelContent==null}">
			<epg:navUrl obj="${series}" addCollectionUrlVar="addCollectionUrl" />
			<epg:img onblur="itemOnBlur('addCol');" left="245" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="./images/addColBtn.png" width="65" height="30" href="javascript:addCollection()" />
			<epg:img id="addCol" left="245" top="151" src="./images/dot.gif" width="65" height="30" />
		</epg:if>
	</epg:if>
	<epg:if test="${series.hdType=='0'}">
		<epg:if test="${HDrelContent!=null}">
			<epg:if test="${HDrelContent.relCodeFlag==1}">
				<epg:navUrl obj="${HDrelContent}" indexUrlVar="HDplayUrl" />
				<epg:img onblur="itemOnBlur('goHDorSDFocus');" left="245" top="151" onfocus="itemOnFocus('goHDorSDFocus','goHDFocus')" src="./images/goHDBtn.png" width="65" height="30" href="${HDplayUrl}" />

				<epg:navUrl obj="${series}" addCollectionUrlVar="addCollectionUrl" />
				<epg:img onblur="itemOnBlur('addCol');" left="315" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="./images/addColBtn.png" width="65" height="30" href="javascript:addCollection()" />
				<epg:img id="addCol" left="315" top="151" src="./images/dot.gif" width="65" height="30" />
			</epg:if>
			<epg:if test="${HDrelContent.relCodeFlag==0}">
				<epg:navUrl obj="${series}" addCollectionUrlVar="addCollectionUrl" />
				<epg:img onblur="itemOnBlur('addCol');" left="245" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="./images/addColBtn.png" width="65" height="30" href="javascript:addCollection()" />
				<epg:img id="addCol" left="245" top="151" src="./images/dot.gif" width="65" height="30" />
			</epg:if>
		</epg:if>
		<epg:if test="${HDrelContent==null}">
			<epg:navUrl obj="${series}" addCollectionUrlVar="addCollectionUrl" />
			<epg:img onblur="itemOnBlur('addCol');" left="245" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="./images/addColBtn.png" width="65" height="30" href="javascript:addCollection()" />
			<epg:img id="addCol" left="245" top="151" src="./images/dot.gif" width="65" height="30" />
		</epg:if>
	</epg:if>
	<epg:img id="goHDorSDFocus" left="245" top="151" src="./images/dot.gif" width="65" height="30" />

	<!-- 搜索,收藏,历史,返回 -->
	<epg:img src="./images/dot.gif" id="ss" left="475" top="47" width="40" height="38" href="${context['EPG_SEARCH_URL']}" onfocus="itemOnFocus('ss','focusMenuTop_1');" onblur="itemOnBlur('ss');" />
	<epg:img src="./images/dot.gif" id="zz" left="525" top="47" width="40" height="38" href="${context['EPG_SELF_URL']}" onfocus="itemOnFocus('zz','zizhuFocus');" onblur="itemOnBlur('zz');" />
	<epg:img src="./images/dot.gif" id="zn" left="575" top="47" width="40" height="38" href="javascript:back();" onfocus="itemOnFocus('zn','focusMenuTop_3');" onblur="itemOnBlur('zn');" />
	
	<!-- logo处高标清图标 -->
	<epg:if test="${fn:startsWith(series.title,'HD_') == true }">
		<epg:img src="./images/hd_theater_title.png" left="114" top="42" width="59" height="44" />
	</epg:if>
	<epg:if test="${fn:startsWith(series.title,'HD_') != true }">
		<epg:img src="./images/sd_theater_title.png" left="114" top="42" width="59" height="44" />
	</epg:if>

	<!-- 节目名 -->
	<epg:text fontSize="16" color="#e74c3c" left="175" top="101" width="310" height="50" align="left" chineseCharNumber="17" dotdotdot="…" text="${series.title}"></epg:text>
	<!-- 导演 -->
	<epg:text fontSize="12" color="#333333" left="40" top="433" width="40" height="27" align="left" text="导演："></epg:text>
	<epg:if test="${series.director!=null}">
		<epg:text id="directorImg" fontSize="12" color="#333333" left="68" top="433" width="85" height="30" chineseCharNumber="8" align="left" dotdotdot="…" text="${series.director}"></epg:text>
	</epg:if>
	<epg:if test="${series.director==''}">
		<epg:text id="directorImg" fontSize="12" color="#333333" left="68" top="433" width="85" height="30" chineseCharNumber="8" align="left" dotdotdot="…" text="无"></epg:text>
	</epg:if>
	<!-- 主演 -->
	<epg:text fontSize="12" color="#333333" left="40" top="465" width="40" height="27" align="left" text="主演："></epg:text>
	<epg:set var="actors" value="${fn:replace(series.actors, '，',',')}"></epg:set>
	<epg:set var="actors" value="${fn:split(actors, ',')}"></epg:set>
	<epg:if test="${actors==''}">
		<epg:text fontSize="12" color="#333333" left="68" top="465" width="66" height="22" align="left" text="无"></epg:text>
	</epg:if>
	<epg:text fontSize="12" color="#333333" left="68" top="465" chineseCharNumber="8" dotdotdot="…" width="100" height="22" align="left" text="${actors[0]}"></epg:text>
	<epg:text fontSize="12" color="#333333" left="68" top="505" chineseCharNumber="8" dotdotdot="…" width="100" height="22" align="left" text="${actors[1]}"></epg:text>
	<epg:text fontSize="12" color="#333333" left="68" top="545" chineseCharNumber="8" dotdotdot="…" width="100" height="22" align="left" text="${actors[2]}"></epg:text>
	<epg:text fontSize="12" color="#333333" left="68" top="585" chineseCharNumber="8" dotdotdot="…" width="100" height="22" align="left" text="${actors[3]}"></epg:text>

	<!-- 内容详情 -->
	<epg:text fontSize="12" color="#333333" id="info" left="467" top="152" width="197" height="35" align="left" text="剧情简介："></epg:text>
	<epg:text fontSize="12" color="#333333" id="info" left="467" top="184" width="197" height="35" align="left" text="${summarys[0].content}"></epg:text>
	<epg:text fontSize="12" color="#333333" id="info" left="467" top="216" width="197" height="35" align="left" text="${summarys[1].content}"></epg:text>
	<epg:text fontSize="12" color="#333333" id="info" left="467" top="248" width="197" height="35" align="left" text="${summarys[2].content}"></epg:text>
	<epg:text fontSize="12" color="#333333" id="info" left="467" top="280" width="197" height="35" align="left" text="${summarys[3].content}"></epg:text>
	<epg:text fontSize="12" color="#333333" id="info" left="467" top="312" width="197" height="35" align="left" text="${summarys[4].content}"></epg:text>
	<epg:text fontSize="12" color="#333333" id="info" left="467" top="344" width="197" height="35" align="left" text="${summarys[5].content}"></epg:text>
	<epg:text fontSize="12" color="#333333" id="info" left="467" top="376" width="197" height="35" align="left" text="${summarys[6].content}"></epg:text>
	<epg:text fontSize="12" color="#333333" id="info" left="467" top="408" width="197" height="35" align="left" text="${summarys[7].content}"></epg:text>
	<!-- 内容海报 -->
	<epg:img id="poster" left="40" top="94" width="110" height="330" src="../${series.icon}" />

	<!-- 每一集内容 -->
	<epg:resource src="./images/numbg.png" realSrcVar="numbg" />
	<epg:forEach begin="0" end="4" varStatus="rowStatus">
		<epg:forEach begin="0" end="7" varStatus="colStatus">
			<epg:if test="${episodes[rowStatus.index*8+colStatus.index].episodeIndex!=null}">
				<div id="episode${rowStatus.index*8+colStatus.index+1}_div" style="position:absolute;background-image:url('${numbg}');left:${175+colStatus.index*35}px;top:${190+rowStatus.index*40}px;width:30px;height:30px;"></div>
				<epg:img id="currepisodeFocus${rowStatus.index*8+colStatus.index+1}" style="visibility:hidden;" left="${175+colStatus.index*35}" top="${190+rowStatus.index*40}" width="30" height="30" src="./images/currFocus.png" />

				<epg:img id="episodeFocus${rowStatus.index*8+colStatus.index+1}" onfocus="setOnFocus('episodeFocus${rowStatus.index*8+colStatus.index+1}')" onblur="setOnBlur('episodeFocus${rowStatus.index*8+colStatus.index+1}')"
					href="javascript:playBefore('${episodes[rowStatus.index*8+colStatus.index].episodeIndex}')" left="${175+colStatus.index*35}" top="${190+rowStatus.index*40}" width="30" height="30" src="./images/dot.gif" />
				<epg:text id="episode${rowStatus.index*8+colStatus.index+1}" left="${178+colStatus.index*35}" top="${195+rowStatus.index*40}" width="23" height="30" align="center" color="#1978b8" fontSize="22" text="${episodes[rowStatus.index*8+colStatus.index].episodeIndex}" />
			</epg:if>
			<epg:if test="${episodes[rowStatus.index*8+colStatus.index].episodeIndex==null}">
				<div id="episode${rowStatus.index*8+colStatus.index+1}_div" style="position:absolute;background-color:#0f4071;visibility:hidden;left:${175+colStatus.index*35}px;top:${190+rowStatus.index*40}px;width:30px;height:30px;"></div>
				<epg:img id="currepisodeFocus${rowStatus.index*8+colStatus.index+1}" style="position:absolute;visibility:hidden;" left="${175+colStatus.index*35}" top="${190+rowStatus.index*40}" width="30" height="30" src="./images/currFocus.png" />

				<epg:img id="episodeFocus${rowStatus.index*8+colStatus.index+1}" href="#" style="position:absolute;visibility:hidden;" left="${175+colStatus.index*35}" top="${190+rowStatus.index*40}" width="30" height="30" src="./images/dot.gif" />

				<epg:text id="episode${rowStatus.index*8+colStatus.index+1}" left="${178+colStatus.index*35}" top="${195+rowStatus.index*40}" width="23" height="30" align="center" color="#ffffff" fontSize="22"></epg:text>
			</epg:if>
		</epg:forEach>
	</epg:forEach>
	
	<epg:choose>
		<epg:when test="${fn:length(renewNum)<40}">
			<epg:img id="pageUp" left="175" top="394" src="./images/seriesNum.png" width="65" height="30" />
			<epg:img id="pageUpFocus" onblur="changeColor(1,'pageUp','seriesNum');" left="175" top="394" onfocus="changeColor(0,'pageUp','seriesNumFocus')" src="./images/currNumFocus.png" width="65" height="30" href="#" />
			<epg:text id="pageUp" left="175" top="398" width="65" height="30" align="center" color="#1978b8" fontSize="22">${renewNum[0].episodeIndex}-${renewNum[fn:length(renewNum)-1].episodeIndex}</epg:text>
		</epg:when>
		<epg:when test="${fn:length(renewNum)==40}">
			<epg:img id="pageUp" left="175" top="394" src="./images/seriesNum.png" width="65" height="30" />
			<epg:img id="pageUpFocus" onblur="changeColor(1,'pageUp','seriesNum');" left="175" top="394" onfocus="changeColor(0,'pageUp','seriesNumFocus')" src="./images/currNumFocus.png" width="65" height="30" href="#" />
			<epg:text id="pageUp" left="175" top="398" width="65" height="30" align="center" color="#1978b8" fontSize="22">${renewNum[0].episodeIndex}-${renewNum[39].episodeIndex}</epg:text>
		</epg:when>
		<epg:when test="${fn:length(renewNum)>40 && fn:length(renewNum)<=80}">
			<epg:img id="pageUp" left="175" top="394" src="./images/seriesNum.png" width="65" height="30" />
			<epg:img id="pageDown" left="245" top="394" src="./images/seriesNum.png" width="65" height="30" />
			<epg:img id="pageUpFocus" onblur="changeColor(1,'pageUp','seriesNum');" left="175" top="394" onfocus="changeColor(0,'pageUp','seriesNumFocus')" pageop="up" keyop="pageup" src="./images/currNumFocus.png" width="65" height="30" href="javascript:goUp();" />
			<epg:img id="pageDownFocus" onblur="changeColor(1,'pageDown','seriesNum');" left="245" top="394" onfocus="changeColor(0,'pageDown','seriesNumFocus')" pageop="down" keyop="pagedown" src="./images/dot.gif" width="65" height="30" href="javascript:goDown();" />
			<epg:text id="pageUp" left="175" top="398" width="65" height="30" align="center" color="#1978b8" fontSize="12">${renewNum[0].episodeIndex}-${renewNum[39].episodeIndex}</epg:text>
			<epg:text id="pageDown" left="245" top="398" width="65" height="30" align="center" color="#1978b8" fontSize="12">${renewNum[40].episodeIndex}-${renewNum[fn:length(renewNum)-1].episodeIndex}</epg:text>
		</epg:when>
		<epg:when test="${fn:length(renewNum)>80 && fn:length(renewNum)<=120}">
			<epg:img id="pageUp" left="175" top="394" src="./images/seriesNum.png" width="65" height="30" />
			<epg:img id="pageUpFocus" onblur="changeColor(1,'pageUp','seriesNum');" left="175" top="394" onfocus="changeColor(0,'pageUp','seriesNumFocus')" src="./images/currNumFocus.png" width="65" height="30" href="javascript:goNext(0);" />

			<epg:text id="pageUp" left="175" top="398" width="65" height="30" align="center" color="#1978b8" fontSize="12">${renewNum[0].episodeIndex}-${renewNum[39].episodeIndex}</epg:text>
			<epg:img id="pageDown" left="245" top="394" src="./images/seriesNum.png" width="65" height="30" />
			<epg:img id="pageDownFocus" onblur="changeColor(1,'pageDown','seriesNum');" left="245" top="394" onfocus="changeColor(0,'pageDown','seriesNumFocus')" src="./images/dot.gif" width="65" height="30" href="javascript:goNext(1);" />

			<epg:text id="pageDown" left="245" top="398" width="65" height="30" align="center" color="#1978b8" fontSize="12">${renewNum[40].episodeIndex}-${renewNum[79].episodeIndex}</epg:text>
			<epg:img id="pageDown1" left="315" top="394" src="./images/seriesNum.png" width="65" height="30" />
			<epg:img id="pageDown1Focus" onblur="changeColor(1,'pageDown1','seriesNum');" left="315" top="394" onfocus="changeColor(0,'pageDown1','seriesNumFocus')" src="./images/dot.gif" width="65" height="30" href="javascript:goNext(2);" />

			<epg:text id="pageDown1" left="315" top="398" width="65" height="30" align="center" color="#1978b8" fontSize="12">${renewNum[80].episodeIndex}-${renewNum[fn:length(renewNum)-1].episodeIndex}</epg:text>
			<div style="position: absolute; visibility: hidden; left: 175px; top: 371px; width: 65px; height: 30px;">
				<epg:img src="./images/dot.gif" width="65" height="30" pageop="up" keyop="pageup" href="javascript:pagUp()" />
			</div>
			<div style="position: absolute; visibility: hidden; left: 245px; top: 371px; width: 65px; height: 30px;">
				<epg:img src="./images/dot.gif" width="65" height="30" pageop="down" keyop="pagedown" href="javascript:pagDown()" />
			</div>
		</epg:when>
		<epg:when test="fn:length(renewNum)>120}">
			<epg:img id="pageUp" left="175" top="394" src="./images/seriesNum.png" width="65" height="30" />
			<epg:img id="pageUpFocus" onblur="changeColor(1,'pageUp','seriesNum');" left="175" top="394" onfocus="changeColor(0,'pageUp','seriesNumFocus')" src="./images/currNumFocus.png" width="65" height="30" href="javascript:goNext(0);" />
			<epg:text id="pageUp" left="175" top="398" width="65" height="30" align="center" color="#1978b8" fontSize="12">${renewNum[0].episodeIndex}-${renewNum[39].episodeIndex}</epg:text>
			
			<epg:img id="pageDown" left="245" top="394" src="./images/seriesNum.png" width="65" height="30" />
			<epg:img id="pageDownFocus" onblur="changeColor(1,'pageDown','seriesNum');" left="245" top="394" onfocus="changeColor(0,'pageDown','seriesNumFocus')" src="./images/dot.gif" width="65" height="30" href="javascript:goNext(1);" />
			<epg:text id="pageDown" left="245" top="398" width="65" height="30" align="center" color="#1978b8" fontSize="12">${renewNum[40].episodeIndex}-${renewNum[79].episodeIndex}</epg:text>
			
			<epg:img id="pageDown1" left="315" top="394" src="./images/seriesNum.png" width="65" height="30" />
			<epg:img id="pageDown1Focus" onblur="changeColor(1,'pageDown1','seriesNum');" left="315" top="394" onfocus="changeColor(0,'pageDown1','seriesNumFocus')" src="./images/dot.gif" width="65" height="30" href="javascript:goNext(2);" />
			<epg:text id="pageDown1" left="315" top="398" width="65" height="30" align="center" color="#1978b8" fontSize="12">${renewNum[80].episodeIndex}-${renewNum[119].episodeIndex}</epg:text>
			
			<epg:img id="pageDown2" left="385" top="394" src="./images/seriesNum.png" width="65" height="30" />
			<epg:img id="pageDown2Focus" onblur="changeColor(1,'pageDown2','seriesNum');" left="385" top="394" onfocus="changeColor(0,'pageDown2','seriesNumFocus')" src="./images/dot.gif" width="65" height="30" href="javascript:goNext(3);" />
			<epg:text id="pageDown2" left="385" top="398" width="65" height="30" align="center" color="#1978b8" fontSize="12">${renewNum[120].episodeIndex}-${renewNum[fn:length(renewNum)-1].episodeIndex}</epg:text>
			
			<div style="position: absolute; visibility: hidden; left: 175px; top: 391px; width: 65px; height: 30px;">
				<epg:img src="./images/dot.gif" width="65" height="30" pageop="up" keyop="pageup" href="javascript:pagUp();init();" />
			</div>
			<div style="position: absolute; visibility: hidden; left: 245px; top: 391px; width: 65px; height: 30px;">
				<epg:img src="./images/dot.gif" width="65" height="30" pageop="down" keyop="pagedown" href="javascript:pagDown();init();" />
			</div>
		</epg:when>
	</epg:choose>

	<!-- 看过此片的人还关注 -->
	<epg:if test="${bottomCategoryItems[0]!=null}">
		<epg:img id="posterImg0" src="./images/dot.gif" left="173" top="465" width="68" height="201" />
		<epg:navUrl obj="${bottomCategoryItems[0]}" indexUrlVar="indexUrl1"></epg:navUrl>
		<epg:img id="poster1" src="../${bottomCategoryItems[0].still}" left="175" top="468" width="65" height="195" />
		<epg:img id="poster1focus" src="./images/dot.gif" left="175" top="468" width="65" height="195" href="${indexUrl1}&returnTo=biz" onfocus="textOnFocus('0','orange3','categoryList0_titlediv','${bottomCategoryItems[0].title}');" onblur="textOnBlur('posterImg0','categoryList0_titlediv');" />
		<div id="categoryList0_titlediv" style="position: absolute; font-size: 12; font-family: '黑体'; color: #FFFFFF; text-align: center; background-color: #f79922; visibility: hidden; left: 175px; top: 633px; width: 65px; height: 31px; z-index: 1;">
			<div id="posterImg0" align="center" style="position: absolute; left: 0px; top: 3px; width: 65px; height: 26px">
				<span id="posterImg0_span" style="color: #ffffff; font-size: 12;"></span>
			</div>
		</div>
	</epg:if>

	<epg:if test="${bottomCategoryItems[1]!=null}">
		<epg:img id="posterImg1" src="./images/dot.gif" left="263" top="465" width="68" height="201" />
		<epg:navUrl obj="${bottomCategoryItems[1]}" indexUrlVar="indexUrl2"></epg:navUrl>
		<epg:img id="poster2" src="../${bottomCategoryItems[1].still}" left="265" top="468" width="65" height="195" />
		<epg:img id="poster2focus" src="./images/dot.gif" left="265" top="468" width="65" height="195" href="${indexUrl2}&returnTo=biz" onfocus="textOnFocus('1','orange3','categoryList1_titlediv','${bottomCategoryItems[1].title}');" onblur="textOnBlur('posterImg1','categoryList1_titlediv');" />
		<div id="categoryList1_titlediv" style="position: absolute; font-size: 12; font-family: '黑体'; color: #FFFFFF; text-align: center; background-color: #f79922; visibility: hidden; left: 265px; top: 633px; width: 65px; height: 31px; z-index: 1;">
			<div id="posterImg1" align="center" style="position: absolute; left: 0px; top: 3px; width: 65px; height: 26px">
				<span id="posterImg1_span" style="color: #ffffff; font-size: 12; height: 26px"></span>
			</div>
		</div>
	</epg:if>

	<epg:if test="${bottomCategoryItems[2]!=null}">
		<epg:img id="posterImg2" src="./images/dot.gif" left="353" top="465" width="68" height="201" />
		<epg:navUrl obj="${bottomCategoryItems[2]}" indexUrlVar="indexUrl3"></epg:navUrl>
		<epg:img id="poster3" src="../${bottomCategoryItems[2].still}" left="355" top="468" width="65" height="195" />
		<epg:img id="poster3focus" src="./images/dot.gif" left="355" top="468" width="65" height="195" href="${indexUrl3}&returnTo=biz" onfocus="textOnFocus('2','orange3','categoryList2_titlediv','${bottomCategoryItems[2].title}');" onblur="textOnBlur('posterImg2','categoryList2_titlediv');" />
		<div id="categoryList2_titlediv" style="position: absolute; font-size: 12; font-family: '黑体'; color: #FFFFFF; text-align: center; background-color: #f79922; visibility: hidden; left: 355px; top: 633px; width: 65px; height: 31px; z-index: 1;">
			<div id="posterImg2" align="center" style="position: absolute; left: 0px; top: 3px; width: 65px; height: 26px">
				<span id="posterImg2_span" style="color: #ffffff; font-size: 12;"></span>
			</div>
		</div>
	</epg:if>
	
	<epg:if test="${bottomCategoryItems[3]!=null}">
		<epg:img id="posterImg3" src="./images/dot.gif" left="443" top="465" width="68" height="201" />
		<epg:navUrl obj="${bottomCategoryItems[3]}" indexUrlVar="indexUrl4"></epg:navUrl>
		<epg:img id="poster4" src="../${bottomCategoryItems[3].still}" left="445" top="468" width="65" height="195" />
		<epg:img id="poster4focus" src="./images/dot.gif" left="445" top="468" width="65" height="195" href="${indexUrl4}&returnTo=biz" onfocus="textOnFocus('3','orange3','categoryList3_titlediv','${bottomCategoryItems[3].title}');" onblur="textOnBlur('posterImg3','categoryList3_titlediv');" />
		<div id="categoryList3_titlediv" style="position: absolute; font-size: 12; font-family: '黑体'; color: #FFFFFF; text-align: center; background-color: #f79912; visibility: hidden; left: 445px; top: 633px; width: 65px; height: 31px; z-index: 1;">
			<div id="posterImg3" align="center" style="position: absolute; left: 0px; top: 3px; width: 65px; height: 26px">
				<span id="posterImg3_span" style="color: #ffffff; font-size: 12;"></span>
			</div>
		</div>
	</epg:if>
	
	<epg:if test="${bottomCategoryItems[4]!=null}">
		<epg:img id="posterImg4" src="./images/dot.gif" left="533" top="465" width="68" height="201" />
		<epg:navUrl obj="${bottomCategoryItems[4]}" indexUrlVar="indexUrl5"></epg:navUrl>
		<epg:img id="poster5" src="../${bottomCategoryItems[4].still}" left="535" top="468" width="65" height="195" />
		<epg:img id="poster5focus" src="./images/dot.gif" left="535" top="468" width="65" height="195" href="${indexUrl5}&returnTo=biz" onfocus="textOnFocus('4','orange3','categoryList4_titlediv','${bottomCategoryItems[4].title}');" onblur="textOnBlur('posterImg4','categoryList4_titlediv');" />
		<div id="categoryList4_titlediv" style="position: absolute; font-size: 12; font-family: '黑体'; color: #FFFFFF; text-align: center; background-color: #f79912; visibility: hidden; left: 535px; top: 633px; width: 65px; height: 31px; z-index: 1;">
			<div id="posterImg4" align="center" style="position: absolute; left: 0px; top: 3px; width: 65px; height: 26px">
				<span id="posterImg4_span" style="color: #ffffff; font-size: 12;"></span>
			</div>
		</div>
	</epg:if>

	<!-- 收藏提示框 -->
	<div id="collectSuccess" style="display: none;">
		<epg:img id="tip" src="./images/collectSuccess.png" left="0" top="0" width="640" height="720" />
		<epg:text id="successTs" fontSize="12" color="#565656" left="200" top="327" width="240" height="30" align="center" chineseCharNumber="17" text=""></epg:text>
	</div>
	<div id="collectFail" style="display: none;">
		<epg:img id="tip" src="./images/collectFail.png" left="0" top="0" width="640" height="720" />
		<epg:text id="failTs" fontSize="12" color="#565656" left="200" top="327" width="240" height="30" align="center" chineseCharNumber="17" text=""></epg:text>
	</div>
	<div id="tsBtn" style="display: none;">
		<epg:img id="Collection" left="240" top="412" onfocus="itemOnFocus('Collection','enterColl');" onblur="itemOnBlur('Collection');" src="./images/dot.gif" width="65" height="40" href="${context['EPG_MYCOLLECTION_URL']}" />
		<epg:img id="enter" left="335" top="412" onfocus="itemOnFocus('enter','closeWin');" onblur="itemOnBlur('enter');" src="./images/dot.gif" width="65" height="40" href="javascript:hiddenTip()" />
	</div>
</div>

<div id="rightDiv">
	<!-- 背景图片以及头部图片 -->
	<epg:img src="./images/HD_SD_series_detail.jpg" id="r_main" left="640" top="0" width="640" height="720" />
	<epg:img src="./images/logo.png" left="640" top="0" width="175" height="85" />

	<!-- 播放收藏 -->
	<!-- 提示上次观看到的集数 -->
	<epg:if test="${userHistory.episodeIndex!=null}">
		<div style="position: absolute; left: 1025px; top: 156px; width: 90px; height: 25px;">
			<font color="#333333" style="font-size: 12px">上次看到</font> <font color="#2e7eb9" style="font-size: 12px"> <epg:if test="${userHistory.episodeIndex!=null}">${userHistory.episodeIndex}</epg:if>
			</font><font color="#333333" style="font-size: 12px">/${series.episodeNumber}</font>
		</div>
	</epg:if>
	<!-- 更新至多少集 -->
	<epg:if test="${fn:length(renewNum)<series.episodeNumber}">
		<div style="position: absolute; left: 1025px; top: 113px; width: 90px; height: 25px;">
			<font color="#333333" style="font-size: 12px">更新至第</font><font color="#2e7eb9" style="font-size: 12px">${renewNum[fn:length(renewNum)-1].episodeIndex}</font><font color="#333333" style="font-size: 12px">集</font>
		</div>
	</epg:if>
	
	<!-- 第几集按钮 -->
	<epg:if test="${userHistory.episodeIndex!=null}">
		<epg:text fontSize="12" color="#1978b8" id="r_playTitle" left="835" top="156" width="42" height="35" align="left" text="第${userHistory.episodeIndex}集"></epg:text>
		<epg:img id="r_play" onblur="blurCurId('play');" left="815" top="151" onfocus="focusCurId('play','seriesPlay')" src="./images/dot.gif" width="65" height="30" href="#" onclick="javascript:playBefore('${userHistory.episodeIndex}')" />
	</epg:if>
	<epg:if test="${userHistory.episodeIndex==null}">
		<epg:text fontSize="12" color="#1978b8" id="r_playTitle" left="835" top="156" width="42" height="35" align="left" text="第${episodes[0].episodeIndex}集"></epg:text>
		<epg:img id="r_play" onblur="blurCurId('play');" left="815" top="151" onfocus="focusCurId('play','seriesPlay')" src="./images/dot.gif" width="65" height="30" href="#" onclick="javascript:playBefore('1')" />
	</epg:if>
	
	<!-- 收藏，高标清按钮 -->
	<epg:if test="${series.hdType=='1'}">
		<epg:if test="${SDrelContent!=null}">
			<epg:if test="${SDrelContent.relCodeFlag==1}">
				<epg:navUrl obj="${SDrelContent}" indexUrlVar="SDplayUrl" />
				<epg:img onblur="itemOnBlur('goHDorSDFocus');" left="885" top="151" onfocus="itemOnFocus('goHDorSDFocus','goSDFocus')" src="./images/goSDBtn.png" width="65" height="30" href="${SDplayUrl}" />
				<epg:navUrl obj="${series}" addCollectionUrlVar="addCollectionUrl" />
				<epg:img onblur="itemOnBlur('addCol');" left="955" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="./images/addColBtn.png" width="65" height="30" href="javascript:addCollection()" />
				<epg:img id="r_addCol" left="955" top="151" src="./images/dot.gif" width="65" height="30" />
			</epg:if>
			<epg:if test="${SDrelContent.relCodeFlag==0}">
				<epg:navUrl obj="${series}" addCollectionUrlVar="addCollectionUrl" />
				<epg:img onblur="itemOnBlur('addCol');" left="885" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="./images/addColBtn.png" width="65" height="30" href="javascript:addCollection()" />
				<epg:img id="r_addCol" left="885" top="151" src="./images/dot.gif" width="65" height="30" />
			</epg:if>
		</epg:if>
		<epg:if test="${SDrelContent==null}">
			<epg:navUrl obj="${series}" addCollectionUrlVar="addCollectionUrl" />
			<epg:img onblur="itemOnBlur('addCol');" left="885" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="./images/addColBtn.png" width="65" height="30" href="javascript:addCollection()" />
			<epg:img id="r_addCol" left="885" top="151" src="./images/dot.gif" width="65" height="30" />
		</epg:if>
	</epg:if>
	<epg:if test="${series.hdType=='0'}">
		<epg:if test="${HDrelContent!=null}">
			<epg:if test="${HDrelContent.relCodeFlag==1}">
				<epg:navUrl obj="${HDrelContent}" indexUrlVar="HDplayUrl" />
				<epg:img onblur="itemOnBlur('goHDorSDFocus');" left="885" top="151" onfocus="itemOnFocus('goHDorSDFocus','goHDFocus')" src="./images/goHDBtn.png" width="65" height="30" href="${HDplayUrl}" />

				<epg:navUrl obj="${series}" addCollectionUrlVar="addCollectionUrl" />
				<epg:img onblur="itemOnBlur('addCol');" left="955" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="./images/addColBtn.png" width="65" height="30" href="javascript:addCollection()" />
				<epg:img id="r_addCol" left="955" top="151" src="./images/dot.gif" width="65" height="30" />
			</epg:if>
			<epg:if test="${HDrelContent.relCodeFlag==0}">
				<epg:navUrl obj="${series}" addCollectionUrlVar="addCollectionUrl" />
				<epg:img onblur="itemOnBlur('addCol');" left="885" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="./images/addColBtn.png" width="65" height="30" href="javascript:addCollection()" />
				<epg:img id="r_addCol" left="885" top="151" src="./images/dot.gif" width="65" height="30" />
			</epg:if>
		</epg:if>
		<epg:if test="${HDrelContent==null}">
			<epg:navUrl obj="${series}" addCollectionUrlVar="addCollectionUrl" />
			<epg:img onblur="itemOnBlur('addCol');" left="885" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="./images/addColBtn.png" width="65" height="30" href="javascript:addCollection()" />
			<epg:img id="r_addCol" left="885" top="151" src="./images/dot.gif" width="65" height="30" />
		</epg:if>
	</epg:if>
	<epg:img id="r_goHDorSDFocus" left="885" top="151" src="./images/dot.gif" width="65" height="30" />

	<!-- 搜索,收藏,历史,返回 -->
	<epg:img src="./images/dot.gif" id="r_ss" left="1115" top="47" width="40" height="38" href="${context['EPG_SEARCH_URL']}" onfocus="itemOnFocus('ss','focusMenuTop_1');" onblur="itemOnBlur('ss');" />
	<epg:img src="./images/dot.gif" id="r_zz" left="1185" top="47" width="40" height="38" href="${context['EPG_SELF_URL']}" onfocus="itemOnFocus('zz','zizhuFocus');" onblur="itemOnBlur('zz');" />
	<epg:img src="./images/dot.gif" id="r_zn" left="1215" top="47" width="40" height="38" href="javascript:back();" onfocus="itemOnFocus('zn','focusMenuTop_3');" onblur="itemOnBlur('zn');" />
	
	<!-- logo处高标清图标 -->
	<epg:if test="${fn:startsWith(series.title,'HD_') == true }">
		<epg:img src="./images/hd_theater_title.png" left="754" top="42" width="59" height="44" />
	</epg:if>
	<epg:if test="${fn:startsWith(series.title,'HD_') != true }">
		<epg:img src="./images/sd_theater_title.png" left="754" top="42" width="59" height="44" />
	</epg:if>

	<!-- 节目名 -->
	<epg:text fontSize="16" color="#e74c3c" left="815" top="101" width="310" height="50" align="left" chineseCharNumber="17" dotdotdot="…" text="${series.title}"></epg:text>
	<!-- 导演 -->
	<epg:text fontSize="12" color="#333333" left="680" top="433" width="40" height="27" align="left" text="导演："></epg:text>
	<epg:if test="${series.director!=null}">
		<epg:text id="r_directorImg" fontSize="12" color="#333333" left="708" top="433" width="85" height="30" chineseCharNumber="8" align="left" dotdotdot="…" text="${series.director}"></epg:text>
	</epg:if>
	<epg:if test="${series.director==''}">
		<epg:text id="r_directorImg" fontSize="12" color="#333333" left="708" top="433" width="85" height="30" chineseCharNumber="8" align="left" dotdotdot="…" text="无"></epg:text>
	</epg:if>
	<!-- 主演 -->
	<epg:text fontSize="12" color="#333333" left="680" top="465" width="40" height="27" align="left" text="主演："></epg:text>
	<epg:set var="actors" value="${fn:replace(series.actors, '，',',')}"></epg:set>
	<epg:set var="actors" value="${fn:split(actors, ',')}"></epg:set>
	<epg:if test="${actors==''}">
		<epg:text fontSize="12" color="#333333" left="708" top="465" width="66" height="22" align="left" text="无"></epg:text>
	</epg:if>
	<epg:text fontSize="12" color="#333333" left="708" top="465" chineseCharNumber="8" dotdotdot="…" width="100" height="22" align="left" text="${actors[0]}"></epg:text>
	<epg:text fontSize="12" color="#333333" left="708" top="505" chineseCharNumber="8" dotdotdot="…" width="100" height="22" align="left" text="${actors[1]}"></epg:text>
	<epg:text fontSize="12" color="#333333" left="708" top="545" chineseCharNumber="8" dotdotdot="…" width="100" height="22" align="left" text="${actors[2]}"></epg:text>
	<epg:text fontSize="12" color="#333333" left="708" top="585" chineseCharNumber="8" dotdotdot="…" width="100" height="22" align="left" text="${actors[3]}"></epg:text>

	<!-- 内容详情 -->
	<epg:text fontSize="12" color="#333333" id="r_info" left="1107" top="152" width="197" height="35" align="left" text="剧情简介："></epg:text>
	<epg:text fontSize="12" color="#333333" id="r_info" left="1107" top="184" width="197" height="35" align="left" text="${summarys[0].content}"></epg:text>
	<epg:text fontSize="12" color="#333333" id="r_info" left="1107" top="216" width="197" height="35" align="left" text="${summarys[1].content}"></epg:text>
	<epg:text fontSize="12" color="#333333" id="r_info" left="1107" top="248" width="197" height="35" align="left" text="${summarys[2].content}"></epg:text>
	<epg:text fontSize="12" color="#333333" id="r_info" left="1107" top="280" width="197" height="35" align="left" text="${summarys[3].content}"></epg:text>
	<epg:text fontSize="12" color="#333333" id="r_info" left="1107" top="312" width="197" height="35" align="left" text="${summarys[4].content}"></epg:text>
	<epg:text fontSize="12" color="#333333" id="r_info" left="1107" top="344" width="197" height="35" align="left" text="${summarys[5].content}"></epg:text>
	<epg:text fontSize="12" color="#333333" id="r_info" left="1107" top="376" width="197" height="35" align="left" text="${summarys[6].content}"></epg:text>
	<epg:text fontSize="12" color="#333333" id="r_info" left="1107" top="408" width="197" height="35" align="left" text="${summarys[7].content}"></epg:text>
	<!-- 内容海报 -->
	<epg:img id="r_poster" left="680" top="94" width="110" height="330" src="../${series.icon}" />

	<!-- 每一集内容 -->
	<epg:resource src="./images/numbg.png" realSrcVar="numbg" />
	<epg:forEach begin="0" end="4" varStatus="rowStatus">
		<epg:forEach begin="0" end="7" varStatus="colStatus">
			<epg:if test="${episodes[rowStatus.index*8+colStatus.index].episodeIndex!=null}">
				<div id="r_episode${rowStatus.index*8+colStatus.index+1}_div" style="position:absolute;background-image:url('${numbg}');left:${815+colStatus.index*35}px;top:${190+rowStatus.index*40}px;width:30px;height:30px;"></div>
				<epg:img id="r_currepisodeFocus${rowStatus.index*8+colStatus.index+1}" style="visibility:hidden;" left="${815+colStatus.index*35}" top="${190+rowStatus.index*40}" width="30" height="30" src="./images/currFocus.png" />

				<epg:img id="r_episodeFocus${rowStatus.index*8+colStatus.index+1}" onfocus="setOnFocus('episodeFocus${rowStatus.index*8+colStatus.index+1}')" onblur="setOnBlur('episodeFocus${rowStatus.index*8+colStatus.index+1}')"
					href="javascript:playBefore('${episodes[rowStatus.index*8+colStatus.index].episodeIndex}')" left="${815+colStatus.index*35}" top="${190+rowStatus.index*40}" width="30" height="30" src="./images/dot.gif" />
				<epg:text id="r_episode${rowStatus.index*8+colStatus.index+1}" left="${818+colStatus.index*35}" top="${195+rowStatus.index*40}" width="23" height="30" align="center" color="#1978b8" fontSize="22" text="${episodes[rowStatus.index*8+colStatus.index].episodeIndex}" />
			</epg:if>
			<epg:if test="${episodes[rowStatus.index*8+colStatus.index].episodeIndex==null}">
				<div id="r_episode${rowStatus.index*8+colStatus.index+1}_div" style="position:absolute;background-color:#0f4071;visibility:hidden;left:${815+colStatus.index*35}px;top:${190+rowStatus.index*40}px;width:30px;height:30px;"></div>
				<epg:img id="r_currepisodeFocus${rowStatus.index*8+colStatus.index+1}" style="position:absolute;visibility:hidden;" left="${815+colStatus.index*35}" top="${190+rowStatus.index*40}" width="30" height="30" src="./images/currFocus.png" />

				<epg:img id="r_episodeFocus${rowStatus.index*8+colStatus.index+1}" href="#" style="position:absolute;visibility:hidden;" left="${815+colStatus.index*35}" top="${190+rowStatus.index*40}" width="30" height="30" src="./images/dot.gif" />

				<epg:text id="r_episode${rowStatus.index*8+colStatus.index+1}" left="${818+colStatus.index*35}" top="${195+rowStatus.index*40}" width="23" height="30" align="center" color="#ffffff" fontSize="22"></epg:text>
			</epg:if>
		</epg:forEach>
	</epg:forEach>
	
	<epg:choose>
		<epg:when test="${fn:length(renewNum)<40}">
			<epg:img id="r_pageUp" left="815" top="394" src="./images/seriesNum.png" width="65" height="30" />
			<epg:img id="r_pageUpFocus" onblur="changeColor(1,'pageUp','seriesNum');" left="815" top="394" onfocus="changeColor(0,'pageUp','seriesNumFocus')" src="./images/currNumFocus.png" width="65" height="30" href="#" />
			<epg:text id="r_pageUp" left="815" top="398" width="65" height="30" align="center" color="#1978b8" fontSize="22">${renewNum[0].episodeIndex}-${renewNum[fn:length(renewNum)-1].episodeIndex}</epg:text>
		</epg:when>
		<epg:when test="${fn:length(renewNum)==40}">
			<epg:img id="r_pageUp" left="815" top="394" src="./images/seriesNum.png" width="65" height="30" />
			<epg:img id="r_pageUpFocus" onblur="changeColor(1,'pageUp','seriesNum');" left="815" top="394" onfocus="changeColor(0,'pageUp','seriesNumFocus')" src="./images/currNumFocus.png" width="65" height="30" href="#" />
			<epg:text id="r_pageUp" left="815" top="398" width="65" height="30" align="center" color="#1978b8" fontSize="22">${renewNum[0].episodeIndex}-${renewNum[39].episodeIndex}</epg:text>
		</epg:when>
		<epg:when test="${fn:length(renewNum)>40 && fn:length(renewNum)<=80}">
			<epg:img id="r_pageUp" left="815" top="394" src="./images/seriesNum.png" width="65" height="30" />
			<epg:img id="r_pageDown" left="885" top="394" src="./images/seriesNum.png" width="65" height="30" />
			<epg:img id="r_pageUpFocus" onblur="changeColor(1,'pageUp','seriesNum');" left="815" top="394" onfocus="changeColor(0,'pageUp','seriesNumFocus')" pageop="up" keyop="pageup" src="./images/currNumFocus.png" width="65" height="30" href="javascript:goUp();" />
			<epg:img id="r_pageDownFocus" onblur="changeColor(1,'pageDown','seriesNum');" left="885" top="394" onfocus="changeColor(0,'pageDown','seriesNumFocus')" pageop="down" keyop="pagedown" src="./images/dot.gif" width="65" height="30" href="javascript:goDown();" />
			<epg:text id="r_pageUp" left="815" top="398" width="65" height="30" align="center" color="#1978b8" fontSize="12">${renewNum[0].episodeIndex}-${renewNum[39].episodeIndex}</epg:text>
			<epg:text id="r_pageDown" left="885" top="398" width="65" height="30" align="center" color="#1978b8" fontSize="12">${renewNum[40].episodeIndex}-${renewNum[fn:length(renewNum)-1].episodeIndex}</epg:text>
		</epg:when>
		<epg:when test="${fn:length(renewNum)>80 && fn:length(renewNum)<=120}">
			<epg:img id="r_pageUp" left="815" top="394" src="./images/seriesNum.png" width="65" height="30" />
			<epg:img id="r_pageUpFocus" onblur="changeColor(1,'pageUp','seriesNum');" left="815" top="394" onfocus="changeColor(0,'pageUp','seriesNumFocus')" src="./images/currNumFocus.png" width="65" height="30" href="javascript:goNext(0);" />

			<epg:text id="r_pageUp" left="815" top="398" width="65" height="30" align="center" color="#1978b8" fontSize="12">${renewNum[0].episodeIndex}-${renewNum[39].episodeIndex}</epg:text>
			<epg:img id="r_pageDown" left="885" top="394" src="./images/seriesNum.png" width="65" height="30" />
			<epg:img id="r_pageDownFocus" onblur="changeColor(1,'pageDown','seriesNum');" left="885" top="394" onfocus="changeColor(0,'pageDown','seriesNumFocus')" src="./images/dot.gif" width="65" height="30" href="javascript:goNext(1);" />

			<epg:text id="r_pageDown" left="885" top="398" width="65" height="30" align="center" color="#1978b8" fontSize="12">${renewNum[40].episodeIndex}-${renewNum[79].episodeIndex}</epg:text>
			<epg:img id="r_pageDown1" left="955" top="394" src="./images/seriesNum.png" width="65" height="30" />
			<epg:img id="r_pageDown1Focus" onblur="changeColor(1,'pageDown1','seriesNum');" left="955" top="394" onfocus="changeColor(0,'pageDown1','seriesNumFocus')" src="./images/dot.gif" width="65" height="30" href="javascript:goNext(2);" />

			<epg:text id="r_pageDown1" left="955" top="398" width="65" height="30" align="center" color="#1978b8" fontSize="12">${renewNum[80].episodeIndex}-${renewNum[fn:length(renewNum)-1].episodeIndex}</epg:text>
			<div style="position: absolute; visibility: hidden; left: 815px; top: 371px; width: 65px; height: 30px;">
				<epg:img src="./images/dot.gif" width="65" height="30" pageop="up" keyop="pageup" href="javascript:pagUp()" />
			</div>
			<div style="position: absolute; visibility: hidden; left: 885px; top: 371px; width: 65px; height: 30px;">
				<epg:img src="./images/dot.gif" width="65" height="30" pageop="down" keyop="pagedown" href="javascript:pagDown()" />
			</div>
		</epg:when>
		<epg:when test="fn:length(renewNum)>120}">
			<epg:img id="r_pageUp" left="815" top="394" src="./images/seriesNum.png" width="65" height="30" />
			<epg:img id="r_pageUpFocus" onblur="changeColor(1,'pageUp','seriesNum');" left="815" top="394" onfocus="changeColor(0,'pageUp','seriesNumFocus')" src="./images/currNumFocus.png" width="65" height="30" href="javascript:goNext(0);" />
			<epg:text id="r_pageUp" left="815" top="398" width="65" height="30" align="center" color="#1978b8" fontSize="12">${renewNum[0].episodeIndex}-${renewNum[39].episodeIndex}</epg:text>
			
			<epg:img id="r_pageDown" left="885" top="394" src="./images/seriesNum.png" width="65" height="30" />
			<epg:img id="r_pageDownFocus" onblur="changeColor(1,'pageDown','seriesNum');" left="885" top="394" onfocus="changeColor(0,'pageDown','seriesNumFocus')" src="./images/dot.gif" width="65" height="30" href="javascript:goNext(1);" />
			<epg:text id="r_pageDown" left="885" top="398" width="65" height="30" align="center" color="#1978b8" fontSize="12">${renewNum[40].episodeIndex}-${renewNum[79].episodeIndex}</epg:text>
			
			<epg:img id="r_pageDown1" left="955" top="394" src="./images/seriesNum.png" width="65" height="30" />
			<epg:img id="r_pageDown1Focus" onblur="changeColor(1,'pageDown1','seriesNum');" left="955" top="394" onfocus="changeColor(0,'pageDown1','seriesNumFocus')" src="./images/dot.gif" width="65" height="30" href="javascript:goNext(2);" />
			<epg:text id="r_pageDown1" left="955" top="398" width="65" height="30" align="center" color="#1978b8" fontSize="12">${renewNum[80].episodeIndex}-${renewNum[119].episodeIndex}</epg:text>
			
			<epg:img id="r_pageDown2" left="1025" top="394" src="./images/seriesNum.png" width="65" height="30" />
			<epg:img id="r_pageDown2Focus" onblur="changeColor(1,'pageDown2','seriesNum');" left="1025" top="394" onfocus="changeColor(0,'pageDown2','seriesNumFocus')" src="./images/dot.gif" width="65" height="30" href="javascript:goNext(3);" />
			<epg:text id="r_pageDown2" left="1025" top="398" width="65" height="30" align="center" color="#1978b8" fontSize="12">${renewNum[120].episodeIndex}-${renewNum[fn:length(renewNum)-1].episodeIndex}</epg:text>
			
			<div style="position: absolute; visibility: hidden; left: 815px; top: 391px; width: 65px; height: 30px;">
				<epg:img src="./images/dot.gif" width="65" height="30" pageop="up" keyop="pageup" href="javascript:pagUp();init();" />
			</div>
			<div style="position: absolute; visibility: hidden; left: 885px; top: 391px; width: 65px; height: 30px;">
				<epg:img src="./images/dot.gif" width="65" height="30" pageop="down" keyop="pagedown" href="javascript:pagDown();init();" />
			</div>
		</epg:when>
	</epg:choose>

	<!-- 看过此片的人还关注 -->
	<epg:if test="${bottomCategoryItems[0]!=null}">
		<epg:img id="r_posterImg0" src="./images/dot.gif" left="813" top="465" width="68" height="201" />
		<epg:navUrl obj="${bottomCategoryItems[0]}" indexUrlVar="indexUrl1"></epg:navUrl>
		<epg:img id="r_poster1" src="../${bottomCategoryItems[0].still}" left="815" top="468" width="65" height="195" />
		<epg:img id="r_poster1focus" src="./images/dot.gif" left="815" top="468" width="65" height="195" href="${indexUrl1}&returnTo=biz" onfocus="textOnFocus('0','orange3','categoryList0_titlediv','${bottomCategoryItems[0].title}');" onblur="textOnBlur('posterImg0','categoryList0_titlediv');" />
		<div id="r_categoryList0_titlediv" style="position: absolute; font-size: 12; font-family: '黑体'; color: #FFFFFF; text-align: center; background-color: #f79922; visibility: hidden; left: 815px; top: 633px; width: 65px; height: 31px; z-index: 1;">
			<div id="r_posterImg0" align="center" style="position: absolute; left: 0px; top: 3px; width: 65px; height: 26px">
				<span id="r_posterImg0_span" style="color: #ffffff; font-size: 12;"></span>
			</div>
		</div>
	</epg:if>

	<epg:if test="${bottomCategoryItems[1]!=null}">
		<epg:img id="r_posterImg1" src="./images/dot.gif" left="903" top="465" width="68" height="201" />
		<epg:navUrl obj="${bottomCategoryItems[1]}" indexUrlVar="indexUrl2"></epg:navUrl>
		<epg:img id="r_poster2" src="../${bottomCategoryItems[1].still}" left="905" top="468" width="65" height="195" />
		<epg:img id="r_poster2focus" src="./images/dot.gif" left="905" top="468" width="65" height="195" href="${indexUrl2}&returnTo=biz" onfocus="textOnFocus('1','orange3','categoryList1_titlediv','${bottomCategoryItems[1].title}');" onblur="textOnBlur('posterImg1','categoryList1_titlediv');" />
		<div id="r_categoryList1_titlediv" style="position: absolute; font-size: 12; font-family: '黑体'; color: #FFFFFF; text-align: center; background-color: #f79922; visibility: hidden; left: 905px; top: 633px; width: 65px; height: 31px; z-index: 1;">
			<div id="r_posterImg1" align="center" style="position: absolute; left: 0px; top: 3px; width: 65px; height: 26px">
				<span id="r_posterImg1_span" style="color: #ffffff; font-size: 12; height: 26px"></span>
			</div>
		</div>
	</epg:if>

	<epg:if test="${bottomCategoryItems[2]!=null}">
		<epg:img id="r_posterImg2" src="./images/dot.gif" left="993" top="465" width="68" height="201" />
		<epg:navUrl obj="${bottomCategoryItems[2]}" indexUrlVar="indexUrl3"></epg:navUrl>
		<epg:img id="r_poster3" src="../${bottomCategoryItems[2].still}" left="995" top="468" width="65" height="195" />
		<epg:img id="r_poster3focus" src="./images/dot.gif" left="995" top="468" width="65" height="195" href="${indexUrl3}&returnTo=biz" onfocus="textOnFocus('2','orange3','categoryList2_titlediv','${bottomCategoryItems[2].title}');" onblur="textOnBlur('posterImg2','categoryList2_titlediv');" />
		<div id="r_categoryList2_titlediv" style="position: absolute; font-size: 12; font-family: '黑体'; color: #FFFFFF; text-align: center; background-color: #f79922; visibility: hidden; left: 995px; top: 633px; width: 65px; height: 31px; z-index: 1;">
			<div id="r_posterImg2" align="center" style="position: absolute; left: 0px; top: 3px; width: 65px; height: 26px">
				<span id="r_posterImg2_span" style="color: #ffffff; font-size: 12;"></span>
			</div>
		</div>
	</epg:if>
	
	<epg:if test="${bottomCategoryItems[3]!=null}">
		<epg:img id="r_posterImg3" src="./images/dot.gif" left="1083" top="465" width="68" height="201" />
		<epg:navUrl obj="${bottomCategoryItems[3]}" indexUrlVar="indexUrl4"></epg:navUrl>
		<epg:img id="r_poster4" src="../${bottomCategoryItems[3].still}" left="1085" top="468" width="65" height="195" />
		<epg:img id="r_poster4focus" src="./images/dot.gif" left="1085" top="468" width="65" height="195" href="${indexUrl4}&returnTo=biz" onfocus="textOnFocus('3','orange3','categoryList3_titlediv','${bottomCategoryItems[3].title}');" onblur="textOnBlur('posterImg3','categoryList3_titlediv');" />
		<div id="r_categoryList3_titlediv" style="position: absolute; font-size: 12; font-family: '黑体'; color: #FFFFFF; text-align: center; background-color: #f79912; visibility: hidden; left: 1085px; top: 633px; width: 65px; height: 31px; z-index: 1;">
			<div id="r_posterImg3" align="center" style="position: absolute; left: 0px; top: 3px; width: 65px; height: 26px">
				<span id="r_posterImg3_span" style="color: #ffffff; font-size: 12;"></span>
			</div>
		</div>
	</epg:if>
	
	<epg:if test="${bottomCategoryItems[4]!=null}">
		<epg:img id="r_posterImg4" src="./images/dot.gif" left="1173" top="465" width="68" height="201" />
		<epg:navUrl obj="${bottomCategoryItems[4]}" indexUrlVar="indexUrl5"></epg:navUrl>
		<epg:img id="r_poster5" src="../${bottomCategoryItems[4].still}" left="1175" top="468" width="65" height="195" />
		<epg:img id="r_poster5focus" src="./images/dot.gif" left="1175" top="468" width="65" height="195" href="${indexUrl5}&returnTo=biz" onfocus="textOnFocus('4','orange3','categoryList4_titlediv','${bottomCategoryItems[4].title}');" onblur="textOnBlur('posterImg4','categoryList4_titlediv');" />
		<div id="r_categoryList4_titlediv" style="position: absolute; font-size: 12; font-family: '黑体'; color: #FFFFFF; text-align: center; background-color: #f79912; visibility: hidden; left: 1175px; top: 633px; width: 65px; height: 31px; z-index: 1;">
			<div id="r_posterImg4" align="center" style="position: absolute; left: 0px; top: 3px; width: 65px; height: 26px">
				<span id="r_posterImg4_span" style="color: #ffffff; font-size: 12;"></span>
			</div>
		</div>
	</epg:if>

	<!-- 收藏提示框 -->
	<div id="r_collectSuccess" style="display: none;">
		<epg:img id="r_tip" src="./images/collectSuccess.png" left="640" top="0" width="640" height="720" />
		<epg:text id="r_successTs" fontSize="12" color="#565656" left="840" top="327" width="240" height="30" align="center" chineseCharNumber="17" text=""></epg:text>
	</div>
	<div id="r_collectFail" style="display: none;">
		<epg:img id="r_tip" src="./images/collectFail.png" left="640" top="0" width="640" height="720" />
		<epg:text id="r_failTs" fontSize="12" color="#565656" left="840" top="327" width="240" height="30" align="center" chineseCharNumber="17" text=""></epg:text>
	</div>
	<div id="r_tsBtn" style="display: none;">
		<epg:img id="r_Collection" left="880" top="412" onfocus="itemOnFocus('Collection','enterColl');" onblur="itemOnBlur('Collection');" src="./images/dot.gif" width="65" height="40" href="${context['EPG_MYCOLLECTION_URL']}" />
		<epg:img id="r_enter" left="975" top="412" onfocus="itemOnFocus('enter','closeWin');" onblur="itemOnBlur('enter');" src="./images/dot.gif" width="65" height="40" href="javascript:hiddenTip()" />
	</div>
</div>
</epg:body>
</html>