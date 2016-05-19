<%@page contentType="text/html; charset=GBK" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@page import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*"%>
<% 
	String leaveFocusId = request.getParameter("leaveFocusId");
	if(leaveFocusId!=null&&leaveFocusId!=""){
		EpgUserSession eus = EpgUserSession.findUserSession(request);
		eus.setPlayFocusId(leaveFocusId) ;
	}
%>
<html>
<!-- 查询剧集内容信息 -->
<epg:query queryName="querySeriesByCode" var="series">
	<epg:param name="contentCode" value="${context['EPG_CONTENT_CODE']}"
		type="java.lang.String" />
</epg:query>

<epg:set value="1" var="ProgramBodyType"/>
<epg:set value="1" var="hdType"/>
<epg:set value="0" var="sdType"/>
<epg:if test="${series.relCode!=null}">
	<!-- HD正片 -->
	<epg:query queryName="queryRelContentByRelCodeAndType" maxRows="1" var="HDrelContent" >
		<epg:param name="relCode" value="${series.relCode}" type="java.lang.String"/>
		<epg:param name="bodyType" value="${ProgramBodyType}" type="java.lang.Integer"/>
		<epg:param name="videoType" value="${hdType}" type="java.lang.Integer"/>
		<epg:param name="type" value="series" type="java.lang.String"/>
	</epg:query>
	<!-- SD正片 -->
	<epg:query queryName="queryRelContentByRelCodeAndType" maxRows="1" var="SDrelContent" >
		<epg:param name="relCode" value="${series.relCode}" type="java.lang.String"/>
		<epg:param name="bodyType" value="${ProgramBodyType}" type="java.lang.Integer"/>
		<epg:param name="videoType" value="${sdType}" type="java.lang.Integer"/>
		<epg:param name="type" value="series" type="java.lang.String"/>
	</epg:query>
</epg:if>
<!-- HD剧集集数信息 -->
<epg:query queryName="queryEpisodeByCode" maxRows="40" var="episodes"
	pageBeanVar="pageBean" pageIndexParamVar="pageIndex2">
	<epg:param name="seriesCode" value="${context['EPG_CONTENT_CODE']}"
		type="java.lang.String" />
</epg:query>
<epg:query queryName="queryEpisodeByCode" maxRows="999" var="renewNum"
	pageBeanVar="pageBean1" pageIndexParamVar="pageIndex1">
	<epg:param name="seriesCode" value="${context['EPG_CONTENT_CODE']}"
		type="java.lang.String" />
</epg:query>


<!-- 查询用户观看历史 -->
<epg:query queryName="userCouldMarkSeries" var="userHistory">
	<epg:param name="USER_ID" value="${EPG_USER.userAccount}"
		type="java.lang.String" />
	<epg:param name="CONTENT_CODE" value="${context['EPG_CONTENT_CODE']}"
		type="java.lang.String" />
</epg:query>

<!-- 右下方推荐随机内容  -->
<epg:set var="tags" value="${fn:split(series.tags, ',')}"></epg:set>
<epg:set var="tag" value="${tags[0]}"></epg:set>
<epg:if test="${tag=='高清'}">
	<epg:set var="tag" value="${tags[1]}"></epg:set>
</epg:if>

<epg:query queryName="getSeverialItemsByTagsRandomIncludePic" maxRows="5" var="bottomCategoryItems">
	<epg:param name="tags" value="${tag}" type="java.lang.String"/>
	<epg:param name="selfCode" value="${series.contentCode}" type="java.lang.String"/>
	<epg:param name="mainFolder" value="${series.mainFolder}" type="java.lang.String"/>
</epg:query>


<!-- 收藏、返回 -->
<epg:navUrl obj="${series}" addCollectionUrlVar="addColUrl"></epg:navUrl>
<epg:navUrl returnTo="${param.returnTo}" returnUrlVar="returnUrl"></epg:navUrl>
<epg:navUrl returnTo="home" returnUrlVar="returnToHomeUrl"></epg:navUrl>

<!--  剧集剧情信息分割为7行 -->
<epg:text left="0" top="0" width="295" height="220" chineseCharWidth="24"
 multi="true" output="false" lines="summarys" lineNum="7">${series.summaryMedium}</epg:text>


<style>
	img{	
		border:0px;
	}
	#info_span{
		display:block;
		line-height:41px;
		height:35px;
	}
	body{
		color:#FFFFFF;
		font-size:22;
		font-family:"黑体";
	}
	a{
		outline:none;
		text-decoration: none;
	}
</style>
<script src="${context['EPG_CONTEXT']}/js/ajax.js"></script>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>

<script type="text/javascript">
var imgPath = "${context['EPG_CONTEXT']}/common/images";
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
	_playUrlList[${idx.index}]='${playUrl}';
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

function returnToBizOrHistory(){
	//if("${param.returnTo}"!=""&&"${param.returnTo}"!=null){
	//	window.location.href = "${returnUrl}";
	//}else{
		history.back();
	//}
}
function $(_id) {
	return "string" == typeof _id ? document.getElementById(_id) : _id;
}

function focusCurId(objId,img,color){
	if(objId=="play"){
		$("playTitle_span").style.color="#ffffff";
		$("playTitle").style.zIndex="10";
	}
	$(objId+"_img").src=imgPath+"/"+img+".png";
}
function blurCurId(objId,color){
	if(objId=="play"){
		$("playTitle_span").style.color="#1978b8";
		$("playTitle").style.zIndex="0";
	}
	$(objId+"_img").src=imgPath+"/dot.gif";
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
				}
			}
		}
		if ("pageDown" == objId) {
			if($("pageDown")!=null){
				$("pageDown").style.zIndex=10;
				if (pagAllNum != 1) {
					$("pageDown_span").style.color = "#ffffff";
				}
			}
		}
		if ("pageDown1" == objId) {
			if($("pageDown1")!=null){
				$("pageDown1").style.zIndex=10;
				if (pagAllNum != 2) {
					$("pageDown1_span").style.color="#ffffff";
				}
			}
		}
		if ("pageDown2" == objId) {
			if ($("pageDown2") != null) {
				$("pageDown2").style.zIndex = 10;
				if (pagAllNum != 3) {
					$("pageDown2_span").style.color = "#ffffff";
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
				}
			}
		}
		if ("pageDown" == objId) {
			if ($("pageDown") != null) {
				$("pageDown").style.zIndex = 0;
				if (pagAllNum != 1) {
					$("pageDown_span").style.color = "#1978b8";
				}
			}
		}
		if ("pageDown1" == objId) {
			if ($("pageDown1") != null) {
				$("pageDown1").style.zIndex = 0;
				if (pagAllNum != 2) {
					$("pageDown1_span").style.color = "#1978b8";
				}
			}
		}
		if ("pageDown2" == objId) {
			if ($("pageDown2") != null) {
				$("pageDown2").style.zIndex = 0;
				if (pagAllNum != 3) {
					$("pageDown2_span").style.color = "#1978b8";
				}
			}
		}
		//$(objId+"Focus_img").src=imgPath+"/currNumFocus.png";
		$(objId+"_img").src=imgPath+"/"+img+".png";
	}
}
//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名
	function itemOnFocus(objId,img){
		leaveFocusId = objId; 
		$(objId+"_img").src=imgPath+"/"+img+".png";
	}
	//失去焦点事件
	function itemOnBlur(objId){
		$(objId+"_img").src=imgPath+"/dot.gif";
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
}
function textOnBlur(objId,itemId){
	document.getElementById(objId+"_img").src=imgPath+"/dot.gif";
	document.getElementById(itemId).style.visibility="hidden";
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
	window.location.href=_playUrlList[index]+"&returnTo=${returnTo}&seriesCode=${context['EPG_CONTENT_CODE']}&episodeIndex="+id1;
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
}
function starringOnBlur(objId){
	$(objId+"_img").src=imgPath+"/vodtextBg.png";
	$(objId+"_span").style.color="#1978b8";
}
//集数选中状态
function setOnFocus(objId){
	$(objId+"_img").src=imgPath+"/episodeFocus.png";
	var episode = objId.substring(objId.indexOf("episodeFocus")+12,objId.length);
	$("episode"+episode+"_span").style.color = "#ffffff";
}
function setOnBlur(objId){
	$(objId+"_img").src = imgPath+"/dot.gif";
	var episode = objId.substring(objId.indexOf("episodeFocus")+12,objId.length);
	if($("currepisodeFocus"+episode+"_img").style.visibility!="visible"){
		$("episode"+episode+"_span").style.color = "#1978b8";
	}
}

function resetHtml(){
	for(var i=0;i<40;i++){
			$("episode"+(i+1)+"_div").style.visibility = 'visible';
			$("episode"+(i+1)).style.visibility = 'visible';
			//$("episode"+(i+1)+"_div").style.backgroundColor="#cdebff";
			//$("episode"+(i+1)+"_span").style.color="#1978b8";
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
//	$("play_a").focus();
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
function back(){
 	returnToBizOrHistory();
 }
 function exit(){
 	window.location.href = "${returnUrl}";
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
</script>
<epg:body onload="init();"  bgcolor="#000000"    width="1280" height="720">
<!-- 背景图片以及头部图片 -->
<epg:img src="/common/images/HD_SD_series_detail.jpg" id="main"  left="0" top="0" width="1280" height="720"/>
<epg:img src="/common/images/logo.png" left="0" top="0" width="350" height="85"/>


<!-- 播放收藏 -->	
<!-- 提示上次观看到的集数 -->
<epg:if test="${userHistory.episodeIndex!=null}">
		<div style="position:absolute;left:769px;top:156px;width:180px;height:25px;">
			<font color="#333333" style="font-size:18px">上次看到</font>
			<font color="#2e7eb9" style="font-size:22px">
				<epg:if test="${userHistory.episodeIndex!=null}">${userHistory.episodeIndex}</epg:if></font><font color="#333333" style="font-size:18px">/${series.episodeNumber}</font>
		</div>
	</epg:if>
	
	<epg:if test="${fn:length(renewNum)<series.episodeNumber}">
		<div style="position:absolute;left:770px;top:113px;width:180px;height:25px;">
			<font color="#333333" style="font-size:18px">更新至第</font><font color="#2e7eb9" style="font-size:22px">${renewNum[fn:length(renewNum)-1].episodeIndex}</font><font color="#333333" style="font-size:18px">集</font>
		</div>
	</epg:if>
	<epg:if test="${userHistory.episodeIndex!=null}">
		<epg:text fontSize="22" color="#1978b8" id="playTitle" left="390" top="156" width="85" height="35" align="left" text="第${userHistory.episodeIndex}集"></epg:text>
		<epg:img id="play" onblur="blurCurId('play');" defaultfocus="true" left="350" top="151" onfocus="focusCurId('play','seriesPlay')" src="/common/images/dot.gif" width="130" height="30"  href="#" onclick="javascript:playBefore('${userHistory.episodeIndex}')"/>
	</epg:if>
	<epg:if test="${userHistory.episodeIndex==null}">
		<epg:text fontSize="22" color="#1978b8" id="playTitle" left="390" top="156" width="85" height="35" align="left" text="第${episodes[0].episodeIndex}集"></epg:text>
		<epg:img id="play" onblur="blurCurId('play');" defaultfocus="true"  left="350" top="151" onfocus="focusCurId('play','seriesPlay')" src="/common/images/dot.gif" width="130" height="30"  href="#" onclick="javascript:playBefore('1')"/>
	</epg:if>
	
	<epg:if test="${series.hdType=='1'}">
		<epg:if test="${SDrelContent!=null}">
			<epg:if test="${SDrelContent.relCodeFlag==1}">
				<epg:navUrl obj="${SDrelContent}" indexUrlVar="SDplayUrl"/>
				<epg:img onblur="itemOnBlur('goHDorSDFocus');" left="490" top="151" onfocus="itemOnFocus('goHDorSDFocus','goSDFocus')" src="/common/images/goSDBtn.png" width="130" height="30"  href="${SDplayUrl}"/>
				
				<epg:navUrl obj="${series}" addCollectionUrlVar="addCollectionUrl"/>
				<epg:img onblur="itemOnBlur('addCol');" left="630" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="/common/images/addColBtn.png" width="130" height="30"  href="javascript:addCollection()"/>
				<epg:img id="addCol" left="630" top="151" src="/common/images/dot.gif" width="130" height="30"/>
			</epg:if>
			<epg:if test="${SDrelContent.relCodeFlag==0}">
				<epg:navUrl obj="${series}" addCollectionUrlVar="addCollectionUrl"/>
				<epg:img onblur="itemOnBlur('addCol');" left="490" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="/common/images/addColBtn.png" width="130" height="30"  href="javascript:addCollection()"/>
				<epg:img id="addCol" left="490" top="151" src="/common/images/dot.gif" width="130" height="30"/>
			</epg:if>
		</epg:if>
		<epg:if test="${SDrelContent==null}">
			<epg:navUrl obj="${series}" addCollectionUrlVar="addCollectionUrl"/>
			<epg:img onblur="itemOnBlur('addCol');" left="490" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="/common/images/addColBtn.png" width="130" height="30"  href="javascript:addCollection()"/>
			<epg:img id="addCol" left="490" top="151" src="/common/images/dot.gif" width="130" height="30"/>
		</epg:if>
	</epg:if>
		
	<epg:if test="${series.hdType=='0'}">
		<epg:if test="${HDrelContent!=null}">
			<epg:if test="${HDrelContent.relCodeFlag==1}">
				<epg:navUrl obj="${HDrelContent}" indexUrlVar="HDplayUrl"/>
				<epg:img  onblur="itemOnBlur('goHDorSDFocus');" left="490" top="151" onfocus="itemOnFocus('goHDorSDFocus','goHDFocus')" src="/common/images/goHDBtn.png" width="130" height="30"  href="${HDplayUrl}"/>
				
				<epg:navUrl obj="${series}" addCollectionUrlVar="addCollectionUrl"/>
				<epg:img onblur="itemOnBlur('addCol');" left="630" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="/common/images/addColBtn.png" width="130" height="30"  href="javascript:addCollection()"/>
				<epg:img id="addCol" left="630" top="151" src="/common/images/dot.gif" width="130" height="30"/>
			</epg:if>
			<epg:if test="${HDrelContent.relCodeFlag==0}">
				<epg:navUrl obj="${series}" addCollectionUrlVar="addCollectionUrl"/>
				<epg:img onblur="itemOnBlur('addCol');" left="490" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="/common/images/addColBtn.png" width="130" height="30"  href="javascript:addCollection()"/>
				<epg:img id="addCol" left="490" top="151" src="/common/images/dot.gif" width="130" height="30"/>
			</epg:if>
		</epg:if>
		<epg:if test="${HDrelContent==null}">
			<epg:navUrl obj="${series}" addCollectionUrlVar="addCollectionUrl"/>
			<epg:img onblur="itemOnBlur('addCol');" left="490" top="151" onfocus="itemOnFocus('addCol','addFocus')" src="/common/images/addColBtn.png" width="130" height="30"  href="javascript:addCollection()"/>
			<epg:img id="addCol" left="490" top="151" src="/common/images/dot.gif" width="130" height="30"/>
		</epg:if>
	</epg:if>
	<epg:img id="goHDorSDFocus" left="490" top="151" src="/common/images/dot.gif" width="130" height="30" />

<!-- 搜索,收藏,历史,返回 -->
<epg:img src="/common/images/dot.gif" id="ss"  left="949" top="47" width="80" height="38"
	href="${context['EPG_SEARCH_URL']}" onfocus="itemOnFocus('ss','focusMenuTop_1');"  onblur="itemOnBlur('ss');" />

<epg:img src="/common/images/dot.gif" id="zz"  left="1050" top="47" width="80" height="38"
	href="${context['EPG_SELF_URL']}" onfocus="itemOnFocus('zz','zizhuFocus');"  onblur="itemOnBlur('zz');" />

<epg:img src="/common/images/dot.gif" id="zn"  left="1150" top="47"width="80" height="38" 
	href="javascript:back();" onfocus="itemOnFocus('zn','focusMenuTop_3');"  onblur="itemOnBlur('zn');" />


<epg:if test="${fn:startsWith(series.title,'HD_') == true }">
	<epg:img src="/common/images/hd_theater_title.png" left="229" top="42" width="118" height="44"/>
</epg:if>
<epg:if test="${fn:startsWith(series.title,'HD_') != true }">
	<epg:img src="/common/images/sd_theater_title.png" left="229" top="42" width="118" height="44"/>
</epg:if>

<!-- 节目名 -->
<epg:text fontSize="32" color="#e74c3c" left="350" top="101" width="620" height="50" align="left" chineseCharNumber="17" dotdotdot="…" text="${series.title}"></epg:text>
<!-- 导演 -->
<epg:text fontSize="21" color="#333333" left="80" top="433" width="80" height="27" align="left"  text="导演："></epg:text>
<epg:if test="${series.director!=null}">
	<epg:text id="directorImg" fontSize="21" color="#333333" left="137" top="433" width="170" height="30" chineseCharNumber="8" align="left"  dotdotdot="…" text="${series.director}"></epg:text>
</epg:if>
<epg:if test="${series.director==''}">
	<epg:text id="directorImg" fontSize="21" color="#333333" left="137" top="433" width="170" height="30" chineseCharNumber="8" align="left"  dotdotdot="…" text="无"></epg:text>
</epg:if>
<!-- 主演 -->
<epg:text fontSize="21" color="#333333" left="80" top="465" width="80" height="27" align="left"  text="主演："></epg:text>
<epg:set var="actors" value="${fn:replace(series.actors, '，',',')}"></epg:set>
<epg:set var="actors" value="${fn:split(actors, ',')}"></epg:set>
<epg:if test="${actors==''}">
<epg:text fontSize="21" color="#333333" left="137" top="465" width="133" height="22" align="left" text="无"></epg:text>
</epg:if>
<epg:text fontSize="21" color="#333333" left="137" top="465" chineseCharNumber="8" dotdotdot="…" width="200"  height="22" align="left" text="${actors[0]}"></epg:text>
<epg:text fontSize="21" color="#333333" left="137" top="505" chineseCharNumber="8" dotdotdot="…" width="200"  height="22" align="left" text="${actors[1]}"></epg:text>
<epg:text fontSize="21" color="#333333" left="137" top="545" chineseCharNumber="8" dotdotdot="…" width="200"  height="22" align="left" text="${actors[2]}"></epg:text>
<epg:text fontSize="21" color="#333333" left="137" top="585" chineseCharNumber="8" dotdotdot="…" width="200"  height="22" align="left" text="${actors[3]}"></epg:text>

<!-- 内容详情 -->
<epg:text fontSize="22" color="#333333" id="info" left="935" top="152" width="295" height="35" align="left" text="剧情简介："></epg:text>
<epg:text fontSize="22" color="#333333" id="info" left="935" top="184" width="295" height="35" align="left" text="${summarys[0].content}"></epg:text>
<epg:text fontSize="22" color="#333333" id="info" left="935" top="216" width="295" height="35" align="left" text="${summarys[1].content}"></epg:text>
<epg:text fontSize="22" color="#333333" id="info" left="935" top="248" width="295" height="35" align="left" text="${summarys[2].content}"></epg:text>
<epg:text fontSize="22" color="#333333" id="info" left="935" top="280" width="295" height="35" align="left" text="${summarys[3].content}"></epg:text>
<epg:text fontSize="22" color="#333333" id="info" left="935" top="312" width="295" height="35" align="left" text="${summarys[4].content}"></epg:text>
<epg:text fontSize="22" color="#333333" id="info" left="935" top="344" width="295" height="35" align="left" text="${summarys[5].content}"></epg:text>
<epg:text fontSize="22" color="#333333" id="info" left="935" top="376" width="295" height="35" align="left" text="${summarys[6].content}"></epg:text>
<epg:text fontSize="22" color="#333333" id="info" left="935" top="408" width="295" height="35" align="left" text="${summarys[7].content}"></epg:text>
<!-- 内容海报 -->
<epg:img id="poster" left="80" top="94"  width="220" height="330" src="../${series.icon}"/>

<!-- 每一集内容 -->
<epg:resource src="/common/images/numbg.png" realSrcVar="numbg" />
<epg:forEach begin="0" end="4" varStatus="rowStatus">
<epg:forEach begin="0" end="7" varStatus="colStatus">
	<epg:if test="${episodes[rowStatus.index*8+colStatus.index].episodeIndex!=null}">
		<div id="episode${rowStatus.index*8+colStatus.index+1}_div" style="position:absolute;background-image:url('${numbg}');left:${349+colStatus.index*70}px;top:${190+rowStatus.index*40}px;width:60px;height:30px;">
		</div>
		<epg:img id="currepisodeFocus${rowStatus.index*8+colStatus.index+1}" style="visibility:hidden;" left="${349+colStatus.index*70}" top="${190+rowStatus.index*40}"  width="60" height="30" src="/common/images/currFocus.png"/>
		
		<epg:img id="episodeFocus${rowStatus.index*8+colStatus.index+1}" onfocus="setOnFocus('episodeFocus${rowStatus.index*8+colStatus.index+1}')"  onblur="setOnBlur('episodeFocus${rowStatus.index*8+colStatus.index+1}')"
			href="javascript:playBefore('${episodes[rowStatus.index*8+colStatus.index].episodeIndex}')"
			left="${349+colStatus.index*70}" top="${190+rowStatus.index*40}"  width="60" height="30" src="/common/images/dot.gif"/>
		<epg:text id="episode${rowStatus.index*8+colStatus.index+1}" left="${356+colStatus.index*70}" top="${195+rowStatus.index*40}" width="46" height="30" 
		align="center" color="#1978b8" fontSize="22" text="${episodes[rowStatus.index*8+colStatus.index].episodeIndex}" />
	</epg:if>
	<epg:if test="${episodes[rowStatus.index*8+colStatus.index].episodeIndex==null}">
		<div id="episode${rowStatus.index*8+colStatus.index+1}_div" style="position:absolute;background-color:#0f4071;visibility:hidden;left:${349+colStatus.index*70}px;top:${190+rowStatus.index*40}px;width:60px;height:30px;">
		</div>
		<epg:img id="currepisodeFocus${rowStatus.index*8+colStatus.index+1}" style="position:absolute;visibility:hidden;" left="${349+colStatus.index*70}" top="${190+rowStatus.index*40}"  width="60" height="30" src="/common/images/currFocus.png"/>
		
		<epg:img id="episodeFocus${rowStatus.index*8+colStatus.index+1}"  href="#"  style="position:absolute;visibility:hidden;"
			left="${349+colStatus.index*70}" top="${190+rowStatus.index*40}"  width="60" height="30" src="/common/images/dot.gif"/>
		
		<epg:text  id="episode${rowStatus.index*8+colStatus.index+1}" left="${356+colStatus.index*70}" top="${195+rowStatus.index*40}" width="46" height="30" 
		 align="center" color="#ffffff" fontSize="22" ></epg:text>
	</epg:if>
</epg:forEach>
</epg:forEach>


<epg:choose>
		<epg:when test="${fn:length(renewNum)<40}">				
			<epg:img id="pageUp"  left="350" top="394"  src="/common/images/seriesNum.png" width="130" height="30"  />
			<epg:img id="pageUpFocus"  onblur="changeColor(1,'pageUp','seriesNum');" left="350" top="394" onfocus="changeColor(0,'pageUp','seriesNumFocus')" src="/common/images/currNumFocus.png" width="130" height="30"  href="#" />
		 	<epg:text id="pageUp" left="350" top="398" width="130" height="30" align="center" color="#1978b8" fontSize="22">${renewNum[0].episodeIndex}-${renewNum[fn:length(renewNum)-1].episodeIndex}</epg:text>
		</epg:when>
		<epg:when test="${fn:length(renewNum)==40}">	
			<epg:img id="pageUp"  left="350" top="394"  src="/common/images/seriesNum.png" width="130" height="30"  />
		 	<epg:img id="pageUpFocus" onblur="changeColor(1,'pageUp','seriesNum');" left="350" top="394" onfocus="changeColor(0,'pageUp','seriesNumFocus')" src="/common/images/currNumFocus.png" width="130" height="30"  href="#" />
			<epg:text id="pageUp" left="350" top="398" width="130" height="30" align="center" color="#1978b8" fontSize="22">${renewNum[0].episodeIndex}-${renewNum[39].episodeIndex}</epg:text>
		</epg:when>
		<epg:when test="${fn:length(renewNum)>40 && fn:length(renewNum)<=80}">	
		 	<epg:img id="pageUp"  left="350" top="394"  src="/common/images/seriesNum.png" width="130" height="30"  />
			<epg:img id="pageDown"  left="490" top="394"  src="/common/images/seriesNum.png" width="130" height="30"  />
			<epg:img id="pageUpFocus"  onblur="changeColor(1,'pageUp','seriesNum');" left="350" top="394" onfocus="changeColor(0,'pageUp','seriesNumFocus')" pageop="up" keyop="pageup" src="/common/images/currNumFocus.png" width="130" height="30"  href="javascript:goUp();" />
		 	<epg:img id="pageDownFocus"  onblur="changeColor(1,'pageDown','seriesNum');" left="490" top="394" onfocus="changeColor(0,'pageDown','seriesNumFocus')" pageop="down" keyop="pagedown" src="/common/images/dot.gif" width="130" height="30"  href="javascript:goDown();" />
			<epg:text id="pageUp" left="350" top="398" width="130" height="30" align="center" color="#1978b8" fontSize="22">${renewNum[0].episodeIndex}-${renewNum[39].episodeIndex}</epg:text>
			<epg:text id="pageDown" left="490" top="398" width="130" height="30" align="center" color="#1978b8" fontSize="22">${renewNum[40].episodeIndex}-${renewNum[fn:length(renewNum)-1].episodeIndex}</epg:text>
		</epg:when>
		<epg:when test="${fn:length(renewNum)>80 && fn:length(renewNum)<=120}">	
			<epg:img id="pageUp"  left="350" top="394"  src="/common/images/seriesNum.png" width="130" height="30"  />
		 	<epg:img id="pageUpFocus" onblur="changeColor(1,'pageUp','seriesNum');" left="350" top="394" onfocus="changeColor(0,'pageUp','seriesNumFocus')" src="/common/images/currNumFocus.png" width="130" height="30"  href="javascript:goNext(0);" />
		 	
			<epg:text id="pageUp" left="350" top="398" width="130" height="30" align="center" color="#1978b8" fontSize="22">${renewNum[0].episodeIndex}-${renewNum[39].episodeIndex}</epg:text>
			<epg:img id="pageDown"  left="490" top="394"  src="/common/images/seriesNum.png" width="130" height="30"  />
			<epg:img  id="pageDownFocus"  onblur="changeColor(1,'pageDown','seriesNum');" left="490" top="394" onfocus="changeColor(0,'pageDown','seriesNumFocus')" src="/common/images/dot.gif" width="130" height="30"  href="javascript:goNext(1);" />
			
			<epg:text id="pageDown" left="490" top="398" width="130" height="30" align="center" color="#1978b8" fontSize="22">${renewNum[40].episodeIndex}-${renewNum[79].episodeIndex}</epg:text>
			<epg:img  id="pageDown1"left="630" top="394" src="/common/images/seriesNum.png" width="130" height="30"  />
			<epg:img  id="pageDown1Focus"   onblur="changeColor(1,'pageDown1','seriesNum');" left="630" top="394" onfocus="changeColor(0,'pageDown1','seriesNumFocus')" src="/common/images/dot.gif" width="130" height="30"  href="javascript:goNext(2);" />
			
			<epg:text id="pageDown1" left="630" top="398" width="130" height="30" align="center" color="#1978b8" fontSize="22">${renewNum[80].episodeIndex}-${renewNum[fn:length(renewNum)-1].episodeIndex}</epg:text>
			<div style="position:absolute;visibility:hidden;left:350px;top:371px;width:130px;height:30px;">
				<epg:img  src="/common/images/dot.gif" width="130" height="30" pageop="up" keyop="pageup" href="javascript:pagUp()" />
			</div>
			<div style="position:absolute;visibility:hidden;left:490px;top:371px;width:130px;height:30px;">
				<epg:img  src="/common/images/dot.gif" width="130" height="30" pageop="down" keyop="pagedown" href="javascript:pagDown()" />
			</div>
		</epg:when>
		<epg:when test="fn:length(renewNum)>120}">	
			<epg:img id="pageUp"  left="350" top="394"  src="/common/images/seriesNum.png" width="130" height="30"  />
		 	<epg:img  id="pageUpFocus"  onblur="changeColor(1,'pageUp','seriesNum');" left="350" top="394" onfocus="changeColor(0,'pageUp','seriesNumFocus')" src="/common/images/currNumFocus.png" width="130" height="30"  href="javascript:goNext(0);" />
		 	
			<epg:text id="pageUp" left="350" top="398" width="130" height="30" align="center" color="#1978b8" fontSize="22">${renewNum[0].episodeIndex}-${renewNum[39].episodeIndex}</epg:text>
			<epg:img id="pageDown"  left="490" top="394"  src="/common/images/seriesNum.png" width="130" height="30"  />
			<epg:img  id="pageDownFocus"  onblur="changeColor(1,'pageDown','seriesNum');" left="490" top="394" onfocus="changeColor(0,'pageDown','seriesNumFocus')" src="/common/images/dot.gif" width="130" height="30"  href="javascript:goNext(1);" />
			
			<epg:text id="pageDown" left="490" top="398" width="130" height="30" align="center" color="#1978b8" fontSize="22">${renewNum[40].episodeIndex}-${renewNum[79].episodeIndex}</epg:text>
			<epg:img  id="pageDown1"left="630" top="394" src="/common/images/seriesNum.png" width="130" height="30"  />
			<epg:img id="pageDown1Focus"  onblur="changeColor(1,'pageDown1','seriesNum');" left="630" top="394" onfocus="changeColor(0,'pageDown1','seriesNumFocus')" src="/common/images/dot.gif" width="130" height="30"  href="javascript:goNext(2);" />
			<epg:text id="pageDown1" left="630" top="398" width="130" height="30" align="center" color="#1978b8" fontSize="22">${renewNum[80].episodeIndex}-${renewNum[119].episodeIndex}</epg:text>
			<epg:img  id="pageDown2" left="770" top="394"  src="/common/images/seriesNum.png" width="130" height="30"  />
			<epg:img id="pageDown2Focus"  onblur="changeColor(1,'pageDown2','seriesNum');" left="770" top="394" onfocus="changeColor(0,'pageDown2','seriesNumFocus')" src="/common/images/dot.gif" width="130" height="30"  href="javascript:goNext(3);" />
			
			<epg:text id="pageDown2" left="770" top="398" width="130" height="30" align="center" color="#1978b8" fontSize="22">${renewNum[120].episodeIndex}-${renewNum[fn:length(renewNum)-1].episodeIndex}</epg:text>
			<div style="position:absolute;visibility:hidden;left:350px;top:391px;width:130px;height:30px;">
				<epg:img  src="/common/images/dot.gif" width="130" height="30" pageop="up" keyop="pageup" href="javascript:pagUp();init();" />
			</div>
			<div style="position:absolute;visibility:hidden;left:490px;top:391px;width:130px;height:30px;">
				<epg:img  src="/common/images/dot.gif" width="130" height="30" pageop="down" keyop="pagedown" href="javascript:pagDown();init();" />
			</div>
		</epg:when>
	</epg:choose>

<!-- 播放收藏 -->	
<!-- 猜你喜欢内容 -->
<epg:if test="${bottomCategoryItems[0]!=null}">
	<epg:img id="posterImg0" src="/common/images/dot.gif" left="347" top="465" width="136" height="201" />
	<epg:navUrl obj="${bottomCategoryItems[0]}" indexUrlVar="indexUrl1" ></epg:navUrl>
	<epg:img id="poster1" src="../${bottomCategoryItems[0].still}" left="350" 
		top="468" width="130" height="195"/>
	<epg:img id="poster1focus" src="/common/images/dot.gif" left="350" 
		top="468" width="130" height="195"  href="${indexUrl1}&returnTo=biz" onfocus="textOnFocus('0','orange3','categoryList0_titlediv','${bottomCategoryItems[0].title}');" 
		onblur="textOnBlur('posterImg0','categoryList0_titlediv');"/>
	<div id="categoryList0_titlediv" style="position:absolute;font-size:22;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#f79922;visibility:hidden;left:350px;top:633px;width:130px;height:31px;z-index:1;" >
	    <div  id="posterImg0"   align="center"  style="position:absolute;left:0px;top:3px;width:130px;height:26px"  >
	  	  <span  id="posterImg0_span"  style="color:#ffffff;font-size:22;"  ></span>
	    </div>
	</div>
</epg:if>

<epg:if test="${bottomCategoryItems[1]!=null}">
	<epg:img id="posterImg1" src="/common/images/dot.gif" left="527" top="465" width="136" height="201" />
	<epg:navUrl obj="${bottomCategoryItems[1]}" indexUrlVar="indexUrl2" ></epg:navUrl>
	<epg:img id="poster2" src="../${bottomCategoryItems[1].still}" left="530" 
		top="468" width="130" height="195"/>
	<epg:img id="poster2focus" src="/common/images/dot.gif" left="530" 
		top="468" width="130" height="195"  href="${indexUrl2}&returnTo=biz" onfocus="textOnFocus('1','orange3','categoryList1_titlediv','${bottomCategoryItems[1].title}');" 
		onblur="textOnBlur('posterImg1','categoryList1_titlediv');"/>
	<div id="categoryList1_titlediv" style="position:absolute;font-size:22;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#f79922;visibility:hidden;left:530px;top:633px;width:130px;height:31px;z-index:1;" >
	    <div  id="posterImg1"   align="center"  style="position:absolute;left:0px;top:3px;width:130px;height:26px"  >
	  	  <span  id="posterImg1_span"  style="color:#ffffff;font-size:22;height:26px"  ></span>
	    </div>  	
	</div>
</epg:if>
	
<epg:if test="${bottomCategoryItems[2]!=null}">
	<epg:img id="posterImg2" src="/common/images/dot.gif" left="707" top="465" width="136" height="201" />
	<epg:navUrl obj="${bottomCategoryItems[2]}" indexUrlVar="indexUrl3" ></epg:navUrl>
	<epg:img id="poster3" src="../${bottomCategoryItems[2].still}" left="710" 
		top="468" width="130" height="195" />
	<epg:img id="poster3focus" src="/common/images/dot.gif" left="710" 
		top="468" width="130" height="195"  href="${indexUrl3}&returnTo=biz" onfocus="textOnFocus('2','orange3','categoryList2_titlediv','${bottomCategoryItems[2].title}');" 
		onblur="textOnBlur('posterImg2','categoryList2_titlediv');"/>		
	<div id="categoryList2_titlediv" style="position:absolute;font-size:22;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#f79922;visibility:hidden;left:710px;top:633px;width:130px;height:31px;z-index:1;" >
	    <div  id="posterImg2"   align="center"  style="position:absolute;left:0px;top:3px;width:130px;height:26px"  >
	  	  <span  id="posterImg2_span"  style="color:#ffffff;font-size:22;"  ></span>
	    </div>  	
	</div>
</epg:if>
<epg:if test="${bottomCategoryItems[3]!=null}">
	<epg:img id="posterImg3" src="/common/images/dot.gif" left="887" top="465" width="136" height="201" />
	<epg:navUrl obj="${bottomCategoryItems[3]}" indexUrlVar="indexUrl4" ></epg:navUrl>
	<epg:img id="poster4" src="../${bottomCategoryItems[3].still}" left="890" 
		top="468" width="130" height="195"/>
	<epg:img id="poster4focus" src="/common/images/dot.gif" left="890" 
		top="468" width="130" height="195"  href="${indexUrl4}&returnTo=biz" onfocus="textOnFocus('3','orange3','categoryList3_titlediv','${bottomCategoryItems[3].title}');" 
		onblur="textOnBlur('posterImg3','categoryList3_titlediv');"/>
	<div id="categoryList3_titlediv" style="position:absolute;font-size:22;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#f79922;visibility:hidden;left:890px;top:633px;width:130px;height:31px;z-index:1;" >
	    <div  id="posterImg3"   align="center"  style="position:absolute;left:0px;top:3px;width:130px;height:26px"  >
	  	  <span  id="posterImg3_span"  style="color:#ffffff;font-size:22;"  ></span>
	    </div>  	
	</div>
</epg:if>
<epg:if test="${bottomCategoryItems[4]!=null}">
	<epg:img id="posterImg4" src="/common/images/dot.gif" left="1067" top="465" width="136" height="201" />
	<epg:navUrl obj="${bottomCategoryItems[4]}" indexUrlVar="indexUrl5" ></epg:navUrl>
	<epg:img id="poster5" src="../${bottomCategoryItems[4].still}" left="1070" 
		top="468" width="130" height="195"/>
	<epg:img id="poster5focus" src="/common/images/dot.gif" left="1070" 
		top="468" width="130" height="195"  href="${indexUrl5}&returnTo=biz" onfocus="textOnFocus('4','orange3','categoryList4_titlediv','${bottomCategoryItems[4].title}');" 
		onblur="textOnBlur('posterImg4','categoryList4_titlediv');"/>
	<div id="categoryList4_titlediv" style="position:absolute;font-size:22;font-family:'黑体';color:#FFFFFF;text-align:center;background-color:#f79922;visibility:hidden;left:1070px;top:633px;width:130px;height:31px;z-index:1;" >
	    <div  id="posterImg4"   align="center"  style="position:absolute;left:0px;top:3px;width:130px;height:26px"  >
	  	  <span  id="posterImg4_span"  style="color:#ffffff;font-size:22;"  ></span>
	    </div>  	
	</div>
</epg:if>
	
<!-- 收藏提示框 -->
<div id="collectSuccess" style="display:none;" >
	<epg:img id="tip"  src="/common/images/collectSuccess.png" left="0" top="0" width="1280" height="720"/>
	<epg:text id="successTs" fontSize="22"  color="#565656" left="400" top="327" width="480" height="30" align="center" chineseCharNumber="17" text=""></epg:text>
</div>
<div id="collectFail" style="display:none;" >
	<epg:img id="tip"  src="/common/images/collectFail.png"  left="0" top="0" width="1280" height="720"/>
	<epg:text id="failTs" fontSize="22"  color="#565656" left="400" top="327" width="480" height="30" align="center" chineseCharNumber="17" text=""></epg:text>
</div>
<div id="tsBtn" style="display:none;" >
	<epg:img id="Collection"   left="481" top="412"  onfocus="itemOnFocus('Collection','enterColl');"  onblur="itemOnBlur('Collection');"  src="/common/images/dot.gif" width="130" height="40"  href="${context['EPG_MYCOLLECTION_URL']}" />
	<epg:img id="enter"   left="671" top="412"  onfocus="itemOnFocus('enter','closeWin');"  onblur="itemOnBlur('enter');"  src="/common/images/dot.gif" width="130" height="40"  href="javascript:hiddenTip()" />
</div>

</epg:body>
</html>