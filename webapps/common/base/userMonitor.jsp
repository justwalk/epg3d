<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@page import="chances.epg.web.UserSessionListener" %>

当前用户数量：<%=UserSessionListener.count%>