package com.bjpowernode.crm.workbench.web.controller;


import com.bjpowernode.crm.utils.HandleFlag;
import com.bjpowernode.crm.workbench.domain.TranHistory;
import com.bjpowernode.crm.workbench.service.TranHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/tranHistory")
public class TranHistoryController {

    @Autowired
    private TranHistoryService tranHistoryService;


    @RequestMapping("/getTranHistoryList.do")
    @ResponseBody
    public Map<String,Object> getTranHistoryListById(String tranId, HttpServletRequest request){

        List<TranHistory> tranHistoryList = tranHistoryService.getTranHistoryListById(tranId);

        //因为阶段历史中的数据需要显示可能性，所以需要从全局作用域中对可能性数据进行获取
        Map<String,String> stringMap = (Map<String, String>) request.getServletContext().getAttribute("sMap");

        //封装阶段的可能性
        for (TranHistory tranHistory : tranHistoryList) {
            //获取传递回来数据的阶段值
            String stage = tranHistory.getStage();
            //根据阶段值获取到可能性，然后为交易历史的可能性进行赋值
            tranHistory.setPossibility(stringMap.get(stage));

        }
        //将获取到的数据进行返回
        return HandleFlag.successObj("thList",tranHistoryList);

    }


}
