package com.jizhi.jlongg.main.fragment;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.dialog.CustomProgress;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

/**
 * 功能:Fragment 父类
 * 作者：xuj
 * 时间: 2016-8-17 16:10
 */
public abstract class BaseFragment extends Fragment {

    /**
     * 加载对话框
     */
    public CustomProgress customProgress;
    /**
     * 键盘管理
     */
    protected InputMethodManager inputMethodManager;
    /**
     * dialog显示文字
     */
    private String string_for_dialog;

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        inputMethodManager = (InputMethodManager) getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
    }

    protected void hideSoftKeyboard() {
        if (getActivity().getWindow().getAttributes().softInputMode != WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN) {
            if (getActivity().getCurrentFocus() != null)
                inputMethodManager.hideSoftInputFromWindow(getActivity().getCurrentFocus().getWindowToken(),
                        InputMethodManager.HIDE_NOT_ALWAYS);
        }
    }

    /**
     *
     */
    public abstract void initFragmentData();

    /**
     * 打印网络连接错误信息
     */
    public void printNetLog(String msg, Activity activity) {
        StringBuffer sb = new StringBuffer();
        sb.append(getString(R.string.conn_fail));
        CommonMethod.makeNoticeShort(activity, sb.toString(), CommonMethod.ERROR);
    }

    public void closeDialog() {
        if (null != customProgress) {
            customProgress.closeDialog();
            customProgress = null;
        }
    }


    public void setString_for_dialog(String string_for_dialog) {
        this.string_for_dialog = string_for_dialog;
    }



    public abstract class RequestCallBackExpand<T> extends RequestCallBack<String> {

        public RequestCallBackExpand() {
            customProgress = new CustomProgress(getActivity());
            customProgress.show(getActivity(), string_for_dialog, false);
        }

        public RequestCallBackExpand(boolean isLoadDialog) {

        }


        public void sendRequest(String url, RequestCallBackExpand request, RequestParams pamas, String showMessage) {
            string_for_dialog = showMessage;
            customProgress = new CustomProgress(getActivity());
            customProgress.show(getActivity(), string_for_dialog, false);
            HttpUtils http = SingsHttpUtils.getHttp();
            http.send(HttpRequest.HttpMethod.POST, url, pamas, request);
        }


        @Override
        public void onStart() {
            super.onStart();
        }

        /**
         * xutils 连接失败 调用的 方法
         */
        @Override
        public void onFailure(HttpException exception, String errormsg) {
            printNetLog(errormsg, getActivity());
            closeDialog();
        }
    }




}