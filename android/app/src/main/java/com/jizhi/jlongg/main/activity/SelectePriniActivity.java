package com.jizhi.jlongg.main.activity;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.text.Editable;
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

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * CName:选择负责人
 * User: xuj
 * Date: 2017年3月31日
 * Time: 14:26:05
 */
public class SelectePriniActivity extends BaseActivity {
    /**
     * 列表适配器
     */
    private SelectePriniAdapter adapter;
    /**
     * listView
     */
    private ListView listView;
    /**
     * 列表数据
     */
    private List<GroupMemberInfo> list;
    /**
     * 筛选文字
     */
    private String matchString;
    /**
     * 无数据时提示的话语
     * 当输入框搜索时如果未查询到数据需要显示:未找到对应成员
     * 当输入框未搜索时如果未查询到数据需要显示:暂无成员
     */
    private TextView defaultDesc;

    /**
     * @param context
     */
    public static void actionStart(Activity context, String uid) {
        Intent intent = context.getIntent();
        intent.putExtra(Constance.UID, uid);
        intent.setClass(context, SelectePriniActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * @param context
     */
    public static void actionStart(Activity context, String uid, String group_id) {
        Intent intent = new Intent();
        intent.putExtra(Constance.UID, uid);
        intent.putExtra(Constance.GROUP_ID, group_id);
        intent.setClass(context, SelectePriniActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.listview_sidebar_search);
        initView();
        getGroupMember();
    }

    /**
     * 获取项目组成员
     */
    private void getGroupMember() {
        Intent intent = getIntent();
        String classType = intent.getStringExtra(Constance.CLASSTYPE);
        String groupId = intent.getStringExtra(Constance.GROUP_ID);
        MessageUtil.getGroupMembers(this, groupId, TextUtils.isEmpty(classType) ? WebSocketConstance.TEAM : classType, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<GroupMemberInfo> memberInfos = (ArrayList<GroupMemberInfo>) object;
                if (memberInfos != null && memberInfos.size() > 0) {
                    //获取上个页面已选中的成员id
                    String uid = getIntent().getStringExtra(Constance.UID);
                    if (!TextUtils.isEmpty(uid)) {
                        for (GroupMemberInfo groupMemberInfo : memberInfos) {
                            if (groupMemberInfo.getUid().equals(uid)) {
                                groupMemberInfo.setSelected(true);
                                break;
                            }
                        }
                    }
                    setAdapter(memberInfos);
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }

    private void initView() {
        setTextTitle(R.string.selected_prini);
        listView = (ListView) findViewById(R.id.listView);
        defaultDesc = getTextView(R.id.defaultDesc);
        defaultDesc.setText("暂无成员");
        TextView centerText = getTextView(R.id.center_text); //当前正在搜索的英文字母
        SideBar sideBar = (SideBar) findViewById(R.id.sidrbar); //侧边搜索框
        sideBar.setTextView(centerText);
        sideBar.setOnTouchingLetterChangedListener(new SideBar.OnTouchingLetterChangedListener() { // 设置右侧触摸监听
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
     * 设置列表适配器
     *
     * @param list
     */
    private void setAdapter(final ArrayList<GroupMemberInfo> list) {
        Utils.setPinYinAndSort(list);
        if (adapter == null) {
            adapter = new SelectePriniAdapter(this, list);
            listView.setAdapter(adapter);
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    GroupMemberInfo info = adapter.getList().get(position);
                    if (info.getIs_active() == 0) { //未注册的用户
                        CommonMethod.makeNoticeShort(getApplicationContext(), "该用户还未注册，不能选择", CommonMethod.ERROR);
                        return;
                    }
                    info.setSelected(true);
                    Intent intent = getIntent();
                    intent.putExtra(Constance.BEAN_CONSTANCE, info);
                    setResult(Constance.SELECTED_PRINCIPAL, intent);
                    finish();
                }
            });
        } else {
            adapter.updateList(list);
        }
        this.list = list;
    }


    /**
     * 功能:设置责任人适配器
     * 时间:2017年6月7日17:05:45
     * 作者:xuj
     */
    public class SelectePriniAdapter extends PersonBaseAdapter {
        /**
         * 列表数据
         */
        private ArrayList<GroupMemberInfo> list;
        /**
         * xml解析器
         */
        private LayoutInflater inflater;

        public SelectePriniAdapter(Context context, ArrayList<GroupMemberInfo> list) {
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
                convertView = inflater.inflate(R.layout.item_choose_prini, null);
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
            } else {
                holder.name.setText(bean.getReal_name());
            }
            holder.isSelected.setVisibility(bean.isSelected() ? View.VISIBLE : View.INVISIBLE);
            holder.isRegister.setVisibility(bean.getIs_active() == 0 ? View.VISIBLE : View.INVISIBLE);
            if (LetterSectionUtil.getPositionForSection(list, bean.getSortLetters(), position)) {
                holder.catalog.setVisibility(View.VISIBLE);
                holder.background.setVisibility(View.GONE);
                holder.catalog.setText(bean.getSortLetters());
            } else {
                holder.background.setVisibility(View.VISIBLE);
                holder.catalog.setVisibility(View.GONE);
            }
        }


        class ViewHolder {
            public ViewHolder(View convertView) {
                name = (TextView) convertView.findViewById(R.id.name);
                isSelected = (ImageView) convertView.findViewById(R.id.isSelected);
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
             * 是否勾选
             */
            ImageView isSelected;
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
