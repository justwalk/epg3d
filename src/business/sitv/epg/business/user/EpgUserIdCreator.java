package sitv.epg.business.user;

import org.springframework.stereotype.Service;

@Service("userIdCreator")
public class EpgUserIdCreator implements UserIdCreator {

	public String createId(String macAddress) {
		return macAddress;
	}

}
