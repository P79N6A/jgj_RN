package com.jizhi.jlongg.main.activity;

import android.content.Intent;
import android.os.Bundle;
import android.text.Html;
import android.view.Gravity;
import android.view.View;
import android.widget.TextView;

import com.hcs.uclient.utils.DatePickerUtil;
import com.hcs.uclient.utils.Festival;
import com.hcs.uclient.utils.LunarCalendar;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.db.HuangliBaseInfoService;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.CalendarModel;
import com.jizhi.jlongg.main.bean.Huangli;
import com.jizhi.jlongg.main.bean.Recommend;
import com.jizhi.jlongg.main.dialog.WheelViewSelectDatePicker;
import com.jizhi.jlongg.main.listener.SelectedLuckyDayListener;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.IsSupplementary;
import com.jizhi.jongg.widget.MultipleTextViewGroup;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.view.annotation.ViewInject;
import com.lidroid.xutils.view.annotation.event.OnClick;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * CName:黄历
 * User: hcs
 * Date: 2016-06-28
 * Time: 10:24
 */
public class HuangliActivity extends BaseActivity implements SelectedLuckyDayListener {
    private HuangliActivity mActivity;
    /**
     * 农历
     */
    @ViewInject(R.id.tv_lunar)
    private TextView tv_lunar;
    /**
     * 回今天按钮
     */
    @ViewInject(R.id.btn_back_today)
    private TextView btn_back_today;
    /**
     * 阳历年月
     */
    @ViewInject(R.id.tv_solar)
    private TextView tv_solar;
    /**
     * 阳历日
     */
    @ViewInject(R.id.tv_date)
    private TextView tv_date;
    /**
     * 星期
     */
    @ViewInject(R.id.tv_week)
    private TextView tv_week;
    /**
     * 喜神
     */
    @ViewInject(R.id.tv_xs)
    private TextView tv_xs;
    /**
     * 福神
     */
    @ViewInject(R.id.tv_fs)
    private TextView tv_fs;
    /**
     * 财神
     */
    @ViewInject(R.id.tv_cs)
    private TextView tv_cs;
    /**
     * 财神
     */
    @ViewInject(R.id.tv_jieqi)
    private TextView tv_jieqi;
    private String year, month, date;
    private HuangliBaseInfoService huangliBaseInfoService;
    private MultipleTextViewGroup mul_yi, mul_ji, mul_jx;
    private List<Recommend> listRecommend;
    private Festival festival;
    private WheelViewSelectDatePicker datePickerPopWindow;
    private List<CalendarModel> yearList;
    private String dateStr;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_almanac);
        ViewUtils.inject(this);
        initView();
        initData();


    }

    private void initData() {
        //初始化获取当前日期
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-E");
        String[] split = sdf.format(new Date()).split("-");
        String months = (split[1].length() == 1 ? "0" + split[1] : split[1]);
        String dates = (split[2].length() == 1 ? "0" + split[2] : split[2]);
        dateStr = split[0] + "-" + months + "-" + dates;

        String intentDate = getIntent().getStringExtra("date");
        if (null != intentDate && !intentDate.equals("")) {
            split = intentDate.split("-");
            findViewById(R.id.right_title).setVisibility(View.GONE);
        }

        //设置日期
        setDate(split[0], split[1], split[2], split[3]);
//        listRecommend = DataUtil.getRecommend(mActivity);
//        RecommedAdapter RecommedAdapter = new RecommedAdapter(mActivity, listRecommend);
//        grid_recommed.setAdapter(RecommedAdapter);
//        grid_recommed.setOnItemClickListener(new AdapterView.OnItemClickListener() {
//            @Override
//            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
//                Intent intent = new Intent();
//                if (listRecommend.get(position).getTitle().equals(getResources().getString(R.string.play_game))) {
//                    String token = (String) SPUtils.get(mActivity, Constance.enum_parameter.TOKEN.toString(), "", Constance.JLONGG);
//                    token = token.replace("A", "").trim();
//                    Map<String, String> par = new HashMap<>();
//                    par.put("userToken", token);
//                    par.put("para1758", "");
//                    String sign = DataUtil.getSignData(par);
//                    sign = MD5.getMD5(sign).toUpperCase();
//                    String url = NetWorkRequest.GAMEURL + token + "&sign=" + sign;
//                    listRecommend.get(position).setUrl(url);
//                    intent.setClass(mActivity, GameActivity.class);
//                    intent.putExtra("title", getString(R.string.play_game));
//                } else if (listRecommend.get(position).getTitle().equals(getResources().getString(R.string.send_msg))) {
//                    if (!judgeLogin()) {
//                        return;
//                    }
//                    intent.setClass(mActivity, WorkerFriendActivity.class);
//                } else if (listRecommend.get(position).getTitle().equals(getResources().getString(R.string.look_video))) {
//                    intent.setClass(mActivity, VideoActivity.class);
//                    intent.putExtra("title", getString(R.string.look_video));
//                } else if (listRecommend.get(position).getTitle().equals(getResources().getString(R.string.look_book))) {
//                    intent.setClass(mActivity, GameActivity.class);
//                    intent.putExtra("title", getString(R.string.look_book));
//                } else if (listRecommend.get(position).getTitle().equals(getResources().getString(R.string.look_duanzi))) {
//                    intent.setClass(mActivity, GameActivity.class);
//                    intent.putExtra("title", getString(R.string.look_duanzi));
//                } else {
//                    intent.setClass(mActivity, UserInfoActivity.class);
//                }
//                intent.putExtra("url", listRecommend.get(position).getUrl());
//                startActivity(intent);
//            }
//        });
    }

    //判断是否登录或补充资料
    private boolean judgeLogin() {
        if (!IsSupplementary.accessLogin(mActivity)) {
            return false;
        }
        String currentRoler = UclientApplication.getRoler(this);
        String title = currentRoler.equals(Constance.ROLETYPE_FM) ? "完善工头资料,即可查看该内容" : "完善工人资料,即可查看该内容";
        if (IsSupplementary.SupplementaryRegistrationWorker(mActivity, title)) {
            return false;
        }
        return true;
    }

    private void initView() {
        mActivity = HuangliActivity.this;
        festival = new Festival();
        huangliBaseInfoService = HuangliBaseInfoService.getInstance(getApplicationContext());
        mul_yi = (MultipleTextViewGroup) findViewById(R.id.mul_yi);
        mul_ji = (MultipleTextViewGroup) findViewById(R.id.mul_ji);
        MultipleTextViewGroup mul_sc = (MultipleTextViewGroup) findViewById(R.id.mul_sc);
        mul_jx = (MultipleTextViewGroup) findViewById(R.id.mul_jx);
        mul_sc.setTextViews(LunarCalendar.getSc());
        yearList = DatePickerUtil.getYearData(2012, 2020);
    }

    /**
     * 设置日期
     *
     * @param solarYear
     * @param solarMonth
     */
    public void setDate(String solarYear, String solarMonth, String solarDate, String week) {
        this.year = solarYear;
        this.month = solarMonth;
        this.date = solarDate;
        //阳历
        tv_solar.setText(java.lang.String.format(getString(R.string.solar), solarYear, Integer.parseInt(solarMonth)));
        tv_date.setText(Integer.parseInt(solarDate) + "");
        week = week.replace("周", "星期");
        tv_week.setText(week);

        if (dateStr.equals(solarYear + "-" + solarMonth + "-" + solarDate)) {
            btn_back_today.setVisibility(View.GONE);
        } else {
            btn_back_today.setVisibility(View.VISIBLE);
        }

        //农历
        int[] lunar = LunarCalendar.solarToLunar(Integer.parseInt(solarYear), Integer.parseInt(solarMonth), Integer.parseInt(solarDate));
        int lempMonth = LunarCalendar.leapMonth(Integer.parseInt(year));
        String lunarMonth = "";
        boolean islempMonth = false;
        if (lempMonth != 0 && lempMonth == lunar[1]) {
            islempMonth = true;
        }
        String yangliFestival = festival.showSFtv(Integer.parseInt(solarMonth), Integer.parseInt(solarDate));

        String nongliFestival = festival.showLFtv(lunar[1], lunar[2], LunarCalendar.daysInMonth(lunar[0], lunar[1], islempMonth));
        if (!yangliFestival.equals("")) {
            tv_week.setText(Html.fromHtml(week.replace("周", "星期") + "<font color='#d7252c'>(" + yangliFestival + ")</font>"));
        } else if (!nongliFestival.equals("")) {
            tv_week.setText(Html.fromHtml(week.replace("周", "星期") + "<font color='#d7252c'>(" + nongliFestival + ")</font>"));
        }

        boolean isLemp = false;
        if (lempMonth != 0 && lunar[3] == 1) {
            lunarMonth = Utils.chiaDate(lempMonth + "");
        } else if (lempMonth != 0 && lempMonth == lunar[1]) {
            lunarMonth = "闰" + Utils.chiaDate(lempMonth + "");
            isLemp = true;
        } else {
            lunarMonth = Utils.chiaDate((lunar[1]) + "");
        }

        String lunarDate = DatePickerUtil.getLunarDate(lunar[2]);
        String monthBS = LunarCalendar.daysInMonth(lunar[0], lunar[1], isLemp) >= 30 ? "大" : "小";
//        String monthBs = LunarCalendar.getLargeOrSmallMonth(lunar[1]);
        tv_lunar.setText(String.format(getString(R.string.almanac_lunar), Utils.chiaDate(lunar[0] + ""), lunarMonth, monthBS, lunarDate));
        String month = solarMonth.length() == 1 ? "0" + solarMonth : solarMonth;
        String date = solarDate.length() == 1 ? "0" + solarDate : solarDate;


        Huangli hl = huangliBaseInfoService.selectHuangliInfo(solarYear + "-" + month + "-" + date);
        //设置喜神财神福神
        tv_xs.setText(String.format(getString(R.string.xs), hl.getXishen()));
        tv_cs.setText(String.format(getString(R.string.cs), hl.getCaishen()));
        tv_fs.setText(String.format(getString(R.string.fs), hl.getFushen()));
        //设置yi忌

        if (null != hl.getYi()) {
            mul_yi.removeAllViews();
            mul_yi.setTextViews(Arrays.asList(hl.getYi().split(",")));
        }

        if (null != hl.getJi()) {
            mul_ji.removeAllViews();
            mul_ji.setTextViews(Arrays.asList(hl.getJi().split(",")));
        }
        if (null != hl.getJishi()) {
            mul_jx.removeAllViews();
            mul_jx.setTextViews(Arrays.asList(hl.getJishi().split(",")));
        }


        if (null != hl.getJieqi() && !hl.getJieqi().equals("")) {
            tv_jieqi.setText(hl.getJieqi());
            tv_jieqi.setVisibility(View.VISIBLE);
        } else {
            tv_jieqi.setVisibility(View.GONE);
        }
    }

    /**
     * 选择日期
     *
     * @param view
     */
    @OnClick(R.id.rea_calender)
    public void rea_calender(View view) {
        if (null == datePickerPopWindow) {
            datePickerPopWindow = new WheelViewSelectDatePicker(mActivity, yearList, getString(R.string.choosetime), this);
        } else {
            datePickerPopWindow.update();
        }
        datePickerPopWindow.showAtLocation(findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(this, 0.5F);
    }

    /**
     * 回今天
     *
     * @param view
     */
    @OnClick(R.id.btn_back_today)
    public void btn_back_today(View view) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd-E");
        String[] split = sdf.format(new Date()).split("-");
        setDate(split[0], split[1], split[2], split[3]);


    }

    /**
     * 日期前一天
     *
     * @param view
     */
    @OnClick(R.id.img_arrows_left)
    public void img_arrows_left(View view) {
        addCalender(-1);


    }

    /**
     * 选择日期后一天
     *
     * @param view
     */
    @OnClick(R.id.img_arrows_right)
    public void img_arrows_right(View view) {
        addCalender(1);
    }

    /**
     * 选吉日
     *
     * @param view
     */
    @OnClick(R.id.right_title)
    public void right_title(View view) {
        startActivity(new Intent(mActivity, LuckyDayActivity.class));

    }

    private String startYear, startMonth, starDate;

    @Override
    public void selectedLuckyDayClick(String yi, String type, int currLeft, int currRight) {

    }

    /**
     * 选择日期回调
     *
     * @param year  年
     * @param month 月
     * @param date  日
     * @param week  星期
     */
    @Override
    public void selectedCaldenerClick(String year, String month, String date, String week) {
        this.startYear = year;
        this.startMonth = (month.length() == 1 ? "0" + month : month);
        this.starDate = (date.length() == 1 ? "0" + date : date);
        setDate(startYear, startMonth, starDate, week);
    }

    /**
     * 日期加减一天
     *
     * @param add 1加一天 -1减一天
     */
    public void addCalender(int add) {
        try {
            Date date = (new SimpleDateFormat("yyyy-MM-dd")).parse(year + "-" + month + "-" + this.date);
            Calendar cal = Calendar.getInstance();
            cal.setTime(date);
            cal.add(Calendar.DATE, add);
            String newDate = (new SimpleDateFormat("yyyy-MM-dd-E")).format(cal.getTime());
            String[] split = newDate.split("-");
            setDate(split[0], split[1], split[2], split[3]);
        } catch (Exception e) {
            CommonMethod.makeNoticeShort(mActivity, "日期错误", CommonMethod.ERROR);
        }
    }

}
