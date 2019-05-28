package com.jizhi.jlongg.main.activity;

import android.content.Intent;
import android.os.Bundle;
import android.text.Html;
import android.view.Gravity;
import android.view.View;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.DatePickerUtil;
import com.hcs.uclient.utils.LunarCalendar;
import com.hcs.uclient.utils.TimesUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.db.HuangliBaseInfoService;
import com.jizhi.jlongg.main.adpter.LuckyDayAdapter;
import com.jizhi.jlongg.main.bean.CalendarModel;
import com.jizhi.jlongg.main.bean.Other;
import com.jizhi.jlongg.main.dialog.WheelViewSelectDatePicker;
import com.jizhi.jlongg.main.dialog.WheelViewSelectLuckDay;
import com.jizhi.jlongg.main.listener.SelectedLuckyDayListener;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;
import com.lidroid.xutils.view.annotation.event.OnClick;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * CName:选吉日
 * User: hcs
 * Date: 2016-06-29
 * Time: 15:01
 */
public class LuckyDayActivity extends BaseActivity implements SelectedLuckyDayListener {
    /* 开始时间 */
    @ViewInject(R.id.tv_starttime)
    private TextView tv_starttime;
    /* 结束时间*/
    @ViewInject(R.id.tv_endtime)
    private TextView tv_endtime;
    /* 选择类别 */
    @ViewInject(R.id.tv_seltype)
    private TextView tv_seltype;
    /* 总天数 */
    @ViewInject(R.id.tv_allday)
    private TextView tv_allday;
    @ViewInject(R.id.listView)
    private ListView listView;


    private LuckyDayActivity mActivity;
    private WheelViewSelectLuckDay wheelViewSelectedLuckDay;
    private WheelViewSelectDatePicker startTimeDialog, endTimeDialog;
    private boolean isStartTime;
    private List<CalendarModel> yearList;
    private HuangliBaseInfoService hlBaseInfoService;
    private LuckyDayAdapter lucyDayAdapter;
    private List<Other> luckyList;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activit_luckday);
        ViewUtils.inject(this);
        mActivity = this;
        setTextTitle(R.string.select_luckday);
        yearList = DatePickerUtil.getYearData(2012, 2020);
        hlBaseInfoService = HuangliBaseInfoService.getInstance(getApplicationContext());
        setDate();
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent Intent = new Intent(mActivity, HuangliActivity.class);
                Intent.putExtra("date", luckyList.get(position).getTemp() + "-" + luckyList.get(position).getWeek());
                startActivity(Intent);
            }
        });
    }

    /**
     * 设置数据
     */
    public void setDate() {
        yi = "yi";
        type = "动土";
        //初始化获取当前日期
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String time = sdf.format(new Date());
        String[] split = time.split("-");
        setStartTime(split[0], split[1], split[2]);
        setEndTime(split[0], split[1], split[2], true);
    }

    /**
     * 设置开始时间
     *
     * @param year  年
     * @param month 月
     * @param date  日
     */
    public void setStartTime(String year, String month, String date) {
        this.startYear = year;
        this.startMonth = (month.length() == 1 ? "0" + month : month);
        this.starDate = (date.length() == 1 ? "0" + date : date);
        //设置日期
        int whichDayWeek = TimesUtils.getwhichDayWeek(Integer.parseInt(year), Integer.parseInt(month), Integer.parseInt(date));
        int[] lunar = LunarCalendar.solarToLunar(Integer.parseInt(year), Integer.parseInt(month), Integer.parseInt(date));
        String lunarDate = DatePickerUtil.getLunarDate(lunar[2]);
        int lempMonth = LunarCalendar.leapMonth(Integer.parseInt(year));
        String lunarMonth = "";
        if (lempMonth != 0 && lunar[3] == 1) {
            lunarMonth = Utils.chiaDate(lempMonth + "");
        } else if (lempMonth != 0 && lempMonth == lunar[1]) {
            lunarMonth = "闰" + Utils.chiaDate(lempMonth + "");
        } else {
            lunarMonth = Utils.chiaDate((lunar[1]) + "");
        }
        tv_starttime.setText(this.startYear + "-" + this.startMonth + "-" + this.starDate + " " + lunarMonth + "月" + lunarDate + " " + Utils.chiaWeek(whichDayWeek));
    }

    /**
     * 设置结束时间
     *
     * @param year  年
     * @param month 月
     * @param date  日
     */
    public void setEndTime(String year, String month, String date, boolean isToFirst) {
        try {
            String split[] = new String[4];
            if (isToFirst) {
                Date dates = (new SimpleDateFormat("yyyy-MM-dd")).parse(year + "-" + month + "-" + date);
                Calendar cal = Calendar.getInstance();
                cal.setTime(dates);
                cal.add(Calendar.MONTH, 1);
                String newDate = (new SimpleDateFormat("yyyy-MM-dd-E")).format(cal.getTime());
                split = newDate.split("-");

            } else {
                split[0] = year;
                split[1] = month;
                split[2] = date;
            }
            this.endYear = split[0] + "";
            this.endMonth = (split[1].length() == 1 ? "0" + split[1] : split[1]);
            this.endDate = (split[2].length() == 1 ? "0" + split[2] : split[2]);
            int[] lunar = LunarCalendar.solarToLunar(Integer.parseInt(split[0]), Integer.parseInt(split[1]), Integer.parseInt(split[2]));
            String lunarDate = DatePickerUtil.getLunarDate(lunar[2]);
            int lempMonth = LunarCalendar.leapMonth(Integer.parseInt(year));
            String lunarMonth = "";
            if (lempMonth != 0 && lunar[3] == 1) {
                lunarMonth = Utils.chiaDate(lempMonth + "");
            } else if (lempMonth != 0 && lempMonth == lunar[1]) {
                lunarMonth = "闰" + Utils.chiaDate(lempMonth + "");
            } else {
                lunarMonth = Utils.chiaDate((lunar[1]) + "");
            }
            int whichDayWeek = TimesUtils.getwhichDayWeek(Integer.parseInt(split[0]), Integer.parseInt(split[1]), Integer.parseInt(split[2]));
            tv_endtime.setText(this.endYear + "-" + this.endMonth + "-" + this.endDate + " " + lunarMonth + "月" + lunarDate + " " + Utils.chiaWeek(whichDayWeek));


            setluckyList(yi, type);
        } catch (Exception e) {
            e.getMessage();
        }

    }

    /**
     * 设置liistview数据
     *
     * @param yi
     * @param content
     */
    public void setluckyList(String yi, String content) {
        luckyList = hlBaseInfoService.selectInfoJixongList(startYear + "-" + startMonth + "-" + starDate, endYear + "-" + endMonth + "-" + endDate, yi, content);
        lucyDayAdapter = new LuckyDayAdapter(mActivity, luckyList);
        listView.setAdapter(lucyDayAdapter);
        setAllDayText(luckyList.size());
    }

    public void setAllDayText(int count) {
        String content = "";
        if (this.yi.equals("yi")) {
            content = "宜(" + type + ")";
        } else if (this.yi.equals("ji")) {
            content = "忌(" + type + ")";
        }
        tv_allday.setText(Html.fromHtml("<font color='#288a48'>" + content + "</font>的日子共有" + count + "天"));
    }

    /**
     * 开始时间
     *
     * @param view
     */
    @OnClick(R.id.rea_starttime)
    public void rea_starttime(View view) {
        isStartTime = true;
        if (null == startTimeDialog) {
            startTimeDialog = new WheelViewSelectDatePicker(mActivity, yearList, getString(R.string.start_time), this);
        } else {
            startTimeDialog.update();
        }
        startTimeDialog.showAtLocation(findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        backgroundAlpha(0.5F);
    }

    /**
     * 结束时间
     *
     * @param view
     */
    @OnClick(R.id.rea_endtime)
    public void rea_endtime(View view) {
        isStartTime = false;
        if (null == endTimeDialog) {
            endTimeDialog = new WheelViewSelectDatePicker(mActivity, yearList, getString(R.string.end_time), this);
        } else {
            endTimeDialog.update();

        }
        endTimeDialog.showAtLocation(findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        backgroundAlpha(0.5F);
    }

    /**
     * 选择类别
     *
     * @param view
     */
    @OnClick(R.id.rea_seltype)
    public void rea_seltype(View view) {
        if (null == wheelViewSelectedLuckDay) {
            wheelViewSelectedLuckDay = new WheelViewSelectLuckDay(mActivity, getString(R.string.select_tyoe), this);
        } else {
            wheelViewSelectedLuckDay.update();
        }

        //显示窗口
        wheelViewSelectedLuckDay.showAtLocation(findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        backgroundAlpha(0.5F);
    }

    private int currLeft, currRight;
    private String yi, type;

    @Override
    public void selectedLuckyDayClick(String yi, String type, int currLeft, int currRight) {
        this.currLeft = currLeft;
        this.currRight = currRight;
        if (yi.equals("宜")) {
            this.yi = "yi";
        } else if (yi.equals("忌")) {
            this.yi = "ji";
        }
        this.type = type;
        setluckyList(this.yi, type);
        tv_seltype.setText(yi + "(" + type + ")");

    }

    private String startYear, startMonth, starDate, endYear, endMonth, endDate;

    @Override
    public void selectedCaldenerClick(String year, String month, String date, String week) {
        if (isStartTime) {
            this.startYear = year;
            this.startMonth = (month.length() == 1 ? "0" + month : month);
            this.starDate = (date.length() == 1 ? "0" + date : date);
            setStartTime(this.startYear, this.startMonth, this.starDate);
            boolean isBigTime = TimesUtils.isBigTime(year + "-" + month + "-" + date, this.endYear + "-" + this.endMonth + "-" + this.endDate);
            if (!isBigTime) {
                setEndTime(this.startYear, this.startMonth, this.starDate, true);
            } else {
                setluckyList(this.yi, type);
            }
        } else {
            boolean isBigTime = TimesUtils.isBigTime(this.startYear + "-" + this.startMonth + "-" + this.starDate, year + "-" + month + "-" + date);
            if (isBigTime) {
                this.endYear = year;
                this.endMonth = (month.length() == 1 ? "0" + month : month);
                this.endDate = (date.length() == 1 ? "0" + date : date);
                setEndTime(this.endYear, this.endMonth, this.endDate, false);
            } else {
                CommonMethod.makeNoticeLong(mActivity, "结束时间不能小于开始时间", CommonMethod.ERROR);
            }
        }
    }

    /**
     * 设置添加屏幕的背景透明度
     *
     * @param bgAlpha
     */
    public void backgroundAlpha(float bgAlpha) {
        WindowManager.LayoutParams lp = getWindow().getAttributes();
        lp.alpha = bgAlpha; //0.0-1.0
        getWindow().setAttributes(lp);
    }

}
