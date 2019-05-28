package com.jizhi.jlongg.main.activity;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.jizhi.jlongg.R;

public class AuthenticationActivity extends BaseActivity implements View.OnClickListener {
    private EditText ed_name, ed_number;
    private RelativeLayout rea_front, rea_back;
    private Button btn_submit;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_authentication);
        initView();
    }

    /**
     * 初始化View
     */
    public void initView() {
        ed_name = (EditText) findViewById(R.id.ed_name);
        ed_number = (EditText) findViewById(R.id.ed_number);
        rea_front = (RelativeLayout) findViewById(R.id.rea_front);
        rea_back = (RelativeLayout) findViewById(R.id.rea_back);
        btn_submit = (Button) findViewById(R.id.btn_submit);
        rea_front.setOnClickListener(this);
        rea_back.setOnClickListener(this);
        btn_submit.setOnClickListener(this);


    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.rea_front:
                Toast.makeText(AuthenticationActivity.this, "click photo to front", Toast.LENGTH_LONG).show();
                break;
            case R.id.rea_back:
                Toast.makeText(AuthenticationActivity.this, "click photo to back", Toast.LENGTH_LONG).show();
                break;
            case R.id.btn_submit:

                if (TextUtils.isEmpty(ed_name.getText().toString().toString())) {
                    Toast.makeText(AuthenticationActivity.this, "请输入姓名", Toast.LENGTH_LONG).show();
                    return;
                }
                if (TextUtils.isEmpty(ed_number.getText().toString().toString())) {
                    Toast.makeText(AuthenticationActivity.this, "请输入身份证号码", Toast.LENGTH_LONG).show();
                    return;
                }
                if (ed_number.getText().toString().toString().length() < 18) {
                    Toast.makeText(AuthenticationActivity.this, "身份证号码输入错误", Toast.LENGTH_LONG).show();
                    return;
                }
                Toast.makeText(AuthenticationActivity.this, "submit is ok", Toast.LENGTH_LONG).show();
                break;

        }
    }
}
