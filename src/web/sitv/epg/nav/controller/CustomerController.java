/*
 * Created on 2012-9-4
 * 版权所有 上海成思信息科技有限公司
 *
 * $HeadURL$:
 */
package sitv.epg.nav.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import chances.epg.web.UserSession;

import sitv.epg.business.dao.CustomerService;
import sitv.epg.entity.customer.EpgCustomer;
import sitv.epg.zhangjiagang.EpgUserSession;

/**
 * Class comments.
 * 
 * @author <a href="mailto:shenwl@chances.com.cn">shenwl</a>
 * @version 1.0
 */
@Controller
@RequestMapping("/customer")
public class CustomerController {

    @Autowired
    @Qualifier("customerService")
    private CustomerService customerService;

    @RequestMapping(value = "/addCustomer", method = RequestMethod.GET)
    public String addCustomer(@ModelAttribute("epgCustomer")
    EpgCustomer epgCustomer, HttpServletRequest httpServletRequest,
            HttpSession httpSession, @RequestParam("homeUrl")
            String homeUrl) {
        // 数据修改或保存
        customerService.saveOrupdate(epgCustomer,
                ((EpgUserSession) httpServletRequest.getSession().getAttribute(
                        UserSession.USER_SESSION_NAME)).getUserAccount());

        // 配置返回路径
        String homeUrlRe = homeUrl.substring(1, homeUrl.length());
        homeUrlRe = homeUrlRe.substring(homeUrlRe.indexOf("/"), homeUrlRe
                .length());

        return "redirect:" + homeUrlRe;

    }

    public CustomerService getCustomerService() {
        return customerService;
    }

    public void setCustomerService(CustomerService customerService) {
        this.customerService = customerService;
    }
}
