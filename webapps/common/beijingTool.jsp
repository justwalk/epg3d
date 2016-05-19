<%@page contentType="text/html; charset=gbk" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@include file="/common/index/indexConfig.jsp" %>
<epg:html>
<style>
	body{ color:#FFFF00;font-size:25}
</style>
<script src="${context['EPG_CONTEXT']}/js/base.js"></script>
<script src="${context['EPG_CONTEXT']}/js/showList.js"></script>
<script src="${context['EPG_CONTEXT']}/js/event.js"></script>
<script src="${context['EPG_CONTEXT']}/js/ajax.js"></script>
<script>
	
	var pageIndex = 1;
	var pageSize = 9;
	var currentFocusId = null;
	var pageCount = 0;
	if (pageIndex == null || pageIndex == ""){
		pageIndex = 1;
	}
	var timer = null;
	var onloaded = false;
	var alertTime = 0;
	var leftToIndex = 0;
	var _menuId  ;
	document.onsystemevent = grabEvent;
	document.onkeypress = grabEvent;
	document.onirkeypress = grabEvent;
	function grabEvent(){
		var keycode = event.which;
		switch(keycode){
			case 3://left
				if(leftToIndex == 1){
					document.location.href = "<%= indexUrl%>";
					return 0;
				}
				break;
			case 13://enter
				break; 
			case 374://pageup
				return 0;
				break;
			case 375://pagedown
				return 0;
				break;
			case 339:
			case 340:
				document.location.href = "<%= indexUrl%>";
				return 0;
			  	break;
		}
	}

	function init(){
		$id("main").style.display = "block";
		//var bjToolMenuIdx = getGlobalVar("bjToolMenuIdx");
		onloaded = true;
		//if (bjToolMenuIdx !=null){
		//	$id("m"+bjToolMenuIdx+"_a").focus();
		//}else{
		 $id("menu1_a").focus();
		_menuId = $id("menu1_title");
		 openSearch();
		//}		
		iPanel.overlayFrame.close();
		
	}	
	function openCollect(){
		_menuId = $id("menu2_title");
		var url = "${context['EPG_CONTEXT']}/common/collect/collect.jsp";
		if (document.frames["iframe1"].location.href.indexOf(url)==-1){
			document.frames["iframe1"].location.href = url;
		}
	}
	function openBookMark(){
		_menuId = $id("menu3_title");
		var url = "${context['EPG_CONTEXT']}/common/mark/bookmark.jsp";
		if (document.frames["iframe1"].location.href.indexOf(url)==-1){
			document.frames["iframe1"].location.href = url;
		}
	}
	function openSearch(){
		_menuId = $id("menu1_title");
		var url = "${context['EPG_CONTEXT']}/common/search/search.jsp";
		if (document.frames["iframe1"].location.href.indexOf(url)==-1){
			document.frames["iframe1"].location.href = url;
		}
	}
	
	/**
	 * 菜单条获得焦点后所作的处理
	 */
	 function menuGetFocus(menuIconDivId){	
	 	if (onloaded == false) return;
	 	lostFocusHandler("menu"); 
	 	//setGlobalVar("bjToolMenuIdx",menuIconDivId);
	 	currentFocusId  = menuIconDivId;
	 	var bar = $id("menuBar");	
	 	var menu = $id("menu"+menuIconDivId+"_div");
	 	
	 	//设置选中的元素的图片为真实图片,而不是透明图
	 	for(var i = 1;i<4;i++){
			var imgMenuDiv = $id("menu"+i+"_div");
			if (imgMenuDiv.id == ("menu"+menuIconDivId+"_div")){				
				$id("menu"+i+"_title").style.color = "#000000";
				/*
				*移动后刷新
				if (i == 1){
					if (timer!=null){
						clearTimeout(timer);
					}
					timer = setTimeout(openCollect,500);
				}else if (i == 2){
					if (timer!=null){
						clearTimeout(timer);
					}
					timer = setTimeout(openBookMark,500);
				}else if (i == 3){
					if (timer!=null){
						clearTimeout(timer);
					}
					timer = setTimeout(openSearch,500);
				}
				*/
			}else{
				$id("menu"+i+"_img").src= blank_img.src;
			}
		}
	 	//if (bar.style.visibility == 'hidden'){
	 		//如果菜单重新获得焦点,则显示菜单条即可
			bar.style.left = menu.style.left;
			bar.style.top = menu.style.top;
			bar.style.visibility = 'visible';
		//	return;
		//}
		//触发菜单条移动动画
		//var topDif = parseInt(getNum(bar.style.top)-getNum(menu.style.top));
		//animation = new showSlip1("menuBar",0,2,10);
		//if (topDif>0){
		//	animation.moveStart(-1,topDif);
		//}else if (topDif<0){
		//	animation.moveStart(1,-topDif);
		//}
	 	leftToIndex = 1 ;
	}
	
	
	
	function menuLostFocus(menuIdx){
		$id("menu"+menuIdx+"_title").style.color = "#fee389";
		_menuId.style.color = "#ffffff";
	}
	
	function focusBack(){
		lostFocusHandler("back");
		$id("btnback_img").src="<%=request.getContextPath()%>/common/images/tools/back1.png";
	}
	function unfocusBack(){
		$id("btnback_img").src="<%=request.getContextPath()%>/common/images/tools/back.png";
	}
	
	function back(){
		document.location.href = "<%= indexUrl%>";
	}
	
	function lostFocusHandler(item){
		leftToIndex = 0;
		 var iframeDoc = document.frames["iframe1"].document;
		if (item == "back"){
			hidden("menuBar");
			if(iframeDoc.getElementById("charBar_div") != null){
				iframeDoc.getElementById("charBar_div").style.visibility = "hidden";
			}
			if(iframeDoc.getElementById("animationBar") != null){
				iframeDoc.getElementById("animationBar").style.visibility = "hidden";
			}
			if(iframeDoc.getElementById("animationBar") != null){
				iframeDoc.getElementById("pl_img").src = iframeDoc.getElementById("pl0_img").src;
				iframeDoc.getElementById("pr_img").src = iframeDoc.getElementById("pr0_img").src;
			}
		}else if(item == "menu"){
			_menuId.style.color = "#fee389";
		 	if(iframeDoc.getElementById("charBar_div") != null){
		 		iframeDoc.getElementById("charBar_div").style.visibility = "hidden";
		 	}
		 	if(iframeDoc.getElementById("animationBar") != null){
		 		iframeDoc.getElementById("animationBar").style.visibility = "hidden";
		 	}
		 	if(iframeDoc.getElementById("animationBar") != null){
		 		iframeDoc.getElementById("pl_img").src = iframeDoc.getElementById("pl0_img").src;
		 		iframeDoc.getElementById("pr_img").src = iframeDoc.getElementById("pr0_img").src;
		 	}
		}
	}
	function hideMainFrame(){
		$id("bodyImg").style.display = "none";
		//$id("main").style.display = "none";
		$id("main").style.left = -1280;
	}
	function blockMainFrame(){
		$id("bodyImg").style.display = "block";
		//$id("main").style.display = "block";
		$id("main").style.left = 0;
		window.mainFrame.focus();
		return 0;
	}
</script>
<epg:body onload="init()" defaultBg="./images/index3.jpg" background="../${templateParams['bgImg']}" style="background-color:#00000;background-repeat:no-repeat;position:absolute; top:0px; left:0px; width:1280px; height:720px " >
<div id="main" style="display: none;width:1280;height:720;position: absolute; left:0;top:0;">
<!-- 隐藏的图片,js切换图片使用 -->
<div style="visibility:hidden;position:absolute; top:0px; left:0px; width:0px; height:0px; z-index:0;">
	<epg:img id="blank" src="./images/dot.gif" />
</div>	

<!--左侧菜单-->	
<div align="center" id="menu_bg" style="position:absolute; top:218px; left:26px; width:243px; height:462px;" >
	<div align="center" id="menuBar" style="position:absolute;visibility:hidden; top:0px; left:0px; width:212px; height:63px;" >
		<epg:img src="./images/select.png"  width="212" height="63" />							
	</div>
	<div align="center" id="menu1_div" style="position:absolute;top:0px; left:0px; width:213px; height:64px;" >
		<epg:img id="menu1" src="./images/dot.gif" href="#" width="213" height="64" onfocus="menuGetFocus('1')" onclick="openSearch()" onblur="menuLostFocus('1')"/>
	</div>	
	<div align="center" id="menu1_title" style="position:absolute;top:15px; left:20px; width:213px; height:64px;font-size:35;color:#fee389;font-family:黑体" >
		搜索
	</div>
	<div align="center" id="menu2_div" style="position:absolute;top:75px; left:0px; width:213px; height:64px;" >
		<epg:img id="menu2" src="./images/dot.gif" href="#" width="213" height="64" onfocus="menuGetFocus('2')" onclick="openCollect()" onblur="menuLostFocus('2')"/>
	</div>
	<div align="center" id="menu2_title" style="position:absolute; top:90px; left:20px; width:213px; height:64px;font-size:35;color:#fee389;font-family:黑体" >
		收藏
	</div>
	<div align="center" id="menu3_div" style="position:absolute;top:150px; left:0px; width:213px; height:64px;" >
		<epg:img id="menu3" src="./images/dot.gif" href="#" width="213" height="64" onfocus="menuGetFocus('3')" onclick="openBookMark()" onblur="menuLostFocus('3')"/>
	</div>
	<div align="center" id="menu3_title" style="position:absolute;top:165px; left:20px; width:213px; height:64px;font-size:35;color:#fee389;font-family:黑体" >
		书签
	</div>
</div>

<div id="btnback" style="position:absolute; top:25px; left:1100px; width: 114px;height:50px;z-index:10;">
	<epg:img id="btnback" onclick="back()" onfocus="focusBack();" onblur="unfocusBack();" href="#"  src="/common/images/tools/back.png" height="62" width="131" />
</div>

<!-- 我的收藏列表 -->
<div align="center" id="l2" style="position:absolute; top:20px; left:300px; width:830px; height:655px;z-index:5;" >
	<iframe id="iframe1" src="" width="880" height="680" scrolling="no" frameborder="0">
</div>
</div>
</epg:body>
</epg:html>