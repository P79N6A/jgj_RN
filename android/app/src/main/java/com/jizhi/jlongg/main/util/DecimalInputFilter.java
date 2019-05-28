package com.jizhi.jlongg.main.util;

/**
 * Created by Administrator on 2017/8/4 0004.
 */

import android.text.InputFilter;
import android.text.Spanned;
import android.text.TextUtils;

public class DecimalInputFilter implements InputFilter {

    private String mRegularExpression;

    public DecimalInputFilter() {
        this(5);
    }

    public DecimalInputFilter(int firstLength) {
        this(firstLength, 2);
    }

    public DecimalInputFilter(int firstLength, int lastLength) {
        mRegularExpression = String.format("(\\d{0,%d}(\\.\\d{0,%d})?)", firstLength, lastLength);
    }
    public DecimalInputFilter(int firstLength, int lastLength,boolean a) {
        mRegularExpression = String.format("((\\-|\\+?)\\d{0,%d}(\\.\\d{0,%d})?)", firstLength, lastLength);
    }

    @Override
    public CharSequence filter(CharSequence source, int start, int end, Spanned dest, int dstart, int dend) {

        boolean delete = false;
        StringBuilder builder = new StringBuilder(dest);

        if (TextUtils.isEmpty(source)) {
            delete = true;
            builder.delete(dstart, dend);
        } else {
            builder.insert(dstart, source);
        }

        String value = builder.toString();

        return value.matches(mRegularExpression) ? null : delete ? "." : "";
    }
}