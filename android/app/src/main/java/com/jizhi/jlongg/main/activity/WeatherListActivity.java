package com.jizhi.jlongg.main.activity;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.StrUtil;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.UserInfo;
import com.jizhi.jlongg.main.bean.WeatherAttribute;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.dialog.WheelViewSelectYearAndMonth;
import com.jizhi.jlongg.main.listener.YearAndMonthClickListener;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.DateUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.Calendar;
import java.util.List;

/**
 * CName:天气详情列表
 * User: xuj
 * Date: 2017年3月31日
 * Time: 14:26:05
 */
public class WeatherListActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 天氣列表适配器
     */
    private CalendarItemAdapter adapter;
    /**
     * 列表数据为空时展示的数据
     */
    private View defaultLayout;
    /**
     * 时间文本
     */
    private TextView dateText;


    private View leftArrows;

    private View rightArrows;
    /**
     * 日期年月
     */
    private String yearMonth;
    /**
     * 当前时间的年月日
     */
    private int year, month;


    /**
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = context.getIntent();
        intent.setClass(context, WeatherListActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.weather_detial);
        initView();
        getData();
    }


    /**
     * 初始化View
     */
    private void initView() {
        setTextTitle(R.string.weather_detal);
        getTextView(R.id.groupName).setText(getIntent().getStringExtra(Constance.GROUP_NAME));
        defaultLayout = findViewById(R.id.defaultLayout);
        dateText = (TextView) findViewById(R.id.topDateText);
        leftArrows = findViewById(R.id.leftArrows);
        rightArrows = findViewById(R.id.rightArrows);
        rightArrows.setVisibility(View.INVISIBLE);

        dateText.setOnClickListener(this);
        leftArrows.setOnClickListener(this);
        rightArrows.setOnClickListener(this);

        year = DateUtil.getYear();
        month = DateUtil.getMonth();
        yearMonth = year + (month < 10 ? "0" + month : month + "");
        dateText.setText(year + "年" + (month < 10 ? "0" + month : month) + "月");
    }

    private void setAdapter(List<WeatherAttribute> list) {
        if (adapter == null) {
            ListView listView = (ListView) findViewById(R.id.listView);
            adapter = new CalendarItemAdapter(this, list);
            listView.setAdapter(adapter);
        } else {
            adapter.updateList(list);
        }
    }

    /**
     * 查询晴雨表列表数据
     */
    public void getData() {
        if (adapter != null) { //为了保证数据的完整性 先清空数据
            adapter.updateList(null);
        }
        String URL = NetWorkRequest.GET_WEATHER_LIST;
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("class_type", WebSocketConstance.TEAM);//类型为项目组
        params.addBodyParameter("group_id", getIntent().getStringExtra(Constance.GROUP_ID));// 组id
        params.addBodyParameter("month", yearMonth);//年、月
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, URL, params, new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonListJson<WeatherAttribute> base = CommonListJson.fromJson(responseInfo.result, WeatherAttribute.class);
                    if (base.getState() != 0) {
                        if (base.getValues() != null && base.getValues().size() > 0) {
                            defaultLayout.setVisibility(View.GONE);
                            setAdapter(base.getValues());
                        } else {
                            defaultLayout.setVisibility(View.VISIBLE);
                        }
                    } else {
                        DataUtil.showErrOrMsg(WeatherListActivity.this, base.getErrno(), base.getErrmsg());
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


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.topDateText: //时间弹出框
                WheelViewSelectYearAndMonth selecteYearMonthPopWindow = new WheelViewSelectYearAndMonth(this, new YearAndMonthClickListener() {
                    @Override
                    public void YearAndMonthClick(String year, String month) {
                        WeatherListActivity.this.year = Integer.parseInt(year);
                        WeatherListActivity.this.month = Integer.parseInt(month);
                        handlerDate();
                    }
                }, year, month);
                selecteYearMonthPopWindow.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(this, 0.5F);
                break;
            case R.id.leftArrows:
                if (year == 2014 && month == 1) {
                    return;
                }
                month -= 1;
                if (month == 0) {
                    year -= 1;
                    month = 12;
                }
                handlerDate();
                break;
            case R.id.rightArrows:
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
                handlerDate();
                break;
        }
    }

    /**
     * 处理选中日期
     */
    private void handlerDate() {
        Calendar calendar = Calendar.getInstance();
        int mYear = calendar.get(calendar.YEAR);
        int mMonth = calendar.get(calendar.MONTH) + 1;
        leftArrows.setVisibility(year == 2014 && month == 1 ? View.INVISIBLE : View.VISIBLE);
        rightArrows.setVisibility(year == mYear && month == mMonth ? View.INVISIBLE : View.VISIBLE);
        String stMonth = month < 10 ? "0" + month : month + "";
        dateText.setText(year + "年" + stMonth + "月");
        yearMonth = year + stMonth;
        getData();
    }

    /**
     * 功能:天气列表适配器
     * 时间:2017年3月31日14:28:52
     * 作者:xuj
     */
    public class CalendarItemAdapter extends BaseAdapter {
        /**
         * 列表数据
         */
        private List<WeatherAttribute> list;
        /**
         * xml 解析器
         */
        private LayoutInflater inflater;

        public CalendarItemAdapter(Context context, List<WeatherAttribute> list) {
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
                convertView = inflater.inflate(R.layout.weather_detial_item, null);
                holder = new ViewHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            bindData(holder, position, convertView);
            return convertView;
        }

        private void bindData(ViewHolder holder, int position, View convertView) {
            final WeatherAttribute weatherAttribute = list.get(position);
            UserInfo recorderInfo = weatherAttribute.getRecord_info();
            holder.date.setText(weatherAttribute.getDay());
            holder.weatherStatusText.setText(weatherAttribute.getWeat());
            if (!TextUtils.isEmpty(weatherAttribute.getTemp())) { //温度描述
                holder.temperatureText.setText(weatherAttribute.getTemp());
                holder.temperatureText.setVisibility(View.VISIBLE);
            } else {
                holder.temperatureText.setVisibility(View.GONE);
            }
            if (!TextUtils.isEmpty(weatherAttribute.getWind())) { //风力描述
                holder.windowText.setText(weatherAttribute.getWind());
                holder.windowText.setVisibility(View.VISIBLE);
            } else {
                holder.windowText.setVisibility(View.GONE);
            }
            if (!TextUtils.isEmpty(weatherAttribute.getDetail())) { //温度描述
                holder.weatherDesc.setText(StrUtil.ToDBC(StrUtil.StringFilter(weatherAttribute.getDetail()))); //天气描述
                holder.weatherDesc.setVisibility(View.VISIBLE);
                holder.line.setVisibility(View.VISIBLE);
            } else {
                holder.weatherDesc.setVisibility(View.GONE);
                holder.line.setVisibility(View.GONE);
            }
            if (recorderInfo != null) {
                holder.recorder.setText(weatherAttribute.getRecord_info().getReal_name());
                holder.recorder.setOnClickListener(new View.OnClickListener() { //点击记录员跳转到 查看资料界面
                    @Override
                    public void onClick(View v) {
                        ChatUserInfoActivity.actionStart(WeatherListActivity.this, weatherAttribute.getRecord_info().getUid());
                    }
                });
            }
        }


        class ViewHolder {
            public ViewHolder(View convertView) {
                date = (TextView) convertView.findViewById(R.id.date);
                weatherStatusText = (TextView) convertView.findViewById(R.id.weatherStatusText);
                temperatureText = (TextView) convertView.findViewById(R.id.temperatureText);
                windowText = (TextView) convertView.findViewById(R.id.windowText);
                weatherDesc = (TextView) convertView.findViewById(R.id.weatherDesc);
                recorder = (TextView) convertView.findViewById(R.id.recorder);
                line = convertView.findViewById(R.id.itemDiver);
            }

            /* 天气 */
            TextView weatherStatusText;
            /* 天气描述 */
            TextView weatherDesc;
            /* 温度描述 */
            TextView temperatureText;
            /* 风力描述 */
            TextView windowText;
            /* 记录时间 */
            TextView date;
            /* 记录员 */
            TextView recorder;

            View line;
        }

        public void updateList(List<WeatherAttribute> list) {
            this.list = list;
            notifyDataSetChanged();
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
