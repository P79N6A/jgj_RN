package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.SelectProjectAdapter;
import com.jizhi.jlongg.main.bean.BaseNetNewBean;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.dialog.DialogCreateSameGroupName;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import java.util.regex.Pattern;

/**
 * 新建班组、所选项目Dialog
 *
 * @author Xuj
 * @date 2016年8月30日 17:23:36
 */
public class ProjectListActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 项目列表适配器
     */
    private SelectProjectAdapter adapter;
    /**
     * 项目列表数据
     */
    private ArrayList<Project> list;
    /**
     * 筛选文字
     */
    private String matchString;
    /**
     * 是否在编辑状态
     */
    private boolean isEditor;
    /**
     * 新建项目布局
     */
    private View bottomLayout;
    /**
     * 新增项目布局 ,保存项目布局
     */
    private View newProjectayout, saveProjectLayout;
    /**
     * 项目输入框
     */
    private EditText newProjectEdit;
    /**
     * 编辑文本
     */
    private TextView editorText;


    /**
     * 启动当前Activity
     *
     * @param context
     * @param proId    已选中的id
     * @param projects 项目列表
     */
    public static void actionStart(Activity context, String proId, ArrayList<Project> projects) {
        Intent intent = new Intent(context, ProjectListActivity.class);
        intent.putExtra(Constance.PRO_ID, proId);
        intent.putExtra(Constance.BEAN_ARRAY, projects);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.group_info);
        initView();
        initData();
    }


    private void initData() {
        ArrayList<Project> list = (ArrayList<Project>) getIntent().getSerializableExtra(Constance.BEAN_ARRAY);
        if (list != null && list.size() > 0) {
            String selecteProId = getIntent().getStringExtra(Constance.PRO_ID);
            if (!TextUtils.isEmpty(selecteProId)) {
                for (Project project : list) {
                    if (!TextUtils.isEmpty(project.getPro_id()) && project.getPro_id().equals(selecteProId)) {
                        project.setIsSelected(true);
                        break;
                    }
                }
            }
            setAdapter(list);
        }
    }

    private void initView() {
        setTextTitleAndRight(R.string.select_project, R.string.update_and_delete);
        getTextView(R.id.red_btn).setText(R.string.add_pro);

        final Button saveProBtn = findViewById(R.id.saveProBtn);

        editorText = getTextView(R.id.right_title);
        bottomLayout = findViewById(R.id.bottom_layout);
        newProjectayout = findViewById(R.id.bottom_layout);
        newProjectEdit = getEditText(R.id.newProjectEdit);
        saveProjectLayout = findViewById(R.id.saveProjectLayout);
        getTextView(R.id.defaultDesc).setText("你还未创建任何项目");
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        // 根据输入框输入值的改变来过滤搜索
        mClearEditText.setHint("快速搜索关键字");
        mClearEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence inputText, int start, int before, int count) {
                filterData(inputText.toString());
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });
        newProjectEdit.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence inputText, int start, int before, int count) {
                String s = inputText.toString();
                Utils.setBackGround(saveProBtn, getResources().getDrawable(TextUtils.isEmpty(s) ? R.drawable.sk_dbdbdb_bg_white_5radius : R.drawable.draw_eb4e4e_5radius));
                saveProBtn.setTextColor(ContextCompat.getColor(getApplicationContext(), TextUtils.isEmpty(s) ? R.color.color_333333 : R.color.white));
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
     * 搜索框 筛选数据
     *
     * @param mMatchString
     */
    private synchronized void filterData(final String mMatchString) {
        if (adapter == null || list == null || list.size() == 0) {
            return;
        }
        matchString = mMatchString;
        new Thread(new Runnable() {
            @Override
            public void run() {
                final List<Project> filterDataList = SearchMatchingUtil.match(Project.class, list, matchString);
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

    private void setAdapter(ArrayList<Project> list) {
        this.list = list;
        ListView listView = (ListView) findViewById(R.id.listView);
        adapter = new SelectProjectAdapter(ProjectListActivity.this, list, new SelectProjectAdapter.ProjectBtnListener() {
            @Override
            public void save(Project project, String editorName, int position) {
                if (TextUtils.isEmpty(editorName)) {
                    CommonMethod.makeNoticeLong(getApplicationContext(), "请输入项目名称", CommonMethod.ERROR);
                    return;
                }
                if (project.getPro_name().equals(editorName)) {
                    CommonMethod.makeNoticeShort(ProjectListActivity.this, "项目修改成功!", CommonMethod.SUCCESS);
                    operationEditor();
                    return;
                }
                modifyProjectName(project, editorName);
            }

            @Override
            public void delete(Project project, int position) {
                deleteProject(project.getPro_id(), project.getPro_name(), project.isSelected(), position);
            }

            @Override
            public void clickItem(Project project) {
                if (project.getIs_create_group() == 1) { //已创建的班组则不能在重新创建
                    new DialogCreateSameGroupName(ProjectListActivity.this, getRegularGroupName(project.getPro_name()), new DialogCreateSameGroupName.LeftRightBtnListener() {
                        @Override
                        public void clickLeftBtnCallBack() {

                        }

                        @Override
                        public void clickRightBtnCallBack(String proName) {
                            addProject(proName);
                        }
                    }).show();
//                    CommonMethod.makeNoticeShort(ProjectListActivity.this, "该项目已经创建过班组了", CommonMethod.ERROR);
                    return;
                }
                Intent intent = getIntent();
                intent.putExtra(Constance.BEAN_CONSTANCE, project);
                setResult(Constance.SELECTE_PROJECT, intent);
                finish();
            }
        }, true);
        listView.setEmptyView(findViewById(R.id.defaultLayout));
        listView.setAdapter(adapter);
    }

    /**
     * 项目名称是纯文字的：输入框中带入【项目名称+01】，末尾的数字，根据点击的项目名称尾数自动+1（如：新天地项目已有班组，点击后，在弹框中输入框内显示“新天地01”；如再次点击“新天地”，
     * 在项目列表中需要和已经创建的项目名称对比，因为新天地01已经存在，所以再次点击“新天地”，弹框输入框内应该显示“新天地02”）；
     * 项目名称位数是2位数字的：如“新天地01”这个项目已有班组，在他的基础上新建项目，点击后，弹框中的项目名称应该为“新天地02”）；
     * 项目名称位数是1位数字的：如“吉工家日常测试1”，这个项目已有班组，在他的基础上新建项目，点击后，弹框中的项目名称应该为“吉工家日常测试101”）
     */
    public String getRegularGroupName(String projectName) {
        if (list != null && list.size() > 0) {
            if (!TextUtils.isEmpty(projectName)) {
                String lastStr = projectName.length() > 2 ? projectName.substring(projectName.length() - 2) : projectName;
                String firstStr = projectName.length() > 2 ? projectName.substring(0, projectName.length() - 2) : projectName;
                //首先检测是否有相同名字的项目名称
                ArrayList<String> sameNameList = new ArrayList<>();
                for (Project project : list) {
                    //如果有相同名字的先记录下来放在集合里面, 需要排除匹配的项目名称
                    if (project.getPro_name().contains(firstStr) || project.getPro_name().contains(projectName)) {
                        sameNameList.add(project.getPro_name());
                    }
                }
                if (sameNameList.size() > 0) { //有相同的项目组名称
                    int maxNumberCount = -1;
                    for (String sameProName : sameNameList) {
                        String sameProNameLastStr = sameProName.substring(sameProName.length() - 2);
                        //获取规则中 数字最大的
                        if (Pattern.compile("[0-9]{2}").matcher(sameProNameLastStr).matches()) {
                            int numberCount = Integer.parseInt(sameProNameLastStr);
                            if (numberCount > maxNumberCount) {
                                maxNumberCount = numberCount;
                            }
                        }
                    }
                    if (maxNumberCount == -1) {
                        return startRegularProName(projectName, lastStr, firstStr);
                    } else {
                        maxNumberCount++;
                        if (Pattern.compile("[0-9]{2}").matcher(lastStr).matches()) {
                            return firstStr + (maxNumberCount < 10 ? "0" + maxNumberCount : maxNumberCount);
                        } else {
                            return projectName + (maxNumberCount < 10 ? "0" + maxNumberCount : maxNumberCount);
                        }
                    }
                } else {
                    return startRegularProName(projectName, lastStr, firstStr);
                }
            }
        }
        return null;
    }

    /**
     * 开启班组名称验证
     */
    private String startRegularProName(String projectName, String lastStr, String firstStr) {
        if (Pattern.compile("[0-9]{2}").matcher(lastStr).matches()) {
            int numberCount = Integer.parseInt(lastStr);
            numberCount++;
            return firstStr + (numberCount < 10 ? "0" + numberCount : numberCount);
        } else {
            return projectName + "01";
        }
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.RESULTWORKERS) { //新建项目回调
            Project project = (Project) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            Intent intent = getIntent();
            intent.putExtra(Constance.BEAN_CONSTANCE, project);
            setResult(Constance.SELECTE_PROJECT, intent);
            finish();
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.red_btn_layout: //新建班组
                newProjectayout.setVisibility(View.GONE);
                saveProjectLayout.setVisibility(View.VISIBLE);
                newProjectEdit.requestFocus();
                new Timer().schedule(new TimerTask() {
                    public void run() {
                        showSoftKeyboard(newProjectEdit);
                    }
                }, 200);
//                AddProjectActivity.actionStart(this, true);
                break;
            case R.id.right_title: //编辑按钮
                operationEditor();
                break;
            case R.id.saveProBtn: //保存新增项目
                String proName = newProjectEdit.getText().toString().trim();
                if (!AppUtils.filterAppImportantWord(getApplicationContext(), proName, "项目", false)) {
                    return;
                }
                addProject(proName);
                break;
        }
    }

    /**
     * 删除项目
     *
     * @param pid 项目id
     */
    private void deleteProject(final String pid, String proName, final boolean isSelecte, final int position) {
        DialogLeftRightBtnConfirm dialogLeftRightBtnConfirm = new DialogLeftRightBtnConfirm(this, null, "确认删除" + proName + "项目吗",
                new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                    @Override
                    public void clickLeftBtnCallBack() {

                    }

                    @Override
                    public void clickRightBtnCallBack() {
                        String httpUrl = NetWorkRequest.WORKDAY_DEL_PRO;
                        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
                        params.addBodyParameter("pid_str", pid); //项目id
                        CommonHttpRequest.commonRequest(ProjectListActivity.this,
                                httpUrl, BaseNetNewBean.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
                                    @Override
                                    public void onSuccess(Object object) {
                                        CommonMethod.makeNoticeLong(getApplicationContext(), "项目删除成功！", CommonMethod.SUCCESS);
                                        adapter.getProjectList().remove(position);
                                        adapter.notifyDataSetChanged();
                                        if (isSelecte) { //如果删除的项目当前已选中则标记一下，当如果什么都不选的情况下返回上个页面需要及时清空上次选择的信息
                                            setResult(Constance.CANCEL_SELECTE);
                                        }
                                    }

                                    @Override
                                    public void onFailure(HttpException exception, String errormsg) {
                                    }
                                });
                    }
                });
        dialogLeftRightBtnConfirm.show();
    }

    /**
     * 修改项目名称
     *
     * @param editorName 修改项目的名称
     * @param project
     */
    private void modifyProjectName(final Project project, final String editorName) {
        if (!AppUtils.filterAppImportantWord(getApplicationContext(), editorName, "项目", false)) {
            return;
        }
        String httpUrl = NetWorkRequest.WORKDAY_MODIFY_PRO;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("pid_str", project.getPro_id()); //项目id
        params.addBodyParameter("pro_name", editorName); //项目名称
        CommonHttpRequest.commonRequest(this, httpUrl, GroupDiscussionInfo.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                if (project.getIs_create_group() == 1) { //项目已创建了班组的标识 需要将本地的名称修改
                    GroupDiscussionInfo groupInfo = (GroupDiscussionInfo) object;
                    //修改本地已创建的班组名称
                    MessageUtil.modityLocalTeamGroupInfo(ProjectListActivity.this, null,
                            groupInfo.getGroup_name(), null,
                            groupInfo.getGroup_id(), groupInfo.getClass_type(),
                            null, null,
                            null, null, 0, null,
                            null, null, null);
                }
                if (project.getPro_id().equals(getIntent().getStringExtra(Constance.PRO_ID))) {
                    Intent intent = getIntent();
                    intent.putExtra(Constance.BEAN_CONSTANCE, project);
                    setResult(Constance.SELECTE_PROJECT, intent);
                }
                project.setPro_name(editorName);
                CommonMethod.makeNoticeLong(getApplicationContext(), "项目修改成功！", CommonMethod.SUCCESS);
                operationEditor();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
            }
        });
    }

    private void operationEditor() {
        if (adapter == null || adapter.getCount() == 0) {
            return;
        }
        isEditor = !isEditor;
        if (isEditor) { //编辑状态下隐藏底部按钮
            bottomLayout.setVisibility(View.GONE);
            saveProjectLayout.setVisibility(View.GONE);
            hideSoftKeyboard();
        } else {
            bottomLayout.setVisibility(View.VISIBLE);
            saveProjectLayout.setVisibility(View.GONE);
        }
        editorText.setText(isEditor ? R.string.cancel : R.string.update_and_delete);
        adapter.setEditor(isEditor);
        adapter.notifyDataSetChanged();
    }

    /**
     * 新增项目
     *
     * @param proname
     */
    public void addProject(String proname) {
        String httpUrl = NetWorkRequest.ADDPRO;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("pro_name", proname);
        CommonHttpRequest.commonRequest(this, httpUrl, Project.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                Project project = (Project) object;
                project.setPro_id(String.valueOf(project.getPid()));
                Intent intent = getIntent();
                intent.putExtra(Constance.BEAN_CONSTANCE, project);
                setResult(Constance.RESULTWORKERS, intent);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
            }
        });
    }
}
