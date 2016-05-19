<%@page contentType="text/html; charset=gb2312" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@ page language="java" import="sitv.epg.zhangjiagang.service.*,java.util.*" %>
<%@ page import="sitv.epg.business.*" %>
<%@ page import="org.springframework.context.ApplicationContext" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page language="java" import="org.springframework.web.context.WebApplicationContext,org.springframework.web.servlet.support.RequestContextUtils" %>
<%
	String account = request.getParameter("getAccount");
	if(account==null||account==""){
%>
<epg:html>
<meta name="login" content="login">
<head>
<script src="<%=request.getContextPath()%>/js/event.js"></script>
<script language="JavaScript">
function submit(){
	var account = 175254844;
	if(account.length<=0){
		document.getElementById("message").style.display = "block";
	}else{
		document.getElementById("getAccount").value = account;
		document.getElementById("login").submit();
	}
}
</script>
</head>
<body bgcolor="#12141b" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="submit();">
<div id="message" style="position:absolute;top:128px;left:379px;width:555px;height:347px;display:none"><epg:img src="/common/images/bgWait.png" width="555" height="347"/></div>
<form id="login" method="post" action="<%=request.getContextPath()%>/login/login.do">
<input id="getAccount" name="getAccount" type="hidden" value=""></input>
<input id="getMacAddress" name="getMacAddress" type="hidden" value=""></input>
</form>
</body>
</epg:html>
<%
    }else{
		WebApplicationContext applicationContext = RequestContextUtils.getWebApplicationContext(request);
		//LoginService loginService = (LoginService)applicationContext.getBean("loginService");
		MockLoginService loginService = (MockLoginService)applicationContext.getBean("mockLoginService");
		
		String pwd = "";
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("vmType","jydv");
		paramMap.put("stbType","hd");
		paramMap.put("entry","hdvod");
		boolean loginFlag = loginService.login(request,account,"0",pwd,0,paramMap);
		//boolean loginFlag = loginService.login(request,"1","111111",account,"0",paramMap);
		String contextPath = request.getContextPath();
		if(loginFlag){
			String url = request.getParameter("backurl");
			if(url==null||url==""){
%>
<epg:html>
<meta name="login" content="login">
<head>
<script language="JavaScript">
function submit(){
	window.location.href = "<%=request.getContextPath()%>/index/hdvod.do";
}
</script>
</head>
<body bgcolor="#12141b" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="submit();">
</body>
</epg:html>
<%
			}else{
%>
<epg:html>
<meta name="login" content="login">
<head>
<script language="JavaScript">
function submit(){
	window.location.href = "<%=url%>";
}
</script>
</head>
<body bgcolor="#12141b" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="submit();">
</body>
</epg:html>
<%
			}
		}else{
%>
<epg:html>
<meta name="login" content="login">
<head>
<script src="<%=request.getContextPath()%>/js/event.js"></script>
<script language="JavaScript">
function back(){
	window.location.href = "ui://index.htm";
}
function submit(){
	document.getElementById("logMes").style.display = "none";
	document.getElementById("message").style.display = "block";
	setTimeout("back()",3000);
}
</script>
</head>
<body bgcolor="#12141b" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="submit();">
<div id="logMes" style="position:absolute;left:379px;top:127px;width:559px;height:349px;display:block"><epg:img src="/common/images/login.png" width="559" height="349"/></div>
<div id="message" style="position:absolute;top:128px;left:379px;width:555px;height:347px;display:none"><epg:img src="/common/images/bgWait.png" width="555" height="347"/></div>
</body>
</epg:html>
<%
		}
	}
%>
