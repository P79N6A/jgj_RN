package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.db.BaseInfoService;
import com.jizhi.jlongg.main.adpter.CityWheelAdapter;
import com.jizhi.jlongg.main.bean.CityInfoMode;
import com.jizhi.jlongg.main.listener.SelectProvinceCityAreaListener;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.wheelview.OnWheelChangedListener;
import com.jizhi.wheelview.OnWheelScrollListener;
import com.jizhi.wheelview.WheelView;

import java.util.List;

public class WheelViewSelectProvinceCityArea extends PopupWindow implements OnClickListener, OnWheelChangedListener, OnWheelScrollListener, PopupWindow.OnDismissListener {
    /* 省wheelView  */
    private WheelView wheelViewProvince;
    /* 市wheelView */
    private WheelView wheelViewCity;
    /* 区wheelView */
    private WheelView wheelViewArea;
    /* 省数据 */
    private List<CityInfoMode> provinceList;
    /* 世数据 */
    private List<CityInfoMode> cityList;
    /* 区数据 */
    private List<CityInfoMode> areasList;
    /* 选择省、市、县回调 */
    public SelectProvinceCityAreaListener listener;
    /* 上下文 */
    private Activity context;
    /* 适配器*/
    private CityWheelAdapter adapterProvince, adapterCity, adapterAreas;
    private BaseInfoService cityInfoService;
    /* popwindow */
    private View popView;
    /* 如果值等于home 则选择家乡
    *  如果值等于EXPERCTEDWORK 则是选择期望工作地
    * */
    private String type;


    public WheelViewSelectProvinceCityArea(Activity context, SelectProvinceCityAreaListener listener, String title, String type) {
        super(context);
        this.context = context;
        this.listener = listener;
        this.type = type;
        setPopView();
        initView(title);
        initData();
        setListener();
    }

    private void initView(String title) {
        wheelViewProvince = (WheelView) popView.findViewById(R.id.id_province);
        wheelViewCity = (WheelView) popView.findViewById(R.id.id_city);
        wheelViewArea = (WheelView) popView.findViewById(R.id.id_district);
        TextView tv_context = (TextView) popView.findViewById(R.id.tv_context);
        tv_context.setText(title);
        wheelViewArea.setVisibility(type.equals(Constance.EXPECTEDWORK) ? View.GONE : View.VISIBLE);
    }


    public void update() {
        adapterProvince.setCurrentIndex(wheelViewProvince.getCurrentItem());
        adapterCity.setCurrentIndex(wheelViewCity.getCurrentItem());
        adapterAreas.setCurrentIndex(wheelViewArea.getCurrentItem());
    }


    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.city_wheel_view, null);
        setContentView(popView);
        //设置SelectPicPopupWindow弹出窗体的宽
        setWidth(ViewGroup.LayoutParams.MATCH_PARENT);
        //设置SelectPicPopupWindow弹出窗体的高
        setHeight(ViewGroup.LayoutParams.WRAP_CONTENT);
        //设置SelectPicPopupWindow弹出窗体可点击
        setFocusable(true);
        //设置SelectPicPopupWindow弹出窗体动画效果
        setAnimationStyle(R.style.ActionSheetDialogAnimation);
        //实例化一个ColorDrawable颜色为半透明
        ColorDrawable dw = new ColorDrawable(0xb0000000);
        setOnDismissListener(this);
        //设置SelectPicPopupWindow弹出窗体的背景
        setBackgroundDrawable(dw);
        setOutsideTouchable(true);
    }

    private void initData() {
        cityInfoService = BaseInfoService.getInstance(context.getApplicationContext());
        provinceList = cityInfoService.SelectCity("0");
        if (null == provinceList) {
            CommonMethod.makeNoticeShort(context, "城市查询失败", CommonMethod.ERROR);
            dismiss();
            return;
        }
        adapterProvince = new CityWheelAdapter(context, provinceList, 0);
        wheelViewProvince.setViewAdapter(adapterProvince);
        // 设置可见条目数量
        wheelViewProvince.setVisibleItems(7);
        wheelViewCity.setVisibleItems(7);
        wheelViewArea.setVisibleItems(7);
        updateCities();
    }

    private void setListener() {
        // 添加change事件
        wheelViewProvince.addChangingListener(this);
        // 添加change事件
        wheelViewCity.addChangingListener(this);
        // 添加change事件
        wheelViewArea.addChangingListener(this);

        wheelViewProvince.addScrollingListener(this);
        wheelViewCity.addScrollingListener(this);
        wheelViewArea.addScrollingListener(this);

        // 添加onclick事件
        popView.findViewById(R.id.btn_confirm).setOnClickListener(this);
        popView.findViewById(R.id.btn_cancel).setOnClickListener(this);
    }

    /**
     * 根据当前的省，更新市WheelView的信息
     */
    private void updateCities() {
        int provincePostion = wheelViewProvince.getCurrentItem();
        String city_code = provinceList.get(provincePostion).getCity_code();
        cityList = cityInfoService.SelectCity(city_code);
        adapterCity = new CityWheelAdapter(context, cityList, 0);
        wheelViewCity.setViewAdapter(adapterCity);
        wheelViewCity.setCurrentItem(0);
        if (cityList != null && cityList.size() > 0) {
            updateAreas();
        }
    }

    /**
     * 根据当前的市，更新区WheelView的信息
     */
    private void updateAreas() {
        int cityPosition = wheelViewCity.getCurrentItem();
        String areaCode = cityList.get(cityPosition).getCity_code();
        areasList = cityInfoService.SelectCity(areaCode);
        adapterAreas = new CityWheelAdapter(context, areasList, 0);
        wheelViewArea.setViewAdapter(adapterAreas);
        wheelViewArea.setCurrentItem(0);
    }

    @Override
    public void onChanged(WheelView wheel, int oldValue, int newValue) {
        setScrollTextColor(wheel);
    }


    private void setScrollTextColor(WheelView wheel) {
        if (wheel == wheelViewProvince) {
            String currentText = (String) adapterProvince.getItemText(wheelViewProvince.getCurrentItem());
            adapterProvince.setTextViewSize(currentText, adapterProvince);
        } else if (wheel == wheelViewCity) {
            String currentText = (String) adapterCity.getItemText(wheelViewCity.getCurrentItem());
            adapterCity.setTextViewSize(currentText, adapterCity);
        } else if (wheel == wheelViewArea) {
            String currentText = (String) adapterAreas.getItemText(wheelViewArea.getCurrentItem());
            adapterAreas.setTextViewSize(currentText, adapterAreas);
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_confirm:
                String cityCode = null;
                StringBuilder builder = new StringBuilder();
                CityInfoMode provinceMode = provinceList.get(wheelViewProvince.getCurrentItem());
                builder.append(provinceMode.getCity_name());
                if (cityList != null && cityList.size() > 0) {
                    int cityPosition = wheelViewCity.getCurrentItem();
                    builder.append(" " + cityList.get(cityPosition).getCity_name());
                    cityCode = cityList.get(cityPosition).getCity_code();
                }
                if (type != Constance.EXPECTEDWORK && areasList != null && areasList.size() > 0) {
                    int areaPosition = wheelViewArea.getCurrentItem();
                    builder.append(" " + String.valueOf(areasList.get(areaPosition).getCity_name()));
                    cityCode = areasList.get(areaPosition).getCity_code();
                }
                listener.selectedCityResult(type, cityCode, builder.toString());
                LUtils.e("cityCode", cityCode);
                break;
        }
        dismiss();
    }

    @Override
    public void onScrollingStarted(WheelView wheel) {

    }

    @Override
    public void onScrollingFinished(WheelView wheel) {
        if (wheel == wheelViewProvince) {
            updateCities();
        } else if (wheel == wheelViewCity) {
            updateAreas();
        }
        setScrollTextColor(wheel);
    }

    @Override
    public void onDismiss() {
        context.runOnUiThread(new Runnable() {
            public void run() {
                BackGroundUtil.backgroundAlpha(context, 1.0F);
            }
        });
    }
}
