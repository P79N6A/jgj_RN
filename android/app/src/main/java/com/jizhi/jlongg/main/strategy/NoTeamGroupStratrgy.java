package com.jizhi.jlongg.main.strategy;

import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;

import com.google.zxing.client.android.scanner.CaptureActivity;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.CreateTeamGroupActivity;
import com.jizhi.jlongg.main.util.IsSupplementary;

/**
 * 班组、项目组策略
 *
 * @author Xuj
 * @time 2018年6月19日14:29:38
 * @Version 1.0
 */
public class NoTeamGroupStratrgy extends MainStrategy implements View.OnClickListener {


    /**
     * activity
     */
    private BaseActivity activity;


    public NoTeamGroupStratrgy(BaseActivity activity) {
        this.activity = activity;
    }


    @Override
    public View getView(LayoutInflater inflater) {
        View convertView = inflater.inflate(R.layout.new_work_circle_no_data, null, false);
        setView(convertView);
        return convertView;
    }

    @Override
    void setView(View convertView) {
        TextView desc1 = (TextView) convertView.findViewById(R.id.desc1);
        desc1.setText(Html.fromHtml("<font color='#999999'>点击右上角</font><font color='#eb4e4e'> \"+\" </font><font color='#999999'>按钮即可</font>"));
        View.OnClickListener onClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                switch (view.getId()) {
                    case R.id.unLoginScanCodeText: //扫描二维码
                        if (!IsSupplementary.isFillRealNameIntentActivity(activity, false, CaptureActivity.class)) {
                            return;
                        }
                        break;
                    case R.id.unLoginCreateTeam: //创建班组
                        if (!IsSupplementary.isFillRealNameIntentActivity(activity, false, CreateTeamGroupActivity.class)) {
                            return;
                        }
                        break;
                }
            }
        };
        convertView.findViewById(R.id.unLoginCreateTeam).setOnClickListener(onClickListener);
        convertView.findViewById(R.id.unLoginScanCodeText).setOnClickListener(onClickListener);
    }

    @Override
    public void bindData(Object object, View convertView, int position) {

    }

    @Override
    public void onClick(View v) {

    }
}
