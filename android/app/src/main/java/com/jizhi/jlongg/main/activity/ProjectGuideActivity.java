package com.jizhi.jlongg.main.activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.custom.TextViewTouchChangeAlpha;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.network.NetWorkRequest;

/**
 * CName:
 * User: hcs
 * Date: 2016-10-18
 * Time: 14:37
 */
public class ProjectGuideActivity extends BaseActivity {
    private TextViewTouchChangeAlpha red_btn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_project_guide);
        red_btn = (TextViewTouchChangeAlpha) findViewById(R.id.red_btn);
        String title = getIntent().getStringExtra("title");
        ((TextView) findViewById(R.id.title)).setText(title);
        //报表默认
        if (getIntent().getIntExtra("from", 1) == 1) {
            Utils.setBackGround(findViewById(R.id.img), getResources().getDrawable(R.drawable.baobiao_nodata_bg));
        } else if (getIntent().getIntExtra("from", 1) == 2) {
            //报表什么是数据来源人
            Utils.setBackGround(findViewById(R.id.img), getResources().getDrawable(R.drawable.baobiao_nodata_default));
            red_btn.setVisibility(View.VISIBLE);
            red_btn.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Intent intent = new Intent(ProjectGuideActivity.this, UserInfoBrageActivity.class);
                    intent.putExtra("url", NetWorkRequest.EXAPLETABLE);
                    intent.putExtra("title", "示例报表");
                    startActivityForResult(intent, Constance.REQUEST_LOGIN);
                }
            });
        } else if (getIntent().getIntExtra("from", 1) == 3) {
            ImageView imageView = (ImageView) findViewById(R.id.img);
            imageView.setImageResource(R.drawable.synch_manmage_desc);
        }
        red_btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(ProjectGuideActivity.this, X5WebViewActivity.class);
                intent.putExtra("url", NetWorkRequest.EXAPLETABLE);
                intent.putExtra("title", "示例报表");
                startActivityForResult(intent, Constance.REQUEST_LOGIN);
            }
        });
    }
}
