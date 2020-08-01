package com.bjpowernode.p2p.service.impl;

import com.alibaba.dubbo.config.annotation.Service;
import com.bjpowernode.p2p.mapper.UserMapper;

import com.bjpowernode.p2p.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;




@Service(interfaceClass = UserService.class,version = "1.0.0",timeout = 5000)
//相当于配置文件中的bean，当文件不好归类时，可以使用
@Component
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;



}
