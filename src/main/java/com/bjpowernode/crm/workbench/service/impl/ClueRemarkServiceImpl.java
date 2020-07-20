package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.dao.ClueRemarkDao;
import com.bjpowernode.crm.workbench.domain.ClueRemark;
import com.bjpowernode.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClueRemarkServiceImpl implements ClueRemarkService {

    @Autowired
    private ClueRemarkDao clueRemarkDao;

    //根据进入我们页面的id，查询到我们在此链接下的备注信息
    @Override
    public List<ClueRemark> getClueRemarkListById(String clueId) {
        return clueRemarkDao.getClueRemarkListById(clueId);
    }

    //对我们页面的备注数据，进行我们增加的操作
    @Override
    public void saveClueRemark(ClueRemark clueRemark) {
        clueRemarkDao.saveClueRemark(clueRemark);
    }

    @Override
    public void deleteClueRemarkById(String id) {
        clueRemarkDao.deleteClueRemarkById(id);
    }
}
