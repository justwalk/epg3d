<%@page contentType="text/html; charset=gbk" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<epg:html>

<epg:navUrl returnTo="${param.returnTo}" returnUrlVar="returnBizUrl"></epg:navUrl>
<%
    request.getSession().removeAttribute("productInfo");
%>
<script src="<%=request.getContextPath()%>/js/ajax.js"></script>
<script src="<%=request.getContextPath()%>/js/base.js"></script>
<script src="<%=request.getContextPath()%>/common/play/play_keyAndEvent.js"></script>
<script>
iPanel.focus.border = 1;
iPanel.focus.display = 1;

function returnToBizOrHistory(){
	if("${param.returnTo}"!=""&&"${param.returnTo}"!=null){
		window.location.href="${returnBizUrl}";
		}else{
		history.back();
			}
	}

function eventHandler(eventObj)
{
	switch(eventObj.code)
	{
		case "KEY_NUMERIC"://数字键
			clearTimeout(timeoutDisplay);
			timeoutDisplay = setTimeout("hidePlayInfo()",10000);
			if(timePosition==1){
				document.getElementById("time1_span").innerText = eventObj.args.value;
				document.getElementById("time1").style.display = "none";
				document.getElementById("time1_span").style.color = "#000000"
				document.getElementById("time2").style.display = "block";
				document.getElementById("time2_span").style.color = "#ffffff";
				timePosition = 2;
			}else if(timePosition==2){
				document.getElementById("time2_span").innerText = eventObj.args.value;
				document.getElementById("time2").style.display = "none";
				document.getElementById("time2_span").style.color = "#000000"
				document.getElementById("time3").style.display = "block";
				document.getElementById("time3_span").style.color = "#ffffff";
				timePosition = 3;
			}else if(timePosition==3){
				document.getElementById("time3_span").innerText = eventObj.args.value;
			}
			return 0;
			break;
		case "EIS_IRKEY_SELECT": //确定
			if(document.getElementById("exitPlay").style.display == "none" && document.getElementById("proHead").style.display == "none" && document.getElementById("downPlayAgain").style.display == "none" && document.getElementById("endPlay").style.display == "none" && document.getElementById("time_out").style.display == "none" && document.getElementById("ad").style.display == "none" && document.getElementById("message_error").style.display == "none"){
				if(document.getElementById("red").style.display == "block"){
					var status = media.AV.status;
					if(status=="PLAY"||status=="play"){
						clearTimeout(timeoutDisplay);
						media.AV.pause();
						clearTimeout(timeOut);
						markTime = media.AV.elapsed;
						timeOut = setTimeout("show_timeoutExit()",600000);
						document.getElementById("play_block_img").src = "${context['EPG_CONTEXT']}/common/images/pause.gif";
						document.getElementById("play_info").style.display = "block";
						hideChooseInfo();
					}else if(status=="PAUSE"||status=="FORWARD"||status=="BACKWARD"||status=="pause"||status=="forward"||status=="backward"){
						media.AV.play();
						clearInterval(sid);
						count = 10;
						document.getElementById("count").innerHTML = "10";
						clearTimeout(timeOut);
						document.getElementById("play_block_img").src = "${context['EPG_CONTEXT']}/common/images/play.gif";
						document.getElementById("play_info").style.display = "block";
						hideChooseInfo();
						clearTimeout(timeoutDisplay);
						timeoutDisplay = setTimeout("hidePlayInfo()",10000);
					}
				}else{
					var time1 = document.getElementById("time1_span").innerText;
					var time2 = document.getElementById("time2_span").innerText;
					var time3 = document.getElementById("time3_span").innerText;
					var timeTotal = time1+time2+time3;
					var timeInt = parseInt(timeTotal*60);
					if(timeInt<=secondTotal){
						var hour = Math.floor(timeInt/3600);
						var minute = Math.floor((timeInt - hour*3600)/60);
						var second = timeInt-minute*60-hour*3600;
						if(hour<10)hour="0"+hour;
						if(minute<10)minute="0"+minute;
						if(second<10)second="0"+second;
						timeTotal = hour+":"+minute+":"+second;
						media.AV.seek(timeTotal);
						clearInterval(sid);
						count = 10;
						document.getElementById("count").innerHTML = "10";
						clearTimeout(timeOut);
						hideChooseInfo();
						document.getElementById("play_block_img").src = "${context['EPG_CONTEXT']}/common/images/play.gif";
						clearTimeout(timeoutDisplay);
						timeoutDisplay = setTimeout("hidePlayInfo()",10000);
					}else{
						document.getElementById("message").style.display = "block";
						document.getElementById("message_title").innerHTML = "选定时间不在有效范围内";
						clearTimeout(timeoutMessage);
						timeoutMessage = setTimeout("cableHide()",2000);
					}
				}
				return 0;
			}else{
			}
			break;
		case "EIS_IRKEY_YELLOW"://黄键书签取消
			return 0;
			break;
		case "EIS_IRKEY_RED"://红键选时
			if(document.getElementById("exitPlay").style.display == "none" && document.getElementById("proHead").style.display == "none" && document.getElementById("downPlayAgain").style.display == "none" && document.getElementById("endPlay").style.display == "none" &&　document.getElementById("time_out").style.display == "none" && document.getElementById("ad").style.display == "none" && document.getElementById("message_error").style.display == "none"){
				timePosition = 1;
				clearTimeout(timeoutDisplay);
				timeoutDisplay = setTimeout("hidePlayInfo()",10000);
				document.getElementById("play_info").style.display = "block";
				if(document.getElementById("red").style.display == "block"){
					document.getElementById("time1").style.display = "block";
					document.getElementById("time2").style.display = "none";
					document.getElementById("time3").style.display = "none";
					document.getElementById("time1_span").style.color = "#ffffff";
					document.getElementById("time2_span").style.color = "#000000";
					document.getElementById("time3_span").style.color = "#000000";
					document.getElementById("choose_time").style.display = "block";
					document.getElementById("red").style.display = "none";
					document.getElementById("red_text").style.display = "none";
					clearTimeout(timeoutChooseTime);
					timeoutChooseTime = setTimeout("hideChooseInfo()",20000);
					elapsedCurrent = media.AV.elapsed;
					var minute = Math.floor(elapsedCurrent/60);
					if(minute>99){
						var time1 = minute.toString().substring(0,1);
						var time2 = minute.toString().substring(1,2);
						var time3 = minute.toString().substring(2,3);
					}else if(minute<100&&minute>9){
						var time1 = "0";
						var time2 = minute.toString().substring(0,1);
						var time3 = minute.toString().substring(1,2);
					}else if(minute<10&&minute>=0){
						var time1 = "0";
						var time2 = "0";
						var time3 = minute.toString().substring(0,1);
					}
					document.getElementById("time1_span").innerText = time1;
					document.getElementById("time2_span").innerText = time2;
					document.getElementById("time3_span").innerText = time3;
				}else if(document.getElementById("red").style.display == "none"){
					document.getElementById("choose_time").style.display = "none";
					document.getElementById("red").style.display = "block";
					document.getElementById("red_text").style.display = "block";
				}
			}else{
			}
			return 0;
			break;
		case "EIS_IRKEY_RIGHT"://快进
			if(document.getElementById("exitPlay").style.display == "none" && document.getElementById("proHead").style.display == "none" && document.getElementById("downPlayAgain").style.display == "none" && document.getElementById("endPlay").style.display == "none" && document.getElementById("time_out").style.display == "none" && document.getElementById("ad").style.display == "none" && document.getElementById("message_error").style.display == "none"){
				if(document.getElementById("red").style.display == "block"){
					clearTimeout(timeoutDisplay);
					clearTimeout(timeOut);
					clearInterval(sid);
					count = 10;
					document.getElementById("count").innerHTML = "10";
					var status = media.AV.status;
					if(status=="PAUSE"||status=="BACKWARD"||status=="pause"||status=="backward"||status=="PLAY"||status=="play"){
						media.AV.forward(12);
						hideChooseInfo();
						document.getElementById("play_block_img").src = "${context['EPG_CONTEXT']}/common/images/forward1.gif";
						document.getElementById("play_info").style.display = "block";
					}else if(status=="FORWARD"||status=="forward"){
					}
				}else{
					if(document.getElementById("time1").style.display == "block"){
						document.getElementById("time2").style.display = "block";
						document.getElementById("time1").style.display = "none";
						document.getElementById("time2_span").style.color = "#ffffff";
						document.getElementById("time1_span").style.color = "#000000";
						timePosition = 2;
					}else if(document.getElementById("time2").style.display == "block"){
						document.getElementById("time3").style.display = "block";
						document.getElementById("time2").style.display = "none";
						document.getElementById("time3_span").style.color = "#ffffff";
						document.getElementById("time2_span").style.color = "#000000";
						timePosition = 3;
					}
				}
				return 0;
			}else{
			}
			break;
		case "EIS_IRKEY_LEFT"://快退
			if(document.getElementById("exitPlay").style.display == "none" && document.getElementById("proHead").style.display == "none" && document.getElementById("downPlayAgain").style.display == "none" && document.getElementById("endPlay").style.display == "none" && document.getElementById("time_out").style.display == "none" && document.getElementById("ad").style.display == "none" && document.getElementById("message_error").style.display == "none"){
				if(document.getElementById("red").style.display == "block"){
					clearTimeout(timeoutDisplay);
					clearTimeout(timeOut);
					clearInterval(sid);
					count = 10;
					document.getElementById("count").innerHTML = "10";
					var status = media.AV.status;
					if(status=="PAUSE"||status=="FORWARD"||status=="pause"||status=="forward"||status=="PLAY"||status=="play"){
						media.AV.backward(12);
						hideChooseInfo();
						document.getElementById("play_block_img").src = "${context['EPG_CONTEXT']}/common/images/backward1.gif";
						document.getElementById("play_info").style.display = "block";
					}else if(status=="BACKWARD"||status=="backward"){
					}
				}else{
					if(document.getElementById("time2").style.display == "block"){
						document.getElementById("time1").style.display = "block";
						document.getElementById("time2").style.display = "none";
						document.getElementById("time1_span").style.color = "#ffffff";
						document.getElementById("time2_span").style.color = "#000000";
						timePosition = 1;
					}else if(document.getElementById("time3").style.display == "block"){
						document.getElementById("time2").style.display = "block";
						document.getElementById("time3").style.display = "none";
						document.getElementById("time2_span").style.color = "#ffffff";
						document.getElementById("time3_span").style.color = "#000000";
						timePosition = 2
					}
				}
				return 0;
			}else{
			}
			break;
		case "EIS_IRKEY_UP"://播放到尾
			if(document.getElementById("exitPlay").style.display == "none" && document.getElementById("proHead").style.display == "none" && document.getElementById("downPlayAgain").style.display == "none" && document.getElementById("endPlay").style.display == "none" && document.getElementById("time_out").style.display == "none" && document.getElementById("ad").style.display == "none" && document.getElementById("message_error").style.display == "none"){
				if(document.getElementById("red").style.display == "none"){
					clearTimeout(timeoutDisplay);
					timeoutDisplay = setTimeout("hidePlayInfo()",10000);
					if(document.getElementById("time1").style.display == "block"){
						if(document.getElementById("time1_span").innerText == "9"){
							document.getElementById("time1_span").innerText = "0";
						}else{
							var time_span = document.getElementById("time1_span").innerText;
							var time_int = (parseInt(time_span)+1).toString();
							document.getElementById("time1_span").innerText = time_int;
						}
					}else if(document.getElementById("time2").style.display == "block"){
						if(document.getElementById("time2_span").innerText == "9"){
							document.getElementById("time2_span").innerText = "0";
						}else{
							var time_span = document.getElementById("time2_span").innerText;
							var time_int = (parseInt(time_span)+1).toString();
							document.getElementById("time2_span").innerText = time_int;
						}
					}else if(document.getElementById("time3").style.display == "block"){
						if(document.getElementById("time3_span").innerText == "9"){
							document.getElementById("time3_span").innerText = "0";
						}else{
							var time_span = document.getElementById("time3_span").innerText;
							var time_int = (parseInt(time_span)+1).toString();
							document.getElementById("time3_span").innerText = time_int;
						}
					}
				}else if(document.getElementById("message_error").style.display == "none"){
					clearTimeout(timeoutDisplay);
					media.AV.pause();
					clearTimeout(timeOut);
					markTime = media.AV.elapsed;
					timeOut = setTimeout("show_timeoutExit()",600000);
					document.getElementById("play_info").style.display = "block";
					document.getElementById("play_block_img").src = "${context['EPG_CONTEXT']}/common/images/pause.gif";
			 		document.getElementById("exitPlay").style.display = "block";
		 			document.getElementById("downPlayAgain").style.display = "none";
			 		document.getElementById("proHead").style.display = "none";
			 		document.getElementById("endPlay").style.display = "none";
			 		document.getElementById("time_out").style.display = "none";
				}
				return 0;
			}else{
			}
			break;
		case "EIS_IRKEY_DOWN"://播放到头
			if(document.getElementById("exitPlay").style.display == "none" && document.getElementById("proHead").style.display == "none" && document.getElementById("downPlayAgain").style.display == "none" && document.getElementById("endPlay").style.display == "none" && document.getElementById("time_out").style.display == "none" && document.getElementById("ad").style.display == "none" && document.getElementById("message_error").style.display == "none"){
				if(document.getElementById("red").style.display == "none"){
					clearTimeout(timeoutDisplay);
					timeoutDisplay = setTimeout("hidePlayInfo()",10000);
					if(document.getElementById("time1").style.display == "block"){
						if(document.getElementById("time1_span").innerText == "0"){
							document.getElementById("time1_span").innerText = "9";
						}else{
							var time_span = document.getElementById("time1_span").innerText;
							var time_int = (parseInt(time_span)-1).toString();
							document.getElementById("time1_span").innerText = time_int;
						}
					}else if(document.getElementById("time2").style.display == "block"){
						if(document.getElementById("time2_span").innerText == "0"){
							document.getElementById("time2_span").innerText = "9";
						}else{
							var time_span = document.getElementById("time2_span").innerText;
							var time_int = (parseInt(time_span)-1).toString();
							document.getElementById("time2_span").innerText = time_int;
						}
					}else if(document.getElementById("time3").style.display == "block"){
						if(document.getElementById("time3_span").innerText == "0"){
							document.getElementById("time3_span").innerText = "9";
						}else{
							var time_span = document.getElementById("time3_span").innerText;
							var time_int = (parseInt(time_span)-1).toString();
							document.getElementById("time3_span").innerText = time_int;
						}
					}
				}else if(document.getElementById("message_error").style.display == "none"){
					clearTimeout(timeoutDisplay);
			 		media.AV.pause();
					clearTimeout(timeOut);
					markTime = media.AV.elapsed;
					timeOut = setTimeout("show_timeoutExit()",600000);
			 		document.getElementById("play_info").style.display = "block";
					document.getElementById("play_block_img").src = "${context['EPG_CONTEXT']}/common/images/pause.gif";
		 			document.getElementById("downPlayAgain").style.display = "block";
			 		document.getElementById("proHead").style.display = "none";
			 		document.getElementById("exitPlay").style.display = "none";
			 		document.getElementById("endPlay").style.display = "none";
			 		document.getElementById("time_out").style.display = "none";
				}
				return 0;
			}else{
			}
			break;
		case "EIS_IRKEY_INFO"://顶部信息条
			clearTimeout(timeoutDisplay);
			var status = media.AV.status;
			if(status=="PLAY"||status=="play"){
				if(document.getElementById("play_info").style.display == "none"){
					document.getElementById("play_info").style.display = "block";
					hideChooseInfo();
					clearTimeout(timeoutDisplay);
					timeoutDisplay = setTimeout("hidePlayInfo()",10000);
				}else if(document.getElementById("play_info").style.display == "block"){
					document.getElementById("play_info").style.display = "none";
				}
			}else{
			}
			return 0;
			break;
		case "EIS_IRKEY_MENU"://屏蔽菜单
			break;
		case "EIS_IRKEY_BACK"://屏蔽返回
			returnToBizOrHistory();
			/*if(document.getElementById("message_error").style.display == "none"){
				clearTimeout(timeoutDisplay);
		 		media.AV.pause();
				clearTimeout(timeOut);
				markTime = media.AV.elapsed;
				timeOut = setTimeout("show_timeoutExit()",600000);
		 		document.getElementById("play_info").style.display = "block";
				document.getElementById("play_block_img").src = "${context['EPG_CONTEXT']}/common/images/pause.gif";
		 		document.getElementById("exitPlay").style.display = "block";
		 		document.getElementById("proHead").style.display = "none";
		 		document.getElementById("downPlayAgain").style.display = "none";
		 		document.getElementById("endPlay").style.display = "none";
		 		document.getElementById("time_out").style.display = "none";
			}*/
			return 0;
			break;
		case "EIS_IRKEY_PAGE_UP"://屏蔽翻页
			return 0;
     		break;
		case "EIS_IRKEY_PAGE_DOWN"://屏蔽翻页
			return 0;
     		break;
		case "EIS_IRKEY_PLAY_EXIT"://弹出退出选择框
			if(document.getElementById("message_error").style.display == "none"){
				clearTimeout(timeoutDisplay);
		 		media.AV.pause();
				clearTimeout(timeOut);
				markTime = media.AV.elapsed;
				timeOut = setTimeout("show_timeoutExit()",600000);
		 		document.getElementById("play_info").style.display = "block";
				document.getElementById("play_block_img").src = "${context['EPG_CONTEXT']}/common/images/pause.gif";
		 		document.getElementById("exitPlay").style.display = "block";
		 		document.getElementById("proHead").style.display = "none";
		 		document.getElementById("downPlayAgain").style.display = "none";
		 		document.getElementById("endPlay").style.display = "none";
		 		document.getElementById("time_out").style.display = "none";
			}
			return 0;
			break;
	 	case "EIS_IRKEY_EXIT"://弹出退出选择框
			if(document.getElementById("message_error").style.display == "none"){
				clearTimeout(timeoutDisplay);
		 		media.AV.pause();
				clearTimeout(timeOut);
				markTime = media.AV.elapsed;
				timeOut = setTimeout("show_timeoutExit()",600000);
		 		document.getElementById("play_info").style.display = "block";
				document.getElementById("play_block_img").src = "${context['EPG_CONTEXT']}/common/images/pause.gif";
		 		document.getElementById("exitPlay").style.display = "block";
		 		document.getElementById("proHead").style.display = "none";
		 		document.getElementById("downPlayAgain").style.display = "none";
		 		document.getElementById("endPlay").style.display = "none";
		 		document.getElementById("time_out").style.display = "none";
			}
			return 0;
			break;
	 	case "EIS_IRKEY_MAIN_PAGE"://弹出退出选择框
      		break;
		case "5201"://EIS_VOD_GETDATA_FAILED
			errorInfo(eventObj.code);
			return 0;
			break;
		case "5202"://EIS_VOD_PREPAREPLAY_SUCCESS
			try{
				clearTimeout(timeoutSetUp);
				clearTimeout(timeoutPlay);
				timeoutPlay = setTimeout("show_timeoutPlay()",30000);
				if(time!=null){
					media.AV.seek(time);
				}else{
					media.AV.play();
				}
			}catch(e){
				errorInfo("02-000");
			}
			return 0;
			break;
		case "5203"://EIS_VOD_CONNECT_FAILED
			try{
				switch(eventObj.args.modifiers){
					case 1052://LSCP多次连接失败后向页面发消息
						errorInfo("5203-1052");
						break;
					case 1106://SSP多次尝试失败后向页面发消息
						errorInfo("5203-1106");
						break;
					default:
						errorInfo(eventObj.code);
						break;
				}
			}catch(e){
				errorInfo("01-500");
			}
			return 0;
			break;
		case "5204"://EIS_VOD_DVB_SERACH_FAILED
			errorInfo(eventObj.code);
			return 0;
			break;
		case "5205"://EIS_VOD_PLAY_SUCCESS
			try{
				clearTimeout(timeoutPlay);
				//failedCount = 0;
				media.video.fullScreen();
				window.mainFrame.bodyTransparent();
				bodyTransparent();
				document.getElementById("play_bar_start").style.display = "block";
				document.getElementById("ad").style.display = "none";
				document.getElementById("wait").style.display = "none";
				document.getElementById("message").style.display = "none";
				document.getElementById("message_error").style.display = "none";
				setInterval(showCurrentTime, 1000);
			}catch(e){
				errorInfo("02-200");
			}
			return 0;
			break;
		case "5206"://EIS_VOD_PLAY_FAILED
			try{
				/*failedCount++;
				if(failedCount<=1){
					media.AV.open(url,"VOD");
				}else{*/
					errorInfo(eventObj.code);
				//}
			}catch(e){
				errorInfo("02-500");
			}
			return 0;
			break;
		case "5208"://EIS_VOD_PREPARE_PROGRAMS_FAILED
			errorInfo(eventObj.code);
			return 0;
			break;
		case "5209"://EIS_VOD_PROGRAM_BEGIN
			clearTimeout(timeoutDisplay);
			media.AV.pause();
			clearTimeout(timeOut);
			markTime = media.AV.elapsed;
			timeOut = setTimeout("show_timeoutExit()",600000);
			document.getElementById("play_info").style.display = "block";
			document.getElementById("play_block_img").src = "${context['EPG_CONTEXT']}/common/images/pause.gif";
			document.getElementById("proHead").style.display = "block";
 			document.getElementById("downPlayAgain").style.display = "none";
	 		document.getElementById("exitPlay").style.display = "none";
	 		document.getElementById("endPlay").style.display = "none";
	 		document.getElementById("time_out").style.display = "none";
			return 0;
			break;
		case "5210"://EIS_VOD_PROGRAM_END
			clearTimeout(timeoutDisplay);
			media.AV.pause();
			clearTimeout(timeOut);
			markTime = media.AV.elapsed;
			timeOut = setTimeout("show_timeoutExit()",600000);
			document.getElementById("play_info").style.display = "block";
			switch(eventObj.args.modifiers){
				case 0://正常播放到尾
					document.getElementById("play_block_img").src = "${context['EPG_CONTEXT']}/common/images/pause.gif";
			 		document.getElementById("exitPlay").style.display = "block";
			 		document.getElementById("proHead").style.display = "none";
			 		document.getElementById("downPlayAgain").style.display = "none";
			 		document.getElementById("endPlay").style.display = "none";
			 		document.getElementById("time_out").style.display = "none";
					/*
					document.getElementById("play_block_img").src = "${context['EPG_CONTEXT']}/common/images/pause.gif";
					document.getElementById("endPlay").style.display = "block";
		 			document.getElementById("downPlayAgain").style.display = "none";
			 		document.getElementById("proHead").style.display = "none";
			 		document.getElementById("exitPlay").style.display = "none";
			 		document.getElementById("time_out").style.display = "none";*/
					break;
				case 1://快进到尾
					document.getElementById("play_block_img").src = "${context['EPG_CONTEXT']}/common/images/pause.gif";
			 		document.getElementById("exitPlay").style.display = "block";
			 		document.getElementById("proHead").style.display = "none";
			 		document.getElementById("downPlayAgain").style.display = "none";
			 		document.getElementById("endPlay").style.display = "none";
			 		document.getElementById("time_out").style.display = "none";
					break;
				default:
					document.getElementById("play_block_img").src = "${context['EPG_CONTEXT']}/common/images/pause.gif";
			 		document.getElementById("exitPlay").style.display = "block";
			 		document.getElementById("proHead").style.display = "none";
			 		document.getElementById("downPlayAgain").style.display = "none";
			 		document.getElementById("endPlay").style.display = "none";
			 		document.getElementById("time_out").style.display = "none";
					break;
			}
			return 0;
			break;
		/*case "5211"://EIS_VOD_RELEASE_SUCCESS
			if(failedCount!=0){
			}else{
				errorInfo(eventObj.code);
			}
			return 0;
			break;*/
		case "5212"://EIS_VOD_RELEASE_FAILED
			errorInfo(eventObj.code);
			return 0;
			break;
		case "5213"://EIS_VOD_TSTVREQUEST_FAILED
			errorInfo(eventObj.code,eventObj.args.modifiers);
			return 0;
			break;
		case "5214"://EIS_VOD_EPGURL_REQUEST_FINISHED
			switch(eventObj.args.modifiers){
				case 2://表示获取EPG服务器地址失败
					errorInfo("5214-2");
					break;
			}
			return 0;
			break;
		case "5221"://EIS_VOD_START_FAILED
			errorInfo(eventObj.code,eventObj.args.modifiers);
			return 0;
			break;
		case "5225"://EIS_VOD_USER_EXCEPTION
			if(eventObj.args.modifiers==455||eventObj.args.modifiers==2401||eventObj.args.modifiers==503){
			}else{
				errorInfo(eventObj.code,eventObj.args.modifiers);
			}
			return 0;
			break;
		default:
			return 1;
			break;
	}
}

</script>
<body leftmargin="0" topmargin="0" bgcolor="#000000" >

<div style="position:absolute;top:128px;left:379px;width:131px;height:62px;">
		<epg:img src="/common/images/back.png" href="javascript:returnToBizOrHistory();" width="131" height="62"/>
		</div>
</body>
</epg:html>