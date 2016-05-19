<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@ page language="java" import="sitv.epg.web.context.*" %>
<%
	request.getSession().removeAttribute("EPG_USER_SESSION");
%>
<epg:html>
<head>
<script language="JavaScript">
function unload(){
	//iPanel.overlayFrame.close();
	iPanel.mainFrame.location = "<%=request.getContextPath()%>/index/hdvod.do";
}
</script>
</head>
<body bgcolor="transparent" onload="unload();" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
</body>
</epg:html>
