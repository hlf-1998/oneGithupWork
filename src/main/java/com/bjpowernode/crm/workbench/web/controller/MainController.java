package com.bjpowernode.crm.workbench.web.controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/workbench/main")
public class MainController {

    @RequestMapping("/toMain.do")
    public String toMainindex(){

        //此方法只作为跳转使用,显示工作台页面
        return "workbench/main/index";


    }
}
