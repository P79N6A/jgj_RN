package com.jizhi.jlongg.main.bean.status;

import com.google.gson.Gson;
import com.jizhi.jlongg.main.bean.BaseNetBean;

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
public class CommonJson<T> extends BaseNetBean {

    private T values;
    private T result;

    public T getResult() {
        return result;
    }

    public void setResult(T result) {
        this.result = result;
    }

    public T getValues() {
        return values;
    }

    public void setValues(T values) {
        this.values = values;
    }

    public static CommonJson fromJson(String json, Class clazz) {
        Gson gson = new Gson();
        Type objectType = type(CommonJson.class, clazz);
        return gson.fromJson(json, objectType);
    }

    public String toJson(Class<T> clazz) {
        Gson gson = new Gson();
        Type objectType = type(CommonJson.class, clazz);
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


}
