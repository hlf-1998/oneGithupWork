package com.bjpowernode.p2p.mapper;

import com.bjpowernode.p2p.model.BidInfo;
import com.bjpowernode.p2p.model.BidInfoExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface BidInfoMapper {
    long countByExample(BidInfoExample example);

    int deleteByExample(BidInfoExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(BidInfo record);

    int insertSelective(BidInfo record);

    List<BidInfo> selectByExample(BidInfoExample example);

    BidInfo selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") BidInfo record, @Param("example") BidInfoExample example);

    int updateByExample(@Param("record") BidInfo record, @Param("example") BidInfoExample example);

    int updateByPrimaryKeySelective(BidInfo record);

    int updateByPrimaryKey(BidInfo record);
}