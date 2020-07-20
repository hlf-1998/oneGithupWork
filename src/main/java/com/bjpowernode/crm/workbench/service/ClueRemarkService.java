package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkService {

    List<ClueRemark> getClueRemarkListById(String clueId);

    void saveClueRemark(ClueRemark clueRemark);

    void deleteClueRemarkById(String id);
}
