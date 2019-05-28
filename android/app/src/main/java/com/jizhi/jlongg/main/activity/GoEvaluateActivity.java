package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.EvaluateTagAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.BaseNetNewBean;
import com.jizhi.jlongg.main.bean.EvaluateInfo;
import com.jizhi.jlongg.main.bean.EvaluateTag;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RecordUtils;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.FlowTagView;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;
import com.jizhi.jongg.widget.StarBar;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;

/**
 * 去评价
 *
 * @author Xuj
 * @time 2018年4月27日17:31:53
 * @Version 1.0
 */

public class GoEvaluateActivity extends BaseActivity implements View.OnClickListener, FlowTagView.TagItemClickListener {
    /**
     * 工作态度、专业技能、靠谱程度
     */
    private StarBar workingAttitudeStarBar, professionalSkillsStarBar, degreeOfReliabilitystarBar;
    /**
     * 评价输入框
     */
    private EditText evaluateEdit;
    /**
     * 是否愿意图标
     */
    private ImageView likeIcon;
    /**
     * 标签View
     */
    private FlowTagView tagView;
    /**
     * 是否愿意
     * true 表示愿意
     * false 表示不愿意
     */
    private boolean isLike = true;
    /**
     * 本地的添加的标签个数不能超过5个
     */
    private int localAddTagCount;

    /**
     * 启动当前Activity
     *
     * @param context
     * @param uid       用户id
     * @param headImage 用户头像
     * @param userName  用户名称
     */
    public static void actionStart(Activity context, String uid, String headImage, String userName) {
        Intent intent = new Intent(context, GoEvaluateActivity.class);
        intent.putExtra(Constance.UID, uid);
        intent.putExtra(Constance.USERNAME, userName);
        intent.putExtra(Constance.HEAD_IMAGE, headImage);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.go_evaluate);
        initView();
        getInfo();
    }

    private void getInfo() {
        String httpUrl = NetWorkRequest.EVALUATE_PAGE_INFO;
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("uid", getIntent().getStringExtra(Constance.UID));
        CommonHttpRequest.commonRequest(this, httpUrl, EvaluateInfo.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                EvaluateInfo evaluateInfo = (EvaluateInfo) object;
                String roler = UclientApplication.getRoler(getApplicationContext());
                String tips = roler.equals(Constance.ROLETYPE_FM) ? "你" : "他";

                getTextView(R.id.projectCount).setText(Utils.setSelectedFontChangeColor("在" + evaluateInfo.getCooperation_pro_num() +
                        "个项目上为" + tips + "工作过", evaluateInfo.getCooperation_pro_num() + "", Color.parseColor("#eb4e4e"),false)); //项目数

                String workHourResult = RecordUtils.cancelIntergerZeroFloat(evaluateInfo.getTotal_work_hours());
                getTextView(R.id.workTotalTime).setText(Utils.setSelectedFontChangeColor("总计为" + tips + "工作" + workHourResult +
                        "小时", workHourResult, Color.parseColor("#eb4e4e"),false)); //项目数

                ArrayList<EvaluateTag> tagList = evaluateInfo.getTag_list(); //获取系统评价标签
                if (tagList == null || tagList.size() == 0) {
                    tagView.setVisibility(View.GONE);
                } else {
                    tagView.setVisibility(View.VISIBLE);
                    EvaluateTagAdapter adapter = new EvaluateTagAdapter(GoEvaluateActivity.this, tagList);
                    adapter.setEditor(true);
                    tagView.setAdapter(adapter);
                    tagView.setItemClickListener(GoEvaluateActivity.this);
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }

    private void initView() {
        setTextTitle(R.string.evaluation);
        getButton(R.id.red_btn).setText(R.string.submit);
        TextView userNameText = getTextView(R.id.userNameText);
        RoundeImageHashCodeTextLayout headImageView = (RoundeImageHashCodeTextLayout) findViewById(R.id.headImageView);

        workingAttitudeStarBar = (StarBar) findViewById(R.id.workingAttitudeStarBar);
        professionalSkillsStarBar = (StarBar) findViewById(R.id.professionalSkillsStarBar);
        degreeOfReliabilitystarBar = (StarBar) findViewById(R.id.degreeOfReliabilitystarBar);
        evaluateEdit = (EditText) findViewById(R.id.evaluateEdit);
        likeIcon = getImageView(R.id.likeIcon);
        tagView = (FlowTagView) findViewById(R.id.tagView);

        workingAttitudeStarBar.setCanTouchStar();
        professionalSkillsStarBar.setCanTouchStar();
        degreeOfReliabilitystarBar.setCanTouchStar();


        headImageView.setView(getIntent().getStringExtra(Constance.HEAD_IMAGE), getIntent().getStringExtra(Constance.USERNAME), 0); //设置头像
        userNameText.setText(getIntent().getStringExtra(Constance.USERNAME)); //设置名称
        evaluateEdit.setHint(UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_FM) ? "请填写你对该工人的评价" : "请填写你对该班组长的评价");
        tagView.setVisibility(View.GONE);

        String roler = UclientApplication.getRoler(getApplicationContext());

        TextView star1Text = (TextView) findViewById(R.id.star1Text);
        TextView star2Text = (TextView) findViewById(R.id.star2Text);
        TextView guYongText = (TextView) findViewById(R.id.guYongText);
        String tips = roler.equals(Constance.ROLETYPE_FM) ? "雇佣他" : "为他工作?";
        guYongText.setText("有新的项目，是否愿意再次" + tips);
        star1Text.setText(roler.equals(Constance.ROLETYPE_FM) ? "工作态度" : "没有拖欠工资");
        star2Text.setText(roler.equals(Constance.ROLETYPE_FM) ? "专业技能" : "没有辱骂工人");
    }

    /**
     * 已选的标签个数
     */
    private int selectedTagCount() {
        int count = 0;
        EvaluateTagAdapter adapter = (EvaluateTagAdapter) tagView.getmAdapter();
        if (adapter != null && adapter.getCount() > 0) {
            List<EvaluateTag> tags = adapter.getList();
            for (EvaluateTag tag : tags) {
                if (tag.is_selected()) {
                    count += 1;
                }
            }
        }
        return count;
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.addTagBtn:
            case R.id.inputTagText: //添加标签
                if (localAddTagCount + selectedTagCount() >= 5) {
                    CommonMethod.makeNoticeLong(getApplicationContext(), "最多添加5个标签", CommonMethod.ERROR);
                    return;
                }
                AddEvaluateTagActivity.actionStart(this);
                break;
            case R.id.red_btn: //提交评价
                submit();
                break;
            case R.id.likeLayout: //愿意布局
                isLike = !isLike;
                likeIcon.setImageResource(isLike ? R.drawable.singlebtn_selected : R.drawable.singlebtn_normal);
                break;
        }
    }

    /**
     * 提交评价
     */
    private void submit() {
        if (TextUtils.isEmpty(getTagNames())) {
            CommonMethod.makeNoticeLong(getApplicationContext(), "请选择你对他的印象", CommonMethod.ERROR);
            return;
        }
        String message = evaluateEdit.getText().toString().trim();
//        if (TextUtils.isEmpty(message)) {
//            CommonMethod.makeNoticeLong(getApplicationContext(), "请填写你对他的评价", CommonMethod.ERROR);
//            return;
//        }
//        if (message.length() < 5) {
//            CommonMethod.makeNoticeLong(getApplicationContext(), "评价不能少于5个字", CommonMethod.ERROR);
//            return;
//        }
        if (workingAttitudeStarBar.getStarMark() == 0 || professionalSkillsStarBar.getStarMark() == 0 || degreeOfReliabilitystarBar.getStarMark() == 0) {
            CommonMethod.makeNoticeLong(getApplicationContext(), "请你对他进行评分", CommonMethod.ERROR);
            return;
        }
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("uid", getIntent().getStringExtra(Constance.UID)); //被评价人uid
        params.addBodyParameter("tag_names", getTagNames()); //标签名称，多个逗号分隔
        params.addBodyParameter("evaluate_content", message); // 评价内容，最多200字
        params.addBodyParameter("attitude_or_arrears", (int) workingAttitudeStarBar.getStarMark() + "");//工作态度或没有拖欠工资星星（当前用户是工头，则为工作态度）
        params.addBodyParameter("professional_or_abuse", (int) professionalSkillsStarBar.getStarMark() + "");//专业技能或者辱骂工人星星（当前用户是工头，则为专业技能）
        params.addBodyParameter("reliance_degree", (int) degreeOfReliabilitystarBar.getStarMark() + "");//	靠谱程度星星
        params.addBodyParameter("is_cooperate_again", isLike ? "1" : "0");//是否愿意再次合作，1愿意，0不愿意，默认0
        String httpUrl = NetWorkRequest.SUBMIT_EVALUATE;
        CommonHttpRequest.commonRequest(this, httpUrl, BaseNetNewBean.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                setResult(Constance.EVALUATE_SUCCESS, getIntent());
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
            }
        });
    }

    /**
     * 获取标签名称
     *
     * @return
     */
    public String getTagNames() {
        EvaluateTagAdapter adapter = (EvaluateTagAdapter) tagView.getmAdapter();
        if (adapter == null || adapter.getCount() == 0) {
            return "";
        } else {
            StringBuilder builder = new StringBuilder();
            List<EvaluateTag> list = adapter.getList();
            for (EvaluateTag tag : list) {
                if (tag.is_selected()) {
                    builder.append(TextUtils.isEmpty(builder.toString()) ? tag.getTag_name() : "," + tag.getTag_name());
                }
            }
            return builder.toString();
        }
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.SUCCESS) { //添加评价标签成功
            tagView.setVisibility(View.VISIBLE);
            EvaluateTag evaluateTag = new EvaluateTag();
            evaluateTag.setIs_selected(true);
            evaluateTag.setTag_name(data.getStringExtra(Constance.BEAN_STRING));
            localAddTagCount += 1;
            if (tagView.getmAdapter() == null) {
                ArrayList<EvaluateTag> tagList = new ArrayList<>();
                tagList.add(evaluateTag);
                EvaluateTagAdapter adapter = new EvaluateTagAdapter(GoEvaluateActivity.this, tagList);
                adapter.setEditor(true);
                tagView.setAdapter(adapter);
                tagView.setItemClickListener(this);
            } else {
                EvaluateTagAdapter adapter = (EvaluateTagAdapter) tagView.getmAdapter();
                adapter.add(evaluateTag);
            }
        }
    }


    @Override
    public void itemClick(int position) {
        EvaluateTagAdapter adapter = (EvaluateTagAdapter) tagView.getmAdapter();
        EvaluateTag clickTag = adapter.getItem(position);
        if (!clickTag.is_selected()) {
            //最多可选中5个标签
            int count = 0;
            for (EvaluateTag tag : adapter.getList()) {
                if (tag.is_selected()) {
                    count += 1;
                }
            }
            if (count >= 5) {
                CommonMethod.makeNoticeLong(getApplicationContext(), "最多可选中5个标签", CommonMethod.ERROR);
                return;
            }
        }
        clickTag.setIs_selected(!clickTag.is_selected());
        adapter.notifyDataSetChanged();
    }
}
