package com.bjpowernode.crm.workbench.web.controller;


import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.HandleFlag;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.*;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping("/workbench/clue")
public class ClueController {

    @Autowired
    private ClueService clueService;

    @Autowired
    private UserService userService;

    @Autowired
    private ClueRemarkService clueRemarkService;

    @Autowired
    private ActivityService activityService;


    //此方法只作为将前端发送的请求跳转的使用，
    @RequestMapping("/toClueIndex.do")
    public String toClueIndex(){

        return "/workbench/clue/index";
    }


    //根据分页进行查询数据的方法
    @RequestMapping("/getPageList.do")
    @ResponseBody
    public Map<String,Object> getPageList(@RequestParam Map<String,Object> paramMap){

        //标识
        Map<String,Object> map = new HashMap<>();

        //在查询分页的时候，我们需要将前端我们输入的分页参数转换成int或者integer
        String p1 = (String) paramMap.get("pageIndex");
        String p2 = (String) paramMap.get("pageSize");

        Integer pageIndex = Integer.valueOf(p1);
        Integer pageSize = Integer.valueOf(p2);

        //将数据再导入回去
        paramMap.put("pageIndex",pageIndex);
        paramMap.put("pageSize",pageSize);

        //对我们的数据进行分页查询
        List<Clue> cList = clueService.getPageList(paramMap);
        map.put("cList",cList);

        //我们在进行分页查询的时候，需要传递我们的页面中的用户的信息，我们在页面中只能查询出我们当前登录用户的客户线索信息
        Long count = clueService.findClueAllCount(paramMap);
        map.put("total",count);

        Map<String,Object> flagMap = HandleFlag.successTrue();
        flagMap.putAll(map);

        return flagMap;

    }

    //我们对数据进行查询，然后返回我们查询到所有者的结果到我们的后台进行显示
    @RequestMapping("/getUserList.do")
    @ResponseBody
    public Map<String,Object> getUserList(){

        //使用我们之前查询user表的方法，然后查询我们所有者的对象
        List<User> userList = userService.getUserList();

        return HandleFlag.successObj("uList",userList);

    }

    //获取在前端创建中的数据，然后我们将数据进行返回到我们的后台，在后台进行我们的增加操作
    @RequestMapping("/saveClue.do")
    @ResponseBody
    public Map<String,Object> saveClue(Clue clue, HttpSession session){
        //我们的标识，还有创建这个数据的用户和创建这个数据的时间进行赋值操作
        clue.setId(UUIDUtil.getUUID());
        clue.setCreateTime(DateTimeUtil.getSysTime());//19位
        clue.setCreateBy(((User)session.getAttribute("user")).getName());

        clueService.saveClue(clue);
        return HandleFlag.successTrue();
    }

    //删除我们前端页面的数据
    @RequestMapping("/deleteClueById.do")
    @ResponseBody
    public Map<String,Object> deleteClueById(String[] clueId){
        clueService.deleteClueById(clueId);
        return HandleFlag.successTrue();
    }


    //从线索主页面跳转到名称链接中
    @RequestMapping("/toClueDetail.do")
    @ResponseBody
    public ModelAndView toClueDetail(String id){


        ModelAndView mv = new ModelAndView();
        Clue clue = clueService.findById(id);
        mv.addObject("c",clue);
        mv.setViewName("/workbench/clue/detail");
        return mv;
    }


    //根据id，查询我们需要获取市场活动列表信息与备注列表信息
    @RequestMapping("/getActivityListAndClueRemarkList.do")
    @ResponseBody
    public Map<String,Object> getActivityListAndClueRemarkList(String clueId){

        //定义返回的结果集
        Map<String,Object> resultMap = new HashMap<>();

        //查询线索信息备注列表
        List<ClueRemark> clueRemarkList = clueRemarkService.getClueRemarkListById(clueId);

        //查询已经关联的市场活动列表
        List<Activity> activityList = activityService.getActivityListById(clueId);
        resultMap.put("aList",activityList);


        resultMap.put("success",true);
        resultMap.put("crList",clueRemarkList);

        return resultMap;

    }

    //根据我们从前端线索首页点击的链接获取的id，查询我们未关联市场活动列表
    @RequestMapping("/getUnActivityListById.do")
    @ResponseBody
    public Map<String,Object> getUnActivityListById(@RequestParam Map<String,Object> paramMap){

        List<Activity> activityList = clueService.getUnActivityListById(paramMap);
        return HandleFlag.successObj("actList",activityList);
    }


    //将模态窗口中未关联的数据进行我们的关联操作
    @RequestMapping("/addRelation.do")
    @ResponseBody
    public Map<String,Object> addRelation(String clueId,@RequestParam String[] ids){
        clueService.addRelation(clueId,ids);
        return HandleFlag.successTrue();
    }


    //根据我们解除关联中保存的id，对我们的市场关联进行解除操作
    @RequestMapping("/removeRelation.do")
    @ResponseBody
    public Map<String,Object> removeRelation(String relationId){

        clueService.deleteRelationId(relationId);
        return HandleFlag.successTrue();
    }


    //将线索页面中的数据进行传递和跳转到我们的转换页面
    @RequestMapping("/toClueConvert.do")
    @ResponseBody
    public ModelAndView toClueConvert(Clue clue){

        ModelAndView mv = new ModelAndView();

        mv.addObject("clue",clue);
        mv.setViewName("workbench/clue/convert");

        return mv;
    }


    //我们根据线索id发送请求，查询我们已经关联到市场活动的列表信息
    @RequestMapping("/getRelationActivityList.do")
    @ResponseBody
    public Map<String,Object> getRelationActivityList(String clueId){
        List<Activity> activityList = clueService.getRelationActivityList(clueId);
        return HandleFlag.successObj("aList",activityList);
    }


    //我们根据我们输入的名称进行模糊查询
    @RequestMapping("/getRelationActivityListLike.do")
    @ResponseBody
    public Map<String,Object> getRelationActivityListLike(@RequestParam Map<String,String> mapParam){
        List<Activity> activityList = clueService.getRelationActivityListLike(mapParam);
        return HandleFlag.successObj("aList",activityList);
    }


    //在我们的前端页面我们点击了转换按钮之后，我们需要将我们的数据进行我们的提交操作
    @RequestMapping("/exchangeClueForm.do")
    public String exchangeClue(@RequestParam Map<String,String> param,HttpSession session){
        //在我们进行转换的时候，我们需要为一些数据进行参数的赋值操作
        //Map<String,String> paramMap = new HashMap<>();
        param.put("createTime",DateTimeUtil.getSysTime());//19位
        param.put("createBy",(((User)session.getAttribute("user")).getName()));

        clueService.exchangeClue(param);

        //转换完成之后，我们需要将页面进行跳转回我们的首页
        return "redirect:/workbench/clue/toClueIndex.do";

    }

}




















