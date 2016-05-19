function Gvent(code, args){
	this.code = code;
	this.args = args;
}
var iPanelReturnFlag = false;
document.onsystemevent = grabEvent;
//document.onkeypress = grabEvent;
//document.onkeyup = grabEvent;
document.onkeydown = grabEvent;
function grabEvent(e)
{
	var e = e||event;
	var keycode = e.keyCode||e.which||e.charCode;
	//alert("keycode="+keycode);
	var retv = 1;
	if(keycode == 5974){//onload成功
		var args = new Object();
		args.modifiers = 0;
		var code = "SYSTEM_EVENT_ONLOAD";
		sys = eventHandler(new Gvent(code, args));
		return sys;
	}
	else if(keycode < 58 && keycode > 40){//数字键
		var args = new Object();
		args.value = keycode - 48;
		eventHandler(new Gvent("KEY_NUMERIC", args));
		if(iPanelReturnFlag) return 1;
	}
	else if(keycode < 269 && keycode > 258){//数字键
		var args = new Object();
		args.value = keycode - 259;
		eventHandler(new Gvent("KEY_NUMERIC", args));
		if(iPanelReturnFlag) return 1;
	}
	else{
		var code = null;
		var args = new Object();
		args.modifiers = 0;
	  switch(keycode)
		{
			case 1://up
			case 38:
				code = "SITV_KEY_UP";
				//args.modifiers = event.modifiers;
				//iPanelReturnFlag = true;
				break;
			case 2://down
			case 40:
				code = "SITV_KEY_DOWN";
				break;
			case 3://left
			case 37:
				code = "SITV_KEY_LEFT";
				break;
			case 4://right
			case 39:
				code = "SITV_KEY_RIGHT";
				break;
			case 4097://select
			case 13:
				code = "SITV_KEY_SELECT";
				break;
			case 27://exit
			case 339:
				/*var ipanelOrSiTV = iPanel.getGlobalVar("from");
				if(ipanelOrSiTV == "iPanel"){
					var cardId = CA.card.serialNumber;
					if(cardId == "" || typeof(cardId) == "undefined"){
						window.location.href = "ui://index.htm";
					}else{
						window.setTimeout('window.location.href = "ui://index.htm";',8000);
						window.location.href = "http://192.168.11.162/portaltest2013/index.htm?STB_ID=" + HardwareInfo.STB.serialnumber + "&type=512&smid=" + cardId;
					}
					return 0;
					break;
				}else{*/
					code = "SITV_KEY_EXIT";
					break;
				//}
			case 340://back
			case 8:
				code = "SITV_KEY_BACK";
				break;
			case 512://menu
			case 513:
			case 4098:
				code = "SITV_KEY_MENU";
				if (typeof(iPanel) != 'undefined') {
					iPanel.focus.display = 1;
					iPanel.focus.border = 1;
				}
				break;
			case 832://red
			case 2305:
				code = "SITV_KEY_RED";
				break;
			case 833://green
				code = "SITV_KEY_GREEN";
				break;
			case 834://yellow
				code = "SITV_KEY_YELLOW";
				break;
			case 835://blue
				code = "SITV_KEY_BLUE";
				break;
			case 4168://page up
			case 375:
			case 372:
			case 33:
				code = "SITV_KEY_PAGEUP";
				break;
			case 4167://page down
			case 374:
			case 373:
			case 34:
				code = "SITV_KEY_PAGEDOWN";
				break;
			case 595://volume up
			case 4109:
				code = "SITV_KEY_VOLUMEUP";
				break;
			case 596://volume down
			case 4110:
				code = "SITV_KEY_VOLUMEDOWN";
				break;
			//case 597://volume mute
			//case 4108:
			//	code = "SITV_KEY_MUTE";
			//	break;
		}
		if(code){
			retv = eventHandler(new Gvent(code, args));
			return retv;
		}
	}
}
if (typeof(iPanel) != 'undefined') {
	iPanel.focus.display = 0;
	iPanel.focus.border = 0;
}