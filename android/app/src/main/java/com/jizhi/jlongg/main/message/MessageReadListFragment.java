package com.jizhi.jlongg.main.message;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.ReadInfoAdapter;
import com.jizhi.jlongg.main.bean.ReadUserInfoBean;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.liaoinstan.springview.container.DefaultFooter;
import com.liaoinstan.springview.container.DefaultHeader;
import com.liaoinstan.springview.widget.SpringView;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

/**
 * CName: 消息已读列表
 * User: hcs
 * Date: 2016-08-25
 * Time: 14:23
 */
public class MessageReadListFragment extends Fragment {
    private SpringView springView;
    private ListView listView;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View main_view = inflater.inflate(R.layout.fragment_msg_read_list, container, false);
        return main_view;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        initView();
    }

    /**
     * 初始化View
     */
    public void initView() {
        listView = getView().findViewById(R.id.listView);
        springView = getView().findViewById(R.id.springview);
        springView.setType(SpringView.Type.FOLLOW);
        springView.setEnableFooter(true);
        springView.setHeader(new DefaultHeader(getActivity()));
        springView.setFooter(new DefaultFooter(getActivity()));
        springView.callFreshDelay();
        springView.setListener(new SpringView.OnFreshListener() {
            @Override
            public void onRefresh() {
                getGroupMenberByMessage();
            }

            @Override
            public void onLoadmore() {
            }
        });
    }

    /**
     * 发布记账
     */
    public void getGroupMenberByMessage() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
        params.addBodyParameter(MessageType.MSG_ID, ((MessageReadInfoListActivity) getActivity()).msg_id);
        params.addBodyParameter(MessageType.GROUP_ID, ((MessageReadInfoListActivity) getActivity()).gnInfo.getGroup_id());
        params.addBodyParameter(MessageType.CLASS_TYPE, ((MessageReadInfoListActivity) getActivity()).gnInfo.getClass_type());
        params.addBodyParameter(MessageType.TYPE, "readed");
        String url = (((MessageReadInfoListActivity) getActivity()).isMsg) ? NetWorkRequest.GET_GROUP_MEMBER_BY_MESSAGE : NetWorkRequest.GET_TYPE_MEMBER_BY_MESSAGE;
        http.send(HttpRequest.HttpMethod.POST, url, params, new RequestCallBack<String>() {
            @Override
            public void onFailure(HttpException e, String s) {
                springView.onFinishFreshAndLoad();
            }

            @Override
            public void onSuccess(ResponseInfo responseInfo) {
                try {
                    CommonJson<ReadUserInfoBean> bean = CommonJson.fromJson(responseInfo.result.toString(), ReadUserInfoBean.class);
                    if (bean.getMsg().equals(Constance.SUCCES_S)) {
                        ReadInfoAdapter readInfoAdapter = new ReadInfoAdapter(getActivity(), bean.getResult().getList());
                        listView.setAdapter(readInfoAdapter);
                    } else {
                        DataUtil.showErrOrMsg(getActivity(), bean.getCode(), bean.getMsg());
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(getActivity(), getString(R.string.service_err), CommonMethod.ERROR);
                    springView.onFinishFreshAndLoad();
                } finally {
                    springView.onFinishFreshAndLoad();
                }
            }

        });
    }
}