/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-26 15:01:26 
 * @Module:登录
 * @Last Modified time: 2019-03-26 15:01:26 
 */
import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform, Image, ScrollView, TextInput } from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import fetchFun from '../../fetch/fetch'

export default class Doubt extends Component {
    constructor(props) {
        super(props)
        this.state = {
            phoneNumber:'',//手机号码
            verifiCode:'',//验证码
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null,gesturesEnabled: false,
    });
    render() {
        return (
            <View style={{ backgroundColor: '#fff', flex: 1 }}>
                {/* 导航条 */}
                <View style={{
                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                }}>
                    <TouchableOpacity style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                        onPress={() => this.props.navigation.goBack()}>
                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>登录</Text>
                    </View>
                    <TouchableOpacity style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>

                {/* 登录框 */}
                <View style={{ marginTop: 16.5, paddingLeft: 5.5, paddingRight: 5.5 }}>
                    <View style={{ flexDirection: 'row', alignItems: 'center', marginBottom: 5.5 }}>
                        <TextInput
                            onChangeText={this._phoneNumberFun.bind(this)}
                            maxLength={11}
                            style={{ height: 40, flex: 1, borderWidth: 1, borderColor: 'rgb(204, 204, 204)', 
                            borderRadius: 4, paddingLeft: 10 }}
                            placeholder='请输入手机号'>
                        </TextInput>
                        <TouchableOpacity 
                        onPress={()=>this._getVerfi()}
                            style={{
                            backgroundColor: '#d7262b', height: 40, marginLeft: 3, width: 120, borderRadius: 4,
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                        }}>
                            <Text style={{ color: '#fff' }}>获取验证码</Text>
                        </TouchableOpacity>
                    </View>

                    <View style={{ marginBottom: 22, height: 40 }}>
                        <TextInput
                            onChangeText={this._verifiCodeFun.bind(this)}
                            maxLength={4}
                            style={{ height: 40, flex: 1, borderWidth: 1, borderColor: 'rgb(204, 204, 204)', 
                            borderRadius: 4, paddingLeft: 10 }}
                            placeholder='请输入收到的短信验证码'>
                        </TextInput>
                    </View>

                    {/* 登录按钮 */}
                    <TouchableOpacity 
                        onPress={()=>this._loginFun()}
                        style={{
                        backgroundColor: '#d7262b', height: 40, marginLeft: 3, borderRadius: 4,
                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                    }}>
                        <Text style={{ color: '#fff' }}>登录</Text>
                    </TouchableOpacity>
                </View>
            </View>
        )
    }
    // 输入的手机号
    _phoneNumberFun(e){
        this.setState({
            phoneNumber:e
        })
    }
    // 获取验证码按钮
    _getVerfi(){
        fetchFun.load({
            url: 'v2/signup/getvcode',
            data: {
                telph: this.state.phoneNumber//手机号码
            },
            success: (res) => {
                console.log('获取验证码',res)
            }
        });
    }
    // 输入的验证码
    _verifiCodeFun(e){
        this.setState({
            verifiCode:e
        })
    }
    // 登录按钮
    _loginFun(){
        fetchFun.load({
            url: 'v2/signup/login',
            data: {
                telph: this.state.phoneNumber,//手机号码
                vcode: this.state.verifiCode,//验证码
                // os: Platform.OS,//平台系统
                os:'W'
            },
            success: (res) => {
                GLOBAL.unserinfo = res//登录返回个人信息存储
                    this.setState({})
                    this.props.navigation.navigate('Recruit')
            }
        });
    }
}