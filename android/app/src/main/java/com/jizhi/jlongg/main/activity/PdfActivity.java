package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import com.github.barteksc.pdfviewer.PDFView;
import com.github.barteksc.pdfviewer.listener.OnPageChangeListener;
import com.hcs.uclient.utils.StrUtil;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Repository;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RepositoryUtil;
import com.jizhi.jlongg.main.util.ShareUtil;
import com.umeng.analytics.MobclickAgent;

import java.io.File;


/**
 * 展示PDF
 *
 * @author Xuj
 * @time 2017年4月11日15:39:55
 * @Version 1.0
 */
public class PdfActivity extends BaseActivity implements View.OnClickListener {
    /**
     * pdf View
     */
    private PDFView pdfView;
    /**
     * 文本
     */
    private TextView pageNumTxt;
    /**
     * 知识库文件信息
     */
    private Repository repository;
    /**
     * 收藏文本
     */
    private TextView collectionTxt;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.pdf_view);
        collectionTxt = (TextView) findViewById(R.id.collection);
        pdfView = (PDFView) findViewById(R.id.pdfView);
        pageNumTxt = (TextView) findViewById(R.id.pageNum);
        Intent intent = getIntent();
        String pdfPath = intent.getStringExtra("param1");
        String pdfName = intent.getStringExtra("param2");
        repository = (Repository) intent.getSerializableExtra("param3");
        collectionTxt.setVisibility(repository.isIs_show_collection_btn() ? View.VISIBLE : View.GONE);
        collectionTxt.setText(repository.getIs_collection() == 1 ? "取消收藏" : "收藏");
        getTextView(R.id.title).setText(StrUtil.ToDBC(StrUtil.StringFilter(pdfName)));
        displayPDF(pdfPath);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     * @param pdfName    pdf名称
     * @param pdfPath    pdf路径
     * @param repository 知识库文件信息
     */
    public static void actionStart(Activity context, String pdfPath, String pdfName, Repository repository) {
        Intent intent = new Intent(context, PdfActivity.class);
        intent.putExtra("param1", pdfPath);
        intent.putExtra("param2", pdfName);
        intent.putExtra("param3", repository);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 显示PDF文件
     *
     * @param pdfPath 文件路径
     */
    private void displayPDF(String pdfPath) {
        File file = new File(pdfPath);
        pdfView.fromFile(file)
                .enableSwipe(true) //是否允许翻页，默认是允许翻页
                .defaultPage(0) //设置默认显示第1页
//                .showMinimap(false)     //pdf放大的时候，是否在屏幕的右上角生成小地图
                .swipeHorizontal(false)//pdf文档翻页是否是垂直翻页，默认是左右滑动翻页
                .onPageChange(new OnPageChangeListener() {
                    @Override
                    public void onPageChanged(int page, int pageCount) {
                        page += 1; //page是从0开始的 我们这里需要+1
                        pageNumTxt.setText(page + " / " + pageCount);
                    }
                })
                .enableAntialiasing(true)
                .enableAnnotationRendering(true)
                .load();
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.collection: //收藏、取消收藏
                RepositoryUtil.collectionOrCancel(repository, this, new RepositoryUtil.CollectionListener() {
                    @Override
                    public void collection() {
                        collectionTxt.setText(repository.getIs_collection() == 1 ? "取消收藏" : "收藏");
                    }
                });
                break;
            case R.id.share: //分享
                MobclickAgent.onEvent(this, "share_repository"); //U盟点击分享统计
                ShareUtil.shareFile(new File(getIntent().getExtras().getString("param1")), this);
                break;
        }
    }


    @Override
    public void onFinish(View view) {
        Intent intent = getIntent();
        intent.putExtra("param1", repository.getIs_collection());
        setResult(RepositoryUtil.READ_DOC_RETURN, intent);
        super.onFinish(view);
    }

    @Override
    public void onBackPressed() {
        Intent intent = getIntent();
        intent.putExtra("param1", repository.getIs_collection());
        setResult(RepositoryUtil.READ_DOC_RETURN, intent);
        super.onBackPressed();
    }
}
