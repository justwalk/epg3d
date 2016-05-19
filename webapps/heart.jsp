<%@page contentType="text/html; charset=GBK" pageEncoding="UTF-8"%>
<html>
<script>
	function send(){
		var cardId = CA.card.serialNumber;
		var url = "http://172.16.255.42:8080/epg/login/login.do?getAccount=175254844";
		document.location.href = url;
	}
</script>
<body>
<div style="position:absolute;left:487px;top:364px;width:408px;height:29px;">
<font style="font-size:24px;color:#000000"><a id="test" href ="#" onclick="send();">服务正在运行……</a></font>
</div>
</body>
</html>