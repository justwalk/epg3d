<%@page contentType="text/html; charset=gbk" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@ page language="java" import="java.util.*,sitv.epg.web.context.*,sitv.epg.zhangjiagang.EpgUserSession" %>
<%
String contextPath = request.getContextPath();
if ("/".equals(contextPath)){
	contextPath = "";
}
String focus="";
if (request.getParameter("enterFocusId")!=null){
	focus = "&enterFocusId="+request.getParameter("enterFocusId");
}
String fixparams = EpgUserSession.createFixUrlParams(request)+focus;
String url = new StringBuffer().append(contextPath).append("/index/hdvod.do?").append(fixparams).toString();
EpgUserSession eus = EpgUserSession.findUserSession(request);
eus.setPlayFocusId(null);
response.sendRedirect(url);
%>

