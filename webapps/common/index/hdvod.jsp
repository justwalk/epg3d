<%@page language="java" import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%
EpgUserSession eus = EpgUserSession.findUserSession(request);
eus.setEntry("hdvod");
String bizCode="biz_01729755";
//String bizCode="biz_07475851";
String contextPath = request.getContextPath();
if ("/".equals(contextPath)){
	contextPath = "";
}

String fixparams = EpgUserSession.createFixUrlParams(request);
String url = new StringBuffer().append(contextPath).append("/biz/").append(bizCode).append(".do?").append(fixparams).toString();
System.out.println("******************[hdvod.jsp]*****url:"+url);
response.sendRedirect(url);
%>