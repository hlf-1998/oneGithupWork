package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TransactionService {
    List<String> getCustomerName(String name);

    void saveTran(Map<String, String> paramMap);

    Tran findById(String id);
}
