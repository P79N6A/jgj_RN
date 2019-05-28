package com.jizhi.jlongg.main.dialog;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.SPUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.util.Constance;

/**
 * 功能: 记账包工 功能引导页
 * 作者：Xuj
 * 时间: 2016/3/11 15:47
 */
public class GuideDialog extends Dialog {

    private Context context;

    /**
     * 工头 班组长
     */
    private int[] location1;

    /**
     * 日薪模板设置
     */
    private int[] location2;

    /**
     * 今天上班
     */
    private int[] location3;

    /**
     * 今天下班
     */
    private int[] location4;

    /** 当前点击的按钮下标 */
    private int currentItem = 0;

    private RelativeLayout relativeLayout;

    private RelativeLayout.LayoutParams params;

    private int filter;


    public GuideDialog(Context context, int[] location1, int[] location2,int filter) {
        super(context, R.style.Transparent);
        this.context = context;
        this.location1 = location1;
        this.location2 = location2;
        this.filter = filter;
    }


    public GuideDialog(Context context, int[] location1, int[] location2, int[] location3, int[] location4,int filter) {
        super(context, R.style.Transparent);
        this.context = context;
        this.location1 = location1;
        this.location2 = location2;
        this.location3 = location3;
        this.location4 = location4;
        this.filter = filter;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.contractor_guide);
        setCanceledOnTouchOutside(false);
        setCancelable(false);// 设置为false，按返回键不能退出。默认为true。
        relativeLayout = (RelativeLayout)findViewById(R.id.relativeLayout);
        params = (RelativeLayout.LayoutParams)relativeLayout.getLayoutParams();
        switch (filter){
            case 1:
                initLiiterWork();
                break;
            case 2:
                initContractor();
                break;
            case 3:
                initPen();
                break;
        }
    }

    /** 初始化包工引导页*/
    private void initContractor(){
        final ImageView guide1 = (ImageView)findViewById(R.id.guide1);
        guide1.setImageResource(R.drawable.guide_5);
        params.topMargin = location1[1] - 8;
        relativeLayout.setLayoutParams(params);
        findViewById(R.id.guide1).setVisibility(View.VISIBLE);
        findViewById(R.id.orang_button).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                currentItem += 1;
                switch (currentItem) {
                    case 1:
                        params.topMargin = location2[1] - DensityUtils.getStatusHeight(context) - 8;
                        relativeLayout.setLayoutParams(params);
                        guide1.setImageResource(R.drawable.guide_6);
                        break;
                    case 2:
                        params.topMargin = location3[1] - DensityUtils.getStatusHeight(context) - 8;
                        relativeLayout.setLayoutParams(params);
                        guide1.setImageResource(R.drawable.guide_7);
                        break;
                    case 3:
                        params.topMargin = location4[1] - DensityUtils.getStatusHeight(context) - 8;
                        relativeLayout.setLayoutParams(params);
                        guide1.setImageResource(R.drawable.guide_8);
                        break;
                    case 4:
                        dismiss();
                        SPUtils.put(context, Constance.enum_parameter.CONTRACTOR.toString(), true, Constance.JLONGG);
                        break;
                }
            }
        });
    }


    /** 初始化点工引导页*/
    private void initLiiterWork(){
        final ImageView guide1 = (ImageView)findViewById(R.id.guide1);
        guide1.setImageResource(R.drawable.guide_1);
        params.topMargin = location1[1]  - 8;
        relativeLayout.setLayoutParams(params);
        findViewById(R.id.guide1).setVisibility(View.VISIBLE);
        findViewById(R.id.orang_button).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                currentItem += 1;
                switch (currentItem) {
                    case 1:
                        params.topMargin = location2[1] - DensityUtils.getStatusHeight(context) - 8;
                        relativeLayout.setLayoutParams(params);
                        guide1.setImageResource(R.drawable.guide_2);
                        break;
                    case 2:
                        params.topMargin = location3[1] - DensityUtils.getStatusHeight(context) - 8;
                        relativeLayout.setLayoutParams(params);
                        guide1.setImageResource(R.drawable.guide_3);
                        break;
                    case 3:
                        params.topMargin = location4[1] - DensityUtils.getStatusHeight(context) - 8;
                        relativeLayout.setLayoutParams(params);
                        guide1.setImageResource(R.drawable.guide_4);
                        break;
                    case 4:
                        dismiss();
                        SPUtils.put(context,Constance.enum_parameter.LIITLEWORK.toString(),true,Constance.JLONGG);
                        break;
                }
            }
        });
    }


    /** 初始化借支引导页*/
    private void initPen(){
        final ImageView guide1 = (ImageView)findViewById(R.id.guide1);
        guide1.setImageResource(R.drawable.guide_1);
        params.topMargin = location1[1] - DensityUtils.getStatusHeight(context) - 8;
        relativeLayout.setLayoutParams(params);
        findViewById(R.id.guide1).setVisibility(View.VISIBLE);
        findViewById(R.id.orang_button).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                currentItem += 1;
                switch (currentItem) {
                    case 1:
                        params.topMargin = location2[1] - DensityUtils.getStatusHeight(context) - 8;
                        relativeLayout.setLayoutParams(params);
                        guide1.setImageResource(R.drawable.guide_2);
                        break;
                    case 2:
                        params.topMargin = location3[1] - DensityUtils.getStatusHeight(context) - 8;
                        relativeLayout.setLayoutParams(params);
                        guide1.setImageResource(R.drawable.guide_3);
                        break;
                    case 3:
                        params.topMargin = location4[1] - DensityUtils.getStatusHeight(context) - 8;
                        relativeLayout.setLayoutParams(params);
                        guide1.setImageResource(R.drawable.guide_4);
                        break;
                    case 4:
                        dismiss();
                        SPUtils.put(context,Constance.enum_parameter.LIITLEWORK.toString(),true,Constance.JLONGG);
                        break;
                }
            }
        });
    }

}
