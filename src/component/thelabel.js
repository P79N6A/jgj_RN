/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-04-04 16:26:13 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-18 17:33:44
 * Module:已实名、已认证、突击队弹框
 */

import React, { Component } from 'React'
import { View, Text, Image, StyleSheet, TouchableOpacity, Modal } from 'react-native'
import Icon from "react-native-vector-icons/iconfont";
import { Global } from '@jest/types';
// import Alertuser from '../component/alertuser'
export default class bottomalert extends Component {
    constructor(props) {
        super(props)
        this.state = {
            ifOpenAlert:false,//控制弹窗
            param:'',//控制弹窗内容
        }
    }
    render() {
        console.log('111')
        return (
            <View>
                {
                    this.props.name == 'information' ? (
                        // 信息列表
                        this.props.is_verified && this.props.is_verified == 1 ? (
                            // 已实名
                            this.props.is_company_auth && this.props.is_company_auth == '2' ? (
                                // 企业认证
                                <TouchableOpacity activeOpacity={.7}
                                    onPress={() => this.informationFun()}
                                >
                                    <Image style={{ width: 18, height: 17, marginLeft: 5, marginTop: 2 }}
                                        source={{ uri: `${GLOBAL.server}public/imgs/icon/company_auth.png` }}></Image>
                                </TouchableOpacity>
                            ) : (
                                    <TouchableOpacity activeOpacity={.7}
                                        onPress={() => this.informationFun()}
                                    >
                                        <Image style={{ width: 46, height: 16, marginLeft: 5 }}
                                            source={{ uri: `${GLOBAL.server}public/imgs/icon/jobverified.png` }}></Image>
                                    </TouchableOpacity>
                                )
                        ) : false

                    ) : (
                            this.props.name == 'user' ? (
                                // 用户列表
                                <View style={{ flexDirection: 'row' }}>
                                    {/* 找工人列表 */}
                                    {
                                        this.props.verified && this.props.verified == 3 ? (
                                            // 已实名
                                            <TouchableOpacity activeOpacity={.7}>
                                                <Image style={{ width: 46, height: 16, marginLeft: 5 }}
                                                    source={{ uri: `${GLOBAL.server}public/imgs/icon/verified.png` }}></Image>
                                            </TouchableOpacity>
                                        ) : false
                                    }
                                    {/* 找活名片 */}
                                    {
                                        this.props.idverified && this.props.idverified !== '0' ? (
                                            // 已实名
                                            <TouchableOpacity activeOpacity={.7}>
                                                <Image style={{ width: 46, height: 16, marginLeft: 5 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/verified.png` }}></Image>
                                            </TouchableOpacity>
                                        ) : false
                                    }
                                    {
                                        this.props.group_verified && this.props.group_verified == '1' ? (
                                            // 已认证
                                            <TouchableOpacity activeOpacity={.7}>
                                                <Image style={{ width: 46, height: 16, marginLeft: 5 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/group-verified.png` }}></Image>
                                            </TouchableOpacity>
                                        ) : false
                                    }
                                    {
                                        this.props.is_commando && this.props.is_commando == '1' ? (
                                            // 突击队
                                            <TouchableOpacity activeOpacity={.7}>
                                                <Image style={{ width: 46, height: 16, marginLeft: 5 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/commando-verified.png` }}></Image>
                                            </TouchableOpacity>
                                        ) : false
                                    }
                                </View>
                            ) : false
                        )
                }

                {/* 弹窗组件 */}
                {/* <Alertuser ifOpenAlert={this.state.ifOpenAlert} alertFunr={this.alertFunr()} param={this.state.param} /> */}
            </View>
        )
    }
    // 信息列表实名标签点击事件
    informationFun() {
        this.setState({
            param:'information-my-Y',
            ifOpenAlert:!this.state.ifOpenAlert
        })
    }
    // 弹窗回调
    alertFunr(){
        this.setState({
            ifOpenAlert:!this.state.ifOpenAlert
        })
    }
}