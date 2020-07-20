package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserDao {

    //根据返回的参数，判断是否有权限可以对表进行查询操作
    User login(@Param("loginAct") String loginAct, @Param("loginPwd") String loginPwd);


    //还有另一种查询的方法，参数使用user对象，例如：
    //User login(User user);


    //查询user的数据用于市场活动页面的局部刷新
    List<User> getUserList();


}
