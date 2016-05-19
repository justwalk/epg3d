<%@page contentType="text/html; charset=gbk" pageEncoding="utf-8"%>
<%@taglib uri="http://chances.com.cn/jsp/epg" prefix="epg"%>

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

	var pageIndex = 1;
	var pageSize = 7;
	var currentFocusId = null;
	var pageCount = 0;
	if (pageIndex == null || pageIndex == ""){
		pageIndex = 1;
	}
	var requester = null;
	var showObject;
	var firstTime = true;
	var collectList = null;
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
				history.back();
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
				var myCollectUrl = "<%=request.getContextPath()%>/result/getEpgProgram.do?initals=${param.initals}&p="+(pageIndex-1)+"&s="+pageSize+"&r="+Math.random();
				var requestCollect = new AJAX_OBJ(myCollectUrl,afterGetCollect);
				requestCollect.requestData();
				
			}
	}
	
	function down(){		
			if (pageCount == 0){ 
				return;
			}else if(pageIndex == pageCount){
				pageIndex = 0;
			}
			if (pageIndex<pageCount && pageCount>1){
				var myCollectUrl = "<%=request.getContextPath()%>/result/getEpgProgram.do?initals=${param.initals}&p="+(pageIndex)+"&s="+pageSize+"&r="+Math.random();
				var requestCollect = new AJAX_OBJ(myCollectUrl,afterGetCollect);
				requestCollect.requestData();
				pageIndex++;
			}
	}
	
	function afterGetTotalCollect(xmlHttpResponse){
		var total = (xmlHttpResponse.responseText)/1;
		$id("total1_div").innerText = "找到"+total+"个节目";	
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
		if (total>0){
			var myCollectUrl = "<%=request.getContextPath()%>/result/getEpgProgram.do?initals=${param.initals}&p="+(pageIndex-1)+"&s="+pageSize+"&r="+Math.random();
			var requestCollect = new AJAX_OBJ(myCollectUrl,afterGetCollect);
			requestCollect.requestData();
		}		
	}
	
	function afterGetCollect(xmlHttpResponse){
		//alert(xmlHttpResponse.responseText);
		eval("collectList ="+xmlHttpResponse.responseText);
		var playImg = p1_img.src;	
		var collectImg = d1_img.src;	
		var collect = null;
		for(var i=0;i<7;i++){
			collect = collectList[i];
			if (collect ==null){
				$id('content'+(i+1)+'_div').innerText = "";
				$id('date'+(i+1)+'_div').innerText = "";
				$id('code'+(i+1)+'_div').innerText = "";
				hidden('play'+(i+1)+'_div');
				hidden('collect'+(i+1)+'_div');
			}else{
				$id('content'+(i+1)+'_div').innerText = showObject.showPartChar(collect.title);
				$id('date'+(i+1)+'_div').innerText = collect.reserve1+"分";
				$id('code'+(i+1)+'_div').innerText = collect.contentCode;
				//alert($id('date'+(i+1)+'_div').innerText);
				//$id('play'+(i+1)+'_a').onclick = "openContent('"+collect.contentType+"','"+collect.indexUrl+"')";
				//$id('collect'+(i+1)+'_a').onclick = "openOverLayFrame('"+collect.collectUrl+"',0,0,1280,720)";
				appear('play'+(i+1)+'_div');
				appear('collect'+(i+1)+'_div');
				$id('collect'+(i+1)+'_img').src = collectImg ;	
				$id('play'+(i+1)+'_img').src = playImg;
			}
		}
		appearDetail(1);
		$id("pageCount").innerText = pageIndex+"/"+pageCount; 
		if (firstTime && collectList.length>0){
			$id("play1_a").focus();
			firstTime = false;
		}
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
	function openOverLayFrameColEx(left,top,width,height,pos){
		var cardId = CA.card.serialNumber;
		var url = collectList[pos].collectUrl+"&account="+cardId;
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
	
	function init(){
		var myCollectTotalUrl = "<%=request.getContextPath()%>/result/getEpgProgramTotal.do?initals=${param.initals}&r="+Math.random();
		if (requester!=null){
			requester.cancel();
		}
		showObject=new showContent(34,3,500);
		$id("main").style.display = "block";
		requester = new AJAX_OBJ(myCollectTotalUrl,afterGetTotalCollect);
		requester.requestData();
		
	}	
	
	
	function focusPlay(idx){
		//$id("test").innerText=$id("test").innerText+" "+idx;
		lostFocusHandler("play");
		currentFocusId  = "play"+idx+"_img";
		$id('play'+idx+'_img').src=$id("play_img").src;
		//if ($id("animationBar").style.visibility == 'hidden'){
	 		//如果菜单重新获得焦点,则显示菜单条即可
		if($id("animationBar").style.top != $id("c"+idx+"_div").style.top){
			$id("animationBar").style.top = $id("c"+idx+"_div").style.top;			
			$id("animationBar").style.left = $id("c"+idx+"_div").style.left;
			appearDetail(idx);
		}
		appear("animationBar");
		//	return;
		//}else{
			//触发菜单条移动动画
		//	animation = new showSlip1("animationBar",0,2,10);
		//	animation.moveToSameLocation("c"+idx+"_div",0,0);
		//}
		
		
	}
	
	function appearDetail(idx){
		var contentCode = $id('code'+idx+'_div').innerText ;
		if (contentCode =="") return;
		//$id("test").innerText=$id("test").innerText+" "+idx+" ["+$id('code'+idx+'_div').innerText+"]";
		var programDetailUrl = "<%=request.getContextPath()%>/biz/-/cat/-/det/" + collectList[idx-1].contentType + "/"+contentCode+"/getProgramDetail.do";//?r="+Math.random();
		if (requester!=null){
			requester.cancel();
		}
		requester = new AJAX_OBJ(programDetailUrl,afterGetDetail);
		requester.requestData();
	}
	
	function afterGetDetail(xmlHttpResponse){
		//alert(xmlHttpResponse.responseText);
		eval("var programDetail ="+ xmlHttpResponse.responseText);
		//var programDetail = eval("("+xmlHttpResponse.responseText+")");
		$id("director_div").innerText = programDetail.director;
		if (programDetail.actors.length>11){
			$id("actor_div").innerText = programDetail.actors.substring(0,11);
		}else{
			$id("actor_div").innerText = programDetail.actors;
		}
		
		if (programDetail.summaryMedium.length>44){
			$id("intro_div").innerText = programDetail.summaryMedium.substring(0,42)+"...";
		}else{
			$id("intro_div").innerText = programDetail.summaryMedium;
		}
		$id("poster_img").src = programDetail.posterFullPath;
	}
	
	function focuscollect(idx){
		lostFocusHandler("play");
		currentFocusId  = "collect"+idx+"_img";
		$id('collect'+idx+'_img').src = collect_img.src;
		//if ($id("animationBar").style.visibility == 'hidden'){
	 		//如果菜单重新获得焦点,则显示菜单条即可
		if($id("animationBar").style.top != $id("c"+idx+"_div").style.top){
			$id("animationBar").style.top = $id("c"+idx+"_div").style.top;			
			$id("animationBar").style.left = $id("c"+idx+"_div").style.left;
			appearDetail(idx);
		}
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
	function unfocuscollect(idx){
		$id('collect'+idx+'_img').src = d1_img.src;
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
			$id("btnback_img").src = $id("back0_img").src;
		}else if(item == "play"){
			$id("pl_img").src = $id("pl0_img").src;
			$id("pr_img").src = $id("pr0_img").src;
			$id("btnback_img").src = $id("back0_img").src;
		}else if(item == "back"){
			hidden("animationBar");
			$id("pl_img").src = $id("pl0_img").src;
			$id("pr_img").src = $id("pr0_img").src;
		}
	}
	function focusBack(){
		$id("btnback_img").src = $id("back1_img").src;
		lostFocusHandler("back");
	}
	function unfocusBack(){
		$id("btnback_img").src = $id("back0_img").src;
	}
	function back(){
		if (typeof(iPanel)!='undefined'){
			iPanel.back();
		}else{
			history.back();
		}
	}
	function openContent(type, url){
		openOverLayFrame(url,0,0,1280,720);
	}
	function hideMainFrame(){
		$id("bodyImg").style.visibility = "hidden";
		//$id("main").style.display = "none";
		$id("main").style.left = -1280;
	}
	function blockMainFrame(){
		$id("bodyImg").style.visibility = "visible";
		//$id("main").style.display = "block";
		$id("main").style.left = 0;
		window.mainFrame.focus();
		return 0;
	}
</script>
<epg:body onload="init()" background="/common/images/tools/result.jpg" style="background-color:#00000;background-repeat:no-repeat;position:absolute;top:0px;left:0px;width:1280px;height:720px">
<div id="main"  style="display: none;width:1280;height:720;position:absolute;left:0;top:0;">
<!-- 隐藏的图片,js切换图片使用 -->
<div style="visibility:hidden;position:absolute; top:0px; left:0px; width:0px; height:0px; z-index:0;">
	<epg:img id="blank" src="/common/images/tools/dot.gif" />
	<epg:img id="blank" src="/common/images/tools/dot.gif" />
	<epg:img id="play" src="/common/images/tools/play1.png" width="1" height="1"/>
	<epg:img id="collect" src="/common/images/tools/collect1.png" width="1" height="1"/>
	<epg:img id="p1" src="/common/images/tools/play.png" width="1" height="1"/>
	<epg:img id="d1" src="/common/images/tools/collect.png" width="1" height="1"/>
	<epg:img id="back0" src="/common/images/tools/back.png" width="1" height="1"/>
	<epg:img id="back1" src="/common/images/tools/back1.png" width="1" height="1"/>
	<epg:img id="pl0" src="/common/images/tools/pg_u.png" width="1" height="1"/>
	<epg:img id="pl1" src="/common/images/tools/pg_u1.png" width="1" height="1"/>
	<epg:img id="pr0" src="/common/images/tools/pg_d.png" width="1" height="1"/>
	<epg:img id="pr1" src="/common/images/tools/pg_d1.png" width="1" height="1"/>
</div>	

<div align="left" id="total1_div" style="overflow:hidden; position:absolute; top:58px; left:250px; width:650px; height:66px;" >
</div>

<div align="center" id="pageCount" style="position:absolute; top:47px; left:798px; width:50px; height:63px;" >
		0/0						
	</div>
	<div id="pl_div" style="position:absolute;left:873; top:30; width:131; height:62;" ><epg:img id="pl" src="/common/images/tools/pg_u.png" width="131" height="62"  href="#" onclick="up()" onfocus="pageOnfocus('pl')" /></div>
	<div id="pr_div" style="position:absolute;left:986; top:30; width:131; height:62;" ><epg:img id="pr" src="/common/images/tools/pg_d.png" width="131" height="62"  href="#" onclick="down()" onfocus="pageOnfocus('pr')" /></div>
<!-- 我的搜索列表 -->
<div align="center" id="l1" style="position:absolute; top:100px; left:20px; width:830px; height:600px;" >
	
	<div align="center" id="animationBar" style="position:absolute;visibility:hidden; top:40px; left:20px; width:212px; height:66px;" >
		<div align="center" id="play" style="position:absolute; top:0px; left:1px; width:66px; height:66px;" >
			<epg:img id="p" src="/common/images/tools/play.png"  width="66" height="66" />							
		</div>
		<div align="center" id="collect" style="position:absolute; top:0px; left:71px; width:66px; height:66px;" >
			<epg:img id="d" src="/common/images/tools/collect.png"  width="66" height="66" />							
		</div>
		<div align="center" id="resultBar" style="position:absolute; top:45px; left:0px; width:772px; height:10px;" >
			<epg:img id="contentSelect" src="/common/images/tools/contentBar.png"  width="772" height="10" />							
		</div>
	</div>
	<!--
	<div align="left" valign="top" id="note" style="position:absolute;top:578px; left:520px; width:440px; height:66px;" >
			<epg:img src="/common/images/tools/play1.png"  width="66" height="66" />&nbsp;&nbsp; <epg:img src="/common/images/tools/collect1.png"  width="66" height="66" />
	</div>
	<div align="left" valign="top" id="note" style="position:absolute;top:596px; left:500px; width:440px; height:66px;color:gray" >
		按&nbsp;&nbsp;&nbsp;&nbsp;播放 &nbsp;&nbsp;&nbsp;删除
	</div>
	-->
	<!-- content 1 -->
	<div align="center" id="c1_div" style="position:absolute;top:40px; left:21px; width:820px; height:60px;" >
		<div align="center" id="play1_div" style="position:absolute;top:0px; left:0px; width:66px; height:66px;" >
			<epg:img id="play1" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="openOverLayFramePlayEx(0,0,1280,720,0)" onfocus="focusPlay(1)" onblur="unfocusPlay(1)"/>
		</div>
		<div align="center" id="collect1_div" style="position:absolute;top:0px; left:70px; width:66px; height:66px;" >
			<epg:img id="collect1" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="openOverLayFrameColEx(0,0,1280,720,0)" onfocus="focuscollect(1)" onblur="unfocuscollect(1)"/>
		</div>
		<div align="left" id="content1_div" style="position:absolute;top:18px; left:160px; width:520px; height:66px;" >
		</div>
		<div align="left" id="date1_div" style="position:absolute;top:18px; left:660px; width:140px; height:66px;" >
		</div>
		<div align="center" id="resultBar1" style="position:absolute; top:50px; left:20px; width:772px; height:10px;" >
			<epg:img src="/common/images/tools/contentBar1.png"  width="772" height="10" />							
		</div>
		<div align="left" id="code1_div" style="position:absolute;top:18px; left:670px; width:140px; height:66px;visibility:hidden" >
		</div>
	</div>	
	
	<!-- content 2 -->
	<div align="center" id="c2_div" style="position:absolute;top:100px; left:21px; width:820px; height:60px;" >
		<div align="center" id="play2_div" style="position:absolute;top:0px; left:0px; width:66px; height:66px;" >
			<epg:img id="play2" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="openOverLayFramePlayEx(0,0,1280,720,1)" onfocus="focusPlay(2)" onblur="unfocusPlay(2)"/>
		</div>
		<div align="center" id="collect2_div" style="position:absolute;top:0px; left:70px; width:66px; height:66px;" >
			<epg:img id="collect2" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="openOverLayFrameColEx(0,0,1280,720,1)" onfocus="focuscollect(2)" onblur="unfocuscollect(2)"/>
		</div>
		<div align="left" id="content2_div" style="position:absolute;top:18px; left:160px; width:520px; height:66px;" >
		</div>
		<div align="left" id="date2_div" style="position:absolute;top:18px; left:660px; width:140px; height:66px;" >
		</div>
		<div align="center" id="resultBar2" style="position:absolute; top:50px; left:20px; width:772px; height:10px;" >
			<epg:img src="/common/images/tools/contentBar1.png"  width="772" height="10" />							
		</div>
		<div align="left" id="code2_div" style="position:absolute;top:18px; left:670px; width:140px; height:66px;visibility:hidden" >
		</div>
	</div>	
	
	<!-- content 3 -->
	<div align="center" id="c3_div" style="position:absolute;top:160px; left:21px; width:820px; height:70px;" >
		<div align="center" id="play3_div" style="position:absolute;top:0px; left:0px; width:66px; height:66px;" >
			<epg:img id="play3" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="openOverLayFramePlayEx(0,0,1280,720,2)" onfocus="focusPlay(3)" onblur="unfocusPlay(3)"/>
		</div>
		<div align="center" id="collect3_div" style="position:absolute;top:0px; left:70px; width:66px; height:66px;" >
			<epg:img id="collect3" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="openOverLayFrameColEx(0,0,1280,720,2)" onfocus="focuscollect(3)" onblur="unfocuscollect(3)"/>
		</div>
		<div align="left" id="content3_div" style="position:absolute;top:18px; left:160px; width:520px; height:66px;" >
		</div>
		<div align="left" id="date3_div" style="position:absolute;top:18px; left:660px; width:140px; height:66px;" >
		</div>
		<div align="center" id="resultBar3" style="position:absolute; top:50px; left:20px; width:772px; height:10px;" >
			<epg:img src="/common/images/tools/contentBar1.png"  width="772" height="10" />							
		</div>
		<div align="left" id="code3_div" style="position:absolute;top:18px; left:670px; width:140px; height:66px;visibility:hidden" >
		</div>
	</div>	
	<!-- content 4 -->
	<div align="center" id="c4_div" style="position:absolute;top:220px; left:21px; width:820px; height:70px;" >
		<div align="center" id="play4_div" style="position:absolute;top:0px; left:0px; width:66px; height:66px;" >
			<epg:img id="play4" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="openOverLayFramePlayEx(0,0,1280,720,3)" onfocus="focusPlay(4)" onblur="unfocusPlay(4)"/>
		</div>
		<div align="center" id="collect4_div" style="position:absolute;top:0px; left:70px; width:66px; height:66px;" >
			<epg:img id="collect4" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="openOverLayFrameColEx(0,0,1280,720,3)" onfocus="focuscollect(4)" onblur="unfocuscollect(4)"/>
		</div>
		<div align="left" id="content4_div" style="position:absolute;top:18px; left:160px; width:520px; height:66px;" >
		</div>
		<div align="left" id="date4_div" style="position:absolute;top:18px; left:660px; width:140px; height:66px;" >
		</div>
		<div align="center" id="resultBar4" style="position:absolute; top:50px; left:20px; width:772px; height:10px;" >
			<epg:img src="/common/images/tools/contentBar1.png"  width="772" height="10" />							
		</div>
		<div align="left" id="code4_div" style="position:absolute;top:18px; left:670px; width:140px; height:66px;visibility:hidden" >
		</div>
	</div>	
	<!-- content 5 -->
	<div align="center" id="c5_div" style="position:absolute;top:280px; left:21px; width:820px; height:70px;" >
		<div align="center" id="play5_div" style="position:absolute;top:0px; left:0px; width:66px; height:66px;" >
			<epg:img id="play5" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="openOverLayFramePlayEx(0,0,1280,720,4)" onfocus="focusPlay(5)" onblur="unfocusPlay(5)"/>
		</div>
		<div align="center" id="collect5_div" style="position:absolute;top:0px; left:70px; width:66px; height:66px;" >
			<epg:img id="collect5" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="openOverLayFrameColEx(0,0,1280,720,4)" onfocus="focuscollect(5)" onblur="unfocuscollect(5)"/>
		</div>
		<div align="left" id="content5_div" style="position:absolute;top:18px; left:160px; width:520px; height:66px;" >
		</div>
		<div align="left" id="date5_div" style="position:absolute;top:18px; left:660px; width:140px; height:66px;" >
		</div>
		<div align="center" id="resultBar5" style="position:absolute; top:50px; left:20px; width:772px; height:10px;" >
			<epg:img src="/common/images/tools/contentBar1.png"  width="772" height="10" />							
		</div>
		<div align="left" id="code5_div" style="position:absolute;top:18px; left:670px; width:140px; height:66px;visibility:hidden" >
		</div>
	</div>	
	<!-- content 6 -->
	<div align="center" id="c6_div" style="position:absolute;top:340px; left:21px; width:820px; height:70px;" >
		<div align="center" id="play6_div" style="position:absolute;top:0px; left:0px; width:66px; height:66px;" >
			<epg:img id="play6" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="openOverLayFramePlayEx(0,0,1280,720,5)" onfocus="focusPlay(6)" onblur="unfocusPlay(6)"/>
		</div>
		<div align="center" id="collect6_div" style="position:absolute;top:0px; left:70px; width:66px; height:66px;" >
			<epg:img id="collect6" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="openOverLayFrameColEx(0,0,1280,720,5)" onfocus="focuscollect(6)" onblur="unfocuscollect(6)"/>
		</div>
		<div align="left" id="content6_div" style="position:absolute;top:18px; left:160px; width:520px; height:66px;" >
		</div>
		<div align="left" id="date6_div" style="position:absolute;top:18px; left:660px; width:140px; height:66px;" >
		</div>
		<div align="center" id="resultBar6" style="position:absolute; top:50px; left:20px; width:772px; height:10px;" >
			<epg:img src="/common/images/tools/contentBar1.png"  width="772" height="10" />							
		</div>
		<div align="left" id="code6_div" style="position:absolute;top:18px; left:670px; width:140px; height:66px;visibility:hidden" >
		</div>
	</div>	
	<!-- content 7 -->
	<div align="center" id="c7_div" style="position:absolute;top:400px; left:21px; width:820px; height:70px;" >
		<div align="center" id="play7_div" style="position:absolute;top:0px; left:0px; width:66px; height:66px;" >
			<epg:img id="play7" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="openOverLayFramePlayEx(0,0,1280,720,6)" onfocus="focusPlay(7)" onblur="unfocusPlay(7)"/>
		</div>
		<div align="center" id="collect7_div" style="position:absolute;top:0px; left:70px; width:66px; height:66px;" >
			<epg:img id="collect7" src="/common/images/tools/dot.gif" href="#" width="66" height="66" onclick="openOverLayFrameColEx(0,0,1280,720,6)" onfocus="focuscollect(7)" onblur="unfocuscollect(7)"/>
		</div>
		<div align="left" id="content7_div" style="position:absolute;top:18px; left:160px; width:520px; height:66px;" >
		</div>
		<div align="left" id="date7_div" style="position:absolute;top:18px; left:660px; width:140px; height:66px;" >
		</div>
		<div align="center" id="resultBar7" style="position:absolute; top:50px; left:20px; width:772px; height:10px;" >
			<epg:img src="/common/images/tools/contentBar1.png"  width="772" height="10" />							
		</div>
		<div align="left" id="code7_div" style="position:absolute;top:18px; left:670px; width:140px; height:66px;visibility:hidden" >
		</div>
	</div>	
</div>
<div align="center" id="detail" style="position:absolute;top:140px; left:802px; width:400px; height:510px;" >
		<div align="center" id="poster_div" style="position:absolute;top:30px; left:126px; width:152px; height:220px;" >
			<img id="poster_img"  href="#" width="152" height="220" />
		</div>
		<div align="left" id="director_label_div" style="position:absolute;top:266px; left:10px; width:120px; height:66px;" >
			导演:
		</div>
		<div align="left" id="director_div" style="position:absolute;top:266px; left:90px; width:300px; height:66px;" >
		</div>
		<div align="left" id="actor_label_div" style="position:absolute;top:306px; left:10px; width:120px; height:66px;" >
			主演:
		</div>
		<div align="left" id="actor_div" style="position:absolute;top:306px; left:90px; width:300px; height:66px;" >
		</div>
		<div align="left" id="intro_label_div" style="position:absolute;top:346px; left:10px; width:120px; height:66px;" >
			简介:
		</div>
		<div align="left" id="intro_div" style="position:absolute;top:346px; left:90px; width:300px; height:150px;line-height:40px;" >
		</div>
	</div>	
	
<div id="btnback" style="position:absolute; top:30px; left:1100px; width: 131px;height:62px;z-index:10;">
	<epg:img id="btnback" onclick="back()" onfocus="focusBack();" onblur="unfocusBack();" href="#"  src="/common/images/tools/back.png" height="62" width="131" />
</div>
</div>
</epg:body>
</epg:html>