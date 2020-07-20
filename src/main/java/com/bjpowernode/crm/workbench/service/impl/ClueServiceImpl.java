package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.dao.*;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;


@Service
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueDao clueDao;


    //我们根据我们传递数据进行分页查询
    @Override
    public List<Clue> getPageList(Map<String, Object> paramMap) {
        return clueDao.getPageList(paramMap);
    }


    //查询我们id为我们现在登录这个用户的id，进行我们的查询我们的总数
    @Override
    public Long findClueAllCount(Map<String, Object> paramMap) {
        return clueDao.findClueAllCount(paramMap);
    }

    //我们对我们线索页面的数据进行增加的操作
    @Override
    public void saveClue(Clue clue) {
        clueDao.saveClue(clue);
    }

    @Override
    public void deleteClueById(String[] clueId) {
        clueDao.deleteClueById(clueId);
    }

    @Override
    public Clue findById(String id) {
        return clueDao.findById(id);
    }


    //根据我们线索页面点击链接的id获取到我们为进行关联的数据，
    @Override
    public List<Activity> getUnActivityListById(Map<String,Object> paramMap) {
        return clueDao.getUnActivityListById(paramMap);
    }

    @Override
    public void addRelation(String clueId, String[] ids) {
        //在我们选择将我们未关联的市场活动进行关联的时候，我们需要再关联的时候，提供我们3个参数，
        // 因为我们关联的中间表有表的唯一标识id，clueId，activityId,我们都需要进行提供，而在这里
        // 我们使用动态sql的foreach标签，无法遍历多个参数，尤其是参数中有包含复杂类型
        //所以我们需要使用简单类型进行封装，在这里使用遍历，然后去调用我们的方法进行我们的关联市场
        for (String id : ids) {
            clueDao.addRelation(UUIDUtil.getUUID(),clueId,id);
        }
    }

    //解除市场关联
    @Override
    public void deleteRelationId(String relationId) {
        clueDao.deleteRelationId(relationId);
    }

    //根据线索id，查询我们已经关联的市场活动信息
    @Override
    public List<Activity> getRelationActivityList(String clueId) {
        return clueDao.getRelationActivityList(clueId);
    }


    //根据我们传递过来的clueId和市场活动名称activityName
    @Override
    public List<Activity> getRelationActivityListLike(Map<String,String> mapParam) {
        return clueDao.getRelationActivityListLike(mapParam);
    }



    @Autowired
    private CustomerDao customerDao;

    @Autowired
    private ContactsDao contactsDao;

    @Autowired
    private ClueRemarkDao clueRemarkDao;

    @Autowired
    private CustomerRemarkDao customerRemarkDao;

    @Autowired
    private ContactsRemarkDao contactsRemarkDao;

    @Autowired
    private ContactsActivityRelationDao contactsActivityRelationDao;

    @Autowired
    private ClueActivityRelationDao clueActivityRelationDao;

    @Autowired
    private TranDao tranDao;

    @Autowired
    private TranHistoryDao tranHistoryDao;


    /**
     * TODO 线索转换业务逻辑：（将线索转换为客户，联系人，客户备注，联系人备注，如果创建了交易就要执行6-10的步骤）
     *      1、根据线索id，查询到线索信息
     *      2、根据线索中的company查询到对应的客户信息，如果没有，进行新增Customer
     *      3、根据线索中的fullname，查询对应联系人的信息，如果没有，进行新增Contacts
     *      4、根据线索的备注信息，将他转换成联系人备注、客户备注信息
     *      5、根据线索和市场活动的关联关系，转换为联系人和市场活动的关联关系
     *
     *      6、是否创建交易，根据我们隐藏域中传递过来的flag进行判断
     *      7、新增交易和交易历史记录
     *      8、删除线索和市场活动的关联关系
     *      9、删除线索的备注信息
     *      10、删除线索
     *
     * @param paramMap
     *      将线索转换成客户，联系人，备注信息需要的内容
     *      clueId
     *      activityId
     *      flag
     *      createTime  createBy 这两个属性我们在controller中已经进行封装
     *
     *      交易的实体类信息
     *      money
     *      name
     *      expectedDate
     *      stage
     *
     *
     */

    @Override
    public void exchangeClue(Map<String, String> paramMap) {
        //0、将参数进行提取
        String clueId = paramMap.get("clueId");
        String activityId = paramMap.get("activityId");
        String createTime = paramMap.get("createTime");
        String createBy = paramMap.get("createBy");
        String flag = paramMap.get("flag");

        String money = "";
        String name = "";
        String expectedDate = "";
        String stage = "";

        //我们需要进行判断是否有选中为客户创建交易的点击
        if ("a".equals(flag)){
            money = paramMap.get("money");
            name = paramMap.get("name");
            expectedDate = paramMap.get("expectedDate");
            stage = paramMap.get("stage");
        }

        //1、根据线索id查询到线索信息
        Clue clue = clueDao.findById(clueId);
        //如果查询到线索信息有值的话，那么则执行以下操作
        if (clue != null){

            //2、根据线索中的company，查询对应的客户信息，如果没有进行新增Customer
            String company = clue.getCompany();

            Customer cust = customerDao.findByCompany(company);
            if (cust == null){
                //新增一个客户对象
                cust = new Customer();
                //赋值操作
                cust.setId(UUIDUtil.getUUID());
                cust.setAddress(clue.getAddress());
                cust.setContactSummary(clue.getContactSummary());
                cust.setCreateBy(createBy);
                cust.setCreateTime(createTime);
                cust.setDescription(clue.getDescription());
                cust.setName(company);
                cust.setNextContactTime(clue.getNextContactTime());
                cust.setOwner(clue.getOwner());
                cust.setPhone(clue.getPhone());
                cust.setWebsite(clue.getWebsite());

                //新增客户记录
                customerDao.saveCustomer(cust);
            }

            //3、根据线索中的fullname，查询对应联系人的信息，如果没有，进行新增Contacts
            //在这里我们可能会遇到名称重复的情况，所以我们再增加一个customerId
            Contacts contacts = contactsDao.findContactsByNameAndId(clue.getFullname(),cust.getId());

            if (contacts == null){
                //新增联系人记录
                contacts = new Contacts();
                //赋值操作
                contacts = new Contacts();
                contacts.setId(UUIDUtil.getUUID());
                contacts.setAddress(clue.getAddress());
                contacts.setAppellation(clue.getAppellation());
                contacts.setContactSummary(clue.getContactSummary());
                contacts.setCreateBy(createBy);
                contacts.setCreateTime(createTime);
                contacts.setDescription(clue.getDescription());
                contacts.setCustomerId(cust.getId());
                contacts.setEmail(clue.getEmail());
                contacts.setFullname(clue.getFullname());
                contacts.setJob(clue.getJob());
                contacts.setMphone(clue.getMphone());
                contacts.setNextContactTime(clue.getNextContactTime());
                contacts.setOwner(clue.getOwner());
                contacts.setSource(clue.getSource());

                //新增联系人记录
                contactsDao.saveContacts(contacts);

            }
            //4、根据线索的备注信息，将他转换成联系人备注、客户备注信息
            //我们需要根据线索id，查询到所属的线索备注列表
            List<ClueRemark> clueRemarkList = clueRemarkDao.getClueRemarkListById(clueId);

            //创建容器用来存储我们查询到的联系人和客户备注信息
            List<CustomerRemark> customerRemarkList = new ArrayList<>();
            List<ContactsRemark> contactsRemarkList = new ArrayList<>();

            //判断是否有查询到我们的线索备注列表的信息
            if (clueRemarkList != null && clueRemarkList.size() > 0){
                //遍历我们线索备注信息，然后将它转换成我们的联系人备注和客户备注信息
                for (ClueRemark clueRemark : clueRemarkList) {

                    //创建联系人备注对象，封装到容器中，进行批量插入
                    ContactsRemark contactsRemark = new ContactsRemark();
                    contactsRemark.setId(UUIDUtil.getUUID());
                    contactsRemark.setContactsId(contacts.getId());
                    contactsRemark.setCreateBy(createBy);
                    contactsRemark.setCreateTime(createTime);
                    contactsRemark.setEditFlag("0");//未修改
                    contactsRemark.setNoteContent(clueRemark.getNoteContent());

                    //将联系人对象存放到容器中
                    contactsRemarkList.add(contactsRemark);

                    //创建客户备注对象，将其封装到容器中，进行批量插入
                    CustomerRemark customerRemark = new CustomerRemark();
                    customerRemark.setId(UUIDUtil.getUUID());
                    customerRemark.setCreateBy(createBy);
                    customerRemark.setCreateTime(createTime);
                    customerRemark.setCustomerId(cust.getId());
                    customerRemark.setEditFlag("0");//未修改
                    customerRemark.setNoteContent(clueRemark.getNoteContent());

                    //将客户对象存放到容器中
                    customerRemarkList.add(customerRemark);
                    
                }
                //批量插入我们的联系人备注和客户备注信息
                contactsRemarkDao.saveContactsRemark(contactsRemarkList);
                customerRemarkDao.saveCustomerRemark(customerRemarkList);
            }

            //5、根据线索和市场活动的关联关系，转换为联系人和市场活动的关联关系
            //我们首先根据我们传递过来需要进行转换的线索id查询到我们线索和市场活动表的中间表信息
            List<ClueActivityRelation> carList = clueActivityRelationDao.findRelationById(clueId);

            //创建容器来存储在关系表中的查询到的数据
            List<ContactsActivityRelation> contactsActivityRelationList = new ArrayList<>();

            //对我们查询到的数据进行遍历操作
            if (carList != null && carList.size() > 0){
                for (ClueActivityRelation car : carList) {
                    //将car转换为联系人和市场活动的对象
                    ContactsActivityRelation contactsActivityRelation = new ContactsActivityRelation();
                    contactsActivityRelation.setId(UUIDUtil.getUUID());
                    contactsActivityRelation.setActivityId(activityId);
                    contactsActivityRelation.setContactsId(contacts.getId());

                    //封装到容器中
                    contactsActivityRelationList.add(contactsActivityRelation);
                }
                //进行批量插入数据操作
                contactsActivityRelationDao.saveContactsActivityRelations(contactsActivityRelationList);
            }

            //根据我们的flag判断是否创建了交易，
            if ("a".equals(flag)){
                //选中了交易

                //7、新增交易（我们这里对新增交易的数据传递的是我们从转换页面中获取的数据，还有我们线索中的信息，已经我们客户的id）
                Tran t = new Tran();
                t.setId(UUIDUtil.getUUID());
                t.setActivityId(activityId);
                t.setContactsId(contacts.getId());
                t.setContactSummary(clue.getContactSummary());
                t.setCreateBy(createBy);
                t.setCreateTime(createTime);
                t.setCustomerId(cust.getId());
                t.setDescription(clue.getDescription());
                t.setExpectedDate(expectedDate);
                t.setMoney(money);
                t.setName(name);
                t.setNextContactTime(clue.getNextContactTime());
                t.setOwner(clue.getOwner());
                t.setSource(clue.getSource());
                t.setStage(stage);

                //新增交易记录（将我们从线索中查询到的数据转换到我们的交易中）
                tranDao.saveTran(t);


                //交易历史记录
                TranHistory th = new TranHistory();
                th.setId(UUIDUtil.getUUID());
                th.setCreateBy(createBy);
                th.setCreateTime(createTime);
                th.setExpectedDate(expectedDate);
                th.setMoney(money);
                th.setStage(stage);
                th.setTranId(t.getId());

                //新增交易历史记录
                tranHistoryDao.saveTranHistory(th);

                //因为有外键关联
                //8、删除线索和市场活动的关联关系
                clueActivityRelationDao.deleteClueActivityRelationById(clueId);
                //9、删除线索的备注信息
                clueRemarkDao.deleteClueRemarkByClueId(clueId);
                //10、删除线索
                clueDao.deleteClueByClueId(clueId);

            }
        }
    }


}
