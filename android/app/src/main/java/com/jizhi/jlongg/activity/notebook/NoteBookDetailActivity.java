package com.jizhi.jlongg.activity.notebook;

import android.app.Activity;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.CheckHistoryImageAdapter;
import com.jizhi.jlongg.main.bean.NoteBook;
import com.jizhi.jlongg.main.bean.UserInfo;
import com.jizhi.jlongg.main.dialog.DialogNoteBookMore;
import com.jizhi.jlongg.main.dialog.DialogTips;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.message.MessageImagePagerActivity;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 功能:记录记详情
 * 时间:2018/4/18 20.08
 * 作者:hcs
 */

public class NoteBookDetailActivity extends BaseActivity {
    private NoteBookDetailActivity mActivity;
    private NoteBook noteBook;
    private TextView isImportantText;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_notebook_detail);
        initView();
        initRightTitle();
        NoteBookDetail();
    }


    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, NoteBook noteBook) {
        Intent intent = new Intent(context, NoteBookDetailActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, noteBook);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 初始化View
     */
    public void initView() {
        mActivity = NoteBookDetailActivity.this;
        noteBook = (NoteBook) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        isImportantText = findViewById(R.id.is_important_text);
        initImporant();
        //设置日期
        if (null != noteBook && !TextUtils.isEmpty(noteBook.getPublish_time())) {
            if (!TextUtils.isEmpty(noteBook.getWeekday())) {
                SetTitleName.setTitle(findViewById(R.id.title), getDateStr(noteBook.getPublish_time()) + " " + noteBook.getWeekday());
            } else {
                SetTitleName.setTitle(findViewById(R.id.title), getDateStr(noteBook.getPublish_time()));
            }
        }
        ((TextView) findViewById(R.id.right_title)).setText("删除");
        findViewById(R.id.btn_edie).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                SaveNoteBookActivity.actionStart(mActivity, noteBook);
            }
        });
        isImportantText.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (noteBook.getIs_import() == 0) {
                    putNoteBook();
                    return;
                }
                new DialogTips(mActivity, new DiaLogTitleListener() {
                    @Override
                    public void clickAccess(int position) {
                        if (null != noteBook) {
                            putNoteBook();
                        }
                    }
                }, "该记事本内容是标记为重要的，确认要取消标记为重要吗？", DialogTips.CLOSE_TEAM,"确认").show();


            }
        });
    }

    public void initRightTitle() {
        findViewById(R.id.right_title).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new DialogTips(mActivity, new DiaLogTitleListener() {
                    @Override
                    public void clickAccess(int position) {
                        if (null != noteBook) {
                            delNoteBook();
                        }
                    }
                }, noteBook.getIs_import() == 1 ? "该条记录已标记为重要，删除后不能找回，确认删除该记录吗？" : "是否确认删除该记录？", DialogTips.CLOSE_TEAM,"确认").show();
            }

        });


    }

    /**
     * 更新记事本单条记录
     */
    public void putNoteBook() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("id", noteBook.getId());
        params.addBodyParameter("is_import", noteBook.getIs_import() == 1 ? "0" : "1");
        CommonHttpRequest.commonRequest(this, NetWorkRequest.PUR_NOTEBOOK, UserInfo.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                noteBook.setIs_import(noteBook.getIs_import() == 1 ? 0 : 1);
                initImporant();
                Intent intent = new Intent(WebSocketConstance.FLUSH_NOTEBOOK);
                LocalBroadcastManager.getInstance(mActivity).sendBroadcast(intent);
            }


            @Override
            public void onFailure(HttpException exception, String errormsg) {
                closeDialog();

            }
        });
    }

    /**
     * 设置标记状态
     */
    private void initImporant() {
        isImportantText.setTextColor(ContextCompat.getColor(getApplicationContext(), noteBook.getIs_import() == 1 ? R.color.color_ff6600 : R.color.color_333333));
        isImportantText.setText(noteBook.getIs_import() == 1 ? "重要" : "标记为重要");
        Drawable mClearDrawable = getResources().getDrawable(noteBook.getIs_import() == 1 ? R.drawable.publish_notes_imporant : R.drawable.publish_notes_no_imporant);
        mClearDrawable.setBounds(0, 0, mClearDrawable.getIntrinsicWidth(), mClearDrawable.getIntrinsicHeight()); //设置清除的图片
        isImportantText.setCompoundDrawables(mClearDrawable, null, null, null);
    }

    /**
     * 记事本详情
     */
    public void NoteBookDetail() {
        String httpUrl = NetWorkRequest.NOTEBOOK_DETAIL;
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("id", noteBook.getId());
        CommonHttpRequest.commonRequest(this, httpUrl, NoteBook.class, CommonHttpRequest.OBJECT, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                //
                noteBook = (NoteBook) object;
                ((TextView) findViewById(R.id.tv_content)).setText(noteBook.getContent());
                if (null != noteBook.getImages() && noteBook.getImages().size() > 0) {
                    CheckHistoryImageAdapter squaredImageAdapter = new CheckHistoryImageAdapter(mActivity, noteBook.getImages());
                    GridView gridView = findViewById(R.id.wrap_grid);
                    gridView.setAdapter(squaredImageAdapter);
                    gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                        @Override
                        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                            ImageView image = view.findViewById(R.id.image);
                            MessageImagePagerActivity.ImageSize imageSize = new MessageImagePagerActivity.ImageSize(image.getMeasuredWidth(), image.getMeasuredHeight());
                            MessageImagePagerActivity.startImagePagerActivity(mActivity, noteBook.getImages(), position, imageSize);
                        }
                    });
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    public String getDateStr(String strDate) {
        String newStr = "";
        try {
            SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy年MM月dd日");
            Date date = sdf1.parse(strDate);//提取格式中的日期
            newStr = sdf2.format(date); //改变格式
        } catch (ParseException e) {
            e.printStackTrace();
        }

        return newStr;
    }


    /**
     * 删除记事本单条记录
     */
    public void delNoteBook() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("id", noteBook.getId());
        String httpUrl = NetWorkRequest.NOTEBOOK_DELETE;
        CommonHttpRequest.commonRequest(this, httpUrl, UserInfo.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                Intent intent = new Intent(WebSocketConstance.FLUSH_NOTEBOOK);
                LocalBroadcastManager.getInstance(mActivity).sendBroadcast(intent);
                //
                setResult(Constance.REQUEST);
                finish();

            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUEST && resultCode == Constance.REQUEST) {
            Intent intent = new Intent(WebSocketConstance.FLUSH_NOTEBOOK);
            LocalBroadcastManager.getInstance(mActivity).sendBroadcast(intent);
            finish();
        }
    }
}
