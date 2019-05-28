package com.jizhi.jlongg.main.activity;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.PayRollList;
import com.jizhi.jlongg.main.bean.PayRollProList;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RecordUtils;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.Calendar;
import java.util.List;

import static com.jizhi.jlongg.main.util.Constance.REQUEST;

/**
 * 功能: 工资清单详情
 * 作者：Xuj
 * 时间: 2016-7-19 11:10
 */
public class PayrollDetailActivity extends BaseActivity implements View.OnClickListener {


    /**
     * person 按个人 project:按项目
     */
    private String classType;
    /**
     * 当前时间的年月日
     */
    private int year, month;
    /**
     * 上一个月文字描述
     */
    private TextView previousMonthText;
    /**
     * 下一个月文字描述
     */
    private TextView nextMonthText;
    /**
     * 当前日期描述
     */
    private TextView currentDate;
    /**
     * 当前月总发生
     */
    private TextView currentMonthMoney;
    /**
     * 列表适配器
     */
    private PayRollListAdapter adapter;
    /**
     * 没有数据时展示的默认页
     */
    private LinearLayout defaultLayout;

    /**
     * 工人、工头文字描述
     */
    private String foremanWorkerDesc;


    /**
     * @param context
     * @param targetId  项目id
     * @param classType person：按个人（默认）;project:按项目
     */
    public static void actionStart(Activity context, String targetId, String classType, String targetTitle, String date) {
        Intent intent = new Intent(context, PayrollDetailActivity.class);
        intent.putExtra("param1", targetId);
        intent.putExtra("param2", classType);
        intent.putExtra("param3", targetTitle);
        intent.putExtra("param4", date);
        context.startActivityForResult(intent, REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.payroll_detail);
        Intent intent = getIntent();
        String targetId = intent.getStringExtra("param1");
        if (TextUtils.isEmpty(targetId)) {
            CommonMethod.makeNoticeShort(this, "获取id出错了", CommonMethod.ERROR);
            finish();
            return;
        }
        initView();
        setNextPreviousMonth();
        getData();
    }


    private void initView() {
        Intent intent = getIntent();
        defaultLayout = (LinearLayout) findViewById(R.id.defaultLayout);
        previousMonthText = getTextView(R.id.previousMonthText);
        nextMonthText = getTextView(R.id.nextMonthText);
        currentDate = getTextView(R.id.currentDate);
        currentMonthMoney = getTextView(R.id.currentMonthMoney);

        classType = getIntent().getStringExtra("param2");

        String title = intent.getStringExtra("param3");
        String date = intent.getStringExtra("param4");
        SetTitleName.setTitle(findViewById(R.id.title), title);

//        foremanWorkerDesc = UclientApplication.getRoler(this).equals(Constance.ROLETYPE_WORKER) ? "收入" : "应付"; //工友是收入、工头是应付
        foremanWorkerDesc = "工资";
        String[] dates = date.split("-");
        year = Integer.parseInt(dates[0]);
        month = Integer.parseInt(dates[1]);
        currentDate.setText(String.format(getString(R.string.date_desc), year, month, foremanWorkerDesc));
    }

    public RequestParams params() {
        Intent intent = getIntent();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("target_id", intent.getStringExtra("param1")); //目标id
        params.addBodyParameter("class_type", intent.getStringExtra("param2")); //person：按个人（默认）;project:按项目
        params.addBodyParameter("month", year + "" + (month < 10 ? "0" + month : month)); //日期
        return params;
    }

    private void setAdapter(List<PayRollList> list) {
        defaultLayout.setVisibility(list == null || list.size() == 0 ? View.VISIBLE : View.GONE);
        if (adapter == null) {
            ListView listView = (ListView) findViewById(R.id.listView);
            adapter = new PayRollListAdapter(this, list);
            listView.setAdapter(adapter);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    if (position == 0) {
                        return;
                    }
                    String selectedDate = year + "-" + (month < 10 ? "0" + month : month) + "-01";
                    position -= 1;
                    PayRollList bean = adapter.getList().get(position);
                    PayrollDetailLastActivity.actionStart(PayrollDetailActivity.this,
                            bean.getUid() + "",
                            bean.getPid() + "",
                            bean.getName(),//项目名称或 班组长名称
                            getIntent().getStringExtra("param3"),//标题名称
                            selectedDate, classType, getIntent().getStringExtra("param1"));//日期
                }
            });
        } else {
            adapter.updateList(list);
        }
    }


    /**
     * 根据用户id查询个人清单
     */
    public void getData() {
        if (adapter != null) { //为了保证数据的完整性 ,先清空在设置
            adapter.updateList(null);
        }
        currentMonthMoney.setText("¥0.00");
        String URL = NetWorkRequest.PERANDPROMONTHBILL;
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, URL, params(), new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<PayRollProList> base = CommonJson.fromJson(responseInfo.result, PayRollProList.class);
                    if (base.getState() != 0 && base.getValues() != null) {
                        PayRollProList bean = base.getValues();
                        currentMonthMoney.setTextColor(ContextCompat.getColor(getApplicationContext(), bean.getTotal_month() >= 0 ? R.color.app_color : R.color.green)); //设置收入颜色
                        currentMonthMoney.setText(Utils.m2(bean.getTotal_month())); //设置当前月收入
                        setAdapter(bean.getList());
                    } else {
                        CommonMethod.makeNoticeShort(PayrollDetailActivity.this, base.getErrmsg(), CommonMethod.ERROR);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(PayrollDetailActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
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


    public void dateChanged() {
        setNextPreviousMonth();
        currentDate.setText(String.format(getString(R.string.date_desc), year, month, foremanWorkerDesc));
        getData();
    }

    /**
     * 设置上一个和下一个月的描述
     */
    private void setNextPreviousMonth() {
        int previousMonth = month - 1;//上个月
        int nextMonth = month + 1;//下个月
        previousMonthText.setText((previousMonth == 0 ? 12 : previousMonth) + "月");
        nextMonthText.setText((nextMonth == 13 ? 1 : nextMonth) + "月");
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.previousMonthText: //上一个月
                if (year == 2014 && month == 1) {
                    return;
                }
                month -= 1;
                if (month == 0) {
                    year -= 1;
                    month = 12;
                }
                dateChanged();
                break;
            case R.id.nextMonthText: //下一个月
                Calendar calendar = Calendar.getInstance();
                int mYear = calendar.get(calendar.YEAR);
                int mMonth = calendar.get(calendar.MONTH) + 1;
                if (year == mYear && month == mMonth) {
                    return;
                }
                month += 1;
                if (month == 13) {
                    year += 1;
                    month = 1;
                }
                dateChanged();
                break;
        }
    }

    /**
     * 功能:工资清单某月详情适配器
     * 时间:2017年4月21日16:06:02
     * 作者:xuj
     */
    public class PayRollListAdapter extends BaseAdapter {
        /**
         * 工资清单数据
         */
        private List<PayRollList> list;
        /**
         * xml解析器
         */
        private LayoutInflater inflater;
        /**
         * Context
         */
        private Context context;

        /**
         * 标题布局
         */
        private final int TITLE_VIEW = 0;
        /**
         * 内容布局
         */
        private final int VALUE_VIEW = 1;


        @Override
        public int getItemViewType(int position) {
            return position == 0 ? TITLE_VIEW : VALUE_VIEW;
        }

        @Override
        public int getViewTypeCount() {
            return 2;
        }

        public void updateList(List<PayRollList> list) {
            this.list = list;
            notifyDataSetChanged();
        }

        public PayRollListAdapter(Context context, List<PayRollList> list) {
            super();
            this.list = list;
            this.context = context;
            inflater = LayoutInflater.from(context);
        }

        @Override
        public int getCount() {
            return list == null ? 0 : list.size() + 1;
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
            int type = getItemViewType(position);
            ViewHolder holder;
            if (convertView == null) {
                if (type == TITLE_VIEW) {
                    convertView = inflater.inflate(R.layout.item_payroll_title, null);
                } else {
                    convertView = inflater.inflate(R.layout.item_payroll_month_value, null);
                }
                holder = new ViewHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            bindData(holder, position, type);
            return convertView;
        }

        private void bindData(ViewHolder holder, int position, int type) {
            if (type == VALUE_VIEW) {
                PayRollList bean = list.get(position - 1);
                holder.proName.setText(bean.getName()); //项目名称
                holder.totalManhour.setText(RecordUtils.getNormalTotalWorkString(bean.getTotal_manhour(), true)); //上班时长
                holder.totalOvertime.setText(RecordUtils.getOverTimeTotalWorkString(bean.getTotal_overtime(), true)); //加班时长
                holder.total.setText(bean.getNew_total().getPre_unit() + bean.getNew_total().getTotal() + bean.getNew_total().getUnit()); //金额
                holder.total.setTextColor(ContextCompat.getColor(context, bean.getTotal() > 0 ? R.color.app_color : R.color.green));
                holder.itemDiver.setVisibility(position == list.size() ? View.GONE : View.VISIBLE);
            } else {
                if (classType.equals("person")) {
                    holder.leftTitle.setText("项目名称");
                } else {
                    holder.leftTitle.setText(UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_FM) ? R.string.workers : R.string.item_foreman_title);
                }
            }
        }


        class ViewHolder {
            public ViewHolder(View convertView) {
                leftTitle = (TextView) convertView.findViewById(R.id.leftTitle);
                proName = (TextView) convertView.findViewById(R.id.proName);
                totalManhour = (TextView) convertView.findViewById(R.id.totalManhour);
                totalOvertime = (TextView) convertView.findViewById(R.id.totalOvertime);
                total = (TextView) convertView.findViewById(R.id.total);
                itemDiver = convertView.findViewById(R.id.itemDiver);
            }

            /**
             * 标题状态
             */
            TextView leftTitle;
            /**
             * 项目名称
             */
            TextView proName;
            /**
             * 上班时长
             */
            TextView totalManhour;
            /**
             * 加班时长
             */
            TextView totalOvertime;
            /**
             * 记账金额
             */
            TextView total;
            /**
             * 分割线
             */
            View itemDiver;
        }

        public List<PayRollList> getList() {
            return list;
        }

        public void setList(List<PayRollList> list) {
            this.list = list;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUEST) {
            getData();
        }
    }


}
