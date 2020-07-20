package com.bjpowernode.crm.workbench.service.impl;


import com.bjpowernode.crm.workbench.dao.UserDao;
import com.bjpowernode.crm.workbench.domain.User;
import com.bjpowernode.crm.workbench.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    //给引用数据类型赋值
    @Autowired
    private UserDao userDao;

    @Override
    public User login(String loginAct, String loginPwd) {

        //使用dao层中的方法作为查询的结果进行返回
        return userDao.login(loginAct,loginPwd);
    }


    //查询user表中的id和name用于页面的局部刷新
    @Override
    public List<User> getUserList() {
        return userDao.getUserList();
    }



}
