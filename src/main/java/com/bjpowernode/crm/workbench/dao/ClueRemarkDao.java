package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    List<ClueRemark> getClueRemarkListById(String clueId);

    void saveClueRemark(ClueRemark clueRemark);

    void deleteClueRemarkById(String id);


    void deleteClueRemarkByClueId(String clueId);
}
