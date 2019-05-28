package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.Html;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.hcs.cityslist.widget.CharacterParser;
import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.FUtils;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.db.BaseInfoService;
import com.jizhi.jlongg.main.activity.map.NearbyAddrActivity;
import com.jizhi.jlongg.main.adpter.FilterCityAdapter;
import com.jizhi.jlongg.main.adpter.FindProjectCityAdapter;
import com.jizhi.jlongg.main.adpter.ProvinceAdapter;
import com.jizhi.jlongg.main.bean.CityInfoMode;
import com.jizhi.jlongg.main.dialog.CustomProgress;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.SetTitleName;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;


/**
 * 选择城市
 *
 * @author Xuj
 * @time 2017年5月27日10:52:42
 * @Version 1.0
 */
public class SelecteCityActivity extends BaseActivity {

    /* 省、市、搜索详情 ListView */
    private ListView provinceListView, cityListView, searchListView;
    /* 省、市数据 */
    private List<CityInfoMode> provinceList, cityList;
    /* 省适配器 */
    private ProvinceAdapter findProjectProvinceAdapter;
    /* 市适配器 */
    private FindProjectCityAdapter findProjectCityAdapter;
    //所有城市数据
    private List<CityInfoMode> allCityDateList;
    /* 汉字转换成拼音的类 */
    private CharacterParser characterParser;
    /* 筛选文字 */
    private String fileterStr;
    /* 城市搜索适配器 */
    private FilterCityAdapter adapter;

    private View searchLayout;


    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, String proName, String teamId) {
        Intent intent = new Intent(context, SelecteCityActivity.class);
        intent.putExtra("param1", proName);
        intent.putExtra(Constance.TEAM_ID, teamId);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, String proName, String teamId, boolean isTeamManager) {
        Intent intent = new Intent(context, SelecteCityActivity.class);
        intent.putExtra("param1", proName);
        intent.putExtra(Constance.TEAM_ID, teamId);
        intent.putExtra(Constance.BEAN_BOOLEAN, isTeamManager);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.selecte_city);
        initView();
        initData();
        getCityData();
    }

    private void initView() {
        if (getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false)) {
            SetTitleName.setTitle(findViewById(R.id.title), "项目地址");
        } else {
            setTextTitle(R.string.curr_city);
        }
        provinceListView = (ListView) findViewById(R.id.provinceListView);
        cityListView = (ListView) findViewById(R.id.cityListView);
        searchListView = (ListView) findViewById(R.id.searchListView);
        searchLayout = findViewById(R.id.searchLayout);
        characterParser = CharacterParser.getInstance();
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        mClearEditText.setHint("请输入城市的中文名称或拼音");
        mClearEditText.addTextChangedListener(new TextWatcher() { //根据输入框输入值的改变来过滤搜索
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                String textValue = s.toString().trim();
                if (TextUtils.isEmpty(textValue)) {
                    searchListView.setVisibility(View.GONE);
                    Utils.setBackGround(searchLayout, null);
                } else {
                    // 当输入框里面的值为空，更新为原来的列表，否则为过滤数据列表
                    boolean isWord = textValue.matches("[a-zA-Z]+");
                    if (isWord) {
                        filterCity(s.toString().toLowerCase());
                    } else {
                        filterCity(s.toString());
                    }
                }
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });
        getTextView(R.id.proAddress).setText(Html.fromHtml("<font color='#999999'>请为&nbsp;</font>" +
                "<font color='#333333'>" + getIntent().getStringExtra("param1") +
                "&nbsp;</font><font color='#999999'>设置项目地址</font>"));
        TextView currentCityText = getTextView(R.id.currentCity);
        String locationCity = SPUtils.get(this, Constance.PROVICECITY, "四川省 成都市", Constance.JLONGG).toString();
        if (!TextUtils.isEmpty(locationCity) && locationCity.contains("null") || TextUtils.isEmpty(locationCity)) {
            locationCity = "四川省 成都市";
        }
        currentCityText.setText(Html.fromHtml("<font color='#333333'>当前所在城市 : </font>" +
                "<font color='#d7252c'>" + locationCity + "</font>"));
        currentCityText.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                NearbyAddrActivity.actionStart(SelecteCityActivity.this, SPUtils.get(getApplicationContext(),
                        "loc_city_name", SPUtils.get(getApplicationContext(), Constance.PROVICECITY, "四川省 成都市", Constance.JLONGG).toString(), Constance.JLONGG).toString(),
                        getIntent().getStringExtra("param1"), getIntent().getStringExtra(Constance.TEAM_ID));
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
        new Thread(new Runnable() {
            @Override
            public void run() {
                final List<CityInfoMode> filterDataList = new ArrayList<>();
                for (CityInfoMode sortModel : allCityDateList) {
                    String cityName = sortModel.getCity_name();
                    if (cityName.indexOf(mFileterStr) != -1 || characterParser.getSelling(cityName).startsWith(mFileterStr)) {
                        filterDataList.add(sortModel);
                    }
                }

                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (filterDataList.size() > 0) {
                            if (mFileterStr.equals(fileterStr)) {
                                if (adapter == null) {
                                    adapter = new FilterCityAdapter(SelecteCityActivity.this, filterDataList);
                                    searchListView.setAdapter(adapter);
                                } else {
                                    adapter.updateListView(filterDataList);
                                }
                                searchListView.setVisibility(View.VISIBLE);
                                Utils.setBackGround(searchLayout, getResources().getDrawable(R.drawable.draw_rectangle_gray_white_round));
                            }
                        } else {
                            searchListView.setVisibility(View.GONE);
                        }
                    }
                });

            }
        }).start();
    }


    private void initData() {
        final BaseInfoService cityInfoService = BaseInfoService.getInstance(getApplicationContext());
        //显示省份数据
        provinceList = cityInfoService.SelectCity("0");
        findProjectProvinceAdapter = new ProvinceAdapter(this, provinceList);
        provinceListView.setAdapter(findProjectProvinceAdapter);
        LinearLayout.LayoutParams layoutParams = (LinearLayout.LayoutParams) provinceListView.getLayoutParams();
        layoutParams.rightMargin = DensityUtils.dp2px(this, 12);
        provinceListView.setLayoutParams(layoutParams);
        setClick(cityInfoService);
    }


    public void setClick(final BaseInfoService cityInfoService) {
        provinceListView.setOnItemClickListener(new AdapterView.OnItemClickListener() { //省级点击事件
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                findProjectProvinceAdapter.notifyDataSetChanged(provinceList.get(position).getCity_name());
                if (provinceList.size() > 0) {
                    String provinceCode = provinceList.get(position).getCity_code();
                    String provinceName = provinceList.get(position).getCity_name();
                    if (provinceName.equals("北京市") || provinceName.equals("天津市") || provinceName.equals("上海市") || provinceName.equals("重庆市") || provinceName.equals("全国")) {
                        cityListView.setVisibility(View.GONE);
                        NearbyAddrActivity.actionStart(SelecteCityActivity.this, provinceName, getIntent().getStringExtra("param1"), getIntent().getStringExtra(Constance.TEAM_ID));
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
                            findProjectCityAdapter = new FindProjectCityAdapter(getApplicationContext(), cityList);
                            cityListView.setAdapter(findProjectCityAdapter);
                        } else {
                            findProjectCityAdapter.updateList(cityList);
                        }
                        cityListView.setVisibility(View.VISIBLE);
                    }
                }
            }
        });
        cityListView.setOnItemClickListener(new AdapterView.OnItemClickListener() { //城市点击事件
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                String cityName = cityList.get(position).getCity_name();
                NearbyAddrActivity.actionStart(SelecteCityActivity.this, cityName, getIntent().getStringExtra("param1"), getIntent().getStringExtra(Constance.TEAM_ID));
            }
        });
        searchListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                String cityName = adapter.getList().get(position).getCity_name();
                NearbyAddrActivity.actionStart(SelecteCityActivity.this, cityName, getIntent().getStringExtra("param1"), getIntent().getStringExtra(Constance.TEAM_ID));
            }
        });
    }

    public void getCityData() {
        final CustomProgress customProgressTest = new CustomProgress(this);
        customProgressTest.show(this, "数据加载中", true);
        new Thread(new Runnable() {
            @Override
            public void run() {
                String provinceCityData = FUtils.readFromAssets(getApplicationContext(), "CityData.txt"); //省市县数据
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

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.RESULTCODE_NEAYBYADDE) { //已确认使用的地址
            setResult(Constance.RESULTCODE_NEAYBYADDE, data);
            finish();
        }
    }
}