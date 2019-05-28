package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Build;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.widget.EditText;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.WeatherAttribute;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.dialog.DialogOnlyTitle;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.popwindow.SelecteWeatherPopWindow;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.DateUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.WeatherUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.CustomCircle;
import com.jizhi.jongg.widget.WeatherRangteCircle;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.ArrayList;
import java.util.List;

/**
 * CName:记录天气
 * User: xuj
 * Date: 2017年3月31日
 * Time: 11:25:06
 */
public class RecordWeatherActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 发布的日期
     */
    private String publishTime;
    /**
     * 左上、右上、左下、右下选中的效果
     */
    private View leftTopSelectedIcon, rightTopSelectedIcon, leftBottomSelectedIcon, rightBottomSelectedIcon;
    /**
     * 上午温度
     */
    private EditText morningTemperatureEdit;
    /**
     * 下午温度
     */
    private EditText afternoonTemperatureEdit;
    /**
     * 上午风力
     */
    private EditText morningWindowForceEdit;
    /**
     * 下午风力
     */
    private EditText afternoonWindowForceEdit;
    /**
     * 备注
     */
    private EditText weatherDesc;
    /**
     * 选择天气弹出框
     */
    private SelecteWeatherPopWindow selecteWeatherPopWindow;
    /**
     * 根布局、主要是PopWindow弹出时使用
     */
    private View rootView;
    /**
     * 中间圆形的天气
     */
    private CustomCircle centerWeather;
    /**
     * 圆角天气
     */
    private WeatherRangteCircle leftTopWeather, rightTopWeather, leftBottomWeather, rightBottomWeather;
    /**
     * 删除的天气id
     */
    private int deleteWeatherId;
    /**
     * 删除天气弹出框
     */
    private DialogOnlyTitle deleteDialog;

    private final boolean START_NEXT_ANIM = true;

    private final boolean STOP_NEXT_ANIM = false;


    /**
     * @param context
     */
    public static void actionStart(Activity context, WeatherAttribute weatherAttribute, int year, int month, int day) {
        Intent intent = context.getIntent();
        intent.putExtra(Constance.BEAN_CONSTANCE, weatherAttribute);
        intent.putExtra("year", year);
        intent.putExtra("month", month);
        intent.putExtra("day", day);
        intent.setClass(context, RecordWeatherActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.record_weather);
        initView();
        initData();
    }

    private void initView() {
        setTextTitleAndRight(R.string.recorde_weather, R.string.save);
        rootView = findViewById(R.id.rootView);

        centerWeather = (CustomCircle) findViewById(R.id.weatherCircle); //自定义 天气组件
        leftTopWeather = (WeatherRangteCircle) findViewById(R.id.leftTop);
        rightTopWeather = (WeatherRangteCircle) findViewById(R.id.rightTop);
        leftBottomWeather = (WeatherRangteCircle) findViewById(R.id.leftBottom);
        rightBottomWeather = (WeatherRangteCircle) findViewById(R.id.rightBottom);

        leftTopSelectedIcon = findViewById(R.id.leftTopSelectedIcon);
        rightTopSelectedIcon = findViewById(R.id.rightTopSelectedIcon);
        leftBottomSelectedIcon = findViewById(R.id.leftBottomSelectedIcon);
        rightBottomSelectedIcon = findViewById(R.id.rightBottomSelectedIcon);

        morningTemperatureEdit = (EditText) findViewById(R.id.morningTemperature);
        afternoonTemperatureEdit = (EditText) findViewById(R.id.afternoonTemperature);
        morningWindowForceEdit = (EditText) findViewById(R.id.morningWindowForce);
        afternoonWindowForceEdit = (EditText) findViewById(R.id.afternoonWindowForce);
        weatherDesc = (EditText) findViewById(R.id.weatherDesc);


        leftTopWeather.setOnClickListener(this);
        rightTopWeather.setOnClickListener(this);
        leftBottomWeather.setOnClickListener(this);
        rightBottomWeather.setOnClickListener(this);

        Typeface fontFace = Typeface.createFromAsset(getAssets(), "IMPACT.TTF");
        // 字体文件必须是true type font的格式(ttf)；
        // 当使用外部字体却又发现字体没有变化的时候(以 Droid Sans代替)，通常是因为
        // 这个字体android没有支持,而非你的程序发生了错误
        leftTopWeather.setTypeface(fontFace);
        rightTopWeather.setTypeface(fontFace);
        leftBottomWeather.setTypeface(fontFace);
        rightBottomWeather.setTypeface(fontFace);
    }

    public void initData() {
        TextView dayText = getTextView(R.id.day);
        Intent intent = getIntent();
        int year = intent.getIntExtra("year", 0);
        int month = intent.getIntExtra("month", 0);
        int day = intent.getIntExtra("day", 0);

        String stMonth = DateUtil.dateToAddZeroDate(month);
        String stDay = DateUtil.dateToAddZeroDate(day);

        publishTime = year + stMonth + stDay;
        WeatherAttribute weatherAttribute = (WeatherAttribute) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
        if (weatherAttribute != null) { //修改天气 、填充天气的数据
            List<WeatherAttribute> list = new ArrayList<>();

            deleteWeatherId = weatherAttribute.getId();

            WeatherAttribute leftTopWetherAttribute = WeatherUtil.getWeatherAttribute(weatherAttribute.getWeat_one());//天气1
            WeatherAttribute rightTopWeatherAttribute = WeatherUtil.getWeatherAttribute(weatherAttribute.getWeat_two()); //天气2
            WeatherAttribute leftBottomWetherAttribute = WeatherUtil.getWeatherAttribute(weatherAttribute.getWeat_three()); //天气3
            WeatherAttribute rightBottomWetherAttribute = WeatherUtil.getWeatherAttribute(weatherAttribute.getWeat_four()); //天气4

            leftTopWeather.setWeatherAttribute(leftTopWetherAttribute); //天气1
            rightTopWeather.setWeatherAttribute(rightTopWeatherAttribute); //天气2
            leftBottomWeather.setWeatherAttribute(leftBottomWetherAttribute); //天气3
            rightBottomWeather.setWeatherAttribute(rightBottomWetherAttribute); //天气4
            if (leftTopWetherAttribute != null) {
                list.add(leftTopWetherAttribute);
            }
            if (rightTopWeatherAttribute != null) {
                list.add(rightTopWeatherAttribute);
            }
            if (leftBottomWetherAttribute != null) {
                list.add(leftBottomWetherAttribute);
            }
            if (rightBottomWetherAttribute != null) {
                list.add(rightBottomWetherAttribute);
            }

            morningTemperatureEdit.setText(weatherAttribute.getTemp_am()); //上午温度
            afternoonTemperatureEdit.setText(weatherAttribute.getTemp_am()); //下午温度
            morningWindowForceEdit.setText(weatherAttribute.getWind_am()); //上午风力
            afternoonWindowForceEdit.setText(weatherAttribute.getWind_pm()); //下午风力
            weatherDesc.setText(weatherAttribute.getDetail()); //天气描述

            centerWeather.setList(list);
            centerWeather.invalidate();
            findViewById(R.id.right_title).setVisibility(View.GONE);
        } else {
            findViewById(R.id.editorLayout).setVisibility(View.GONE); //隐藏编辑框
            rootView.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() { //当布局加载完毕  是否需要引导
                @Override
                public void onGlobalLayout() { //但是需要注意的是OnGlobalLayoutListener可能会被多次触发，因此在得到了高度之后，要
                    openWeatherPopWindow(WeatherRangteCircle.TOP_LEFT, leftTopWeather.getWeatherAttribute());
                    if (Build.VERSION.SDK_INT < 16) {
                        rootView.getViewTreeObserver().removeGlobalOnLayoutListener(this);
                    } else {
                        rootView.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                    }
                }
            });
        }
        StringBuilder builder = new StringBuilder(100);
        builder.append(year + "-" + stMonth + "-" + stDay);
//        builder.append("  " + DatePickerUtil.getLunarDate(LunarCalendar.solarToLunar(year, month, day)[2]));
        builder.append("  " + TimesUtils.getWeekString(year, month, day));
        dayText.setText(builder.toString());
        getTextView(R.id.groupName).setText(intent.getStringExtra(Constance.GROUP_NAME));

    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title:
            case R.id.saveBtn: //保存按钮
                if (leftTopWeather.getWeatherAttribute() == null) {
                    CommonMethod.makeNoticeShort(getApplicationContext(), "请至少选择一种天气", CommonMethod.ERROR);
                    return;
                }
                publishWeather();
                break;
            case R.id.deleteBtn: //删除按钮
                delWeather();
                break;
            case R.id.leftTop: //天气1
                hideSoftKeyboard();
                openWeatherPopWindow(WeatherRangteCircle.TOP_LEFT, leftTopWeather.getWeatherAttribute());
                break;
            case R.id.rightTop: //天气2
                if (leftTopWeather.getWeatherAttribute() == null) {
                    CommonMethod.makeNoticeShort(getApplicationContext(), "请先选择上一种天气", CommonMethod.ERROR);
                    return;
                }
                hideSoftKeyboard();
                openWeatherPopWindow(WeatherRangteCircle.TOP_RIGHT, rightTopWeather.getWeatherAttribute());
                break;
            case R.id.leftBottom: //天气3
                if (rightTopWeather.getWeatherAttribute() == null) {
                    CommonMethod.makeNoticeShort(getApplicationContext(), "请先选择上一种天气", CommonMethod.ERROR);
                    return;
                }
                hideSoftKeyboard();
                openWeatherPopWindow(WeatherRangteCircle.BOTTOM_LEFT, leftBottomWeather.getWeatherAttribute());
                break;
            case R.id.rightBottom: //天气4
                if (leftBottomWeather.getWeatherAttribute() == null) {
                    CommonMethod.makeNoticeShort(getApplicationContext(), "请先选择上一种天气", CommonMethod.ERROR);
                    return;
                }
                hideSoftKeyboard();
                openWeatherPopWindow(WeatherRangteCircle.BOTTOM_RIGHT, rightBottomWeather.getWeatherAttribute());
                break;
        }
    }


    /**
     * 打开选择天气
     *
     * @param weatherDirection
     */
    public void openWeatherPopWindow(int weatherDirection, WeatherAttribute attribute) {
        if (selecteWeatherPopWindow == null) {
            selecteWeatherPopWindow = new SelecteWeatherPopWindow(RecordWeatherActivity.this, new SelecteWeatherPopWindow.SelectedWeatherListener() {
                @Override
                public void selectedWather(WeatherAttribute attribute, int weatherDirection) { //选中天气时的回调
                    List<WeatherAttribute> list = centerWeather.getList();
                    boolean isRemoveWeather;
                    if (attribute.getWeatherId() == WeatherAttribute.NOTHING) { //清除天气
                        if (list.size() >= weatherDirection) { //如果当前天气存在时则直接移除
                            list.remove(weatherDirection - 1);
                        }
                        isRemoveWeather = true;
                    } else {
                        if (list.size() >= weatherDirection) { //如果天气中已存在下标的天气 则直接替换不用添加
                            list.set(weatherDirection - 1, attribute);
                        } else { //添加天气
                            list.add(attribute);
                        }
                        weatherDirection += 1; //当前天气自动移动到下一个
                        isRemoveWeather = false;
                    }
                    int size = list.size();
                    for (int i = 0; i < 4; i++) { //重新遍历  填充天气数据
                        WeatherAttribute weatherAttribute = null;
                        if (i < size) {
                            weatherAttribute = list.get(i);
                        }
                        switch (i + 1) {
                            case WeatherRangteCircle.TOP_LEFT: //左上
                                leftTopWeather.setWeatherAttribute(weatherAttribute);
                                break;
                            case WeatherRangteCircle.TOP_RIGHT: //右上
                                rightTopWeather.setWeatherAttribute(weatherAttribute);
                                break;
                            case WeatherRangteCircle.BOTTOM_LEFT: //左下
                                leftBottomWeather.setWeatherAttribute(weatherAttribute);
                                break;
                            case WeatherRangteCircle.BOTTOM_RIGHT: //右下
                                rightBottomWeather.setWeatherAttribute(weatherAttribute);
                                break;
                        }
                    }
                    centerWeather.setList(list);
                    centerWeather.invalidate(); //重新绘制
                    if (list.size() == WeatherRangteCircle.WEATHER_TOTAL_SIZE) { //已经填满了4种天气
                        clearAllSelectedWeatherAndStartNext(isRemoveWeather, -1, STOP_NEXT_ANIM);
                        selecteWeatherPopWindow.dismiss();
                    } else {
                        clearAllSelectedWeatherAndStartNext(isRemoveWeather, weatherDirection, START_NEXT_ANIM);
                    }
                }

                @Override
                public void clearAllWeather() {
                    leftTopWeather.setWeatherAttribute(null);
                    rightTopWeather.setWeatherAttribute(null);
                    leftBottomWeather.setWeatherAttribute(null);
                    rightBottomWeather.setWeatherAttribute(null);
                    clearAllSelectedWeatherAndStartNext(false, WeatherRangteCircle.TOP_LEFT, true);

                    selecteWeatherPopWindow.setWeatherDirection(WeatherRangteCircle.TOP_LEFT);
                    centerWeather.getList().clear();
                    centerWeather.invalidate();

                }
            });
            selecteWeatherPopWindow.setOnDismissListener(new PopupWindow.OnDismissListener() {
                @Override
                public void onDismiss() {
                    clearAllSelectedWeatherAndStartNext(false, -1, false);
                }
            });
        }
        setSelectedWeather(weatherDirection);
        selecteWeatherPopWindow.setWeatherDirection(weatherDirection);
        selecteWeatherPopWindow.showAtLocation(rootView, Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
    }


    /**
     * 设置选中天气
     *
     * @param weatherDirection 天气下标
     */
    private void setSelectedWeather(int weatherDirection) {
        switch (weatherDirection) {
            case WeatherRangteCircle.TOP_LEFT:
                if (leftBottomSelectedIcon.getVisibility() == View.INVISIBLE) {
                    showWeatherAnim(leftTopSelectedIcon);
                }
                break;
            case WeatherRangteCircle.TOP_RIGHT:
                if (rightTopSelectedIcon.getVisibility() == View.INVISIBLE) {
                    showWeatherAnim(rightTopSelectedIcon);
                }
                break;
            case WeatherRangteCircle.BOTTOM_LEFT:
                if (leftBottomSelectedIcon.getVisibility() == View.INVISIBLE) {
                    showWeatherAnim(leftBottomSelectedIcon);
                }
                break;
            case WeatherRangteCircle.BOTTOM_RIGHT:
                if (rightBottomSelectedIcon.getVisibility() == View.INVISIBLE) {
                    showWeatherAnim(rightBottomSelectedIcon);
                }
                break;
        }
    }

    /**
     * 停止动画
     *
     * @param weatherView          天气图标
     * @param nextWeatherDirection 下一个天气下标
     * @param isStartNextWeather   是否开启下一个动画
     */
    public void stopWeatherAnim(final View weatherView, final int nextWeatherDirection, final boolean isStartNextWeather) {
        if (weatherView.getVisibility() == View.INVISIBLE) {
            return;
        }
        AlphaAnimation animation = new AlphaAnimation(1.0f, 0f);
        animation.setDuration(200);// 设置动画显示时间
        animation.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {

            }

            @Override
            public void onAnimationEnd(Animation animation) {
                weatherView.setVisibility(View.INVISIBLE);
                if (!isStartNextWeather) {
                    return;
                }
                setSelectedWeather(nextWeatherDirection);
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
        weatherView.startAnimation(animation);
    }

    /**
     * 清空天气选中状态
     *
     * @param isRemove             如果是移除动画 则不停止当前的动画
     * @param nextWeatherDirection 下一个天气开动的图标
     * @param isStartNextWeather   是否开启下一个动画
     */
    private void clearAllSelectedWeatherAndStartNext(boolean isRemove, int nextWeatherDirection, boolean isStartNextWeather) {
        if (leftTopSelectedIcon.getVisibility() == View.VISIBLE && !isRemove) {
            stopWeatherAnim(leftTopSelectedIcon, nextWeatherDirection, isStartNextWeather);
        }
        if (rightTopSelectedIcon.getVisibility() == View.VISIBLE && !isRemove) {
            stopWeatherAnim(rightTopSelectedIcon, nextWeatherDirection, isStartNextWeather);
        }
        if (leftBottomSelectedIcon.getVisibility() == View.VISIBLE && !isRemove) {
            stopWeatherAnim(leftBottomSelectedIcon, nextWeatherDirection, isStartNextWeather);
        }
        if (rightBottomSelectedIcon.getVisibility() == View.VISIBLE && !isRemove) {
            stopWeatherAnim(rightBottomSelectedIcon, nextWeatherDirection, isStartNextWeather);
        }
    }

    /**
     * 开启动画
     *
     * @param weatherView
     */
    public void showWeatherAnim(final View weatherView) {
        if (weatherView.getVisibility() == View.VISIBLE) {
            return;
        }
        weatherView.setVisibility(View.VISIBLE);
        AlphaAnimation anima = new AlphaAnimation(0f, 1.0f);
        anima.setDuration(200);// 设置动画显示时间
        weatherView.startAnimation(anima);
    }

    /**
     * 发布天气
     */
    public void publishWeather() {
        String URL = NetWorkRequest.PUBLISH_WEATHER;
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("class_type", WebSocketConstance.TEAM);//类型为项目组
        params.addBodyParameter("group_id", getIntent().getStringExtra(Constance.GROUP_ID));// 组id
        params.addBodyParameter("uid", getIntent().getStringExtra(Constance.UID));//发布的用户uid，不传默认当前用户
        if (leftTopWeather.getWeatherAttribute() != null) {
            params.addBodyParameter("weat_one", leftTopWeather.getWeatherAttribute().getWeatherId() + "");// 天气1
        }
        if (rightTopWeather.getWeatherAttribute() != null) {
            params.addBodyParameter("weat_two", rightTopWeather.getWeatherAttribute().getWeatherId() + "");// 天气2
        }
        if (leftBottomWeather.getWeatherAttribute() != null) {
            params.addBodyParameter("weat_three", leftBottomWeather.getWeatherAttribute().getWeatherId() + "");// 天气3
        }
        if (rightBottomWeather.getWeatherAttribute() != null) {
            params.addBodyParameter("weat_four", rightBottomWeather.getWeatherAttribute().getWeatherId() + "");// 天气4
        }
        params.addBodyParameter("temp_am", morningTemperatureEdit.getText().toString().trim());// 上午温度
        params.addBodyParameter("temp_pm", afternoonTemperatureEdit.getText().toString().trim());// 下午温度
        params.addBodyParameter("wind_am", morningWindowForceEdit.getText().toString().trim());// 上午风力
        params.addBodyParameter("wind_pm", afternoonWindowForceEdit.getText().toString().trim());// 下午风力
        params.addBodyParameter("detail", weatherDesc.getText().toString().trim());// 描述
        params.addBodyParameter("month", publishTime);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, URL, params, new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<BaseNetBean> base = CommonJson.fromJson(responseInfo.result, BaseNetBean.class);
                    if (base.getState() != 0) {
                        CommonMethod.makeNoticeShort(getApplicationContext(), "保存成功", CommonMethod.SUCCESS);
                        setResult(Constance.UPDATE_SUCCESS);
                        finish();
                    } else {
                        DataUtil.showErrOrMsg(RecordWeatherActivity.this, base.getErrno(), base.getErrmsg());
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
     * 删除天气
     */
    public void delWeather() {
        if (deleteDialog == null) {
            deleteDialog = new DialogOnlyTitle(this, new DiaLogTitleListener() {
                @Override
                public void clickAccess(int position) {
                    String URL = NetWorkRequest.DELETE_WEATHER;
                    RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
                    params.addBodyParameter("group_id", getIntent().getStringExtra(Constance.GROUP_ID));// 组id
                    params.addBodyParameter("id", deleteWeatherId + ""); //晴雨表id
                    HttpUtils http = SingsHttpUtils.getHttp();
                    http.send(HttpRequest.HttpMethod.POST, URL, params, new RequestCallBackExpand<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonJson<BaseNetBean> base = CommonJson.fromJson(responseInfo.result, BaseNetBean.class);
                                if (base.getState() != 0) {
                                    if (deleteDialog != null && deleteDialog.isShowing()) {
                                        deleteDialog.dismiss();
                                    }
                                    CommonMethod.makeNoticeShort(getApplicationContext(), "删除成功", CommonMethod.SUCCESS);
                                    setResult(Constance.UPDATE_SUCCESS);
                                    finish();
                                } else {
                                    DataUtil.showErrOrMsg(RecordWeatherActivity.this, base.getErrno(), base.getErrmsg());
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    });
                }
            }, 0, "你确定要删除当前记录吗？");
        }
        deleteDialog.show();
    }

}
