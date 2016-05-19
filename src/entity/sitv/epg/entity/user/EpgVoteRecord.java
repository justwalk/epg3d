/**
 * 
 */
package sitv.epg.entity.user;
import java.util.*;

/**
 * 投票的操作记录
 * @author chenjie
 *
 */
public class EpgVoteRecord implements java.io.Serializable{
	private Long id;
	private String userMac;
	private String contentType;
	private String contentCode;
	private String voteMethod;
	private int voteVal;
	private Date voteTime;
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getUserMac() {
		return userMac;
	}
	public void setUserMac(String userMac) {
		this.userMac = userMac;
	}
	public String getContentType() {
		return contentType;
	}
	public void setContentType(String contentType) {
		this.contentType = contentType;
	}
	public String getContentCode() {
		return contentCode;
	}
	public void setContentCode(String contentCode) {
		this.contentCode = contentCode;
	}
	public String getVoteMethod() {
		return voteMethod;
	}
	public void setVoteMethod(String voteMethod) {
		this.voteMethod = voteMethod;
	}
	public int getVoteVal() {
		return voteVal;
	}
	public void setVoteVal(int voteVal) {
		this.voteVal = voteVal;
	}
	public Date getVoteTime() {
		return voteTime;
	}
	public void setVoteTime(Date voteTime) {
		this.voteTime = voteTime;
	}
	
}
