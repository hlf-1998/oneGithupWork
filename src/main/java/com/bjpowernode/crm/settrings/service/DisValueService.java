package com.bjpowernode.crm.settrings.service;

import com.bjpowernode.crm.settrings.domain.DisValue;

import java.util.List;
import java.util.Map;

public interface DisValueService {

    //查询tbl_dic_value表中所有的数据
    List<DisValue> toDisValue();

    Map<String, Object> valueIfOnly(Map<String, String> disValue);

    void saveDisValue(DisValue disValue);

    DisValue findDisValueByID(String id);

    void updateDisValue(DisValue disValue);

    void deleteDisValueByID(String[] ids);

    List<DisValue> findDisValueByCode(String code);
}
