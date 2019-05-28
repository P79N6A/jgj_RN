/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package com.alibaba.sdk.android.oss.model;

/**
 * 包含向OSS上传Multipart分块（Part）的结果信息。
 *
 */
public class UploadPartResult extends OSSResult {

    private String eTag;

    /**
     * 构造函数。
     */
    public UploadPartResult(){
    }

    /**
     * 返回OSS生成的ETag值。
     * <p>
     * OSS 会将服务器端收到 Part 数据的 MD5 值放在 ETag 头内返回给用户。为了
     * 保证数据在网络传输过程中不出现错误，强烈推荐用户在收到 OSS的返回请求后，
     * 用该MD5值验证上传数据的正确性。
     * </p>
     * @return ETag值。
     */
    public String getETag() {
        return eTag;
    }

    /**
     * 设置OSS生成的ETag值。
     * <p>
     * OSS 会将服务器端收到 Part 数据的 MD5 值放在 ETag 头内返回给用户。为了
     * 保证数据在网络传输过程中不出现错误，强烈推荐用户在收到 OSS的返回请求后，
     * 用该MD5值验证上传数据的正确性。
     * </p>
     * @param eTag
     *          ETag值。
     */
    public void setETag(String eTag) {
        this.eTag = eTag;
    }
}
