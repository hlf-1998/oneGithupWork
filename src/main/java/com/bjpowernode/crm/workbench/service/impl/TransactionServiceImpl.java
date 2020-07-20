package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.dao.TranDao;
import com.bjpowernode.crm.workbench.dao.TransactionDao;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;


@Service
public class TransactionServiceImpl implements TransactionService {

    @Autowired
    private TransactionDao transactionDao;

   /* @Autowired
    private CustomerService customerService;
*/
    @Autowired
    private TranDao tranDao;



    @Override
    public List<String> getCustomerName(String name) {
        return transactionDao.getCustomerName(name);
    }

    //对Tran表中的数据进行增加操作
    /**
     * Tran属性：
     *      activityId:
     *      contactsId:
     *      owner:
     *      money:
     *      name:
     *      expectedDate:
     *      stage:
     *      type:
     *      source:
     *      description:
     *      contactSummary:
     *      nextContactTime:
     *
     *      没传的属性
     *          customerId，根据customerName来去查询获取，没有再新增。
     *
     *      赋值
     *          id
     *          createTime
     *          createBy
     *
     *      附属
     *          customerName: 如果没有传递customerId，使用customerName进行后台查询，无结果，新增一条客户记录
     *          contactsName: 如果没有传递contactsId，使用contactsName进行后台查询，无结果，新增一条联系人记录
     *
     *
     */
    @Override
    public void saveTran(Map<String, String> paramMap) {

        /**
         *   TODO 未写完，这里就是在我们保存后，新增交易记录，将保存页面中的数据进行传递，
         *   然后我们的唯一标识id，还有创建时间，创建人，在controller中进行创建，
         *   如果我们传递过来的数据中客户名称和联系人名称在数据库中不存在的话，那么需要再数据库进行创建，
         *   创建成功之后，返回客户名称的id，还有联系人的id，将数据传递给Tran表（交易表），在交易添加
         *   成功之后，之后需要创建交易历史的记录发送到交易历史的表中
         */



       /* //7.新增交易
        Tran t = new Tran();
        t.setId(UUIDUtil.getUUID());
        t.setActivityId(paramMap.get("activityId"));
        if(paramMap.get("customerId") != null && paramMap.get("customerId").length() >0){
            t.setContactsId(paramMap.get("customerId"));
        }else{
            //说明没有客户Id，新增客户
            String customerName = paramMap.get("customerName");
            //TODO 查询后，并新增的功能
            //先根据customerName进行等值查询，如果返回null，再新增客户
            //新增，id...
            //...
            //设置customerId
        }
        t.setContactSummary(paramMap.get("contactSummary"));
        t.setCreateBy(paramMap.get("createBy"));
        t.setCreateTime(paramMap.get("createTime"));
        //根据customerName去查询数据库，匹配公司名称，返回结果为null，新增客户
        Customer customer = customerService.findCustomerByCompany(paramMap.get("customerName"));
        if(customer == null ){
            //TODO 查询后，并新增的功能
            //新增客户
            //...
            //给tran赋值id
        }
        t.setCustomerId(customer.getId());
        t.setDescription(paramMap.get("description"));
        t.setExpectedDate(paramMap.get("expectedDate"));
        t.setMoney(paramMap.get("money"));
        t.setName(paramMap.get("name"));
        t.setNextContactTime(paramMap.get("nextContactTime"));
        t.setOwner(paramMap.get("owner"));
        t.setSource(paramMap.get("source"));
        t.setStage(paramMap.get("stage"));

        //新增交易记录
        tranDao.saveTran(t);

        //交易历史记录
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setCreateBy(paramMap.get("createBy"));
        th.setCreateTime(paramMap.get("createTime"));
        th.setExpectedDate(paramMap.get("expectedDate"));
        th.setMoney(paramMap.get("money"));
        th.setStage(paramMap.get("stage"));
        th.setTranId(t.getId());

        //新增交易历史记录
        tranHistoryDao.saveTranHistory(th);*/
    }

    @Override
    public Tran findById(String id) {
        return transactionDao.findById(id);
    }
}
