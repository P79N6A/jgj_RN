package com.jizhi.jlongg.main.dialog;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.custom.ButtonTouchChangeAlpha;

/**
 * 修改昵称Dialog
 * @author Xuj
 * @time 2016年1月28日 15:11:15
 * @Version 1.0
 */
public class NicknameDialog extends Dialog implements android.view.View.OnClickListener {
	private RelativeLayout uploading_headimage;
	private ImageView headimage;
	private EditText nickname;
	private ButtonTouchChangeAlpha submit;
	private CallBackChooseChef listener;
	private Context context;
	private PopupWindow popup;

	public NicknameDialog(Context context,CallBackChooseChef listener) {
		super(context);
		this.context = context;
		this.listener = listener;
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.supplement_nickname);
		intiView();
	}

	private void intiView() {
		uploading_headimage = (RelativeLayout) findViewById(R.id.uploading_headimage);
		headimage = (ImageView) findViewById(R.id.headimage);
		nickname = (EditText) findViewById(R.id.nickname);
//		submit = (ButtonTouchChangeAlpha) findViewById(R.id.submit);
		uploading_headimage.setOnClickListener(this);
		submit.setOnClickListener(this);
	}

	@Override
	public void onClick(View view) {
		String nickn = nickname.getText().toString();
		switch(view.getId()){
		case R.id.uploading_headimage:
			break;
		case R.id.submit:
			listener.callChoose(nickn, "");
			break;
		}
	}
	public interface CallBackChooseChef{
		void callChoose(String nickname, String url);
	}
	
}
