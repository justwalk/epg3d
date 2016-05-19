<%@page contentType="text/html; charset=gbk" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
	String hisurl = request.getParameter("hisurl");
%>
<epg:query queryName="userCouldMark" maxRows="1" var="markProgram">
	<epg:param name="USER_ID" value="${userData.deviceId}" type="java.lang.String"/>
	<epg:param name="CONTENT_CODE" value="${PROGRAM.contentCode}" type="java.lang.String"/>
</epg:query>
<epg:if test="${context['EPG_CONTENT_TYPE']=='episode'}">
    <!-- 查询连续剧，返回Episode -->
    <epg:query queryName="querySeriesCodeByEpisodeCode" maxRows="1" var="series">
	    <epg:param name="contentCode" value="${context['EPG_CONTENT_CODE']}" type="java.lang.String"/>
    </epg:query>
	<epg:if test="${series!=null}">
		<!-- 查询剧集集数信息 -->
		<epg:query queryName="queryEpisodeByCode" maxRows="999" var="episodes">
			<epg:param name="seriesCode" value="${series.seriesCode}" type="java.lang.String" />
		</epg:query>
		<epg:set var="index" value="${series.episodeIndex}"></epg:set>
		<epg:if test="${fn:length(episodes) > index && index >0 && fn:length(episodes) > 1}">
		    <epg:navUrl obj="${episodes[index]}" playUrlVar="playUrl"/>
		</epg:if>
	</epg:if>
</epg:if>
<epg:navUrl obj="${PROGRAM}" addBookmarkUrlVar="addBookmarkUrl"></epg:navUrl>
<epg:navUrl returnTo="${param.returnTo}" returnUrlVar="returnBizUrl"></epg:navUrl>
<epg:html>
<title>play</title>
<link href="${context['EPG_CONTEXT']}/common/play/base.css" rel="stylesheet" type="text/css" />
<script src="${context['EPG_CONTEXT']}/common/play/play_keyAndEvent.js"></script>
<script src="${context['EPG_CONTEXT']}/js/ajax.js"></script>
<script>
//-----------服务器参数配置-------------
var _MAPIP = "10.11.2.60";
var _MAPPort = "554";
var _AAAIP = "10.11.2.50";
var _AAAPort = "18080";
//-----------服务器参数配置-------------
var _rtsp = "rtsp://"+_MAPIP+":"+_MAPPort+"/;purchaseToken=${startResponse.purchaseToken};serverID="+_AAAIP+":"+_AAAPort+";";
var _frequence = "${userData.frequence}";//VOD频点
var _elapsedCurrent = 0;//当前播放时间点
var _sid = null;//每秒执行任务id
var _hiddenId = null;//信息隐藏
var _visibleId = null;//信息显示
var _speed = 0;//快进、快退
var _maxSpeed = 32;//最大快进、快退
var _allTime = getIntValue("${PROGRAM.displayRunTime}");//总时长
var _returnUrl = "${returnBizUrl}";//返回地址
var _hisurl = "<%=hisurl%>";
var _nextPlayUrl = "${playUrl}&seriesCode=${series.seriesCode}&episodeIndex=${series.episodeIndex+1}&hisurl="+_hisurl;
var _currentUrl = window.location.href;
var _detailUrl = "${context['EPG_CONTEXT']}/biz/${context['EPG_BUSINESS_CODE']}/cat/${context['EPG_CATEGORY_CODE']}/det/series/${series.seriesCode}.do?vmType=csdv&entry=hdvod&returnTo=${param.returnTo}&hisurl="+_hisurl;
//----------音量----------
/*var flag = 0;//静音标识
var user = users.currentUser;
user.soundControl = 1;
var temp = media.sound.value;
media.sound.value = temp;*/
//------------------------
function eventHandler(eventObj){
	switch(eventObj.code){
		case "EIS_IRKEY_FAST_REWIND"://快退
			if($id("wait").style.visibility == "hidden" && $id("checkout").style.visibility == "hidden" && $id("start").style.visibility == "hidden" && $id("end").style.visibility == "hidden" && $id("seriesEnd").style.visibility == "hidden"){
				var status = media.AV.status;
				if(status=="PAUSE"||status=="pause"||status=="PLAY"||status=="play"){
					_speed = 15;
					media.AV.backward(_speed);
					$id("g_speed").innerText = "X-"+_speed;
					$id("imgStatus").src = "${context['EPG_CONTEXT']}/common/images/playVod/button_b.png";
				}else if(status=="FORWARD"||status=="forward"){
					media.AV.pause();
					$id("g_speed").innerText = "";
					$id("imgStatus").src = "${context['EPG_CONTEXT']}/common/images/playVod/button_s.png";
				}else if(status=="BACKWARD"||status=="backward"){
					if(_speed>=_maxSpeed){
						_speed = 15;
						media.AV.backward(_speed);
						$id("g_speed").innerText = "X-"+_speed;
					}else{
						_speed = _maxSpeed;
						media.AV.backward(_speed);
						$id("g_speed").innerText = "X-"+_speed;
					}
					$id("imgStatus").src = "${context['EPG_CONTEXT']}/common/images/playVod/button_b.png";
				}
			}
			return 0;
			break;
		case "EIS_IRKEY_FAST_FORWARD"://快进
			if($id("wait").style.visibility == "hidden" && $id("checkout").style.visibility == "hidden" && $id("start").style.visibility == "hidden" && $id("end").style.visibility == "hidden" && $id("seriesEnd").style.visibility == "hidden"){
				var status = media.AV.status;
				if(status=="PAUSE"||status=="pause"||status=="PLAY"||status=="play"){
					_speed = 15;
					media.AV.forward(_speed);
					$id("g_speed").innerText = "X"+_speed;
					$id("imgStatus").src = "${context['EPG_CONTEXT']}/common/images/playVod/button_g.png";
				}else if(status=="BACKWARD"||status=="backward"){
					media.AV.pause();
					$id("g_speed").innerText = "";
					$id("imgStatus").src = "${context['EPG_CONTEXT']}/common/images/playVod/button_s.png";
				}else if(status=="FORWARD"||status=="forward"){
					if(_speed>=_maxSpeed){
						_speed = 15;
						media.AV.forward(_speed);
						$id("g_speed").innerText = "X"+_speed;
					}else{
						_speed = _maxSpeed;
						media.AV.forward(_speed);
						$id("g_speed").innerText = "X"+_speed;
					}
					$id("imgStatus").src = "${context['EPG_CONTEXT']}/common/images/playVod/button_g.png";
				}
			}
			return 0;
			break;
		case "EIS_IRKEY_PAUSE"://确定、暂停
		case "EIS_IRKEY_SELECT":
			if($id("wait").style.visibility == "hidden" && $id("checkout").style.visibility == "hidden" && $id("input_box").style.visibility == "hidden" && $id("start").style.visibility == "hidden" && $id("end").style.visibility == "hidden" && $id("seriesEnd").style.visibility == "hidden"){
				var status = media.AV.status;
				if(status=="PLAY"||status=="play"){
					media.AV.pause();
					$id("g_speed").innerText = "";
					$id("imgStatus").src = "${context['EPG_CONTEXT']}/common/images/playVod/button_s.png";
				}else if(status=="PAUSE"||status=="pause"){
					media.AV.play();
					$id("g_speed").innerText = "";
					setTimeout("hiddenMain()",5000);
					$id("imgStatus").src = "${context['EPG_CONTEXT']}/common/images/playVod/button_q.png";
				}else if(status=="FORWARD"||status=="BACKWARD"||status=="forward"||status=="backward"){
					media.AV.play();
					$id("g_speed").innerText = "";
					setTimeout("hiddenMain()",5000);
					$id("imgStatus").src = "${context['EPG_CONTEXT']}/common/images/playVod/button_q.png";
				}
				return 0;
			}
			if($id("checkout").style.visibility == "visible"){
				if(_returnUrl!=""&&_returnUrl!="undefined"){
					window.location.href = _returnUrl;
				}else{
					history.back();
				}
				return 0;
			}
			if($id("input_box").style.visibility == "visible"){
				chooseTime();
				return 0;
			}
			break;
		case "KEY_VOLUME_UP"://音量加
		case "KEY_VOLUME_DOWN"://音量减
			var volumeo = iPanel.pageWidgets.getByName("volume");
			volumeo.init();
	        volumeo.show();
			break;
		case "EIS_IRKEY_VOLUME_MUTE":
			if(flag==0){
				media.sound.mute();
				$id("mutePic").style.visibility = "visible";
				flag = 1;
			}else if(flag==1){
				media.sound.resume();
				$id("mutePic").style.visibility = "hidden";
				flag = 0;
			}
			return 0;
			break;
		case "EIS_IRKEY_RED"://信息
			if($id("wait").style.visibility == "hidden" && $id("checkout").style.visibility == "hidden" && $id("start").style.visibility == "hidden" && $id("end").style.visibility == "hidden" && $id("seriesEnd").style.visibility == "hidden"){
				if($id("main").style.visibility == "hidden"){
					$id("main").style.visibility = "visible";
				}else{
					$id("main").style.visibility = "hidden";
				}
			}
			return 0;
			break;
		case "EIS_IRKEY_GREEN"://选时
		case "EIS_IRKEY_YELLOW":
			if($id("input_box").style.visibility == "hidden" && $id("wait").style.visibility == "hidden" && $id("checkout").style.visibility == "hidden" && $id("start").style.visibility == "hidden" && $id("end").style.visibility == "hidden" && $id("seriesEnd").style.visibility == "hidden"){
				setDisplay_loc(1);
				media.AV.pause();
				$id("g_speed").innerText = "";
				$id("imgStatus").src = "${context['EPG_CONTEXT']}/common/images/playVod/button_s.png";
			}else if($id("input_box").style.visibility == "visible"){
				setDisplay_loc(0);
				media.AV.play();
				$id("g_speed").innerText = "";
				setTimeout("hiddenMain()",5000);
				$id("imgStatus").src = "${context['EPG_CONTEXT']}/common/images/playVod/button_q.png";
			}
			return 0;
			break;
		case "EIS_IRKEY_MENU"://屏蔽菜单
			media.AV.close();
			iPanel.focus.display = 1;
			iPanel.focus.border = 1;
			window.location.href = "ui://index.htm";
			return 0;
			break;
		case "EIS_IRKEY_BACK"://屏蔽返回
			if($id("input_box").style.visibility == "visible"){
				setDisplay_loc(0);
				media.AV.play();
			}else{
				$id("checkout").style.visibility = "hidden";
				$id("checkoutContent").style.visibility = "hidden";
				$id("wait").style.visibility = "hidden";
				$id("main").style.visibility = "hidden";
				$id("start").style.visibility = "hidden";
				$id("seriesEnd").style.visibility = "hidden";
				$id("end").style.visibility = "visible";
			}
			return 0;
			break;
		case "EIS_IRKEY_PLAY_EXIT"://弹出退出选择框
			$id("checkout").style.visibility = "hidden";
			$id("checkoutContent").style.visibility = "hidden";
			$id("wait").style.visibility = "hidden";
			$id("main").style.visibility = "hidden";
			$id("start").style.visibility = "hidden";
			$id("seriesEnd").style.visibility = "hidden";
			$id("end").style.visibility = "visible";
			return 0;
			break;
	 	case "EIS_IRKEY_EXIT"://弹出退出选择框
			$id("checkout").style.visibility = "hidden";
			$id("checkoutContent").style.visibility = "hidden";
			$id("wait").style.visibility = "hidden";
			$id("main").style.visibility = "hidden";
			$id("start").style.visibility = "hidden";
			$id("seriesEnd").style.visibility = "hidden";
			$id("end").style.visibility = "visible";
			return 0;
			break;
	 	case "EIS_IRKEY_MAIN_PAGE"://弹出退出选择框
      		break;
	 	case "5226"://表示VOD模块接收TSTV 数据成功
	 		var areaCode = VOD.server.nodeGroupID;
      		iPanel.debug("捕获5226消息，获取得到区域码为：" + VOD.server.nodeGroupID);
	 		$id("wait").style.visibility = "hidden";
	 		playVideo(_rtsp, areaCode);
	 		break;
	 	case "5202"://EIS_VOD_PREPAREPLAY_SUCCESS
	 		if("${markProgram.contentElapsed}"==""){
	 			media.AV.play();
	 		}else{
	 			$id("start").style.visibility = "visible";
	 		}
	 		//media.AV.play();
			$id("g_speed").innerText = "";
	 		return 0;
		 	break;
	 	case "5205"://EIS_VOD_PLAY_SUCCESS
	 		_sid = setInterval(showCurrentTime, 1000);
	 		_visibleId = setInterval(visibleMain, 1000);
		 	break;
	 	case "5225"://error
	 		visibleCheckOut(eventObj.args.modifiers);
	 		break;
	 	case "5227"://区域码获取失败
	 		var areaCode = VOD.server.nodeGroupID;
      		iPanel.debug("捕获5227消息，获取得到区域码为：" + VOD.server.nodeGroupID);
	 		visibleCheckOut(5227);
		 	break;
	 	case "5209"://文件到头
	 		//visibleCheckOut(5209);
	 		media.AV.play();
			$id("g_speed").innerText = "";
			setTimeout("hiddenMain()",5000);
			$id("imgStatus").src = "${context['EPG_CONTEXT']}/common/images/playVod/button_q.png";
		 	break;
	 	case "5210"://文件到尾
		 	if("${markProgram.id}"==""){
		 		if("${playUrl}"!=""){
			 		$id("checkout").style.visibility = "hidden";
					$id("checkoutContent").style.visibility = "hidden";
					$id("wait").style.visibility = "hidden";
					$id("main").style.visibility = "hidden";
					$id("start").style.visibility = "hidden";
					$id("end").style.visibility = "hidden";
					$id("seriesEnd").style.visibility = "visible";
				}else{
					visibleCheckOut(5210);
				}
			}else{
				deleteMark("${markProgram.id}");
			}
		 	break;
	 	case "5203"://网络故障
	 		//visibleCheckOut(5203);
		 	break;
	 	case "5206"://锁频失败
	 		visibleCheckOut(5206);
		 	break;
	 	case "5301"://未插卡
	 		visibleCheckOut(5301);
		 	break;
	 	case "EIS_CABLE_NETWORK_DISCONNECT"://cable线没有连接上的消息
	 		visibleCheckOut(5551);
		 	break;
	 	case "EIS_CABLE_NETWORK_CONNECT"://插上cable线的消息
		 	return 1;
		 	break;
	 	case "EIS_CA_SMARTCARD_EVULSION"://拔出智能卡
	 		visibleCheckOut(5301);
		 	break;
	 	case "EIS_CA_SMARTCARD_INSERT"://插入智能卡
	 		return 1;
		 	break;
	 	case "5503"://测试错误
	 		visibleCheckOut(5503);
		 	break;
     }
}
//checkout
function visibleCheckOut(code){
	$id("checkout").style.visibility = "visible";
	$id("checkoutContent").style.visibility = "visible";
	$id("seriesEnd").style.visibility = "hidden";
	$id("wait").style.visibility = "hidden";
	$id("main").style.visibility = "hidden";
	$id("start").style.visibility = "hidden";
	$id("end").style.visibility = "hidden";
	switch(code){
		case 400:
		case 403:
		case 404:
		case 405:
		case 406:
		case 408:
		case 413:
		case 415:
		case 451:
		case 453:
		case 454:
		case 457:
		case 461:
		case 462:
		case 500:
		case 510:
			$id("checkoutContent_span").innerHTML = "网络连接失败，请退出重试或联系52725610<br>服务代码："+code;
			break;
		case 5227:
			$id("checkoutContent_span").innerHTML = "请退出重试或联系52725610<br>服务代码：5227";
			break;
		/*case 5209:
			$id("checkoutContent_span").innerHTML = "请退出重试或联系52725610<br>服务代码：5209";
			break;*/
		case 5210:
			$id("checkoutContent_span").innerHTML = "视频已播放到尾";
			break;
		case 5203:
			$id("checkoutContent_span").innerHTML = "请确认机顶盒的网线连接并退出重试或联系52725610<br>服务代码：5203";
			break;
		case 5206:
			$id("checkoutContent_span").innerHTML = "请退出重试或联系52725610<br>服务代码：5206";
			break;
		case 5301:
			$id("checkoutContent_span").innerHTML = "请插入智能卡并退出重试或联系52725610<br>服务代码：5301";
			break;
		case 5551:
			$id("checkoutContent_span").innerHTML = "请退出重试或联系52725610<br>服务代码：5551";
			break;
		case 5503:
			$id("checkoutContent_span").innerHTML = "请退出重试或联系52725610<br>服务代码：5503";
			break;
	}
}
function hiddenCheckOut(code){
	$id("checkout").style.visibility = "hidden";
	$id("checkoutContent").style.visibility = "hidden";
}
//----------------定时任务------------------begin
function showCurrentTime(){
	_elapsedCurrent = media.AV.elapsed;
	var hour = Math.floor(_elapsedCurrent/3600);
	var minute = Math.floor((_elapsedCurrent - hour*3600)/60);
	var second = _elapsedCurrent-minute*60-hour*3600;
	if(hour<10)hour="0"+hour;
	if(minute<10)minute="0"+minute;
	if(second<10)second="0"+second;
	$id("play_time_span").innerText = hour+":"+minute+":"+second;
	$id("imgTimeControl").width = (parseInt(_elapsedCurrent/(_allTime*60)*700)).toString();
	$id("cicle").style.left = (parseInt(_elapsedCurrent/(_allTime*60)*700+220)).toString();
}
function hiddenMain(){
	var status = media.AV.status;
	if(status=="PLAY"||status=="play"){
		$id("main").style.visibility = "hidden";
		$id("g_button").style.visibility = "hidden";
	}
}
function visibleMain(){
	var status = media.AV.status;
	if(status!="PLAY"&&status!="play"){
		$id("main").style.visibility = "visible";
		$id("g_button").style.visibility = "visible";
	}
}
//----------------定时任务------------------end
//----------------选时操作------------------begin
function setPostionTipDisplay(isdisplay, type){
	var str = "";
	switch (type) {
		case 0:
			str = "输入时间超过总时间";
			break;
		case 1:
			str = "输入时间无效";
			break;
	}
    if (str != "") {
        $id("locationTip").innerText = decodeURIComponent(str);
    }
	if(isdisplay && getDisplay_loc()) {
		$id("locationTip").style.visibility = "visible";
	} else {
		$id("locationTip").style.visibility = "hidden";
	}
}
function getDisplay_loc(){
	return ($id("input_box").style.visibility != "hidden");
}
function setDisplay_loc(isdisplay) {
	if(isdisplay == 1) {
		$id("input_box").style.visibility = "visible";
		$id("txtInput").focus();
	} else {
		$id("input_box").style.visibility = "hidden";
		$id("txtInput").blur();
		setPostionTipDisplay(false, -1);
	}
}
function chooseTime(){
	if(getDisplay_loc()){
		var txtTime = $id("txtInput").value;
		if(txtTime == "" || txtTime == null) {
			setPostionTipDisplay(true, 1);
			return;
		}
		if(isNaN(txtTime)) {
			setPostionTipDisplay(true, 1);
			return;
		}
		var time = getIntValue(txtTime) * 60;
		if(time - _allTime*60 > 0) {
			setPostionTipDisplay(true, 0);
		}else{
			setDisplay_loc(0);
			mediaSeek(time);
		}
		$id("txtInput").value = "";
		$id("txtInput").innerText = "";
	}
}
function mediaSeek(time){
	var elapsedCurrent = time;
	var hour = Math.floor(elapsedCurrent/3600);
	var minute = Math.floor((elapsedCurrent - hour*3600)/60);
	var second = elapsedCurrent-minute*60-hour*3600;
	if(hour<10)hour="0"+hour;
	if(minute<10)minute="0"+minute;
	if(second<10)second="0"+second;
    var goto_time = hour+":"+minute+":"+second;
    media.AV.seek(goto_time);
	$id("g_speed").innerText = "";
	setTimeout("hiddenMain()",5000);
}
//----------------选时操作------------------end
//SETUP发起请求
function playVideo(str,areaCode){
	var qam_name = "" + areaCode;
    var client = CA.card.serialNumber;
	var rtsp_url =str+"qam_name="+qam_name+";client="+client;
	VOD.changeServer("cisco_dmx", "dvb");
	//alert(rtsp_url);
    iPanel.debug("rtsp_url：" + rtsp_url);
    media.AV.open(rtsp_url, "VOD");
    media.video.fullScreen();
}
//载入
function init(){
	  //--------------测试----------------
    //var date = new Date();
		//document.write(date.getFullYear()+"-"+date.getMonth()+"-"+date.getDate()+" "+date.getHours()+":"+date.getMinutes()+":"+date.getSeconds()+":"+date.getMilliseconds());
    //--------------end-----------------
    iPanel.debug("SiTV执行获取点播频点方法完毕获取频点值_frequence为" + _frequence);
    iPanel.debug("SiTV-VOD.server.enterVOD-----start");
    VOD.changeServer("cisco_dmx", "dvb");
		VOD.server.enterVOD(parseInt(_frequence));
		iPanel.debug("SiTV-VOD.server.enterVOD-----end");
}
function playMark(n){
	if(n=='1'){
		var elapsed = parseInt("${markProgram.contentElapsed}");
		if(elapsed>5){
			elapsed = elapsed-5;
		}
		var hour = Math.floor(elapsed/3600);
		var minute = Math.floor((elapsed - hour*3600)/60);
		var second = elapsed-minute*60-hour*3600;
		if(hour<10)hour="0"+hour;
		if(minute<10)minute="0"+minute;
		if(second<10)second="0"+second;
		var seek = hour+":"+minute+":"+second;
		media.AV.seek(seek);
	}else{
		media.AV.play();
	}
	$id("start").style.visibility = "hidden";
	$id("buttonOk_start").style.visibility = "hidden";
	$id("buttonCancel_start").style.visibility = "hidden";
}
//下面函数加上就行
function init_ad_widget(){//初始化音量广告
   if(!iPanel.eventFrame.volume_ad.ADWindow){
		iPanel.eventFrame.volume_ad.ADWindow=iPanel.eventFrame.FreeADWindow.shift();
		if(iPanel.eventFrame.volume_ad.ADWindow){
			iPanel.eventFrame.volume_ad.ADWindow.resizeTo(0,0);
			iPanel.eventFrame.volume_ad.ADWindow.isResizeToZero=true;
			iPanel.eventFrame.volume_ad.refreshed=false;
		}
	}
}
function checkIdToRefreshAD(id_array){
	var len=id_array.length;
	for(var i=0; i<len; i++){
	var tmp_id=id_array[i];
		switch(tmp_id){	
			case iPanel.eventFrame.volume_ad.id:
				iPanel.eventFrame.volume_ad.refreshed=false;
				iPanel.eventFrame.volume_ad.refreshAD();
			break;	
		}
	}
}
//开始刷新广告 （收到8424，或者刚进页面，调用此函数）
function ADTReload(){
	iPanel.eventFrame.volume_ad.refreshed = false;
	iPanel.eventFrame.volume_ad.refreshAD();
}
//退出页面是关广告
function exit_ad_widget(){
  
   if(iPanel.eventFrame.volume_ad.ADWindow){
		iPanel.eventFrame.volume_ad.ADWindow.minimize();
		iPanel.eventFrame.FreeADWindow.push(iPanel.eventFrame.volume_ad.ADWindow);
		iPanel.eventFrame.volume_ad.ADWindow = null;		
	}
}
//卸载
function end(){
	if(_sid!=null){
		clearInterval(_sid);
		clearInterval(_visibleId);
		media.AV.close();
	}else{
		media.AV.close();
	}
	//exit_ad_widget();
}
//基本功能
function $id(id) {
	return document.getElementById(id);
}
function getIntValue(val) {
	if(val != null && val != "" && !isNaN(val))
		return parseInt(val, 10);
	return 0;
}
function back(){
	ajaxMark();
}
function button_blur(idd){
	$id(idd).style.visibility = "hidden";
}
function button_focus(idd){
	$id(idd).style.visibility = "visible";
}
function hiddenEnd(){
	$id("end").style.visibility = "hidden";
	$id("buttonOk_end").style.visibility = "hidden";
	$id("buttonCancel_end").style.visibility = "hidden";
}
function seriesOK(){
	end();
	window.location.href = _nextPlayUrl+"&returnTo=${param.returnTo}";
}
function seriesCancel(){
	end();
	//window.location.href = _detailUrl;
	hiddenEnd();
}
function ajaxMark(){
	var markTime = media.AV.elapsed;
	if(typeof(markTime)=='undefined'){
		markTime = 0;
	}
	var markUrl = "${addBookmarkUrl}&contentElapsed="+markTime;
	var markAjax = new AJAX_OBJ(markUrl,markResponse);
	markAjax.requestData();
}
function markResponse(xmlHttpResponse){
	if("${series.seriesCode}"!=null && "${series.seriesCode}"!=""){
		window.location.href = _detailUrl;
	}else if(_returnUrl!=""&&_returnUrl!="undefined"){
		window.location.href = _returnUrl;
	}else{
		history.back();
	}
	end();
}
function deleteMark(mId){
	var delMarkUrl =  "${context['EPG_CONTEXT']}/deleteBookmark.do?id=" + mId;
	var delMarkAjax = new AJAX_OBJ(delMarkUrl,delMarkResponse);
	delMarkAjax.requestData();
}
function delMarkResponse(xmlHttpResponse){
	if("${playUrl}"!=""){
 		$id("checkout").style.visibility = "hidden";
		$id("checkoutContent").style.visibility = "hidden";
		$id("wait").style.visibility = "hidden";
		$id("main").style.visibility = "hidden";
		$id("start").style.visibility = "hidden";
		$id("end").style.visibility = "hidden";
		$id("seriesEnd").style.visibility = "visible";
	}else{
		visibleCheckOut(5210);
	}
}
</script>
<body onLoad="init();" bgColor="transparent" onUnload="end();">
<epg:if test="${markProgram.contentElapsed==null}">
	<epg:playlog log="${userData.account}|${userData.client}|${userData.deviceId}|play|0|${context['EPG_CONTENT_TYPE']}|${context['EPG_CONTENT_CODE']}|${context['EPG_BUSINESS_CODE']}|${context['EPG_CATEGORY_CODE']}|${OFFERING.offeringId}|${OFFERING.serviceType}|${OFFERING.serviceName}|${OFFERING.serviceCode}|${PROGRAM.runTime}|${PROGRAM.fileName}"/>
</epg:if>
<epg:if test="${markProgram.contentElapsed!=null}">
	<epg:playlog log="${userData.account}|${userData.client}|${userData.deviceId}|play|${markProgram.contentElapsed}|${context['EPG_CONTENT_TYPE']}|${context['EPG_CONTENT_CODE']}|${context['EPG_BUSINESS_CODE']}|${context['EPG_CATEGORY_CODE']}|${OFFERING.offeringId}|${OFFERING.serviceType}|${OFFERING.serviceName}|${OFFERING.serviceCode}|${PROGRAM.runTime}|${PROGRAM.fileName}"/>
</epg:if>
	<div id="wait" style="position:absolute;top:0px;left:0px;width:1280px;height:720px;visibility:visible;z-index:-2">
		<div style="position:absolute;top:0px;left:0px;width:1280px;height:720px;">
			<img src="${context['EPG_CONTEXT']}/common/images/playVod/wait.jpg" width="1280" height="720"/></div>
		<div style="position:absolute;top:180px;left:550px;width:114px;height:102px;">
			<img src="${context['EPG_CONTEXT']}/common/images/playVod/0.png" width="114" height="102"/></div>
	</div>
	<div id="start" style="position:absolute;top:0px;left:0px;width:1280px;height:720px;visibility:hidden;z-index:-2">
		<div style="position:absolute;top:194px;left:432px;width:426px;height:254px;">
			<img src="${context['EPG_CONTEXT']}/common/images/playVod/start.png" width="426" height="254"/></div>
		<div style="position:absolute;top:383px;left:532px;width:102px;height:40px;">
			<a href="#" onClick="playMark('1')" onBlur="button_blur('buttonOk_start')" onFocus="button_focus('buttonOk_start')">
				<img src="${context['EPG_CONTEXT']}/common/images/playVod/dot.gif" width="102" height="40"/></a></div>
		<div style="position:absolute;top:383px;left:644px;width:102px;height:40px;">
			<a href="#" onClick="playMark('0')"  onblur="button_blur('buttonCancel_start')" onFocus="button_focus('buttonCancel_start')">
				<img src="${context['EPG_CONTEXT']}/common/images/playVod/dot.gif" width="102" height="40"/></a></div>
	</div>
	<div id="end" style="position:absolute;top:0px;left:0px;width:1280px;height:720px;visibility:hidden;z-index:-2">
		<div style="position:absolute;top:194px;left:432px;width:426px;height:254px;">
			<img src="${context['EPG_CONTEXT']}/common/images/playVod/end.png" width="426" height="254"/></div>
		<div style="position:absolute;top:383px;left:532px;width:102px;height:40px;">
			<a href="#" onClick="back()" onBlur="button_blur('buttonOk_end')" onFocus="button_focus('buttonOk_end')">
				<img src="${context['EPG_CONTEXT']}/common/images/playVod/dot.gif" width="102" height="40"/></a></div>
		<div style="position:absolute;top:383px;left:644px;width:102px;height:40px;">
			<a href="#" onClick="hiddenEnd()"  onblur="button_blur('buttonCancel_end')" onFocus="button_focus('buttonCancel_end')">
				<img src="${context['EPG_CONTEXT']}/common/images/playVod/dot.gif" width="102" height="40"/></a></div>
	</div>
	<epg:if test="${playUrl!=null}">
		<div id="seriesEnd" style="position:absolute;top:0px;left:0px;width:1280px;height:720px;visibility:hidden;z-index:-2">
			<div style="position:absolute;top:194px;left:432px;width:426px;height:254px;">
				<img src="${context['EPG_CONTEXT']}/common/images/playVod/seriesEnd.png" width="426" height="254"/></div>
			<div style="position:absolute;top:383px;left:532px;width:102px;height:40px;">
				<a href="#" onClick="seriesOK()" onBlur="button_blur('buttonOk_end')" onFocus="button_focus('buttonOk_end')">
					<img src="${context['EPG_CONTEXT']}/common/images/playVod/dot.gif" width="102" height="40"/></a></div>
			<div style="position:absolute;top:383px;left:644px;width:102px;height:40px;">
				<a href="#" onClick="seriesCancel()"  onblur="button_blur('buttonCancel_end')" onFocus="button_focus('buttonCancel_end')">
					<img src="${context['EPG_CONTEXT']}/common/images/playVod/dot.gif" width="102" height="40"/></a></div>
		</div>
	</epg:if>
	<epg:if test="${playUrl==null}">
		<div id="seriesEnd" style="position:absolute;top:0px;left:0px;width:1280px;height:720px;visibility:hidden;z-index:-2">
		</div>
	</epg:if>
	<!--高亮-->
	<div id="buttonOk_start" style="position:absolute;top:383px;left:532px;width:102px;height:40px;visibility:hidden">
			<img src="${context['EPG_CONTEXT']}/common/images/playVod/button_ok.png" width="102" height="40"/></div>
	<div id="buttonCancel_start" style="position:absolute;top:383px;left:644px;width:102px;height:40px;visibility:hidden">
		<img src="${context['EPG_CONTEXT']}/common/images/playVod/button_cancel.png" width="102" height="40"/></div>
	<div id="buttonOk_end" style="position:absolute;top:383px;left:532px;width:102px;height:40px;visibility:hidden">
		<img src="${context['EPG_CONTEXT']}/common/images/playVod/button_ok.png" width="102" height="40"/></div>
	<div id="buttonCancel_end" style="position:absolute;top:383px;left:644px;width:102px;height:40px;visibility:hidden">
		<img src="${context['EPG_CONTEXT']}/common/images/playVod/button_cancel.png" width="102" height="40"/></div>
	
	<div id="test" style="position:absolute;"></div>
	<div id="mutePic" style="visibility:hidden;background:url(${context['EPG_CONTEXT']}/common/images/playVod/static_bg.png) no-repeat;position:absolute;left:220px;top:80px;width:78px;height:64px;"></div>
	<div id="g_track" style="visibility:hidden;background:url(${context['EPG_CONTEXT']}/common/images/playVod/track_bg.png) no-repeat;position:absolute;left:900px;top:63px;width:155px;height:62px;font-size:26px;line-height:62px;text-align:center;"></div>
	<div id="g_button" style="visibility: hidden;"><img id="imgStatus" src="${context['EPG_CONTEXT']}/common/images/playVod/button_q.png" width="76" height="75" />
	</div>
	<div id="g_speed"></div>
	<div id="input_box" style="visibility:hidden;">
	<div id="location_bg"><img src="${context['EPG_CONTEXT']}/common/images/playVod/l_position.png" />
	</div>
	<div id="location_div">
		<input id="txtInput" style="BACKGROUND-COLOR:Transparent; border:0px;width:100px;color:#fff;outline: #000;font-size:120%;" type="text" value="" />
		<span id="fen" style="position:absolute;left:110px;top:0px;width:129px;height:26px;font-size:18px;">分</span>
	</div>
	<div id="locationTip" style="visibility:hidden;position:absolute;left:730px;top:324px;color:red;font-size:26px;width:260px;">
			输入时间比总时间长。
		</div>
	</div>
	<div id="main" style="visibility:hidden;">
		<!--end_定位时间-->
	<p style="position:absolute;left:100px;top:488px;background:url(${context['EPG_CONTEXT']}/common/images/playVod/g_bg_1.png) no-repeat;width:1037px;height:162px;"></p>
		<div id="live_p"></div>
		<div id="begin_time">
			<span id="play_time_span">00:00:00</span>
		</div>
		<div id="end_time">
			${PROGRAM.runTime}
		</div>
		<div id="play_time">
			${PROGRAM.title}
		</div>
		<div id="play_program"></div>
		<div id="begin_end_time">
			<p id="g_c"><img id="imgTimeControl" src="${context['EPG_CONTEXT']}/common/images/playVod/g_c.png" width="0" height="14" /></p>
			<p><img id="cicle" src="${context['EPG_CONTEXT']}/common/images/playVod/circle.png" width="33" height="35" /></p>
		</div>
	</div>
	<div id="dv_voice" style="visibility:hidden;color:#ffffff;">
		<p id="vo"><img src="${context['EPG_CONTEXT']}/common/images/playVod/vo.png" width="800" height="58" /></p>
		<p class="vo_g" id="imgPosition"><img src="${context['EPG_CONTEXT']}/common/images/playVod/vo_g.png" width="28" height="18" /></p>
		<p class="vo_gre"><img src="${context['EPG_CONTEXT']}/common/images/playVod/vo_gre.png" width="0" height="6" id="imgVoice"/></p>
		<p class="vo_vo" id="txtVoice"></p>
	</div>
	<div id="checkout" style="visibility:hidden;">
	<!--退出-->
		<div id="checkoutOk" style="position:absolute;top:178px;left:140px;">
			<img src="${context['EPG_CONTEXT']}/common/images/playVod/y_button_s.png" name="Image1" width="101" height="43" border="0" id="Image1" />
		</div>
	</div>
	<div id="checkoutContent" style=" text-align:center;visibility:hidden;">
		<span id="checkoutContent_span">
			无权限播控！
		</span>
	</div>
	<div id="info" style="position:absolute;top:50px;left:50px;color:#ffffff"></div>
</body>
</epg:html>