package com.jizhi.jlongg.main.activity.procloud;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.cityslist.widget.ClearEditText;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.db.ProCloudService;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.adpter.FirstLevelMenuFileAdatper;
import com.jizhi.jlongg.main.bean.Cloud;
import com.jizhi.jlongg.main.dialog.DialogOnlyTitle;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.cloud.CloudUtil;

import java.util.ArrayList;
import java.util.List;

/**
 * 功能: 项目云盘-->回收站
 * 时间:2017年7月18日10:02:29
 * 作者:xuj
 */
public class RecycleBinActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 列表数据
     */
    private List<Cloud> list;
    /**
     * 是否在编辑
     */
    private boolean isEditor;
    /**
     * 云盘适配器
     */
    private FirstLevelMenuFileAdatper adapter;
    /**
     * 导航栏右边标题
     */
    private TextView navigationRightTitle;
    /**
     * 导航栏返回布局,底部布局,输入框布局,回收站文本提示
     */
    private View navigationLeftLayout, bottomLayout, inputLayout, recycleTipsText;
    /**
     * 文件父id
     */
    private String parentId;
    /**
     * 模糊搜索框
     */
    private ClearEditText mClearEditText;
    /**
     * 项目组id
     */
    private String groupId;
    /**
     * 全选、取消全选
     */
    private TextView selecteAllOrCancelAllText;
    /**
     * 选择文件数量
     */
    private int selecteCount;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, String groupId, String parentId) {
        Intent intent = new Intent(context, RecycleBinActivity.class);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.FILE_PARENT_ID, parentId);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.recycle_bin);
        initView();
        loadRecycleBinData();
    }

    private void initView() {
        setTextTitle(R.string.recycle_bin);
        parentId = getIntent().getStringExtra(Constance.FILE_PARENT_ID);
        groupId = getIntent().getStringExtra(Constance.GROUP_ID);
        recycleTipsText = findViewById(R.id.recycleTipsText);
        inputLayout = findViewById(R.id.input_layout);
        bottomLayout = findViewById(R.id.bottomLayout);
        mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);

        navigationLeftLayout = findViewById(R.id.lin_back);
        navigationRightTitle = getTextView(R.id.cancelText);

        selecteAllOrCancelAllText = getTextView(R.id.selecteAllOrCancelAllText);
        findViewById(R.id.right_title).setVisibility(View.GONE);//隐藏导航栏右图标
        findViewById(R.id.cancelText).setVisibility(View.VISIBLE); //显示导航栏 取消文字
        getTextView(R.id.defaultDesc).setText("暂无文件");
        navigationRightTitle.setText(R.string.selecte);

        mClearEditText.setHint("输入文件名查找");
        mClearEditText.setImeOptions(EditorInfo.IME_ACTION_SEARCH);
        mClearEditText.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if (actionId == EditorInfo.IME_ACTION_SEARCH) {//按下手机键盘的搜索按钮的时候去 执行搜索的操作
                    searchCloudFiles(mClearEditText.getText().toString());
                }
                return false;
            }
        });

        mClearEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (TextUtils.isEmpty(s.toString())) {
                    if (adapter != null) {
                        adapter.setFilterValue(null);
                        adapter.updateList(list);
                    }
                }
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });
    }


    /**
     * 全选
     */
    private void selecteAll() {
        if (adapter != null && adapter.getCount() > 0) {
            for (Cloud cloud : adapter.getList()) {
                cloud.setSelected(true);
            }
            adapter.notifyDataSetChanged();
            selecteCount = adapter.getList().size();
            setSelecteCount();
        }
    }

    /**
     * 取消全选
     */
    private void cancelSelecteAll() {
        if (adapter != null && adapter.getCount() > 0) {
            for (Cloud cloud : adapter.getList()) {
                cloud.setSelected(false);
            }
            adapter.notifyDataSetChanged();
            selecteCount = 0;
            setSelecteCount();
        }
    }

    private void setSelecteCount() {
        selecteAllOrCancelAllText.setText(selecteCount == adapter.getCount() ? R.string.cancel_check_all : R.string.check_all);
    }

    /**
     * 还原文件
     *
     * @param sourceIds
     */
    private void restoryCloudFiles(String sourceIds) {
        CloudUtil.restoreFiles(this, groupId, WebSocketConstance.TEAM, sourceIds, parentId, new CloudUtil.GetFileListListener() {
            @Override
            public void onSuccess(List<Cloud> list) {
                CommonMethod.makeNoticeLong(getApplicationContext(), "还原文件操作成功", CommonMethod.SUCCESS);
                clickEditor();
                setAdatper(list);
            }

            @Override
            public void onFailure() {

            }
        });
    }

    /**
     * 删除云盘数据
     *
     * @param sourceIds
     */
    private void deleteCloudFiles(final String sourceIds, final List<Cloud> selecteItems) {
        DialogOnlyTitle deleteDialog = new DialogOnlyTitle(this, new DiaLogTitleListener() {
            @Override
            public void clickAccess(int position) {
                CloudUtil.deleteFiles(RecycleBinActivity.this, groupId, WebSocketConstance.TEAM, sourceIds, CloudUtil.DELETE_BIN_FILE, parentId, new CloudUtil.GetFileListListener() {
                    @Override
                    public void onSuccess(List<Cloud> list) {
                        for (Cloud cloud : selecteItems) { //彻底删除之后需要清空已上传了并且id相同的文件
                            ProCloudService.getInstance(getApplicationContext()).deleteFileInfo(getApplicationContext(), cloud.getId(), groupId, CloudUtil.FILE_TYPE_UPLOAD_TAG + ""); //移除数据库数据
                        }
                        CommonMethod.makeNoticeLong(getApplicationContext(), "删除成功", CommonMethod.SUCCESS);
                        clickEditor();
                        setAdatper(list);
                    }

                    @Override
                    public void onFailure() {

                    }
                });
            }
        }, -1, getString(R.string.delete_pro_cloudfile_recycle_tips));
        deleteDialog.show();
    }

    /**
     * 加载回收站数据
     */
    private void loadRecycleBinData() {
        CloudUtil.getCloudDir(this, groupId, WebSocketConstance.TEAM, parentId, true, new CloudUtil.GetFileListListener() {
            @Override
            public void onSuccess(List<Cloud> list) {
                setAdatper(list);
            }

            @Override
            public void onFailure() {

            }
        });
    }

    /**
     * 搜索云盘数据
     *
     * @param fileName 云盘的值
     */
    private void searchCloudFiles(final String fileName) {
        if (adapter == null || adapter.getCount() == 0) {
            return;
        }
        CloudUtil.searchFile(this, fileName, parentId, groupId, true, new CloudUtil.GetFileListListener() {
            @Override
            public void onSuccess(List<Cloud> list) {
                adapter.setFilterValue(mClearEditText.getText().toString());
                adapter.updateList(list);
            }

            @Override
            public void onFailure() {

            }
        });
    }

    private void setAdatper(final List<Cloud> list) {
        this.list = list;
        if (adapter == null) {
            ListView listView = (ListView) findViewById(R.id.listView);
            adapter = new FirstLevelMenuFileAdatper(RecycleBinActivity.this, list);
            listView.setAdapter(adapter);
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    final Cloud bean = adapter.getList().get(position);
                    if (isEditor) { //正在编辑状态下
                        bean.setSelected(!bean.isSelected());
                        adapter.notifyDataSetChanged();
                        selecteCount = bean.isSelected() ? selecteCount + 1 : selecteCount - 1;
                        setSelecteCount();
                    } else {
                        if (bean.getType().equals(CloudUtil.FOLDER_TAG)) { //文件夹
                            RecycleBinActivity.actionStart(RecycleBinActivity.this, groupId, bean.getId());
                        }
                    }
                }
            });
            listView.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() { //长按事件
                @Override
                public boolean onItemLongClick(AdapterView<?> adapterView, View view, int position, long l) {
                    if (adapter != null && adapter.getCount() > 0 && !adapter.isEditor()) {
                        clickEditor();
                        adapter.getList().get(position).setSelected(true);
                        adapter.notifyDataSetChanged();
                    }
                    return false;
                }
            });
        } else {
            adapter.updateList(list);
        }
    }


    /**
     * 取消文件编辑状态
     */
    private void cancelEditorState() {
        navigationRightTitle.setText(R.string.selecte);
        navigationLeftLayout.setVisibility(View.VISIBLE);
        selecteAllOrCancelAllText.setVisibility(View.GONE);
        recycleTipsText.setVisibility(View.VISIBLE);
        inputLayout.setVisibility(View.VISIBLE);
        bottomLayout.setVisibility(View.GONE);
        adapter.setEditor(false);
        adapter.notifyDataSetChanged();
    }

    /**
     * 显示文件编辑状态
     */
    private void showEditorState() {
        clearFilesSelectedState();
        navigationRightTitle.setText(R.string.cancel);
        selecteAllOrCancelAllText.setVisibility(View.VISIBLE);
        bottomLayout.setVisibility(View.VISIBLE);
        recycleTipsText.setVisibility(View.GONE);
        inputLayout.setVisibility(View.GONE);
        navigationLeftLayout.setVisibility(View.GONE);
        adapter.setEditor(true);
        adapter.notifyDataSetChanged();
    }

    /**
     * 清空文件选中状态
     *
     * @return
     */
    public void clearFilesSelectedState() {
        if (adapter != null && adapter.getCount() > 0) {
            for (Cloud cloud : adapter.getList()) {
                if (cloud.isSelected()) {
                    cloud.setSelected(false);
                }
            }
        }
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        switch (id) {
            case R.id.cancelText: //取消
                clickEditor();
                break;
            case R.id.selecteAllOrCancelAllText: //取消全选、全选按钮
                if (adapter == null || adapter.getCount() == 0) {
                    return;
                }
                if (selecteCount == adapter.getList().size()) { //现在是全选状态
                    cancelSelecteAll();
                } else {
                    selecteAll();
                }
                break;
            case R.id.restoreText: //还原文件
            case R.id.deleteText: //彻底删除按钮
                if (adapter == null || adapter.getCount() == 0) {
                    return;
                }
                List<Cloud> selecteList = new ArrayList<>();
                for (Cloud cloud : adapter.getList()) {
                    if (cloud.isSelected()) {
                        selecteList.add(cloud);
                    }
                }
                if (selecteList.size() == 0) {
                    return;
                }
                String sourceIds = new Gson().toJson(selecteList);
                if (id == R.id.restoreText) { //恢复文件
                    restoryCloudFiles(sourceIds);
                } else if (id == R.id.deleteText) { //彻底删除
                    deleteCloudFiles(sourceIds, selecteList);
                }
                break;
        }
    }

    private void clickEditor() {
        if (adapter == null || adapter.getCount() == 0) {
            return;
        }
        isEditor = !isEditor;
        if (isEditor) { //当前正在编辑文件
            showEditorState();
        } else { //取消编辑
            cancelEditorState();
        }
    }

    @Override
    public void onBackPressed() {
        if (adapter != null && adapter.isEditor()) {
            cancelEditorState();
            return;
        }
        super.onBackPressed();
    }

}
