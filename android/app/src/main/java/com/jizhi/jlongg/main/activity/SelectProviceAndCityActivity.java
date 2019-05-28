package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Editable;
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
import com.jizhi.jlongg.main.adpter.FilterCityAdapter;
import com.jizhi.jlongg.main.adpter.FindProjectCityAdapter;
import com.jizhi.jlongg.main.adpter.ProvinceAdapter;
import com.jizhi.jlongg.main.bean.CityInfoMode;
import com.jizhi.jlongg.main.dialog.CustomProgress;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.lidroid.xutils.exception.HttpException;

import java.io.Serializable;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

/**
 * CName:选择城市
 * User: hcs
 * Date: 2016-08-23
 * Time: 16:50
 */
public class SelectProviceAndCityActivity extends BaseActivity {
    /* 当前省下标 */
    private int provincePosition = -1;
    //省市数据
    private ListView lv_province, lv_city, all_city;
    /* 城市适配器 */
    private FindProjectCityAdapter cityAdapter;
    /* 省适配器 */
    private ProvinceAdapter provinceAdapter;
    //所有城市数据、筛选的城市数据
    private List<CityInfoMode> SourceDateList, filterDataList;
    private FilterCityAdapter adapter;
    private LinearLayout rea_seach;
    /* 当前输入的筛选城市 */
    private String fileterStr;
    /* 是否是班组管理 */
    private boolean isEditorTeamManager;
    /* 项目id */
    private String groupId;
    /* 点击城市编码 */
    private String cityCode, cityName;


    /**
     * 启动当前Activity
     *
     * @param context
     * @param groupId      项目组id
     * @param selectedCity 已选择的城市
     * @param isEditor     true表示正在编辑班组地点
     */
    public static void actionStart(Activity context, String groupId, String selectedCity, boolean isEditor) {
        Intent intent = new Intent(context, SelectProviceAndCityActivity.class);
        intent.putExtra("selectedCity", selectedCity);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.BEAN_BOOLEAN, isEditor);
        context.startActivityForResult(intent, Constance.REQUESTCODE_SELECTCITY);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, SelectProviceAndCityActivity.class);
        context.startActivityForResult(intent, Constance.REQUESTCODE_SELECTCITY);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_filter_city);
        setTextTitle(R.string.curr_city);
        initView();
        initData();
        initTeamManagerData();
    }

    private void initTeamManagerData() {
        Intent intent = getIntent();
        isEditorTeamManager = intent.getBooleanExtra(Constance.BEAN_BOOLEAN, false);
        groupId = intent.getStringExtra(Constance.GROUP_ID);
    }

    private void initView() {
        TextView currentCity = (TextView) findViewById(R.id.current_city);
        Intent intent = getIntent();
        String selectedCity = intent.getStringExtra("selectedCity"); //已选的城市
        String provice = SPUtils.get(getApplicationContext(), Constance.PROVICECITY, "", Constance.JLONGG).toString();
        currentCity.setText(!TextUtils.isEmpty(selectedCity) ? selectedCity : TextUtils.isEmpty(provice) ? "未定位到相关城市" : provice);
        lv_province = (ListView) findViewById(R.id.lv_province);
        lv_city = (ListView) findViewById(R.id.lv_city);
        all_city = (ListView) findViewById(R.id.all_city);
        rea_seach = (LinearLayout) findViewById(R.id.rea_seach);
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filter_edit);
        // 根据输入框输入值的改变来过滤搜索
        mClearEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                // 当输入框里面的值为空，更新为原来的列表，否则为过滤数据列表
                boolean isWord = s.toString().matches("[a-zA-Z]+");
                if (isWord) {
                    filterData1(s.toString().toLowerCase());
                } else {
                    filterData1(s.toString());
                }
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });
        getCityData();
    }


    private synchronized void filterData1(final String mFileterStr) {
        fileterStr = mFileterStr;
        if (!TextUtils.isEmpty(mFileterStr)) {
            new Thread(new Runnable() {
                @Override
                public void run() {
                    List<CityInfoMode> filterDataList = new ArrayList<CityInfoMode>();
                    for (CityInfoMode sortModel : SourceDateList) {
                        String name = sortModel.getCity_name();
                        if (name.indexOf(mFileterStr) != -1 || CharacterParser.getInstance().getSelling(name).startsWith(mFileterStr)) {
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
            all_city.setVisibility(View.GONE);
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
    /**
     * 数据库
     */
    private BaseInfoService cityInfoService;

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
                    SelectProviceAndCityActivity.this.filterDataList = filterList;
                    all_city.setVisibility(View.VISIBLE);
                    Utils.setBackGround(rea_seach, getResources().getDrawable(R.drawable.draw_rectangle_gray_white_round));
                    if (null == adapter) {
                        adapter = new FilterCityAdapter(SelectProviceAndCityActivity.this, filterList);
                        all_city.setAdapter(adapter);
                    } else {
                        adapter.updateListView(filterList);
                    }
                    all_city.setSelection(1);
                    break;
                case GONEFILTER:
                    all_city.setVisibility(View.GONE);
                    break;
                default:
                    break;
            }
            super.handleMessage(msg);
        }
    };


    private void initData() {
        cityInfoService = BaseInfoService.getInstance(getApplicationContext());
        //显示省份数据
        List<CityInfoMode> provinceList = cityInfoService.SelectCity("0");
        if (provinceList == null) {
            CommonMethod.makeNoticeShort(this, "获取城市失败", CommonMethod.ERROR);
            finish();
            return;
        }
        provinceAdapter = new ProvinceAdapter(getApplicationContext(), provinceList);
        lv_province.setAdapter(provinceAdapter);
        LinearLayout.LayoutParams layoutParams = (LinearLayout.LayoutParams) lv_province.getLayoutParams();
        layoutParams.rightMargin = DensityUtils.dp2px(getApplicationContext(), 12);
        lv_province.setLayoutParams(layoutParams);
        lv_province.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (provincePosition == position) {
                    return;
                }
                if (provinceAdapter.getProvinceList().size() > 0) {
                    List<CityInfoMode> provinceList = provinceAdapter.getProvinceList();
                    provinceAdapter.notifyDataSetChanged(provinceList.get(position).getCity_name());
                    String provinceCode = provinceList.get(position).getCity_code();
                    String provinceName = provinceList.get(position).getCity_name();
                    SelectProviceAndCityActivity.this.cityCode = provinceCode;
                    SelectProviceAndCityActivity.this.cityName = provinceName;
                    if (provinceName.equals("北京市") || provinceName.equals("天津市") || provinceName.equals("上海市") || provinceName.equals("重庆市") || provinceName.equals("全国")) {
                        if (isEditorTeamManager) {
                            setCityInfo();
                            return;
                        }
                        returnParameter();
                    } else {
                        provincePosition = position;
                        List<CityInfoMode> cityList = cityInfoService.SelectCity(provinceCode); //城市数据
                        if (null != cityList && cityList.size() > 0) {
                            //显示城市数据
                            LinearLayout.LayoutParams layoutParams = (LinearLayout.LayoutParams) lv_province.getLayoutParams();
                            layoutParams.rightMargin = 0;
                            lv_province.setLayoutParams(layoutParams);
                            if (cityAdapter == null) {
                                cityAdapter = new FindProjectCityAdapter(getApplicationContext(), cityList);
                                lv_city.setAdapter(cityAdapter);
                            } else {
                                cityAdapter.updateList(cityList);
                            }
                            lv_city.setVisibility(View.VISIBLE);
                        }
                    }
                }
            }
        });
        lv_city.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                List<CityInfoMode> provinceList = provinceAdapter.getProvinceList();
                String provinceName = provinceList.get(provincePosition).getCity_name();
                String cityCode = cityAdapter.getCityList().get(position).getCity_code();
                String cityName = cityAdapter.getCityList().get(position).getCity_name();
                SelectProviceAndCityActivity.this.cityCode = cityCode;
                SelectProviceAndCityActivity.this.cityName = provinceName + "  " + cityName;
                if (isEditorTeamManager) {
                    setCityInfo();
                } else {
                    returnParameter();
                }
            }
        });
        all_city.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                String cityName = filterDataList.get(position).getCity_name();
                String cityCode = filterDataList.get(position).getCity_code();
                SelectProviceAndCityActivity.this.cityName = cityName;
                SelectProviceAndCityActivity.this.cityCode = cityCode;
                if (isEditorTeamManager) {
                    setCityInfo();
                } else {
                    returnParameter();
                }
            }
        });
    }

    /**
     * 获取本地城市数据库数据
     */
    public void getCityData() {
        final CustomProgress customProgressTest = new CustomProgress(this);
        customProgressTest.show(SelectProviceAndCityActivity.this, "数据加载中", true);
        new Thread(new Runnable() {
            @Override
            public void run() {
                String filedatas = FUtils.readFromAssets(getApplicationContext(), "CityData.txt");
                if (!filedatas.equals("")) {
                    Gson gson = new Gson();
                    Type type = new TypeToken<ArrayList<CityInfoMode>>() {
                    }.getType();
                    SourceDateList = gson.fromJson(filedatas, type);
                    customProgressTest.closeDialog();
                }
            }
        }).start();
    }

    private void returnParameter() {
        Intent intent = getIntent();
        intent.putExtra("cityName", cityName);
        intent.putExtra("cityCode", cityCode);
        setResult(Constance.SET_CITY_INFO_SUCCESS, intent);
        finish();
    }

    private void setCityInfo() {
        MessageUtil.modifyTeamGroupInfo(this, groupId, WebSocketConstance.GROUP, null, null, cityCode, null, null, null,
                new CommonHttpRequest.CommonRequestCallBack() {
                    @Override
                    public void onSuccess(Object object) {
                        returnParameter();
                    }

                    @Override
                    public void onFailure(HttpException exception, String errormsg) {

                    }
                });
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (cityInfoService != null) {
            cityInfoService.closeDB();
        }
    }

}

