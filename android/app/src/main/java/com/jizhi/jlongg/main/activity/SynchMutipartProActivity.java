package com.jizhi.jlongg.main.activity;

import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.Html;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.cityslist.widget.SideBar;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.SynchMultiplePersonAdapter;
import com.jizhi.jlongg.main.bean.SynBill;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.dialog.DiaLogNoMoreProject;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;
import com.lidroid.xutils.view.annotation.ViewInject;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * 功能:需同步项目组的联系人
 * 作者：xuj
 * 时间: 2016-5-9 15:37
 */
public class SynchMutipartProActivity extends BaseActivity implements View.OnClickListener {
    /* listView 适配器*/
    private SynchMultiplePersonAdapter adapter;
    /* 人员选中text */
    @ViewInject(R.id.person_count)
    private TextView personCountText;

    @ViewInject(R.id.listView)
    private ListView listView;

    /* 默认页 */
    @ViewInject(R.id.default_layout)
    private LinearLayout defaultLayout;

    /**
     * 筛选文字
     */
    private String matchString;
    /**
     * 已选中的数量
     */
    private int selectedSize;

    /* 底部选择人员布局 */
    @ViewInject(R.id.bottom_layout)
    private RelativeLayout bottomLayout;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.synch_mutiple_person);
        ViewUtils.inject(this); // Xutil必须调用的一句话
        initView();
    }

    public void initView() {
        onRefresh();
        setTextTitleAndRight(R.string.need_synch_person, R.string.add_sync_person);
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filter_edit);
        TextView confirmAdd = (TextView) findViewById(R.id.confirm_add);
        SideBar sideBar = (SideBar) findViewById(R.id.sidrbar);
        sideBar.setTextView(getTextView(R.id.center_text));
        confirmAdd.setText("确认同步");
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
                // 当输入框里面的值为空，更新为原来的列表，否则为过滤数据列表
                filterData(s.toString());
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                SynBill bean = adapter.getList().get(position);
                if (bean.getIs_sync() == 1) {
                    return;
                }
                boolean isSelected = bean.isSelcted();
                selectedSize = isSelected ? selectedSize - 1 : selectedSize + 1;
                bean.setSelcted(!isSelected);
                adapter.updateSingleView(view, position);
                if (selectedSize == 0) {
                    hideBottomLayout();
                } else {
                    showBottomLayout();
                }
            }
        });
    }

    /**
     * 显示底部Layout
     */
    private void showBottomLayout() {
        personCountText.setText(Html.fromHtml("<font color='#666666'>已选中</font><font color='#d7252c'> " + selectedSize + " <font color='#666666'><font>人</font>"));
        bottomLayout.setVisibility(View.VISIBLE);
    }

    /**
     * 隐藏底部Layout
     */
    private void hideBottomLayout() {
        bottomLayout.setVisibility(View.GONE);
    }


    /**
     * 数据筛选
     *
     * @param mMatchString 筛选值
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
        if (id == R.id.confirm_add) { //确认同步
            synProject();
        } else {
            Intent intent = new Intent(this, SynContactsActivity.class);
            if (adapter != null && adapter.getCount() > 0) {
                intent.putExtra(Constance.BEAN_ARRAY, (Serializable) adapter.getList());
            }
            intent.putExtra(Constance.BEAN_BOOLEAN, true);
            startActivityForResult(intent, Constance.REQUEST);
        }
    }


    public RequestParams params() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        Intent intent = getIntent();
        String pid = getIntent().getStringExtra(Constance.PID);
        if (adapter != null && adapter.getList() != null && adapter.getList().size() > 0) {
            List<SynBill> list = adapter.getList();
            String pro_name = intent.getStringExtra(Constance.BEAN_STRING);
            //项目组 格式： “11404,1,中建投峰汇中心;11404,2,福年广场项目组” (target_uid,pid,pro_name)
            StringBuffer builder = new StringBuffer();
            int size = list.size();
            for (int i = 0; i < size; i++) {
                SynBill bean = list.get(i);
                if (list.get(i).isSelcted()) {
                    int tagetId = bean.getTarget_uid();
                    if (!TextUtils.isEmpty(builder.toString())) {
                        builder.append(";");
                    }
                    builder.append(tagetId + "," + pid + "," + pro_name);
                }
            }
            params.addBodyParameter("pro_info", builder.toString());
        }
        return params;
    }

    private List<SynBill> list;

    /**
     * 获取、管理同步人列表
     */
    public void onRefresh() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("pid", getIntent().getStringExtra(Constance.PID));
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GETUSERSYNLIST, params, new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonListJson<SynBill> base = CommonListJson.fromJson(responseInfo.result, SynBill.class);
                    if (base.getState() != 0) {
                        initList(base.getValues());
                    } else {
                        CommonMethod.makeNoticeShort(SynchMutipartProActivity.this, base.getErrmsg(), CommonMethod.ERROR);
                        finish();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(SynchMutipartProActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                    finish();
                } finally {
                    closeDialog();
                }
            }
        });
    }


    /**
     * 同步项目组
     */
    public void synProject() {
        if (selectedSize == 0) {
            CommonMethod.makeNoticeShort(getApplicationContext(), "请选择需要同步的对象", CommonMethod.ERROR);
            return;
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.SYNCPRO, params(), new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonListJson<SynBill> base = CommonListJson.fromJson(responseInfo.result, SynBill.class);
                    if (base.getState() != 0) {
                        DiaLogNoMoreProject dialog = new DiaLogNoMoreProject(SynchMutipartProActivity.this, getString(R.string.syn_desc), false);
                        dialog.show();
                    } else {
                        CommonMethod.makeNoticeShort(SynchMutipartProActivity.this, base.getErrmsg(), CommonMethod.ERROR);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(SynchMutipartProActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    closeDialog();
                }
            }
        });
    }


    /**
     * 当前list排序 根据Accsi码
     */
    public List<SynBill> sortcurrentList(List<SynBill> list) {
        Utils.setPinYinAndSortSynch(list);
        return list;
    }


    private void initList(List<SynBill> list) {
        defaultLayout.setVisibility(list == null || list.size() == 0 ? View.VISIBLE : View.GONE);
        if (list != null) {
            list = sortcurrentList(list);
        }
        if (adapter == null) {
            adapter = new SynchMultiplePersonAdapter(SynchMutipartProActivity.this, list);
            listView.setAdapter(adapter);
        } else {
            adapter.updateListView(list);
            adapter.notifyDataSetChanged();
        }
        this.list = list;
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode == Constance.ADD_SUCCESS) { //新增同步对象
            SynBill synBill = (SynBill) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            if (list == null) {
                list = new ArrayList<>();
            }
            list.add(synBill);
            initList(list);
        }
    }
}
