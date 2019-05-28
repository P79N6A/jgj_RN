package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.InputFilter;
import android.text.TextWatcher;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.cityslist.widget.SideBar;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.account.NewAccountActivity;
import com.jizhi.jlongg.main.adpter.SyncManageAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.bean.SynBill;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.IsSupplementary;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.io.Serializable;
import java.util.List;

/**
 * 功能:同步项目
 * 作者：xuj
 * 时间: 2016-5-9 15:37
 */
public class SyncManagerActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 列表数据
     */
    private List<SynBill> list;
    /**
     * 列表适配器
     */
    private SyncManageAdapter adapter;
    /**
     * listView
     */
    private ListView listView;
    /**
     * 无数据时的红色按钮
     */
    private Button defaultBtn;
    /**
     * 无数据时展示的文本描述
     */
    private TextView defaultDesc;
    /**
     * 是否是添加人员
     */
    private boolean isAddPerson;
    /**
     * 当前筛选框文字
     */
    private String matchString;
    /**
     * 添加新增同步人按钮
     */
    private TextView rightTitle;


    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, SyncManagerActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.syn_bills_manage);
        initView();
        getMySelfProject();
    }


    public void initView() {
        setTextTitleAndRight(R.string.syn_manage, R.string.add_syn_person);
        rightTitle = getTextView(R.id.right_title);
        rightTitle.setVisibility(View.GONE);
        listView = (ListView) findViewById(R.id.listView);
        defaultDesc = (TextView) findViewById(R.id.defaultDesc);
        defaultBtn = getButton(R.id.defaultBtn);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent intent = new Intent(getApplicationContext(), SynchProjectListActivity.class);
                intent.putExtra(Constance.BEAN_CONSTANCE, adapter.getList().get(position));
                startActivityForResult(intent, Constance.REQUEST);
            }
        });

        TextView center_text = getTextView(R.id.center_text);
        SideBar sideBar = (SideBar) findViewById(R.id.sidrbar); //搜索框
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        mClearEditText.setHint("请输入姓名和手机号查找");
        mClearEditText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(20)});
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
        // 根据输入框输入值的改变来过滤搜索
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
                final List<SynBill> filterDataList = SearchMatchingUtil.match(SynBill.class, list, matchString);
                if (mMatchString.equals(matchString)) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            adapter.setFilterValue(mMatchString);
                            adapter.updateListView(filterDataList);
                        }
                    });
                }
            }
        }).start();
    }


    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.right_title || id == R.id.defaultBtn) { //添加同步人
            IsSupplementary.isFillRealNameCallBackListener(this, true, new IsSupplementary.CallSupplementNameSuccess() {
                @Override
                public void onSuccess() {
                    //完善姓名成功
                    Utils.sendBroadCastToUpdateInfo(SyncManagerActivity.this);
                    Intent intent = new Intent();
                    if (isAddPerson) {
                        intent.setClass(SyncManagerActivity.this, SynContactsActivity.class);
                        if (adapter != null && adapter.getCount() > 0) {
                            intent.putExtra(Constance.BEAN_ARRAY, (Serializable) adapter.getList());
                        }
                        startActivityForResult(intent, Constance.REQUEST);
                    } else {
                        intent.setClass(SyncManagerActivity.this, CreateTeamGroupActivity.class);
                        startActivityForResult(intent, Constance.REQUEST_PROJECT);
                    }
                }
            });
        } else if (id == R.id.synchmanage_desc || id == R.id.whatIsTheProLayout) { //什么是同步管理?
            X5WebViewActivity.actionStart(SyncManagerActivity.this, NetWorkRequest.HELPDETAIL + 91);
        }
    }


    /**
     * 查询可以同步的项目组
     */
    public void getMySelfProject() {
        String url = NetWorkRequest.SYNCEDPRO;
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("uid", UclientApplication.getUid(getApplicationContext())); //当前用户id
        params.addBodyParameter("pg", "1");
        params.addBodyParameter("synced", "0");//1：已同步的项目组列表 0：未同步的项目组列表
        http.send(HttpRequest.HttpMethod.POST, url, params, new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonListJson<Project> bean = CommonListJson.fromJson(responseInfo.result, Project.class);
                    if (bean.getState() != 0) {
                        final List<Project> list = bean.getValues();
                        //当有项目的时 才会去请求 同步人的接口
                        if (list != null && list.size() > 0) {
                            getSynchperson();
                        } else {
                            setCreateProjectDefaultDesc();
                        }
                    } else {
                        DataUtil.showErrOrMsg(SyncManagerActivity.this, bean.getErrno(), bean.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    closeDialog();
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                super.onFailure(exception, errormsg);
                finish();
            }
        });
    }


    /**
     * 获取、管理同步人列表
     */
    public void getSynchperson() {
        setAddPersonDefaultDesc();
        String url = NetWorkRequest.GETUSERSYNLIST;
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, url, RequestParamsToken.getExpandRequestParams(this), new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonListJson<SynBill> base = CommonListJson.fromJson(responseInfo.result, SynBill.class);
                    if (base.getState() != 0) {
                        List<SynBill> list = base.getValues();
                        setAdapter(list);
                    } else {
                        DataUtil.showErrOrMsg(SyncManagerActivity.this, base.getErrno(), base.getErrmsg());
                        finish();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
                    finish();
                } finally {
                    closeDialog();
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                super.onFailure(exception, errormsg);
                finish();
            }
        });
    }


    private void setAdapter(List<SynBill> list) {
        Utils.setPinYinAndSortSynch(list);
        this.list = list;
        if (adapter == null) {
            adapter = new SyncManageAdapter(this, list);
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            listView.setAdapter(adapter);
        } else {
            adapter.updateListView(list);
        }
        rightTitle.setVisibility(list != null && list.size() > 0 ? View.VISIBLE : View.GONE);
    }


    /**
     * 设置无项目时的描述
     */
    private void setCreateProjectDefaultDesc() {
        defaultBtn.setText("马上创建班组");
        defaultDesc.setText("你还没有自己的班组");
        findViewById(R.id.defaultLayout).setVisibility(View.VISIBLE);
    }

    /**
     * 设置添加同步人无数据时的描述
     */
    private void setAddPersonDefaultDesc() {
        isAddPerson = true;
        defaultBtn.setText("新增同步人");
        defaultDesc.setText("你还没有给任何人同步项目");
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == Constance.REQUEST) {
            getMySelfProject();
        } else if (requestCode == Constance.REQUEST_PROJECT && resultCode == Constance.SUCCESS) {
            finish();
        } else if (requestCode == Constance.REQUEST_PROJECT && resultCode == MessageUtil.WAY_CREATE_GROUP_CHAT) {
            setResult(resultCode, data);
            finish();
        }
    }
}
