package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.InputFilter;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.ContextMenu;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.RepositoryDownLoadAdapter;
import com.jizhi.jlongg.main.bean.Repository;
import com.jizhi.jlongg.main.dialog.DialogTips;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RepositoryUtil;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;


/**
 * 知识库，下载管理
 *
 * @author Xuj
 * @time 2018年7月17日10:05:18
 * @Version 1.0
 */
public class RepositoryDownLoadActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 适配器
     */
    private RepositoryDownLoadAdapter adapter;
    /**
     * 列表数据
     */
    private ArrayList<Repository> repositorys;
    /**
     * 编辑按钮状态
     */
    private TextView editorText;
    /**
     * 搜索文本框
     */
    private String matchString;
    /**
     * 文本搜索框
     */
    private ClearEditText clearEditText;
    /**
     * 删除按钮
     */
    private Button deleteBtn;
    /**
     * 输入框布局,删除布局
     */
    private View inputLayout, deleteLayout;
    /**
     * 全选按钮,返回按钮
     */
    private TextView selecteAllOrCancelAllText, returnText;
    /**
     * 长按事件点击的下标
     */
    private int longClickPostion;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.repository_download);
        initView();
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, RepositoryDownLoadActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    private void initView() {
        setTextTitleAndRight(R.string.download_repository, R.string.delete);
        deleteBtn = getButton(R.id.red_btn);
        deleteLayout = findViewById(R.id.bottom_layout);
        inputLayout = findViewById(R.id.input_layout);
        returnText = getTextView(R.id.returnText);
        selecteAllOrCancelAllText = getTextView(R.id.selecteAllOrCancelAllText);
        deleteBtn.setText("从本机删除");
        editorText = getTextView(R.id.right_title);
        clearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        clearEditText.setHint("请输入文档名称进行搜索");
        clearEditText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(20)});
        clearEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                filterData(s.toString());
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
        deleteLayout.setVisibility(View.GONE);
        setAdapter();
        btnUnClick();
    }

    private void btnUnClick() {
        deleteBtn.setClickable(false);
        Utils.setBackGround(deleteBtn, getResources().getDrawable(R.drawable.draw_dis_app_btncolor_5radius));
    }

    private void btnClick() {
        deleteBtn.setClickable(true);
        Utils.setBackGround(deleteBtn, getResources().getDrawable(R.drawable.draw_app_btncolor_5radius));
    }


    private void setAdapter() {
        repositorys = getData();
        editorText.setVisibility(repositorys == null || repositorys.size() == 0 ? View.GONE : View.VISIBLE);
        findViewById(R.id.defaultLayout).setVisibility(repositorys == null || repositorys.size() == 0 ? View.VISIBLE : View.GONE);
        if (adapter == null) {
            final ListView listView = (ListView) findViewById(R.id.listView);
            adapter = new RepositoryDownLoadAdapter(RepositoryDownLoadActivity.this, repositorys);
            listView.setAdapter(adapter);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    Repository repository = adapter.getList().get(position);
                    if (adapter.isEditor()) { //编辑状态下 自动切换状态
                        repository.setIs_selected(!repository.isIs_selected());
                        adapter.notifyDataSetChanged();
                        if (isSelecteRepository()) {
                            btnClick();
                        } else {
                            btnUnClick();
                        }
                        checkIsSelecteAll();
                    } else {
                        RepositoryUtil.openDownloadFile(RepositoryDownLoadActivity.this, repository.getFile_path(),
                                repository.getFile_name() + "." + repository.getFile_type(), repository);
                    }
                }
            });
            listView.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
                @Override
                public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
                    longClickPostion = position;
                    return false;
                }
            });
            listView.setOnCreateContextMenuListener(new View.OnCreateContextMenuListener() {
                public void onCreateContextMenu(ContextMenu menu, View v, ContextMenu.ContextMenuInfo menuInfo) {
                    menu.add(0, Menu.FIRST, 0, "删除");
                }
            });
        } else {
            adapter.updateList(repositorys);
        }
    }


    private boolean isSelecteRepository() {
        if (adapter == null || adapter.getCount() == 0) {
            return false;
        }
        for (Repository repository : adapter.getList()) {
            if (repository.isIs_selected()) {
                return true;
            }
        }
        return false;
    }


    /**
     * 搜索框 筛选数据
     *
     * @param mMatchString
     */
    private synchronized void filterData(final String mMatchString) {
        if (adapter == null || repositorys == null || repositorys.size() == 0) {
            return;
        }
        matchString = mMatchString;
        new Thread(new Runnable() {
            @Override
            public void run() {
                final List<Repository> filterDataList = SearchMatchingUtil.match(Repository.class, repositorys, matchString);
                if (mMatchString.equals(matchString)) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            adapter.setFilterValue(mMatchString);
                            adapter.updateListView(filterDataList);
                        }
                    });
                }
            }
        }).start();
    }

    /**
     * 获取已下载的知识库数据
     */
    private ArrayList<Repository> getData() {
        String downLoadPath = RepositoryUtil.FILE_DOWNLOADED_FLODER;
        File fileDirectory = new File(downLoadPath);
        if (!fileDirectory.exists()) {
            return null;
        }
        File[] files = fileDirectory.listFiles();
        if (files == null || files.length == 0) {
            return null;
        }
        ArrayList<Repository> repositories = new ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar calen = Calendar.getInstance();
        //这里因为要倒叙所以我们倒着循环
        for (int i = files.length - 1; i >= 0; i--) {
            File listFiles = files[i];
            String fileName = listFiles.getName(); //文件名称,包含了后缀名的
            String fileType = getFileType(fileName); //文件后缀名
            String filePath = listFiles.getAbsolutePath(); //文件路径
            calen.setTimeInMillis(listFiles.lastModified());
            switch (fileType) {
                case ".doc":
                case ".docx":
                case ".xls":
                case ".xlsx":
                case ".pdf":
                    repositories.add(new Repository(getFileName(fileName), filePath, sdf.format(calen.getTime()), fileType, false));
                    break;
            }
        }
        return repositories;
    }

    /**
     * 获取文件后缀名
     *
     * @param fileName
     * @return
     */
    private String getFileType(String fileName) {
        return fileName.substring(fileName.lastIndexOf("."));
    }

    /**
     * 获取文件名称并且未带有后缀名
     *
     * @param fileName
     * @return
     */
    private String getFileName(String fileName) {
        return fileName.substring(0, fileName.lastIndexOf("."));
    }

    /**
     * 删除资料库文件
     *
     * @param filePath
     */
    private void deleteRepositoryFile(String filePath) {
        if (TextUtils.isEmpty(filePath)) {
            return;
        }
        File file = new File(filePath);
        if (file.exists() && file.isFile()) {
            file.delete();
        }
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.selecteAllOrCancelAllText:
                selecteOrCancalAll(!checkIsSelecteAll());
                break;
            case R.id.red_btn:
                if (adapter == null || adapter.getCount() == 0) {
                    return;
                }
                DialogTips dialogTips = new DialogTips(this, new DiaLogTitleListener() {
                    @Override
                    public void clickAccess(int position) {
                        for (Repository repository : repositorys) {
                            if (repository.isIs_selected()) {
                                deleteRepositoryFile(repository.getFile_path());
                            }
                        }
                        //清空已经输入的搜索内容
                        clearEditText.setText("");
                        matchString = null;
                        adapter.setEditor(false);
                        editorText.setText(adapter.isEditor() ? R.string.cancel : R.string.delete);
                        selecteAllOrCancelAllText.setVisibility(View.GONE);
                        returnText.setVisibility(View.VISIBLE);
                        setAdapter();
                    }
                }, "您确定要删除所选资料吗？", -1);
                dialogTips.setContentCenterGravity();
                dialogTips.show();
                break;
            case R.id.right_title: //取消编辑状态
                if (adapter == null || adapter.getCount() == 0) {
                    return;
                }
                boolean isEditor = adapter.isEditor();
                if (!isEditor) {
                    selecteAllOrCancelAllText.setText("全选");
                    //清空之前已选中的文件状态
                    for (Repository repository : adapter.getList()) {
                        if (repository.isIs_selected()) {
                            repository.setIs_selected(false);
                        }
                    }
                }
                adapter.setEditor(!isEditor);
                isEditor = adapter.isEditor();
                inputLayout.setVisibility(isEditor ? View.GONE : View.VISIBLE);
                selecteAllOrCancelAllText.setVisibility(isEditor ? View.VISIBLE : View.GONE);
                returnText.setVisibility(isEditor ? View.GONE : View.VISIBLE);
                editorText.setText(isEditor ? R.string.cancel : R.string.delete);
                deleteLayout.setVisibility(isEditor ? View.VISIBLE : View.GONE);
                adapter.notifyDataSetChanged();
                break;
        }
    }

    /**
     * 全选或取消全选
     *
     * @param isSelecteAll true 表示全部选中 false反之
     */
    private void selecteOrCancalAll(boolean isSelecteAll) {
        if (adapter == null || adapter.getCount() == 0) {
            return;
        }
        for (Repository repository : repositorys) {
            repository.setIs_selected(isSelecteAll ? true : false);
        }
        selecteAllOrCancelAllText.setText(isSelecteAll ? "全不选" : "全选");
        if (isSelecteAll) {
            btnClick();
        } else {
            btnUnClick();
        }
        adapter.notifyDataSetChanged();
    }


    /**
     * 是否已选择了全部的数据
     *
     * @return
     */
    private boolean checkIsSelecteAll() {
        if (adapter == null || adapter.getCount() == 0) {
            return false;
        }
        int count = 0;
        for (Repository repository : repositorys) {
            if (repository.isIs_selected()) {
                count++;
            }
        }
        selecteAllOrCancelAllText.setText(count == repositorys.size() ? "全不选" : "全选");
        return count == repositorys.size() ? true : false;
    }

    @Override
    public boolean onContextItemSelected(MenuItem item) {
        //参数为用户选择的菜单选项对象
        //根据菜单选项的id来执行相应的功能
        switch (item.getItemId()) {
            case Menu.FIRST: //长按删除单条 知识库信息
                DialogTips dialogTips = new DialogTips(this, new DiaLogTitleListener() {
                    @Override
                    public void clickAccess(int position) {
                        Repository repository = adapter.getList().get(longClickPostion);
                        deleteRepositoryFile(repository.getFile_path());
                        setAdapter();
                    }
                }, "您确定要删除该资料吗？", -1);
                dialogTips.setContentCenterGravity();
                dialogTips.show();
                break;
        }
        return super.onOptionsItemSelected(item);
    }

}