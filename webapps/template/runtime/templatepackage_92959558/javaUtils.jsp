<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="sitv.epg.config.EpgConfigUtils"%>
<%
	String templateRoot = EpgConfigUtils.getInstance().getProperty("navigator.template.root.path");
	request.setAttribute("templateRoot",templateRoot);
%>
<epg:set var="imgPath" 
		 value="${context['EPG_CONTEXT']}/${templateRoot}/${CONTEXT_OBJ['currentTemplatePackageCode']}/images/"/>
<epg:set value="./images/dot.gif" var="dot"/>