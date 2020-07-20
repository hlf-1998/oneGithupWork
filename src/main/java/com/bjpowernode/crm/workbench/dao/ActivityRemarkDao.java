package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {

    List<ActivityRemark> toActivityRemarkControllerList(String activityId);

    void saveActivityRemark(ActivityRemark activityRemark);

    void deleteActivityRemarkById(String id);

    void updateActivityRemark(ActivityRemark activityRemark);
}
