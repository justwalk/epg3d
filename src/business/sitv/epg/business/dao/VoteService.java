package sitv.epg.business.dao;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import sitv.epg.zhangjiagang.EpgUserSession;
import sitv.epg.config.EpgConfigUtils;
import sitv.epg.entity.user.EpgContentVote;
import sitv.epg.entity.user.EpgVoteNum;
import chances.epg.exception.DaoException;
import chances.epg.ibtais.BaseDaoiBatis;

/**
 * 投票打分服务
 * @author chenjie
 *
 */
@Repository
public class VoteService extends EpgBaseDao {
	@Autowired
    protected BaseDaoiBatis masterDao;
	
	private  static final int defaultNum = 10;
	
	public boolean limitVote(HttpServletRequest request,String contentType,String contentCode,String voteMethod) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		EpgUserSession eus = EpgUserSession.findUserSession(request);
		Calendar today = Calendar.getInstance();
		String beginTime = new SimpleDateFormat("yyyy-MM-dd 00:00:00").format(today.getTime());
		String endTime = new SimpleDateFormat("yyyy-MM-dd 23:59:59").format(today.getTime());
		
		paramMap.put("USER_MAC", eus.getUserAccount());
		paramMap.put("VOTE_METHOD",voteMethod);
		paramMap.put("BEGIN_TIME",beginTime);
		paramMap.put("END_TIME",endTime);
		
		try {
			EpgVoteNum en = (EpgVoteNum)baseDao
					.getSqlMapClientTemplate().queryForObject(
							"getVoteNum", paramMap);
			int num = EpgConfigUtils.getInstance().getIntValue(EpgConfigUtils.MYVOTE_LIMITSIZE_NUM, defaultNum);
			if (en.getNum()>=num)
				return false;
			return true;
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced whether limit;vote method:"
								+ voteMethod+";USER_ACCOUNT:"
								+ eus.getUserAccount()+";content type:"
								+ contentType+";content code:"
								+ contentCode, dae);
		}finally{
			paramMap.clear();
			paramMap = null;
		}
	}
	
	
	public EpgContentVote vote(HttpServletRequest request,String contentType,String contentCode,String voteMethod) {
		
		EpgUserSession eus = EpgUserSession.findUserSession(request);
		Map<String, Object> voteMap = new HashMap<String, Object>();
		voteMap.put("CONTENT_TYPE", contentType);
		voteMap.put("CONTENT_CODE", contentCode);
		
		Map<String, Object> recordMap = new HashMap<String, Object>();
		recordMap.put("USER_MAC",eus.getUserAccount());
		recordMap.put("CONTENT_TYPE",contentType);
		recordMap.put("CONTENT_CODE",contentCode);
		recordMap.put("VOTE_METHOD",voteMethod);
		recordMap.put("VOTE_VAL",1);
		recordMap.put("VOTE_TIME",new Date());
		
		try {
			masterDao.getSqlMapClientTemplate().insert(
				"addVoteRecord", recordMap);
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced when vote EpgVoteRecord; macAddress:"
					+ eus.getUserAccount()+";vote method:"
					+ voteMethod+";content type:"
					+ contentType+";content code:"
					+ contentCode, dae);
		}finally{
			recordMap.clear();
			recordMap = null;
		}
		
		try {
			if(existContentVote(contentType,contentCode)) {
				if("good".equals(voteMethod)) {
					masterDao.getSqlMapClientTemplate().update(
							"updateContentVoteGood", voteMap);
				}else if("bad".equals(voteMethod)) {
					masterDao.getSqlMapClientTemplate().update(
							"updateContentVoteBad", voteMap);
				}
			}else{
				if("good".equals(voteMethod)) {
					masterDao.getSqlMapClientTemplate().insert(
							"addContentVoteGood", voteMap);
				}else if("bad".equals(voteMethod)) {
					masterDao.getSqlMapClientTemplate().insert(
							"addContentVoteBad", voteMap);
				}
			}
			
			EpgContentVote epgContentVote = (EpgContentVote) baseDao.getSqlMapClientTemplate().queryForObject("getEpgContentVote", voteMap);
			return epgContentVote;
			
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced when vote EpgContentVote; vote method:"
					+ voteMethod+";content type:"
					+ contentType+";content code:"
					+ contentCode, dae);
		}finally{
			voteMap.clear();
			voteMap = null;
		}
						
	}
	
	
	public boolean existContentVote(String contentType,String contentCode) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("CONTENT_TYPE", contentType);
		paramMap.put("CONTENT_CODE", contentCode);
		
		try {
			EpgContentVote ecv = (EpgContentVote) baseDao
					.getSqlMapClientTemplate().queryForObject(
							"contentHasVote", paramMap);
			if (ecv == null)
				return false;
			return true;
		} catch (DataAccessException dae) {
			throw new DaoException(
					"An exception produced when search existContentVote; content type:"
					+ contentType+";content code:"
					+ contentCode, dae);
		}finally{
			paramMap.clear();
			paramMap = null;
		}
		
	}
	

}
