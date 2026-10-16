import { get, post } from '/@/utils/http/axios';

const URL = {
  // 操作日志
  opLogList: '/api/opLog/list',
  clearOpLog: '/api/opLog/clearOpLog',
  // 登录日志
  loginLogList: '/api/opLog/loginLogList',
  clearLoginLog: '/api/opLog/clearLoginLog',
  // 错误日志
  errorLogList: '/api/errorLog/list',
  clearErrorLog: '/api/errorLog/clearErrorLog',
};

// 操作日志列表
const listOpLogListApi = async (params) => get({ url: URL.opLogList, params: params, data: {}, headers: {} });

// 清空操作日志
const clearOpLogListApi = async (params) => post({ url: URL.clearOpLog, params: params, headers: {} });

// 登录日志列表
const listLoginLogApi = async (params) => get({ url: URL.loginLogList, params: params, data: {}, headers: {} });

// 清空登录日志
const clearLoginLogApi = async (params) => post({ url: URL.clearLoginLog, params: params, headers: {} });

// 错误日志列表
const listErrorLogListApi = async (params) => get({ url: URL.errorLogList, params: params, data: {}, headers: {} });

// 清空错误日志
const clearErrorLogListApi = async (params) => post({ url: URL.clearErrorLog, params: params, headers: {} });

export {
  listOpLogListApi,
  clearOpLogListApi,
  listLoginLogApi,
  clearLoginLogApi,
  listErrorLogListApi,
  clearErrorLogListApi,
};
