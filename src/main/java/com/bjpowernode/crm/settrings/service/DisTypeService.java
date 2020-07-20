package com.bjpowernode.crm.settrings.service;


import com.bjpowernode.crm.settrings.domain.DisType;

import java.util.List;

public interface DisTypeService {

    //根据code查询是否有重复code的接口方法
    DisType saveReuseDisTypeByCode(String code);

    //查询表中所有数据的方法
    List<DisType> toDictionaryType();

    //对表中的数据进行增加的操作
    void saveDistype(DisType disType);

    //根据从前端选中的code对表中的数据进行查询的操作
    DisType updateDisTypeByCode(String code);


    //对数据库进行修改的操作
    void updateDistype(DisType disType);

    //根据前端返回的数据，删除表中的数据
    Integer deleteDisTypeByCodes(String[] codes);

    //查询type表的code值用于value表的外键使用
    List<String> toSaveValue();
}
