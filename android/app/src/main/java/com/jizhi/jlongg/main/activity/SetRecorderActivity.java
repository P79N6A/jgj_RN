package com.jizhi.jlongg.main.activity;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.text.Editable;
import android.text.Html;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.cityslist.widget.SideBar;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

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
public class SetRecorderActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 记录员适配器
     */
    private SetRecoderAdapter adapter;
    /**
     * 已选中人员
     */
    private TextView personCount;
    /**
     * 记录员人员数量
     */
    private int count;
    /**
     * 记录员列表数据
     */
    private List<GroupMemberInfo> list;
    /**
     * 筛选文字
     */
    private String matchString;
    /**
     * listView
     */
    private ListView listView;


    /**
     * @param context
     * @param isCLose
     */
    public static void actionStart(Activity context,boolean isCLose) {
        Intent intent = context.getIntent();
        intent.putExtra(Constance.IS_CLOSED,isCLose);
        intent.setClass(context, SetRecorderActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.bottom_add_member_sidebar_layout);
        initView();
        getRecorders();
    }

    private void initView() {
        setTextTitle(R.string.set_recorder);
        getTextView(R.id.defaultDesc).setText("暂无成员");
        findViewById(R.id.bottom_layout).setVisibility(getIntent().getBooleanExtra(Constance.IS_CLOSED,false)?View.GONE:View.VISIBLE);
        personCount = (TextView) findViewById(R.id.personCount);
        listView = (ListView) findViewById(R.id.listView);
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

        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        mClearEditText.setHint("请输入成员名字进行搜索");
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
                final List<GroupMemberInfo> filterDataList = SearchMatchingUtil.match(GroupMemberInfo.class, list, matchString);
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
     * 获取已选中记录员id
     */
    private String getSelectedReportId() {
        if (adapter != null && adapter.getList() != null && adapter.getList().size() > 0) {
            StringBuilder builder = new StringBuilder();
            int i = 0;
            for (GroupMemberInfo bean : adapter.getList()) {
                if (bean.isSelected()) {
                    builder.append(i == 0 ? bean.getUid() : "," + bean.getUid());
                    i += 1;
                }
            }
            return builder.toString();
        }
        return null;
    }

    /**
     * 获取记录员数量
     */
    private int getRecordersCount(List<GroupMemberInfo> list) {
        if (list != null && list.size() > 0) {
            int count = 0;
            for (GroupMemberInfo bean : list) {
                if (bean.getIs_report() == 1) {
                    count += 1;
                    bean.setSelected(true);
                }
            }
            return count;
        }
        return 0;
    }


    /**
     * 设置记录员
     */
    public void setReport() {
        String URL = NetWorkRequest.SET_REPORT;
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("class_type", WebSocketConstance.TEAM);//类型为项目组
        params.addBodyParameter("group_id", getIntent().getStringExtra(Constance.GROUP_ID));// 组id
        final String reportUid = getSelectedReportId();
        if (TextUtils.isEmpty(reportUid)) { //清空所有的记录员
            params.addBodyParameter("is_del", "1");
        } else {
            params.addBodyParameter("uid", reportUid); //	记录员的UID，多个人是，以’,’号隔开
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, URL, params, new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<BaseNetBean> base = CommonJson.fromJson(responseInfo.result, BaseNetBean.class);
                    if (base.getState() != 0) {
                        CommonMethod.makeNoticeShort(getApplicationContext(), TextUtils.isEmpty(reportUid) ? "你还未选择任何记录员" : "设置成功", CommonMethod.SUCCESS);
                        finish();
                    } else {
                        DataUtil.showErrOrMsg(SetRecorderActivity.this, base.getErrno(), base.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    closeDialog();
                }
            }
        });

    }


    /**
     * 获取记录员
     */
    private void getRecorders() {
        MessageUtil.getGroupMembers(this, getIntent().getStringExtra(Constance.GROUP_ID), WebSocketConstance.TEAM, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<GroupMemberInfo> serverList = (ArrayList<GroupMemberInfo>) object;
                if (serverList != null && serverList.size() > 0) {
                    count = getRecordersCount(serverList);
                    setAdapter(serverList);
                    personCount.setText(Html.fromHtml("<font color='#666666'>本次已选中</font><font color='#d7252c'> " + count + "</font><font color='#666666'> 人</font>"));
                } else {
                    CommonMethod.makeNoticeShort(getApplicationContext(), "该项目中没有更多的成员可添加", CommonMethod.ERROR);
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    /**
     * 设置列表适配器
     *
     * @param list
     */
    private void setAdapter(List<GroupMemberInfo> list) {
        Utils.setPinYinAndSort(list);
        if (adapter == null) {
            adapter = new SetRecoderAdapter(this, list,getIntent().getBooleanExtra(Constance.IS_CLOSED,false));
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            listView.setAdapter(adapter);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    GroupMemberInfo info = adapter.getList().get(position);
                    if (info.getIs_active() == 0) { //未注册的用户
                        CommonMethod.makeNoticeShort(getApplicationContext(), "该用户还未注册，不能选择", CommonMethod.ERROR);
                        return;
                    }
                    boolean isSelected = info.isSelected();
                    count = isSelected ? count - 1 : count + 1;
                    info.setSelected(!isSelected);
                    personCount.setText(Html.fromHtml("<font color='#666666'>本次已选中</font><font color='#d7252c'>  " +
                            count + "</font><font color='#666666'> 人</font>"));
                    adapter.notifyDataSetChanged();
                }
            });
        } else {
            adapter.updateList(list);
        }
        this.list = list;
    }


    @Override
    public void onClick(View v) {
        setReport();
    }


    /**
     * 功能:设置记录员适配器
     * 时间:2017年3月31日15:21:22
     * 作者:xuj
     */
    public class SetRecoderAdapter extends BaseAdapter {
        /**
         * 列表数据
         */
        private List<GroupMemberInfo> list;
        /**
         * xml解析器
         */
        private LayoutInflater inflater;
        /**
         * true 表示项目已关闭
         */
        private boolean isClose;

        public SetRecoderAdapter(Context context, List<GroupMemberInfo> list,boolean isClose) {
            super();
            this.list = list;
            this.isClose = isClose;
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
                convertView = inflater.inflate(R.layout.set_recorder_item, null);
                holder = new ViewHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            bindData(holder, position, convertView);
            return convertView;
        }

        private void bindData(ViewHolder holder, int position, View convertView) {
            holder.firstTips.setVisibility(position == 0 ? View.VISIBLE : View.GONE);
            GroupMemberInfo groupMemberInfo = list.get(position);
            holder.isRegister.setVisibility(groupMemberInfo.getIs_active() == 0 ? View.VISIBLE : View.GONE); //是否注册
            if (!TextUtils.isEmpty(matchString)) { //如果过滤文字不为空
                Pattern p = Pattern.compile(matchString);
                SpannableStringBuilder builder = new SpannableStringBuilder(groupMemberInfo.getReal_name());
                Matcher nameMatch = p.matcher(groupMemberInfo.getReal_name());
                while (nameMatch.find()) {
                    ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                    builder.setSpan(redSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                }
                holder.name.setText(builder);
            } else {
                holder.name.setText(groupMemberInfo.getReal_name()); //名称
            }
            holder.roundImageHashText.setView(groupMemberInfo.getHead_pic(), groupMemberInfo.getReal_name(), position); //设置头像
            if(isClose){
                holder.seletedImage.setVisibility(View.GONE);
            }else{
                holder.seletedImage.setVisibility(View.VISIBLE);
                holder.seletedImage.setImageResource(!groupMemberInfo.isSelected() ? R.drawable.checkbox_normal : R.drawable.checkbox_pressed);
            }

            int section = getSectionForPosition(position);
            // 如果当前位置等于该分类首字母的Char的位置 ，则认为是第一次出现
            if (position == getPositionForSection(section)) {
                holder.catalog.setVisibility(View.VISIBLE);
                holder.background.setVisibility(View.GONE);
                holder.catalog.setText(groupMemberInfo.getSortLetters());
            } else {
                holder.background.setVisibility(View.VISIBLE);
                holder.catalog.setVisibility(View.GONE);
            }
        }


        class ViewHolder {
            public ViewHolder(View convertView) {
                seletedImage = (ImageView) convertView.findViewById(R.id.seletedImage);
                isRegister = (ImageView) convertView.findViewById(R.id.isRegister);
                name = (TextView) convertView.findViewById(R.id.name);
                firstTips = convertView.findViewById(R.id.firstTips);
                roundImageHashText = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.roundImageHashText);
                convertView.findViewById(R.id.telph).setVisibility(View.GONE); //不需要显示电话号码
                background = convertView.findViewById(R.id.background);
                catalog = (TextView) convertView.findViewById(R.id.catalog);
            }


            /**
             * 头像、HashCode文本
             */
            RoundeImageHashCodeTextLayout roundImageHashText;
            /**
             * 提示内容
             */
            View firstTips;
            /**
             * 是否选中
             */
            ImageView seletedImage;
            /**
             * 是否是平台注册用户  1是注册用户
             */
            ImageView isRegister;
            /**
             * 记录员名称
             */
            TextView name;
            /**
             * 首字母
             */
            TextView catalog;
            /**
             * 首字母背景色
             */
            View background;

        }


        public void updateList(List<GroupMemberInfo> list) {
            this.list = list;
            notifyDataSetChanged();
        }

        public List<GroupMemberInfo> getList() {
            return list;
        }

        public void setList(List<GroupMemberInfo> list) {
            this.list = list;
        }

        /**
         * 根据分类的首字母的Char ascii值获取其第一次出现该首字母的位置
         */
        @SuppressWarnings("unused")
        public int getPositionForSection(int section) {
            for (int i = 0; i < getCount(); i++) {
                String sortStr = list.get(i).getSortLetters();
                if (null != sortStr) {
                    char firstChar = sortStr.toUpperCase().charAt(0);
                    if (firstChar == section) {
                        return i;
                    }
                }
            }
            return -1;
        }

        /**
         * 根据ListView的当前位置获取分类的首字母的Char ascii值
         */
        public int getSectionForPosition(int position) {
            if (null == list.get(position).getSortLetters()) {
                return 1;
            }
            return list.get(position).getSortLetters().charAt(0);
        }
    }

}
