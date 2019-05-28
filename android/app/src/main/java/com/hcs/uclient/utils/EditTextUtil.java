package com.hcs.uclient.utils;

import android.content.Context;
import android.text.Editable;
import android.text.Selection;
import android.text.Spannable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.TextView;

import com.jizhi.jlongg.main.util.CommonMethod;

/**
 * 功能:
 * 作者：Xuj
 * 时间: 2016-4-7 10:16
 */
public class EditTextUtil implements TextWatcher {

    private Context context;

    private EditText editext;

    private TextView text;

    public EditTextUtil(Context context, EditText editext) {
        this.context = context;
        this.editext = editext;
    }

    public EditTextUtil(Context context, EditText editext, TextView text) {
        this.context = context;
        this.editext = editext;
        this.text = text;
    }

    /**
     * EditText 光标至于 最后一位
     */
    public void cursorEnd(EditText editext) {
        CharSequence text = editext.getText();
        //Debug.asserts(text instanceof Spannable);
        if (text instanceof Spannable) {
            Spannable spanText = (Spannable) text;
            Selection.setSelection(spanText, text.length());
        }
    }

    /**
     * EditText 光标至于 最后一位
     */
    public static void showKeyBoarad(EditText editText) {
        editText.setFocusable(true);
        editText.setFocusableInTouchMode(true);
        editText.requestFocus();
        InputMethodManager inputManager =
                (InputMethodManager) editText.getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
        inputManager.showSoftInput(editText, 0);
    }

    public void beforeTextChanged(CharSequence s, int start, int count, int after) {

    }

    @Override
    public void onTextChanged(CharSequence s, int start, int before, int count) {
        String temp = s.toString();
        if (TextUtils.isEmpty(temp)) { //输入文字不为null 或者""
            if (text != null) {
                if (text.getVisibility() == View.GONE) {
                    text.setVisibility(View.VISIBLE);
                }
            }
            return;
        }
        if (temp.startsWith(".") || temp.startsWith("0")) {
            CommonMethod.makeNoticeShort(context, "首位不能出现小数点或0!", CommonMethod.ERROR);
            editext.setText(null);
            return;
        }
        int index = temp.indexOf(".");
        if (index > 0) {
            boolean access = true;
            if (index != temp.lastIndexOf(".")) { //不能出现2位小数点
                access = false;
            }
            if ((temp.length() - 1) - index > 2) { //保留小数点两位
                CommonMethod.makeNoticeShort(context, "只能输入2位小数!", CommonMethod.ERROR);
                access = false;
            }
            if (!access) {
                editext.setText(temp.substring(0, temp.length() - 1));
                cursorEnd(editext);
                return;
            }
        }
        if (text != null) {
            if (text.getVisibility() == View.VISIBLE) {
                text.setVisibility(View.GONE);
            }
        }
    }

    @Override
    public void afterTextChanged(Editable s) {
    }
}
