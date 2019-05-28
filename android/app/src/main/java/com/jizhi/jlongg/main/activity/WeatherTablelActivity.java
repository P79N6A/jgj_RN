package com.jizhi.jlongg.main.activity;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.ScrollView;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.StrUtil;
import com.hcs.uclient.utils.TimesUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.CalendarViewPagerAdapter;
import com.jizhi.jlongg.main.bean.WeatherAttribute;
import com.jizhi.jlongg.main.dialog.WheelViewSelectYearAndMonth;
import com.jizhi.jlongg.main.fragment.WeatherCalendarFragment;
import com.jizhi.jlongg.main.listener.YearAndMonthClickListener;
import com.jizhi.jlongg.main.popwindow.WeatherPopWindow;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.CustomDate;
import com.jizhi.jlongg.main.util.DateUtil;
import com.jizhi.jlongg.main.util.HelpCenterUtil;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jongg.widget.ResetHeightViewPager;

import java.util.ArrayList;
import java.util.List;

/**
 * 功能:晴雨表
 * 时间:2017年3月29日9:53:17
 * 作者:xuj
 */
public class WeatherTablelActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 当前日期
     */
    private TextView weatherDateText;
    /**
     * 天气状态
     */
    private TextView weatherStatusText;
    /**
     * 温度描述
     */
    private TextView temperatureText;
    /**
     * 温度描述
     */
    private TextView windowText;
    /**
     * 天气描述
     */
    private TextView weatherDescText;
    /**
     * 天气记录员
     */
    private TextView weatherRecoder;
    /**
     * 可点击的日期
     */
    private TextView topDateText;
    /**
     * 存放日历的Fragment 集合
     */
    private ArrayList<Fragment> fragments;
    /**
     * viewPager
     */
    private ResetHeightViewPager mViewPager;
    /**
     * VierPager 当前滑动位置
     */
    private int mCurrentIndex;
    /**
     * 没有数据时的布局
     */
    private View noDataLayout;
    /**
     * 有数据的时候的布局
     */
    private View existDataLayout;
    /**
     * 天气编辑
     */
    private View weatherDateEditIcon;
    /**
     * 左滑箭头
     */
    private View leftArrows;
    /**
     * 右滑箭头
     */
    private View rightArrows;
    /**
     * 当前点击的天气属性
     */
    private WeatherAttribute clickWeather;
    /**
     * 是否是记录员
     */
    private boolean isRecorder;
    /**
     * 是否是管理员或者创建者
     */
    private boolean isAdminOrCreator;
    /**
     * 项目是否已关闭
     */
    private boolean proIsClosed;
    /**
     * 滑动组件
     */
    private ScrollView scrollView;

    /**
     * 启动当前Activity
     *
     * @param context
     * @param groupId          项目组id
     * @param teamName         项目组名称
     * @param isRecorder       是否是记录员
     * @param isAdminOrCreator 是否是管理员或者创建者
     * @param proIsClosed      项目是否已关闭
     */
    public static void actionStart(Activity context, String groupId, String teamName, boolean isRecorder, boolean isAdminOrCreator, boolean proIsClosed) {
        Intent intent = new Intent(context, WeatherTablelActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.GROUP_NAME, teamName);
        intent.putExtra("param1", isRecorder);
        intent.putExtra("param2", isAdminOrCreator);
        intent.putExtra("param3", proIsClosed);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.weather_calendar);
        initView();
    }

    private void initView() {
        SetTitleName.setTitle(findViewById(R.id.title), getString(R.string.weather_table));
        Intent intent = getIntent();

        isRecorder = intent.getBooleanExtra("param1", false);// 是否是记录员
        isAdminOrCreator = intent.getBooleanExtra("param2", false);// 是否是管理员或者创建者
        proIsClosed = intent.getBooleanExtra("param3", false);// 项目是否已关闭
        scrollView = (ScrollView) findViewById(R.id.scrollView);

        getTextView(R.id.proName).setText(getIntent().getStringExtra(Constance.GROUP_NAME));
        mViewPager = (ResetHeightViewPager) findViewById(R.id.viewPager);
        noDataLayout = findViewById(R.id.noDataLayout);
        weatherStatusText = (TextView) findViewById(R.id.weatherStatusText);
        temperatureText = (TextView) findViewById(R.id.temperatureText);
        windowText = (TextView) findViewById(R.id.windowText);
        weatherDescText = (TextView) findViewById(R.id.weatherDesc);
        weatherRecoder = (TextView) findViewById(R.id.weatherRecoder);

        weatherDateText = getTextView(R.id.weatherDateText);
        topDateText = getTextView(R.id.topDateText);
        existDataLayout = findViewById(R.id.existDataLayout);
        weatherDateEditIcon = findViewById(R.id.weatherDateEdit);
        leftArrows = findViewById(R.id.leftArrows);
        rightArrows = findViewById(R.id.rightArrows);
        ImageView isClosedImageIcon = (ImageView) findViewById(R.id.closedIcon);
        TextView rightTitle = (TextView) findViewById(R.id.right_title);


        isClosedImageIcon.setVisibility(proIsClosed ? View.VISIBLE : View.GONE);
        findViewById(R.id.recordBtn).setVisibility(proIsClosed ? View.GONE : isRecorder || isAdminOrCreator ? View.VISIBLE : View.GONE);
        findViewById(R.id.weather_tips).setVisibility(proIsClosed ? View.GONE : isRecorder || isAdminOrCreator ? View.GONE : View.VISIBLE);
        rightArrows.setVisibility(View.INVISIBLE);

        leftArrows.setOnClickListener(this);
        rightArrows.setOnClickListener(this);
        weatherDateEditIcon.setOnClickListener(this);
        weatherRecoder.setOnClickListener(this);
        rightTitle.setText(R.string.more);


        GridView weatherGridView = (GridView) findViewById(R.id.weatherGridView);
        weatherGridView.setAdapter(new ExampleWeatherAdapter(this));

        fragments = new ArrayList<>();
        CustomDate currentTime = new CustomDate();
        int difference_between_month = 0; //相差月份个数
        try {
            difference_between_month = DateUtil.countMonths("2014-01", currentTime.getYear() + "-" + currentTime.getMonth(), "yyyy-MM"); // 获取2014年1月到现在相差多少个月
        } catch (Exception e) {
            e.printStackTrace();
        }
        int startYear = 2014; // 开始时间2014年
        int startMonth = 1; // 1月
        int startday = 1; // 第一天
        for (int i = 0; i <= difference_between_month; i++) {
            if (startMonth > 12) {
                startYear += 1;
                startMonth = 1;
            }
            WeatherCalendarFragment fragment = new WeatherCalendarFragment();
            Bundle bundle = new Bundle();
            bundle.putSerializable(Constance.BEAN_CONSTANCE, new CustomDate(startYear, startMonth, startday));
            bundle.putString(Constance.GROUP_ID, getIntent().getStringExtra(Constance.GROUP_ID));
            bundle.putInt("fragmentPosition", i);
            fragment.setArguments(bundle);
            fragments.add(fragment);
            startMonth += 1;
        }
        setViewPager();
    }

    private void setViewPager() {
        mViewPager.setAdapter(new CalendarViewPagerAdapter(getSupportFragmentManager(), fragments));
        mViewPager.setCurrentItem(fragments.size());
        mViewPager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageSelected(int position) {
                leftArrows.setVisibility(position == 0 ? View.INVISIBLE : View.VISIBLE);
                rightArrows.setVisibility(position == fragments.size() - 1 ? View.INVISIBLE : View.VISIBLE);
                mCurrentIndex = position;
                mViewPager.resetHeight(position); //由于每个Fragment高度不一致 重置viewpager的高度
                WeatherCalendarFragment fragment = (WeatherCalendarFragment) (fragments.get(position));
                int month = fragment.getmShowDate().month;
                topDateText.setText(fragment.getmShowDate().year + "年" + (month < 10 ? "0" + month : month) + "月");
                fragment.refreshData(); //每次滑动ViewPager则重新加载数据
            }

            @Override
            public void onPageScrolled(int arg0, float arg1, int arg2) {

            }

            @Override
            public void onPageScrollStateChanged(int arg0) {

            }
        });
        WeatherCalendarFragment fragment = (WeatherCalendarFragment) fragments.get(fragments.size() - 1);
        Bundle bundle = fragment.getArguments();
        CustomDate date = (CustomDate) bundle.getSerializable(Constance.BEAN_CONSTANCE);
        String month = date.month >= 10 ? date.month + "" : "0" + date.month;
        topDateText.setText(date.year + "年" + month + "月");
        mCurrentIndex = fragments.size() - 1;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.topDateText: //日历时间选择框
                WeatherCalendarFragment fragme = (WeatherCalendarFragment) fragments.get(mCurrentIndex);
                WheelViewSelectYearAndMonth selecteYearMonthPopWindow = new WheelViewSelectYearAndMonth(this, new
                        YearAndMonthClickListener() {
                            @Override
                            public void YearAndMonthClick(String year, String month) {
                                try {
                                    int count = DateUtil.countMonths("2014-01", year + "-" + month, "yyyy-MM");
                                    mViewPager.setCurrentItem(count);
                                    topDateText.setText(year + "年" + month + "月");
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            }
                        }, fragme.getmShowDate().year, fragme.getmShowDate().month);
                selecteYearMonthPopWindow.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(this, 0.5F);
                return;
            case R.id.right_title: //显示更多弹出框
                //显示窗口
                WeatherPopWindow rightPopWindow = new WeatherPopWindow(this, isAdminOrCreator, proIsClosed);
                rightPopWindow.showAsDropDown(findViewById(R.id.right_title), 0, DensityUtils.dp2px(this, 10));
                break;
            case R.id.recordBtn: //记录天气
                WeatherCalendarFragment fragment = (WeatherCalendarFragment) fragments.get(mCurrentIndex);
                WeatherCalendarFragment.Cell cell = fragment.getClickCell();
                RecordWeatherActivity.actionStart(this, null, cell.date.year, cell.date.month, cell.date.day);
                break;
            case R.id.weatherDateEdit: //编辑天气
                WeatherCalendarFragment fragment1 = (WeatherCalendarFragment) fragments.get(mCurrentIndex);
                WeatherCalendarFragment.Cell cell1 = fragment1.getClickCell();
                RecordWeatherActivity.actionStart(this, clickWeather, cell1.date.year, cell1.date.month, cell1.date.day);
                break;
            case R.id.weatherRecoder: //点击记录员
                ChatUserInfoActivity.actionStart(this, clickWeather.getRecord_info().getUid());
                break;
            case R.id.leftArrows: //左滑箭头
                if (mCurrentIndex == 0) {
                    return;
                }
                mViewPager.setCurrentItem(mCurrentIndex - 1);
                break;
            case R.id.rightArrows: //右滑箭头
                if (mCurrentIndex == fragments.size() - 1) {
                    return;
                }
                mViewPager.setCurrentItem(mCurrentIndex + 1);
                break;
            case R.id.title:
                HelpCenterUtil.actionStartHelpActivity(this, 189);
                break;
        }
    }

    /**
     * 填充点击的晴雨表天气数据
     */
    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    public void fillWeatherData(WeatherAttribute bean) {
        if (bean == null) {
            noDataLayout.setVisibility(View.VISIBLE);
            weatherDateEditIcon.setVisibility(View.INVISIBLE);
            existDataLayout.setVisibility(View.GONE);
            StringBuilder timeBuilder = new StringBuilder();
            WeatherCalendarFragment fragment = (WeatherCalendarFragment) fragments.get(mCurrentIndex);
            WeatherCalendarFragment.Cell cell = fragment.getClickCell();
            String stMonth = cell.date.month < 10 ? "0" + cell.date.month : cell.date.month + "";
            String stDay = cell.date.day < 10 ? "0" + cell.date.day : cell.date.day + "";
            timeBuilder.append(cell.date.year + "-" + stMonth + "-" + stDay);
//            timeBuilder.append(" " + DatePickerUtil.getLunarDate(LunarCalendar.solarToLunar(cell.date.year, cell.date.month, cell.date.day)[2]));
            timeBuilder.append(" " + TimesUtils.getWeekString(cell.date.year, cell.date.month, cell.date.day));
            weatherDateText.setText(timeBuilder.toString()); //日期
            moveToBottom();
            return;
        }
        clickWeather = bean;
        existDataLayout.setVisibility(View.VISIBLE);
        noDataLayout.setVisibility(View.GONE);
        weatherDateEditIcon.setVisibility(proIsClosed ? View.GONE : isRecorder || isAdminOrCreator ? View.VISIBLE : View.INVISIBLE); //记录员和管理员创建者才能编辑 并且项目未关闭时
        weatherDateText.setText(bean.getDay()); //日期
        weatherStatusText.setText(bean.getWeat()); //天气描述
        if (!TextUtils.isEmpty(bean.getTemp())) { //温度描述
            temperatureText.setText(bean.getTemp());
            temperatureText.setVisibility(View.VISIBLE);
        } else {
            temperatureText.setVisibility(View.GONE);
        }
        if (!TextUtils.isEmpty(bean.getWind())) { //风力描述
            windowText.setText(bean.getWind());
            windowText.setVisibility(View.VISIBLE);
        } else {
            windowText.setVisibility(View.GONE);
        }
        if (!TextUtils.isEmpty(bean.getDetail())) { //温度描述
            weatherDescText.setText(StrUtil.ToDBC(StrUtil.StringFilter(bean.getDetail()))); //天气描述
            weatherDescText.setVisibility(View.VISIBLE);
        } else {
            weatherDescText.setVisibility(View.GONE);
        }
        String recorderName = bean.getRecord_info().getReal_name();
        SpannableStringBuilder builder = Utils.setSelectedFontChangeColor("记录员 : " + recorderName, recorderName, Color.parseColor("#628ae0"), false);
        weatherRecoder.setText(builder);
        moveToBottom();
    }

    /**
     * scrollview 移动到底部
     */
    private void moveToBottom() {
        Handler handler = new Handler();
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                //scrollView.fullScroll(ScrollView.FOCUS_DOWN);滚动到底部
                //scrollView.fullScroll(ScrollView.FOCUS_UP);滚动到顶
                scrollView.fullScroll(ScrollView.FOCUS_DOWN);
            }
        }, 300);//0.3秒后执行Runnable中的run方法
    }


    public ResetHeightViewPager getmViewPager() {
        return mViewPager;
    }

    /**
     * 功能:晴雨表参考日历
     * 时间:2016-3-18 19:13
     * 作者:xuj
     */
    public class ExampleWeatherAdapter extends BaseAdapter {
        /**
         * xml解析器
         */
        private LayoutInflater inflater;
        /**
         * 数据
         */
        private List<WeatherAttribute> list;


        public ExampleWeatherAdapter(Context context) {
            super();
            inflater = LayoutInflater.from(context);
            this.list = getData();
        }

        private List<WeatherAttribute> getData() {
            List<WeatherAttribute> list = new ArrayList<>();

            WeatherAttribute weather1 = new WeatherAttribute(R.drawable.eg_calendar_weather_clear, "晴");
            WeatherAttribute weather2 = new WeatherAttribute(R.drawable.eg_calendar_weather_over_cast, "阴");
            WeatherAttribute weather3 = new WeatherAttribute(R.drawable.eg_calendar_weather_cloudy, "多云");
            WeatherAttribute weather4 = new WeatherAttribute(R.drawable.eg_calendar_weather_rain, "雨");
            WeatherAttribute weather5 = new WeatherAttribute(R.drawable.eg_calendar_weather_wind, "风");
            WeatherAttribute weather6 = new WeatherAttribute(R.drawable.eg_calendar_weather_snow, "雪");
            WeatherAttribute weather7 = new WeatherAttribute(R.drawable.eg_calendar_weather_fog, "雾");
            WeatherAttribute weather8 = new WeatherAttribute(R.drawable.eg_calendar_weather_haze, "霾");
            WeatherAttribute weather9 = new WeatherAttribute(R.drawable.eg_calendar_weather_frost, "冰冻");
            WeatherAttribute weather10 = new WeatherAttribute(R.drawable.eg_calendar_weather_power_outage, "停电");
            list.add(weather1);
            list.add(weather2);
            list.add(weather3);
            list.add(weather4);
            list.add(weather5);
            list.add(weather6);
            list.add(weather7);
            list.add(weather8);
            list.add(weather9);
            list.add(weather10);
            return list;
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
                convertView = inflater.inflate(R.layout.item_example_weather_icon, null);
                holder = new ViewHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            bindData(holder, position, convertView);
            return convertView;
        }

        private void bindData(ViewHolder holder, int position, View convertView) {
            WeatherAttribute bean = list.get(position);
            holder.weatherIcon.setImageResource(bean.getWeatherIcon());
            holder.weatherName.setText(bean.getWeatherName());
        }


        class ViewHolder {
            public ViewHolder(View convertView) {
                weatherName = (TextView) convertView.findViewById(R.id.weatherName);
                weatherIcon = (ImageView) convertView.findViewById(R.id.weatherIcon);
            }

            /**
             * 天气名称
             */
            TextView weatherName;
            /**
             * 天气图标
             */
            ImageView weatherIcon;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.CLICK_SINGLECHAT) { //点击单聊
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
            return;
        }
        fragments.get(mCurrentIndex).onActivityResult(requestCode, resultCode, data);
    }


}
