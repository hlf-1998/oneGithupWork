package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    List<Activity> toActivityIndex(Map<String,Object> paramMap);

    void saveActivityAll(Activity activity);

    Long findActivityCount(Map<String,Object> paramMap);

    void deleteActivityById(String[] activityId);

    Activity saveActivityById(String id);

    void deleteActivity(Activity activity);

    List<Activity> findActivityAll();

    List<Activity> findActivityAllById(String[] ids);

    void saveActivityAllXls(List<Activity> aList);

    Activity toDetail(String id);

    List<Activity> getActivityListById(String clueId);


}
