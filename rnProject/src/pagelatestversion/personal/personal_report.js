/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-04-04 11:48:36 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-04 15:47:08
 * Module:举报
 */
import React, { Component } from 'react';
import {
    Image,
    StyleSheet,
    Text,
    TouchableOpacity,
    View,
    Modal,
    TextInput
} from 'react-native';
import Icon from "react-native-vector-icons/Ionicons";
import fetchFun from '../../fetch/fetch'
import Alert from '../../component/alert'

export default class report extends Component {
    constructor(props) {
        super(props)
        this.state = {
            uid: '',
            value: [],
            other: '',
            alertValue: '',//弹框内容
            ifError: false,//弹框图标为正确类型还是错误类型
            openAlert: false,//控制弹框关闭打开
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });
    componentWillMount() {
        let uid = [this.props.navigation.getParam('uid')]
        this.setState({
            uid: uid
        })
    }
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>
                            举报
                                </Text>
                    </View>
                    <TouchableOpacity
                        style={{
                            width: '25%', height: '100%', marginRight: 10,
                            flexDirection: 'row', alignItems: 'center',
                            justifyContent: 'flex-end'
                        }}>
                    </TouchableOpacity>
                </View>

                {/* 举报内容 */}
                <View style={{ marginTop: 22, marginBottom: 33, paddingLeft: 11, paddingRight: 11 }}>
                    {/* 色情 */}
                    <TouchableOpacity
                        onPress={() => this.aFun()}
                        style={{
                            borderWidth: 1, borderColor: '#e1aaaa', backgroundColor: '#fbf6f6',
                            marginTop: 11, paddingTop: 11, paddingBottom: 11, position: 'relative'
                        }}>
                        {
                            this.state.value.indexOf('a') > -1 ? (
                                <View>
                                    <View style={{
                                        position: 'absolute',
                                        right: 0, top: -11,
                                        borderWidth: 16,
                                        height: 0, width: 0,
                                        borderBottomColor: 'rgba(0,0,0,0)',
                                        borderLeftColor: 'rgba(0,0,0,0)',
                                        borderTopColor: 'rgb(206,33,38)',
                                        borderRightColor: 'rgb(206,33,38)'
                                    }}></View>
                                    <Icon style={{ position: 'absolute', right: 3, top: -8, }} name="sure" size={12} color="#fff" />
                                </View>
                            ) : false
                        }
                        {
                            this.state.value.indexOf('a') > -1 ? (
                                <Text style={{ textAlign: 'center', color: '#eb4e4e', fontSize: 19.8, lineHeight: 29.8 }}>色情</Text>
                            ) : (
                                    <Text style={{ textAlign: 'center', color: '#333', fontSize: 19.8, lineHeight: 29.8 }}>色情</Text>
                                )
                        }
                        <Text style={{ textAlign: 'center', color: '#999', fontSize: 13.2, lineHeight: 19.8 }}>如涉黄涉赌涉毒等</Text>
                    </TouchableOpacity>

                    {/* 辱骂 */}
                    <TouchableOpacity
                        onPress={() => this.bFun()}
                        style={{
                            borderWidth: 1, borderColor: '#e1aaaa', backgroundColor: '#fbf6f6',
                            marginTop: 11, paddingTop: 11, paddingBottom: 11, position: 'relative'
                        }}>
                        {
                            this.state.value.indexOf('b') > -1 ? (
                                <View>
                                    <View style={{
                                        position: 'absolute',
                                        right: 0, top: -11,
                                        borderWidth: 16,
                                        height: 0, width: 0,
                                        borderBottomColor: 'rgba(0,0,0,0)',
                                        borderLeftColor: 'rgba(0,0,0,0)',
                                        borderTopColor: 'rgb(206,33,38)',
                                        borderRightColor: 'rgb(206,33,38)'
                                    }}></View>
                                    <Icon style={{ position: 'absolute', right: 3, top: -8, }} name="sure" size={12} color="#fff" />
                                </View>
                            ) : false
                        }
                        {
                            this.state.value.indexOf('b') > -1 ? (
                                <Text style={{ textAlign: 'center', color: '#eb4e4e', fontSize: 19.8, lineHeight: 29.8 }}>辱骂</Text>
                            ) : (
                                    <Text style={{ textAlign: 'center', color: '#333', fontSize: 19.8, lineHeight: 29.8 }}>辱骂</Text>
                                )
                        }
                        <Text style={{ textAlign: 'center', color: '#999', fontSize: 13.2, lineHeight: 19.8 }}>如存在侮辱性言语或图片</Text>
                    </TouchableOpacity>

                    {/* 欺诈 */}
                    <TouchableOpacity
                        onPress={() => this.cFun()}
                        style={{
                            borderWidth: 1, borderColor: '#e1aaaa', backgroundColor: '#fbf6f6',
                            marginTop: 11, paddingTop: 11, paddingBottom: 11, position: 'relative'
                        }}>
                        {
                            this.state.value.indexOf('c') > -1 ? (
                                <View>
                                    <View style={{
                                        position: 'absolute',
                                        right: 0, top: -11,
                                        borderWidth: 16,
                                        height: 0, width: 0,
                                        borderBottomColor: 'rgba(0,0,0,0)',
                                        borderLeftColor: 'rgba(0,0,0,0)',
                                        borderTopColor: 'rgb(206,33,38)',
                                        borderRightColor: 'rgb(206,33,38)'
                                    }}></View>
                                    <Icon style={{ position: 'absolute', right: 3, top: -8, }} name="sure" size={12} color="#fff" />
                                </View>
                            ) : false
                        }
                        {
                            this.state.value.indexOf('c') > -1 ? (
                                <Text style={{ textAlign: 'center', color: '#eb4e4e', fontSize: 19.8, lineHeight: 29.8 }}>欺诈</Text>
                            ) : (
                                    <Text style={{ textAlign: 'center', color: '#333', fontSize: 19.8, lineHeight: 29.8 }}>欺诈</Text>
                                )
                        }
                        <Text style={{ textAlign: 'center', color: '#999', fontSize: 13.2, lineHeight: 19.8 }}>如存在欺骗性或者诈骗性的内容</Text>
                    </TouchableOpacity>

                    {/* 其他 */}
                    <TouchableOpacity
                        onPress={() => this.dFun()}
                        style={{
                            borderWidth: 1, borderColor: '#e1aaaa', backgroundColor: '#fbf6f6',
                            marginTop: 11, paddingTop: 11, paddingBottom: 11, position: 'relative'
                        }}>
                        {
                            this.state.value.indexOf('d') > -1 ? (
                                <View>
                                    <View style={{
                                        position: 'absolute',
                                        right: 0, top: -11,
                                        borderWidth: 16,
                                        height: 0, width: 0,
                                        borderBottomColor: 'rgba(0,0,0,0)',
                                        borderLeftColor: 'rgba(0,0,0,0)',
                                        borderTopColor: 'rgb(206,33,38)',
                                        borderRightColor: 'rgb(206,33,38)'
                                    }}></View>
                                    <Icon style={{ position: 'absolute', right: 3, top: -8, }} name="sure" size={12} color="#fff" />
                                </View>
                            ) : false
                        }
                        {
                            this.state.value.indexOf('d') > -1 ? (
                                <Text style={{ textAlign: 'center', color: '#eb4e4e', fontSize: 19.8, lineHeight: 29.8 }}>其他</Text>
                            ) : (
                                    <Text style={{ textAlign: 'center', color: '#333', fontSize: 19.8, lineHeight: 29.8 }}>其他</Text>
                                )
                        }
                        {
                            this.state.value.indexOf('d') > -1 ? (
                                <TextInput multiline={true}
                                    placeholder='请输入'
                                    style={{
                                        height: 80,
                                        marginTop: 11, marginBottom: 11, marginLeft: 22, marginRight: 22,
                                        backgroundColor: '#fff',
                                        borderWidth: 1, borderColor: '#e1aaaa', borderRadius: 3, color: 'red'
                                    }}
                                    onChangeText={this.onChangeText.bind(this)}
                                    textAlignVertical='top'>
                                </TextInput>
                            ) : false
                        }
                    </TouchableOpacity>

                </View>

                {/* 提交按钮 */}
                <TouchableOpacity
                    onPress={() => this.btn()}
                    style={{
                        marginLeft: 11, marginRight: 11, height: 47.8, flexDirection: 'row',
                        alignItems: 'center', justifyContent: 'center', backgroundColor: '#eb4e4e', borderRadius: 4
                    }}>
                    <Text style={{ color: '#fff', fontSize: 18.7 }}>提交</Text>
                </TouchableOpacity>

                {/* 弹框 */}
                <Alert alertValue={this.state.alertValue} ifError={this.state.ifError} openAlert={this.state.openAlert} openAlertFun={this.openAlertFun.bind(this)} />
            </View>
        )
    }
    openAlertFun() {
        this.setState({
            openAlert: !this.state.openAlert
        })
    }
    // 色情
    aFun() {
        if (this.state.value.indexOf('a') > -1) {
            let index = this.state.value.indexOf('a')
            this.state.value.splice(index, 1)
            this.setState({})
        } else {
            this.state.value.push('a')
            this.setState({})
        }
    }
    // 辱骂
    bFun() {
        if (this.state.value.indexOf('b') > -1) {
            let index = this.state.value.indexOf('b')
            this.state.value.splice(index, 1)
            this.setState({})
        } else {
            this.state.value.push('b')
            this.setState({})
        }
    }
    // 欺诈
    cFun() {
        if (this.state.value.indexOf('c') > -1) {
            let index = this.state.value.indexOf('c')
            this.state.value.splice(index, 1)
            this.setState({})
        } else {
            this.state.value.push('c')
            this.setState({})
        }
    }
    // 其他
    dFun() {
        if (this.state.value.indexOf('d') > -1) {
            let index = this.state.value.indexOf('d')
            this.state.value.splice(index, 1)
            this.setState({})
        } else {
            this.state.value.push('d')
            this.setState({})
        }
    }
    // 输入其他内容
    onChangeText(e) {
        this.setState({
            other: e
        })
    }
    // 提交
    btn() {
        let values = []
        let other = ''
        if (this.state.value.indexOf('a') > -1) {
            values.push(51)
        }
        if (this.state.value.indexOf('b') > -1) {
            values.push(52)
        }
        if (this.state.value.indexOf('c') > -1) {
            values.push(53)
        }
        if (this.state.value.indexOf('d') > -1) {
            other = this.state.other
        }
        if (this.state.value.length == 0) {
            this.setState({
                alertValue: '你还没选择举报内容',
                ifError: false,
                openAlert: !this.state.openAlert
            }, () => {
                setTimeout(() => {
                    this.setState({
                        openAlert: false
                    })
                }, 1000)
            })

        } else {
            fetchFun.load({
                url: 'jlwork/report',
                data: {
                    mstype: 'person',//举报消息类型社交信息：cms 招聘：recruit 个人：person；动态：dynamic
                    key: this.state.uid[0][0],
                    value: values.join(','),
                    other: other,
                },
                success: (res) => {
                    console.log('---举报---', res)
                    if (res.state == 1) {
                        this.setState({
                            alertValue: '我们已经收到你的举报',
                            ifError: true,
                            openAlert: !this.state.openAlert
                        }, () => {
                            setTimeout(() => {
                                this.setState({
                                    openAlert: false
                                })
                                this.props.navigation.navigate('Personal_preview')
                            }, 1000)
                        })
                    }
                }
            });
        }
    }
}