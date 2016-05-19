<%@page contentType="text/html; charset=gbk" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>
<%@include file="/common/index/indexConfig.jsp" %>
<epg:html>
<style>
	body{ color:#bbbbbb;font-size:25}
</style>

<script src="<%=request.getContextPath()%>/js/base.js"></script>
<script src="<%=request.getContextPath()%>/js/showList.js"></script>
<script src="<%=request.getContextPath()%>/js/event.js"></script>
<script src="<%=request.getContextPath()%>/js/ajax.js"></script>
<script>
	
	//动画变量
	var pageIndex = 1 ;
	var pageSize = 9;
	var total = 0;
	var pageTotal = 0 ;
	var currentFocusId = null;
	var pageCount = 0;
	var showObject;
	var collectList = null;
	var ajaxReq = null;
	
	document.onsystemevent = grabEvent;
	document.onkeypress = grabEvent;
	document.onirkeypress = grabEvent;
	function grabEvent(){
		var keycode = event.which;
		switch(keycode){
			case 1://up
				if (!canMove()) return 0; //如果有动画正在运行,则截断事件链
				break; 
			case 2://down
				if (!canMove()) return 0; //如果有动画正在运行,则截断事件链
				break; 
			case 3://left
				if (!canMove()) return 0; //如果有动画正在运行,则截断事件链
				break; 
			case 4://right
				if (!canMove()) return 0; //如果有动画正在运行,则截断事件链
				break; 
			case 13://enter
				break; 
			case 374://pageup
				$id("pl_a").focus();
				up();
				return 0;
				break; 
			case 375://pagedown
				$id("pr_a").focus();
				down();
				return 0;
				break;
			case 339:
			case 340:
				window.parent.location = "<%= indexUrl%>";
				return 0;
			  break;
		}
	}
	
	
	function up(){
		if (pageCount == 0) {
			return;
		}else if (pageIndex == 1 ){
			pageIndex = pageCount+1;
		} 
		if (pageIndex>1 && pageCount>1){
			pageIndex--;
			var myCollectUrl = "<%=request.getContextPath()%>/getBookmark.do?p="+(pageIndex-1)+"&s="+pageSize+"&r="+Math.random();
			//resetRequest();
			ajaxReq = new AJAX_OBJ(myCollectUrl,afterGetCollect);
			ajaxReq.requestData();
		}
		//setGlobalVar("collect_page_index",pageIndex);
		//setGlobalVar("collect_delete_index",0);
	}
	
	function down(){
		if (pageCount == 0){ 
				return;
		}else if(pageIndex == pageCount){
			pageIndex = 0;
		}
		if (pageIndex<pageCount && pageCount>1){
			var myCollectUrl = "<%=request.getContextPath()%>/getBookmark.do?p="+(pageIndex)+"&s="+pageSize+"&r="+Math.random();
			//resetRequest();
			ajaxReq = new AJAX_OBJ(myCollectUrl,afterGetCollect);
			ajaxReq.requestData();
			pageIndex++;
			//setGlobalVar("collect_page_index",pageIndex);
		}
	}
	
	function afterGetTotalCollect(xmlHttpResponse){
		total = xmlHttpResponse.responseText;
		var result = total%pageSize;
		pageCount = total/pageSize;
		if (total == 0){
			pageCount = 0;
			for(var i = 1;i<=9;i++){
				hidden("c"+i+"_div");
			}
		}
		if (result > 0 && total>0){
			pageCount = Math.floor(total/pageSize+1);
		}
		if (pageIndex>pageCount){
			pageIndex = pageIndex-1;
			setGlobalVar("collect_page_index",pageIndex);
		}		
		
		if (total>0){
			var myCollectUrl = "<%=request.getContextPath()%>/getBookmark.do?p="+(pageIndex-1)+"&s="+pageSize+"&r="+Math.random();
			//resetRequest();
			ajaxReq = new AJAX_OBJ(myCollectUrl,afterGetCollect);
			//window.location.href = myCollectUrl;
			ajaxReq.requestData();
		}		
	}
	
	function afterGetCollect(xmlHttpResponse){
		//alert(xmlHttpResponse.responseText);
		var playImg = p1_img.src;	
		var deleteImg = d1_img.src;	
		collectList = eval(xmlHttpResponse.responseText);
		var collect = null;
		pageTotal = collectList.length;
		for(var i=0;i<9;i++){
			collect = collectList[i];
			if (collect ==null){
				$id('content'+(i+1)+'_div').innerText = "";
				$id('mark'+(i+1)+'_div').innerText = "";
				hidden('play'+(i+1)+'_div');
				hidden('delete'+(i+1)+'_div');
				$id('play'+(i+1)+'_a').href = "#";
				$id('delete'+(i+1)+'_a').href = "#";
			}else{	
				var hour = parseInt(collect.contentElapsed/3600);
				var minute = parseInt((collect.contentElapsed - hour*3600)/60);
				var second = collect.contentElapsed - (minute*60)-(hour*3600);
				if(hour<10)hour="0"+hour;
				if(minute<10)minute="0"+minute;
				if(second<10)second="0"+second;
				$id('content'+(i+1)+'_div').innerHTML = showObject.showPartChar(collect.contentName);
				$id('mark'+(i+1)+'_div').innerText = hour+":"+minute+":"+second;
				
				//$id('play'+(i+1)+'_a').href = "javascript:openContent('"+collect.contentType+"','"+collect.indexUrl+"')";
				//$id('delete'+(i+1)+'_a').href = "javascript:deleteCollect('"+collect.deleteUrl+"&pageIndex="+(pageIndex-1)+"',"+(i+1)+")";

				appear('play'+(i+1)+'_div');
				appear('delete'+(i+1)+'_div');
				$id('delete'+(i+1)+'_img').src = deleteImg ;	
				$id('play'+(i+1)+'_img').src = playImg;
			}
		}
		$id("pageCount").innerText = pageIndex+"/"+pageCount; 
	}
	function openOverLayFramePlayEx(left,top,width,height,pos){
		var cardId = CA.card.serialNumber;
		var url = collectList[pos].indexUrl+"&account="+cardId;
		if (typeof(iPanel)!='undefined'){
			var overlayFram = iPanel.overlayFrame ;
			overlayFram.location = url;
			overlayFram.moveTo(left,top);
			overlayFram.resizeTo(width,height);
			overlayFram.focus;
		}else{
			window.open(url,'overlayWindow','height='+height+', width='+width+', top='+top+', left='+left+', toolbar=no, menubar=no, scrollbars=no,resizable=no,location=no, status=no');
		}
	}
	
	function deleteCollect(pos){
		//resetRequest();
		//setGlobalVar("collect_delete_index",idx);
		/*
		if (currentFocusId == "delete"+idx+"_img" && idx == pageTotal){
			if (pageCount > 1 && idx == 9 && pageIndex ==1){
				ajaxReq = new AJAX_OBJ(deleteUrl,startReqData());
			}else{
				ajaxReq = new AJAX_OBJ(deleteUrl,reload());
			}
		}else{
			ajaxReq = new AJAX_OBJ(deleteUrl,startReqData());
		}
		*/
		var url = collectList[pos].deleteUrl
		ajaxReq = new AJAX_OBJ(url,reload());
		ajaxReq.requestData();
	}
	
	function reload(){
		location.reload();
	}
	
	function init(){
		//document.getElementById('m1_a').focus();
		$id("main").style.display = "block";
		startReqData();
		showObject=new showContent(30,3,500);
	}	
	
	function startReqData(){
		var myCollectTotalUrl = "<%=request.getContextPath()%>/getBookmarkTotal.do?r="+Math.random();
		//resetRequest();
		ajaxReq = new AJAX_OBJ(myCollectTotalUrl,afterGetTotalCollect);
		ajaxReq.requestData();
	}
	
	function resetRequest(){
		if (ajaxReq!=null){
			ajaxReq.cancel();
		}
	}
	
	function focusPlay(idx){
		lostFocusHandler("play");
		currentFocusId  = "play"+idx+"_img";
		//hidden("menuBar");
		$id('play'+idx+'_img').src=$id("play_img").src;
		//if ($id("animationBar").style.visibility == 'hidden'){
	 		//如果菜单重新获得焦点,则显示菜单条即可
			$id("animationBar").style.top = $id("c"+idx+"_div").style.top;
			$id("animationBar").style.left = $id("c"+idx+"_div").style.left;
			appear("animationBar");
		//	return;
		//}else{
			//触发菜单条移动动画
		//	animation = new showSlip1("animationBar",0,2,10);
		//	animation.moveToSameLocation("c"+idx+"_div",0,0);
		//}
	}
	
	function destory(){
		setGlobalVar("collect_page_index",1);
	}
	
	function focusDelete(idx){
		lostFocusHandler("play");
		currentFocusId  = "delete"+idx+"_img";
		//hidden("menuBar");
		$id('delete'+idx+'_img').src = delete_img.src;
		//if ($id("animationBar").style.visibility == 'hidden'){
	 		//如果菜单重新获得焦点,则显示菜单条即可
			$id("animationBar").style.top = $id("c"+idx+"_div").style.top;
			$id("animationBar").style.left = $id("c"+idx+"_div").style.left;
			appear("animationBar");
		//	return;
		//}else{
			//触发菜单条移动动画
		//	animation = new showSlip1("animationBar",0,2,10);
		//	animation.moveToSameLocation("c"+idx+"_div",0,0);
		//}
	}
	function unfocusPlay(idx){
		$id('play'+idx+'_img').src = p1_img.src;
	}
	function unfocusDelete(idx){
		$id('delete'+idx+'_img').src = d1_img.src;
	}
	function pageOnfocus(pageCur){
		$id("pl_img").src = $id("pl0_img").src;
		$id("pr_img").src = $id("pr0_img").src;
		$id(pageCur+"_img").src = $id(pageCur+"1_img").src;
		lostFocusHandler("page");
		curFocus = $id(pageCur+"_div");
	}
	function lostFocusHandler(item){
		if(item == "page"){
			hidden("animationBar");
			parent.document.getElementById("btnback_img").src = $id("back0_img").src;
			parent.menuBar.style.visibility = "hidden";
		}else if(item == "play"){
			parent.document.getElementById("btnback_img").src = $id("back0_img").src;
			$id("pl_img").src = $id("pl0_img").src;
			$id("pr_img").src = $id("pr0_img").src;
			parent.menuBar.style.visibility = "hidden";
		}
	}
	function openContent(type, url){
			openOverLayFrame(url,0,0,1280,720);
	}
</script>
<body onload="init()"  bgcolor="transparent" style="position:absolute; top:0px;width:830px;height:655px; left:0px;" >
<div id="main" style="display: none;width:830;height:655;position: absolute; left:0;top:0;">
<!-- 隐藏的图片,js切换图片使用 -->
<div style="visibility:hidden;position:absolute; top:1px; left:1px; width:1px; height:1px; z-index:0;">
	<epg:img id="blank" src="/common/images/tools/dot.gif" />
	<epg:img id="play" src="/common/images/tools/play1.png" width="1" height="1"/>
	<epg:img id="delete" src="/common/images/tools/delete1.png" width="1" height="1"/>
	<epg:img id="p1" src="/common/images/tools/play.png" width="1" height="1"/>
	<epg:img id="d1" src="/common/images/tools/delete.png" width="1" height="1"/>
	<epg:img id="back0" src="/common/images/tools/back.png" width="1" height="1"/>
	<epg:img id="back1" src="/common/images/tools/back1.png" width="1" height="1"/>
	<epg:img id="pl0" src="/common/images/tools/pg_u.png" width="1" height="1"/>
	<epg:img id="pl1" src="/common/images/tools/pg_u1.png" width="1" height="1"/>
	<epg:img id="pr0" src="/common/images/tools/pg_d.png" width="1" height="1"/>
	<epg:img id="pr1" src="/common/images/tools/pg_d1.png" width="1" height="1"/>
</div>	



<!-- 我的收藏列表 -->
<div align="center" id="l1" style="position:absolute; top:40px; left:0px; width:830px; height:600px;" >
	
<div align="center" id="pageCount" style="position:absolute; top:-14px; left:500px; width:50px; height:33px;" >
	0/0						
</div>
<div id="pl_div" style="position:absolute;left:580; top:-35; width:131; height:62;" ><epg:img id="pl" src="/common/images/tools/pg_u.png" width="131" height="62"  href="#" onclick="up()" onfocus="pageOnfocus('pl')" /></div>
<div id="pr_div" style="position:absolute;left:690; top:-35; width:131; height:62;" ><epg:img id="pr" src="/common/images/tools/pg_d.png" width="131" height="62"  href="#" onclick="down()" onfocus="pageOnfocus('pr')" /></div>
		
	<div align="center" id="animationBar" style="position:absolute;visibility:hidden; top:40px; left:20px; width:212px; height:36px;" >
		<div align="center" id="contentBar" style="position:absolute; top:45px; left:0px; width:212px; height:33px;" >
			<epg:img id="contentSelect" src="/common/images/tools/contentBar.png"  width="815" height="20" />							
		</div>
	</div>
		<div align="left" valign="top" id="note" style="position:absolute;top:568px; left:520px; width:340px; height:10px;" >
			<epg:img src="/common/images/tools/play.png"  width="66" height="66" />&nbsp;&nbsp;&nbsp;<epg:img src="/common/images/tools/delete.png"  width="66" height="66" />
		</div>
	<div align="left" valign="top" id="note" style="position:absolute;top:586px; left:500px; width:300px; height:36px;color:gray" >
		按&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;播放 &nbsp;&nbsp;&nbsp;&nbsp;删除
	</div>
	
	<!-- content 1 -->
	<div align="center" id="c1_div" style="position:absolute;top:30px; left:21px; width:820px; height:60px;" >
		<div align="center" id="play1_div" style="position:absolute;top:0px; left:0px; width:66px; height:66px;" >
			<epg:img id="play1" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="openOverLayFramePlayEx(0,0,1280,720,0)" onfocus="focusPlay(1)" onblur="unfocusPlay(1)"/>
		</div>
		<div align="center" id="delete1_div" style="position:absolute;top:0px; left:70px; width:66px; height:66px;" >
			<epg:img id="delete1" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="deleteCollect(0)" onfocus="focusDelete(1)" onblur="unfocusDelete(1)"/>
		</div>
		<div align="left" id="content1_div" style="position:absolute;top:18px; left:160px; width:520px; height:66px;" >
		</div>
		<div align="left" id="mark1_div" style="position:absolute;top:18px; left:670px; width:140px; height:66px;" >
		</div>
		<div align="center" id="contentBar1" style="position:absolute; top:50px; left:20px; width:815px; height:20px;" >
			<epg:img src="/common/images/tools/contentBar1.png"  width="815" height="20" />							
		</div>
		
	</div>	
	
	<!-- content 2 -->
	<div align="center" id="c2_div" style="position:absolute;top:90px; left:21px; width:820px; height:60px;" >
		<div align="center" id="play2_div" style="position:absolute;top:0px; left:0px; width:66px; height:66px;" >
			<epg:img id="play2" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="openOverLayFramePlayEx(0,0,1280,720,1)" onfocus="focusPlay(2)" onblur="unfocusPlay(2)"/>
		</div>
		<div align="center" id="delete2_div" style="position:absolute;top:0px; left:70px; width:66px; height:66px;" >
			<epg:img id="delete2" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="deleteCollect(1)" onfocus="focusDelete(2)" onblur="unfocusDelete(2)"/>
		</div>
		<div align="left" id="content2_div" style="position:absolute;top:18px; left:160px; width:520px; height:66px;" >
		</div>
		<div align="left" id="mark2_div" style="position:absolute;top:18px; left:670px; width:140px; height:66px;" >
		</div>
		<div align="center" id="contentBar2" style="position:absolute; top:50px; left:20px; width:815px; height:20px;" >
			<epg:img src="/common/images/tools/contentBar1.png"  width="815" height="20" />							
		</div>
	</div>	
	
	<!-- content 3 -->
	<div align="center" id="c3_div" style="position:absolute;top:150px; left:21px; width:820px; height:70px;" >
		<div align="center" id="play3_div" style="position:absolute;top:0px; left:0px; width:66px; height:66px;" >
			<epg:img id="play3" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="openOverLayFramePlayEx(0,0,1280,720,2)" onfocus="focusPlay(3)" onblur="unfocusPlay(3)"/>
		</div>
		<div align="center" id="delete3_div" style="position:absolute;top:0px; left:70px; width:66px; height:66px;" >
			<epg:img id="delete3" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="deleteCollect(2)" onfocus="focusDelete(3)" onblur="unfocusDelete(3)"/>
		</div>
		<div align="left" id="content3_div" style="position:absolute;top:18px; left:160px; width:520px; height:66px;" >
		</div>
		<div align="left" id="mark3_div" style="position:absolute;top:18px; left:670px; width:140px; height:66px;" >
		</div>
		<div align="center" id="contentBar3" style="position:absolute; top:50px; left:20px; width:815px; height:20px;" >
			<epg:img src="/common/images/tools/contentBar1.png"  width="815" height="20" />							
		</div>
	</div>	
	<!-- content 4 -->
	<div align="center" id="c4_div" style="position:absolute;top:210px; left:21px; width:820px; height:70px;" >
		<div align="center" id="play4_div" style="position:absolute;top:0px; left:0px; width:66px; height:66px;" >
			<epg:img id="play4" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="openOverLayFramePlayEx(0,0,1280,720,3)" onfocus="focusPlay(4)" onblur="unfocusPlay(4)"/>
		</div>
		<div align="center" id="delete4_div" style="position:absolute;top:0px; left:70px; width:66px; height:66px;" >
			<epg:img id="delete4" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="deleteCollect(3)" onfocus="focusDelete(4)" onblur="unfocusDelete(4)"/>
		</div>
		<div align="left" id="content4_div" style="position:absolute;top:18px; left:160px; width:520px; height:66px;" >
		</div>
		<div align="left" id="mark4_div" style="position:absolute;top:18px; left:670px; width:140px; height:66px;" >
		</div>
		<div align="center" id="contentBar4" style="position:absolute; top:50px; left:20px; width:815px; height:20px;" >
			<epg:img src="/common/images/tools/contentBar1.png"  width="815" height="20" />							
		</div>
	</div>	
	<!-- content 5 -->
	<div align="center" id="c5_div" style="position:absolute;top:270px; left:21px; width:820px; height:70px;" >
		<div align="center" id="play5_div" style="position:absolute;top:0px; left:0px; width:66px; height:66px;" >
			<epg:img id="play5" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="openOverLayFramePlayEx(0,0,1280,720,4)" onfocus="focusPlay(5)" onblur="unfocusPlay(5)"/>
		</div>
		<div align="center" id="delete5_div" style="position:absolute;top:0px; left:70px; width:66px; height:66px;" >
			<epg:img id="delete5" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="deleteCollect(4)" onfocus="focusDelete(5)" onblur="unfocusDelete(5)"/>
		</div>
		<div align="left" id="content5_div" style="position:absolute;top:18px; left:160px; width:520px; height:66px;" >
		</div>
		<div align="left" id="mark5_div" style="position:absolute;top:18px; left:670px; width:140px; height:66px;" >
		</div>
		<div align="center" id="contentBar5" style="position:absolute; top:50px; left:20px; width:815px; height:20px;" >
			<epg:img src="/common/images/tools/contentBar1.png"  width="815" height="20" />							
		</div>
	</div>	
	<!-- content 6 -->
	<div align="center" id="c6_div" style="position:absolute;top:330px; left:21px; width:820px; height:70px;" >
		<div align="center" id="play6_div" style="position:absolute;top:0px; left:0px; width:66px; height:66px;" >
			<epg:img id="play6" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="openOverLayFramePlayEx(0,0,1280,720,5)" onfocus="focusPlay(6)" onblur="unfocusPlay(6)"/>
		</div>
		<div align="center" id="delete6_div" style="position:absolute;top:0px; left:70px; width:66px; height:66px;" >
			<epg:img id="delete6" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="deleteCollect(5)" onfocus="focusDelete(6)" onblur="unfocusDelete(6)"/>
		</div>
		<div align="left" id="content6_div" style="position:absolute;top:18px; left:160px; width:520px; height:66px;" >
		</div>
		<div align="left" id="mark6_div" style="position:absolute;top:18px; left:670px; width:140px; height:66px;" >
		</div>
		<div align="center" id="contentBar6" style="position:absolute; top:50px; left:20px; width:815px; height:20px;" >
			<epg:img src="/common/images/tools/contentBar1.png"  width="815" height="20" />							
		</div>
	</div>	
	<!-- content 7 -->
	<div align="center" id="c7_div" style="position:absolute;top:390px; left:21px; width:820px; height:70px;" >
		<div align="center" id="play7_div" style="position:absolute;top:0px; left:0px; width:66px; height:66px;" >
			<epg:img id="play7" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="openOverLayFramePlayEx(0,0,1280,720,6)" onfocus="focusPlay(7)" onblur="unfocusPlay(7)"/>
		</div>
		<div align="center" id="delete7_div" style="position:absolute;top:0px; left:70px; width:66px; height:66px;" >
			<epg:img id="delete7" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="deleteCollect(6)" onfocus="focusDelete(7)" onblur="unfocusDelete(7)"/>
		</div>
		<div align="left" id="content7_div" style="position:absolute;top:18px; left:160px; width:520px; height:66px;" >
		</div>
		<div align="left" id="mark7_div" style="position:absolute;top:18px; left:670px; width:140px; height:66px;" >
		</div>
		<div align="center" id="contentBar7" style="position:absolute; top:50px; left:20px; width:815px; height:20px;" >
			<epg:img src="/common/images/tools/contentBar1.png"  width="815" height="20" />							
		</div>
	</div>	
	<!-- content 8 -->
	<div align="center" id="c8_div" style="position:absolute;top:450px; left:21px; width:820px; height:70px;" >
		<div align="center" id="play8_div" style="position:absolute;top:0px; left:0px; width:66px; height:66px;" >
			<epg:img id="play8" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="openOverLayFramePlayEx(0,0,1280,720,7)" onfocus="focusPlay(8)" onblur="unfocusPlay(8)"/>
		</div>
		<div align="center" id="delete8_div" style="position:absolute;top:0px; left:70px; width:66px; height:66px;" >
			<epg:img id="delete8" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="deleteCollect(7)" onfocus="focusDelete(8)" onblur="unfocusDelete(8)"/>
		</div>
		<div align="left" id="content8_div" style="position:absolute;top:18px; left:160px; width:520px; height:66px;" >
		</div>
		<div align="left" id="mark8_div" style="position:absolute;top:18px; left:670px; width:140px; height:66px;" >
		</div>
		<div align="center" id="contentBar8" style="position:absolute; top:50px; left:20px; width:815px; height:20px;" >
			<epg:img src="/common/images/tools/contentBar1.png"  width="815" height="20" />							
		</div>
	</div>	
	<!-- content 9 -->
	<div align="center" id="c9_div" style="position:absolute;top:510px; left:21px; width:820px; height:70px;" >
		<div align="center" id="play9_div" style="position:absolute;top:0px; left:0px; width:66px; height:66px;" >
			<epg:img id="play9" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="openOverLayFramePlayEx(0,0,1280,720,8)" onfocus="focusPlay(9)" onblur="unfocusPlay(9)"/>
		</div>
		<div align="center" id="delete9_div" style="position:absolute;top:0px; left:70px; width:66px; height:66px;" >
			<epg:img id="delete9" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="deleteCollect(8)" onfocus="focusDelete(9)" onblur="unfocusDelete(9)"/>
		</div>
		<div align="left" id="content9_div" style="position:absolute;top:18px; left:160px; width:520px; height:66px;" >
		</div>
		<div align="left" id="mark9_div" style="position:absolute;top:18px; left:670px; width:140px; height:66px;" >
		</div>
		<div align="center" id="contentBar9" style="position:absolute; top:50px; left:20px; width:815px; height:20px;" >
			<epg:img src="/common/images/tools/contentBar1.png"  width="815" height="20" />							
		</div>
	</div>	
</div>
</div>
</body>
</epg:html>