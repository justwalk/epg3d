package sitv.epg.web.tag;

import javax.servlet.jsp.JspException;
import sitv.epg.business.EpgLogFactory;

/**
 * 记录播放log标签
 * @author zhangxs
 *
 */
public class PlayLogTag extends SitvEpgBaseTag {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1942744776200901903L;
	public String log;

	@Override
	public void release() {
		log = "";
		super.release();
	}

	@Override
	public int doEndTag() throws JspException {
		if (EpgLogFactory.getPlayLogger().isInfoEnabled()) {
			EpgLogFactory.getPlayLogger().info(log);
		}
		return super.doEndTag();
	}

	public String getLog() {
		return log;
	}

	public void setLog(String log) {
		this.log = log;
	}

}
