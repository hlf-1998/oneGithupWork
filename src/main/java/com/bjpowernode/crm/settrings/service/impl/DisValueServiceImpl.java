package com.bjpowernode.crm.settrings.service.impl;

import com.bjpowernode.crm.settrings.dao.DisValueDao;
import com.bjpowernode.crm.settrings.domain.DisValue;
import com.bjpowernode.crm.settrings.service.DisValueService;
import com.bjpowernode.crm.utils.HandleFlag;
import com.bjpowernode.crm.utils.UUIDUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DisValueServiceImpl implements DisValueService {

    @Autowired
    private DisValueDao disValueDao;

    @Override
    public List<DisValue> toDisValue() {

        //返回查询到的所有数据
        return disValueDao.toDisValue();
    }

    @Override
    public Map<String, Object> valueIfOnly(Map<String, String> disValue) {
        //获取查询到的结果
        DisValue dv = disValueDao.valueIfOnly(disValue);


        Map<String,Object> map = new HashMap<>();

        //如果能够查询到结果说明重复了，需要给用户提示
        if (dv != null){
            map.put("success",false);
            map.put("msg","您输入的字典值重复了！！！");
        }else {
            map = HandleFlag.successTrue();
        }
        return map;
    }

    @Override
    public void saveDisValue(DisValue disValue) {
        //需要为id赋值
        //UUID是36位长度的，其中有四个-，代表的是一条无意义的字符串，起到的是唯一标识的作用
        disValue.setId(UUIDUtil.getUUID());
        disValueDao.saveDisValue(disValue);
    }


    //根据唯一标识id，对value进行查询，查询到表中的数据，将数据进行返回
    @Override
    public DisValue findDisValueByID(String id) {
        return disValueDao.findDisValueByID(id);
    }


    //根据我们前端输入所需要修改的数据，进行传递过来，完成修改的操作
    @Override
    public void updateDisValue(DisValue disValue) {
        disValueDao.updateDisValue(disValue);
    }

    //根据我们复选框选中的数据得到他的id，然后进行删除的操作
    @Override
    public void deleteDisValueByID(String[] ids) {
        disValueDao.deleteDisValueByID(ids);
    }


    //根据我们type表中的code的值，查询value表中的数据
    @Override
    public List<DisValue> findDisValueByCode(String code) {
        return disValueDao.findDisValueByCode(code);
    }
}
