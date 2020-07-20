package com.bjpowernode.crm.workbench.web.controller;


import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.HandleFlag;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Contacts;
import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.domain.User;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.ContactsService;
import com.bjpowernode.crm.workbench.service.TransactionService;
import com.bjpowernode.crm.workbench.service.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/transaction")
public class TransactionController {

    @Autowired
    private UserService userService;

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ContactsService contactsService;


    //前端跳转页面到交易首页
    @RequestMapping("/toTransaction.do")
    public String toTransaction(){

        return "/workbench/transaction/index";
    }

    //在交易首页点击创建按钮，页面跳转到我们的创建页面
    @RequestMapping("/toSaveTransaction.do")
    public ModelAndView toSaveTransaction(){
        ModelAndView mv = new ModelAndView();
        mv.setViewName("/workbench/transaction/save");

        //将我们的所有者进行获取，封装到我们下拉列表中
        List<User> userList = userService.getUserList();
        mv.addObject("uList",userList);
        return mv;
    }

    /**
     * 数据自动补全发送的请求：
     * 要求我们参数必须是name，返回值必须是List<String>
     *
     */
    @RequestMapping("/getCustomerName.do")
    @ResponseBody
    public List<String> getCustomerName(String name){

        List<String> stringList = transactionService.getCustomerName(name);

        return stringList;
    }

    //获取我们市场活动源的信息
    @RequestMapping("/getActivityList.do")
    @ResponseBody
    public Map<String,Object> getActivityList(){
        List<Activity> activityList = activityService.findActivityAll();
        return HandleFlag.successObj("aList",activityList);
    }


    //获取联系人的名称信息
    @RequestMapping("/getContactsList.do")
    @ResponseBody
    public Map<String,Object> getContactsList(){

        List<Contacts> contactsList = contactsService.findAll();

        return HandleFlag.successObj("cList",contactsList);

    }

    //将我们表单中的数据进行提交的操作,我们数据提交成功之后，我们将重定向回我们主页面
    @RequestMapping("/saveTran.do")
    public String saveTran(@RequestParam Map<String,String> paramMap, HttpSession session){
        //我们对数据请求参数进行赋值
        paramMap.put("id", UUIDUtil.getUUID());
        paramMap.put("createBy",((User)session.getAttribute("user")).getName());
        paramMap.put("createTime", DateTimeUtil.getSysTime());

        //新增交易和历史记录
        transactionService.saveTran(paramMap);

        //重定向回到我们的页面
        return "";
    }

    //点击页面中的名称链接，跳转到下一个页面，并且将需要的信息进行传递
    @RequestMapping("/toDetail.do")
    /**
     * 我们这里需要将我们交易表中的信息进行传递，还需要将保存在服务器缓存中的数据传递到页面中，
     * 因为我们的阶段和可能性保存在了我们ServletContext作用域中，我们可以直接进行获取到，然后再传递
     * 到进度页面中进行显示的操作
     */
    public ModelAndView toTranDetail(String id, HttpServletRequest request){

        //首先需要创建标识
        ModelAndView mv = new ModelAndView();

        //获取缓存中的阶段和可能性对应的集合数据
        Map<String,String> stringMap = (Map<String, String>) request.getServletContext().getAttribute("sMap");

        //根据id去数据库中查询交易表中的信息
        Tran tran = transactionService.findById(id);

        //获取到当前的阶段
        String stage = tran.getStage();

        //去集合中查询对应的可能性
        String possibility = stringMap.get(stage);

        //将可能性封装到tran对象中
        tran.setPossibility(possibility);


        mv.setViewName("/workbench/transaction/detail");
        mv.addObject("t",tran);

        return mv;
    }


}
