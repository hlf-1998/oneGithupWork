package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueService {

    List<Clue> getPageList(Map<String, Object> paramMap);

    Long findClueAllCount(Map<String, Object> paramMap);

    void saveClue(Clue clue);

    void deleteClueById(String[] clueId);

    Clue findById(String id);

    List<Activity> getUnActivityListById(Map<String,Object> paramMap);

    void addRelation(String clueId, String[] ids);


    void deleteRelationId(String relationId);

    List<Activity> getRelationActivityList(String clueId);

    List<Activity> getRelationActivityListLike(Map<String,String> mapParam);

    void exchangeClue(Map<String, String> paramMap);
}
