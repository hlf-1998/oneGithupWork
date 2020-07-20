package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.User;

import java.util.List;

public interface UserService {

    //查询输入的用户账号和密码是否能够查询到
    User login(String loginAct, String loginPwd);

    List<User> getUserList();


}
