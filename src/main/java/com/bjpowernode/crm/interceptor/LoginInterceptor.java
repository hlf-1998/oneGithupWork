package com.bjpowernode.crm.interceptor;

import com.bjpowernode.crm.exception.InterceptorException;
import com.bjpowernode.crm.workbench.domain.User;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


//登录的拦截器，验证当前操作者是否有权限操作
public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        //在拦截器执行时，需要对一些url进行放行，登录页面的请求是需要放行的

        //1、判断当前用户是否有权限操作
        //2、登录了就可以操作，未登录就无法操作，需要重新跳转到登录的页面
        User user = (User) request.getSession().getAttribute("user");

        //判断是否已经有用户的信息，是否已经登录了
        if (user == null){
            //如果接收的到为空，那么就需要将将页面进行跳转
            throw new InterceptorException();
        }
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request,
                           HttpServletResponse response,
                           Object handler,
                           ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest request,
                                HttpServletResponse response,
                                Object handler,
                                Exception ex) throws Exception {

    }
}
