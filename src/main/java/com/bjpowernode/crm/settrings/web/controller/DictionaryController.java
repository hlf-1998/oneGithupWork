package com.bjpowernode.crm.settrings.web.controller;


import com.bjpowernode.crm.exception.TraditionRequestException;
import com.bjpowernode.crm.settrings.domain.DisType;
import com.bjpowernode.crm.settrings.domain.DisValue;
import com.bjpowernode.crm.settrings.service.DisTypeService;
import com.bjpowernode.crm.settrings.service.DisValueService;
import com.bjpowernode.crm.utils.HandleFlag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/settrings/dictionary")
public class DictionaryController {

    @Autowired
    private DisTypeService disTypeService;



    //=================================================================================================================
    //=========================================字典类型页面设置=========================================================
    //=================================================================================================================

    /**
     * 将系统设置页面中的数据字典表进行跳转，
     * @return
     */
    @RequestMapping("/toDictionary.do")
    public String toDictionary(){

        return "/settrings/dictionary/index";

    }

    /**
     * 让登录进行后，页面可以看到字典类型中的内容,查询所有对象，将其显示的方法
     * @return
     */
    @RequestMapping("/toDictionaryType.do")
    public ModelAndView toDictionaryType(){

        ModelAndView mv = new ModelAndView();

        mv.setViewName("/settrings/dictionary/type/index");

        List<DisType> disTypes = disTypeService.toDictionaryType();

        mv.addObject("dtList",disTypes);

        return mv;

    }

    /**
     * 对页面进行跳转操作，让其到创建的页面中，进行创建新的操作
     * @return
     */
    @RequestMapping("/type/toDicTypeSave.do")
    public String toDicTypeSave(){

        return "/settrings/dictionary/type/save";

    }

    /**
     * 通过编码进行查询，查看编码是否有重复
     * @return
     */
    @RequestMapping("/type/saveReuseDisTypeByCode.do")
    @ResponseBody
    public Map<String,Object> saveReuseDisTypeByCode(String code){

        //先创建一个map集合
        Map<String,Object> map = new HashMap<>();

        //根据输入的code返回的数据
        DisType disType = disTypeService.saveReuseDisTypeByCode(code);

        //如果返回的数据不为空，那么说明我的code是重复的，如果为空，那么说明不是重复的
        if (disType == null){

            //说明输入的code没有重复的
            map = HandleFlag.successTrue();

        }else {

            //说明输入的code是有重复的
            map.put("success",false);
            map.put("msg","您输入的编码是重复的，请您检查后再次输入！");

        }

        return map;

    }


    //对字典类型添加数据操作
    @RequestMapping("/saveDistype.do")
    public String saveDistype(DisType disType) throws TraditionRequestException {

        disTypeService.saveDistype(disType);

        //使用重定向，可以通过url的方式访问字典类型的主页面，对添加成功后跳转回主页面查看添加成功后的数据
        return "redirect:/settrings/dictionary/toDictionaryType.do";

    }


    //根据复选框选中code，然后进行查询到所需要修改的数据
    @RequestMapping("/updateDisTypeByCode.do")
    //因为我们需要根据code查询到我们所需要修改的页面，然后将查询到的值传递到所需要修改的页面，然后在页面中对其进行修改的操作
    public ModelAndView updateDisTypeByCode(String code){


        ModelAndView mv = new ModelAndView();

        //获取根据复选框code查询到的数据
        DisType disType = disTypeService.updateDisTypeByCode(code);


        //将获取到的数据存入，然后传递到页面
        mv.addObject("dt",disType);

        //页面转发的位置
        mv.setViewName("settrings/dictionary/type/edit");

        return mv;

    }

    //对字典类型进行修改
    @RequestMapping("/type/updateDistype.do")
    public String updateDistype(DisType disType){
        

        //获取从后端修改后的数据
        disTypeService.updateDistype(disType);

        //使用重定向，通过url的方式访问字典类型的主页面，修改后跳转回主页面
        return "redirect:/settrings/dictionary/toDictionaryType.do";


    }


    //对字典类型中数据进行删除的操作
    @RequestMapping("/type/deleteDisType.do")
    @ResponseBody
    public Map<String,Object> deleteDisType(String[] codes){

        System.out.println(Arrays.toString(codes));

        Map<String,Object> map = new HashMap<>();

        Integer rows = disTypeService.deleteDisTypeByCodes(codes);
        if (rows == null){
            map.put("success",false);
            map.put("msg","未删除成功！！！");
        }else {
            map = HandleFlag.successTrue();
        }

        return map;

    }


    //=================================================================================================================
    //=========================================字典值页面设置===========================================================
    //=================================================================================================================

    @Autowired
    private DisValueService disValueService;

    //点击字面值后可以直接看到它页面显示的方法,还需要将数据传递到页面中
    @RequestMapping("/toDisValue.do")
    public ModelAndView toDisValue(){

        ModelAndView mv = new ModelAndView();

        mv.setViewName("/settrings/dictionary/value/index");

        List<DisValue> dvList = disValueService.toDisValue();

        mv.addObject("dvList",dvList);

        return mv;

    }

    /**点击创建按钮后，对页面进行跳转到创建页面,在这里我们需要获取到tbl_dic_type表中code，
     * 因为tbl_dic_value的外键typeCode是tbl_dic_type表中code的值，在我们对于tbl_dic_value这张表数据进行创建操作的时候，
     * 我们需要使用到tbl_dic_value表的外键作为我们添加时候的字典类型编码框中的数据是tbl_dic_type表的。我们要将数据传递过来`
     * @return
     */
    @RequestMapping("/toSaveValue.do")
    //本次我们不仅需要再点击创建之后跳转到我们的创建页面，还需要将我们查询到的数据进行传递的操作
    public ModelAndView toSaveValue(){
        ModelAndView mv = new ModelAndView();

        //查询到type表的code值，用于value表，在value表中，type表中的code值，作为这张表的添加的标识
        List<String> stringList = disTypeService.toSaveValue();

        mv.addObject("codeList",stringList);
        mv.setViewName("/settrings/dictionary/value/save");

        return mv;


    }

    /**
     * 根据我们的字典编码类型查询我们的字典值是否有重复
     * 这种方式的封装应对前台传递来的参数，后台无需继续用实体类进行封装，传递的方式更加灵活
     * 一定要添加@RequestParam注解，来将传递的参数封装到集合中
     * @param disValue
     * @return
     */
    @RequestMapping("/value/valueIfOnly.do")
    @ResponseBody
    public Map<String,Object> valueIfOnly(@RequestParam Map<String,String> disValue){

        //disValue={typeCode=xxx, value=xxx}
        Map<String,Object> map = disValueService.valueIfOnly(disValue);

        //我们的结果在service已经进行了处理，controller负责接收我们返回的结果进行传递

        return map;
    }

    //在点击保存按钮后我们需要把表单中的数据进行提交的操作
    @RequestMapping("/value/saveDisValue.do")
    public String saveDisValue(DisValue disValue) throws TraditionRequestException{
        disValueService.saveDisValue(disValue);
        //添加成功之后将页面重定向回到字典值的首页面进行创建后的显示
        return "redirect:/settrings/dictionary/toDisValue.do";
    }

    //根据value表的唯一标识id，然后根据选中后对这张表进行查询操作
    @RequestMapping("/value/findDisValueByID.do")
    @ResponseBody
    public ModelAndView findDisValueByID(String id){
        DisValue disValue = disValueService.findDisValueByID(id);

        ModelAndView mv = new ModelAndView();
        mv.addObject("dv",disValue);
        //需要将我们查询到的数据，跳转到我们修改的页面中
        mv.setViewName("/settrings/dictionary/value/edit");
        return mv;
    }

    //将修改后的数据进行提交，返回到数据库中进行修改的操作
    @RequestMapping("/value/updateDisValue.do")
    public String updateDisValue(DisValue disValue) throws TraditionRequestException {
        disValueService.updateDisValue(disValue);

        return "redirect:/settrings/dictionary/toDisValue.do";
    }

    //对选中的数据进行删除的操作
    @RequestMapping("/value/deleteDisValueByID.do")
    @ResponseBody
    //将我们获取到的id属性保存到数组中进行传递
    public Map<String,Object> deleteDisValueByID(String[] ids) throws TraditionRequestException{

        disValueService.deleteDisValueByID(ids);
        return HandleFlag.successTrue();
    }
}
