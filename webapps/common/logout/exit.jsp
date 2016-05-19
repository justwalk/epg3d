<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>

<html>
<head>
<script language="JavaScript">
document.onsystemevent = grabEvent;
document.onkeypress = grabEvent;
document.onirkeypress = grabEvent;
function grabEvent(){
	var keycode = event.which;
	switch(keycode){
		case 13:
			//alert("exit");
			window.location.href = "logout.jsp";
			return 0;
			break;
		case 340:
				iPanel.overlayFrame.close();
				return 0;
				break;
		default:
			return 1;
			break;
	}
}
</script>
</head>
<body bgcolor="transparent" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<div style="width:559px;height:349px;"><epg:img src="/common/images/exit.png" width="559" height="349"/></div>
</body>
<html>