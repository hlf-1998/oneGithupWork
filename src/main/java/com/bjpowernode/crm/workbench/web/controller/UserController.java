package com.bjpowernode.crm.workbench.web.controller;


import com.bjpowernode.crm.exception.LoginException;
import com.bjpowernode.crm.utils.Constant;
import com.bjpowernode.crm.utils.MD5Util;
import com.bjpowernode.crm.workbench.domain.User;
import com.bjpowernode.crm.workbench.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/workbench/user")
public class UserController {

    @Autowired
    private UserService userService;


    //使用ajax进行数据的表单提交
    @RequestMapping("/ajaxLogin.do")
    @ResponseBody
    public Map<String, Object> ajaxLogin(String loginAct, String loginPwd, String flag, HttpServletRequest request, HttpServletResponse response) throws Exception {

        //对前端返回的数据进行查询的操作,需要将从前端传递回来的数据进行MD5加密操作
        User user = userService.login(loginAct, MD5Util.getMD5(loginPwd));


        //标识，用来返回到后台，让后台进行判断的页面
        Map<String,Object> map = new HashMap<>();


        //对查询的数据进行判断
        //如果返回的数据为空，那么抛出账号和密码错误的异常
        if (user == null){

            //设置一个常量的工具类，为抛出异常时，输入的语句可以直接调用
            throw new LoginException(Constant.LOGIN_FAILURE);

        }
        //查看账号的失效时间,如果时间失效了，也将抛出异常
        //需要先获取到数据库中的时间
        String expireTime = user.getExpireTime();

        /**
         * 此时的时间：new Date()
         * 时间的格式：new SimpleDateFormat("yyyy-MM-dd hh:mm:ss")
         * 将时间转换成String类型：format(new Date()
         */

        if (expireTime.compareTo(new SimpleDateFormat("yyyy-MM-dd hh:mm:ss").format(new Date())) < 0){

            //抛出异常，账号到期了
            throw new LoginException(Constant.LOGIN_EXPIRETIME);

        }

        //判断账号是否是被锁定的状态
        String lockState = user.getLockState();

        //如果值为0，说明账号已经被锁定了
        if ("0".equals(lockState)){

            //如果账号被锁定，那么我将对其进行异常的抛出
            throw new LoginException(Constant.LOGIN_LOCK);

        }
        //获取前端页面的ip地址
        String ip = request.getRemoteAddr();
        //获取数据库中ip账号的地址
        String ips = user.getAllowIps();

        //如果数据库中的值ip地址不同的话，则无法进行访问
        if (!ips.contains(ip)){

            //如果无法访问，则抛出ip地址受限
            throw new LoginException(Constant.LOGIN_IP);

        }

        //如果没有出现以上的情况，那么说明数据是可以进行传递的,
        map.put("success",true);

        //登录成功需要将用户的信息存入到我们的session作用域
        request.getSession().setAttribute("user",user);

        //实现十天免登录操作

        //如果在页面中选择了十天免登录的按钮
        if ("a".equals(flag)){

            //我们就将获取到的账号和密码保存到cookie中
            Cookie loginActCookie = new Cookie("loginAct",loginAct);
            //密码需要进行加密的操作
            Cookie loginPwdCookie = new Cookie("loginPwd",MD5Util.getMD5(loginPwd));

            //设置路径，可以应用于整个浏览器
            loginActCookie.setPath("/");
            loginPwdCookie.setPath("/");

            //设置cookie保存的时间
            loginActCookie.setMaxAge(60*60*24*10);
            loginPwdCookie.setMaxAge(60*60*24*10);

            //将cookie进行保存
            response.addCookie(loginActCookie);
            response.addCookie(loginPwdCookie);

        }

        //将数据向jsp页面进行传递
        return map;

    }

    //登录成功后的页面在此处进行跳转
    @RequestMapping("/loginSuccess.do")
    public String loginSuccess(HttpSession session){

        //需要将session作用域中数据进行获取，然后进行传递
        session.getAttribute("user");

        return "workbench/index";

    }

    //页面跳转,需要在此进行免登录操作
    @RequestMapping("/toLogin.do")
    public String toLogin(HttpServletRequest request){

        //标识
        String loginAct = "";
        String loginPwd = "";

        //进行十天免登录操作，获取cookie
        Cookie[] cookies = request.getCookies();

        if (cookies != null){

            //遍历cookie
            for (Cookie cookie : cookies) {

                //获取账号
                if ("loginAct".equals(cookie.getName())){
                    loginAct = cookie.getValue();
                }
                //获取密码
                if ("loginPwd".equals(cookie.getName())){
                    loginPwd = cookie.getValue();
                }

            }
            //将获取到的账号存入到user中
            User user = userService.login(loginAct,loginPwd);

            //需要将user存入到session作用域中，这样免登录的时候，user就是有对象的，不会被拦截器所拦截
            request.getSession().setAttribute("user",user);

            if (user != null){
                //获取成功之后，对页面直接进行跳转到工作台页面
                return  "workbench/index";
            }

        }



        return "login";
    }

    //点击退出登录之后，需要对cookie和user对象进行销毁的操作
    @RequestMapping("/loginOut.do")
    public String loginOut(HttpServletRequest request,HttpServletResponse response){

        //销毁session中的user
        request.getSession().invalidate();

        //获取到cookie，然后将其进行覆盖
        Cookie[] cookies = request.getCookies();

        if (cookies != null){

            for (Cookie cookie : cookies) {

                //将账号进行覆盖
                if ("loginAct".equals(cookie.getName())){
                    cookie.setValue("");
                    cookie.setPath("/");
                    cookie.setMaxAge(0);
                    response.addCookie(cookie);
                }
                //对密码进行覆盖
                if ("loginPwd".equals(cookie.getName())){
                    cookie.setValue("");
                    cookie.setPath("/");
                    cookie.setMaxAge(0);
                    response.addCookie(cookie);
                }
            }

        }

        return "login";

    }


}






















