import { get, post } from '/@/utils/http/axios';

const URL = {
  login: '/api/user/login',
  userLogin: '/api/user/userLogin',
  register: '/api/user/register',
  detail: '/api/user/detail',
  updateUserInfo: '/api/user/updateUserInfo',
  updateUserPwd: '/api/user/updateUserPwd',
  list: '/api/user/list',
  create: '/api/user/create',
  update: '/api/user/update',
  delete: '/api/user/delete',
};

// 管理员登录
const loginApi = async (data) =>
  post({ url: URL.login, params: {}, data: data, headers: { 'Content-Type': 'multipart/form-data;charset=utf-8' } });

// 普通用户登录
const userLoginApi = async (data) =>
  post({ url: URL.userLogin, params: {}, data: data, headers: { 'Content-Type': 'multipart/form-data;charset=utf-8' } });

// 注册
const userRegisterApi = async (data) =>
  post({ url: URL.register, params: {}, data: data, headers: { 'Content-Type': 'multipart/form-data;charset=utf-8' } });

// 用户详情
const detailApi = async (params) => get({ url: URL.detail, params: params, data: {}, headers: {} });

// 修改个人资料（里面可能带头像文件 avatarFile）
const updateUserInfoApi = async (data) =>
  post({
    url: URL.updateUserInfo,
    params: {},
    data: data,
    headers: { 'Content-Type': 'multipart/form-data;charset=utf-8' },
  });

// 修改密码
const updateUserPwdApi = async (data) =>
  post({
    url: URL.updateUserPwd,
    params: {},
    data: data,
    headers: { 'Content-Type': 'multipart/form-data;charset=utf-8' },
  });

// 后台：用户列表
const listApi = async (params) => get({ url: URL.list, params: params, data: {}, headers: {} });

// 后台：新增用户
const createApi = async (data) =>
  post({ url: URL.create, params: {}, data: data, headers: { 'Content-Type': 'multipart/form-data;charset=utf-8' } });

// 后台：编辑用户
const updateApi = async (data) =>
  post({ url: URL.update, data: data, headers: { 'Content-Type': 'multipart/form-data;charset=utf-8' } });

// 后台：删除用户
const deleteApi = async (params) => post({ url: URL.delete, params: params, headers: {} });

export {
  loginApi,
  userLoginApi,
  userRegisterApi,
  detailApi,
  updateUserInfoApi,
  updateUserPwdApi,
  listApi,
  createApi,
  updateApi,
  deleteApi,
};
