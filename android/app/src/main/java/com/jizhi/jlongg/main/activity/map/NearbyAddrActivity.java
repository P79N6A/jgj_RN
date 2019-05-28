package com.jizhi.jlongg.main.activity.map;

import android.app.Activity;
import android.content.Intent;
import android.graphics.drawable.AnimationDrawable;
import android.os.Bundle;
import android.text.Editable;
import android.text.Html;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;

import com.baidu.mapapi.search.core.PoiInfo;
import com.baidu.mapapi.search.core.SearchResult;
import com.baidu.mapapi.search.poi.OnGetPoiSearchResultListener;
import com.baidu.mapapi.search.poi.PoiCitySearchOption;
import com.baidu.mapapi.search.poi.PoiDetailResult;
import com.baidu.mapapi.search.poi.PoiResult;
import com.baidu.mapapi.search.poi.PoiSearch;
import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.uclient.utils.KeyBoardUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.NearByInfoAdapter;
import com.jizhi.jlongg.main.dialog.DialogSelecteAddress;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.lidroid.xutils.exception.HttpException;

import java.util.List;

/**
 * 附近地址
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2015-7-30 上午10:11:04
 */
public class NearbyAddrActivity extends BaseActivity {

    /**
     * 城市列表ddapter
     */
    private NearByInfoAdapter adapter;
    /**
     * 搜索详细地址
     */
    private ClearEditText searchAddressEdit;
    /**
     * 未找到相关地址的View
     */
    private View noAddressView;
    /**
     * 搜索中的布局
     */
    private LinearLayout searchingLayout;
    /**
     * ListView
     */
    private ListView listView;
    /**
     * 搜索类
     */
    private PoiSearch mPoiSearch;
    /**
     * 城市名称
     */
    private String cityName;
    /**
     * 加载项目地址页码
     */
    private int loadAddressPage = 0;
    /**
     * 点击的对象
     */
    private PoiInfo clickPoiInfo;


    /**
     * 启动当前Activity
     *
     * @param context
     * @param cityName 城市名称
     */
    public static void actionStart(Activity context, String cityName, String proName, String teamId) {
        Intent intent = new Intent(context, NearbyAddrActivity.class);
        intent.putExtra("city_name", cityName);
        intent.putExtra("param1", proName);
        intent.putExtra(Constance.TEAM_ID, teamId);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    /**
     * 项目地址
     *
     * @param address
     */
    private void showSelectedAddressDialog(final String address) {
        DialogSelecteAddress dialogSelecteAddress = new DialogSelecteAddress(this, new DialogSelecteAddress.TipsClickListener() {
            @Override
            public void clickConfirm(int position) {
                setAddress(address);
            }
        });
        dialogSelecteAddress.setData(getIntent().getStringExtra("param1"), address);
        dialogSelecteAddress.show();
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_nearby);
        initView();
        initBaiduSearchConfiguration();
    }

    /**
     * 当窗口焦点改变时调用
     */
    public void onWindowFocusChanged(boolean hasFocus) {
        ImageView imageView = (ImageView) findViewById(R.id.spinner);
        // 获取ImageView上的动画背景
        AnimationDrawable spinner = (AnimationDrawable) imageView.getBackground();
        // 开始动画
        spinner.start();
        searchingLayout.setVisibility(View.GONE);
    }


    private void setAddress(String groupAddress) {
        final Intent intent = getIntent();
        MessageUtil.modifyTeamGroupInfo(this, intent.getStringExtra(Constance.TEAM_ID), WebSocketConstance.TEAM, null,
                null, null, null, null, groupAddress, new CommonHttpRequest.CommonRequestCallBack() {
                    @Override
                    public void onSuccess(Object object) {
                        intent.putExtra(Constance.BEAN_CONSTANCE, clickPoiInfo);
                        setResult(Constance.RESULTCODE_NEAYBYADDE, intent);
                        finish();
                    }

                    @Override
                    public void onFailure(HttpException exception, String errormsg) {

                    }
                });
    }

    private void initView() {
        setTextTitle(R.string.pro_address);
        listView = (ListView) findViewById(R.id.listView);
        searchAddressEdit = (ClearEditText) findViewById(R.id.filterEdit);
        noAddressView = findViewById(R.id.noAddressView);
        searchingLayout = (LinearLayout) findViewById(R.id.rea_seach);

        KeyBoardUtils.closeKeybord(searchAddressEdit, getApplicationContext());
        KeyBoardUtils.cursorMoveToLase(searchAddressEdit);
        // 初始化搜索模块，注册搜索事件监听

        searchAddressEdit.setHint(getString(R.string.pro_addres_hint));
        listView.setOnItemClickListener(new OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> arg0, View arg1, int position, long arg3) {
                clickPoiInfo = adapter.getList().get(position);
                showSelectedAddressDialog(clickPoiInfo.address);
            }
        });

        /**
         * 当输入关键字变化时，动态更新建议列表
         */
        searchAddressEdit.addTextChangedListener(new TextWatcher() {

            @Override
            public void afterTextChanged(Editable arg0) {
            }

            @Override
            public void beforeTextChanged(CharSequence arg0, int arg1, int arg2, int arg3) {
            }

            @Override
            public void onTextChanged(CharSequence cs, int arg1, int arg2, int arg3) {
                /**
                 * 使用建议搜索服务获取建议列表，结果在onSuggestionResult()中更新
                 */
                if (!TextUtils.isEmpty(searchAddressEdit.getText().toString().trim())) {
                    noAddressView.setVisibility(View.GONE);
                    searchingLayout.setVisibility(View.VISIBLE);
                    listView.setVisibility(View.VISIBLE);
                    setAdapterData(null);
                    serachAddr();
                } else {
                    searchingLayout.setVisibility(View.GONE);
                    noAddressView.setVisibility(View.GONE);
                    listView.setVisibility(View.GONE);
                }
            }
        });

        findViewById(R.id.chooseBtn).setOnClickListener(new View.OnClickListener() { //未搜索到地址时使用的地址
            @Override
            public void onClick(View v) {
                PoiInfo info = new PoiInfo();
                info.address = searchAddressEdit.getText().toString().trim();
                clickPoiInfo = info;
                showSelectedAddressDialog(info.address);
            }
        });
        getTextView(R.id.proAddress).setText(Html.fromHtml("<font color='#999999'>" +
                "请为&nbsp;</font><font color='#333333'>" + getIntent().getStringExtra("param1") + "&nbsp;</font><font color='#999999'>设置项目地址</font>"));
        //获取本地城市名称
        cityName = getIntent().getStringExtra("city_name");
        if (TextUtils.isEmpty(cityName)) { //如果地址为空 则默认为成都
            cityName = "成都市";
        }
    }


    private void initBaiduSearchConfiguration() {
        mPoiSearch = PoiSearch.newInstance();
        mPoiSearch.setOnGetPoiSearchResultListener(new OnGetPoiSearchResultListener() {
            @Override
            public void onGetPoiResult(PoiResult result) {
                searchingLayout.setVisibility(View.GONE);
                if (result == null || result.error == SearchResult.ERRORNO.RESULT_NOT_FOUND) {
                    searchFail();
                    return;
                }
                List<PoiInfo> poiInfos = result.getAllPoi();
                if (null != poiInfos && poiInfos.size() > 0) {
                    noAddressView.setVisibility(View.GONE);
                    listView.setVisibility(View.VISIBLE);
                    setAdapterData(poiInfos);
                } else {
                    searchFail();
                }
            }

            @Override
            public void onGetPoiDetailResult(PoiDetailResult poiDetailResult) {

            }
        });
    }


    private void setAdapterData(List<PoiInfo> list) {
        if (adapter == null) {
            adapter = new NearByInfoAdapter(this, list, false);
            listView.setAdapter(adapter);
        } else {
            adapter.updateList(list);
        }
    }

    public void serachAddr() {
        mPoiSearch.searchInCity((new PoiCitySearchOption()).city(cityName)
                .keyword(searchAddressEdit.getText().toString()).pageNum(loadAddressPage)
                .pageCapacity(30));
    }

    /**
     * 查找结果失败
     */
    public void searchFail() {
        listView.setVisibility(View.GONE);
        noAddressView.setVisibility(View.VISIBLE);
    }

    @Override
    protected void onDestroy() {
        mPoiSearch.destroy();
        super.onDestroy();
    }

}
