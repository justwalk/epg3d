package sitv.epg.entity.content;

import java.util.List;

public class EpgPlayableContent extends EpgProgram  implements Cloneable{
	private String fileName;
	private String format;
	private String birate;
	private boolean hd;
	private String type;
	private String audioType;
	private String programType;
	private String assetId;
	
	private List<EpgContentOffering> epgContentOfferings;
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getFormat() {
		return format;
	}
	public void setFormat(String format) {
		this.format = format;
	}
	public String getBirate() {
		return birate;
	}
	public void setBirate(String birate) {
		this.birate = birate;
	}
	public boolean isHd() {
		return hd;
	}
	public void setHd(boolean hd) {
		this.hd = hd;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getAudioType() {
		return audioType;
	}
	public void setAudioType(String audioType) {
		this.audioType = audioType;
	}
	public String getProgramType() {
		return programType;
	}
	public void setProgramType(String programType) {
		this.programType = programType;
	}
	public List<EpgContentOffering> getEpgContentOfferings() {
		return epgContentOfferings;
	}
	public void setEpgContentOfferings(List<EpgContentOffering> epgContentOfferings) {
		this.epgContentOfferings = epgContentOfferings;
	}
	
	
	public EpgContentOffering existService(String serviceType){		
		EpgContentOffering eco;
		for(int i=0;epgContentOfferings != null&&i<epgContentOfferings.size();i++){
			eco = epgContentOfferings.get(i);
			if (serviceType.equals(eco.getServiceType())){
				return eco;
			}
		}
		return null;
	}
	
	public EpgContentOffering existServices(String serviceTypes){
		String[] scs = serviceTypes.split(",");
		EpgContentOffering eco;
		for(int i=0;i<scs.length;i++){
			eco = existService(scs[i]);
			if(eco != null) return eco;
		}
		return null;
	}
	
	public EpgContentOffering getOfferingByService(String serviceType){
		EpgContentOffering eco;
		for(int i=0;epgContentOfferings != null&&i<epgContentOfferings.size();i++){
			eco = epgContentOfferings.get(i);
			if (serviceType.equals(eco.getServiceType())){
				return eco;
			}
		}
		return null;
	}
	
	public EpgContentOffering getOfferingByOfferingId(String offeringId){
		EpgContentOffering eco;
		for(int i=0;epgContentOfferings != null&&i<epgContentOfferings.size();i++){
			eco = epgContentOfferings.get(i);
			if (offeringId.equals(eco.getOfferingId())){
				return eco;
			}
		}
		return null;
	} 
	
	public EpgPlayableContent copy(EpgContentOffering eco){
		EpgPlayableContent epc = null;
		try {
			epc = (EpgPlayableContent) this.clone();
			epc.setServiceCode(eco.getServiceCode());
			epc.setServiceName(eco.getServiceName());
			epc.setServiceType(eco.getServiceType());
			epc.setOfferingId(eco.getOfferingId());			
			return epc;
		} catch (CloneNotSupportedException e) {
			e.printStackTrace();
		}
		return epc;
	}
	public String getAssetId() {
    	return assetId;
    }
	public void setAssetId(String assetId) {
    	this.assetId = assetId;
    }
}
