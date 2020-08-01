package com.bjpowernode.p2p.mapper;

import com.bjpowernode.p2p.model.LoanInfo;
import com.bjpowernode.p2p.model.LoanInfoExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface LoanInfoMapper {
    long countByExample(LoanInfoExample example);

    int deleteByExample(LoanInfoExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(LoanInfo record);

    int insertSelective(LoanInfo record);

    List<LoanInfo> selectByExample(LoanInfoExample example);

    LoanInfo selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") LoanInfo record, @Param("example") LoanInfoExample example);

    int updateByExample(@Param("record") LoanInfo record, @Param("example") LoanInfoExample example);

    int updateByPrimaryKeySelective(LoanInfo record);

    int updateByPrimaryKey(LoanInfo record);
}