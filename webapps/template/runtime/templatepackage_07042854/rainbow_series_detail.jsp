<%@page contentType="text/html; charset=gbk" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page language="java" import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*"%>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setDateHeader("Expires", 0);
	String returnTo = request.getParameter("returnTo");
	request.setAttribute("returnTo", returnTo);
	String leaveFocusId = request.getParameter("leaveFocusId");
	if (leaveFocusId != null && leaveFocusId != "") {
		EpgUserSession eus = EpgUserSession.findUserSession(request);
		eus.setPlayFocusId(leaveFocusId);
	}
%>
<html>
<style>
a {
	display: block;
	outline: none
}
</style>
<!-- 查询最近观看的剧集集数 -->
<epg:query queryName="userCouldMarkSeries" maxRows="1" var="userHistory">
	<epg:param name="USER_ID" value="${EPG_USER.userData.deviceId}" type="java.lang.String" />
	<epg:param name="CONTENT_CODE" value="${context['EPG_CONTENT_CODE']}" type="java.lang.String"></epg:param>
</epg:query>
<epg:set var="historyNumber" value="${userHistory.episodeIndex}"></epg:set>
<!-- 查询剧集内容信息 -->
<epg:query queryName="querySeriesByCode" var="series">
	<epg:param name="contentCode" value="${context['EPG_CONTENT_CODE']}" type="java.lang.String" />
</epg:query>
<!-- 查询剧集集数信息 -->
<epg:query queryName="queryEpisodeByCode" maxRows="999" var="episodes" pageBeanVar="pageBean" pageIndexParamVar="pageIndex">
	<epg:param name="seriesCode" value="${context['EPG_CONTENT_CODE']}" type="java.lang.String" />
</epg:query>

<!-- 高标混排相关 -->
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
<!-- series.relCode:${series.relCode} -->
<!-- HDrelContent:${HDrelContent} -->
<!-- SDrelContent.relCodeFlag:${SDrelContent.relCodeFlag} -->
<epg:navUrl returnTo="home" returnUrlVar="returnHomeUrl"></epg:navUrl>

<!-- 收藏、返回 -->
<!-- <epg:navUrl obj="${series}" addCollectionUrlVar="addColUrl"></epg:navUrl> -->

<meta http-equiv="Content-Type" content="textml; charset=GBK" />

<!-- 节目简介与主演 -->
<epg:text left="0" top="0" width="709" height="80" chineseCharWidth="24"
	needBlank="true" multi="true" output="false" lines="summarys" lineNum="3">${series.summaryMedium}</epg:text>
<epg:text left="0" top="0" width="600" height="70" chineseCharWidth="26"
	multi="true" output="false" lines="actors" lineNum="1">${series.actors}</epg:text>

<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script type="text/javascript">
var imgPath = "${context['EPG_CONTEXT']}/template/runtime/${CONTEXT_OBJ['currentTemplatePackageCode']}/images/";
var returnTo;
var url;
var _level = "${series.reserve1}";
var _ajaxObj = null;
var _index = 0;
var _pageIndex = 1;
var _episodeIndex = 1;
var leaveFocusId;
var _playUrlList = [];//播放链接
var _episodeNumList = [];//集数号码
<epg:forEach items="${episodes}" var="episode" varStatus="idx">
	<epg:navUrl obj="${episode}" playUrlVar="playUrl"/>
	_playUrlList[${idx.index}]='${playUrl}';
	_episodeNumList[${idx.index}] = '${episode.episodeIndex}';
</epg:forEach>
var totalNums = ${fn:length(episodes)};//总集数
var pageNums = 40;//每页的集数
var totalPage = 1;
var lastPageNums = totalNums / pageNums == 0 ? totalNums / pageNums : totalNums % pageNums;
if(lastPageNums > 0) {
	totalPage = parseInt(totalNums / pageNums) + 1;
} else {
	totalPage = totalNums / pageNums;
}
var pageLoad = false;
//翻页处理
function pageUp(){
	if(_pageIndex==1){
		_pageIndex = totalPage + 1;
	}
		_pageIndex = _pageIndex-1;
		for(i=1;i<=pageNums;i++){
			if(typeof(_episodeNumList[pageNums*(_pageIndex-1)+i-1])!='undefined'){
				if(_pageIndex==1){
					if(_episodeNumList[i-1]<10){
					document.getElementById("episode"+i+"_span").innerHTML = "0"+_episodeNumList[i-1];
					}else{
					document.getElementById("episode"+i+"_span").innerHTML = _episodeNumList[i-1];
					}
				}else{
					document.getElementById("episode"+i+"_span").innerHTML = _episodeNumList[pageNums*(_pageIndex-1)+i-1];
				}
				document.getElementById("episode"+i+"_span").style.color="#1581c5";
				var str = "<a id=\"episode"+i+"_a\" href=\"#\" onfocus=\"changeColor(0,"+i+")\" onblur=\"changeColor(1,"+i+")\" onclick=\"playBefore(\'"+(_episodeNumList[pageNums*(_pageIndex-1)+i-1])+"\',\'"+i+"\')\">";
				str += "<img id=\"episode"+i+"_img\" src=\"${context['EPG_CONTEXT']}/common/images/dot.gif\" border=\"0\" width=\"55\" height=\"42\"></a>";
				document.getElementById("episode"+i+"_div").innerHTML = str;
			}else{
				document.getElementById("episode"+i+"_span").innerHTML = "";
				document.getElementById("episode"+i+"_div").innerHTML = "";
			}
		}
}
function pageDown(){
	if(_pageIndex + 1 > totalPage){
		_pageIndex = 0;
	}
	for(i=1;i<=pageNums;i++){
		if(typeof(_episodeNumList[pageNums*_pageIndex+i-1])!='undefined'){	
			document.getElementById("episode"+i+"_span").style.color="#1581c5";
			if(_pageIndex==0){
				if(_episodeNumList[pageNums*_pageIndex+i-1]<10){
				document.getElementById("episode"+i+"_span").innerHTML = "0"+ _episodeNumList[pageNums*_pageIndex+i-1];
				}else{
				document.getElementById("episode"+i+"_span").innerHTML =  _episodeNumList[pageNums*_pageIndex+i-1];
				}
			}else{
				document.getElementById("episode"+i+"_span").innerHTML = _episodeNumList[pageNums*_pageIndex+i-1];
			}
			var str = "<a id=\"episode"+i+"_a\" href=\"#\" onfocus=\"changeColor(0,"+i+")\" onblur=\"changeColor(1,"+i+")\" onclick=\"playBefore(\'"+(_episodeNumList[pageNums*(_pageIndex)+i-1])+"\',\'"+i+"\')\">";
			str += "<img id=\"episode"+i+"_img\" src=\"${context['EPG_CONTEXT']}/common/images/dot.gif\" border=\"0\" width=\"55\" height=\"42\"></a>";
			document.getElementById("episode"+i+"_div").innerHTML = str;
		}else{
			document.getElementById("episode"+i+"_span").innerHTML = "";
			document.getElementById("episode"+i+"_div").innerHTML = "";
		}
	}
	_pageIndex = _pageIndex+1;
}
function focusCurId(id){
	_index = id;
	leaveFocusId = "poster"+(id+1);
}

function changeColor(flag,objId){
	leaveFocusId = "episode"+objId;
	if(flag==0){
		itemOnFocus(leaveFocusId,'numFocus'); 
	}else if(flag==1){
		itemOnBlur(leaveFocusId);
	}
}

//播放视频
function playBefore(idx){
	var id1=parseInt(idx);
	var index = 0;
	for(var j=0; j<_episodeNumList.length;j++){
		if(_episodeNumList[j]==id1){
			index = j;
		}
	}
	window.location.href=_playUrlList[index]+"&seriesCode=${context['EPG_CONTENT_CODE']}&episodeIndex="+id1;
}

//初始化
function init(){
	//上次观看定位焦点
	if("${userHistory}"!=""){
		var _episodeIndex = "${userHistory.episodeIndex}";
		var index = 0;
		for(var j=0; j<_episodeNumList.length;j++){
			if(_episodeNumList[j]==_episodeIndex){
				index = j;
			}
		}
		_pageIndex = parseInt((index)/40);
		for(i=1;i<=pageNums;i++){
			if(typeof(_episodeNumList[pageNums*(_pageIndex)+i-1])!='undefined'){	
				if(_episodeNumList[pageNums*(_pageIndex)+i-1]<10){
					document.getElementById("episode"+i+"_span").innerHTML = "0"+_episodeNumList[pageNums*(_pageIndex)+i-1];
				}else{
					document.getElementById("episode"+i+"_span").innerHTML = _episodeNumList[pageNums*(_pageIndex)+i-1];
				}
				document.getElementById("episode"+i+"_span").style.color="#1581c5";
				var str = "<a id=\"episode"+i+"_a\" href=\"#\" onfocus=\"changeColor(0,"+i+",'focusNums')\" onblur=\"changeColor(1,"+i+",'dot')\" onclick=\"playBefore(\'"+(_episodeNumList[pageNums*(_pageIndex)+i-1])+"\')\">";
				str += "<img id=\"episode"+i+"_img\" src=\"${context['EPG_CONTEXT']}/common/images/dot.gif\" border=\"0\" width=\"55\" height=\"42\"></a>";
				document.getElementById("episode"+i+"_div").innerHTML = str;
			}else{
				document.getElementById("episode"+i+"_span").innerHTML = "";
				document.getElementById("episode"+i+"_div").innerHTML = "";
			}
		}
		_pageIndex = _pageIndex+1;
		document.getElementById("episode"+((index)%40+1)+"_a").focus();
	}else{
		document.getElementById("episode1_a").focus();
	}
}

function getParam(name) {
	var reg = new RegExp("(^|;)" + name + "=([^;]*)(;|$)", "i");
	var r = window.location.search.substr(1).match(reg);
	if (r != null) return unescape(r[2]); return null;
}

//获得焦点事件 objId为焦点图片ID，img 高亮图片名称 不带后缀名，isChangeColor 是否改变文字列表颜色
function itemOnFocus(objId,img){
	if (pageLoad) {
		leaveFocusId = objId;
		document.getElementById(objId + "_img").src = imgPath + img + ".png";
	}
}
//失去焦点事件
function itemOnBlur(objId){
	if (pageLoad) {
		document.getElementById(objId + "_img").src = imgPath + "dot.gif";
	}
}
function returnToBizOrHistory(){
	//if("${param.returnTo}"!=""&&"${param.returnTo}"!=null){
	//	window.location.href=url;
	//}else{
		history.back();
	//}
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
			return 0;
	    	break;
	    case "SITV_KEY_PAGEDOWN":
			pageDown()
			return 0;
	    	break;
	    case "SITV_KEY_BACK":
	    	returnToBizOrHistory();
			return 0;
	    	break;
		case "SITV_KEY_EXIT":
			document.location.href = "${returnHomeUrl}";
			return 0;
			break;
	  case "SITV_KEY_MENU":
			iPanel.focus.display = 1;
			iPanel.focus.border = 1;
			//window.location.href = "${context['EPG_CONTEXT']}/common/logout/logout.jsp";
			document.location.href = "${returnHomeUrl}";
			return 0;
			break;
		default:
			return 1;
			break;
	}
}
</script>

<epg:body onload="init();" style="background-repeat:no-repeat;"
	bgcolor="#000000" defaultBg="./images/detailsSeriesImg.jpg" width="1280" height="720">
	<!-- 标题 -->
	<epg:text fontSize="24" color="#333333" left="275" top="115"
		width="125" height="52" align="center" chineseCharNumber="5" text="${context['EPG_BUSINESS'].title}"></epg:text>

	<!-- 返回首页 -->
	<epg:img id="back" src="./images/dot.gif" height="86" left="1117" top="12" width="102" href="javascript:returnToBizOrHistory();"
		onfocus="itemOnFocus('back','backToNursery')" onblur="itemOnBlur('back');" />

	<!-- 节目名 -->
	<epg:text fontSize="34" color="#1581c5" left="418" top="109"
		width="460" height="52" align="center" dotdotdot="…"
		chineseCharNumber="12" text="${series.title}"></epg:text>

	<!-- 内容详情 -->
	<epg:text fontSize="24" color="#000000" left="425" top="530"
		width="709" height="32" align="left" text="${summarys[0].content}"></epg:text>
	<epg:text fontSize="24" color="#000000" left="425" top="560"
		width="709" height="32" align="left" text="${summarys[1].content}"></epg:text>
	<epg:text fontSize="24" color="#000000" left="425" top="592"
		width="709" height="32" align="left" text="${summarys[2].content}"></epg:text>

	<!-- 内容海报 -->
	<epg:img id="poster" left="169" top="230" width="220" height="330"
		src="../${series.icon}" />

	<!-- 总集数 -->
	<div style="position: absolute; left: 653px; top: 187px; width: 208px; height: 30px; font-size: 26px;" align="left">
		<font color="#666666">共</font><font color="#d1821b">${series.episodeNumber}</font><font color="#666666">集</font>
	</div>

	<!-- 每一集内容 -->
	<div id="episodes"
		style="position: absolute; top: 228px; left: 440px; width: 660px; height: 200px;">
		<epg:forEach begin="0" end="3" varStatus="rowStatus">
			<epg:forEach begin="0" end="9" varStatus="colStatus">
				<epg:if test="${episodes[rowStatus.index*10+colStatus.index].episodeIndex!=null}">
					<epg:if test="${episodes[rowStatus.index*10+colStatus.index].episodeIndex<10}">
						<epg:text id="episode${rowStatus.index*10+colStatus.index+1}" left="${5+colStatus.index*66}" top="${13+rowStatus.index*51}"
								width="46" height="30" align="center" color="#1581c5" fontSize="26">
							0${episodes[rowStatus.index*10+colStatus.index].episodeIndex}
						</epg:text>
					</epg:if>
					<epg:if test="${episodes[rowStatus.index*10+colStatus.index].episodeIndex>=10}">
						<epg:text id="episode${rowStatus.index*10+colStatus.index+1}" left="${5+colStatus.index*66}" top="${13+rowStatus.index*51}" 
								width="46" height="30" align="center" color="#1581c5" fontSize="26">
							${episodes[rowStatus.index*10+colStatus.index].episodeIndex}
						</epg:text>
					</epg:if>
					<epg:img id="episode${rowStatus.index*10+colStatus.index+1}" left="${colStatus.index*66}" top="${rowStatus.index*51+5}" 
						width="55" height="42" src="./images/dot.gif" href="#" onclick="javascript:playBefore('${rowStatus.index*10+colStatus.index+1}')"
						onfocus="changeColor(0,${rowStatus.index*10+colStatus.index+1})" onblur="changeColor(1,${rowStatus.index*10+colStatus.index+1})" />
				</epg:if>
				<epg:if test="${episodes[rowStatus.index*10+colStatus.index].episodeIndex==null}">
					<epg:text id="episode${rowStatus.index*10+colStatus.index+1}" left="${5+colStatus.index*66}" top="${13+rowStatus.index*51}"
							width="46" height="30" align="center" color="#1581c5" fontSize="26">
						${episodes[rowStatus.index*10+colStatus.index].episodeIndex}
					</epg:text>
					<epg:img style="visibility:hidden;" id="episode${rowStatus.index*10+colStatus.index+1}"
						left="${colStatus.index*66+5}" top="${rowStatus.index*51+8}" width="55" height="42" src="./images/dot.gif" />
				</epg:if>
			</epg:forEach>
		</epg:forEach>
	</div>
	
	<!-- 提示上次观看到的集数 -->
	<epg:if test="${userHistory!=null}">
		<div
			style="position: absolute; left: 602px; top: 433px; width: 243px; height: 26px;">
			<font color="#888888" style="font-size: 17px">您上次观看到第</font><font
				color="#d1821b" style="font-size: 23px">${userHistory.episodeIndex}</font><font
				color="#888888" style="font-size: 17px">集</font>
		</div>
	</epg:if>

	<!--翻页-->
	<epg:img id="pageUp" left="429" top="179" src="./images/dot.gif" width="90" height="44" href="javascript:pageUp()"
		onfocus="itemOnFocus('pageUp','pageFocus');" onblur="itemOnBlur('pageUp');" />
	<epg:img id="pageDown" left="541" top="179" src="./images/dot.gif" width="90" height="44" href="javascript:pageDown()"
		onfocus="itemOnFocus('pageDown','pageFocus');" onblur="itemOnBlur('pageDown');" />
	
	<!-- 当前高清，显示标清 -->
	<epg:if test="${series.hdType=='1'}">
		<epg:if test="${SDrelContent!=null}">
			<epg:if test="${SDrelContent.relCodeFlag==1}">
				<epg:navUrl obj="${SDrelContent}" indexUrlVar="SDplayUrl"/>
				<epg:img id="HD_SD_change" left="929" top="179" src="./images/rainbow_detail_hd_sd.png" width="150" height="44" style="visibility:hidden;" href="${SDplayUrl}"
					onfocus="itemOnFocus('HD_SD_change','nurseryMenuFocus');" onblur="itemOnBlur('HD_SD_change');" />
				<epg:text left="929" top="189" width="150" height="44" align="center" color="#000000" fontSize="24" fontFamily="SimHei">进入标清版</epg:text>
			</epg:if>
		</epg:if>
	</epg:if>
	<!-- 当前标清，显示高清 -->
	<epg:if test="${series.hdType=='0'}">
		<epg:if test="${HDrelContent!=null}">
			<epg:if test="${HDrelContent.relCodeFlag==1}">
				<epg:navUrl obj="${HDrelContent}" indexUrlVar="HDplayUrl"/>
				<epg:img id="HD_SD_change" left="929" top="179" src="./images/rainbow_detail_hd_sd.png" width="150" height="44" style="visibility:hidden;" href="${HDplayUrl}"
					onfocus="itemOnFocus('HD_SD_change','nurseryMenuFocus');" onblur="itemOnBlur('HD_SD_change');" />
				<epg:text left="929" top="189" width="150" height="44" align="center" color="#000000" fontSize="24" fontFamily="SimHei">进入高清版</epg:text>
			</epg:if>
		</epg:if>
	</epg:if>
	<!-- Test -->
	<div style="visibility:hidden;">
		<epg:img id="HD_SD_change" left="929" top="179" src="./images/rainbow_detail_hd_sd.png" width="150" height="44" href="javascript:void(0);"
			onfocus="itemOnFocus('HD_SD_change','nurseryMenuFocus');" onblur="itemOnBlur('HD_SD_change');" />
		<epg:text left="929" top="189" width="150" height="44" align="center" color="#000000" fontSize="24" fontFamily="SimHei">进入标清版</epg:text>
	</div>
	
</epg:body>
</html>