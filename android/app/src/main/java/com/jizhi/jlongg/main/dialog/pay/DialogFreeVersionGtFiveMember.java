package com.jizhi.jlongg.main.dialog.pay;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.graphics.Color;
import android.os.Build;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.style.ForegroundColorSpan;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;

import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * 功能:项目组成员数大于5人
 * 时间:2017年8月7日10:10:12
 * 作者:xuj
 */
public class DialogFreeVersionGtFiveMember extends Dialog implements View.OnClickListener {


    private Activity activity;

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

    public DialogFreeVersionGtFiveMember(Activity activity) {
        super(activity, R.style.network_dialog_style);
        this.activity = activity;
        createLayout(activity);
        commendAttribute(true);
    }


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final Activity activity) {
        setContentView(R.layout.dialog_gt_five_member);
        TextView tipsContent = (TextView) findViewById(R.id.content);
        String content = "免费版的使用人数不能超过5人，如需使用免费版，请进入[项目设置]模块中将成员人数降到≤5人。";
        Pattern p = Pattern.compile("[项目设置]");
        SpannableString builder = new SpannableString(content);
        Matcher nameMatch = p.matcher(content);
        while (nameMatch.find()) {
            ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#eb4e4e"));
            builder.setSpan(redSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
        }
        tipsContent.setText(builder);
        findViewById(R.id.redBtn).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        dismiss();
    }
}
