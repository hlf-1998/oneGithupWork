package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Clue;
import org.apache.ibatis.annotations.Param;


import java.util.List;
import java.util.Map;

public interface ClueDao {

    List<Clue> getPageList(Map<String, Object> paramMap);

    Long findClueAllCount(Map<String, Object> paramMap);

    void saveClue(Clue clue);

    void deleteClueById(String[] clueId);

    Clue findById(String id);

    List<Activity> getUnActivityListById(Map<String,Object> paramMap);


    void addRelation(@Param("uuid") String uuid,@Param("clueId") String clueId,@Param("id") String id);

    void deleteRelationId(String relationId);

    List<Activity> getRelationActivityList(String clueId);

    List<Activity> getRelationActivityListLike(Map<String,String> mapParam);

    void deleteClueByClueId(String clueId);
}
