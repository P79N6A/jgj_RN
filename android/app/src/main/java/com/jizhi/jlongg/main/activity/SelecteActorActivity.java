package com.jizhi.jlongg.main.activity;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.text.Editable;
import android.text.Html;
import android.text.InputFilter;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.cityslist.widget.SideBar;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.PersonBaseAdapter;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.LetterSectionUtil;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;
import com.lidroid.xutils.exception.HttpException;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * CName:设置记录员
 * User: xuj
 * Date: 2017年3月31日
 * Time: 14:26:05
 */
public class SelecteActorActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 列表适配器
     */
    private SelecteActorAdapter adapter;
    /**
     * 已选中人员
     */
    private TextView personCount;
    /**
     * 已选人员的数量
     */
    private int selectedCount;
    /**
     * 是否选中了全部
     */
    private boolean isSelectedAll;
    /**
     * 列表数据
     */
    private List<GroupMemberInfo> list;
    /**
     * 筛选文字
     */
    private String matchString;
    /**
     * 项目组信息
     */
    private View groupInfoView;
    /**
     * 无数据时提示的话语
     * 当输入框搜索时如果未查询到数据需要显示:未找到对应成员
     * 当输入框未搜索时如果未查询到数据需要显示:暂无成员
     */
    private TextView defaultDesc;
    /**
     * listView
     */
    private ListView listView;


    /**
     * @param context
     */
    public static void actionStart(Activity context, String uids, String title) {
        Intent intent = context.getIntent();
        intent.putExtra(Constance.UID, uids);
        intent.putExtra(Constance.TITLE, title);
        intent.setClass(context, SelecteActorActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * @param context
     */
    public static void actionStart(Activity context, String uids, String title, boolean isShowUnRegister) {
        Intent intent = context.getIntent();
        intent.putExtra(Constance.UID, uids);
        intent.putExtra(Constance.TITLE, title);
        intent.putExtra(Constance.BEAN_BOOLEAN, isShowUnRegister);
        intent.setClass(context, SelecteActorActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * @param context
     */
    public static void actionStart(Activity context, String uids, String title, String group_id, String group_name, String class_type) {
        Intent intent = context.getIntent();
        intent.putExtra(Constance.UID, uids);
        intent.putExtra(Constance.TITLE, title);
        intent.putExtra(Constance.GROUP_ID, group_id);
        intent.putExtra(Constance.GROUP_NAME, group_name);
        intent.putExtra(Constance.CLASSTYPE, class_type);
        intent.setClass(context, SelecteActorActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * isShowUnRegister 未注册的人可以选中 true
     *
     * @param context
     */
    public static void actionStart(Activity context, String uids, String title, String group_id, String group_name, String class_type, boolean isShowUnRegister) {
        Intent intent = context.getIntent();
        intent.putExtra(Constance.UID, uids);
        intent.putExtra(Constance.TITLE, title);
        intent.putExtra(Constance.GROUP_ID, group_id);
        intent.putExtra(Constance.GROUP_NAME, group_name);
        intent.putExtra(Constance.CLASSTYPE, class_type);
        intent.putExtra(Constance.BEAN_BOOLEAN, isShowUnRegister);
        intent.setClass(context, SelecteActorActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.bottom_add_member_sidebar_layout);
        initView();
        getGroupMember();
    }

    private void getGroupMember() {
        Intent intent = getIntent();
        String classType = intent.getStringExtra(Constance.CLASSTYPE);
        String groupId = intent.getStringExtra(Constance.GROUP_ID);
        MessageUtil.getGroupMembers(this, groupId, TextUtils.isEmpty(classType) ? WebSocketConstance.TEAM : classType, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<GroupMemberInfo> list = (ArrayList<GroupMemberInfo>) object;
                if (list != null && list.size() > 0) {
                    selectedCount = setTraceState(list);
                    setAdapter(list);
                    personCount.setText(Html.fromHtml("<font color='#666666'>本次已选中</font><font color='#d7252c'> " + selectedCount + "</font><font color='#666666'> 人</font>"));
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }

    private void initView() {
        String navigationTitle = getIntent().getStringExtra(Constance.TITLE);
        getTextView(R.id.title).setText(navigationTitle);
        personCount = (TextView) findViewById(R.id.personCount);
        listView = (ListView) findViewById(R.id.listView);
        defaultDesc = getTextView(R.id.defaultDesc);
        defaultDesc.setText("暂无成员");
        TextView centerText = getTextView(R.id.center_text); //当前正在搜索的英文字母
        SideBar sideBar = (SideBar) findViewById(R.id.sidrbar); //侧边搜索框
        sideBar.setTextView(centerText);
        // 设置右侧触摸监听
        sideBar.setOnTouchingLetterChangedListener(new SideBar.OnTouchingLetterChangedListener() {
            @Override
            public void onTouchingLetterChanged(String s) {
                if (adapter != null) {
                    //该字母首次出现的位置
                    int position = LetterSectionUtil.getSectionForPosition(s.charAt(0), list);
                    if (position != -1) {
                        listView.setSelection(position);
                    }
                }
            }
        });
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        mClearEditText.setHint("请输入成员名字进行搜索");
        mClearEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                int headCount = listView.getHeaderViewsCount();
                if (TextUtils.isEmpty(s.toString())) {
                    if (headCount == 0) {
                        listView.addHeaderView(groupInfoView, null, false);
                    }
                } else {
                    if (headCount > 0) {
                        listView.removeHeaderView(groupInfoView);
                    }
                }
                defaultDesc.setText(TextUtils.isEmpty(s.toString()) ? "暂无成员" : "未找到对应成员");
                filterData(s.toString());
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });
        mClearEditText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(20)}); //设置最大输入框为20个字
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
                            adapter.updateList(filterDataList);
                        }
                    });
                }
            }
        }).start();
    }


    /**
     * 获取成员的数量
     */
    private int getRegisterUserCount() {
        if (list != null) {
            return list.size();
        }
        return 0;
    }


    /**
     * 获取已选中人员
     *
     * @return
     */
    private ArrayList<GroupMemberInfo> getSelectedUsers() {
        if (list != null && list.size() > 0) {
            ArrayList<GroupMemberInfo> groupMemberInfos = null;
            for (GroupMemberInfo bean : list) {
                if (bean.isSelected()) {
                    if (groupMemberInfos == null) {
                        groupMemberInfos = new ArrayList<>();
                    }
                    groupMemberInfos.add(bean);
                }
            }
            return groupMemberInfos;
        }
        return null;
    }

    /**
     * 设置参与者状态
     *
     * @param list
     * @return
     */
    private int setTraceState(List<GroupMemberInfo> list) {
        String uids = getIntent().getStringExtra(Constance.UID);
        if (!TextUtils.isEmpty(uids) && list != null && list.size() > 0) {
            int count = 0;
            for (String uid : uids.split(",")) {
                for (GroupMemberInfo bean : list) {
                    if (bean.getUid().equals(uid)) {
                        count += 1;
                        bean.setSelected(true);
                    }
                }
            }
            return count;
        }
        return 0;
    }


    /**
     * 设置列表适配器
     *
     * @param list
     */
    private void setAdapter(final ArrayList<GroupMemberInfo> list) {
        Utils.setPinYinAndSort(list);
        this.list = list;
        if (adapter == null) {
            groupInfoView = getLayoutInflater().inflate(R.layout.item_head_choose_member, null);
            TextView groupName = (TextView) groupInfoView.findViewById(R.id.groupName);
            groupName.setText(getIntent().getStringExtra(Constance.GROUP_NAME));
            groupName.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.color_333333));

            final ImageView groupInfoSelecteImage = (ImageView) groupInfoView.findViewById(R.id.seletedImage);
            groupInfoView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    isSelectedAll = !isSelectedAll;
                    groupInfoSelecteImage.setImageResource(isSelectedAll ? R.drawable.checkbox_pressed : R.drawable.checkbox_normal);
                    for (GroupMemberInfo info : adapter.getList()) {
                        if (info.getIs_active() == 1 || getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false)) {
                            info.setSelected(isSelectedAll);
                        }
                    }
                    selectedCount = isSelectedAll ? getRegisterUserCount() : 0;
                    adapter.notifyDataSetChanged();
                    personCount.setText(Html.fromHtml("<font color='#666666'>本次已选中</font><font color='#d7252c'>  " + selectedCount + "</font><font color='#666666'> 人</font>"));
                }
            });
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            listView.addHeaderView(groupInfoView, null, false);
            adapter = new SelecteActorAdapter(this, list);
            listView.setAdapter(adapter);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    GroupMemberInfo info = adapter.getList().get(position - listView.getHeaderViewsCount());
                    if (info.getIs_active() == 0 && !getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false)) { //未注册的用户
                        CommonMethod.makeNoticeShort(getApplicationContext(), "该用户还未注册，不能选择", CommonMethod.ERROR);
                        return;
                    }
                    info.setSelected(!info.isSelected());
                    selectedCount = info.isSelected() ? selectedCount + 1 : selectedCount - 1;
                    personCount.setText(Html.fromHtml("<font color='#666666'>本次已选中</font><font color='#d7252c'>  " + selectedCount + "</font><font color='#666666'> 人</font>"));
                    adapter.notifyDataSetChanged();
                    isSelectedAll = selectedCount == getRegisterUserCount() ? true : false;
                    groupInfoSelecteImage.setImageResource(isSelectedAll ? R.drawable.checkbox_pressed : R.drawable.checkbox_normal);
                }
            });
            if (selectedCount == getRegisterUserCount()) {
                groupInfoSelecteImage.setImageResource(R.drawable.checkbox_pressed);
                isSelectedAll = true;
            } else {
                groupInfoSelecteImage.setImageResource(R.drawable.checkbox_normal);
                isSelectedAll = false;
            }
        } else {
            adapter.updateList(list);
        }
    }


    @Override
    public void onClick(View v) {
        Intent intent = getIntent();
        intent.putExtra(Constance.BEAN_CONSTANCE, (Serializable) getSelectedUsers());
        intent.putExtra(Constance.BEAN_BOOLEAN, isSelectedAll);
        setResult(Constance.SELECTED_ACTOR, intent);
        finish();
    }


    /**
     * 功能:设置参与者适配器
     * 时间:2017年6月7日17:05:45
     * 作者:xuj
     */
    public class SelecteActorAdapter extends PersonBaseAdapter {
        /**
         * 列表数据
         */
        private ArrayList<GroupMemberInfo> list;
        /**
         * xml解析器
         */
        private LayoutInflater inflater;

        public SelecteActorAdapter(Context context, ArrayList<GroupMemberInfo> list) {
            super();
            this.list = list;
            inflater = LayoutInflater.from(context);
        }

        @Override
        public int getCount() {
            return list == null ? 0 : list.size();
        }

        @Override
        public Object getItem(int position) {
            return list.get(position);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }


        @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
        @Override
        public View getView(final int position, View convertView, ViewGroup parent) {
            ViewHolder holder;
            if (convertView == null) {
                convertView = inflater.inflate(R.layout.item_choose_member, null);
                holder = new ViewHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            bindData(holder, position, convertView);
            return convertView;
        }

        private void bindData(ViewHolder holder, int position, View convertView) {
            GroupMemberInfo bean = list.get(position);
            holder.roundImageHashText.setView(bean.getHead_pic(), bean.getReal_name(), position);
            if (!TextUtils.isEmpty(matchString)) { //如果过滤文字不为空
                Pattern p = Pattern.compile(matchString);
                SpannableStringBuilder builder = new SpannableStringBuilder(bean.getReal_name());
                Matcher nameMatch = p.matcher(bean.getReal_name());
                while (nameMatch.find()) {
                    ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                    builder.setSpan(redSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                }
                holder.name.setText(builder);
                holder.tel.setText(bean.getTelephone());
            } else {
                setTelphoneAndRealName(bean.getReal_name(), bean.getTelephone(), holder.name, holder.tel);
            }
            holder.tel.setVisibility(View.GONE);
            holder.seletedImage.setImageResource(bean.isSelected() ? R.drawable.checkbox_pressed : R.drawable.checkbox_normal);
            holder.bottomDesc.setVisibility(View.GONE);
            holder.seletedImage.setVisibility(bean.getIs_active() == 1 || getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false) ? View.VISIBLE : View.INVISIBLE);
            holder.isRegister.setVisibility(bean.getIs_active() == 0 ? View.VISIBLE : View.GONE);

            if (LetterSectionUtil.getPositionForSection(list, bean.getSortLetters(), position)) {
                holder.catalog.setVisibility(View.VISIBLE);
                holder.background.setVisibility(View.GONE);
                holder.catalog.setText(bean.getSortLetters());
            } else {
                holder.catalog.setVisibility(View.GONE);
                holder.background.setVisibility(View.VISIBLE);
            }
        }


        class ViewHolder {
            public ViewHolder(View convertView) {
                name = (TextView) convertView.findViewById(R.id.name);
                tel = (TextView) convertView.findViewById(R.id.telph);
                seletedImage = (ImageView) convertView.findViewById(R.id.seletedImage);
                bottomDesc = (TextView) convertView.findViewById(R.id.bottomDesc);
                isRegister = (ImageView) convertView.findViewById(R.id.isRegister);
                roundImageHashText = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.roundImageHashText);
                background = convertView.findViewById(R.id.background);
                catalog = (TextView) convertView.findViewById(R.id.catalog);
            }

            /**
             * 名称
             */
            TextView name;
            /**
             * 电话号码
             */
            TextView tel;
            /**
             * 是否勾选
             */
            ImageView seletedImage;
            /**
             * 人员数量
             */
            TextView bottomDesc;
            /**
             * 是否注册
             */
            ImageView isRegister;
            /**
             * 头像、HashCode文本
             */
            RoundeImageHashCodeTextLayout roundImageHashText;

            /**
             * 首字母
             */
            TextView catalog;
            /**
             * 首字母背景色
             */
            View background;

        }


        public void updateList(ArrayList<GroupMemberInfo> list) {
            this.list = list;
            notifyDataSetChanged();
        }

        public ArrayList<GroupMemberInfo> getList() {
            return list;
        }

        public void setList(ArrayList<GroupMemberInfo> list) {
            this.list = list;
        }

    }

}
