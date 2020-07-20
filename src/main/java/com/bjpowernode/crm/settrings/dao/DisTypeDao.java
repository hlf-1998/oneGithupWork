package com.bjpowernode.crm.settrings.dao;

import com.bjpowernode.crm.settrings.domain.DisType;

import java.util.List;

public interface DisTypeDao {

    /**
     * 通过编码code来查询是否有重复的方法
     */
    DisType saveReuseDisTypeByCode(String code);

    /**
     * 将表中所有的对象进行查询的操作
     */
    List<DisType> toDictionaryType();

    //对表中数据进行增加的操作
    void saveDistype(DisType disType);

    //根据从前端复选框选中的code，作为查询的标识，对表中的数据进行查询
    DisType updateDisTypeByCode(String code);

    //修改数据
    void updateDistype(DisType disType);

    //删除数据
    Integer deleteDisTypeByCodes(String[] codes);

    //查询type表的的code值用于value表中进行使用
    List<String> toSaveValue();
}
