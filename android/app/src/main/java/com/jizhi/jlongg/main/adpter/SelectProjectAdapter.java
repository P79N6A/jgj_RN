package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.graphics.Color;
import android.support.v4.content.ContextCompat;
import android.text.Editable;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Project;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 选择项目
 *
 * @author xuj
 * @version 1.0
 * @time 2018年6月7日16:31:21
 */
public class SelectProjectAdapter extends BaseAdapter {
    /**
     * 列表数据
     */
    private List<Project> projectList;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * true 表示正在编辑
     */
    private boolean isEditor;
    /**
     * 保存按钮、修改按钮、删除按钮
     */
    private ProjectBtnListener listener;
    /**
     * 过滤文本
     */
    private String filterValue;
    /**
     * EditText 触摸的下标,重新获取焦点时 使用
     */
    public int editTouchIndex = -1;
    /**
     * 是否显示已有班组字段
     */
    private boolean isShowAlreadGroupText;

    private Context context;

    public SelectProjectAdapter(Context context, List<Project> projectInfos, ProjectBtnListener listener, boolean isShowAlreadGroupText) {
        super();
        this.context = context;
        this.projectList = projectInfos;
        this.listener = listener;
        this.isShowAlreadGroupText = isShowAlreadGroupText;
        inflater = LayoutInflater.from(context);

    }

    @Override
    public int getCount() {
        return projectList == null ? 0 : projectList.size();
    }

    @Override
    public Project getItem(int position) {
        return projectList.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @SuppressWarnings("deprecation")
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        final ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_selectproject, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        final Project project = getItem(position);
        holder.itemDiver.setVisibility(getCount() == position - 1 ? View.GONE : View.VISIBLE);
        if (isEditor && !TextUtils.isEmpty(project.getPro_id()) && !project.getPro_id().equals("0")) { //pid等于0的就是系统默认无项目名称  这条记录不需要显示删除和修改按钮
            if (project.isEditor()) {
                holder.proNameEdit.setText(!TextUtils.isEmpty(project.getEditor_name()) ? project.getEditor_name() : project.getPro_name());
                holder.btnDelete.setVisibility(View.GONE);
                holder.btnUpdate.setVisibility(View.GONE);
                holder.btnSave.setVisibility(View.VISIBLE);
                holder.proNameEdit.setVisibility(View.VISIBLE);
                holder.btnSave.setOnClickListener(new View.OnClickListener() { //保存按钮
                    @Override
                    public void onClick(View v) {
                        listener.save(project, holder.proNameEdit.getText().toString(), position);
                    }
                });
                holder.proNameEdit.setTag(position);
                setFocusEdit(holder.proNameEdit, position);
                setEditTextChange(holder.proNameEdit, position);
            } else {
                holder.btnDelete.setVisibility(View.VISIBLE);
                holder.btnUpdate.setVisibility(View.VISIBLE);
                holder.proNameEdit.setVisibility(View.GONE);
                holder.btnSave.setVisibility(View.GONE);
                holder.proNameTxt.setText(project.getPro_name());
                View.OnClickListener onClickListener = new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        switch (v.getId()) {
                            case R.id.btnDelete: //删除按钮
                                listener.delete(project, position);
                                break;
                            case R.id.btnUpdate: //修改项目名称
                                clearLastSelecteProjectEditorState();
                                project.setEditor(true);
                                notifyDataSetChanged();
                                break;
                        }
                    }
                };
                holder.btnDelete.setOnClickListener(onClickListener);
                holder.btnUpdate.setOnClickListener(onClickListener);
            }
            holder.existProName.setVisibility(View.GONE);
            holder.isSelected.setVisibility(View.GONE);
            holder.proNameTxt.setTextColor(ContextCompat.getColor(context, R.color.color_333333));
        } else {
            holder.btnDelete.setVisibility(View.GONE);
            holder.btnUpdate.setVisibility(View.GONE);
            holder.proNameEdit.setVisibility(View.GONE);
            holder.btnSave.setVisibility(View.GONE);
            holder.isSelected.setVisibility(project.isSelected() ? View.VISIBLE : View.GONE);
            holder.proNameTxt.setText(project.getPro_name());
            if (project.getIs_create_group() == 1 && isShowAlreadGroupText) {  //是否已有班组
                holder.existProName.setVisibility(View.VISIBLE);
                holder.proNameTxt.setTextColor(ContextCompat.getColor(context, R.color.color_999999));
            } else {
                holder.existProName.setVisibility(View.GONE);
                holder.proNameTxt.setTextColor(ContextCompat.getColor(context, R.color.color_333333));
            }
        }
        if (!TextUtils.isEmpty(filterValue)) { //如果过滤文字不为空
            Pattern p = Pattern.compile(filterValue);
            if (!TextUtils.isEmpty(project.getPro_name())) { //姓名不为空的时才进行模糊匹配
                SpannableStringBuilder builder = new SpannableStringBuilder(project.getPro_name());
                Matcher nameMatch = p.matcher(project.getPro_name());
                while (nameMatch.find()) {
                    ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                    builder.setSpan(redSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                }
                holder.proNameTxt.setText(builder);
            }
        }
        Utils.setBackGround(convertView, context.getResources().getDrawable(isEditor ? R.color.white : R.drawable.listview_selector_white_gray));
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (isEditor) {
                    return;
                }
                listener.clickItem(project);
            }
        });
        return convertView;
    }

    /**
     * 清空上次选择的项目状态
     */
    public void clearLastSelecteProjectEditorState() {
        if (getCount() != 0) {
            for (Project project : projectList) {
                if (project.isEditor()) {
                    project.setEditor(false);
                    return;
                }
            }
        }
    }

    class ViewHolder {
        /**
         * 修改按钮
         */
        TextView btnUpdate;
        /**
         * 删除按钮
         */
        TextView btnDelete;
        /**
         * 保存按钮
         */
        TextView btnSave;
        /**
         * 项目名称输入框
         */
        EditText proNameEdit;
        /**
         * 项目名称
         */
        TextView proNameTxt;
        /**
         * 是否选中
         */
        View isSelected;
        /**
         * 分割线
         */
        View itemDiver;
        /**
         * 已绑定班组的项目
         */
        TextView existProName;

        public ViewHolder(View convertView) {
            btnSave = (TextView) convertView.findViewById(R.id.btnSave);
            btnDelete = (TextView) convertView.findViewById(R.id.btnDelete);
            btnUpdate = (TextView) convertView.findViewById(R.id.btnUpdate);
            proNameTxt = (TextView) convertView.findViewById(R.id.proNameTxt);
            proNameEdit = (EditText) convertView.findViewById(R.id.proNameEdit);
            isSelected = convertView.findViewById(R.id.isSelected);
            itemDiver = convertView.findViewById(R.id.itemDiver);
            existProName = (TextView) convertView.findViewById(R.id.exist_pro_name);
        }
    }

    public interface ProjectBtnListener {
        public void save(Project project, String editorName, int position);

        public void delete(Project project, int position);

        public void clickItem(Project project);
    }

    public List<Project> getProjectList() {
        return projectList;
    }

    public void setProjectList(List<Project> projectList) {
        this.projectList = projectList;
    }

    public boolean isEditor() {
        return isEditor;
    }

    public void setEditor(boolean editor) {
        isEditor = editor;
    }

    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(List<Project> list) {
        this.projectList = list;
        notifyDataSetChanged();
    }

    public String getFilterValue() {
        return filterValue;
    }

    public void setFilterValue(String filterValue) {
        this.filterValue = filterValue;
    }

    /**
     * 解决liview中edittext弹出键盘焦点失去问题
     *
     * @param editText
     * @param position
     */
    private void setFocusEdit(final EditText editText, final int position) {
        if (editText == null) {
            return;
        }
        editText.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                if (event.getAction() == MotionEvent.ACTION_UP) {
                    // 在TOUCH的UP事件中，要保存当前的行下标，因为弹出软键盘后，整个画面会被重画
                    // 在getView方法的最后，要根据index和当前的行下标手动为EditText设置焦点
                    editTouchIndex = position;
                }
                return false;
            }
        });
        editText.clearFocus();
        // 如果当前的行下标和点击事件中保存的index一致，手动为EditText设置焦点。
        if (editTouchIndex != -1 && editTouchIndex == position) {
            editText.requestFocus();
        }
    }

    private void setEditTextChange(final EditText editText, final int position) {
        editText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
            }

            @Override
            public void afterTextChanged(Editable s) {
                getItem(position).setEditor_name(s.toString());
            }
        });
    }
}
