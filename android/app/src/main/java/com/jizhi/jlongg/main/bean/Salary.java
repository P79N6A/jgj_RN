package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 薪资模板
 * @author xuj
 * @time 2016年2月22日 11:51:55
 * @version 1.0
 */
public class Salary implements Serializable{
	/** 金额 */
	private double s_tpl;
	/** 日薪模板正常上班时常 */
	private double w_h_tpl;
	/** 日薪模板加班时常 */
	private double o_h_tpl;
	/** 滑动选择 正常上班时常 */
	private double choose_w_h_tpl;
	/** 滑动选择 加班时常 */
	private double choose_o_h_tpl;
	/** 是否有差帐数据 */
	private String is_diff;
	/** 按小时算加班工资*/
	private double o_s_tpl;
	/** 4.0.2表示按小时算加班工资*/
    private String overtime_salary_tpl;
	/** 1:按小时计费；0:按工天*/
    private int hour_type;

    public String getOvertime_salary_tpl() {
        return overtime_salary_tpl;
    }

    public void setOvertime_salary_tpl(String overtime_salary_tpl) {
        this.overtime_salary_tpl = overtime_salary_tpl;
    }

    public int getHour_type() {
        return hour_type;
    }

    public void setHour_type(int hour_type) {
        this.hour_type = hour_type;
    }

    public double getO_s_tpl() {
		return o_s_tpl;
	}

	public void setO_s_tpl(double o_s_tpl) {
		this.o_s_tpl = o_s_tpl;
	}

	public double getS_tpl() {
		return s_tpl;
	}

	public void setS_tpl(double s_tpl) {
		this.s_tpl = s_tpl;
	}

	public double getW_h_tpl() {
		return w_h_tpl;
	}

	public void setW_h_tpl(double w_h_tpl) {
		this.w_h_tpl = w_h_tpl;
	}

	public double getO_h_tpl() {
		return o_h_tpl;
	}

	public void setO_h_tpl(double o_h_tpl) {
		this.o_h_tpl = o_h_tpl;
	}

	public double getChoose_w_h_tpl() {
		return choose_w_h_tpl;
	}

	public void setChoose_w_h_tpl(double choose_w_h_tpl) {
		this.choose_w_h_tpl = choose_w_h_tpl;
	}

	public double getChoose_o_h_tpl() {
		return choose_o_h_tpl;
	}

	public void setChoose_o_h_tpl(double choose_o_h_tpl) {
		this.choose_o_h_tpl = choose_o_h_tpl;
	}

	public String getIs_diff() {
		return is_diff;
	}

	public void setIs_diff(String is_diff) {
		this.is_diff = is_diff;
	}

	@Override
	public String toString() {
		return "Salary{" +
				"s_tpl=" + s_tpl +
				", w_h_tpl=" + w_h_tpl +
				", o_h_tpl=" + o_h_tpl +
				", choose_w_h_tpl=" + choose_w_h_tpl +
				", choose_o_h_tpl=" + choose_o_h_tpl +
				", is_diff='" + is_diff + '\'' +
				", o_s_tpl=" + o_s_tpl +
				", overtime_salary_tpl='" + overtime_salary_tpl + '\'' +
				", hour_type=" + hour_type +
				'}';
	}
}
