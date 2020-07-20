package com.bjpowernode.crm.settrings.dao;

import com.bjpowernode.crm.settrings.domain.DisValue;

import java.util.List;
import java.util.Map;

public interface DisValueDao {

    //查询表中所有数据的方法
    List<DisValue> toDisValue();

    //根据字典类型编码和字典值查询
    DisValue valueIfOnly(Map<String, String> disValue);

    //对表中的数据进行增加的操作
    void saveDisValue(DisValue disValue);

    DisValue findDisValueByID(String id);

    void updateDisValue(DisValue disValue);

    void deleteDisValueByID(String[] ids);

    List<DisValue> findDisValueByCode(String code);
}
