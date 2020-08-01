package com.bjpowernode.p2p.mapper;

import com.bjpowernode.p2p.model.IncomeRecord;
import com.bjpowernode.p2p.model.IncomeRecordExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface IncomeRecordMapper {
    long countByExample(IncomeRecordExample example);

    int deleteByExample(IncomeRecordExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(IncomeRecord record);

    int insertSelective(IncomeRecord record);

    List<IncomeRecord> selectByExample(IncomeRecordExample example);

    IncomeRecord selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") IncomeRecord record, @Param("example") IncomeRecordExample example);

    int updateByExample(@Param("record") IncomeRecord record, @Param("example") IncomeRecordExample example);

    int updateByPrimaryKeySelective(IncomeRecord record);

    int updateByPrimaryKey(IncomeRecord record);
}