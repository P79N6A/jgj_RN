package com.jizhi.jlongg.main.util;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.BaseCheckInfo;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.CheckContent;
import com.jizhi.jlongg.main.bean.CheckHomePageInfo;
import com.jizhi.jlongg.main.bean.CheckList;
import com.jizhi.jlongg.main.bean.CheckPlanListBean;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

/**
 * 检查项Http请求工具
 */

public class CheckListHttpUtils {


    /**
     * 新增检查内容
     *
     * @param groupId         项目组id
     * @param classType       项目组类型
     * @param contentName     检查内容名称
     * @param dotsContentJson 检查点（json格式），数组格式如：array（array（’dot_id’=>1,’dot_name’=>’检查点名’），array（’dot_id’=>0,’dot_name’=>’检查点名’））
     */
    public static void addCheckContent(final BaseActivity activity, String groupId, String classType, String contentName, String dotsContentJson, final CommonRequestCallBack callBackListener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", classType);
        params.addBodyParameter("content_name", contentName);
        params.addBodyParameter("dots_content", dotsContentJson);
        params.addBodyParameter("is_object", "1"); //是否返回 检查内容对象
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.ADD_CHECK_CONTENT, params, activity.new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<CheckContent> base = CommonJson.fromJson(responseInfo.result, CheckContent.class);
                    if (base.getState() != 0) {
                        if (callBackListener != null) {
                            callBackListener.onSuccess(base.getValues());
                        }
                    } else {
                        DataUtil.showErrOrMsg(activity, base.getErrno(), base.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    activity.closeDialog();
                }
            }
        });
    }

    /**
     * 修改检查内容
     *
     * @param contentId       检查项目内容id
     * @param contentName     检查内容名称
     * @param dotsContentJson 检查点（json格式），数组格式如：array（array（’dot_id’=>1,’dot_name’=>’检查点名’），array（’dot_id’=>0,’dot_name’=>’检查点名’））
     */
    public static void updateCheckContent(final BaseActivity activity, int contentId, String contentName, String dotsContentJson, final CommonRequestCallBack callBackListener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("content_id", contentId + "");
        params.addBodyParameter("content_name", contentName);
        params.addBodyParameter("dots_content", dotsContentJson);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.UPDATE_CHECK_CONTENT, params, activity.new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<BaseNetBean> base = CommonJson.fromJson(responseInfo.result, BaseNetBean.class);
                    if (base.getState() != 0) {
                        if (callBackListener != null) {
                            callBackListener.onSuccess(base.getValues());
                        }
                    } else {
                        DataUtil.showErrOrMsg(activity, base.getErrno(), base.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    activity.closeDialog();
                }
            }
        });
    }

    /**
     * 修改检查项
     *
     * @param proId         检查项ids
     * @param checkListName 检查项名称
     * @param locationText  检查项位置
     * @param contentIds    检查内容ids
     */
    public static void updateCheckList(final BaseActivity activity, int proId, String checkListName, String locationText, String contentIds, final CommonRequestCallBack callBackListener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("pro_id", proId + "");
        params.addBodyParameter("pro_name", checkListName);
        params.addBodyParameter("location_text", locationText);
        params.addBodyParameter("content_ids", contentIds);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.UPDATE_CHECK_LIST, params, activity.new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<BaseNetBean> base = CommonJson.fromJson(responseInfo.result, BaseNetBean.class);
                    if (base.getState() != 0) {
                        if (callBackListener != null) {
                            callBackListener.onSuccess(base.getValues());
                        }
                    } else {
                        DataUtil.showErrOrMsg(activity, base.getErrno(), base.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    activity.closeDialog();
                }
            }
        });
    }

    /**
     * 获取检查项列表
     *
     * @param context
     * @param groupId          项目组id
     * @param classType        项目组类型
     * @param type             检查项pro,检查内容content
     * @param callBackListener 加载回调
     */
    public static void getInspecProList(final BaseActivity context, String groupId, String classType, int pageNum, String type, final CommonRequestCallBack callBackListener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(context);
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", classType);
        params.addBodyParameter("type", type);
        params.addBodyParameter("pg", pageNum + "");
        params.addBodyParameter("pagesize", RepositoryUtil.DEFAULT_PAGE_SIZE + ""); //一页显示多少条数据
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GETINSPECTPROORCONTENT, params, new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<BaseCheckInfo> base = CommonJson.fromJson(responseInfo.result, BaseCheckInfo.class);
                            if (base.getState() != 0) {
                                if (callBackListener != null) {
                                    callBackListener.onSuccess(base.getValues());
                                }
                            } else {
                                DataUtil.showErrOrMsg(context, base.getErrno(), base.getErrmsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(context, context.getString(R.string.service_err), CommonMethod.ERROR);
                            if (callBackListener != null) {
                                callBackListener.onFailure(null, null);
                            }
                        }
                    }

                    @Override
                    public void onFailure(HttpException e, String s) {
                        CommonMethod.makeNoticeShort(context, context.getString(R.string.service_err), CommonMethod.ERROR);
                        if (callBackListener != null) {
                            callBackListener.onFailure(e, s);
                        }
                    }
                }
        );
    }


    /**
     * 删除检查项内容
     *
     * @param activity
     * @param contentId        内容详情id
     * @param callBackListener 加载回调
     */
    public static void deleteCheckContent(final BaseActivity activity, int contentId, final CommonRequestCallBack callBackListener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("content_id", contentId + "");
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.DELETE_CHECK_CONTENT, params, activity.new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<BaseNetBean> base = CommonJson.fromJson(responseInfo.result, BaseNetBean.class);
                            if (base.getState() != 0) {
                                if (callBackListener != null) {
                                    callBackListener.onSuccess(base.getValues());
                                }
                            } else {
                                DataUtil.showErrOrMsg(activity, base.getErrno(), base.getErrmsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                        } finally {
                            activity.closeDialog();
                        }
                    }

                    @Override
                    public void onFailure(HttpException e, String s) {
                        super.onFailure(e, s);
                        if (callBackListener != null) {
                            callBackListener.onFailure(e, s);
                        }
                    }
                }
        );
    }

    /**
     * 删除检查项内容
     *
     * @param activity
     * @param proId            检查项id
     * @param callBackListener 加载回调
     */
    public static void deleteCheckList(final BaseActivity activity, int proId, final CommonRequestCallBack callBackListener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("pro_id", proId + "");
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.DELETE_CHECK_LIST, params, activity.new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<BaseNetBean> base = CommonJson.fromJson(responseInfo.result, BaseNetBean.class);
                            if (base.getState() != 0) {
                                if (callBackListener != null) {
                                    callBackListener.onSuccess(base.getValues());
                                }
                            } else {
                                DataUtil.showErrOrMsg(activity, base.getErrno(), base.getErrmsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                        } finally {
                            activity.closeDialog();
                        }
                    }

                    @Override
                    public void onFailure(HttpException e, String s) {
                        super.onFailure(e, s);
                        if (callBackListener != null) {
                            callBackListener.onFailure(e, s);
                        }
                    }
                }
        );
    }


    /**
     * 获取检查项首页数据
     *
     * @param activity
     * @param groupId          项目组id
     * @param classType        项目组类型
     * @param callBackListener 加载回调
     */
    public static void getCheckListHomePageData(final BaseActivity activity, String groupId, String classType, final CommonRequestCallBack callBackListener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", classType);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_CHECK_CONTENT_HOME_PAGE_DATA, params, activity.new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<CheckHomePageInfo> base = CommonJson.fromJson(responseInfo.result, CheckHomePageInfo.class);
                            if (base.getState() != 0) {
                                if (callBackListener != null) {
                                    callBackListener.onSuccess(base.getValues());
                                }
                            } else {
                                DataUtil.showErrOrMsg(activity, base.getErrno(), base.getErrmsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                        } finally {
                            activity.closeDialog();
                        }
                    }

                    @Override
                    public void onFailure(HttpException e, String s) {
                        super.onFailure(e, s);
                        if (callBackListener != null) {
                            callBackListener.onFailure(e, s);
                        }
                    }
                }
        );
    }

    /**
     * 获取检查内容详情
     *
     * @param activity
     * @param contentId        内容详情id
     * @param callBackListener 加载回调
     */
    public static void getCheckContentDetail(final BaseActivity activity, int contentId, final CommonRequestCallBack callBackListener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("content_id", contentId + "");
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_CHECK_CONTENT_DETAIL, params, activity.new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<CheckContent> base = CommonJson.fromJson(responseInfo.result, CheckContent.class);
                            if (base.getState() != 0) {
                                if (callBackListener != null) {
                                    callBackListener.onSuccess(base.getValues());
                                }
                            } else {
                                DataUtil.showErrOrMsg(activity, base.getErrno(), base.getErrmsg());
                                if (callBackListener != null) {
                                    callBackListener.onFailure(null, null);
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                            if (callBackListener != null) {
                                callBackListener.onFailure(null, null);
                            }
                        } finally {
                            activity.closeDialog();
                        }
                    }

                    @Override
                    public void onFailure(HttpException e, String s) {
                        super.onFailure(e, s);
                        if (callBackListener != null) {
                            callBackListener.onFailure(e, s);
                        }
                    }
                }
        );
    }

    /**
     * 获取检查项详情
     *
     * @param activity
     * @param proId            检查项id
     * @param callBackListener 加载回调
     */
    public static void getCheckListDetail(final BaseActivity activity, int proId, final CommonRequestCallBack callBackListener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("pro_id", proId + "");
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_CHECK_LIST_DETAIL, params, activity.new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<CheckList> base = CommonJson.fromJson(responseInfo.result, CheckList.class);
                            if (base.getState() != 0) {
                                if (callBackListener != null) {
                                    callBackListener.onSuccess(base.getValues());
                                }
                            } else {
                                DataUtil.showErrOrMsg(activity, base.getErrno(), base.getErrmsg());
                                if (callBackListener != null) {
                                    callBackListener.onFailure(null, null);
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                            if (callBackListener != null) {
                                callBackListener.onFailure(null, null);
                            }
                        } finally {
                            activity.closeDialog();
                        }
                    }

                    @Override
                    public void onFailure(HttpException e, String s) {
                        super.onFailure(e, s);
                        if (callBackListener != null) {
                            callBackListener.onFailure(e, s);
                        }
                    }
                }
        );
    }

    /**
     * 添加检查项
     *
     * @param activity
     * @param groupId          项目组id
     * @param classType        项目组类型
     * @param proName          检查项内容
     * @param locationText     地址
     * @param contentIds       检查内容id,以‘，’隔开
     * @param callBackListener 加载回调
     */
    public static void addCheckList(final BaseActivity activity, String groupId, String classType, String proName, String locationText, String contentIds, final CommonRequestCallBack callBackListener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("class_type", classType);
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("pro_name", proName);
        params.addBodyParameter("location_text", locationText);
        params.addBodyParameter("content_ids", contentIds);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.ADD_CHECK_LIST, params, activity.new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<BaseNetBean> base = CommonJson.fromJson(responseInfo.result, BaseNetBean.class);
                            if (base.getState() != 0) {
                                if (callBackListener != null) {
                                    callBackListener.onSuccess(base.getValues());
                                }
                            } else {
                                DataUtil.showErrOrMsg(activity, base.getErrno(), base.getErrmsg());
                                if (callBackListener != null) {
                                    callBackListener.onFailure(null, null);
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                            if (callBackListener != null) {
                                callBackListener.onFailure(null, null);
                            }
                        } finally {
                            activity.closeDialog();
                        }
                    }

                    @Override
                    public void onFailure(HttpException e, String s) {
                        super.onFailure(e, s);
                        if (callBackListener != null) {
                            callBackListener.onFailure(e, s);
                        }
                    }
                }
        );
    }

    /**
     * 修改检查计划
     *
     * @param activity
     * @param planId           检查计划id
     * @param planName         检查计划名称
     * @param uids             执行人uid，‘，’隔开
     * @param executeTime      执行时间 ‘2017-11-25 18:39’
     * @param proIds           检查项，‘，’隔开
     * @param callBackListener 加载回调
     */
    public static void updateCheckPlan(final BaseActivity activity, int planId, String planName, String uids, String executeTime, String proIds, final CommonRequestCallBack callBackListener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("plan_id", planId + ""); //检查计划id
        params.addBodyParameter("plan_name", planName); //检查计划名称
        params.addBodyParameter("uids", uids); //执行人uid，‘，’隔开
        params.addBodyParameter("execute_time", executeTime); //	执行时间 ‘2017-11-25 18:39’
        params.addBodyParameter("pro_ids", proIds); //	检查项，‘，’隔开
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.UPDATE_CHECK_PLAN, params, activity.new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<BaseNetBean> base = CommonJson.fromJson(responseInfo.result, BaseNetBean.class);
                            if (base.getState() != 0) {
                                if (callBackListener != null) {
                                    callBackListener.onSuccess(base.getValues());
                                }
                            } else {
                                DataUtil.showErrOrMsg(activity, base.getErrno(), base.getErrmsg());
                                if (callBackListener != null) {
                                    callBackListener.onFailure(null, null);
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                            if (callBackListener != null) {
                                callBackListener.onFailure(null, null);
                            }
                        } finally {
                            activity.closeDialog();
                        }
                    }

                    @Override
                    public void onFailure(HttpException e, String s) {
                        super.onFailure(e, s);
                        if (callBackListener != null) {
                            callBackListener.onFailure(e, s);
                        }
                    }
                }
        );
    }


    /**
     * 获取检查计划详情
     *
     * @param activity
     * @param planId           检查计划id
     * @param callBackListener 加载回调
     */
    public static void getCheckPlanDetail(final BaseActivity activity, int planId, final CommonRequestCallBack callBackListener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("plan_id", planId + ""); //检查计划id
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_INSPECTPLAN_INFO, params, activity.new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<CheckPlanListBean> base = CommonJson.fromJson(responseInfo.result, CheckPlanListBean.class);
                            if (base.getState() != 0) {
                                if (callBackListener != null) {
                                    callBackListener.onSuccess(base.getValues());
                                }
                            } else {
                                DataUtil.showErrOrMsg(activity, base.getErrno(), base.getErrmsg());
                                if (callBackListener != null) {
                                    callBackListener.onFailure(null, null);
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                            if (callBackListener != null) {
                                callBackListener.onFailure(null, null);
                            }
                        } finally {
                            activity.closeDialog();
                        }
                    }

                    @Override
                    public void onFailure(HttpException e, String s) {
                        super.onFailure(e, s);
                        if (callBackListener != null) {
                            callBackListener.onFailure(e, s);
                        }
                    }
                }
        );
    }

    /**
     * 获取检查项内容列表
     *
     * @param activity
     * @param groupId          项目组id
     * @param contentIds       已选的检查内容id,’,’隔开
     * @param callBackListener 加载回调
     */
    public static void getCheckListContentList(final BaseActivity activity, String groupId, String classType, String contentIds, final CommonRequestCallBack callBackListener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", classType);
        params.addBodyParameter("content_ids", contentIds);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_CHECK_LIST_CONTENT_LIST, params, activity.new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonListJson<CheckContent> base = CommonListJson.fromJson(responseInfo.result, CheckContent.class);
                            if (base.getState() != 0) {
                                if (callBackListener != null) {
                                    callBackListener.onSuccess(base.getValues());
                                }
                            } else {
                                DataUtil.showErrOrMsg(activity, base.getErrno(), base.getErrmsg());
                                if (callBackListener != null) {
                                    callBackListener.onFailure(null, null);
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                            if (callBackListener != null) {
                                callBackListener.onFailure(null, null);
                            }
                        } finally {
                            activity.closeDialog();
                        }
                    }

                    @Override
                    public void onFailure(HttpException e, String s) {
                        super.onFailure(e, s);
                        if (callBackListener != null) {
                            callBackListener.onFailure(e, s);
                        }
                    }
                }
        );
    }

    /**
     * 添加检查计划
     *
     * @param activity
     * @param groupId          项目组id
     * @param classType        项目组类型
     * @param uids             成员uid,以‘，’隔开
     * @param proIds           检查项id,以‘，’隔开
     * @param planName         计划名称
     * @param executeTime      执行时间 ‘2017-11-12 14：20’
     * @param callBackListener 加载回调
     */
    public static void addCheckPlan(final BaseActivity activity, String groupId, String classType, String uids, String proIds, String planName, String executeTime,
                                    final CommonRequestCallBack callBackListener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("class_type", classType);
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("uids", uids);
        params.addBodyParameter("pro_ids", proIds);
        params.addBodyParameter("plan_name", planName);
        params.addBodyParameter("execute_time", executeTime);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.ADD_CHECK_PLAN, params, activity.new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<BaseNetBean> base = CommonJson.fromJson(responseInfo.result, BaseNetBean.class);
                            if (base.getState() != 0) {
                                if (callBackListener != null) {
                                    callBackListener.onSuccess(base.getValues());
                                }
                            } else {
                                DataUtil.showErrOrMsg(activity, base.getErrno(), base.getErrmsg());
                                if (callBackListener != null) {
                                    callBackListener.onFailure(null, null);
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                            if (callBackListener != null) {
                                callBackListener.onFailure(null, null);
                            }
                        } finally {
                            activity.closeDialog();
                        }
                    }

                    @Override
                    public void onFailure(HttpException e, String s) {
                        super.onFailure(e, s);
                        if (callBackListener != null) {
                            callBackListener.onFailure(e, s);
                        }
                    }
                }
        );
    }


    /**
     * 检查项列表
     *
     * @param activity
     * @param groupId          项目组id
     * @param proIds           检查项目id,以‘,’隔开
     * @param callBackListener 加载回调
     */
    public static void getCheckList(final BaseActivity activity, String groupId, String classType, String proIds, final CommonRequestCallBack callBackListener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("group_id", groupId);
        params.addBodyParameter("class_type", classType);
        params.addBodyParameter("pro_ids", proIds);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.CHECK_LIST, params, activity.new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonListJson<CheckList> base = CommonListJson.fromJson(responseInfo.result, CheckList.class);
                            if (base.getState() != 0) {
                                if (callBackListener != null) {
                                    callBackListener.onSuccess(base.getValues());
                                }
                            } else {
                                DataUtil.showErrOrMsg(activity, base.getErrno(), base.getErrmsg());
                                if (callBackListener != null) {
                                    callBackListener.onFailure(null, null);
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                            if (callBackListener != null) {
                                callBackListener.onFailure(null, null);
                            }
                        } finally {
                            activity.closeDialog();
                        }
                    }

                    @Override
                    public void onFailure(HttpException e, String s) {
                        super.onFailure(e, s);
                        if (callBackListener != null) {
                            callBackListener.onFailure(e, s);
                        }
                    }
                }
        );
    }


    /**
     * 数据加载成功后的回调函数
     */
    public interface CommonRequestCallBack {

        public void onSuccess(Object checkPlan);

        public void onFailure(HttpException e, String s);

    }


}
