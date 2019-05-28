package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.text.Html;
import android.view.Gravity;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.CalendarViewPagerAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.dialog.WheelViewSelectYearAndMonth;
import com.jizhi.jlongg.main.fragment.NotesCalendarDetailFragment;
import com.jizhi.jlongg.main.listener.YearAndMonthClickListener;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.CustomDate;
import com.jizhi.jlongg.main.util.DateUtil;
import com.jizhi.jongg.widget.ResetHeightViewPager;

import java.util.ArrayList;

/**
 * 功能:记事本日历
 * 时间:2019年1月9日16:22:49
 * 作者:xuj
 */
public class NotesCalendarActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 存放日历的Fragment 集合
     */
    private ArrayList<Fragment> fragments;
    /**
     * ViewPager
     */
    private ResetHeightViewPager mViewPager;
    /**
     * 顶部月份
     */
    private TextView dateText;
    /**
     * VierPager 当前滑动位置
     */
    private int mCurrentIndex;
    /**
     * 结束动画,是否在加载动画
     */
    private boolean isFirstEnter = true;
    /**
     * 时间左滑箭头
     */
    private View leftArrows;
    /**
     * 时间右滑箭头
     */
    private View rightArrows;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, NotesCalendarActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onResume() {
        super.onResume();
        if (!isFirstEnter && UclientApplication.isLogin(this)) { //只要登录成功就刷新数据
            NotesCalendarDetailFragment framgent = (NotesCalendarDetailFragment) fragments.get(mCurrentIndex);
            framgent.refreshData();
        }
        if (isFirstEnter) {
            isFirstEnter = false;
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.notes_calendar);
        initView();
    }

    private void initView() {
        dateText = getTextView(R.id.title);
        mViewPager = findViewById(R.id.viewPager);

        leftArrows = findViewById(R.id.leftIcon);
        rightArrows = findViewById(R.id.rightIcon);
        leftArrows.setOnClickListener(this);
        rightArrows.setOnClickListener(this);

        TextView importantText = getTextView(R.id.important_text);
        importantText.setText(Html.fromHtml("<font color='#333333'>这一天有</font><font color='#FF6600'>重要记事</font>"));

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
        for (int i = 0; i <= difference_between_month + 24; i++) {
            if (startMonth > 12) {
                startYear += 1;
                startMonth = 1;
            }
            NotesCalendarDetailFragment fragment = new NotesCalendarDetailFragment();
            Bundle bundle = new Bundle();
            bundle.putSerializable(Constance.BEAN_CONSTANCE, new CustomDate(startYear, startMonth, startday));
            bundle.putInt("fragmentPosition", i);
            fragment.setArguments(bundle);
            fragments.add(fragment);
            startMonth += 1;
        }
        setViewPager(difference_between_month);
        setResult(Constance.REQUEST);//告诉上个列表页刷新的标识
    }

    private void setViewPager(int selecteItem) {
        mViewPager.setAdapter(new CalendarViewPagerAdapter(getSupportFragmentManager(), fragments));
        mViewPager.setCurrentItem(selecteItem);
        mViewPager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageSelected(int position) {
                //未完善姓名的用户不能查看日历数据
                try {
                    leftArrows.setVisibility(position == 0 ? View.INVISIBLE : View.VISIBLE);
                    rightArrows.setVisibility(position == fragments.size() - 1 ? View.INVISIBLE : View.VISIBLE);
                    mCurrentIndex = position;
                    mViewPager.resetHeight(position); //由于每个Fragment高度不一致 重置viewpager的高度
                    NotesCalendarDetailFragment fragment = (NotesCalendarDetailFragment) (fragments.get(position));
                    int month = fragment.getmShowDate().month;
                    setDate(fragment.getmShowDate().year + "", month);
                    fragment.refreshData(); //每次滑动ViewPager则重新加载数据
                } catch (Exception e) {
                    e.getMessage();
                }
            }

            @Override
            public void onPageScrolled(int arg0, float arg1, int arg2) {

            }

            @Override
            public void onPageScrollStateChanged(int arg0) {

            }
        });
        NotesCalendarDetailFragment fragment = (NotesCalendarDetailFragment) fragments.get(selecteItem);
        Bundle bundle = fragment.getArguments();
        CustomDate date = (CustomDate) bundle.getSerializable(Constance.BEAN_CONSTANCE);
        setDate(date.year + "", date.month);
        mCurrentIndex = selecteItem;
    }


    private void setDate(String year, int month) {
        dateText.setText(year + "年" + month + "月");
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.title: //日历时间选择框
                NotesCalendarDetailFragment fragme = (NotesCalendarDetailFragment) fragments.get(mCurrentIndex);
                WheelViewSelectYearAndMonth selecteYearMonthPopWindow = new WheelViewSelectYearAndMonth(this, new YearAndMonthClickListener() {
                    @Override
                    public void YearAndMonthClick(String year, String month) {
                        try {
                            int count = DateUtil.countMonths("2014-01", year + "-" + month, "yyyy-MM");
                            mViewPager.setCurrentItem(count);
                            setDate(year, Integer.parseInt(month));
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }, fragme.getmShowDate().year, fragme.getmShowDate().month, true);
                selecteYearMonthPopWindow.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(this, 0.5F);
                break;
            case R.id.leftIcon: //点击回到上个月
                if (mCurrentIndex == 0) {
                    return;
                }
                mViewPager.setCurrentItem(mCurrentIndex - 1);
                break;
            case R.id.rightIcon://点击去到下个月
                if (mCurrentIndex == fragments.size() - 1) {
                    return;
                }
                mViewPager.setCurrentItem(mCurrentIndex + 1);
                break;
        }
    }

    public ResetHeightViewPager getmViewPager() {
        return mViewPager;
    }


}
