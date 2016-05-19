package sitv.epg.business.user;

import sitv.epg.zhangjiagang.EpgUserSession;
import sitv.epg.entity.user.EpgSubscriber;


public class EpgSubscriberFactory {
	public static EpgSubscriber createEpgSubscriber(EpgUserSession userSession){
		EpgSubscriber  es = new EpgSubscriber();
		es.setUserAccount(userSession.getUserAccount());
		return es;
	}
}
