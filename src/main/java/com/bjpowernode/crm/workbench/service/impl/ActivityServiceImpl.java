package com.bjpowernode.crm.workbench.service.impl;


import com.bjpowernode.crm.workbench.dao.ActivityDao;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityDao activityDao;


    //查询到表中的数据，将其更新到我们的主页面中
    @Override
    public List<Activity> toActivityIndex(Map<String,Object> paramMap) {
        return activityDao.toActivityIndex(paramMap);
    }


    //将获取到的数据向后台传递，完成增加的操作
    @Override
    public void saveActivityAll(Activity activity) {
        activityDao.saveActivityAll(activity);
    }

    @Override
    public Long findActivityCount(Map<String,Object> paramMap) {
        return activityDao.findActivityCount(paramMap);
    }

    @Override
    public void deleteActivityById(String[] activityId) {
        activityDao.deleteActivityById(activityId);
    }

    //通过我们选中的复选框，获取到我们的id值，然后通过id值对我们的数据进行查询的操作
    @Override
    public Activity saveActivityById(String id) {
        return activityDao.saveActivityById(id);
    }

    //将获取到的数据对原本我们的数据进行修改的操作
    @Override
    public void deleteActivity(Activity activity) {

        activityDao.deleteActivity(activity);

    }

    @Override
    public List<Activity> findActivityAll() {
        return activityDao.findActivityAll();
    }

    @Override
    public List<Activity> findActivityAllById(String[] ids) {
        return activityDao.findActivityAllById(ids);
    }

    //将我们从外部导入的数据上传到我们的数据库中
    @Override
    public void saveActivityAllXls(List<Activity> aList) {
        activityDao.saveActivityAllXls(aList);
    }

    @Override
    public Activity toDetail(String id) {
        return activityDao.toDetail(id);
    }


    //根据线索主页面链接的id进行查询到我们市场活动表中的详细信息
    @Override
    public List<Activity> getActivityListById(String clueId) {
        return activityDao.getActivityListById(clueId);
    }


}
