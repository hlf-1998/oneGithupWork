package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Customer;

public interface CustomerDao {

    Customer findByCompany(String company);

    void saveCustomer(Customer cust);
}
