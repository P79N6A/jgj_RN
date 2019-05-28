package com.jizhi.jlongg.main.bean.status;

import com.google.gson.Gson;
import com.jizhi.jlongg.main.bean.BaseNetNewBean;

import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;

/**
 * 对象的基类
 *
 * @param <T>
 * @author Xuj
 * @time 2016-2-2 10:30:33
 * @Version 1.0
 */
public class CommonNewJson<T> extends BaseNetNewBean {

    private T result;


    public static CommonNewJson fromJson(String json, Class clazz) {
        Gson gson = new Gson();
        Type objectType = type(CommonNewJson.class, clazz);
        return gson.fromJson(json, objectType);
    }

    public String toJson(Class<T> clazz) {
        Gson gson = new Gson();
        Type objectType = type(CommonNewJson.class, clazz);
        return gson.toJson(this, objectType);
    }

    static ParameterizedType type(final Class raw, final Type... args) {
        return new ParameterizedType() {
            public Type getRawType() {
                return raw;
            }

            public Type[] getActualTypeArguments() {
                return args;
            }

            public Type getOwnerType() {
                return null;
            }
        };
    }

    public T getResult() {
        return result;
    }

    public void setResult(T result) {
        this.result = result;
    }
}
