var lastKey = 0;
var rekeyTimes = 0;

var _mediaElapsed = 0;//当前播放时间

function Gvent(code, args){
	this.code = code;
	this.args = args;
}

var iPanelReturnFlag = false;

document.onsystemevent = grabEvent;
document.onirkeypress = grabEvent;
function grabEvent()
{

	var retv = 1;
	var keycode = event.which;
	var date = new Date();
	if(keycode == lastKey){
		rekeyTimes++;
	}else{
		lastKey = keycode;
		rekeyTimes = 0;
	}
	//document.getElementById('info').innerHTML += "-"+keycode+"-time="+date.getSeconds()+":"+date.getMilliseconds()+"<br>";//+"("+event.modifiers+")" ;
	if(keycode < 58 && keycode > 40){	//数字键
		var args = new Object();
		args.value = keycode - 48;
		eventHandler(new Gvent("KEY_NUMERIC", args));
		if(iPanelReturnFlag) return 1;
		else return 0;
	}
	else if(keycode < 269 && keycode > 258){	//数字键
		var args = new Object();
		args.value = keycode - 259;
		eventHandler(new Gvent("KEY_NUMERIC", args));
		if(iPanelReturnFlag) return 1;
		else return 0;
	}
	else{
		var code = null;
		var args = new Object();
		args.modifiers = 0;
	    switch(keycode)
		{
			case 1://上
				code = "EIS_IRKEY_UP";
				break;
			case 2://下
				code = "EIS_IRKEY_DOWN";
				break;
			case 3://左
				code = "EIS_IRKEY_LEFT";
				break;
			case 4://右
				code = "EIS_IRKEY_RIGHT";
				break;
			case 1024://播放
				code = "EIS_IRKEY_PLAY";
				break;
			case 1026://暂停
				code = "EIS_IRKEY_PAUSE";
				break;
			case 1040://快退
				code = "EIS_IRKEY_FAST_REWIND";
				break;
			case 1028://快进
				code = "EIS_IRKEY_FAST_FORWARD";
				break;
			case 769://F2
				code = "EIS_IRKEY_F2";
				break;
			case 832://红
				code = "EIS_IRKEY_RED";
				break;
			case 833://绿
				code = "EIS_IRKEY_GREEN";
				break;
			case 834://黄
				code = "EIS_IRKEY_YELLOW";
				break;
			case 835://蓝
				code = "EIS_IRKEY_BLUE";
				break;
			case 13://确定
			    code = "EIS_IRKEY_SELECT";
				break;
			case 595://音量加
				code = "KEY_VOLUME_UP";
				break;				
			case 596://音量减
				code = "KEY_VOLUME_DOWN";
				break;	
			case 597://静音
				code = "EIS_IRKEY_VOLUME_MUTE";
				break;	
			case 567://信息
				code = "EIS_IRKEY_INFO";
				break;
			case 513://菜单
				code = "EIS_IRKEY_MENU";
				break;
			case 339://退出
				code = "EIS_IRKEY_EXIT";
				break;
			case 340://返回
				code = "EIS_IRKEY_BACK";
				break;
			case 372://上一页
				code = "EIS_IRKEY_PAGE_UP";
				break;
			case 373://下一页
				code = "EIS_IRKEY_PAGE_DOWN";
				break;
			case 1025://停止键
				code = "EIS_IRKEY_PLAY_EXIT";
				break;
			case 512://主页
				code = "EIS_IRKEY_MAIN_PAGE";
				break;
			case 514://EPG
				code = "EIS_IRKEY_EPG";
				break;
			case 518://NVOD
				code = "EIS_IRKEY_NVOD";
				break;
			case 564://audio
				code = "EIS_IRKEY_AUDIO";
				break;
			case 570://喜爱键
				code = "EIS_IRKEY_FAVORITE";
				break;
			case 5200://下载数据成功,请求返回时移频道列表
				code="5200";
			    break;
			case 5201://下载数据失败,请求未返回时移频道列表
				code="5201";
			    break;
			case 5202://准备播放媒体成功
				code="5202";
			    break;
			case 5203://连接服务器失败,建立会话失败或者服务器返回超时。p2值定义
				code="5203";
				args.modifiers = event.modifiers;
			    break;
			case 5204://DVB在VOD指定的IPQAM中搜索数据失败
				code="5204";
			    break;
			case 5205://播放媒体成功,p2值代表播放成功类型 1:仅代表rtsp协议连接成功； 2:代表rtsp协议连接成功并且音视频播放成功
				code="5205";
				args.modifiers = event.modifiers;
			    break;
			case 5206://播放媒体失败
				code="5206";
			    break;
            case 5207://更新时移频道的节目列表成功. P2:为时移频道对应直播的service ID
				code="5207";
				args.modifiers = event.modifiers;
			    break;		
			case 5208://更新时移频道的节目列表失败
				code="5208";
			    break;
			case 5209://时移频道或VOD影片播放到了点播开始的位置
				code="5209";
			    break;
			case 5210://时移频道或VOD影片播放到了点播结束的位置.P2：取值为0表示正常播放到尾，取值为1表示快进到尾
				code="5210";
				args.modifiers = event.modifiers;
			    break;
			case 5211://拆链成功
				code="5211";
			    break;
			case 5212://拆链失败
				code="5212";
			    break;
			case 5213://时移请求服务器失败
				code="5213";
			    break;
			case 5214://完成对VOD点播页面地址的获取(EPG服务器地址)，其中p2值为1表示获取EPG服务器地址成功，为2表示获取EPG服务器地址失败。
				code="5214";
				args.modifiers = event.modifiers;
				break;
			case 5220://VOD启动成功,服务数据已更新
				code="5220";
				break;
			case 5221://VOD启动失败：p2值定义如下
				code="5221";
				args.modifiers = event.modifiers;
				break;
			case 5222://底层开始缓冲数据，等待播放
				code="5222";
				break;
			case 5223://缓冲数据结束，已开始播放
				code="5223";
				break;
			case 5224://传入的时间超出有效范围
				code="5224";
				break;
			case 5225://自定义消息段，P2值表示 其具体含义
				code="5225";
				args.modifiers = event.modifiers;
				break;
			case 5226://表示VOD模块接收TSTV 数据成功
				code="5226";
				break;
			case 5227://表示VOD模块接收TSTV 数据失败
				code="5227";
				break;
			case 5551://cable线没有连接上的消息
				code = "EIS_CABLE_NETWORK_DISCONNECT";
				break;
			case 5550://插上cable线的消息
				code = "EIS_CABLE_NETWORK_CONNECT";
				break;
			case 5301://拔出智能卡
				code = "EIS_CA_SMARTCARD_EVULSION";
				break;
			case 5351://插入智能卡
				code = "EIS_CA_SMARTCARD_INSERT";
				break;
			case 5503://测试
				code = "5503";
				break;
		}
		//document.getElementById('info').innerHTML += "-"+keycode+"("+event.modifiers+")" ;
		if(code){
			retv = eventHandler(new Gvent(code, args));
			return retv;
		}
	}
}
