/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-04-04 16:26:13 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-18 17:33:44
 * Module:已实名、已认证、突击队弹框
 */

import React, { Component } from 'React'
import { View, Text, Image, StyleSheet, TouchableOpacity, Modal, Platform, NativeModules } from 'react-native'
import Icon from "react-native-vector-icons/iconfont";
import { Global } from '@jest/types';
export default class bottomalert extends Component {
    constructor(props) {
        super(props)
        this.state = {
        }
    }
    render() {
        param = this.props.param
        return (
            <Modal visible={this.props.ifOpenAlert}
                animationType="none"//从底部划出
                transparent={true}//透明蒙层
                onRequestClose={() => this.props.alertFunr()}//点击返回的回调函数
                style={{ height: '100%', flexDirection: "row", justifyContent: 'center', alignItems: 'center' }}
            >
                <TouchableOpacity activeOpacity={.7}
                    activeOpacity={1}
                    onPress={() => this.props.alertFunr()}
                    style={{ flex: 1, backgroundColor: 'rgba(0,0,0,.5)', position: 'absolute' }}>
                </TouchableOpacity>
                <TouchableOpacity activeOpacity={.7}
                    activeOpacity={1}
                    onPress={() => this.props.alertFunr()}
                    style={{
                        position: 'relative',
                        flex: 1,
                        flexDirection: 'row',
                        justifyContent: 'center',
                        alignItems: 'center',
                        backgroundColor: 'rgba(0,0,0,.5)'
                    }}
                >
                    {/* 弹窗内容 */}
                    {
                        GLOBAL.userinfo.uid ? (
                            this.props.param == 'information-sm' ? (
                                // 首页-信息-实名标签
                                GLOBAL.userinfo.verified == 3 ? (
                                    // 我已实名
                                    <TouchableOpacity activeOpacity={.7}
                                        activeOpacity={1}
                                        style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 300 }}>
                                        <View style={{ padding: 16.5 }}>
                                            <Text style={{ color: '#68d672', fontSize: 18.7, lineHeight: 28.1, textAlign: 'center' }}>该信息由用户实名发布</Text>
                                            <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证真实性</Text>

                                        </View>

                                        {/* 按钮 */}
                                        <View style={{
                                            flexDirection: 'row', alignItems: 'center',
                                            borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                        }}>
                                            <TouchableOpacity activeOpacity={.7}
                                                onPress={() => this.props.alertFunr()}
                                                style={{
                                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                    borderRightWidth: 1, borderRightColor: '#ebebeb', width: '100%', height: '100%'
                                                }}>
                                                <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>我知道了</Text>
                                            </TouchableOpacity>
                                        </View>
                                    </TouchableOpacity>
                                ) : (
                                        // 我未实名
                                        <TouchableOpacity activeOpacity={.7}
                                            activeOpacity={1}
                                            style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 300 }}>
                                            <View style={{ padding: 16.5 }}>
                                                <Text style={{ color: '#68d672', fontSize: 18.7, lineHeight: 28.1, textAlign: 'center' }}>该信息由用户实名发布</Text>
                                                <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证真实性</Text>

                                                <View style={{ marginTop: 22 }}>
                                                    <View
                                                        style={{
                                                            marginBottom: 11, flexDirection: 'row',
                                                            alignItems: 'center', justifyContent: 'space-around'
                                                        }}>
                                                        <View style={{ width: 50, height: 2, backgroundColor: '#ebebeb' }}></View>
                                                        <Text style={{ fontSize: 14.3, color: '#000', lineHeight: 21.5, fontWeight: '400' }}>通过实名认证的好处</Text>
                                                        <View style={{ width: 50, height: 2, backgroundColor: '#ebebeb' }}></View>
                                                    </View>

                                                    <View style={{ flexDirection: 'row', alignItems: 'center', height: 33 }}>
                                                        <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: '#000', marginLeft: 8, marginRight: 8 }}></View>
                                                        <Text style={{ color: '#000', fontSize: 16.5 }}>可联系招工找活</Text>
                                                    </View>

                                                    <View style={{ flexDirection: 'row', alignItems: 'center', height: 33 }}>
                                                        <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: '#000', marginLeft: 8, marginRight: 8 }}></View>
                                                        <Text style={{ color: '#000', fontSize: 16.5 }}>有利于找回账号</Text>
                                                    </View>

                                                    <View style={{ flexDirection: 'row', alignItems: 'center', height: 33 }}>
                                                        <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: '#000', marginLeft: 8, marginRight: 8 }}></View>
                                                        <Text style={{ color: '#000', fontSize: 16.5 }}>提高账户安全性</Text>
                                                    </View>
                                                </View>
                                            </View>

                                            {/* 按钮 */}
                                            <View style={{
                                                flexDirection: 'row', alignItems: 'center',
                                                borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                            }}>
                                                <TouchableOpacity activeOpacity={.7}
                                                    onPress={() => this.props.alertFunr()}
                                                    style={{
                                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                        borderRightWidth: 1, borderRightColor: '#ebebeb', width: '50%', height: '100%'
                                                    }}>
                                                    <Text style={{ color: '#000', fontSize: 16.5 }}>我知道了</Text>
                                                </TouchableOpacity>
                                                <TouchableOpacity activeOpacity={.7}
                                                    onPress={() => this.toAuthen()}
                                                    style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, height: '100%' }}>
                                                    <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>我也去认证</Text>
                                                    {/* 找活招工列表*/}
                                                </TouchableOpacity>
                                            </View>
                                        </TouchableOpacity>
                                    )
                            ) : (
                                    this.props.param == 'user-sm' ? (
                                        // 找工人、名片-用户-实名标签
                                        GLOBAL.userinfo.verified == 3 ? (
                                            // 我已实名
                                            <TouchableOpacity activeOpacity={.7}
                                                activeOpacity={1}
                                                style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 300 }}>
                                                <View style={{ padding: 16.5 }}>
                                                    <Text style={{ color: '#68d672', fontSize: 18.7, lineHeight: 28.1, textAlign: 'center' }}>该用户已通过实名认证</Text>
                                                    <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证真实性</Text>

                                                </View>

                                                {/* 按钮 */}
                                                <View style={{
                                                    flexDirection: 'row', alignItems: 'center',
                                                    borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                }}>
                                                    <TouchableOpacity activeOpacity={.7}
                                                        onPress={() => this.props.alertFunr()}
                                                        style={{
                                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                            borderRightWidth: 1, borderRightColor: '#ebebeb', width: '100%', height: '100%'
                                                        }}>
                                                        <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>我知道了</Text>
                                                    </TouchableOpacity>
                                                </View>
                                            </TouchableOpacity>
                                        ) : (
                                                // 我未实名
                                                <TouchableOpacity activeOpacity={.7}
                                                    activeOpacity={1}
                                                    style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 300 }}>
                                                    <View style={{ padding: 16.5 }}>
                                                        <Text style={{ color: '#68d672', fontSize: 18.7, lineHeight: 28.1, textAlign: 'center' }}>该用户已通过实名认证</Text>
                                                        <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证真实性</Text>

                                                        <View style={{ marginTop: 22 }}>
                                                            <View
                                                                style={{
                                                                    marginBottom: 11, flexDirection: 'row',
                                                                    alignItems: 'center', justifyContent: 'space-around'
                                                                }}>
                                                                <View style={{ width: 50, height: 2, backgroundColor: '#ebebeb' }}></View>
                                                                <Text style={{ fontSize: 14.3, color: '#000', lineHeight: 21.5, fontWeight: '400' }}>通过实名认证的好处</Text>
                                                                <View style={{ width: 50, height: 2, backgroundColor: '#ebebeb' }}></View>
                                                            </View>

                                                            <View style={{ flexDirection: 'row', alignItems: 'center', height: 33 }}>
                                                                <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: '#000', marginLeft: 8, marginRight: 8 }}></View>
                                                                <Text style={{ color: '#000', fontSize: 16.5 }}>可联系招工找活</Text>
                                                            </View>

                                                            <View style={{ flexDirection: 'row', alignItems: 'center', height: 33 }}>
                                                                <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: '#000', marginLeft: 8, marginRight: 8 }}></View>
                                                                <Text style={{ color: '#000', fontSize: 16.5 }}>有利于找回账号</Text>
                                                            </View>

                                                            <View style={{ flexDirection: 'row', alignItems: 'center', height: 33 }}>
                                                                <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: '#000', marginLeft: 8, marginRight: 8 }}></View>
                                                                <Text style={{ color: '#000', fontSize: 16.5 }}>提高账户安全性</Text>
                                                            </View>
                                                        </View>
                                                    </View>

                                                    {/* 按钮 */}
                                                    <View style={{
                                                        flexDirection: 'row', alignItems: 'center',
                                                        borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                    }}>
                                                        <TouchableOpacity activeOpacity={.7}
                                                            onPress={() => this.props.alertFunr()}
                                                            style={{
                                                                flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                borderRightWidth: 1, borderRightColor: '#ebebeb', width: '50%', height: '100%'
                                                            }}>
                                                            <Text style={{ color: '#000', fontSize: 16.5 }}>我知道了</Text>
                                                        </TouchableOpacity>
                                                        <TouchableOpacity activeOpacity={.7}
                                                            onPress={() => this.toAuthen()}
                                                            style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, height: '100%' }}>
                                                            <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>我也去认证</Text>
                                                        </TouchableOpacity>
                                                    </View>
                                                </TouchableOpacity>
                                            )
                                    ) : (
                                            this.props.param == 'user-rz-bz' ? (
                                                // 优质劳务-班组-用户-认证标签
                                                GLOBAL.userinfo.verified == 3 ? (
                                                    GLOBAL.userinfo.verified_arr.foreman == 1 ? (
                                                        // 我已实名认证-已班组认证
                                                        <TouchableOpacity activeOpacity={.7}
                                                            activeOpacity={1}
                                                            style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 320 }}>
                                                            <View style={{ padding: 16.5 }}>
                                                                <Text style={{ color: '#68d672', fontSize: 18.7, lineHeight: 28.1, textAlign: 'center' }}>该用户已通过班组长认证</Text>
                                                                <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证真实性</Text>
                                                                <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证与真人对比照片</Text>
                                                                <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其在本平台未被曝光</Text>
                                                            </View>

                                                            {/* 按钮 */}
                                                            <View style={{
                                                                flexDirection: 'row', alignItems: 'center',
                                                                borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                            }}>
                                                                <TouchableOpacity activeOpacity={.7}
                                                                    onPress={() => this.props.alertFunr()}
                                                                    style={{
                                                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                        borderRightWidth: 1, borderRightColor: '#ebebeb', width: '100%', height: '100%'
                                                                    }}>
                                                                    <Text style={{ color: '#000', fontSize: 16.5 }}>我知道了</Text>
                                                                </TouchableOpacity>

                                                            </View>
                                                        </TouchableOpacity>
                                                    ) : (
                                                            // 我已实名认证-未班组认证
                                                            <TouchableOpacity activeOpacity={.7}
                                                                activeOpacity={1}
                                                                style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 320 }}>
                                                                <View style={{ padding: 16.5 }}>
                                                                    <Text style={{ color: '#68d672', fontSize: 18.7, lineHeight: 28.1, textAlign: 'center' }}>该用户已通过班组长认证</Text>
                                                                    <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证真实性</Text>
                                                                    <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证与真人对比照片</Text>
                                                                    <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其在本平台未被曝光</Text>
                                                                </View>

                                                                <View style={{ marginTop: 22 }}>
                                                                    <View
                                                                        style={{
                                                                            marginBottom: 11, flexDirection: 'row',
                                                                            alignItems: 'center', justifyContent: 'space-around'
                                                                        }}>
                                                                        <View style={{ width: 50, height: 2, backgroundColor: '#ebebeb' }}></View>
                                                                        <Text style={{ fontSize: 14.3, color: '#000', lineHeight: 21.5, fontWeight: '400' }}>通过班组长认证的好处</Text>
                                                                        <View style={{ width: 50, height: 2, backgroundColor: '#ebebeb' }}></View>
                                                                    </View>

                                                                    <View style={{ flexDirection: 'row', alignItems: 'center', height: 33 }}>
                                                                        <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: '#000', marginLeft: 8, marginRight: 8 }}></View>
                                                                        <Text style={{ color: '#000', fontSize: 16.5 }}>大大提高你的可信度</Text>
                                                                    </View>

                                                                    <View style={{ flexDirection: 'row', alignItems: 'center', height: 33, flexWrap: "wrap" }}>
                                                                        <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: '#000', marginLeft: 8, marginRight: 8 }}></View>
                                                                        <Text style={{ color: '#000', fontSize: 16.5 }}>优先匹配项目</Text>
                                                                    </View>

                                                                    <View style={{ flexDirection: 'row', alignItems: 'center', height: 33, flexWrap: "wrap" }}>
                                                                        <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: '#000', marginLeft: 8, marginRight: 8 }}></View>
                                                                        <Text style={{ color: '#000', fontSize: 16.5 }}>获得广告宣传等高级服务</Text>
                                                                    </View>

                                                                </View>

                                                                {/* 按钮 */}
                                                                <View style={{
                                                                    flexDirection: 'row', alignItems: 'center',
                                                                    borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                                }}>
                                                                    <TouchableOpacity activeOpacity={.7}
                                                                        onPress={() => this.props.alertFunr()}
                                                                        style={{
                                                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                            borderRightWidth: 1, borderRightColor: '#ebebeb', width: '50%', height: '100%'
                                                                        }}>
                                                                        <Text style={{ color: '#000', fontSize: 16.5 }}>我知道了</Text>
                                                                    </TouchableOpacity>
                                                                    <TouchableOpacity activeOpacity={.7}
                                                                        onPress={() => this.tobzrz()}
                                                                        style={{
                                                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                            borderRightWidth: 1, borderRightColor: '#ebebeb', flex: 1, height: '100%'
                                                                        }}>
                                                                        <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>我也要认证</Text>
                                                                    </TouchableOpacity>

                                                                </View>
                                                            </TouchableOpacity>
                                                        )
                                                ) : (
                                                        // 我未实名认证
                                                        <TouchableOpacity activeOpacity={.7}
                                                            activeOpacity={1}
                                                            style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 320 }}>
                                                            <View style={{ padding: 16.5 }}>
                                                                <Text style={{ color: '#68d672', fontSize: 18.7, lineHeight: 28.1, textAlign: 'center' }}>该用户已通过班组长认证</Text>
                                                                <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证真实性</Text>
                                                                <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证与真人对比照片</Text>
                                                                <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其在本平台未被曝光</Text>

                                                                <View style={{ marginTop: 22 }}>
                                                                    <View
                                                                        style={{
                                                                            marginBottom: 11, flexDirection: 'row',
                                                                            alignItems: 'center', justifyContent: 'space-around'
                                                                        }}>
                                                                        <View style={{ width: 50, height: 2, backgroundColor: '#ebebeb' }}></View>
                                                                        <Text style={{ fontSize: 14.3, color: '#000', lineHeight: 21.5, fontWeight: '400' }}>通过班组长认证的好处</Text>
                                                                        <View style={{ width: 50, height: 2, backgroundColor: '#ebebeb' }}></View>
                                                                    </View>

                                                                    <View style={{ flexDirection: 'row', alignItems: 'center', height: 33 }}>
                                                                        <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: '#000', marginLeft: 8, marginRight: 8 }}></View>
                                                                        <Text style={{ color: '#000', fontSize: 16.5 }}>大大提高你的可信度</Text>
                                                                    </View>

                                                                    <View style={{ flexDirection: 'row', alignItems: 'center', height: 33, flexWrap: "wrap" }}>
                                                                        <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: '#000', marginLeft: 8, marginRight: 8 }}></View>
                                                                        <Text style={{ color: '#000', fontSize: 16.5 }}>优先匹配项目</Text>
                                                                    </View>

                                                                    <View style={{ flexDirection: 'row', alignItems: 'center', height: 33, flexWrap: "wrap" }}>
                                                                        <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: '#000', marginLeft: 8, marginRight: 8 }}></View>
                                                                        <Text style={{ color: '#000', fontSize: 16.5 }}>获得广告宣传等高级服务</Text>
                                                                    </View>

                                                                </View>
                                                            </View>

                                                            {/* 按钮 */}
                                                            <View style={{
                                                                flexDirection: 'row', alignItems: 'center',
                                                                borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                            }}>
                                                                <TouchableOpacity activeOpacity={.7}
                                                                    onPress={() => this.props.alertFunr()}
                                                                    style={{
                                                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                        borderRightWidth: 1, borderRightColor: '#ebebeb', width: '50%', height: '100%'
                                                                    }}>
                                                                    <Text style={{ color: '#000', fontSize: 16.5 }}>我知道了</Text>
                                                                </TouchableOpacity>
                                                                <TouchableOpacity activeOpacity={.7}
                                                                    onPress={() => this.toAuthenRz(2)}
                                                                    style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, height: '100%' }}>
                                                                    <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>我也要认证</Text>
                                                                </TouchableOpacity>
                                                            </View>
                                                        </TouchableOpacity>
                                                    )
                                            ) : (
                                                    this.props.param == 'user-rz-gr' ? (
                                                        // 优质劳务-工人-用户-认证标签
                                                        GLOBAL.userinfo.verified == 3 ? (
                                                            GLOBAL.userinfo.verified_arr.worker == 1 ? (
                                                                // 我已实名认证-已工人认证
                                                                <TouchableOpacity activeOpacity={.7}
                                                                    activeOpacity={1}
                                                                    style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 320 }}>
                                                                    <View style={{ padding: 16.5 }}>
                                                                        <Text style={{ color: '#68d672', fontSize: 18.7, lineHeight: 28.1, textAlign: 'center' }}>该用户已通过工人认证</Text>
                                                                        <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证真实性</Text>
                                                                        <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证与真人对比照片</Text>
                                                                        <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其在本平台未被曝光</Text>
                                                                    </View>

                                                                    {/* 按钮 */}
                                                                    <View style={{
                                                                        flexDirection: 'row', alignItems: 'center',
                                                                        borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                                    }}>
                                                                        <TouchableOpacity activeOpacity={.7}
                                                                            onPress={() => this.props.alertFunr()}
                                                                            style={{
                                                                                flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                                borderRightWidth: 1, borderRightColor: '#ebebeb', width: '100%', height: '100%'
                                                                            }}>
                                                                            <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>我知道了</Text>
                                                                        </TouchableOpacity>
                                                                    </View>
                                                                </TouchableOpacity>
                                                            ) : (
                                                                    // 我已实名认证-未工人认证
                                                                    <TouchableOpacity activeOpacity={.7}
                                                                        activeOpacity={1}
                                                                        style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 320 }}>
                                                                        <View style={{ padding: 16.5 }}>
                                                                            <Text style={{ color: '#68d672', fontSize: 18.7, lineHeight: 28.1, textAlign: 'center' }}>该用户已通过工人认证</Text>
                                                                            <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证真实性</Text>
                                                                            <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证与真人对比照片</Text>
                                                                            <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其在本平台未被曝光</Text>
                                                                        </View>

                                                                        {/* 按钮 */}
                                                                        <View style={{
                                                                            flexDirection: 'row', alignItems: 'center',
                                                                            borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                                        }}>
                                                                            <TouchableOpacity activeOpacity={.7}
                                                                                onPress={() => this.props.alertFunr()}
                                                                                style={{
                                                                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                                    borderRightWidth: 1, borderRightColor: '#ebebeb', width: '50%', height: '100%'
                                                                                }}>
                                                                                <Text style={{ color: '#000', fontSize: 16.5 }}>我知道了</Text>
                                                                            </TouchableOpacity>

                                                                            <TouchableOpacity activeOpacity={.7}
                                                                                onPress={() => this.toGrRz()}
                                                                                style={{
                                                                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                                    borderRightWidth: 1, borderRightColor: '#ebebeb', height: '100%', flex: 1
                                                                                }}>
                                                                                <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>我也去认证</Text>
                                                                            </TouchableOpacity>
                                                                        </View>
                                                                    </TouchableOpacity>
                                                                )
                                                        ) : (
                                                                // 我未实名认证
                                                                <TouchableOpacity activeOpacity={.7}
                                                                    activeOpacity={1}
                                                                    style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 320 }}>
                                                                    <View style={{ padding: 16.5 }}>
                                                                        <Text style={{ color: '#68d672', fontSize: 18.7, lineHeight: 28.1, textAlign: 'center' }}>该用户已通过工人认证</Text>
                                                                        <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证真实性</Text>
                                                                        <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证与真人对比照片</Text>
                                                                        <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其在本平台未被曝光</Text>

                                                                        <View style={{ marginTop: 22 }}>
                                                                            <View
                                                                                style={{
                                                                                    marginBottom: 11, flexDirection: 'row',
                                                                                    alignItems: 'center', justifyContent: 'space-around'
                                                                                }}>
                                                                                <View style={{ width: 50, height: 2, backgroundColor: '#ebebeb' }}></View>
                                                                                <Text style={{ fontSize: 14.3, color: '#000', lineHeight: 21.5, fontWeight: '400' }}>通过工人认证的好处</Text>
                                                                                <View style={{ width: 50, height: 2, backgroundColor: '#ebebeb' }}></View>
                                                                            </View>

                                                                            <View style={{ flexDirection: 'row', alignItems: 'center', height: 33 }}>
                                                                                <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: '#000', marginLeft: 8, marginRight: 8 }}></View>
                                                                                <Text style={{ color: '#000', fontSize: 16.5 }}>大大提高你的可信度</Text>
                                                                            </View>

                                                                            <View style={{ flexDirection: 'row', alignItems: 'center', height: 33, flexWrap: "wrap" }}>
                                                                                <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: '#000', marginLeft: 8, marginRight: 8 }}></View>
                                                                                <Text style={{ color: '#000', fontSize: 16.5 }}>优先匹配项目</Text>
                                                                            </View>

                                                                            <View style={{ flexDirection: 'row', alignItems: 'center', height: 33, flexWrap: "wrap" }}>
                                                                                <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: '#000', marginLeft: 8, marginRight: 8 }}></View>
                                                                                <Text style={{ color: '#000', fontSize: 16.5 }}>获得广告宣传等高级服务</Text>
                                                                            </View>

                                                                        </View>
                                                                    </View>

                                                                    {/* 按钮 */}
                                                                    <View style={{
                                                                        flexDirection: 'row', alignItems: 'center',
                                                                        borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                                    }}>
                                                                        <TouchableOpacity activeOpacity={.7}
                                                                            onPress={() => this.props.alertFunr()}
                                                                            style={{
                                                                                flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                                borderRightWidth: 1, borderRightColor: '#ebebeb', width: '50%', height: '100%'
                                                                            }}>
                                                                            <Text style={{ color: '#000', fontSize: 16.5 }}>我知道了</Text>
                                                                        </TouchableOpacity>
                                                                        <TouchableOpacity activeOpacity={.7}
                                                                            onPress={() => this.toAuthenRz(1)}
                                                                            style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, height: '100%' }}>
                                                                            <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>我也要认证</Text>
                                                                        </TouchableOpacity>
                                                                    </View>
                                                                </TouchableOpacity>
                                                            )
                                                    ) : (
                                                            this.props.param == 'user-tj' ? (
                                                                // 优质劳务-用户-突击队标签
                                                                GLOBAL.userinfo.verified == 3 ? (
                                                                    GLOBAL.userinfo.is_commando == 1 ? (
                                                                        // 我已通过实名认证-通过突击队认证
                                                                        <TouchableOpacity activeOpacity={.7}
                                                                            activeOpacity={1}
                                                                            style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 320 }}>
                                                                            <View style={{ padding: 16.5 }}>
                                                                                <Text style={{ color: '#68d672', fontSize: 18.7, lineHeight: 28.1, textAlign: 'center' }}>该用户已通过突击队认证</Text>
                                                                                <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证真实性</Text>
                                                                                <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证与真人对比照片</Text>

                                                                            </View>

                                                                            {/* 按钮 */}
                                                                            <View style={{
                                                                                flexDirection: 'row', alignItems: 'center',
                                                                                borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                                            }}>
                                                                                <TouchableOpacity activeOpacity={.7}
                                                                                    onPress={() => this.props.alertFunr()}
                                                                                    style={{
                                                                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                                        borderRightWidth: 1, borderRightColor: '#ebebeb', width: '100%', height: '100%'
                                                                                    }}>
                                                                                    <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>我知道了</Text>
                                                                                </TouchableOpacity>
                                                                            </View>
                                                                        </TouchableOpacity>
                                                                    ) : (
                                                                            // 我已实名认证-未突击队认证
                                                                            <TouchableOpacity activeOpacity={.7}
                                                                                activeOpacity={1}
                                                                                style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 320 }}>
                                                                                <View style={{ padding: 16.5 }}>
                                                                                    <Text style={{ color: '#68d672', fontSize: 18.7, lineHeight: 28.1, textAlign: 'center' }}>该用户已通过突击队认证</Text>
                                                                                    <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证真实性</Text>
                                                                                    <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证与真人对比照片</Text>

                                                                                    <View style={{ marginTop: 22 }}>
                                                                                        <View
                                                                                            style={{
                                                                                                marginBottom: 11, flexDirection: 'row',
                                                                                                alignItems: 'center', justifyContent: 'space-around'
                                                                                            }}>
                                                                                            <View style={{ width: 50, height: 2, backgroundColor: '#ebebeb' }}></View>
                                                                                            <Text style={{ fontSize: 14.3, color: '#000', lineHeight: 21.5, fontWeight: '400' }}>通过此认证的好处</Text>
                                                                                            <View style={{ width: 50, height: 2, backgroundColor: '#ebebeb' }}></View>
                                                                                        </View>

                                                                                        <View style={{ flexDirection: 'row', alignItems: 'center', height: 33 }}>
                                                                                            <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: '#000', marginLeft: 8, marginRight: 8 }}></View>
                                                                                            <Text style={{ color: '#000', fontSize: 16.5 }}>可优先联系突击队工作</Text>
                                                                                        </View>

                                                                                        <View style={{ flexDirection: 'row', alignItems: 'center', height: 33 }}>
                                                                                            <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: '#000', marginLeft: 8, marginRight: 8 }}></View>
                                                                                            <Text style={{ color: '#000', fontSize: 16.5 }}>招工方可通过"优质突击队"直接找到你</Text>
                                                                                        </View>
                                                                                    </View>
                                                                                </View>

                                                                                {/* 按钮 */}
                                                                                <View style={{
                                                                                    flexDirection: 'row', alignItems: 'center',
                                                                                    borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                                                }}>
                                                                                    <TouchableOpacity activeOpacity={.7}
                                                                                        onPress={() => this.props.alertFunr()}
                                                                                        style={{
                                                                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                                            borderRightWidth: 1, borderRightColor: '#ebebeb', width: '50%', height: '100%'
                                                                                        }}>
                                                                                        <Text style={{ color: '#000', fontSize: 16.5 }}>我知道了</Text>
                                                                                    </TouchableOpacity>
                                                                                    <TouchableOpacity activeOpacity={.7}
                                                                                        onPress={() => this.tjrzGod()}
                                                                                        style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, height: '100%' }}>
                                                                                        <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>我也去认证</Text>
                                                                                    </TouchableOpacity>
                                                                                </View>
                                                                            </TouchableOpacity>
                                                                        )
                                                                ) : (
                                                                        // 我未实名认证
                                                                        <TouchableOpacity activeOpacity={.7}
                                                                            activeOpacity={1}
                                                                            style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 320 }}>
                                                                            <View style={{ padding: 16.5 }}>
                                                                                <Text style={{ color: '#68d672', fontSize: 18.7, lineHeight: 28.1, textAlign: 'center' }}>该用户已通过突击队认证</Text>
                                                                                <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证真实性</Text>
                                                                                <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证与真人对比照片</Text>

                                                                                <View style={{ marginTop: 22 }}>
                                                                                    <View
                                                                                        style={{
                                                                                            marginBottom: 11, flexDirection: 'row',
                                                                                            alignItems: 'center', justifyContent: 'space-around'
                                                                                        }}>
                                                                                        <View style={{ width: 50, height: 2, backgroundColor: '#ebebeb' }}></View>
                                                                                        <Text style={{ fontSize: 14.3, color: '#000', lineHeight: 21.5, fontWeight: '400' }}>通过此认证的好处</Text>
                                                                                        <View style={{ width: 50, height: 2, backgroundColor: '#ebebeb' }}></View>
                                                                                    </View>

                                                                                    <View style={{ flexDirection: 'row', alignItems: 'center', height: 33 }}>
                                                                                        <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: '#000', marginLeft: 8, marginRight: 8 }}></View>
                                                                                        <Text style={{ color: '#000', fontSize: 16.5 }}>可优先联系突击队工作</Text>
                                                                                    </View>

                                                                                    <View style={{ flexDirection: 'row', alignItems: 'center', height: 33 }}>
                                                                                        <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: '#000', marginLeft: 8, marginRight: 8 }}></View>
                                                                                        <Text style={{ color: '#000', fontSize: 16.5 }}>招工方可通过"优质突击队"直接找到你</Text>
                                                                                    </View>

                                                                                    <View style={{ marginTop: 10 }}>
                                                                                        <Text style={{ color: '#ff8a00', fontSize: 13, lineHeight: 19, flexWrap: "wrap" }}>为了建立完善可靠的招工找活系统，并增强你的账户安全性，申请突击队认证前需先通过实名认证</Text>
                                                                                    </View>
                                                                                </View>
                                                                            </View>

                                                                            {/* 按钮 */}
                                                                            <View style={{
                                                                                flexDirection: 'row', alignItems: 'center',
                                                                                borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                                            }}>
                                                                                <TouchableOpacity activeOpacity={.7}
                                                                                    onPress={() => this.props.alertFunr()}
                                                                                    style={{
                                                                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                                        borderRightWidth: 1, borderRightColor: '#ebebeb', width: '50%', height: '100%'
                                                                                    }}>
                                                                                    <Text style={{ color: '#000', fontSize: 16.5 }}>我知道了</Text>
                                                                                </TouchableOpacity>
                                                                                <TouchableOpacity activeOpacity={.7}
                                                                                    onPress={() => this.toAuthen()}
                                                                                    style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, height: '100%' }}>
                                                                                    <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>去实名认证</Text>
                                                                                </TouchableOpacity>
                                                                            </View>
                                                                        </TouchableOpacity>
                                                                    )
                                                            ) : (
                                                                    this.props.param == 'dy' ? (
                                                                        // 订阅弹窗
                                                                        this.props.is_subscibe ? (
                                                                            <TouchableOpacity activeOpacity={.7}
                                                                                activeOpacity={1}
                                                                                style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden',width:320 }}>
                                                                                <View style={{padding:14,flexDirection:"row",justifyContent:'center'}}>
                                                                                        <View style={{paddingTop:30,paddingBottom:30}}>
                                                                                            <View style={{flexDirection:"row",justifyContent:'flex-start'}}>
                                                                                                <Text style={{ color: '#666', fontSize: 16, lineHeight: 24, }}>
                                                                                                    你已订阅&nbsp;
                                                                                                </Text>
                                                                                                <Text style={{ color: '#000', fontSize: 16, lineHeight: 24, }}>
                                                                                                    {this.props.name.length > 3 ? this.props.name.substr(0, 3) + '...' : this.props.name}
                                                                                                </Text>
                                                                                                <Text style={{ color: '#666', fontSize: 16, lineHeight: 24, }}>
                                                                                                &nbsp;招工信息，当他发
                                                                                                </Text>
                                                                                            </View>
                                                                                            <View style={{flexDirection:"row",justifyContent:'flex-start'}}>
                                                                                                <Text style={{ color: '#666', fontSize: 16, lineHeight: 24, }}>
                                                                                                布新工作时，将及时通知你
                                                                                                </Text>
                                                                                            </View>
                                                                                        </View>
                                                                                    </View>

                                                                                {/* 按钮 */}
                                                                                <View style={{
                                                                                    flexDirection: 'row', alignItems: 'center',
                                                                                    borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                                                }}>
                                                                                    <TouchableOpacity activeOpacity={.7}
                                                                                        onPress={() => this.props.subscFun()}
                                                                                        style={{
                                                                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                                            borderRightWidth: 1, borderRightColor: '#ebebeb', width: '50%', height: '100%'
                                                                                        }}>
                                                                                        <Text style={{ color: '#000', fontSize: 16.5 }}>取消订阅</Text>
                                                                                    </TouchableOpacity>
                                                                                    <TouchableOpacity activeOpacity={.7}
                                                                                        onPress={() => this.props.alertFunr()}
                                                                                        style={{
                                                                                            flexDirection: 'row', alignItems: 'center',
                                                                                            justifyContent: 'center', flex: 1, height: '100%'
                                                                                        }}>
                                                                                        <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>保持订阅</Text>
                                                                                    </TouchableOpacity>
                                                                                </View>
                                                                            </TouchableOpacity>
                                                                        ) : (
                                                                                <TouchableOpacity activeOpacity={.7}
                                                                                    activeOpacity={1}
                                                                                    style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden',width:320 }}>
                                                                                    <View style={{padding:14,flexDirection:"row",justifyContent:'center'}}>
                                                                                        <View style={{paddingTop:30,paddingBottom:30}}>
                                                                                            <View style={{flexDirection:"row",justifyContent:'flex-start'}}>
                                                                                                <Text style={{ color: '#666', fontSize: 16, lineHeight: 24, }}>
                                                                                                    订阅后，
                                                                                                </Text>
                                                                                                <Text style={{ color: '#000', fontSize: 16, lineHeight: 24, }}>
                                                                                                    {this.props.name.length > 3 ? this.props.name.substr(0, 3) + '...' : this.props.name}
                                                                                                </Text>
                                                                                                <Text style={{ color: '#666', fontSize: 16, lineHeight: 24, }}>
                                                                                                    &nbsp;有新的招工信息发布
                                                                                                </Text>
                                                                                            </View>
                                                                                            <View style={{flexDirection:"row",justifyContent:'flex-start'}}>
                                                                                                <Text style={{ color: '#666', fontSize: 16, lineHeight: 24, }}>
                                                                                                    时，将及时通知你
                                                                                                </Text>
                                                                                            </View>
                                                                                        </View>
                                                                                    </View>

                                                                                    {/* 按钮 */}
                                                                                    <View style={{
                                                                                        flexDirection: 'row', alignItems: 'center',
                                                                                        borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                                                    }}>
                                                                                        <TouchableOpacity activeOpacity={.7}
                                                                                            onPress={() => this.props.alertFunr()}
                                                                                            style={{
                                                                                                flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                                                borderRightWidth: 1, borderRightColor: '#ebebeb', width: '50%', height: '100%'
                                                                                            }}>
                                                                                            <Text style={{ color: '#000', fontSize: 16.5 }}>取消</Text>
                                                                                        </TouchableOpacity>
                                                                                        <TouchableOpacity activeOpacity={.7}
                                                                                            onPress={() => this.props.subscFun()}
                                                                                            style={{
                                                                                                flexDirection: 'row', alignItems: 'center',
                                                                                                justifyContent: 'center', flex: 1, height: '100%'
                                                                                            }}>
                                                                                            <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>立即订阅</Text>
                                                                                        </TouchableOpacity>
                                                                                    </View>
                                                                                </TouchableOpacity>
                                                                            )
                                                                    ) : (
                                                                            // 点击发布招工，提示去实名认证
                                                                            this.props.param == 'fbzg' ? (
                                                                                <TouchableOpacity activeOpacity={.7}
                                                                                    activeOpacity={1}
                                                                                    style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 300 }}>
                                                                                    <View style={{ padding: 16.5 }}>
                                                                                        <Text style={{ color: 'rgb(21, 161, 83)', marginTop: 16, fontSize: 18.7, lineHeight: 28.1, textAlign: 'center' }}>招工信息发布成功</Text>
                                                                                        <Text style={{ marginTop: 10, color: '#666', marginBottom: 16, fontSize: 15.4, lineHeight: 23.1 }}>
                                                                                            你还未进行实名认证，认证后招工信息将会推荐给更多的工人
                                                                                        </Text>
                                                                                    </View>

                                                                                    {/* 按钮 */}
                                                                                    <View style={{
                                                                                        flexDirection: 'row', alignItems: 'center',
                                                                                        borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                                                    }}>
                                                                                        <TouchableOpacity activeOpacity={.7}
                                                                                            onPress={() => this.props.alertFunr()}
                                                                                            style={{
                                                                                                flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                                                borderRightWidth: 1, borderRightColor: '#ebebeb', width: '50%', height: '100%'
                                                                                            }}>
                                                                                            <Text style={{ color: '#000', fontSize: 16.5 }}>暂不认证</Text>
                                                                                        </TouchableOpacity>
                                                                                        <TouchableOpacity activeOpacity={.7}
                                                                                            onPress={() => this.toAuthen()}
                                                                                            style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, height: '100%' }}>
                                                                                            <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>立即认证</Text>
                                                                                        </TouchableOpacity>
                                                                                    </View>
                                                                                </TouchableOpacity>
                                                                            ) : (
                                                                                    // 提示去完善资料弹窗
                                                                                    this.props.param == 'wszl' ? (
                                                                                        <TouchableOpacity activeOpacity={.7}
                                                                                            activeOpacity={1}
                                                                                            style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 300 }}>
                                                                                            <View style={{ padding: 16.5 }}>
                                                                                                <Text style={{ marginTop: 10, color: '#666', marginBottom: 10, fontSize: 15.4, lineHeight: 23.1, textAlign: 'center' }}>
                                                                                                    {/* 为了工人能够快速联系到您，请先完善个人资料 */}
                                                                                                    进行下一步操作之前，需要请你完善个人资料
                                                                                    </Text>
                                                                                            </View>

                                                                                            {/* 按钮 */}
                                                                                            <View style={{
                                                                                                flexDirection: 'row', alignItems: 'center',
                                                                                                borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                                                            }}>
                                                                                                <TouchableOpacity activeOpacity={.7}
                                                                                                    onPress={() => this.props.gows()}
                                                                                                    style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, height: '100%' }}>
                                                                                                    <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>去完善资料</Text>
                                                                                                </TouchableOpacity>
                                                                                            </View>
                                                                                        </TouchableOpacity>
                                                                                    ) : (
                                                                                            // 去实名认证
                                                                                            this.props.param == 'smrz' ? (
                                                                                                <TouchableOpacity activeOpacity={.7}
                                                                                                    activeOpacity={1}
                                                                                                    style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 300 }}>
                                                                                                    <View style={{ padding: 16.5 }}>
                                                                                                        <Text style={{ marginTop: 10, color: '#666', marginBottom: 10, fontSize: 15.4, lineHeight: 23.1, textAlign: 'center' }}>
                                                                                                            进行下一步操作之前，需先完成实名认证
                                                                                                        </Text>
                                                                                                    </View>

                                                                                                    {/* 按钮 */}
                                                                                                    <View style={{
                                                                                                        flexDirection: 'row', alignItems: 'center',
                                                                                                        borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                                                                    }}>
                                                                                                        <TouchableOpacity activeOpacity={.7}
                                                                                                            onPress={() => this.toAuthen()}
                                                                                                            style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, height: '100%' }}>
                                                                                                            <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>马上去实名认证</Text>
                                                                                                        </TouchableOpacity>
                                                                                                    </View>
                                                                                                </TouchableOpacity>
                                                                                            ) : (
                                                                                                    this.props.param == 'smrz-call' ? (
                                                                                                        <TouchableOpacity activeOpacity={.7}
                                                                                                            activeOpacity={1}
                                                                                                            style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 300 }}>
                                                                                                            <View style={{ padding: 16.5 }}>
                                                                                                                <Text style={{ marginTop: 10, color: '#666', marginBottom: 10, fontSize: 15.4, lineHeight: 23.1, textAlign: 'center' }}>
                                                                                                                    为了提高招工方对您的信任度，请先完成实名认证
                                                                                                        </Text>
                                                                                                            </View>

                                                                                                            {/* 按钮 */}
                                                                                                            <View style={{
                                                                                                                flexDirection: 'row', alignItems: 'center',
                                                                                                                borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                                                                            }}>
                                                                                                                <TouchableOpacity activeOpacity={.7}
                                                                                                                    onPress={() => this.toAuthen()}
                                                                                                                    style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, height: '100%' }}>
                                                                                                                    <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>马上去实名认证</Text>
                                                                                                                </TouchableOpacity>
                                                                                                            </View>
                                                                                                        </TouchableOpacity>
                                                                                                    ) : (
                                                                                                            // 免费套餐已经用完
                                                                                                            this.props.param == 'status1' ? (

                                                                                                                <TouchableOpacity activeOpacity={.7}
                                                                                                                    activeOpacity={1}
                                                                                                                    style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 300 }}>
                                                                                                                    <View style={{ padding: 16.5 }}>
                                                                                                                        <Text style={{ marginTop: 10, color: '#666', marginBottom: 5, fontSize: 15.4, lineHeight: 23.1, textAlign: 'center' }}>
                                                                                                                            你的找活招工电话套餐已经用完
                                                                                                            </Text>
                                                                                                                        <Text style={{ color: '#666', marginBottom: 10, fontSize: 15.4, lineHeight: 23.1, textAlign: 'center' }}>
                                                                                                                            购买套餐后可继续拨打电话
                                                                                                            </Text>
                                                                                                                    </View>

                                                                                                                    {/* 按钮 */}
                                                                                                                    <View style={{
                                                                                                                        flexDirection: 'row', alignItems: 'center',
                                                                                                                        borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                                                                                    }}>
                                                                                                                        <TouchableOpacity activeOpacity={.7}
                                                                                                                            onPress={() => this.props.alertFunr()}
                                                                                                                            style={{
                                                                                                                                flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                                                                                borderRightWidth: 1, borderRightColor: '#ebebeb', width: '50%', height: '100%'
                                                                                                                            }}>
                                                                                                                            <Text style={{ color: '#000', fontSize: 16.5 }}>取消</Text>
                                                                                                                        </TouchableOpacity>
                                                                                                                        <TouchableOpacity activeOpacity={.7}
                                                                                                                            onPress={() => this.props.useup()}
                                                                                                                            style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, height: '100%' }}>
                                                                                                                            <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>购买套餐</Text>
                                                                                                                        </TouchableOpacity>
                                                                                                                    </View>
                                                                                                                </TouchableOpacity>
                                                                                                            ) : (
                                                                                                                    // 购买过的套餐已经用完
                                                                                                                    this.props.param == 'status2' ? (
                                                                                                                        <TouchableOpacity activeOpacity={.7}
                                                                                                                            activeOpacity={1}
                                                                                                                            style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 300 }}>
                                                                                                                            <View style={{ padding: 16.5 }}>
                                                                                                                                <Text style={{ marginTop: 10, color: '#666', marginBottom: 5, fontSize: 15.4, lineHeight: 23.1, textAlign: 'center' }}>
                                                                                                                                    你的找活招工电话套餐已经用完
                                                                                                                </Text>
                                                                                                                                <Text style={{ color: '#666', marginBottom: 10, fontSize: 15.4, lineHeight: 23.1, textAlign: 'center' }}>
                                                                                                                                    购买套餐后可继续拨打电话
                                                                                                                </Text>
                                                                                                                            </View>

                                                                                                                            {/* 按钮 */}
                                                                                                                            <View style={{
                                                                                                                                flexDirection: 'row', alignItems: 'center',
                                                                                                                                borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                                                                                            }}>
                                                                                                                                <TouchableOpacity activeOpacity={.7}
                                                                                                                                    onPress={() => this.props.alertFunr()}
                                                                                                                                    style={{
                                                                                                                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                                                                                        borderRightWidth: 1, borderRightColor: '#ebebeb', width: '50%', height: '100%'
                                                                                                                                    }}>
                                                                                                                                    <Text style={{ color: '#000', fontSize: 16.5 }}>取消</Text>
                                                                                                                                </TouchableOpacity>
                                                                                                                                <TouchableOpacity activeOpacity={.7}
                                                                                                                                    onPress={() => this.props.shopping()}
                                                                                                                                    style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, height: '100%' }}>
                                                                                                                                    <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>购买套餐</Text>
                                                                                                                                </TouchableOpacity>
                                                                                                                            </View>
                                                                                                                        </TouchableOpacity>
                                                                                                                    ) : (
                                                                                                                            // 可以分享获取次数
                                                                                                                            this.props.param == 'status3' ? (
                                                                                                                                <TouchableOpacity activeOpacity={.7}
                                                                                                                                    activeOpacity={1}
                                                                                                                                    style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 300 }}>
                                                                                                                                    <View style={{ padding: 16.5 }}>
                                                                                                                                        <Text style={{ marginTop: 10, color: '#666', marginBottom: 10, fontSize: 15.4, lineHeight: 23.1, textAlign: 'center' }}>
                                                                                                                                            分享"吉工家"给工地朋友，即可查看或拨打电话
                                                                                                                </Text>
                                                                                                                                    </View>

                                                                                                                                    {/* 按钮 */}
                                                                                                                                    <View style={{
                                                                                                                                        flexDirection: 'row', alignItems: 'center',
                                                                                                                                        borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                                                                                                    }}>
                                                                                                                                        <TouchableOpacity activeOpacity={.7}
                                                                                                                                            onPress={() => this.props.shareFriend()}
                                                                                                                                            style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, height: '100%' }}>
                                                                                                                                            <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>立即分享</Text>
                                                                                                                                        </TouchableOpacity>
                                                                                                                                    </View>
                                                                                                                                </TouchableOpacity>
                                                                                                                            ) : (
                                                                                                                                    // 分享成功，获得拨打电话次数
                                                                                                                                    this.props.param == 'status3end' ? (
                                                                                                                                        <TouchableOpacity activeOpacity={.7}
                                                                                                                                            activeOpacity={1}
                                                                                                                                            style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 300 }}>
                                                                                                                                            <View style={{ padding: 16.5 }}>
                                                                                                                                                <Text style={{ marginTop: 10, color: '#666', marginBottom: 10, fontSize: 15.4, lineHeight: 23.1, textAlign: 'center' }}>
                                                                                                                                                    恭喜你获得1个免费找活招工电话，该找活招工电话数仅限当月使用
                                                                                                                                        </Text>
                                                                                                                                            </View>

                                                                                                                                            {/* 按钮 */}
                                                                                                                                            <View style={{
                                                                                                                                                flexDirection: 'row', alignItems: 'center',
                                                                                                                                                borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                                                                                                            }}>
                                                                                                                                                <TouchableOpacity activeOpacity={.7}
                                                                                                                                                    onPress={() => this.props.shareFriendEnd()}
                                                                                                                                                    style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, height: '100%' }}>
                                                                                                                                                    <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>我知道了</Text>
                                                                                                                                                </TouchableOpacity>
                                                                                                                                            </View>
                                                                                                                                        </TouchableOpacity>
                                                                                                                                    ) : (
                                                                                                                                            // 完善资料并实名认证
                                                                                                                                            this.props.param == 'wszlandsmrz' ? (
                                                                                                                                                <TouchableOpacity activeOpacity={.7}
                                                                                                                                                    activeOpacity={1}
                                                                                                                                                    style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 300 }}>
                                                                                                                                                    <View style={{ padding: 16.5 }}>
                                                                                                                                                        <Text style={{ marginTop: 10, color: '#666', marginBottom: 10, fontSize: 15.4, lineHeight: 23.1, textAlign: 'center' }}>
                                                                                                                                                            进行下一步操作之前，需要请你完善个人资料并完成实名认证
                                                                                                                                                        </Text>
                                                                                                                                                    </View>

                                                                                                                                                    {/* 按钮 */}
                                                                                                                                                    <View style={{
                                                                                                                                                        flexDirection: 'row', alignItems: 'center',
                                                                                                                                                        borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                                                                                                                    }}>
                                                                                                                                                        <TouchableOpacity activeOpacity={.7}
                                                                                                                                                            onPress={() => this.props.gows()}
                                                                                                                                                            style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, height: '100%' }}>
                                                                                                                                                            <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>去完善资料</Text>
                                                                                                                                                        </TouchableOpacity>
                                                                                                                                                    </View>
                                                                                                                                                </TouchableOpacity>
                                                                                                                                            ) : (
                                                                                                                                                    // 完善资料并实名认证-拨打电话
                                                                                                                                                    this.props.param == 'wszlandsmrz-call' ? (
                                                                                                                                                        <TouchableOpacity activeOpacity={.7}
                                                                                                                                                            activeOpacity={1}
                                                                                                                                                            style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 300 }}>
                                                                                                                                                            <View style={{ padding: 16.5 }}>
                                                                                                                                                                <Text style={{ marginTop: 10, color: '#666', marginBottom: 10, fontSize: 15.4, lineHeight: 23.1, textAlign: 'center' }}>
                                                                                                                                                                    为了招工方更好的评估您的能力，请先完善资料
                                                                                                                                                                </Text>
                                                                                                                                                            </View>

                                                                                                                                                            {/* 按钮 */}
                                                                                                                                                            <View style={{
                                                                                                                                                                flexDirection: 'row', alignItems: 'center',
                                                                                                                                                                borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                                                                                                                            }}>
                                                                                                                                                                <TouchableOpacity activeOpacity={.7}
                                                                                                                                                                    onPress={() => this.props.gows()}
                                                                                                                                                                    style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, height: '100%' }}>
                                                                                                                                                                    <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>去完善资料</Text>
                                                                                                                                                                </TouchableOpacity>
                                                                                                                                                            </View>
                                                                                                                                                        </TouchableOpacity>
                                                                                                                                                    ) : this.props.param == 'user-rz-tj' ? (
                                                                                                                                                        // 我已实名认证
                                                                                                                                                        GLOBAL.userinfo.verified == 3 ? (
                                                                                                                                                            // 我已工人认证
                                                                                                                                                            GLOBAL.userinfo.verified_arr.worker == 1 ? (
                                                                                                                                                                // 我已实名认证-已工人认证
                                                                                                                                                                <TouchableOpacity activeOpacity={.7}
                                                                                                                                                                    activeOpacity={1}
                                                                                                                                                                    style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 320 }}>
                                                                                                                                                                    <View style={{ padding: 16.5 }}>
                                                                                                                                                                        <Text style={{ color: '#68d672', fontSize: 18.7, lineHeight: 28.1, textAlign: 'center' }}>该用户已通过工人认证</Text>
                                                                                                                                                                        <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证真实性</Text>
                                                                                                                                                                        <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证与真人对比照片</Text>
                                                                                                                                                                        <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其在本平台未被曝光</Text>
                                                                                                                                                                    </View>

                                                                                                                                                                    {/* 按钮 */}
                                                                                                                                                                    <View style={{
                                                                                                                                                                        flexDirection: 'row', alignItems: 'center',
                                                                                                                                                                        borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                                                                                                                                    }}>
                                                                                                                                                                        <TouchableOpacity activeOpacity={.7}
                                                                                                                                                                            onPress={() => this.props.alertFunr()}
                                                                                                                                                                            style={{
                                                                                                                                                                                flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                                                                                                                                borderRightWidth: 1, borderRightColor: '#ebebeb', width: '100%', height: '100%'
                                                                                                                                                                            }}>
                                                                                                                                                                            <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>我知道了</Text>
                                                                                                                                                                        </TouchableOpacity>
                                                                                                                                                                    </View>
                                                                                                                                                                </TouchableOpacity>
                                                                                                                                                            ) : (
                                                                                                                                                                    // 我已班组认证
                                                                                                                                                                    <TouchableOpacity activeOpacity={.7}
                                                                                                                                                                        activeOpacity={1}
                                                                                                                                                                        style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 320 }}>
                                                                                                                                                                        <View style={{ padding: 16.5 }}>
                                                                                                                                                                            <Text style={{ color: '#68d672', fontSize: 18.7, lineHeight: 28.1, textAlign: 'center' }}>该用户已通过班组长认证</Text>
                                                                                                                                                                            <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证真实性</Text>
                                                                                                                                                                            <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证与真人对比照片</Text>
                                                                                                                                                                            <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其在本平台未被曝光</Text>
                                                                                                                                                                        </View>

                                                                                                                                                                        {/* 按钮 */}
                                                                                                                                                                        <View style={{
                                                                                                                                                                            flexDirection: 'row', alignItems: 'center',
                                                                                                                                                                            borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                                                                                                                                        }}>
                                                                                                                                                                            <TouchableOpacity activeOpacity={.7}
                                                                                                                                                                                onPress={() => this.props.alertFunr()}
                                                                                                                                                                                style={{
                                                                                                                                                                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                                                                                                                                    borderRightWidth: 1, borderRightColor: '#ebebeb', width: '100%', height: '100%'
                                                                                                                                                                                }}>
                                                                                                                                                                                <Text style={{ color: '#000', fontSize: 16.5 }}>我知道了</Text>
                                                                                                                                                                            </TouchableOpacity>

                                                                                                                                                                        </View>
                                                                                                                                                                    </TouchableOpacity>
                                                                                                                                                                )
                                                                                                                                                        ) : (
                                                                                                                                                                // 我未实名认证
                                                                                                                                                                <TouchableOpacity activeOpacity={.7}
                                                                                                                                                                    activeOpacity={1}
                                                                                                                                                                    style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 320 }}>
                                                                                                                                                                    <View style={{ padding: 16.5 }}>
                                                                                                                                                                        <Text style={{ color: '#68d672', fontSize: 18.7, lineHeight: 28.1, textAlign: 'center' }}>该用户已通过工人认证</Text>
                                                                                                                                                                        <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证真实性</Text>
                                                                                                                                                                        <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其身份证与真人对比照片</Text>
                                                                                                                                                                        <Text style={{ marginTop: 8.8, color: '#666', fontSize: 15.4, lineHeight: 23.1 }}>平台已验证其在本平台未被曝光</Text>

                                                                                                                                                                        <View style={{ marginTop: 22 }}>
                                                                                                                                                                            <View
                                                                                                                                                                                style={{
                                                                                                                                                                                    marginBottom: 11, flexDirection: 'row',
                                                                                                                                                                                    alignItems: 'center', justifyContent: 'space-around'
                                                                                                                                                                                }}>
                                                                                                                                                                                <View style={{ width: 50, height: 2, backgroundColor: '#ebebeb' }}></View>
                                                                                                                                                                                <Text style={{ fontSize: 14.3, color: '#000', lineHeight: 21.5, fontWeight: '400' }}>通过工人认证的好处</Text>
                                                                                                                                                                                <View style={{ width: 50, height: 2, backgroundColor: '#ebebeb' }}></View>
                                                                                                                                                                            </View>

                                                                                                                                                                            <View style={{ flexDirection: 'row', alignItems: 'center', height: 33 }}>
                                                                                                                                                                                <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: '#000', marginLeft: 8, marginRight: 8 }}></View>
                                                                                                                                                                                <Text style={{ color: '#000', fontSize: 16.5 }}>大大提高你的可信度</Text>
                                                                                                                                                                            </View>

                                                                                                                                                                            <View style={{ flexDirection: 'row', alignItems: 'center', height: 33, flexWrap: "wrap" }}>
                                                                                                                                                                                <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: '#000', marginLeft: 8, marginRight: 8 }}></View>
                                                                                                                                                                                <Text style={{ color: '#000', fontSize: 16.5 }}>优先匹配项目</Text>
                                                                                                                                                                            </View>

                                                                                                                                                                            <View style={{ flexDirection: 'row', alignItems: 'center', height: 33, flexWrap: "wrap" }}>
                                                                                                                                                                                <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: '#000', marginLeft: 8, marginRight: 8 }}></View>
                                                                                                                                                                                <Text style={{ color: '#000', fontSize: 16.5 }}>获得广告宣传等高级服务</Text>
                                                                                                                                                                            </View>

                                                                                                                                                                        </View>
                                                                                                                                                                    </View>

                                                                                                                                                                    {/* 按钮 */}
                                                                                                                                                                    <View style={{
                                                                                                                                                                        flexDirection: 'row', alignItems: 'center',
                                                                                                                                                                        borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                                                                                                                                                                    }}>
                                                                                                                                                                        <TouchableOpacity activeOpacity={.7}
                                                                                                                                                                            onPress={() => this.props.alertFunr()}
                                                                                                                                                                            style={{
                                                                                                                                                                                flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                                                                                                                                borderRightWidth: 1, borderRightColor: '#ebebeb', width: '50%', height: '100%'
                                                                                                                                                                            }}>
                                                                                                                                                                            <Text style={{ color: '#000', fontSize: 16.5 }}>我知道了</Text>
                                                                                                                                                                        </TouchableOpacity>
                                                                                                                                                                        <TouchableOpacity activeOpacity={.7}
                                                                                                                                                                            onPress={() => this.toAuthenRz(1)}
                                                                                                                                                                            style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, height: '100%' }}>
                                                                                                                                                                            <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>我也要认证</Text>
                                                                                                                                                                        </TouchableOpacity>
                                                                                                                                                                    </View>
                                                                                                                                                                </TouchableOpacity>
                                                                                                                                                            )
                                                                                                                                                    ) : false
                                                                                                                                                )
                                                                                                                                        )
                                                                                                                                )
                                                                                                                        )
                                                                                                                )
                                                                                                        )
                                                                                                )
                                                                                        )
                                                                                )
                                                                        )
                                                                )
                                                        )
                                                )
                                        )
                                )
                        ) : false//直接进入登录页面
                    }
                </TouchableOpacity>
            </Modal>
        )
    }
    // 去认证
    toAuthen() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            this.props.alertFunr()//关闭弹窗
            NativeModules.MyNativeModule.openWebView('my/idcard')//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//ios个人端
            this.props.alertFunr()//关闭弹窗
            NativeModules.JGJRecruitmentController.openWebView('my/idcard');//调用原生方法
        }
    }
    // 班组-工人认证
    toAuthenRz(e) {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            this.props.alertFunr()//关闭弹窗
            NativeModules.MyNativeModule.openWebView(`my/attest?role=${e}`);//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//ios个人端
            this.props.alertFunr()//关闭弹窗
            NativeModules.JGJRecruitmentController.openWebView(`my/attest?role=${e}`);//调用原生方法
        }
    }
    // 已认证突击页面
    tjrzGod() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            this.props.alertFunr()//关闭弹窗
            NativeModules.MyNativeModule.openWebView('my/attest/commando')//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//ios个人端
            this.props.alertFunr()//关闭弹窗
            NativeModules.JGJRecruitmentController.openWebView('my/attest/commando');//调用原生方法
        }
    }
    // 班组认证
    tobzrz() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            this.props.alertFunr()//关闭弹窗
            NativeModules.MyNativeModule.openWebView('my/attest?role=2')//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//ios个人端
            this.props.alertFunr()//关闭弹窗
            NativeModules.JGJRecruitmentController.openWebView('my/attest?role=2');//调用原生方法
        }
    }
    //工人认证
    toGrRz() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            this.props.alertFunr()//关闭弹窗
            NativeModules.MyNativeModule.openWebView('my/attest?role=1')//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//ios个人端
            this.props.alertFunr()//关闭弹窗
            NativeModules.JGJRecruitmentController.openWebView('my/attest?role=1');//调用原生方法
        }
    }
}
