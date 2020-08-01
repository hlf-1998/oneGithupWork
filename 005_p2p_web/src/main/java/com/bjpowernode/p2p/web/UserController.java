package com.bjpowernode.p2p.web;


import com.alibaba.dubbo.config.annotation.Reference;
import com.bjpowernode.p2p.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@RequestMapping("/user")
public class UserController {


    //@Reference：是dubbo的注解，也是注入，它一般注入的是分布式的远程服务对象
    @Reference(interfaceClass = UserService.class,version = "1.0.0",check = false)
    public UserService userService;


}
