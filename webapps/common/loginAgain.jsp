<%@page contentType="text/html; charset=gbk" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%
	String errorType = request.getParameter("errorType");
	if("login".equals(errorType)){
%>
<epg:html>
<script language="JavaScript">
function submit(){
	media.AV.close();
	iPanel.overlayFrame.close();
	setTimeout("back()",3000);
}
function back(){
	//window.location.href = "/epg/index/hdvod.do";
	iPanel.mainFrame.location = "/epg/index/hdvod.do";
}
</script>
<body bgcolor="#12141b" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="submit();">
<div id="message" style="position:absolute;top:128px;left:379px;width:555px;height:347px;">
<epg:img src="/common/images/bgWait2.png" width="555" height="347"/>
<div align="center" style="position:absolute;top:150px;left:0px;width:555px;height:347px;">
<span id="message_title" style=" font-size:30px;color:#ffffff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;尊敬的用户，由于您较长时&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;间未操作，系统将重新登陆……</span>
</div></div>
</body>
</epg:html>
<%
	}else if("epgError".equals(errorType)){
%>
<epg:html>
<script language="JavaScript">
function submit(){
	//media.AV.close();
	//iPanel.overlayFrame.close();
	setTimeout("back()",2000);
}
function back(){
	iPanel.overlayFrame.close();
}
</script>
<body bgcolor="transparent" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="submit();">
<div id="message" style="position:absolute;top:128px;left:379px;width:555px;height:347px;">
<epg:img src="/common/images/bgWait2.png" width="555" height="347"/>
<div align="center" style="position:absolute;top:150px;left:0px;width:555px;height:347px;">
<span id="message_title" style=" font-size:30px;color:#ffffff">系统忙，请稍后再试</span>
</div></div>
</body>
</epg:html>
<%
	}
%>
