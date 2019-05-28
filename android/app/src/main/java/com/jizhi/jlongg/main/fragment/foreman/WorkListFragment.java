package com.jizhi.jlongg.main.fragment.foreman;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.BaseExpandableListAdapter;
import android.widget.ExpandableListView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.DownLoadBillActivity;
import com.jizhi.jlongg.main.activity.ListDetailActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.BillingList;
import com.jizhi.jlongg.main.bean.BillingListDetail;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.PinnedHeaderExpandableListView;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;
import com.lidroid.xutils.view.annotation.ViewInject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * 记账清单 Fragment
 *
 * @author Xuj
 * @time 2016年2月26日 10:01:47
 * @Version 1.0
 */
@SuppressLint("ValidFragment")
public class WorkListFragment extends Fragment implements OnScrollListener {

    private String TAG = getClass().getName();

    /**
     * 传1是看人、传2是看项目
     */
    private int filter;

    /**
     * 当前角色
     */
    private String roler;

    private BaseActivity mActivity;

    private View main_view;

    /**
     * 列表数据
     */
    private List<BillingList> list;


    @ViewInject(R.id.listview)
    private PinnedHeaderExpandableListView listView;

    /**
     * 列表适配器
     */
    private MyExpandableListAdapter adatper;

    private LayoutInflater inflater;
    /**
     * 百分比
     */
    private float money_percentage;

    /**
     * 分页数据
     */
    private int pager;

    /**
     * 底部加载对话框
     */
    private View foot_view;


    public WorkListFragment(int filter) {
        this.filter = filter;
    }

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        mActivity = (BaseActivity) activity;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
//        main_view = inflater.inflate(R.layout.expandlist, container, false);
//        return main_view;
        return null;
    }

    /**
     * 置顶View
     */
    View convertView;
    /**
     * 记录上次
     */
    private int oldGroup = -1;


    /***
     * 初始化View
     */
    public void initView() {
        roler = UclientApplication.getRoler(mActivity);
        listView.setOnScrollListener(this);
        convertView = mActivity.getLayoutInflater().inflate(R.layout.level_one, null); //初始化置顶View
        Group holder = new Group();
        holder.month = (TextView) convertView.findViewById(R.id.month); //月份
        holder.year = (TextView) convertView.findViewById(R.id.year); //年
        holder.income = (TextView) convertView.findViewById(R.id.income); //当月发生额 总数
        holder.cash_advance = (TextView) convertView.findViewById(R.id.cash_advance); //支出
        holder.real_income = (TextView) convertView.findViewById(R.id.real_income); // 收入
        holder.cash_advance_layout = (RelativeLayout) convertView.findViewById(R.id.cash_advance_layout);
        holder.income_layout = (RelativeLayout) convertView.findViewById(R.id.income_layout);
        holder.background = convertView.findViewById(R.id.background);
        holder.desc = (TextView) convertView.findViewById(R.id.desc);
        holder.head = (ImageView) convertView.findViewById(R.id.head);
        convertView.setTag(holder);
        convertView.setVisibility(View.GONE);
        RelativeLayout layout = (RelativeLayout) main_view.findViewById(R.id.layout);
        layout.addView(convertView);
        listView.setOnGroupClickListener(new GroupClickListener());
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View arg0) {
                list.get(expandFlag).setIsSelected(false);
                expandFlag = -1;
                listView.headerViewClick();
            }
        });
        listView.setScrollCallBack(new PinnedHeaderExpandableListView.scrollCallBack() {
            @Override
            public void gone(int gourpPosition) {
                if (convertView.getVisibility() == View.VISIBLE) {
                    if (convertView.getTop() == 0) {
                        convertView.setVisibility(View.GONE);
                    } else {
                        convertView.layout(0, -convertView.getHeight(), convertView.getWidth(), 0);
                    }
                }
            }

            @Override
            public void visible(int groupPosition, int childPosition, boolean isPushed) {
                if (convertView.getVisibility() == View.GONE) {
                    convertView.setVisibility(View.VISIBLE);
                }
                if (oldGroup != groupPosition) {
                    if (convertView.getTop() == 0) {
                        convertView.layout(0, 0, convertView.getWidth(), convertView.getHeight());
                    }
                    adatper.setGroupValue((Group) convertView.getTag(), groupPosition);
                }
                if (convertView.getTop() != 0) {
                    convertView.layout(0, 0, convertView.getWidth(), convertView.getHeight());
                }
                oldGroup = groupPosition;

            }

            @Override
            public void push_up(int groupPosition, int childPosition, int bottom) {
                int headerHeight = convertView.getHeight();
                int y;
                int alpha;
                if (bottom < headerHeight) {
                    y = bottom - headerHeight;
                } else {
                    y = 0;
                }
                if (y != convertView.getTop()) {
                    if (convertView.getVisibility() == View.GONE) {
                        convertView.setVisibility(View.VISIBLE);
                    }
                    convertView.layout(0, y, convertView.getWidth(), convertView.getHeight() + y);
                }
            }
        });
    }


    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        ViewUtils.inject(this, main_view);
        initView();
        refreshData();
    }


    /**
     * 记账清单所需参数
     */
    public RequestParams params() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(mActivity);
        params.addBodyParameter("filter", filter + "");//传1是看人、传2是看项目
        params.addBodyParameter("pg", pager + "");
        return params;
    }

    /**
     * 查询记账清单数据
     */
    public void refreshData() {
        pager += 1;
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.WAGEDETAILDISH,
                params(), mActivity.new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        LUtils.e(TAG, responseInfo.result);
                        try {
                            CommonListJson<BillingList> bean = CommonListJson.fromJson(responseInfo.result, BillingList.class);
                            if (bean.getState() != 0) {
                                if (bean.getValues() != null && bean.getValues().size() > 0) {
                                    if (bean.getValues().size() < 12) {
                                        haveCasheData = false;
                                        listView.removeFooterView(foot_view);
                                    }
                                    if (list == null) {
                                        createList(bean.getValues());
                                    } else {
                                        if (pager == 1) {
                                            list.addAll(bean.getValues());
                                            adatper.calculateMoney();
                                            adatper.notifyDataSetChanged();
                                            listView.expandGroup(expandFlag); //展开上次的二级菜单
                                            list.get(expandFlag).setIsSelected(true);
                                            adatper.setGroupValue((Group) convertView.getTag(), expandFlag); //设置value
                                            convertView.layout(0, 0, convertView.getWidth(), convertView.getHeight());
                                        }
                                    }
                                }
                            } else {
                                pager -= 1;
                                DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                            pager -= 1;
                        } finally {
                            mActivity.closeDialog();
                        }
                        isLoadCacheData = false;
                    }

                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                        super.onFailure(exception, errormsg);
                        if (pager != 1) {
                            foot_view.setVisibility(View.GONE);
                        } else {
                            mActivity.finish();
                        }
                        pager -= 1;
                        isLoadCacheData = false;
                    }
                });
    }


    /**
     * 创建list
     */
    public void createList(List<BillingList> tempList) {
        list = new ArrayList<>();
        list.addAll(tempList);
        adatper = new MyExpandableListAdapter(mActivity);
        listView.setAdapter(adatper);
        if (list.get(0).getList().size() != 0) { //如果 当月第一条 不为null 默认展开
            list.get(0).setIsSelected(true);
            // 展开被选的group
            listView.expandGroup(0);
            // 设置被选中的group置于顶端
            listView.setSelectedGroup(0);
            expandFlag = 0;
            childCount = list.get(0).getList().size();
        }

    }


    /**
     * listView 监听 最后一条
     */
    private int lastItem;
    /**
     * 当上拉数据小于10条的时候 为false
     */
    private boolean haveCasheData = true;
    /**
     * 是否在加载缓存数据
     */
    private boolean isLoadCacheData = false;

    @Override
    public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
        lastItem = (firstVisibleItem + visibleItemCount - 1 - childCount);
        final long flatPos = listView.getExpandableListPosition(firstVisibleItem);
        int groupPosition = ExpandableListView.getPackedPositionGroup(flatPos);
        int childPosition = ExpandableListView.getPackedPositionChild(flatPos);
        if (list != null && list.size() > 0) {
            listView.configureHeaderView(groupPosition, childPosition);
        }
    }

    @Override
    public void onScrollStateChanged(AbsListView view, int scrollState) {
//        if (lastItem == list.size() && scrollState == OnScrollListener.SCROLL_STATE_IDLE) {
//            if (haveCasheData && !isLoadCacheData) {// 是否还有缓存数据
//                isLoadCacheData = true;
//                foot_view.setVisibility(View.VISIBLE);
//            }
//        }
    }


    class MyExpandableListAdapter extends BaseExpandableListAdapter implements PinnedHeaderExpandableListView.HeaderAdapter {


        private Context context;
        /**
         * resrouce
         */
        private Resources res;


        public MyExpandableListAdapter(Context context) {
            inflater = LayoutInflater.from(context);
            this.context = context;
            res = context.getResources();
            calculateMoney();
        }


        /**
         * 计算当年 每个月最大金额  算出条形图 所占的百分比
         */
        public void calculateMoney() {
            float total_expand = 0; //借支
            float total_income = 0; //收入
            for (int i = 0; i < list.size(); i++) {
                float temp_expand = Float.parseFloat(list.get(i).getM_total_expend());
                float temp_incom = Float.parseFloat(list.get(i).getM_total_income());
                if (temp_expand > total_expand) {
                    total_expand = temp_expand;
                }
                if (temp_incom > total_income) {
                    total_income = temp_incom;
                }
            }
            float money = 0;
            if (total_expand > total_income) {
                money = total_expand;
            } else {
                money = total_income;
            }
            int dp = DensityUtils.dp2px(context, 180);
            money_percentage = dp / money;
        }


        @Override
        public int getGroupCount() {
            return list.size();
        }

        @Override
        public int getChildrenCount(int groupPosition) {
            return list.get(groupPosition).getList().size();
        }

        @Override
        public Object getGroup(int groupPosition) {
            return list.get(groupPosition);
        }

        @Override
        public Object getChild(int groupPosition, int childPosition) {
            return list.get(groupPosition).getList().get(childPosition);
        }

        @Override
        public long getGroupId(int groupPosition) {
            return groupPosition;
        }

        @Override
        public long getChildId(int groupPosition, int childPosition) {
            return childPosition;
        }

        @Override
        public boolean hasStableIds() {
            return true;
        }

        @Override
        public boolean isChildSelectable(int groupPosition, int childPosition) {
            return true;
        }

        @Override
        public boolean areAllItemsEnabled() {
            return false;
        }

        @Override
        public boolean isEmpty() {
            return false;
        }


        @Override
        public long getCombinedChildId(long groupId, long childId) {
            return 0;
        }

        @Override
        public long getCombinedGroupId(long groupId) {
            return 0;
        }


        @Override
        public int getHeaderState(int groupPosition, int childPosition) {
            final int childCount = getChildrenCount(groupPosition);
            if (childPosition == childCount - 1 && childCount != 0) { //向下滑动
                return PINNED_HEADER_PUSHED_UP;
            } else if (childPosition == -1 && !listView.isGroupExpanded(groupPosition)) { //隐藏View
                return PINNED_HEADER_GONE;
            } else { //显示头部
                return PINNED_HEADER_VISIBLE;
            }
        }

        private HashMap<Integer, Integer> groupStatusMap = new HashMap<Integer, Integer>();

        @Override
        public void setGroupClickStatus(int groupPosition, int status) {
            groupStatusMap.put(groupPosition, status);
        }

        @Override
        public int getGroupClickStatus(int groupPosition) {
            if (groupStatusMap.containsKey(groupPosition)) {
                return groupStatusMap.get(groupPosition);
            } else {
                return 0;
            }
        }

        @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
        public void setGroupValue(Group holder, int groupPosition) {
            BillingList bean = list.get(groupPosition);
            holder.month.setText(bean.getMonth() < 10 ? "0" + bean.getMonth() : bean.getMonth() + "");
            holder.year.setText(bean.getYear() + "");
            int role = Integer.parseInt(UclientApplication.getRoler(mActivity));
            switch (role) {
                case 1:
                    holder.income.setText("收入:" + bean.getM_total_income());
                    holder.desc.setText("实际收入");
                    break;
                case 2:
                    holder.income.setText("应付:" + bean.getM_total_income());
                    holder.desc.setText("实际应付");
                    break;
            }
            holder.cash_advance.setText("借支:" + bean.getM_total_expend());
            holder.real_income.setText("¥" + bean.getM_total());
            if (Float.parseFloat(bean.getM_total()) <= 0) {
                holder.real_income.setTextColor(res.getColor(R.color.green_7ec568));
            } else {
                holder.real_income.setTextColor(res.getColor(R.color.red_f75a23));
            }
            if (Float.parseFloat(bean.getM_total_income()) == 0) {
                holder.income.setTextColor(res.getColor(R.color.red_f75a23));
                holder.income_layout.setBackground(null);
            } else {
                RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) holder.income_layout.getLayoutParams();
                params.width = (int) (Math.round(Float.parseFloat(bean.getM_total_income()) * money_percentage));
                holder.income_layout.setLayoutParams(params);
                Utils.setBackGround(holder.income_layout, res.getDrawable(R.drawable.bg_pk_ffcccc));
                holder.income.setTextColor(res.getColor(R.color.black_333333));
            }
            if (Float.parseFloat(bean.getM_total_expend()) == 0) {
                holder.cash_advance.setTextColor(res.getColor(R.color.green_7ec568));
                holder.cash_advance_layout.setBackground(null);
            } else {
                RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) holder.cash_advance_layout.getLayoutParams();
                params.width = (int) (Math.round(Float.parseFloat(bean.getM_total_expend()) * money_percentage));
                holder.cash_advance_layout.setLayoutParams(params);
                holder.cash_advance.setTextColor(res.getColor(R.color.black_333333));
                Utils.setBackGround(holder.cash_advance_layout, res.getDrawable(R.drawable.bg_gn_b2ead0_sk1px));
            }
            if (bean.isSelected()) {
                holder.background.setVisibility(View.GONE);
                holder.head.setImageResource(R.drawable.gray_down);
            } else {
                holder.background.setVisibility(View.VISIBLE);
                holder.head.setImageResource(R.drawable.houtui);
            }
        }

        @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
        @Override
        public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {  //创建组Group
            Group holder = null;
            if (convertView == null) {
                holder = new Group();
                convertView = inflater.inflate(R.layout.level_one, null);
                holder.month = (TextView) convertView.findViewById(R.id.month);
                holder.year = (TextView) convertView.findViewById(R.id.year);
                holder.income = (TextView) convertView.findViewById(R.id.income);
                holder.cash_advance = (TextView) convertView.findViewById(R.id.cash_advance);
                holder.real_income = (TextView) convertView.findViewById(R.id.real_income);
                holder.cash_advance_layout = (RelativeLayout) convertView.findViewById(R.id.cash_advance_layout);
                holder.income_layout = (RelativeLayout) convertView.findViewById(R.id.income_layout);
                holder.background = convertView.findViewById(R.id.background);
                holder.desc = (TextView) convertView.findViewById(R.id.desc);
                holder.head = (ImageView) convertView.findViewById(R.id.head);
                convertView.setTag(holder);
            } else {
                holder = (Group) convertView.getTag();
            }
            setGroupValue(holder, groupPosition);
            return convertView;
        }

        @Override
        public View getChildView(final int groupPosition, final int childPosition, boolean isLastChild, View convertView, ViewGroup parent) { //创建子group
            Child holder = null;
            final BillingListDetail bean = list.get(groupPosition).getList().get(childPosition);
            if (convertView == null) {
                holder = new Child();
                convertView = inflater.inflate(R.layout.level_two, null);
                holder.name = (TextView) convertView.findViewById(R.id.name);
                holder.price = (TextView) convertView.findViewById(R.id.price);
                holder.count = (TextView) convertView.findViewById(R.id.count);
                holder.layout_head = (LinearLayout) convertView.findViewById(R.id.layout_head);
                holder.layout_content = (RelativeLayout) convertView.findViewById(R.id.layout_content);
                holder.background = convertView.findViewById(R.id.background);
                holder.name_title = (TextView) convertView.findViewById(R.id.name_title);
                holder.layout_tail = (LinearLayout) convertView.findViewById(R.id.layout_tail);
                holder.click_month_layout = (LinearLayout) convertView.findViewById(R.id.click_month_layout);
                holder.month_account = (TextView) convertView.findViewById(R.id.month_account);
                convertView.setTag(holder);
            } else {
                holder = (Child) convertView.getTag();
            }
            if (childPosition == 0) {
                if (filter == Constance.TYPE_PERSON) {
                    if (roler.equals(Constance.ROLETYPE_WORKER)) {
                        holder.name_title.setText("班组长/工头");
                    } else {
                        holder.name_title.setText("工人");
                    }
                } else {
                    holder.name_title.setText("项目");
                }
                if (childPosition == list.get(groupPosition).getList().size() - 1) {
                    holder.layout_tail.setVisibility(View.VISIBLE);
                    holder.background.setVisibility(View.VISIBLE);
                    if (filter == Constance.TYPE_PERSON) {
                        holder.month_account.setText(String.format(getString(R.string.month_account), list.get(groupPosition).getMonth()));
                    } else {
                        holder.layout_tail.setVisibility(View.GONE);
                    }
                } else {
                    holder.background.setVisibility(View.GONE);
                    holder.layout_tail.setVisibility(View.GONE);
                }
                holder.layout_head.setVisibility(View.VISIBLE);
            } else {
                if (childPosition == list.get(groupPosition).getList().size() - 1) {
                    holder.layout_tail.setVisibility(View.VISIBLE);
                    holder.background.setVisibility(View.VISIBLE);
                    if (filter == Constance.TYPE_PERSON) {
                        holder.month_account.setText(String.format(getString(R.string.month_account), list.get(groupPosition).getMonth()));
                    } else {
                        holder.layout_tail.setVisibility(View.GONE);
                    }
                } else {
                    holder.layout_tail.setVisibility(View.GONE);
                    holder.background.setVisibility(View.GONE);
                }
                holder.layout_head.setVisibility(View.GONE);
            }
            holder.name.setText(bean.getName());
            holder.count.setText(bean.getT_poor() + "");
            holder.price.setText("¥" + bean.getT_total());
            if (Float.parseFloat(bean.getT_total()) <= 0) {
                holder.price.setTextColor(res.getColor(R.color.green_7ec568));
            } else {
                holder.price.setTextColor(res.getColor(R.color.red_f75a23));
            }
            holder.layout_content.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    BillingList group = list.get(groupPosition);
                    Intent intent = new Intent(mActivity, ListDetailActivity.class);
                    String title = null;
                    if (bean.getName().equals("其他项目")) {
                        title = "其他";
                    } else {
                        title = bean.getName();
                    }
                    int month = group.getMonth();
                    intent.putExtra("cur_uid", group.getCur_uid() + "");
                    intent.putExtra(Constance.BEAN_STRING, title); //标题名称
                    intent.putExtra(Constance.UID, bean.getUid() + ""); //uid
                    intent.putExtra(Constance.PID, bean.getPid()); //项目id
                    intent.putExtra(Constance.YEAR, group.getYear() + ""); //项目id
                    intent.putExtra(Constance.MONTH, (month < 10 ? "0" + month : month + "")); //项目id
                    intent.putExtra(Constance.BEAN_INT, filter);
                    startActivityForResult(intent, 100);
                }
            });
            holder.click_month_layout.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    BillingList group = list.get(groupPosition);
                    int year = group.getYear();
                    int month = group.getMonth();
                    StringBuilder sb = new StringBuilder();
                    String role = UclientApplication.getRoler(mActivity);
                    role = role.equals(Constance.ROLETYPE_WORKER) ? Constance.ROLETYPE_FM : Constance.ROLETYPE_WORKER;
                    sb.append("role=" + role + "&");
                    sb.append("year=" + year + "&");
                    sb.append("month=" + (month < 10 ? "0" + month : month) + "&");
                    sb.append("cur_uid=" + group.getCur_uid() + "&");
                    sb.append("type=total&");
                    sb.append("ver=" + AppUtils.getVersionName(mActivity));
                    Intent intent = new Intent(mActivity, DownLoadBillActivity.class);
                    intent.putExtra(Constance.BEAN_STRING, sb.toString());
                    intent.putExtra("year", year + "");
                    intent.putExtra("month", month < 10 ? "0" + month : month);
                    startActivity(intent);
                }
            });


//            int type = getChildType(groupPosition, childPosition);
//            switch (type) {
//                case CHILD_HEAD_LAYOUT: //头部分
//                    if (convertView == null) {
//                        convertView = inflater.inflate(R.layout.account_list_head, null);
//                        holder = new Child();
//                        holder.name_title = (TextView) convertView.findViewById(R.id.name_title);
//                        convertView.setTag(holder);
//                    } else {
//                        holder = (Child) convertView.getTag();
//                    }
//                    if (filter == Constance.TYPE_PERSON) {
//                        if (roler.equals(Constance.ROLETYPE_WORKER)) {
//                            holder.name_title.setText("工头/班组长");
//                        } else {
//                            holder.name_title.setText("工人");
//                        }
//                    } else {
//                        holder.name_title.setText("项目");
//                    }
//                    break;
//                case CHILD_TAILS_LAYOUT: //尾部
//                    if (convertView == null) {
//                        convertView = inflater.inflate(R.layout.account_list_tail, null);
//                        holder = new Child();
//                        holder.name_title = (TextView) convertView.findViewById(R.id.name_title);
//                        convertView.setTag(holder);
//                    } else {
//                        holder = (Child) convertView.getTag();
//                    }
////                    holder.name_title.setText("");
//                    break;
//                case CHILD_CONTENT_LAYOUT: //内容部分
//                    final BillingListDetail bean = list.get(groupPosition).getList().get(childPosition);
//                    if (convertView == null) {
//                        holder = new Child();
//                        convertView = inflater.inflate(R.layout.level_two, null);
//                        holder.name = (TextView) convertView.findViewById(R.id.name);
//                        holder.price = (TextView) convertView.findViewById(R.id.price);
//                        holder.count = (TextView) convertView.findViewById(R.id.count);
//                        holder.title_layout = (LinearLayout) convertView.findViewById(R.id.title_layout);
//                        holder.project_layout = (RelativeLayout) convertView.findViewById(R.id.project_layout);
//                        holder.background = convertView.findViewById(R.id.background);
//                        holder.name_title = (TextView) convertView.findViewById(R.id.name_title);
//                        convertView.setTag(holder);
//                    } else {
//                        holder = (Child) convertView.getTag();
//                    }
//                    if (childPosition == list.get(groupPosition).getList().size() - 1) {
//                        holder.background.setVisibility(View.VISIBLE);
//                    } else {
//                        holder.background.setVisibility(View.GONE);
//                    }
//                    holder.name.setText(bean.getName());
//                    holder.count.setText(bean.getT_poor() + "");
//                    holder.price.setText("¥" + bean.getT_total());
//                    if (Float.parseFloat(bean.getT_total()) <= 0) {
//                        holder.price.setTextColor(res.getColor(R.color.green_7ec568));
//                    } else {
//                        holder.price.setTextColor(res.getColor(R.color.red_f75a23));
//                    }
//                    holder.project_layout.setOnClickListener(new View.OnClickListener() {
//                        @Override
//                        public void onClick(View v) {
//                            int month = list.get(groupPosition).getMonth();
//                            Intent intent = new Intent(mActivity, ListDetailActivity.class);
//                            String title = null;
//                            if (list.get(groupPosition).getList().get(childPosition).getName().equals("其他项目")) {
//                                title = "其他";
//                            } else {
//                                title = list.get(groupPosition).getList().get(childPosition).getName();
//                            }
//                            intent.putExtra(Constance.BEAN_STRING, title); //标题名称
//                            intent.putExtra(Constance.UID, bean.getUid() + ""); //uid
//                            intent.putExtra(Constance.PID, bean.getPid() + ""); //项目id
//                            intent.putExtra(Constance.DATE, list.get(groupPosition).getYear() + (month < 10 ? "0" + month : month + "")); //日期
//                            intent.putExtra(Constance.BEAN_INT, filter);
//                            startActivityForResult(intent, 100);
//                        }
//                    });
//                    break;
//            }
            return convertView;
        }
    }


    class Group {
        TextView desc;

        View background;
        /**
         * 年
         */
        TextView year;
        /**
         * 月
         */
        TextView month;
        /**
         * 收入
         */
        TextView income;
        /**
         * 借支
         */
        TextView cash_advance;
        /**
         * 实际收入
         */
        TextView real_income;
        /**
         * 收入layout
         */
        RelativeLayout income_layout;
        /**
         * 支出layout
         */
        RelativeLayout cash_advance_layout;
        /**
         * 箭头
         */
        ImageView head;
    }

    class Child {

        /**
         * 背景
         */
        View background;
        /**
         * 头部文字
         */
        TextView name_title;
        /**
         * 尾部Layout
         */
        LinearLayout layout_tail;

        /**
         * 保存账单Layout
         */
        LinearLayout click_month_layout;

        /**
         * 几月账单
         */
        TextView month_account;

        RelativeLayout layout_content;
        /**
         * 标题栏layout
         */
        LinearLayout layout_head;
        /**
         * 名称
         */
        TextView name;
        /**
         * 工钱
         */
        TextView price;
        /**
         * 差账次数
         */
        TextView count;

    }

    private int expandFlag = -1;// 控制列表的展开
    private int childCount = 0;

    class GroupClickListener implements ExpandableListView.OnGroupClickListener {
        @Override
        public boolean onGroupClick(ExpandableListView parent, View v, int groupPosition, long id) {
            if (list.get(groupPosition).getList().size() == 0) {
                listView.collapseGroup(groupPosition);
                adatper.setGroupClickStatus(groupPosition, 0);
                return true;
            }
            if (expandFlag == -1) {
                list.get(groupPosition).setIsSelected(true);
                // 展开被选的group
                listView.expandGroup(groupPosition);
                // 设置被选中的group置于顶端
                listView.setSelectedGroup(groupPosition);
                expandFlag = groupPosition;
                childCount = list.get(groupPosition).getList().size();
            } else if (expandFlag == groupPosition) {
                list.get(groupPosition).setIsSelected(false);
                listView.collapseGroup(expandFlag);
                expandFlag = -1;
                childCount = 0;
            } else {
                list.get(expandFlag).setIsSelected(false);
                list.get(groupPosition).setIsSelected(true);
                listView.collapseGroup(expandFlag);
                // 展开被选的group
                listView.expandGroup(groupPosition);
                // 设置被选中的group置于顶端
                listView.setSelectedGroup(groupPosition);
                expandFlag = groupPosition;
                childCount = list.get(groupPosition).getList().size();
            }
            return true;
        }

    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode == Constance.SUCCESS) {
            listView.collapseGroup(expandFlag);
            pager = 0;
            haveCasheData = true;
            list.clear();
            refreshData();
        }
    }
}
