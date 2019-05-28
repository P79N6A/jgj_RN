package com.jizhi.jlongg.main.dialog;

import android.app.ActionBar;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.hcs.cityslist.widget.CharacterParser;
import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.FUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.db.BaseInfoService;
import com.jizhi.jlongg.main.adpter.FilterCityAdapter;
import com.jizhi.jlongg.main.adpter.FindProjectCityAdapter;
import com.jizhi.jlongg.main.adpter.ProvinceAdapter;
import com.jizhi.jlongg.main.bean.CityInfoMode;
import com.jizhi.jlongg.main.util.Constance;

import java.io.Serializable;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

/**
 * 选择城市window
 *
 * @author huchangsheng
 * @date 2016年4月18日 15:45:12
 */
public class PopSelectProvinceAndCity extends PopupWindow {
    /* 上下文 */
    private Context context;
    /* 省、市、模糊搜索ListView */
    private ListView provinceListView, cityListView, searchListView;
    /* 省、市数据 */
    private List<CityInfoMode> provinceList, cityList;
    /* 省适配器 */
    private ProvinceAdapter findProjectProvinceAdapter;
    /* 市适配器 */
    private FindProjectCityAdapter findProjectCityAdapter;
    /* 城市点击回调函数 */
    private CityItemClickListerer cityClick;
    //所有城市数据、筛选的城市数据
    private List<CityInfoMode> allCityDateList, filterDataList;
    /* 城市搜索适配器 */
    private FilterCityAdapter adapter;
    private LinearLayout rea_seach;
    /* 汉字转换成拼音的类 */
    private CharacterParser characterParser;
    /* 筛选文字 */
    private String fileterStr;

    public PopSelectProvinceAndCity(Context context, CityItemClickListerer cityClick) {
        super(context);
        this.context = context;
        this.cityClick = cityClick;
        init();
        initData();
        getCityData();
    }

    private void init() {
        View view = LayoutInflater.from(context).inflate(R.layout.filter_city, null);
        setContentView(view);
        setWidth(ActionBar.LayoutParams.MATCH_PARENT);
        setHeight(ActionBar.LayoutParams.MATCH_PARENT);
        setFocusable(true);
        ColorDrawable dw = new ColorDrawable(0x00);
        setBackgroundDrawable(dw);
        provinceListView = (ListView) view.findViewById(R.id.provinceListView);
        cityListView = (ListView) view.findViewById(R.id.cityListView);
        searchListView = (ListView) view.findViewById(R.id.searchListView);
        rea_seach = (LinearLayout) view.findViewById(R.id.rea_seach);
        characterParser = CharacterParser.getInstance();
        ClearEditText mClearEditText = (ClearEditText) view.findViewById(R.id.filter_edit);
        mClearEditText.addTextChangedListener(new TextWatcher() { //根据输入框输入值的改变来过滤搜索
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                // 当输入框里面的值为空，更新为原来的列表，否则为过滤数据列表
                boolean isWord = s.toString().matches("[a-zA-Z]+");
                if (isWord) {
                    filterCity(s.toString().toLowerCase());
                } else {
                    filterCity(s.toString());
                }
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });
    }


    /**
     * 过滤城市信息
     *
     * @param mFileterStr
     */
    private synchronized void filterCity(final String mFileterStr) {
        fileterStr = mFileterStr;
        if (!TextUtils.isEmpty(mFileterStr)) {
            new Thread(new Runnable() {
                @Override
                public void run() {
                    List<CityInfoMode> filterDataList = new ArrayList<>();
                    for (CityInfoMode sortModel : allCityDateList) {
                        String cityName = sortModel.getCity_name();
                        if (cityName.indexOf(mFileterStr) != -1 || characterParser.getSelling(cityName).startsWith(mFileterStr)) {
                            filterDataList.add(sortModel);
                        }
                    }
                    if (filterDataList.size() != 0) {
                        Message message = Message.obtain();
                        Bundle bundle = new Bundle();
                        bundle.putSerializable(Constance.BEAN_ARRAY, (Serializable) filterDataList);
                        bundle.putString(Constance.BEAN_STRING, mFileterStr);
                        message.setData(bundle);
                        message.what = VISIBLEFILTER;
                        mHandler.sendMessage(message);
                    } else {
                        mHandler.sendEmptyMessage(GONEFILTER);
                    }
                }
            }).start();
        } else {
            searchListView.setVisibility(View.GONE);
        }
    }

    /**
     * 显示筛选数据
     */
    private final int VISIBLEFILTER = 1;

    /**
     * 隐藏筛选数据
     */
    private final int GONEFILTER = 2;


    public Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case VISIBLEFILTER://查询列表数据
                    Bundle bundle = msg.getData();
                    String filter = bundle.getString(Constance.BEAN_STRING, "");
                    if (!filter.equals(fileterStr)) {
                        return;
                    }
                    List<CityInfoMode> filterList = (List<CityInfoMode>) bundle.getSerializable(Constance.BEAN_ARRAY);
                    filterDataList = filterList;
                    searchListView.setVisibility(View.VISIBLE);
                    Utils.setBackGround(rea_seach, context.getResources().getDrawable(R.drawable.draw_rectangle_gray_white_round));
                    if (null == adapter) {
                        adapter = new FilterCityAdapter(context, filterList);
                        searchListView.setAdapter(adapter);
                    } else {
                        adapter.updateListView(filterList);
                    }
                    searchListView.setSelection(1);
                    break;
                case GONEFILTER:
                    searchListView.setVisibility(View.GONE);
                    break;
                default:
                    break;
            }
            super.handleMessage(msg);
        }
    };


    private void initData() {
        final BaseInfoService cityInfoService = BaseInfoService.getInstance(context.getApplicationContext());
        //显示省份数据
        provinceList = cityInfoService.SelectCity("0");
        if (null == provinceList) {
            provinceList = new ArrayList<>();
        }
        CityInfoMode all_province = new CityInfoMode("-1", "全国", "0"); //全国
        provinceList.add(0, all_province);
        findProjectProvinceAdapter = new ProvinceAdapter(context, provinceList);
        provinceListView.setAdapter(findProjectProvinceAdapter);
        LinearLayout.LayoutParams layoutParams = (LinearLayout.LayoutParams) provinceListView.getLayoutParams();
        layoutParams.rightMargin = DensityUtils.dp2px(context, 12);
        provinceListView.setLayoutParams(layoutParams);
        setClick(cityInfoService);
    }


    public void setClick(final BaseInfoService cityInfoService) {
        provinceListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                findProjectProvinceAdapter.notifyDataSetChanged(provinceList.get(position).getCity_name());
                if (provinceList.size() > 0) {
                    String provinceCode = provinceList.get(position).getCity_code();
                    String provinceName = provinceList.get(position).getCity_name();
                    if (provinceName.equals("北京市") || provinceName.equals("天津市") || provinceName.equals("上海市") || provinceName.equals("重庆市") || provinceName.equals("全国")) {
                        cityClick.cityItemClick(provinceName, provinceCode);
                        cityListView.setVisibility(View.GONE);
                        dismiss();
                        return;
                    }
                    cityList = cityInfoService.SelectCity(provinceCode);
                    if (null != cityList && cityList.size() > 0) {
                        CityInfoMode all_province = new CityInfoMode(provinceList.get(position).getCity_code(), provinceList.get(position).getCity_name(), "0"); //全省
                        cityList.add(0, all_province);
                        //显示城市数据
                        LinearLayout.LayoutParams layoutParams = (LinearLayout.LayoutParams) provinceListView.getLayoutParams();
                        layoutParams.rightMargin = 0;
                        provinceListView.setLayoutParams(layoutParams);
                        if (findProjectCityAdapter == null) {
                            findProjectCityAdapter = new FindProjectCityAdapter(context, cityList);
                            cityListView.setAdapter(findProjectCityAdapter);
                        } else {
                            findProjectCityAdapter.updateList(cityList);
                        }
                        cityListView.setVisibility(View.VISIBLE);
                    }
                }

            }
        });
        cityListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                String cityName = cityList.get(position).getCity_name();
                String cityCode = cityList.get(position).getCity_code();
                cityClick.cityItemClick(cityName, cityCode);
                dismiss();
            }
        });
        searchListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                String cityName = filterDataList.get(position).getCity_name();
                String cityCode = filterDataList.get(position).getCity_code();
                cityClick.cityItemClick(cityName, cityCode);
                dismiss();
            }
        });
    }

    public void getCityData() {
        final CustomProgress customProgressTest = new CustomProgress(context);
        customProgressTest.show(context, "数据加载中", true);
        new Thread(new Runnable() {
            @Override
            public void run() {
                String provinceCityData = FUtils.readFromAssets(context, "CityData.txt"); //省市县数据
                if (!TextUtils.isEmpty(provinceCityData)) {
                    Gson gson = new Gson();
                    Type type = new TypeToken<ArrayList<CityInfoMode>>() {
                    }.getType();
                    allCityDateList = gson.fromJson(provinceCityData, type);
                    customProgressTest.closeDialog();
                }

            }
        }).start();
    }


    public interface CityItemClickListerer {
        void cityItemClick(String cityName, String cityCode);
    }
}
