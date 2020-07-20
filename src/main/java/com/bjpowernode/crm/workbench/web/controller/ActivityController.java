package com.bjpowernode.crm.workbench.web.controller;


import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.HandleFlag;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.User;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.UserService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.CellType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbeach/activity")
public class ActivityController {

    @Autowired
    private ActivityService activityService;

    @Autowired
    private UserService userService;


    //市场活动的主页面，并且需要将表中查询到数据更新到页面中
    @RequestMapping("/toActivityIndex.do")
    public String toActivityIndex() {

        /**
         * 以下方法是我们没有使用分页进行查询时候的方法，需要将获取到的数据进行传递到我们需要的页面
         * 现在我们需要实现分页的功能，那么我们现在此页面的作用就是在我们点击市场活动之后进行跳转的功能
         * 具体的数据返回，会在其他的方法中进行返回的操作
         */

        /*ModelAndView mv = new ModelAndView();
        List<Activity> ayList = activityService.toActivityIndex();

        mv.addObject("ayList",ayList);
        mv.setViewName("/workbench/activity/index");*/

        return "/workbench/activity/index";

    }


    //我们需要获取到用户的name来作为我们下拉列表中的值，获取用户id来作为我们的唯一标识，用于我们的value值
    @RequestMapping("/getUserList.do")
    @ResponseBody
    public Map<String, Object> getUserList() {

        Map<String, Object> map = new HashMap<>();

        List<User> userList = userService.getUserList();


        if (userList == null) {
            map.put("success", false);
            map.put("msg", "未查询到您所需要的结果");
        } else {
            map.put("success", true);
            map.put("uList", userList);
        }

        return map;

    }

    //将数据进行提交，进行增加的操作
    @RequestMapping("/saveActivityAll.do")
    @ResponseBody
    public Map<String, Object> saveActivityAll(Activity activity, HttpSession session) {
        //获取到id作为我们的唯一标识
        String id = UUIDUtil.getUUID();
        //通过session作用域获取到user的值,给创建者赋值
        String name = ((User) session.getAttribute("user")).getName();
        //使用工具类获取当前为19位的时间，
        String time = DateTimeUtil.getSysTime();

        //为我们的activity进行赋值操作
        activity.setId(id);
        activity.setCreateBy(name);
        activity.setCreateTime(time);


        //把我们的前端获取的值和我们在这里获取的值向后端进行传递，完成最后的赋值和添加操作
        activityService.saveActivityAll(activity);

        return HandleFlag.successTrue();
    }

    //登陆后对数据进行查询操作，实现分页的功能
    @RequestMapping("/getPageList.do")
    @ResponseBody
    //在此处使用@RequestParam的方式，我们是将前台传递过来的参数进行封装，后台无需在使用实体类进行封装
    public Map<String, Object> getPageList(@RequestParam Map<String, Object> paramMap) {

        //标识
        Map<String, Object> map = new HashMap<>();

        //在进行查询的时候，我们需要将我们的分页参数转换成int或者integer，不然会执行sql报错
        //如果没有进行转换会在sql语句执行的时候照成语句拼接错误
        String p1 = (String) paramMap.get("pageNo");
        String p2 = (String) paramMap.get("pageSize");

        Integer pageNo = Integer.valueOf(p1);
        Integer pageSize = Integer.valueOf(p2);
        //将我们转换类型后的每页页码和每页总条数赋值回我们的map集合中
        paramMap.put("pageNo", pageNo);
        paramMap.put("pageSize", pageSize);

        List<Activity> aList = activityService.toActivityIndex(paramMap);

        map.put("aList", aList);

        Map<String, Object> mapAll = HandleFlag.successTrue();

        //获取我们登录用户的总记录数，根据我们登录用户的id值，
        String userId = (String) paramMap.get("userId");
        Long count = activityService.findActivityCount(paramMap);

        System.out.println(count);

        map.put("total", count);

        //使用map.putAll()的方法,将所有的map数据添加到我们的集合中
        mapAll.putAll(map);


        return mapAll;


    }

    /**
     * 根据复选框的id删除数据
     * 删除有两种方式：
     * 1、物理删除：使用delete从数据库中对数据进行删除的操作
     * 2、逻辑删除：设置某一个字段，以该字段作为查询的条件，不是真正意义上的删除，而是通过字段的方式，让我们无法进行查询，但是并为删除其数据
     *
     * @param activityId
     * @return
     */
    @RequestMapping("/deleteActivityById.do")
    @ResponseBody
    public Map<String, Object> deleteActivityById(String[] activityId) {
        //标识
        Map<String, Object> map = new HashMap<>();

        activityService.deleteActivityById(activityId);
        return HandleFlag.successTrue();
    }

    /**
     * 通过复选框选中的数据在前台得到复选框选中数据的id，然后我们通过id进行数据的查询
     */
    @RequestMapping("/saveActivityById.do")
    @ResponseBody
    public Map<String, Object> saveActivityById(String id) {
        Activity activity = activityService.saveActivityById(id);

        return HandleFlag.successObj("aty", activity);
    }


    /**
     * 获取到我们修改的后的数据，传递回后台进行修改的操作
     */
    @RequestMapping("/deleteActivity.do")
    @ResponseBody
    public Map<String, Object> deleteActivity(Activity activity, HttpSession session) {
        //给修改人和修改时间进行赋值操作
        activity.setEditTime(DateTimeUtil.getSysTime());
        activity.setEditBy(((User) session.getAttribute("user")).getName());
        activityService.deleteActivity(activity);

        return HandleFlag.successTrue();
    }

    /**
     * 我们应该封装一个批量导出/选择导出的下载方法
     *
     * @param aList :需要导出的数据
     * @Param response :打开下载框，设置下载文件的名称
     */
    public void doLoadExcel(List<Activity> aList, HttpServletResponse response) throws Exception {
        //我们需要封装POI对象，封装，写入到Excel方法中
        //1、创建工作簿对象
        HSSFWorkbook workbook = new HSSFWorkbook();
        //2、创建页码对象
        HSSFSheet sheet = workbook.createSheet();
        //3、创建行对象，写入表头数据
        HSSFRow row1 = sheet.createRow(0);

        row1.createCell(0).setCellValue("id");
        row1.createCell(1).setCellValue("owner");
        row1.createCell(2).setCellValue("name");
        row1.createCell(3).setCellValue("startDate");
        row1.createCell(4).setCellValue("endDate");
        row1.createCell(5).setCellValue("cost");
        row1.createCell(6).setCellValue("description");
        row1.createCell(7).setCellValue("createTime");
        row1.createCell(8).setCellValue("createBy");
        row1.createCell(9).setCellValue("editTime");
        row1.createCell(10).setCellValue("editBy");

        //4、通过循环遍历，填充数据

        //4.1遍历填充行数据
        for (int i = 1; i < aList.size(); i++) {
            //表头数据已经进行了填充，我们就从我们第二行开始对数据进行数据的填充
            //创建行对象
            HSSFRow row = sheet.createRow(i);
            //获取我们导入的数据
            Activity activity = aList.get(i - 1);

            //对单元格的数据进行填充操作
            for (int j = 0; j < 11; j++) {
                if (j == 0) {
                    row.createCell(0).setCellValue(activity.getId());
                } else if (j == 1) {
                    row.createCell(1).setCellValue(activity.getOwner());
                } else if (j == 2) {
                    row.createCell(2).setCellValue(activity.getName());
                } else if (j == 3) {
                    row.createCell(3).setCellValue(activity.getStartDate());
                } else if (j == 4) {
                    row.createCell(4).setCellValue(activity.getEndDate());
                } else if (j == 5) {
                    row.createCell(5).setCellValue(activity.getCost());
                } else if (j == 6) {
                    row.createCell(6).setCellValue(activity.getDescription());
                } else if (j == 7) {
                    row.createCell(7).setCellValue(activity.getCreateTime());
                } else if (j == 8) {
                    row.createCell(8).setCellValue(activity.getCreateBy());
                } else if (j == 9) {
                    row.createCell(9).setCellValue(activity.getEditTime());
                } else if (j == 10) {
                    row.createCell(10).setCellValue(activity.getEditBy());
                }
            }

        }
        //5、输出，为用户浏览器提供下载框
        response.setContentType("octets/stream");
        response.setHeader("Content-Disposition", "attachment;filename=Activity-" + DateTimeUtil.getSysTimeForUpload() + ".xls");

        //将我们的数据写入到Excel中
        OutputStream out = response.getOutputStream();

        workbook.write(out);

    }


    //将所有的数据进行批量导出到excel中
    @RequestMapping("/exportActivityAll.do")
    public void exportActivityAll(HttpServletResponse response) throws Exception {

        //将activity表中所有的数据查询出来
        List<Activity> activities = activityService.findActivityAll();

        //在这里调用我们下载的方法，将数据库中的数据，全部进行下载
        doLoadExcel(activities, response);
    }


    //根据选中的市场活动id，选择导出我们的数据到excel中
    @RequestMapping("/exportActivityXzBtn.do")
    public void exportActivityXzBtn(String[] ids, HttpServletResponse response) throws Exception {
        List<Activity> activities = activityService.findActivityAllById(ids);

        //调用我们的下载方法，下载我们选中的数据
        doLoadExcel(activities, response);
    }


    //将我们获取到表格的数据向数据库进行传输的方法
    @RequestMapping("/importActivity.do")
    @ResponseBody
    //这里我们需要在我们的控制器上添加MultipartFile参数
    public Map<String, Object> importActivity(MultipartFile myFile, HttpSession session, HttpServletRequest request) throws Exception {
        //1、获取原来的名称进行替换成唯一标识的名称
        System.out.println("========");
        //1.1、原始文件的名称
        String originalfilename = myFile.getOriginalFilename();

        //2不重名的文件名称
        //2.1、首先先将我们从前端传递回来的文件，文件后缀名进行截取
        String suffix = originalfilename.substring(originalfilename.lastIndexOf(".") + 1);//xls

        //2.2、使用DateTimeUtil.getSysTimeForUpload()方法，根据当前时间将我们的文件进行重新命名
        String filename = DateTimeUtil.getSysTimeForUpload() + "." + suffix;

        //3、获取上传的路径
        String uploadPath = request.getRealPath("/upload");

        //4、执行上传的操作

        //在进行测试上传文件的时候，我们需要先创建一个文件夹，在该文件下创建一个文件，clean之后，再启动我们的tomcat
        //在去target目录下进行查看
        myFile.transferTo(new File(uploadPath + "/" + filename));

        //4.1、创建工作簿对象
        InputStream in = new FileInputStream(uploadPath + "/" + filename);
        HSSFWorkbook workbook = new HSSFWorkbook(in);

        //4.2、创建页码对象
        HSSFSheet sheet = workbook.getSheetAt(0);
        int firstRowNum = sheet.getFirstRowNum();
        int lastRowNum = sheet.getLastRowNum();




        //5、把市场活动的对象全部封装到我们的集合中
        List<Activity> aList = new ArrayList<>();

        //遍历表行，跳过我们的表头
        for (int i = firstRowNum + 1; i <= lastRowNum; i++) {



            //获取到表行中的每个单元格数据
            HSSFRow row = sheet.getRow(i);
            //name、startDate、endDate、cost、description
            //创建市场活动对象封装从Excel获取到的属性值
            String name = row.getCell(0).getStringCellValue();
            String startDate = row.getCell(1).getStringCellValue();
            String endDate = row.getCell(2).getStringCellValue();
            String cost = row.getCell(3).getStringCellValue();
            String description = row.getCell(4).getStringCellValue();

            Activity a = new Activity();
            a.setId(UUIDUtil.getUUID());
            a.setOwner(((User) session.getAttribute("user")).getId());
            a.setCreateBy(((User) session.getAttribute("user")).getName());
            a.setCreateTime(DateTimeUtil.getSysTime());
            a.setCost(cost);
            a.setDescription(description);
            a.setStartDate(startDate);
            a.setEndDate(endDate);
            a.setName(name);

            //将activity封装到我们的集合容器中
            aList.add(a);

        }

        //将数据批量插入到数据库中
        activityService.saveActivityAllXls(aList);

        return HandleFlag.successTrue();
    }

    //我们在这里接收从前端通过点击名称后，携带它的id进行传递，我们在这里需要查询到他的数据，向下一个页面进行跳转的操作
    @RequestMapping("/toDetail.do")
    @ResponseBody
    public ModelAndView toDetail(String id){
        ModelAndView mv = new ModelAndView();
        Activity activity = activityService.toDetail(id);
        mv.addObject("a",activity);
        mv.setViewName("/workbench/activity/detail");

        System.out.println(activity);

        return mv;
    }
}
