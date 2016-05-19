<%@page contentType="text/html; charset=gbk" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<epg:html>
<script>
document.onsystemevent = grabEvent;
document.onkeypress = grabEvent;
document.onirkeypress = grabEvent;
function grabEvent(){
	var keycode = event.which;
	switch(keycode){
		case 339:
		case 340:
			back();
			return 0;
		    break;
	
	}
}
function init(){
	document.getElementById("back").focus();
	//display();
}
function eventHandler(eventObj)
{
	switch(eventObj.code)
	{
	    case "EIS_CA_SMARTCARD_EVULSION":
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
function back(){
	if (typeof(iPanel)!='undefined'){
		if(iPanel.overlayFrame.location!=""){
			iPanel.overlayFrame.close();
			return 0;
		}else{
			history.back();
		}
	}else{
		history.back();
	}
}
</script>
<epg:body onload="init()" background="/common/images/errorBg.jpg" style="background-repeat:no-repeat;" width="1280" height="720">
<div align="center" style="position:absolute;left:630px;top:456px;width:130px;height:22px;">
<font style="font-size:24px;color:#333333">500</font>
</div>
<div style="position:absolute;left:324px;top:498px;width:760px;height:29px;">
<font style="font-size:24px;color:#dfbc75">对不起，您未订购该产品</font>
</div>
<div style="position:absolute;left:582px;top:378px;width:113px;height:48px;">
<epg:img id="back" src="/common/images/dot.gif" width="113" height="48" href="javascript:back();"></epg:img>
</div>
</epg:body>
</epg:html>