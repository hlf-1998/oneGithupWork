package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {
    List<ActivityRemark> toActivityRemarkControllerList(String activityId);

    void saveActivityRemark(ActivityRemark activityRemark);

    void deleteActivityRemarkById(String id);

    void updateActivityRemark(ActivityRemark activityRemark);


}
