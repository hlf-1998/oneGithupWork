package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.workbench.dao.TranHistoryDao;
import com.bjpowernode.crm.workbench.domain.TranHistory;
import com.bjpowernode.crm.workbench.service.TranHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TranHistoryServiceImpl implements TranHistoryService {

    @Autowired
    private TranHistoryDao tranHistoryDao;



    @Override
    public List<TranHistory> getTranHistoryListById(String tranId) {
        return tranHistoryDao.getTranHistoryListById(tranId);
    }
}
