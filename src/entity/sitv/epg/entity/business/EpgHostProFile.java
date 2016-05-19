package sitv.epg.entity.business;

import java.io.Serializable;

/**
 * 
 * EPG 主机配置,包括播放参数的配置
 * 
 * @author zhuwenqing
 */
//@Entity
//@Table(name = "EPG_HOST_PROFILE")
///@Proxy(lazy = false)
//@SequenceGenerator(allocationSize = 1, name = "seq", sequenceName = "EPG_HOST_PROFILE_SEQ")
public class EpgHostProFile implements Serializable {

	
	private Long id;

	//@Column(name = "GROUP_ID")
	private Long groupId;

	//@Column(name = "HOST_CODE")
	private String hostCode;

	//@Column(name = "HOST_NAME")
	private String hostName;

	//@Column(name = "HOST_IP")
	private String hostIp;

	//@Column(name = "NAME")
	private String name;

	//@Column(name = "VALUE")
	private String value;

	//@Column(name = "STATUS")
	private int status;

	/**
	 * @return the id
	 */
	public Long getId() {
		return id;
	}

	/**
	 * @param id
	 *            the id to set
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return the hostCode
	 */
	public String getHostCode() {
		return hostCode;
	}

	/**
	 * @param hostCode
	 *            the hostCode to set
	 */
	public void setHostCode(String hostCode) {
		this.hostCode = hostCode;
	}

	/**
	 * @return the hostName
	 */
	public String getHostName() {
		return hostName;
	}

	/**
	 * @param hostName
	 *            the hostName to set
	 */
	public void setHostName(String hostName) {
		this.hostName = hostName;
	}

	/**
	 * @return the hostIp
	 */
	public String getHostIp() {
		return hostIp;
	}

	/**
	 * @param hostIp
	 *            the hostIp to set
	 */
	public void setHostIp(String hostIp) {
		this.hostIp = hostIp;
	}

	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}

	/**
	 * @param name
	 *            the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}

	
	/**
	 * @return the value
	 */
	public String getValue() {
		return value;
	}

	/**
	 * @param value the value to set
	 */
	public void setValue(String value) {
		this.value = value;
	}

	/**
	 * @return the groupId
	 */
	public Long getGroupId() {
		return groupId;
	}
	
	/**
	 * @param groupId
	 *            the groupId to set
	 */
	public void setGroupId(Long groupId) {
		this.groupId = groupId;
	}
	
	/**
	 * @return the status
	 */
	public int getStatus() {
		return status;
	}
	
	/**
	 * @param status
	 *            the status to set
	 */
	public void setStatus(int status) {
		this.status = status;
	}
}
