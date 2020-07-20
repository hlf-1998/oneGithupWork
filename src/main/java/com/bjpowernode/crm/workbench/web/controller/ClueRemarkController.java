package com.bjpowernode.crm.workbench.web.controller;


import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.HandleFlag;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.domain.ClueRemark;
import com.bjpowernode.crm.workbench.domain.User;
import com.bjpowernode.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Map;


@Controller
@RequestMapping("/workbench/clueRemark")
public class ClueRemarkController {

    @Autowired
    private ClueRemarkService clueRemarkService;

    //对我们存储clue备注信息的数据库，进行数据的增加操作
    @RequestMapping("/saveClueRemark.do")
    @ResponseBody
    public Map<String,Object> saveClueRemark(ClueRemark clueRemark, HttpSession session){
        //这里我们需要将一些信息进行填入
        //补充参数
        clueRemark.setId(UUIDUtil.getUUID());
        clueRemark.setEditFlag("0");//未修改过的标记，已修改过的标记是1
        clueRemark.setCreateTime(DateTimeUtil.getSysTime());//19位
        clueRemark.setCreateBy(((User)session.getAttribute("user")).getName());

        clueRemarkService.saveClueRemark(clueRemark);

        return HandleFlag.successObj("cr",clueRemark);
    }

    //根据我们从前端选择删除的数据id信息，我们在后台对器进行删除操作
    @RequestMapping("/deleteClueRemarkById.do")
    @ResponseBody
    public Map<String,Object> deleteClueRemarkById(String id){

        clueRemarkService.deleteClueRemarkById(id);

        return HandleFlag.successTrue();

    }
}
