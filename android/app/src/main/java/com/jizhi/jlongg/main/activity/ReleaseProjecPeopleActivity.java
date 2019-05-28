package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.cityslist.widget.SideBar;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.SelectProjectPeopleAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.status.CommonNewListJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.ArrayList;
import java.util.List;

/**
 * 功能: 发质量，安全选择整改负责人
 * <p>
 * 作者：胡常生
 * 时间: 2017年5月26日 16:10:12
 */
public class ReleaseProjecPeopleActivity extends BaseActivity {
    private ReleaseProjecPeopleActivity mActivity;
    private List<GroupMemberInfo> list;
    /* 添加工人、工头列表适配器 */
    private SelectProjectPeopleAdapter adapter;
    private ListView listView;
    public static final String UID = "uid";
    private int type;
    //组信息
    private GroupDiscussionInfo gnInfo;
    /**
     * 筛选文字
     */
    private String matchString;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_release_userinfo);
        initView();
        getIntentData();
        getMemberList();
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                GroupMemberInfo info = adapter.getList().get(position);
                if (info.getIs_active() == 1) {
                    Intent intent = new Intent();
                    intent.putExtra(ReleaseQualityAndSafeActivity.VALUE, info.getReal_name());
                    intent.putExtra(UID, info.getUid() + "");
                    setResult(type, intent);
                    finish();
                } else {
                    CommonMethod.makeNoticeShort(mActivity, "该用户还未注册，不能选择", CommonMethod.SUCCESS);
                }
            }
        });
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        mClearEditText.setHint("请输入成员名字进行搜索");
        mClearEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                ((TextView) findViewById(R.id.defaultDesc)).setText(TextUtils.isEmpty(s.toString()) ? "暂无成员" : "未找到对应成员");
                filterData(s.toString());
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });
    }

    /**
     * 搜索框 筛选数据
     *
     * @param mMatchString
     */
    private synchronized void filterData(final String mMatchString) {
        if (adapter == null || list == null || list.size() == 0) {
            return;
        }
        matchString = mMatchString;
        new Thread(new Runnable() {
            @Override
            public void run() {
                final List<GroupMemberInfo> filterDataList = SearchMatchingUtil.match(GroupMemberInfo.class, list, matchString);
                if (mMatchString.equals(matchString)) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            adapter.updateListView(filterDataList);
                        }
                    });
                }
            }
        }).start();
    }

    /**
     * 初始化view
     */
    private void initView() {
        mActivity = ReleaseProjecPeopleActivity.this;
        listView = (ListView) findViewById(R.id.listView);
        list = new ArrayList<>();
        type = getIntent().getIntExtra(Constance.BEAN_CONSTANCE, 0);
        String title = getIntent().getStringExtra("title");
        SetTitleName.setTitle(findViewById(R.id.title), TextUtils.isEmpty(title) ? "" : title);


    }


    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(("gnInfo"));
    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo gnInfo, String people_uid, int type, String title) {
        Intent intent = new Intent(context, ReleaseProjecPeopleActivity.class);
        intent.putExtra("gnInfo", gnInfo);
        intent.putExtra("people_uid", people_uid);
        intent.putExtra("title", title);
        intent.putExtra(Constance.BEAN_CONSTANCE, type);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 成员列表
     */
    public void getMemberList() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("group_id", gnInfo.getGroup_id() + "");
        params.addBodyParameter("class_type", gnInfo.getClass_type() + "");
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_MEMBER_LIST, params, new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonNewListJson<GroupMemberInfo> bean = CommonNewListJson.fromJson(responseInfo.result, GroupMemberInfo.class);
                    if (bean.getMsg().equals(Constance.SUCCES_S)) {
                        List<GroupMemberInfo> infos = bean.getResult();
                        if (infos != null && infos.size() > 0) {
                            list = infos;
                            int selecteType = getIntent().getIntExtra(Constance.BEAN_CONSTANCE, 0);
                            if (selecteType == Constance.SELECTE_PROXYER) { //如果是设置代班长 需要排除自己
                                int size = infos.size();
                                for (int i = 0; i < size; i++) {
                                    if (infos.get(i).getUid().equals(UclientApplication.getUid(getApplicationContext()))) {
                                        infos.remove(i);
                                        break;
                                    }
                                }
                            }
                            if (!TextUtils.isEmpty(getIntent().getStringExtra("people_uid"))) { //设置已中的成员
                                int size = infos.size();
                                for (int i = 0; i < size; i++) {
                                    if (getIntent().getStringExtra("people_uid").equals(list.get(i).getUid() + "")) {
                                        infos.get(i).setSelected(true);
                                    }
                                }
                            }
                            /**
                             * 当前list排序
                             */
                            Utils.setPinYinAndSort(list);
                            adapter = new SelectProjectPeopleAdapter(mActivity, list);
                            listView.setEmptyView(findViewById(R.id.defaultLayout));
                            listView.setAdapter(adapter);
                            TextView center_text = getTextView(R.id.center_text);
                            SideBar sideBar = findViewById(R.id.sidrbar); //搜索框
                            sideBar.setTextView(center_text);
                            // 设置右侧触摸监听
                            sideBar.setOnTouchingLetterChangedListener(new SideBar.OnTouchingLetterChangedListener() {
                                @Override
                                public void onTouchingLetterChanged(String s) {
                                    if (adapter != null) {
                                        //该字母首次出现的位置
                                        int position = adapter.getPositionForSection(s.charAt(0));
                                        if (position != -1) {
                                            listView.setSelection(position);
                                        }
                                    }
                                }
                            });
                        }
                    } else {
                        closeDialog();
                        DataUtil.showErrOrMsg(mActivity, bean.getCode() + "", bean.getMsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(mActivity, mActivity.getString(R.string.service_err), CommonMethod.ERROR);
                }
                closeDialog();
            }
        });
    }


}
