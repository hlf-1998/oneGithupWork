package com.bjpowernode.crm.listener;

import com.bjpowernode.crm.settrings.domain.DisType;
import com.bjpowernode.crm.settrings.domain.DisValue;
import com.bjpowernode.crm.settrings.service.DisTypeService;
import com.bjpowernode.crm.settrings.service.DisValueService;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;


public class SysLoadListener implements ServletContextListener {

    //我们将数据放入到服务器中，进行缓存的操作
    @Override
    public void contextInitialized(ServletContextEvent sce) {

        System.out.println("============执行缓存开始！！！！！！！！！！！");

        //创建spring容器
        ApplicationContext act = new ClassPathXmlApplicationContext("classpath:spring/applicationContext.xml");

        //获取容器中的对象，DicTypeService
        DisTypeService disTypeService = act.getBean(DisTypeService.class);
        //获取容器中的对象，DisValueService
        DisValueService disValueService = act.getBean(DisValueService.class);

        //对数据库进行查询的操作
        List<DisType> disTypeList = disTypeService.toDictionaryType();

        //遍历我们tbl_dis_type表中的数据
        for (DisType disType : disTypeList) {


            //获取数据字典类型和对应数据字典值的集合
            List<DisValue> disValueList = disValueService.findDisValueByCode(disType.getCode());

           /* System.out.println("=====================key"+disType.getCode());
            System.out.println("=====================value"+disValueList);*/

           //将我们的数据保存到我们最大的作用域中
            sce.getServletContext().setAttribute(disType.getCode()+"List",disValueList);
            
        }

        System.out.println("=========================数据保存成功==============================");


        //加载属性文件，指定属性文件的名称，去掉后缀名
        Map<String,String> sMap = new HashMap<>();

        ResourceBundle bundle = ResourceBundle.getBundle("properties/stage");

        Enumeration<String> keys = bundle.getKeys();

        while (keys.hasMoreElements()){
            String key = keys.nextElement();
            String value = (String) bundle.getObject(key);
            sMap.put(key,value);
        }

        //将阶段和对应的可能性集合存入到服务器缓存中
        sce.getServletContext().setAttribute("sMap",sMap);

    }
}
