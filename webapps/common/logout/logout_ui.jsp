<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%
	request.getSession().removeAttribute("EPG_USER_SESSION");
%>
<html>
<head>
<script language="JavaScript">
function unload(){
	window.location.href = "file:///roroot/resdata/web/index.html";
}
</script>
</head>
<body bgcolor="transparent" onload="unload();" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
</body>
<html>