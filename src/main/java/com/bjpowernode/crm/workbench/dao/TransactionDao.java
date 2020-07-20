package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Tran;

import java.util.List;

public interface TransactionDao {

    List<String> getCustomerName(String name);

    Tran findById(String id);
}
