package com.jizhi.jlongg.calener_week;

import android.support.annotation.NonNull;

import org.joda.time.LocalDate;

/**
 * Created by Blaz Solar on 26/04/15.
 */
public interface Formatter {

    String getDayName(@NonNull LocalDate date);
    String getHeaderText(int type, @NonNull LocalDate from, @NonNull LocalDate to);

}
