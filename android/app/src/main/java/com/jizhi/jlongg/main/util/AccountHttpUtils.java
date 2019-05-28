package com.jizhi.jlongg.main.util;

import android.content.Intent;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.AddProjectActivity;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.List;

/**
 * 功能: 记账相关的查询
 * 作者：xuj
 * 时间: 2017年9月30日11:10:03
 */
public class AccountHttpUtils {

    /**
     * 与我相关的项目
     *
     * @param mActivity
     * @param listener
     * @param isAddPro  是否是新增项目
     */
    public static void IRelatedProjects(final BaseActivity mActivity, final AccountIRelatedListener listener, final boolean isAddPro) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(mActivity);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.QUERYPRO, params, mActivity.new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonListJson<Project> base = CommonListJson.fromJson(responseInfo.result, Project.class);
                    if (base.getState() != 0) {
                        if (base.getValues() != null && base.getValues().size() > 0) {
                            listener.IRelatedProjectsSuccess(base.getValues());
                        } else {
                            if (isAddPro) {
                                Intent intent = new Intent(mActivity, AddProjectActivity.class);
                                mActivity.startActivityForResult(intent, Constance.REQUESTWORKERS);
                            } else {
                                CommonMethod.makeNoticeLong(mActivity, "暂无可用的项目", CommonMethod.ERROR);
                            }
                        }
                    } else {
                        DataUtil.showErrOrMsg(mActivity, base.getErrno(), base.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(mActivity, mActivity.getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    mActivity.closeDialog();
                }
            }
        });
    }


    public interface AccountIRelatedListener {
        public void IRelatedProjectsSuccess(List<Project> list);
    }
}
