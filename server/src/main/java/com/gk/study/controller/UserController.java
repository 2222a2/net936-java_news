package com.gk.study.controller;

import com.gk.study.common.APIResponse;
import com.gk.study.common.ResponeCode;
import com.gk.study.entity.User;
import com.gk.study.permission.Access;
import com.gk.study.permission.AccessLevel;
import com.gk.study.service.UserService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

/**
 * 用户相关接口
 *
 * 注意：本项目的接口路径前面还有一层 context-path（/api），
 * 所以这里写 /user/login，前端实际访问的是 /api/user/login。
 */
@RestController
@RequestMapping("/user")
public class UserController {

    private final static Logger logger = LoggerFactory.getLogger(UserController.class);

    @Autowired
    UserService service;

    @Value("${File.uploadPath}")
    private String uploadPath;

    /**
     * 管理员登录（role 大于 1 的账号：演示用户、管理员）
     */
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public APIResponse login(User user) {
        if (StringUtils.isBlank(user.getUsername()) || StringUtils.isBlank(user.getPassword())) {
            return new APIResponse(ResponeCode.FAIL, "账号和密码不能为空");
        }
        User loginUser = service.getAdminUser(user);
        if (loginUser == null) {
            return new APIResponse(ResponeCode.FAIL, "账号或密码错误");
        }
        // 每次登录都换一个新 token，前端拿到后会存进 localStorage 并随请求带上
        loginUser.setToken(createToken());
        service.updateUser(loginUser);
        return new APIResponse(ResponeCode.SUCCESS, "登录成功", loginUser);
    }

    /**
     * 普通用户登录（只认 role = 1）
     */
    @RequestMapping(value = "/userLogin", method = RequestMethod.POST)
    public APIResponse userLogin(User user) {
        if (StringUtils.isBlank(user.getUsername()) || StringUtils.isBlank(user.getPassword())) {
            return new APIResponse(ResponeCode.FAIL, "账号和密码不能为空");
        }
        User loginUser = service.getNormalUser(user);
        if (loginUser == null) {
            return new APIResponse(ResponeCode.FAIL, "账号或密码错误");
        }
        loginUser.setToken(createToken());
        service.updateUser(loginUser);
        return new APIResponse(ResponeCode.SUCCESS, "登录成功", loginUser);
    }

    /**
     * 注册（注册出来的都是普通用户 role = 1）
     */
    @RequestMapping(value = "/register", method = RequestMethod.POST)
    @Transactional
    public APIResponse register(User user) {
        if (StringUtils.isBlank(user.getUsername()) || StringUtils.isBlank(user.getPassword())) {
            return new APIResponse(ResponeCode.FAIL, "账号和密码不能为空");
        }
        if (!user.getPassword().equals(user.getRePassword())) {
            return new APIResponse(ResponeCode.FAIL, "两次输入的密码不一致");
        }
        if (service.getUserByUserName(user.getUsername()) != null) {
            return new APIResponse(ResponeCode.FAIL, "该账号已被注册");
        }

        user.setRole(String.valueOf(User.NormalUser));   // 1：普通用户
        user.setStatus("0");                             // 0：正常
        user.setScore("0");
        user.setToken(createToken());
        user.setCreateTime(String.valueOf(System.currentTimeMillis()));
        service.createUser(user);

        return new APIResponse(ResponeCode.SUCCESS, "注册成功");
    }

    /**
     * 用户详情
     */
    @RequestMapping(value = "/detail", method = RequestMethod.GET)
    public APIResponse detail(String userId) {
        if (StringUtils.isBlank(userId)) {
            return new APIResponse(ResponeCode.FAIL, "缺少 userId 参数");
        }
        User user = service.getUserDetail(userId);
        return new APIResponse(ResponeCode.SUCCESS, "查询成功", user);
    }

    /**
     * 修改个人资料（昵称、邮箱、手机、简介、头像）
     */
    @RequestMapping(value = "/updateUserInfo", method = RequestMethod.POST)
    @Transactional
    public APIResponse updateUserInfo(User user) throws IOException {
        if (StringUtils.isBlank(user.getId())) {
            return new APIResponse(ResponeCode.FAIL, "缺少用户 id");
        }
        String avatar = saveAvatar(user);
        if (StringUtils.isNotBlank(avatar)) {
            user.setAvatar(avatar);
        }
        service.updateUser(user);
        return new APIResponse(ResponeCode.SUCCESS, "更新成功");
    }

    /**
     * 修改密码（要先校验原密码）
     */
    @RequestMapping(value = "/updateUserPwd", method = RequestMethod.POST)
    @Transactional
    public APIResponse updateUserPwd(String userId, String password, String newPassword) {
        if (StringUtils.isBlank(userId) || StringUtils.isBlank(password) || StringUtils.isBlank(newPassword)) {
            return new APIResponse(ResponeCode.FAIL, "参数不能为空");
        }
        User user = service.getUserDetail(userId);
        if (user == null) {
            return new APIResponse(ResponeCode.FAIL, "用户不存在");
        }
        if (!password.equals(user.getPassword())) {
            return new APIResponse(ResponeCode.FAIL, "原密码不正确");
        }
        // 只更新密码这一个字段，其它字段保持原样
        User update = new User();
        update.setId(userId);
        update.setPassword(newPassword);
        service.updateUser(update);
        return new APIResponse(ResponeCode.SUCCESS, "密码修改成功");
    }

    /**
     * 后台：用户列表
     */
    @Access(level = AccessLevel.ADMIN)
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public APIResponse list(String keyword) {
        List<User> list = service.getUserList(keyword);
        return new APIResponse(ResponeCode.SUCCESS, "查询成功", list);
    }

    /**
     * 后台：新增用户
     */
    @Access(level = AccessLevel.ADMIN)
    @RequestMapping(value = "/create", method = RequestMethod.POST)
    @Transactional
    public APIResponse create(User user) throws IOException {
        if (StringUtils.isBlank(user.getUsername()) || StringUtils.isBlank(user.getPassword())) {
            return new APIResponse(ResponeCode.FAIL, "账号和密码不能为空");
        }
        if (service.getUserByUserName(user.getUsername()) != null) {
            return new APIResponse(ResponeCode.FAIL, "该账号已存在");
        }
        String avatar = saveAvatar(user);
        if (StringUtils.isNotBlank(avatar)) {
            user.setAvatar(avatar);
        }
        if (StringUtils.isBlank(user.getStatus())) {
            user.setStatus("0");
        }
        if (StringUtils.isBlank(user.getScore())) {
            user.setScore("0");
        }
        user.setToken(createToken());
        user.setCreateTime(String.valueOf(System.currentTimeMillis()));
        service.createUser(user);
        return new APIResponse(ResponeCode.SUCCESS, "创建成功");
    }

    /**
     * 后台：编辑用户
     */
    @Access(level = AccessLevel.ADMIN)
    @RequestMapping(value = "/update", method = RequestMethod.POST)
    @Transactional
    public APIResponse update(User user) throws IOException {
        if (StringUtils.isBlank(user.getId())) {
            return new APIResponse(ResponeCode.FAIL, "缺少用户 id");
        }
        String avatar = saveAvatar(user);
        if (StringUtils.isNotBlank(avatar)) {
            user.setAvatar(avatar);
        }
        service.updateUser(user);
        return new APIResponse(ResponeCode.SUCCESS, "更新成功");
    }

    /**
     * 后台：删除用户（支持逗号分隔的批量删除）
     */
    @Access(level = AccessLevel.ADMIN)
    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    public APIResponse delete(String ids) {
        if (StringUtils.isBlank(ids)) {
            return new APIResponse(ResponeCode.FAIL, "缺少 ids 参数");
        }
        String[] arr = ids.split(",");
        for (String id : arr) {
            service.deleteUser(id);
        }
        return new APIResponse(ResponeCode.SUCCESS, "删除成功");
    }

    /**
     * 生成一个随机 token
     */
    private String createToken() {
        return UUID.randomUUID().toString().replace("-", "");
    }

    /**
     * 保存头像文件，返回新文件名（没有上传文件时返回 null）
     */
    private String saveAvatar(User user) throws IOException {
        MultipartFile file = user.getAvatarFile();
        if (file == null || file.isEmpty()) {
            return null;
        }
        String oldFileName = file.getOriginalFilename();
        String newFileName = UUID.randomUUID().toString() + oldFileName.substring(oldFileName.lastIndexOf("."));
        String filePath = uploadPath + File.separator + "avatar" + File.separator + newFileName;
        File destFile = new File(filePath);
        if (!destFile.getParentFile().exists()) {
            destFile.getParentFile().mkdirs();
        }
        file.transferTo(destFile);
        return newFileName;
    }
}
