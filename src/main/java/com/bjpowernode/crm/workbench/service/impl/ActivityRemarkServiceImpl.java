package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.dao.ActivityRemarkDao;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {

    @Autowired
    private ActivityRemarkDao activityRemarkDao;


    //根据进入页面activity中记录的id，然后查询我们activityRemark表中的数据，获取传递回我们的controller，controller传递回前端，在备注页面进行显示
    @Override
    public List<ActivityRemark> toActivityRemarkControllerList(String activityId) {
        return activityRemarkDao.toActivityRemarkControllerList(activityId);
    }

    @Override
    public void saveActivityRemark(ActivityRemark activityRemark) {
        activityRemarkDao.saveActivityRemark(activityRemark);
    }

    //根据前端需要删除获取的id，向我们的后台进行传递
    @Override
    public void deleteActivityRemarkById(String id) {
        activityRemarkDao.deleteActivityRemarkById(id);
    }


    //对数据库中的数据进行修改的操作
    @Override
    public void updateActivityRemark(ActivityRemark activityRemark) {

        activityRemarkDao.updateActivityRemark(activityRemark);

    }

}
