package com.jizhi.jlongg.main.activity;

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
import com.jizhi.jlongg.main.adpter.AddAtMemberAdapter;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.status.CommonNewListJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.ArrayList;
import java.util.List;


/**
 * 添加@对象
 *
 * @author Xuj
 * @time 2016-11-28 17:47:42
 * @Version 1.0
 */
public class AtMemberListActivity extends BaseActivity {

    private AddAtMemberAdapter administratorAdapter;

    private ListView listView;
    private List<GroupMemberInfo> list;
    private View headView;
    /**
     * 筛选文字
     */
    private String matchString;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.add_at_member);
        ViewUtils.inject(this); // Xutil必须调用的一句话
        list = new ArrayList<>();
        findViewById(R.id.at_all).setVisibility(View.GONE);
        initSideBar();
        getMemberGroupList();
    }

    private void initSideBar() {
        setTextTitle(R.string.select_person);
        listView = (ListView) findViewById(R.id.listView);
        if (getIntent().getIntExtra("mySelfGroup", 2) == 1) {
            headView = getLayoutInflater().inflate(R.layout.headview_msg_at, null); // 加载对话框
            listView.addHeaderView(headView);
            administratorAdapter = new AddAtMemberAdapter(AtMemberListActivity.this, list);
            listView.setAdapter(administratorAdapter);

            headView.findViewById(R.id.at_all).setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    atAll();
                }
            });
        }
        TextView center_text = getTextView(R.id.center_text);
        SideBar sideBar = (SideBar) findViewById(R.id.sidrbar); //搜索框
        sideBar.setTextView(center_text);
        // 设置右侧触摸监听
        sideBar.setOnTouchingLetterChangedListener(new SideBar.OnTouchingLetterChangedListener() {
            @Override
            public void onTouchingLetterChanged(String s) {
                if (administratorAdapter != null) {
                    //该字母首次出现的位置
                    int position = administratorAdapter.getPositionForSection(s.charAt(0));
                    if (position != -1) {
                        listView.setSelection(position);
                    }
                }
            }
        });

        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        mClearEditText.setHint("请输入名字或手机号进行搜索");
        mClearEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
//                ((TextView) findViewById(R.id.defaultDesc)).setText(TextUtils.isEmpty(s.toString()) ? "暂无成员" : "未找到对应成员");
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
        if (administratorAdapter == null || list == null || list.size() == 0) {
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
                            administratorAdapter.setMatchString(matchString);
                            administratorAdapter.updateList(filterDataList);
                        }
                    });
                }
            }
        }).start();
    }

    /**
     * 选择的@成员
     */
    private void atInfo(GroupMemberInfo info) {
        PersonBean clickPerson = new PersonBean();
        if (TextUtils.isEmpty(info.getFull_name())) {
            clickPerson.setName(info.getReal_name());
        } else {
            clickPerson.setName(info.getFull_name());
        }
        clickPerson.setTelph(info.getTelephone());
        clickPerson.setUid(Integer.parseInt(info.getUid()));
        Intent intent = getIntent();
        intent.putExtra(Constance.BEAN_ARRAY, clickPerson);
        setResult(Constance.PERSON, intent);
        finish();
    }

    /**
     * at所有人
     */
    private void atAll() {

        PersonBean clickPerson = new PersonBean();
        clickPerson.setUid(123456);
        clickPerson.setName("text11");
        Intent intent = getIntent();
        intent.putExtra(Constance.ATALL, true);
        intent.putExtra(Constance.BEAN_ARRAY, clickPerson);
        setResult(Constance.PERSON, intent);
        finish();
    }


    private void setAdapter() {
        Utils.setPinYinAndSort(list);
        administratorAdapter = new AddAtMemberAdapter(AtMemberListActivity.this, list);
        listView.setAdapter(administratorAdapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                GroupMemberInfo info;
                if (getIntent().getIntExtra("mySelfGroup", 2) == 1) {
                    info = administratorAdapter.getList().get(position - 1);
                } else {
                    info = administratorAdapter.getList().get(position);
                }
                atInfo(info);
            }
        });
    }

    /**
     * 成员列表
     */
    public void getMemberGroupList() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("class_type", getIntent().getStringExtra(Constance.CLASSTYPE));
        params.addBodyParameter("group_id", getIntent().getStringExtra(Constance.GROUP_ID));
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_MEMBER_LIST, params, new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonNewListJson<GroupMemberInfo> bean = CommonNewListJson.fromJson(responseInfo.result, GroupMemberInfo.class);
                    if (bean.getMsg().equals(Constance.SUCCES_S)) {
                        try {
                            if (bean.getMsg().equals(Constance.SUCCES_S)) {
                                list = bean.getResult();
                                setAdapter();
                            } else {
                                DataUtil.showErrOrMsg(AtMemberListActivity.this, bean.getCode() + "", bean.getMsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(AtMemberListActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                        }
                    } else {
                        closeDialog();
                        DataUtil.showErrOrMsg(AtMemberListActivity.this, bean.getCode() + "", bean.getMsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(AtMemberListActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                }
                closeDialog();
            }
        });
    }

}