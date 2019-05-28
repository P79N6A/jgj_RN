package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.cityslist.widget.SideBar;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.TelContactAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SearchEditextHanlderResult;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;


/**
 * 手机联系人
 *
 * @author Xuj
 * @time 2017年2月10日17:33:24
 * @Version 1.0
 */
public class TelContactActivity extends BaseActivity {
    /**
     * 手机通讯录适配器
     */
    private TelContactAdapter adapter;
    /**
     * 手机通讯录数据
     */
    private List<GroupMemberInfo> list;
    /**
     * 输入框筛选文字
     */
    private String matchString;
    /**
     * listView
     */
    private ListView listView;

    private TextView defaultText, defaultText1;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, TelContactActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.tel_contact_layout);
        initView();
        getContactData();
    }

    private void initView() {
        setTextTitle(R.string.phone_contact);
        defaultText = getTextView(R.id.defaultDesc);
        defaultText1 = getTextView(R.id.defaultDesc1);
        defaultText1.setTextSize(13);
        defaultText1.setText("请确认是否已允许吉工家访问手机通讯录");
        defaultText1.setVisibility(View.VISIBLE);

        View listViewLayout = findViewById(R.id.listViewLayout);
        RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) listViewLayout.getLayoutParams();
        params.width = ViewGroup.LayoutParams.MATCH_PARENT;
        params.height = ViewGroup.LayoutParams.MATCH_PARENT;
        listViewLayout.setLayoutParams(params);

        defaultText.setText(SearchEditextHanlderResult.getDefaultResultString(this.getClass().getName()));

        listView = (ListView) findViewById(R.id.listView);
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        mClearEditText.setHint("请输入名字或手机号码查找");
        mClearEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                filterData(s.toString());
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });
        TextView center_text = getTextView(R.id.center_text);
        SideBar sideBar = (SideBar) findViewById(R.id.sidrbar); //搜索框
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
                final ArrayList<GroupMemberInfo> filterDataList = (ArrayList<GroupMemberInfo>) SearchMatchingUtil.match(GroupMemberInfo.class, list, matchString);
                if (mMatchString.equals(matchString)) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            defaultText.setText(filterDataList == null || filterDataList.size() == 0 ?
                                    SearchEditextHanlderResult.getEmptyResultString(TelContactActivity.class.getName()) :
                                    SearchEditextHanlderResult.getUoEmptyResultString(TelContactActivity.class.getName()));
                            defaultText1.setVisibility(filterDataList == null || filterDataList.size() == 0 ? View.GONE : View.VISIBLE);
                            adapter.setFilterValue(mMatchString);
                            adapter.updateListView(filterDataList);
                        }
                    });
                }
            }
        }).start();
    }


    /**
     * 获取手机联系人
     */
    private void getContactData() {
        String httpUrl = NetWorkRequest.GET_MEMBER_TELEPHONE;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("uid", UclientApplication.getUid());
        CommonHttpRequest.commonRequest(this, httpUrl, GroupMemberInfo.class, true, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<GroupMemberInfo> list = (ArrayList<GroupMemberInfo>) object;
                setAdapter(list);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    private void setAdapter(ArrayList<GroupMemberInfo> list) {
        TelContactActivity.this.list = list;
        Utils.setPinYinAndSort(list); //设置首字母 拼音
        if (adapter == null) {
            adapter = new TelContactAdapter(TelContactActivity.this, list);
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            listView.setAdapter(adapter);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    if (adapter.getList().get(position).getIs_active() == 0) {
                        CommonMethod.makeNoticeShort(TelContactActivity.this, "TA还没加入吉工家，没有更多资料了", CommonMethod.ERROR);
                        return;
                    }
                    ChatUserInfoActivity.actionStart(TelContactActivity.this, adapter.getList().get(position).getUid());
                }
            });
        } else {
            adapter.updateListView(list);
        }
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.CLICK_SINGLECHAT) { //点击单聊
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        }
    }


}