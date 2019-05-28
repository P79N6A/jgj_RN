package com.jizhi.jlongg.main.dialog;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.db.BaseInfoService;
import com.jizhi.jlongg.main.bean.CityInfoMode;
import com.jizhi.wheelview.OnWheelChangedListener;
import com.jizhi.wheelview.WheelView;
import com.jizhi.wheelview.adapter.MyArrayWheelAdapter;

import java.util.ArrayList;
import java.util.List;

public class WheelViewSelectCityDialog extends Dialog implements
        OnClickListener, OnWheelChangedListener {
    private WheelView mViewProvince;
    private WheelView mViewCity;
    private WheelView mViewDistrict;
    private Button mBtnConfirm, mBtnCancel;
    private List<CityInfoMode> provinceList;
    private BaseInfoService cityInfoService;
    private List<CityInfoMode> cityList;
    private List<CityInfoMode> areasList;
    private CityInfoMode province;
    private CityInfoMode city;
    private CityInfoMode areas;
    public SelectedResultClickListener listener;
    private Context context;
    private MyArrayWheelAdapter adapterProvince, adapterCity, adapterDistrict;
    private boolean isSelet;
    private int maxsize = 24;
    private int minsize = 14;
    private String title;

    public WheelViewSelectCityDialog(Context context, SelectedResultClickListener listener, boolean isSelet, String title) {
        super(context, R.style.wheelViewDialog);
        this.context = context;
        this.listener = listener;
        this.isSelet = isSelet;
        this.title = title;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        DensityUtils.applyCompat(getWindow(), context);
        setContentView(R.layout.city_wheel_view);
        setUpViews();
        initData();

    }

    private void initData() {
        cityInfoService = BaseInfoService.getInstance(context.getApplicationContext());
        provinceList = cityInfoService.SelectCity("0");
        if (null == provinceList) {
            provinceList = new ArrayList<CityInfoMode>();
        }
        adapterProvince = new MyArrayWheelAdapter(context, provinceList, 0,
                maxsize, minsize);
        mViewProvince.setViewAdapter(adapterProvince);
        // 设置可见条目数量
        mViewProvince.setVisibleItems(7);
        mViewCity.setVisibleItems(7);
        mViewDistrict.setVisibleItems(7);
        setUpListener();
        updateCities();
    }

    private void setUpViews() {
        mViewProvince = (WheelView) findViewById(R.id.id_province);
        mViewCity = (WheelView) findViewById(R.id.id_city);
        mViewDistrict = (WheelView) findViewById(R.id.id_district);
        mBtnConfirm = (Button) findViewById(R.id.btn_confirm);
        mBtnCancel = (Button) findViewById(R.id.btn_cancel);
        TextView tv_context = (TextView) findViewById(R.id.tv_context);
        tv_context.setText(title);
        if (!isSelet) {
            mViewDistrict.setVisibility(View.GONE);
        }
    }

    private void setUpListener() {
        // 添加change事件
        mViewProvince.addChangingListener(this);
        // 添加change事件
        mViewCity.addChangingListener(this);
        // 添加change事件
        mViewDistrict.addChangingListener(this);
        // 添加onclick事件
        mBtnConfirm.setOnClickListener(this);
        mBtnCancel.setOnClickListener(this);
    }

    /**
     * 根据当前的省，更新市WheelView的信息
     */
    private void updateCities() {
        int pCurrent = mViewProvince.getCurrentItem();
        if (pCurrent < provinceList.size()) {
            if (provinceList.size() > 0) {
                province = provinceList.get(pCurrent);
            } else {
                province = new CityInfoMode("", "", "");
            }
            String city_code = provinceList.get(pCurrent).getCity_code();
            cityList = new ArrayList<CityInfoMode>();
            cityList = cityInfoService.SelectCity(city_code);
            if (cityList == null) {
                cityList = new ArrayList<CityInfoMode>();
                CityInfoMode cityInfoMode = new CityInfoMode("", "", "");
                cityList.add(cityInfoMode);
            }
            adapterCity = new MyArrayWheelAdapter(context, cityList, 0,
                    maxsize, minsize);
            mViewCity.setViewAdapter(adapterCity);
            mViewCity.setCurrentItem(0);
            updateAreas();
        } else {
            province = new CityInfoMode("", "", "");
        }
    }

    /**
     * 根据当前的市，更新区WheelView的信息
     */
    private void updateAreas() {
        int pCurrent = mViewCity.getCurrentItem();
        if (pCurrent < cityList.size()) {
            if (cityList.size() > 0) {
                city = cityList.get(pCurrent);
            } else {
                city = new CityInfoMode("", "", "");
            }
            String city_code = cityList.get(pCurrent).getCity_code();
            areasList = new ArrayList<CityInfoMode>();
            areasList = cityInfoService.SelectCity(city_code);
            if (areasList == null) {
                areasList = new ArrayList<CityInfoMode>();
                CityInfoMode cityInfoMode = new CityInfoMode("", "", "");
                areasList.add(cityInfoMode);
            }
            adapterDistrict = new MyArrayWheelAdapter(context, areasList, 0,
                    maxsize, minsize);
            mViewDistrict.setViewAdapter(adapterDistrict);
            mViewDistrict.setCurrentItem(0);
        } else {
            city = new CityInfoMode("", "", "");
        }
        pCurrent = mViewDistrict.getCurrentItem();
        if (areasList.size() > 0) {
            areas = areasList.get(pCurrent);
        } else {
            areas = new CityInfoMode("", "", "");
        }

    }

    @Override
    public void onChanged(WheelView wheel, int oldValue, int newValue) {
        if (wheel == mViewProvince) {
            updateCities();
            String currentText = (String) adapterProvince
                    .getItemText(mViewProvince.getCurrentItem());
            setTextviewSize(currentText, adapterProvince);
        } else if (wheel == mViewCity) {
            updateAreas();
            String currentText = (String) adapterCity.getItemText(mViewCity
                    .getCurrentItem());
            setTextviewSize(currentText, adapterCity);
        } else if (wheel == mViewDistrict) {
            int pCurrent = mViewDistrict.getCurrentItem();
            String currentText = (String) adapterDistrict
                    .getItemText(mViewDistrict.getCurrentItem());
            setTextviewSize(currentText, adapterDistrict);
            if (areasList.size() > 0) {
                areas = areasList.get(pCurrent);
            } else {
                areas = new CityInfoMode("", "", "");
            }
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_confirm:
                if (isSelet) {
                    listener.selectedResultClick(province, city, areas);
                } else {
                    listener.selectedCityNoAresClick(province, city);
                }
                break;
        }
        dismiss();
    }

    /**
     * 设置字体大小
     *
     * @param curriteItemText
     * @param adapter
     */
    public void setTextviewSize(String curriteItemText, MyArrayWheelAdapter adapter) {
        ArrayList<View> arrayList = adapter.getTestViews();
        int size = arrayList.size();
        String currentText;
        for (int i = 0; i < size; i++) {
            TextView textView = (TextView) arrayList.get(i);
            currentText = textView.getText().toString();
            if (curriteItemText.equals(currentText)) {
                textView.setTextSize(24);
                textView.setTextColor(context.getResources().getColor(R.color.app_color));
            } else {
                textView.setTextSize(14);
                textView.setTextColor(context.getResources().getColor(R.color.black));
            }
        }
    }

    public interface SelectedResultClickListener {
        void selectedResultClick(CityInfoMode province, CityInfoMode city, CityInfoMode areas);

        void selectedCityNoAresClick(CityInfoMode province, CityInfoMode city);
    }
}
