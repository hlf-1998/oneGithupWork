package com.bjpowernode.crm.settrings.web.controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/settrings")
public class SettringsController {
    /**
     * 将页面中系统设置页面进行跳转
     * @return
     */
    @RequestMapping("/settringsIndex.do")
    public String settingsIndex(){

        return "settrings/index";
    }

}
