package com.bjpowernode.p2p.mapper;

import com.bjpowernode.p2p.model.FinanceAccount;
import com.bjpowernode.p2p.model.FinanceAccountExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface FinanceAccountMapper {
    long countByExample(FinanceAccountExample example);

    int deleteByExample(FinanceAccountExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(FinanceAccount record);

    int insertSelective(FinanceAccount record);

    List<FinanceAccount> selectByExample(FinanceAccountExample example);

    FinanceAccount selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") FinanceAccount record, @Param("example") FinanceAccountExample example);

    int updateByExample(@Param("record") FinanceAccount record, @Param("example") FinanceAccountExample example);

    int updateByPrimaryKeySelective(FinanceAccount record);

    int updateByPrimaryKey(FinanceAccount record);
}