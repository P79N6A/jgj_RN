package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.Editable;
import android.text.Html;
import android.text.InputFilter;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.cityslist.widget.SideBar;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.AddAccountPersonAdapter;
import com.jizhi.jlongg.main.adpter.MemberAccountPersonRecyclerViewAdapter;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SearchEditextHanlderResult;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.WrapLinearLayoutManager;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;

/**
 * CName:借支增加“一天记多人”（只有从班组内的“借支/结算”进入借支界面，才有此功能）
 * User: xuj
 * Date: 2019年2月20日
 * Time: 11:20:49
 */
public class AddAccountPersonMultipartActivity extends BaseActivity implements View.OnClickListener, AdapterView.OnItemClickListener {
    /**
     * 底部按钮
     */
    private Button joinChatBtn;
    /**
     * 聊天成员适配器
     */
    private MemberAccountPersonRecyclerViewAdapter horizontalAdapter;
    /**
     * 通讯录适配器
     */
    private AddAccountPersonAdapter adapter;
    /**
     * 已选中的成员数量
     */
    private int selectSize;
    /**
     * 项目组信息
     */
    private GroupMemberInfo groupInfo;
    /**
     * 项目组是否全选按钮
     */
    private ImageView groupSelectImage;
    /**
     * 列表数据
     */
    private List<PersonBean> list;
    /**
     * 搜索框输入的文件
     */
    private String matchString;
    /**
     * listView
     */
    private ListView listView;
    /**
     * 项目组View
     */
    private View headView;
    /**
     * 无数据时显示文本
     */
    private TextView defaultText;


    /**
     * @param context
     * @param groupId    组id(如果只是查看列表成员或者是添加记账对象可以不传)
     * @param groupName  项目组名称
     * @param selecteLis 选中对象的信息
     */
    public static void actionStart(Activity context, String groupName, String groupId, ArrayList<PersonBean> selecteLis) {
        Intent intent = new Intent(context, AddAccountPersonMultipartActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.GROUP_NAME, groupName);
        intent.putExtra(Constance.BEAN_CONSTANCE, selecteLis);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.initiate_group_chat);
        initView();
        getData();
    }

    /**
     * 获取记账对象
     */
    public void getData() {
        final String groupId = getIntent().getStringExtra(Constance.GROUP_ID);
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        if (!TextUtils.isEmpty(groupId)) {
            params.addBodyParameter("group_id", groupId);//如果从班组中进来的则只查询班组中的记账对象
        }
        CommonHttpRequest.commonRequest(this, NetWorkRequest.BILLGROUPLIST, PersonBean.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<PersonBean> list = (ArrayList<PersonBean>) object;
                ArrayList<PersonBean> selectList = (ArrayList<PersonBean>) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
                if (null != selectList && selectList.size() > 0) {
                    for (PersonBean personBean : list) {
                        for (PersonBean p : selectList) {
                            if (personBean.getUid() == p.getUid()) {
                                selectSize++;
                                horizontalAdapter.addData(personBean);
                                personBean.setIsChecked(true);
                                break;
                            }
                        }
                    }
                    if (selectSize > 0) {
                        btnClick();
                    } else {
                        btnUnClick();
                    }
                    groupInfo.setSelected(selectSize == list.size() ? true : false);
                    groupSelectImage.setImageResource(groupInfo.isSelected() ? R.drawable.checkbox_pressed : R.drawable.checkbox_normal);
                }
                setAdapter(list);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
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
                final List<PersonBean> filterDataList = SearchMatchingUtil.match(GroupMemberInfo.class, list, matchString);
                if (mMatchString.equals(matchString)) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            defaultText.setText(filterDataList == null || filterDataList.size() == 0 ?
                                    SearchEditextHanlderResult.getEmptyResultString(AddAccountPersonMultipartActivity.class.getName()) :
                                    SearchEditextHanlderResult.getUoEmptyResultString(AddAccountPersonMultipartActivity.class.getName()));
                            adapter.setFilterValue(mMatchString);
                            adapter.updateListView(filterDataList);
                            int headCount = listView.getHeaderViewsCount();
                            if (TextUtils.isEmpty(mMatchString)) {
                                if (headCount == 0) {
                                    listView.addHeaderView(headView, null, false);
                                }
                            } else {
                                if (headCount > 0) {
                                    listView.removeHeaderView(headView);
                                }
                            }
                        }
                    });
                }
            }
        }).start();
    }

    /**
     * 初始化搜索框
     */
    private void initSeatchEdit() {
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        mClearEditText.setHint("请输入名字或手机号码查找");
        mClearEditText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(20)});
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

    private void btnUnClick() {
        joinChatBtn.setText("确定");
        joinChatBtn.setClickable(false);
        Utils.setBackGround(joinChatBtn, getResources().getDrawable(R.drawable.draw_dis_app_btncolor_5radius));
    }

    private void btnClick() {
        joinChatBtn.setText(String.format(getString(R.string.confirm_add_member_count), selectSize));
        joinChatBtn.setClickable(true);
        Utils.setBackGround(joinChatBtn, getResources().getDrawable(R.drawable.draw_app_btncolor_5radius));
    }


    /**
     * 初始化View
     */
    private void initView() {
        setTextTitle(R.string.selecte_member);
        listView = (ListView) findViewById(R.id.listView);
        listView.addHeaderView(initTeamInfo(), null, false);
        joinChatBtn = getButton(R.id.redBtn);
        defaultText = getTextView(R.id.defaultDesc);
        defaultText.setText(SearchEditextHanlderResult.getDefaultResultString(this.getClass().getName()));
        TextView centerText = getTextView(R.id.center_text); //当前正在搜索的英文字母
        SideBar sideBar = (SideBar) findViewById(R.id.sidrbar); //侧边搜索框
        sideBar.setTextView(centerText);
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
        initRecyleListView();
        btnUnClick();
        initSeatchEdit();
    }


    private void initRecyleListView() {
        RecyclerView mRecyclerView = (RecyclerView) findViewById(R.id.recyclerview);//横向滚动View
        WrapLinearLayoutManager linearLayoutManager = new WrapLinearLayoutManager(this);
        linearLayoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
        mRecyclerView.setLayoutManager(linearLayoutManager);
        mRecyclerView.setItemAnimator(new DefaultItemAnimator());// 设置item动画
        horizontalAdapter = new MemberAccountPersonRecyclerViewAdapter(this);
        mRecyclerView.setAdapter(horizontalAdapter);
        horizontalAdapter.setOnItemClickLitener(new MemberAccountPersonRecyclerViewAdapter.OnItemClickLitener() {
            @Override
            public void onItemClick(View view, int position) {
                selectSize -= 1;
                if (selectSize > 0) {
                    btnClick();
                } else {
                    btnUnClick();
                }
                if (position < 0) {
                    position = 0;
                }
                horizontalAdapter.getSelectList().get(position).setIsChecked(false);
                horizontalAdapter.removeDataByPosition(position);
                adapter.notifyDataSetChanged();
                groupInfo.setSelected(false);
                groupSelectImage.setImageResource(R.drawable.checkbox_normal);
            }
        });
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.redBtn: //添加成员、发起群聊按钮
                if (selectSize > 0) {
                    ArrayList<PersonBean> selecteList = new ArrayList<>();
                    for (PersonBean personBean : list) {
                        if (personBean.isChecked()) {
                            selecteList.add(personBean);
                        }
                    }
                    Intent intent = getIntent();
                    intent.putExtra(Constance.BEAN_ARRAY, selecteList);
                    intent.putExtra(Constance.CHOOSE_MEMBER_TYPE, MessageUtil.WAY_ADD_BORROW_MULTIPART_PERSON);
                    setResult(Constance.SUCCESS, intent);
                    LUtils.e("----AA------" + new Gson().toJson(selecteList));
                    finish();
                }
                break;
        }
    }

    private void setAdapter(ArrayList<PersonBean> list) {
        this.list = list;
        Utils.setPinYinAndSortPerson(list);
        if (adapter == null) {
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            adapter = new AddAccountPersonAdapter(this, list, null, AccountUtil.BORROWING_INT, 0);
            adapter.setMultipartSet(true);
            listView.setAdapter(adapter);
            listView.setOnItemClickListener(this);
        } else {
            adapter.updateListView(list);
        }
    }

    /**
     * 初始化讨论组头信息
     *
     * @return
     */
    private View initTeamInfo() {
        groupInfo = new GroupMemberInfo();
        groupInfo.setGroup_name(getIntent().getStringExtra(Constance.GROUP_NAME));
        headView = getLayoutInflater().inflate(R.layout.item_head_choose_member, null);
        TextView groupNameText = (TextView) headView.findViewById(R.id.groupName);
        groupSelectImage = (ImageView) headView.findViewById(R.id.seletedImage);
        groupSelectImage.setVisibility(View.VISIBLE);
        groupNameText.setText(Html.fromHtml("<font color='#333333'>" + groupInfo.getGroup_name() + "</font>"));
        headView.setOnClickListener(new View.OnClickListener() { //设置取消全选和全选的事件
            @Override
            public void onClick(View v) {
                boolean isSelect = !groupInfo.isSelected();
                groupInfo.setSelected(isSelect);
                groupSelectImage.setImageResource(isSelect ? R.drawable.checkbox_pressed : R.drawable.checkbox_normal);
                for (PersonBean personBean : list) {
                    personBean.setIsChecked(isSelect);
                }
                horizontalAdapter.setSelectList(isSelect ? list : null);
                selectSize = isSelect ? list.size() : 0;
                if (selectSize > 0) {
                    btnClick();
                } else {
                    btnUnClick();
                }
                adapter.notifyDataSetChanged();
                hideSoftKeyboard();
            }
        });
        return headView;
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        PersonBean bean = adapter.getList().get(position - listView.getHeaderViewsCount());
        bean.setIsChecked(!bean.isChecked());
        selectSize = bean.isChecked() ? selectSize + 1 : selectSize - 1;
        adapter.notifyDataSetChanged();
        if (selectSize > 0) {
            btnClick();
        } else {
            btnUnClick();
        }
        groupInfo.setSelected(selectSize == list.size() ? true : false);
        groupSelectImage.setImageResource(groupInfo.isSelected() ? R.drawable.checkbox_pressed : R.drawable.checkbox_normal);
        if (bean.isChecked()) {
            horizontalAdapter.addData(bean);
        } else {
            horizontalAdapter.removeDataByTelephone(bean.getTelph());
        }
//            mRecyclerView.smoothScrollToPosition(horizontalAdapter.getSelectList().size() == 0 ? 0 : horizontalAdapter.getSelectList().size() - 1);
        hideSoftKeyboard();
    }


}
