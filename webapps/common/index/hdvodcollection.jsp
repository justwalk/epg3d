<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@ page language="java" import="java.util.*,sitv.epg.zhangjiagang.*,chances.epg.utils.*" %>
<%
EpgUserSession eus = EpgUserSession.findUserSession(request);
eus.setEntry("hdvod");
String bizCode="biz_30227245";
//String bizCode="biz_17249444";
//String bizCode="biz_86996967";
String contextPath = request.getContextPath();
if ("/".equals(contextPath)){
	contextPath = "";
}
String fixparams = EpgUserSession.createFixUrlParams(request);

String url = new StringBuffer().append(contextPath).append("/biz/").append(bizCode).append(".do?").append(fixparams).toString();
response.sendRedirect(url);
%>

