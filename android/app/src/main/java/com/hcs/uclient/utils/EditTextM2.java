package com.hcs.uclient.utils;

import android.app.Activity;
import android.text.Editable;
import android.text.TextWatcher;
import android.widget.EditText;
import android.widget.TextView;

/**
 * Created by hcs on 2016/5/23.
 */
public class EditTextM2 {

    private EditText edit_text;
    private Activity activity;
    private int length;
    private TextView salary;
    private CalcPriceListener calcPriceListener;

    public EditTextM2(final EditText edit_text, final int length, final CalcPriceListener calcPriceListener) {
        this.edit_text = edit_text;
        this.length = length;
        this.calcPriceListener = calcPriceListener;
        edit_text.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                //限制只能输入一个小数点
                if (edit_text.getText().toString().indexOf(".") >= 0) {
                    if (edit_text.getText().toString().indexOf(".") == 0) {
                        edit_text.setText("");
                    } else if (edit_text.getText().toString().indexOf(".", edit_text.getText().toString().indexOf(".") + 1) > 0) {
                        edit_text.setText(edit_text.getText().toString().substring(0, edit_text.getText().toString().length() - 1));
                        edit_text.setSelection(edit_text.getText().toString().length());
                    }

                }
            }

            @Override
            public void afterTextChanged(Editable editable) {
                //小数点后面保存length位数
                String temp = editable.toString();
                int posDot = temp.indexOf(".");
                if (posDot > 0) {
                    if (temp.length() - posDot - 1 > length) {
                        editable.delete(posDot + 1 + length, posDot + 2 + length);
                    }
                }
                calcPriceListener.CalcPrice();
            }
        });
    }

    public interface CalcPriceListener {
        void CalcPrice();
    }
}
