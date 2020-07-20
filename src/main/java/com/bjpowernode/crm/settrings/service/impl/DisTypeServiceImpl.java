package com.bjpowernode.crm.settrings.service.impl;

import com.bjpowernode.crm.settrings.dao.DisTypeDao;
import com.bjpowernode.crm.settrings.domain.DisType;
import com.bjpowernode.crm.settrings.service.DisTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DisTypeServiceImpl implements DisTypeService {

    @Autowired
    private DisTypeDao disTypeDao;


    @Override
    public DisType saveReuseDisTypeByCode(String code) {

        //返回从数据库根据code查询到的数据
        return disTypeDao.saveReuseDisTypeByCode(code);

    }

    @Override
    public List<DisType> toDictionaryType() {

        //查询表中所有的数据，然后进行返回
        return disTypeDao.toDictionaryType();
    }

    @Override
    public void saveDistype(DisType disType) {
        disTypeDao.saveDistype(disType);
    }

    @Override
    public DisType updateDisTypeByCode(String code) {

        //查询复选框选中的数据
        return disTypeDao.updateDisTypeByCode(code);

    }

    @Override
    public void updateDistype(DisType disType) {

        //修改数据库中的数据
        disTypeDao.updateDistype(disType);
    }

    @Override
    public Integer deleteDisTypeByCodes(String[] codes) {

        //删除表中的数据
        return disTypeDao.deleteDisTypeByCodes(codes);
    }

    @Override
    public List<String> toSaveValue() {

        return disTypeDao.toSaveValue();
    }
}
