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

import com.hcs.uclient.utils.StrUtil;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;

import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * 功能:免费版超过最大人数和云盘免费使用的限制
 * 时间:2017年8月7日10:10:12
 * 作者:xuj
 */
public class DialogMoreThanFreeCount extends Dialog implements View.OnClickListener {


    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

    public DialogMoreThanFreeCount(BaseActivity activity) {
        super(activity, R.style.network_dialog_style);
        createLayout(activity);
        commendAttribute(true);
    }


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final Activity activity) {
        setContentView(R.layout.dialog_more_than_free_count);
        TextView tipContent = (TextView) findViewById(R.id.content);
        String content = StrUtil.ToDBC(StrUtil.StringFilter("免费版的使用人数不能超过5人,且云盘空间不能超过2G,如需使用免费版,请进入[项目设置]中将成员人数降到≤5人,并从云盘中将文件删除到≤2G"));
        Pattern p = Pattern.compile("[项目设置]");
        SpannableString builder = new SpannableString(content);
        Matcher nameMatch = p.matcher(content);
        while (nameMatch.find()) {
            ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#eb4e4e"));
            builder.setSpan(redSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
        }
        tipContent.setText(builder);
        findViewById(R.id.redBtn).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        dismiss();
    }
}
