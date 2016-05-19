/*
 * showList对象的作用就是控制在页面列表数据信息上下滚动切换以及翻页；
 * @__listSize    列表显示的长度；
 * @__dataSize    所有数据的长度；
 * @__position    数据焦点的位置；
 * @__startplace  页面焦点Div开始位置的TOP值；
 */
function showList(__listSize, __dataSize, __position, __startplace){
	this.listSize = __listSize;  //列表显示的长度；
	this.dataSize = __dataSize;  //所有数据的长度；
	this.position = __position;  //数据焦点的位置；
	this.tempSize = this.dataSize<this.listSize?this.dataSize:this.listSize;
	this.focusPos = this.dataSize-this.position<this.tempSize?this.tempSize-(this.dataSize-this.position):0; //页面焦点的位置；

	this.listHigh = null;  //列表中每个行的高度，可以是数据或者数组，例如：40 或 [40,41,41,40,42];
	this.focusDiv = null;  //页面焦点的ID名称或者定义为滑动对象，例如："focusDiv" 或 new showSlip("focusDiv",0,3,40);
	this.focusPlace = new Array();  //记录每行页面焦点的位置值；
	this.startPlace = __startplace;	 //页面焦点Div开始位置的TOP值；
	
	this.haveData = function(){}; //在显示列表信息时，有数据信息就会调用该方法；
	this.notData = function(){}; //在显示列表信息时，无数据信息就会调用该方法；
	this.showScrollData = function(){}; //当列表中的某个行获得焦点时，调用此方法以滚动方式显示信息
	//调用以上三个方法都会收到参数为{idPos:Num, dataPos:Num}的对象，该对象属性idPos为页面焦点的值，属性dataPos为数据焦点的值；
	
	this.focusUp  = function(){this.changeList(-1);}; //焦点向上移动；
	this.focusDown= function(){this.changeList(1); }; //焦点向下移动；
	this.pageUp   = function(){this.changePage(-1);}; //列表向上翻页；
	this.pageDown = function(){this.changePage(1); }; //列表向下翻页；
	
	//开始显示列表信息
	this.startShow = function(){
		this.focusPlace[0]= this.startPlace;
		if(typeof(this.listHigh)=="number"){
			for(var i=1; i<this.listSize; i++) this.focusPlace[i] = this.listHigh*i+this.startPlace;
		}else if(typeof(this.listHigh)=="object"){
			for(var i=1; i<this.listSize; i++) this.focusPlace[i] = typeof(this.listHigh[i-1])=="undefined"?this.listHigh[this.listHigh.length-1]+this.focusPlace[i-1]:this.listHigh[i-1]+this.focusPlace[i-1];
		}
		if(typeof(this.focusDiv)=="string"){
			document.getElementById(this.focusDiv).style.top = this.focusPlace[this.focusPos];
		}else{
			this.focusDiv.tunePlace(this.focusPlace[this.focusPos]);
		}
		this.showList();
	}

	//切换数据焦点的位置
	this.changeList = function(__num){
		if(this.position+__num<0||this.position+__num>this.dataSize-1) return;
		this.haveData({idPos:this.focusPos, dataPos:this.position});
		this.position += __num;
		if(this.focusPos+__num<0||this.focusPos+__num>this.listSize-1){
			this.showList();
		}else{
			this.changeFocus(__num);
			this.showScrollData({idPos:this.focusPos, dataPos:this.position});
		}
	}

	//切换页面列表翻页
	this.changePage = function(__num){
		var tempPos = this.position-this.focusPos;
		if((tempPos==0 && __num<0)||(tempPos==this.dataSize-this.tempSize && __num>0)) return;
		this.haveData({idPos:this.focusPos, dataPos:this.position});
		tempPos += __num*this.tempSize;
		if(tempPos<0){
			tempPos = 0;
		}else if(tempPos>this.dataSize-this.tempSize){
			tempPos = this.dataSize-this.tempSize;
		}
		if(this.focusPos!=0) this.changeFocus(this.focusPos*-1);
		this.position = tempPos;
		this.showList();
	}

	//切换页面焦点的位置
	this.changeFocus = function(__num){
		this.focusPos += __num;		
		if(typeof(this.focusDiv)=="string"){
			document.getElementById(this.focusDiv).style.top = this.focusPlace[this.focusPos];
		}else{
			this.focusDiv.moveStart(__num/Math.abs(__num), Math.abs(this.focusPlace[this.focusPos-__num]-this.focusPlace[this.focusPos]));
		}
	}
	//显示列表信息
	this.showList = function(){
		var tempPos = this.position-this.focusPos;
		for(var i=tempPos; i<tempPos+this.listSize; i++){
			if(i<this.dataSize){
				this.haveData({idPos:i-tempPos, dataPos:i});
			}else{
				this.notData({idPos:i-tempPos, dataPos:i});
			}
		}
		this.showScrollData({idPos:this.focusPos, dataPos:this.position});
	}
}




/*
 * showSlip对象的作用就是控制Div层的滑动；
 * @__name  所要滑动对象的ID名称；
 * @__sign  “0”表示上下滑动，“1”表示左右滑动；
 * @__delay 此值是控制步长的，每次滑动的步长就是到终点所剩距离的__delay分之一,默认值(4)；
 * @__time  滑动间隔时间,默认值(40)；
 */
function showSlip(__name, __sign, __delay, __time){
	this.moveObj = document.getElementById(__name); //所要滑动的对象；
	this.moveSize = 500;    //每一次滑动的距离；
	this.moveType = 1;      //1表是正向滑动，-1表是反向滑动；
	this.moveSign = __sign; //0表示top属性，1表示left属性；

	this.endPlace  = (this.moveSign==0)?this.moveObj.style.top:this.moveObj.style.left; //滑动结束位置；
	
	this.currPlace = this.endPlace; //滑动当前位置；
	

	this.moveLoad = null;
	this.spaceTime = __time;   //滑动间隔时间,默认值(40)；
	this.delayValue= __delay;  //此值是控制步长的，每次滑动的步长就是到终点所剩距离的this.delayValue分之一,默认值(4)；
	//开始滑动对象
	this.moveStart = function(__type, __size){
		this.moveStop();
		this.moveType = __type;
		this.moveSize = __size;
		
		this.endPlace += this.moveSize*this.moveType;
		
		this.moveGoto();
	}
	//计算当前要滑动的位置
	this.moveGoto = function(){
		var tempStep = Math.ceil(Math.abs((this.endPlace-this.currPlace)/this.delayValue))*this.moveType; //计算步长
		this.currPlace += tempStep;
		if((this.moveType==-1&&this.currPlace<=this.endPlace)||(this.moveType==1&&this.currPlace>=this.endPlace)||tempStep==0){ //判断是否到达终点
			this.currPlace = this.endPlace;
			this.setcurrPlace();
			
		}else{
			var self = this;
			this.setcurrPlace();
			this.moveLoad = window.setTimeout(function(){self.moveGoto();},this.spaceTime);
		}
	}
	//设置滑动对象的位置
	this.setcurrPlace = function(){
		if(this.moveSign==0){
			this.moveObj.style.top = this.currPlace;
		}else{
			this.moveObj.style.left= this.currPlace;
		}
	}
	//调整对象位置，参数__num是将要调整位置的值
	this.tunePlace = function(__num){
		this.endPlace  = __num; 
		this.currPlace = this.endPlace;
		this.setcurrPlace();
	}
	//对象停止滑动
	this.moveStop = function(){ window.clearTimeout(this.moveLoad);}
}


function getNum(pxValue){	
	if (isNaN(pxValue)){
		//alert("pxValue["+pxValue+"]  px["+pxValue.substring(0,pxValue.indexOf("px"))+"]");
		if (pxValue.indexOf("pt")!=-1){
			return parseInt(pxValue.substring(0,pxValue.indexOf("pt")));
		}
		return parseInt(pxValue.substring(0,pxValue.indexOf("px")));
	}else{
		return parseInt(pxValue);
	}
}
//var _animation = null;

/*
 * showSlip对象的作用就是控制Div层的滑动；
 * @__name  所要滑动对象的ID名称；
 * @__sign  “0”表示上下滑动，“1”表示左右滑动；
 * @__delay 此值是控制步长的，每次滑动的步长就是到终点所剩距离的__delay分之一,默认值(4)；
 * @__time  滑动间隔时间,默认值(40)；
 */
function showSlip1(__name, __sign, __delay, __time){
	this.moveObj = document.getElementById(__name); //所要滑动的对象；
	this.moveSize = 500;    //每一次滑动的距离；
	this.moveType = 1;      //1表是正向滑动，-1表是反向滑动；
	this.moveSign = __sign; //0表示top属性，1表示left属性；
	this.endPlace  = parseInt((this.moveSign==0)?getNum(this.moveObj.style.top):getNum(this.moveObj.style.left)); //滑动结束位置；
	this.currPlace = this.endPlace; //滑动当前位置；
    this.finished = true;
    this.finishCallback = function(){};
	this.moveLoad = null;
	this.spaceTime = __time;   //滑动间隔时间,默认值(40)；
	this.delayValue= __delay;  //此值是控制步长的，每次滑动的步长就是到终点所剩距离的this.delayValue分之一,默认值(4)；
	//开始滑动对象
	this.moveStart = function(__type, __size){
		if (__size == 0) return;
		/**
		if (_animation!=null){
			$id("test").innerText =_animation.moveObj.id+" "+this.moveObj.id+" "+_animation.finished;
		}
		if (_animation!=null && _animation.moveObj.id == this.moveObj.id){
			$id("test").innerText = _animation.finished;
			if (!_animation.finished) return;
		}
		_animation = this;
		**/
		this.finished = false;
		this.moveStop();
		this.moveType = __type;
		this.moveSize = __size;
		this.endPlace += this.moveSize*this.moveType;		
		this.moveGoto();
	}
	this.moveToSameLocation = function ( __destObjId,__leftOffset,__topOffset){
		var barLeft = getNum(this.moveObj.style.left);
	     var barTop = getNum(this.moveObj.style.top);
	     var destObj = document.getElementById(__destObjId);
		var elementLeft = getNum(destObj.style.left)-__leftOffset;
		var elementTop = getNum(destObj.style.top)-__topOffset;
		if (elementLeft-barLeft ==0){
			var topDif = barTop - elementTop;
			if (topDif == 0) return;
			this.moveSign = 0;
			this.endPlace  = parseInt((this.moveSign==0)?getNum(this.moveObj.style.top):getNum(this.moveObj.style.left)); //滑动结束位置；
			this.currPlace = this.endPlace; //滑动当前位置；
			if (topDif>0){
				this.moveStart(-1,topDif);
			}else if (topDif<0){
				this.moveStart(1,-topDif);
			}
		}else if (elementTop -barTop ==0){
			var leftDif = barLeft - elementLeft;
			if (leftDif == 0) return;
			this.moveSign = 1;
			this.endPlace  = parseInt((this.moveSign==0)?getNum(this.moveObj.style.top):getNum(this.moveObj.style.left)); //滑动结束位置；
			this.currPlace = this.endPlace; //滑动当前位置；
			if (leftDif>0){
				this.moveStart(-1,leftDif);
			}else if (leftDif<0){
				this.moveStart(1,-leftDif);
			}
		}else{
			this.moveObj.style.left = elementLeft;
			this.moveObj.style.top = elementTop;
		}
	}
	//计算当前要滑动的位置
	this.moveGoto = function(){
		var tempStep = Math.ceil(Math.abs((this.endPlace-this.currPlace)/this.delayValue))*this.moveType; //计算步长
		this.currPlace += tempStep;
		if((this.moveType==-1&&this.currPlace<=this.endPlace)||(this.moveType==1&&this.currPlace>=this.endPlace)||tempStep==0){ //判断是否到达终点
			this.currPlace = this.endPlace;
			this.setcurrPlace();
			this.finishCallback();
			this.finished = true;
			//alert(this.finished);
		}else{
			var self = this;
			this.setcurrPlace();
			this.moveLoad = window.setTimeout(function(){self.moveGoto();},this.spaceTime);
		}
	}
	//设置滑动对象的位置
	this.setcurrPlace = function(){
		if(this.moveSign==0){
			this.moveObj.style.top = this.currPlace;
		}else{
			this.moveObj.style.left= this.currPlace;
		}
	}
	//调整对象位置，参数__num是将要调整位置的值
	this.tunePlace = function(__num){
		this.endPlace  = __num; 
		this.currPlace = this.endPlace;
		this.setcurrPlace();
	}
	//对象停止滑动
	this.moveStop = function(){ window.clearTimeout(this.moveLoad);}
}
	
	if (typeof(iPanel)!='undefined'){
	   iPanel.focus.border = 0; //无边框
	   iPanel.focus.diplay = 0;
	   iPanel.focus.cyclicfocus = 0;
	}
	var animation = null;
	function canMove(){
		if (animation!=null && !animation.finished) return false;
		return true;
	}

	

String.prototype.length2 = function(){
	var cArr = this.match(/[^\x00-\xff]/ig);
	//alert(cArr);
	return this.length + (cArr == null ? 0 : cArr.length);
}
//var str="test测试字符串123人";
//alert("字符串 “" + str + "” 的长度：" + str.length2());

function getNum1(pxValue){	
	if (isNaN(pxValue)){
		//alert("pxValue["+pxValue+"]  px["+pxValue.substring(0,pxValue.indexOf("px"))+"]");
		if (pxValue.indexOf("pt")!=-1){
			return parseInt(pxValue.substring(0,pxValue.indexOf("pt")));
		}
		return parseInt(pxValue.substring(0,pxValue.indexOf("px")));
	}else{
		return parseInt(pxValue);
	}
}




function slipImgFocus (__curorId, __imgWidth, __imgHeight, __difImgAndDiv, __difCurorAndDiv, __maxLength){
	this.curorId = __curorId;
	this.imgWidth = __imgWidth;
	this.imgHeight = __imgHeight;
	this.difImgAndDiv = __difImgAndDiv;
	this.difCurorAndDiv = __difCurorAndDiv;
	this.maxLength = __maxLength;
	
	this.currentFocusId = null;
	this.movedFocusSlip = null;	
		
	var self = this;
	this.getFocus = function(__recId){
		if (this.movedFocusSlip != null){
			if (!this.movedFocusSlip.finished) {			
				//将焦点回到老的焦点上	
			    var ahref = document.getElementById(this.currentFocusId+'_a');
				if (this.currentFocusId != __recId ){
					//alert(this.currentFocusId+" "+__recId);
					ahref.focus();
				}
				return; //如果动画未完成,则不响应.
			}
		}
		//如果当前焦点已存在,则需要恢复原有的放大的div和图片
		if (this.currentFocusId != null && this.difImgAndDiv != 0){
			this.zoomOut();
		}
		//将新获得的焦点保存
		this.currentFocusId = __recId;
		var recDiv = document.getElementById(__recId);
	//alert("befor1: rec=left:"+recDiv.style.left+" top:"+recDiv.style.top+" width:"+recDiv.style.width+" height:"+recDiv.style.height);
		
		var imgDiv = document.getElementById(__recId+'_img');
		var curorDiv = document.getElementById(this.curorId);
		//如果焦点框隐藏,则说明该内容区域还没有获得焦点,需要设置焦点聚焦
		if (curorDiv.style.visibility == "hidden"){
			//焦点获得后内容放大	
			 
			if 	(this.difImgAndDiv != 0){
				this.zoomIn();		
			}
			//复制焦点div区域的位置信息给焦点框
			//copyPosition(recDiv,curorDiv,null,-10,-10,20,20);
			//alert(getNum(recDiv.style.top)+" "+this.difCurorAndDiv);
			curorDiv.style.top = getNum(recDiv.style.top)- this.difCurorAndDiv;
			curorDiv.style.left = getNum(recDiv.style.left)- this.difCurorAndDiv;
			curorDiv.style.width =  getNum(recDiv.style.width)+ this.difCurorAndDiv*2;
			curorDiv.style.height = getNum(recDiv.style.height)+ this.difCurorAndDiv*2;
			if 	(this.difImgAndDiv != 0){
				curorDiv.style.left = getNum(recDiv.style.left)- this.difCurorAndDiv+31;
				curorDiv.style.top = getNum(recDiv.style.top)- this.difCurorAndDiv;
			}
			var focusImg = document.getElementById(self.curorId+"_img");
			if (focusImg != 'undefined' && focusImg != null){
				focusImg.width = getNum(curorDiv.style.width);
				focusImg.height = getNum(curorDiv.style.height);
			}
			//设置可见
			curorDiv.style.visibility = 'visible';
			
		}else{
			//比较焦点框和新获得的焦点之间水平和垂直方向的差		
			
			var leftDif = getNum(curorDiv.style.left) - (getNum(recDiv.style.left) - this.difCurorAndDiv) ;
			if 	(this.difImgAndDiv != 0){
				leftDif = getNum(curorDiv.style.left) - (getNum(recDiv.style.left) - this.difCurorAndDiv)-31 ;
			}
			var topDif = getNum(curorDiv.style.top) - (getNum(recDiv.style.top) - this.difCurorAndDiv);
			//alert(leftDif+" "+topDif);
			var leftOrTop = 0; //默认垂直方向
			var selectedDif = topDif; //默认垂直差
			if (Math.abs(leftDif)>Math.abs(topDif)){ // 水平差大于垂直差则水平运动
				leftOrTop = 1;
				selectedDif = leftDif;
			}
			//设置滑动动画
			this.movedFocusSlip = new showSlip1(this.curorId,leftOrTop,4,40);	
			//alert(this.movedFocusSlip+" ///");
			//滑动完成后新的内容区聚焦放大
			if 	(this.difImgAndDiv != 0){
				this.movedFocusSlip.finishCallback = this.zoomIn;
			}
			//开始动画
			if (selectedDif>0){
				this.movedFocusSlip.moveStart(-1,selectedDif); //反向滑动	
			}else{
				this.movedFocusSlip.moveStart(1,-selectedDif); //正向滑动.
			}
		}
	}
	//复原
	this.zoomOut = function(){
		var recDiv = document.getElementById(self.currentFocusId); //当前焦点div
		var	img = document.getElementById(self.currentFocusId+'_img');//当前图片
		var	titleSpan = document.getElementById(self.currentFocusId+'_title'); //当前title
		var curorDiv = document.getElementById(self.curorId);
		if (curorDiv.style.visibility == "visible"){
			recDiv.style.top = getNum(recDiv.style.top)+self.difImgAndDiv;
			recDiv.style.left = getNum(recDiv.style.left)+self.difImgAndDiv;
			recDiv.style.width = self.imgWidth;
			recDiv.style.height = getNum(recDiv.style.height)-self.difImgAndDiv*2;
			curorDiv.style.top = getNum(recDiv.style.top)-self.difCurorAndDiv;
			curorDiv.style.left = getNum(recDiv.style.left)-self.difCurorAndDiv+31;
			curorDiv.style.width = getNum(recDiv.style.width)+self.difCurorAndDiv*2;
			curorDiv.style.height = getNum(recDiv.style.height)+self.difCurorAndDiv*2;
			var focusImg = document.getElementById(self.curorId+"_img");
			if (focusImg != 'undefined' && focusImg != null){
				focusImg.width = getNum(curorDiv.style.width);
				focusImg.height = getNum(curorDiv.style.height);
			}
			if (img != null){
				img.width = self.imgWidth;
				img.height = self.imgHeight;
			}
			//alert(titleSpan.innerHTML.indexOf("MARQUEE"));	
			titleSpan.style.color = 'white';		
			if (titleSpan.innerHTML.indexOf("MARQUEE")!=-1){
				titleSpan.innerText =  titleSpan.childNodes[0].innerText;
				//alert(titleSpan.innerText);
			} 
		}
	}
	//放大
	this.zoomIn = function(){
		var curorDiv = document.getElementById(self.curorId);
		var recDiv = document.getElementById(self.currentFocusId);
		var img = document.getElementById(self.currentFocusId+'_img');
		//alert("before: rec=left:"+recDiv.style.left+" top:"+recDiv.style.top+" width:"+recDiv.style.width+" height:"+recDiv.style.height);
		//alert(curorDiv.style.left+" "+recDiv.style.left);
		
		recDiv.style.left = getNum(recDiv.style.left) - self.difImgAndDiv ;
		recDiv.style.top = getNum(recDiv.style.top) - self.difImgAndDiv;
		recDiv.style.width = getNum(recDiv.style.width)+self.difImgAndDiv*2;
		recDiv.style.height = getNum(recDiv.style.height)+self.difImgAndDiv*2;
		//alert("after: rec="+recDiv.style.left+" "+recDiv.style.top+" "+recDiv.style.width+" "+recDiv.style.height);
		
		if (img != null){
			img.width = self.imgWidth+self.difImgAndDiv*2;
			img.height = self.imgHeight*(self.difImgAndDiv+self.imgWidth)/self.imgWidth;
		}
		//alert("before: curor="+curorDiv.style.left+" "+curorDiv.style.top+" "+curorDiv.style.width+" "+curorDiv.style.height);
		curorDiv.style.top = getNum(recDiv.style.top)-self.difCurorAndDiv;
		curorDiv.style.left = getNum(recDiv.style.left)-self.difCurorAndDiv+31;
		curorDiv.style.width = getNum(recDiv.style.width)+self.difCurorAndDiv*2;
		curorDiv.style.height = getNum(recDiv.style.height)+self.difCurorAndDiv*2;
			var focusImg = document.getElementById(self.curorId+"_img");
			if (focusImg != 'undefined' && focusImg != null){
				focusImg.width = getNum(curorDiv.style.width);
				focusImg.height = getNum(curorDiv.style.height);
			}
		//alert("after: curor="+curorDiv.style.left+" "+curorDiv.style.top+" "+curorDiv.style.width+" "+curorDiv.style.height);
		
		//判断是否需要将文字转化为marquee;
		var	titleSpan = document.getElementById(self.currentFocusId+'_title');
		//alert(titleSpan.innerText);
		titleSpan.style.color = 'yellow';
		if (titleSpan.innerText.toString().length2()>self.maxLength){
			titleSpan.innerHTML = "<marquee direction='left' width='"+getNum(recDiv.style.width)+"' behavior='alternate' height='"+25+"' scrollamount='1' scrolldelay='10'>"+titleSpan.innerText+"</marquee>"
			//alert(titleSpan.innerHTML);
		}
	}
}

/*
 * showContent对象的作用就是控制在页面中信息显示方式的对象；
 * @__wordLength   显示文字的最大长度；
 * @__dotNum       显示点的个数；
 * @__width        显示的marquee的宽度；
 * @__height       显示的marquee的高度；
 */
function showContent(__wordLength,__dotNum,__width,__height){
	if(typeof(__wordLength)=="undefined")
		this.wordLength=10;
	else
		this.wordLength=__wordLength;
	if(typeof(__dotNum)=="undefined")
		this.dotNum=3;
	else
	    this.dotNum=__dotNum;
    if(typeof(__width)=="undefined")
		this.width=200;
	else
	    this.width=__width;
    if(typeof(__height)=="undefined")
		this.height=20;
	else
	    this.height=__height;

    this.showAllWord=function(str){
		var showStr="";
		if(str.length>this.wordLength){
			showStr="<marquee direction='left' width='"+this.width+"' behavior='alternate' height='"+this.height+"' scrollamount='1' scrolldelay='10'>"+str+"</marquee>";
		}else{
			showStr=str;
		}
		return showStr;
	}
    
    this.showPartChar=function(str){
    	var showStr="";
    	var w = 0;
    	for(var i=0;i<str.length;i++){
    		var c = str.charCodeAt(i);
    		//单1a字a节加    8
    		if(c>97&&c<122) {
    			w++;
    		}else if(c>48&&c<57){
    			w++;
    		}else{
    			w+=2;
    		}
    		if(w>this.wordLength){
        		var dot="";
        		for(var j=0;j<this.dotNum;j++){
        			dot+=".";
        		}
        		showStr = str.substr(0,i)+dot;
        		return showStr;
    		}
    	}
    	showStr = str;
    	return showStr;
    	/*if(w>this.wordLength){
    		var dot="";
    		for(var i=0;i<this.dotNum;i++){
    			dot+=".";
    		}
			showStr=str.substr(0,this.wordLength)+dot; 
    	}else{
			showStr=str;
		}
    	return showStr;*/
    }

	this.showPartWord=function(str){
		var showStr="";
		if(str.length>this.wordLength){
			var dot="";
			for(var i=0;i<this.dotNum;i++){
				dot+=".";
			}
			showStr=str.substr(0,this.wordLength)+dot; 
		}else{
			showStr=str;
		}
		return showStr;
	}
}


function getNum(pxValue){	
	if (isNaN(pxValue)){
		//alert("pxValue["+pxValue+"]  px["+pxValue.substring(0,pxValue.indexOf("px"))+"]");
		if (pxValue.indexOf("pt")!=-1){
			return parseInt(pxValue.substring(0,pxValue.indexOf("pt")));
		}
		return parseInt(pxValue.substring(0,pxValue.indexOf("px")));
	}else{
		return parseInt(pxValue);
	}
}

