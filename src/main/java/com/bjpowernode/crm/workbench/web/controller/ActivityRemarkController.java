package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.HandleFlag;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.domain.User;
import com.bjpowernode.crm.workbench.service.ActivityRemarkService;
import org.apache.poi.ss.usermodel.DateUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/activityRemark")
public class ActivityRemarkController {

    @Autowired
    private ActivityRemarkService activityRemarkService;

    //根据我们activity中id，查询activityRemark中数据，然后将数据进行返回
    @RequestMapping("/toActivityRemarkControllerList.do")
    @ResponseBody
    public Map<String,Object> toActivityRemarkControllerList(String activityId){

        List<ActivityRemark> remarkList = activityRemarkService.toActivityRemarkControllerList(activityId);

        return HandleFlag.successObj("arList",remarkList);
    }


    //对备注进行新增的操作
    @RequestMapping("/saveActivityRemark.do")
    @ResponseBody
    public Map<String,Object> saveActivityRemark(ActivityRemark activityRemark, HttpSession session){
        //补充参数
        activityRemark.setId(UUIDUtil.getUUID());
        //对数据的标记进行设置，0为未修改，1为已修改
        activityRemark.setEditFlag("0");
        //设置创建人，通过我们session进行赋值
        activityRemark.setCreateBy(((User)session.getAttribute("user")).getName());
        //设置创建的时间，19位
        activityRemark.setCreateTime(DateTimeUtil.getSysTime());

        activityRemarkService.saveActivityRemark(activityRemark);
        return HandleFlag.successObj("ar",activityRemark);
    }


    //对数据库中的数据进行删除操作
    //因为我们前端页面的删除按钮出现在对应的需要删除数据的后面，所有我们可以直接在前端页面中获取对应的id，
    // 然后我们点击删除按钮之后，我们的前端页面就知道我们点击了删除数据的id是什么，然后我们就可以传递这个id
    @RequestMapping("/deleteActivityRemarkById.do")
    @ResponseBody
    public Map<String,Object> deleteActivityRemarkById(String id){

        activityRemarkService.deleteActivityRemarkById(id);

        return HandleFlag.successTrue();
    }

    /**
     * 对数据库中备注的信息进行修改的操作
     */

    @RequestMapping("/updateActivityRemark.do")
    @ResponseBody
    public Map<String,Object> updateActivityRemark(ActivityRemark activityRemark,HttpSession session){
        //设置修改时间
        activityRemark.setEditTime(DateTimeUtil.getSysTime());
        //设置修改人
        activityRemark.setEditBy(((User)session.getAttribute("user")).getName());
        //设置修改的标识，0表示为修改，1表示已修改
        activityRemark.setEditFlag("1");

        activityRemarkService.updateActivityRemark(activityRemark);

        return HandleFlag.successObj("ar",activityRemark);
    }

}
