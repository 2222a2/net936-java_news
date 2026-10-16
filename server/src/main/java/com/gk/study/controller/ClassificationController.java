package com.gk.study.controller;

import com.gk.study.common.APIResponse;
import com.gk.study.common.ResponeCode;
import com.gk.study.entity.Classification;
import com.gk.study.permission.Access;
import com.gk.study.permission.AccessLevel;
import com.gk.study.service.ClassificationService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 新闻分类相关接口
 *
 * 前端实际访问路径：/api/classification/xxx
 */
@RestController
@RequestMapping("/classification")
public class ClassificationController {

    private final static Logger logger = LoggerFactory.getLogger(ClassificationController.class);

    @Autowired
    ClassificationService service;

    /**
     * 分类列表（首页筛选栏、后台发布新闻、后台分类管理都要用）
     */
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public APIResponse list() {
        List<Classification> list = service.getClassificationList();
        return new APIResponse(ResponeCode.SUCCESS, "查询成功", list);
    }

    /**
     * 新增分类
     */
    @Access(level = AccessLevel.ADMIN)
    @RequestMapping(value = "/create", method = RequestMethod.POST)
    @Transactional
    public APIResponse create(Classification classification) {
        if (StringUtils.isBlank(classification.getTitle())) {
            return new APIResponse(ResponeCode.FAIL, "分类名称不能为空");
        }
        service.createClassification(classification);
        return new APIResponse(ResponeCode.SUCCESS, "创建成功");
    }

    /**
     * 编辑分类
     */
    @Access(level = AccessLevel.ADMIN)
    @RequestMapping(value = "/update", method = RequestMethod.POST)
    @Transactional
    public APIResponse update(Classification classification) {
        if (classification.getId() == null) {
            return new APIResponse(ResponeCode.FAIL, "缺少分类 id");
        }
        service.updateClassification(classification);
        return new APIResponse(ResponeCode.SUCCESS, "更新成功");
    }

    /**
     * 删除分类（支持逗号分隔的批量删除）
     */
    @Access(level = AccessLevel.ADMIN)
    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    public APIResponse delete(String ids) {
        if (StringUtils.isBlank(ids)) {
            return new APIResponse(ResponeCode.FAIL, "缺少 ids 参数");
        }
        String[] arr = ids.split(",");
        for (String id : arr) {
            service.deleteClassification(id);
        }
        return new APIResponse(ResponeCode.SUCCESS, "删除成功");
    }
}
