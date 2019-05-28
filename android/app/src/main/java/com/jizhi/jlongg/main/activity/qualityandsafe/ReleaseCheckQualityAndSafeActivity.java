package com.jizhi.jlongg.main.activity.qualityandsafe;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Html;
import android.text.TextUtils;
import android.view.View;
import android.widget.CheckBox;
import android.widget.ListView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.ReleaseProjecPeopleActivity;
import com.jizhi.jlongg.main.activity.ReleaseQualityAndSafeActivity;
import com.jizhi.jlongg.main.adpter.QualityAndSafeInspeceAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.InspectQualityList;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.List;


/**
 * CName:发检查计划 2.3.0
 * User: hcs
 * Date: 2017-07-13
 * Time: 11:40
 */

public class ReleaseCheckQualityAndSafeActivity extends BaseActivity implements View.OnClickListener, QualityAndSafeInspeceAdapter.OnCheckChangeListener {
    private ReleaseCheckQualityAndSafeActivity mActivity;
    private TextView tv_name;
    //组信息
    private GroupDiscussionInfo gnInfo;
    //执行检查人uid,名字
    private String people_uid, peopleStr;
    public static final String VALUE = "name";
    private QualityAndSafeInspeceAdapter adapter;
    //检查大项数据
    private List<InspectQualityList> allrow;
    private ListView listView;
    private CheckBox ck_check;
    private int selectCount;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_release_check_quality_and_safe);
        initView();
        getIntentData();
        getInspectQualityList();
    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        LUtils.e("-------------------:" + new Gson().toJson(gnInfo));
    }

    /**
     * 初始化View
     */
    public void initView() {
        mActivity = ReleaseCheckQualityAndSafeActivity.this;
        SetTitleName.setTitle(findViewById(R.id.title), getString(R.string.release_check));
        SetTitleName.setTitle(findViewById(R.id.right_title), "发布");
        String msgType = getIntent().getStringExtra(Constance.MSG_TYPE);
        if (msgType.equals(MessageType.MSG_QUALITY_STRING)) {
            ((TextView) findViewById(R.id.tv_default)).setText(Html.fromHtml("请在电脑浏览器上登录吉工宝<br/>" +
                    "www.jgongb.com,进入<font color='#d7252c'>[质量]</font>模块进行设置"));
        } else if (msgType.equals(MessageType.MSG_SAFE_STRING)) {
            ((TextView) findViewById(R.id.tv_default)).setText(Html.fromHtml("请在电脑浏览器上登录吉工宝<br/>" +
                    "www.jgongb.com,进入<font color='#d7252c'>[安全]</font>模块进行设置"));
        }


        tv_name = (TextView) findViewById(R.id.tv_name);
        listView = (ListView) findViewById(R.id.listView);
        ck_check = (CheckBox) findViewById(R.id.ck_check);
//        ck_check.setOnCheckedChangeListener(onCheckedChangeListener);
//        ck_check.setOnClickListener(ck_checkClick);
        setOnCheckBoxClick(ck_check, ck_check.isChecked());
        findViewById(R.id.rea_check_people).setOnClickListener(this);
        findViewById(R.id.right_title).setOnClickListener(this);
    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info, String msg_type) {
        Intent intent = new Intent(context, ReleaseCheckQualityAndSafeActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.MSG_TYPE, msg_type);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }

    /**
     * 检查大项全部选择监听
     */
    public void setOnCheckBoxClick(final CheckBox ck_check, final boolean isCheck) {
        ck_check.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (null == allrow || null == adapter) {
                    return;
                }
                for (int i = 0; i < allrow.size(); i++) {
                    if (allrow.get(i).getChild_num() > 0) {
                        allrow.get(i).setCheck(ck_check.isChecked());
                    }
                }
                adapter.notifyDataSetChanged();
            }
        });
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.rea_check_people:
                ReleaseProjecPeopleActivity.actionStart(mActivity, gnInfo, !TextUtils.isEmpty(people_uid) ? people_uid : "", ReleaseQualityAndSafeActivity.PROJECT_PEOPLE, "选择检查执行人");
                break;
            case R.id.right_title:
                if (Utils.isFastDoubleClick()) {
                    return;
                }
                if (selectCount <= 0) {
                    CommonMethod.makeNoticeShort(mActivity, "请至少选择一个检查大项", CommonMethod.ERROR);
                    return;
                }
                pubInspectQuality();
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUEST && resultCode == ReleaseQualityAndSafeActivity.PROJECT_PEOPLE) {
            //执行检查人
            if (!TextUtils.isEmpty(data.getStringExtra(VALUE))) {
                peopleStr = data.getStringExtra(VALUE);
                people_uid = data.getStringExtra(ReleaseProjecPeopleActivity.UID);
                ((TextView) findViewById(R.id.tv_name)).setText(peopleStr);
            }
        }
    }

    /**
     * 获取检查项信息列表
     */
    protected void getInspectQualityList() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("group_id", gnInfo.getGroup_id());
        params.addBodyParameter("class_type", gnInfo.getClass_type());
        params.addBodyParameter(Constance.MSG_TYPE, getIntent().getStringExtra(Constance.MSG_TYPE));
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_INSPECT_QUALITYLIST,
                params, new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<InspectQualityList> beans = CommonJson.fromJson(responseInfo.result, InspectQualityList.class);
                            if (beans.getState() != 0) {
                                allrow = beans.getValues().getAllrow();
                                people_uid = UclientApplication.getUid(mActivity);
                                peopleStr = beans.getValues().getReal_name();
                                ((TextView) findViewById(R.id.tv_name)).setText(peopleStr);
                            } else {
                                DataUtil.showErrOrMsg(mActivity, beans.getErrno(), beans.getErrmsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                        } finally {
                            closeDialog();
                            if (null != allrow && allrow.size() > 0) {
                                adapter = new QualityAndSafeInspeceAdapter(mActivity, allrow, mActivity);
                                listView.setAdapter(adapter);
                                listView.addFooterView(loadFooderView(), null, false);
                                findViewById(R.id.lin_message_def).setVisibility(View.GONE);
                                findViewById(R.id.lin_data).setVisibility(View.VISIBLE);
                            } else {
                                findViewById(R.id.lin_message_def).setVisibility(View.VISIBLE);
                                findViewById(R.id.lin_data).setVisibility(View.GONE);
                                findViewById(R.id.right_title).setVisibility(View.GONE);
                            }
                        }
                    }

                    /** xutils 连接失败 调用的 方法 */
                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                        finish();
                    }
                });


    }

    public View loadFooderView() {
        View foot_view = getLayoutInflater().inflate(R.layout.layout_fooder_view_hint, null); // 加载对话框
        TextView tv_fooder = (TextView) foot_view.findViewById(R.id.tv_fooder);
        foot_view.setVisibility(View.VISIBLE);
        String msgType = getIntent().getStringExtra(Constance.MSG_TYPE);
        //如需添加检查项
        if (msgType.equals(MessageType.MSG_QUALITY_STRING)) {
            tv_fooder.setText(Html.fromHtml("如需添加检查项,请在电脑浏览器上登录吉工宝<br/>" +
                    "www.jgongb.com,进入<font color='#d7252c'>[质量]</font>模块进行设置"));
        } else if (msgType.equals(MessageType.MSG_SAFE_STRING)) {
            tv_fooder.setText(Html.fromHtml("如需添加检查项,请在电脑浏览器上登录吉工宝<br/>" +
                    "www.jgongb.com,进入<font color='#d7252c'>[安全]</font>模块进行设置"));
        }


        return foot_view;
    }

    @Override
    public void checkChangeListener(boolean isCheck, int position) {
        allrow.get(position).setCheck(isCheck);
        adapter.notifyDataSetChanged();
//        isShowCheckAll();
        if (isCheck) {
            selectCount += 1;
        } else {
            selectCount -= 1;
        }
        if (selectCount <= 0) {
            SetTitleName.setTitle(findViewById(R.id.right_title), "发布");
            ck_check.setChecked(false);
        } else {
            SetTitleName.setTitle(findViewById(R.id.right_title), "发布(" + selectCount + ")");
            isCheckAll();
        }

    }

    public void isCheckAll() {
        int countAdd = 0;
        for (int i = 0; i < allrow.size(); i++) {
            if (allrow.get(i).getChild_num() > 0) {
                countAdd += 1;
            }

        }
        if (countAdd == selectCount) {
            ck_check.setChecked(true);
        } else {
            ck_check.setChecked(false);
        }
    }

    /**
     * 发布、修改检查项目计划
     */
    protected void pubInspectQuality() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("principal_uid", people_uid);
        params.addBodyParameter("group_id", gnInfo.getGroup_id());
        params.addBodyParameter("class_type", gnInfo.getClass_type());
        params.addBodyParameter(Constance.MSG_TYPE, getIntent().getStringExtra(Constance.MSG_TYPE));
        StringBuffer stringBuffer = new StringBuffer();
        for (int i = 0; i < allrow.size(); i++) {
            if (allrow.get(i).getChild_num() > 0 && allrow.get(i).isCheck()) {
                stringBuffer.append(allrow.get(i).getInsp_id() + ",");
            }
        }
        if (!TextUtils.isEmpty(stringBuffer.toString())) {
            params.addBodyParameter("insp_id", stringBuffer.toString());
        }

        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.PUB_INSPECT_QUALITY,
                params, new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<InspectQualityList> beans = CommonJson.fromJson(responseInfo.result, InspectQualityList.class);
                            if (beans.getState() != 0) {
                                setResult(Constance.RESULTCODE_FINISH, getIntent());
                                finish();
                            } else {
                                DataUtil.showErrOrMsg(mActivity, beans.getErrno(), beans.getErrmsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                        } finally {
                            closeDialog();
                        }
                    }

                    /** xutils 连接失败 调用的 方法 */
                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                        finish();
                    }
                });


    }
}
