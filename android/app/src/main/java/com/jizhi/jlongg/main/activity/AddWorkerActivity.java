package com.jizhi.jlongg.main.activity;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.text.Editable;
import android.text.Html;
import android.text.InputFilter;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.TextView;

import com.hcs.uclient.utils.StrUtil;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.OnSquaredImageRemoveClick;
import com.jizhi.jlongg.main.adpter.SquaredImageAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AccountSwitchConfirm;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.UserInfo;
import com.jizhi.jlongg.main.dialog.DiaLogBottomRed;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.ThreadPoolUtils;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.utis.acp.Acp;
import com.jizhi.jlongg.utis.acp.AcpListener;
import com.jizhi.jlongg.utis.acp.AcpOptions;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import java.util.regex.Pattern;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;

import static anet.channel.util.Utils.context;

/**
 * 功能:添加记账对象 编辑记账对象名
 * 时间:2018年6月13日15:15:59
 * 作者:xuj
 */
public class AddWorkerActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 姓名输入框
     */
    private EditText nameEdit;
    /**
     * 电话输入框
     */
    private EditText telephoneEdit;
    /**
     * 备注信息
     */
    private EditText remarkEdittext;
    /**
     * 备注图片适配器
     */
    private SquaredImageAdapter adapter;
    /**
     * 备注图片最大上传数
     */
    private int MAXPHOTOCOUNT = 8;
    /**
     * 备注图片数据
     */
    private ArrayList<ImageItem> imageItems = new ArrayList<>();

    /**
     * 启动当前Activity
     *
     * @param context
     * @param isEditor         true表示编辑
     * @param uid              编辑人id
     * @param editorName       编辑者名称
     * @param editorTele       编辑者电话
     * @param remarkInfo       备注信息
     * @param remarkImages     图片备注
     * @param isShowRemarkInfo 是否显示备注信息
     */
    public static void actionStart(Activity context, boolean isEditor, String editorName,
                                   String editorTele, String uid, String remarkInfo, ArrayList<String> remarkImages, boolean isShowRemarkInfo) {
        Intent intent = new Intent(context, AddWorkerActivity.class);
        intent.putExtra(Constance.USERNAME, editorName);
        intent.putExtra(Constance.UID, uid);
        intent.putExtra(Constance.TELEPHONE, editorTele);
        intent.putExtra(Constance.BEAN_BOOLEAN, isEditor);
        intent.putExtra("remark_info", remarkInfo);
        intent.putExtra("remark_images", remarkImages);
        intent.putExtra("is_show_remark", isShowRemarkInfo);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     * @param personBeans     将列表上的成员信息传过来 主要是做电话号码的比对 如果已经提交了相同的电话号码则不提交服务器
     * @param accountTyps     记账类型
     * @param constractorType 包工类型  (1是承包 2是分包)如果不是包工记账 则传0
     */
    public static void actionStart(Activity context, ArrayList<PersonBean> personBeans, int accountTyps, int constractorType) {
        Intent intent = new Intent(context, AddWorkerActivity.class);
        intent.putExtra(Constance.BEAN_ARRAY, personBeans);
        intent.putExtra(Constance.ACCOUNT_TYPE, accountTyps);
        intent.putExtra(Constance.CONSTRACTOR_TYPE, constractorType);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.add_worker);
        initView();
    }

    private void initView() {
        Intent intent = getIntent();
        nameEdit = getEditText(R.id.nameEdit);
        telephoneEdit = getEditText(R.id.telephoneEdit);
        boolean isShowRemark = intent.getBooleanExtra("is_show_remark", false);
        if (isShowRemark) {
            findViewById(R.id.remark_layout).setVisibility(View.VISIBLE);
            remarkEdittext = getEditText(R.id.remark_edit);
            remarkEdittext.setText(intent.getStringExtra("remark_info"));
            ArrayList<String> imageItems = (ArrayList<String>) intent.getSerializableExtra("remark_images");
            if (imageItems != null && !imageItems.isEmpty()) {
                int size = imageItems.size();
                for (int i = 0; i < size; i++) {
                    ImageItem imageItem = new ImageItem();
                    imageItem.isNetPicture = true;
                    imageItem.imagePath = imageItems.get(i);
                    this.imageItems.add(imageItem);
                }
            }
            initWorkReportImageAdapter();
        }
        TextView nameText = getTextView(R.id.nameText);
        TextView telephoneText = getTextView(R.id.telephoneText);
        boolean isEditorPerson = intent.getBooleanExtra(Constance.BEAN_BOOLEAN, false);
        if (isContractor()) {
            nameText.setText("承包对象");
            nameEdit.setHint("输入承包对象姓名、承包单位、承包项目名称");
            nameEdit.setFilters(new InputFilter[]{new InputFilter.LengthFilter(15)});
            telephoneText.setText(Html.fromHtml(isEditorPerson ? "<font color='#333333'>电话号码</font>" :
                    "<font color='#333333'>电话号码</font><font color='#eb4e4e'>(可以不填)</font>"));
            telephoneEdit.setHint("请输入电话号码");
        } else {
            if (UclientApplication.isForemanRoler(getApplicationContext())) { //工头角色
                nameText.setText("工人姓名");
                telephoneText.setText(Html.fromHtml(isEditorPerson ? "<font color='#333333'>工人电话</font>" :
                        "<font color='#333333'>工人电话</font><font color='#eb4e4e'>(可以不填)</font>"));
                nameEdit.setHint("请输入工人的姓名");
                telephoneEdit.setHint("请输入工人的电话号码");
            } else { //工人角色
                nameText.setText("班组长姓名");
                telephoneText.setText(Html.fromHtml(isEditorPerson ? "<font color='#333333'>班组长电话</font>" :
                        "<font color='#333333'>班组长电话</font><font color='#eb4e4e'>(可以不填)</font>"));
                nameEdit.setHint("请输入班组长的姓名");
                telephoneEdit.setHint("请输入班组长的电话号码");
            }
        }
        if (isEditorPerson) {//编辑状态
            setTextTitleAndRight(R.string.update_info, R.string.save);
            String name = intent.getStringExtra(Constance.USERNAME);
            if (!TextUtils.isEmpty(name)) { //设置选中的光标为最后一位
                nameEdit.setText(name);
                nameEdit.setSelection(nameEdit.getText().length());
            }
            String telphone = intent.getStringExtra(Constance.TELEPHONE);
            //如果没有电话号码则隐藏布局
            if (TextUtils.isEmpty(telphone)) {
                findViewById(R.id.telephoneLayout).setVisibility(View.GONE);
            } else {
                telephoneEdit.setText(telphone);
                telephoneEdit.setFocusable(false);
                telephoneEdit.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.color_999999));
                telephoneEdit.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        String role = UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_FM) ? "工人" : "班组长";
                        String tips = role + "电话无法修改哦，如果该" + role + "换了电话，可以重新添加新的电话号码为他记工。";
                        new DiaLogBottomRed(AddWorkerActivity.this, "我知道了", tips).show();
                    }
                });
            }
        } else {
            if (isContractor()) {
                setTextTitleAndRight(R.string.add_contractor_person, R.string.save);
            } else {
                setTextTitleAndRight(UclientApplication.isForemanRoler(getApplicationContext()) ? R.string.add_worker : R.string.add_foreman, R.string.save);
            }
        }
        telephoneEdit.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (s.length() == 11) {
                    MessageUtil.useTelGetUserInfo(AddWorkerActivity.this, s.toString(), new CommonHttpRequest.CommonRequestCallBack() {
                        @Override
                        public void onSuccess(Object object) {
                            GroupMemberInfo info = (GroupMemberInfo) object;
                            if (!TextUtils.isEmpty(info.getReal_name())) {
                                nameEdit.setText(info.getReal_name());
                            }
                        }

                        @Override
                        public void onFailure(HttpException exception, String errormsg) {

                        }
                    });
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
        new Timer().schedule(new TimerTask() { //弹出键盘
            public void run() {
                showSoftKeyboard(nameEdit);
            }
        }, 500);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title: //保存数据
                final String name = nameEdit.getText().toString().trim();
                if (TextUtils.isEmpty(name)) {
                    CommonMethod.makeNoticeShort(getApplicationContext(), nameEdit.getHint().toString(), CommonMethod.ERROR);
                    return;
                }
                String ruler = "(([\u4E00-\u9FA5]{2,7})|([a-zA-Z]{3,10}))";
                if (!Pattern.matches(ruler, name)) {
                    if (isContractor()) {
                        if (name.length() < 2 || name.length() > 15) {
                            CommonMethod.makeNoticeShort(getApplicationContext(), "姓名只能为二至十五个字!", CommonMethod.ERROR);
                            return;
                        }
                    } else {
                        if (name.length() < 2 || name.length() > 10) {
                            CommonMethod.makeNoticeShort(getApplicationContext(), "姓名只能为二至十个字!", CommonMethod.ERROR);
                            return;
                        }
                    }
                }
                commitSave(name, telephoneEdit.getText().toString().trim());
                break;
        }
    }

    /**
     * 提交保存数据
     *
     * @param name
     * @param telphone
     */
    public void commitSave(final String name, final String telphone) {
        if (getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false)) {//编辑状态
            fileUpData(name);
        } else { //添加记账成员
            if (TextUtils.isEmpty(telphone)) {
                AccountUtil.getRecordConfirmStatus(this, new CommonHttpRequest.CommonRequestCallBack() {
                    @Override
                    public void onSuccess(Object object) {
                        AccountSwitchConfirm accountSwitchConfirm = (AccountSwitchConfirm) object;
                        int status = accountSwitchConfirm.getStatus();//1 表示关闭 ；0:表示开启
                        String tips = null;
                        if (status == 1) {
                            tips = isContractor() ? "填写电话号码后能找回误删的记工记录。确定不填写承包对象电话吗？"
                                    : "填写电话号码后能找回误删的记工记录。确定不填写吗？";
                        } else {
                            tips = isContractor() ? "填写对方的手机号码，可以让对方更快与你在线对账，避免差异。确定不填写承包对象电话吗？" :
                                    "填写对方的手机号码，可以让对方更快与你在线对账，避免差异。确定不填写吗？";
                        }
                        DialogLeftRightBtnConfirm dialog = new DialogLeftRightBtnConfirm(AddWorkerActivity.this, null, tips, new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                            @Override
                            public void clickLeftBtnCallBack() {
                                addAccountPerson(name, telphone);
                            }

                            @Override
                            public void clickRightBtnCallBack() {

                            }
                        });
                        dialog.setLeftBtnText("不填写");
                        dialog.setRightBtnText("继续填写");
                        dialog.show();
                    }

                    @Override
                    public void onFailure(HttpException exception, String errormsg) {

                    }
                });
            } else {
                if (!StrUtil.isMobileNum(telphone)) {
                    CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.input_sure_mobile), CommonMethod.ERROR);
                    return;
                }
                PersonBean personBean = checkTelphoneIsExist(telphone);
                if (personBean != null) {
                    Intent intent = getIntent();
                    intent.putExtra(Constance.BEAN_CONSTANCE, personBean); //获取已中的记账对象
                    setResult(Constance.MANUAL_ADD_OR_EDITOR_PERSON, intent);
                    finish();
                    return;
                }
                addAccountPerson(name, telphone);
            }
        }
    }

    /**
     * 添加记账对象
     *
     * @param name      记账人名称
     * @param telephone 电话号码
     */
    private void addAccountPerson(String name, String telephone) {
        CommonHttpRequest.addAccountPerson(AddWorkerActivity.this, name, telephone, isContractor(), new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                Intent intent = getIntent();
                intent.putExtra(Constance.BEAN_CONSTANCE, (PersonBean) object);
                setResult(Constance.MANUAL_ADD_OR_EDITOR_PERSON, intent);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    /**
     * 是否是承包对象
     *
     * @return true表示是
     */
    public boolean isContractor() {
        int accountTyps = getIntent().getIntExtra(Constance.ACCOUNT_TYPE, AccountUtil.HOUR_WORKER_INT);
        int constractorType = getIntent().getIntExtra(Constance.CONSTRACTOR_TYPE, 0);
        return accountTyps == AccountUtil.CONSTRACTOR_INT && constractorType == 1;
    }


    /**
     * 检查记账对象是否已存在列表中
     *
     * @param telphone
     * @return
     */
    public PersonBean checkTelphoneIsExist(String telphone) {
        ArrayList<PersonBean> personBeans = (ArrayList<PersonBean>) getIntent().getSerializableExtra(Constance.BEAN_ARRAY);
        if (personBeans != null && !personBeans.isEmpty()) {
            for (PersonBean bean : personBeans) {
                if (telphone.equals(bean.getTelph())) { //电话号码相同
                    return bean;
                }
            }
        }
        return null;
    }


    /**
     * 初始化图片数据
     */
    public void initWorkReportImageAdapter() {
        if (adapter == null) {
            GridView gridView = (GridView) findViewById(R.id.remark_gridView);
            adapter = new SquaredImageAdapter(this, new OnSquaredImageRemoveClick() {
                @Override
                public void remove(int position) { //图片删除按钮回调
                    imageItems.remove(position);
                    adapter.notifyDataSetChanged();
                }
            }, imageItems, MAXPHOTOCOUNT);
            gridView.setAdapter(adapter);
            gridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    if (position == imageItems.size()) { //进入图片选择器
                        //6.0需要获取读取本地内存卡权限
                        Acp.getInstance(getApplicationContext()).request(new AcpOptions.Builder()
                                        .setPermissions(Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.CAMERA).build(),
                                new AcpListener() {
                                    @Override
                                    public void onGranted() {
                                        ArrayList<String> mSelected = getSelectedPhotoPath();
                                        CameraPop.multiSelector(AddWorkerActivity.this, mSelected, MAXPHOTOCOUNT - getNetPicCount());
                                    }

                                    @Override
                                    public void onDenied(List<String> permissions) {
                                        CommonMethod.makeNoticeShort(getApplicationContext(), context.getResources().getString(R.string.permission_close), CommonMethod.ERROR);
                                    }
                                });
                    } else { //查看图片
                        PhotoZoomActivity.actionStart(AddWorkerActivity.this, (ArrayList<ImageItem>) imageItems, position, false);
                    }
                }
            });
        } else {
            adapter.notifyDataSetChanged();
        }
    }

    /**
     * 当前已选图片路径
     */
    public ArrayList<String> getSelectedPhotoPath() {
        ArrayList<String> mSelected = new ArrayList<>();
        int size = imageItems.size();
        for (int i = 0; i < size; i++) {
            ImageItem item = imageItems.get(i);
            if (!item.isNetPicture) {
                mSelected.add(item.imagePath);
            }
        }
        return mSelected;
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == CameraPop.REQUEST_IMAGE && resultCode == RESULT_OK) {//选择相册回调
            ArrayList<String> mSelected = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
            //服务器图片路径
            ArrayList<ImageItem> netWorkPic = new ArrayList<>();
            for (ImageItem netImageItem : imageItems) {
                if (netImageItem.isNetPicture) {
                    netWorkPic.add(netImageItem);
                }
            }
            imageItems = (ArrayList<ImageItem>) Utils.getImages(mSelected, null);
            imageItems.addAll(0, netWorkPic);
            adapter.updateGridView(imageItems);
        }
    }

    /**
     * 当前已选图片路径
     */
    public ArrayList<String> selectedPhotoPath() {
        if (imageItems == null || imageItems.isEmpty()) {
            return null;
        }
        ArrayList<String> mSelected = new ArrayList<String>();
        int size = imageItems.size();
        for (int i = 0; i < size; i++) {
            ImageItem item = imageItems.get(i);
            mSelected.add(item.imagePath);
        }
        return mSelected;
    }


    public void fileUpData(final String commentName) {
        createCustomDialog();
        ThreadPoolUtils.fixedThreadPool.execute(new Runnable() {
            @Override
            public void run() {
                RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
                if (selectedPhotoPath() != null && selectedPhotoPath().size() > 0) {
                    List<String> localUploadList = new ArrayList<>();
                    int size = imageItems.size();
                    for (int i = 0; i < size; i++) {
                        ImageItem item = imageItems.get(i);
                        if (!item.isNetPicture && !TextUtils.isEmpty(item.imagePath)) {
                            localUploadList.add(imageItems.get(i).imagePath);
                        }
                    }
                    if (localUploadList.size() > 0) {
                        RequestParamsToken.compressImageAndUpLoad(params, localUploadList, getApplicationContext());
                        upLoadImage(params, commentName);
                    } else {
                        commit(null, commentName);
                    }
                } else {
                    commit(null, commentName);
                }
            }
        });
    }

    /**
     * 上传图片
     */
    public void upLoadImage(RequestParams params, final String commentName) {
        String httpUrl = NetWorkRequest.UPLOAD_NEW;
        CommonHttpRequest.commonRequest(this, httpUrl, String.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                commit((ArrayList<String>) object, commentName);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                closeDialog();
            }
        });
    }

    /**
     * 提交工人，班组长信息
     *
     * @param remarkImages 图片备注信息
     * @param commentName  工人，班组长名称
     */
    public void commit(List<String> remarkImages, final String commentName) {
        String httpUrl = NetWorkRequest.SET_USER_COMMENT_NAME;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        String uid = getIntent().getStringExtra(Constance.UID);
        String notesTxt = remarkEdittext.getText().toString().trim();
        params.addBodyParameter("uid", uid);
        params.addBodyParameter("comment_name", commentName);
        if (!TextUtils.isEmpty(notesTxt)) {
            params.addBodyParameter("notes_txt", notesTxt);
        }
        //表示从工人/工头管理进入修改名称时（v4.0.0）
        params.addBodyParameter("modify_parnter", "1");
        StringBuffer buffer = new StringBuffer();
        int count = 0;
        if (null != remarkImages && remarkImages.size() > 0) {
            for (String path : remarkImages) {
                buffer.append(count == 0 ? path : "," + path);
                count++;
            }
        }
        if (imageItems != null && imageItems.size() > 0) {
            for (ImageItem imageItem : imageItems) {
                if (imageItem.isNetPicture) {
                    buffer.append(count == 0 ? imageItem.imagePath : "," + imageItem.imagePath);
                }
                count++;
            }
        }
        params.addBodyParameter("notes_img", buffer.toString());
        CommonHttpRequest.commonRequest(this, httpUrl, UserInfo.class, false, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                closeDialog();
                Intent intent = getIntent();
                intent.putExtra(Constance.TELEPHONE, telephoneEdit.getText().toString().trim());
                intent.putExtra(Constance.USERNAME, commentName);
                setResult(Constance.MANUAL_ADD_OR_EDITOR_PERSON, intent);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                closeDialog();
            }
        });
    }


    public int getNetPicCount() {
        int count = 0;
        if (imageItems != null && !imageItems.isEmpty()) {
            for (ImageItem netImageItem : imageItems) {
                if (netImageItem.isNetPicture) {
                    count++;
                }
            }
            return count;
        }
        return count;
    }

}
