<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="org.springframework.web.context.*"%>
<%@ page import="java.util.*"%>

<%
ConfigurableWebApplicationContext appContext = (ConfigurableWebApplicationContext) pageContext.findAttribute("org.springframework.web.servlet.FrameworkServlet.CONTEXT.epg");
appContext.refresh();

%>
<%=appContext%>
