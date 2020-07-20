package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Contacts;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ContactsDao {
    Contacts findContactsByNameAndId(@Param("fullname") String fullname,@Param("id") String id);

    void saveContacts(Contacts contacts);

    List<Contacts> findAll();
}
