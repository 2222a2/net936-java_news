import { get, post } from '/@/utils/http/axios';

const URL = {
  list: '/api/ad/list',
  create: '/api/ad/create',
  update: '/api/ad/update',
  delete: '/api/ad/delete',
};

// 广告列表（后台广告页、新闻详情页右侧都用）
const listApi = async (params) => get({ url: URL.list, params: params, data: {}, headers: {} });

// 新增广告（传的是 FormData，里面含图片文件 imageFile）
const createApi = async (data) =>
  post({ url: URL.create, params: {}, data: data, headers: { 'Content-Type': 'multipart/form-data;charset=utf-8' } });

// 编辑广告
const updateApi = async (data) =>
  post({ url: URL.update, data: data, headers: { 'Content-Type': 'multipart/form-data;charset=utf-8' } });

// 删除广告
const deleteApi = async (params) => post({ url: URL.delete, params: params, headers: {} });

export { listApi, createApi, updateApi, deleteApi };
