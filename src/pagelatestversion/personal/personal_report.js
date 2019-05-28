/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-04-04 11:48:36 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-17 14:36:46
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
    TextInput,ScrollView
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import fetchFun from '../../fetch/fetch'
import Alert from '../../component/alert'

export default class report extends Component {
    constructor(props) {
        super(props)
        this.state = {
            uid: '',
            value: [],
            other: '',
            isOther: false,
            alertValue: '',//弹框内容
            ifError: false,//弹框图标为正确类型还是错误类型
            openAlert: false,//控制弹框关闭打开

            selectValue: [],//举报信息选择
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null, gesturesEnabled: false,
    });
    componentWillMount() {
        let uid = [this.props.navigation.getParam('uid')]
        this.getreportselect()
        this.setState({
            uid: uid
        })
    }
    // 获取举报选项
    getreportselect() {
        fetchFun.load({
            url: 'jlcfg/classlist',
            data: {
                class_id: '50',//举报信息类型
            },
            success: (res) => {
                console.log('---举报---', res)
                this.setState({
                    selectValue: res
                })
            }
        });
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
                    <TouchableOpacity activeOpacity={.7} style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                        onPress={() => this.props.navigation.goBack()}>
                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>
                            举报
                                </Text>
                    </View>
                    <TouchableOpacity activeOpacity={.7}
                        style={{
                            width: '25%', height: '100%', marginRight: 10,
                            flexDirection: 'row', alignItems: 'center',
                            justifyContent: 'flex-end'
                        }}>
                    </TouchableOpacity>
                </View>

                {/* 举报内容 */}
                <ScrollView style={{ marginTop: 22, marginBottom: 33, paddingLeft: 11, paddingRight: 11 }} keyboardDismissMode={'on-drag'}>
                    {
                        this.state.selectValue && this.state.selectValue.length > 0 ? (
                            this.state.selectValue.map((v, i) => {
                                return (
                                    <TouchableOpacity activeOpacity={.7}
                                        key={i}
                                        onPress={() => this.selectFun(v.code)}
                                        style={{
                                            borderWidth: 1, borderColor: '#e1aaaa', backgroundColor: '#fbf6f6',
                                            marginTop: 11, paddingTop: 11, paddingBottom: 11, position: 'relative'
                                        }}>
                                        {
                                            this.state.value.indexOf(v.code) > -1 ? (
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
                                            this.state.value.indexOf(v.code) > -1 ? (
                                                <Text style={{ textAlign: 'center', color: '#eb4e4e', fontSize: 19.8, lineHeight: 29.8 }}>
                                                    {v.name}
                                                </Text>
                                            ) : (
                                                    <Text style={{ textAlign: 'center', color: '#333', fontSize: 19.8, lineHeight: 29.8 }}>
                                                        {v.name}
                                                    </Text>
                                                )
                                        }
                                        <Text style={{ textAlign: 'center', color: '#999', fontSize: 13.2, lineHeight: 19.8 }}>
                                            {v.desc}
                                        </Text>
                                    </TouchableOpacity>
                                )
                            })
                        ) : false
                    }
                    {/* 其他 */}
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.otherFun()}
                        style={{
                            borderWidth: 1, borderColor: '#e1aaaa', backgroundColor: '#fbf6f6',
                            marginTop: 11, paddingTop: 11, paddingBottom: 11, position: 'relative'
                        }}>
                        {
                            this.state.isOther ? (
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
                            this.state.isOther ? (
                                <Text style={{ textAlign: 'center', color: '#eb4e4e', fontSize: 19.8, lineHeight: 29.8 }}>其他</Text>
                            ) : (
                                    <Text style={{ textAlign: 'center', color: '#333', fontSize: 19.8, lineHeight: 29.8 }}>其他</Text>
                                )
                        }
                        {
                            this.state.isOther ? (
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
                </ScrollView>

                {/* 提交按钮 */}
                <TouchableOpacity activeOpacity={.7}
                    onPress={() => this.btn()}
                    style={{
                        marginLeft: 11, marginRight: 11, height: 47.8, flexDirection: 'row',marginBottom:50,
                        alignItems: 'center', justifyContent: 'center', backgroundColor: '#eb4e4e', borderRadius: 4
                    }}>
                    <Text style={{ color: '#fff', fontSize: 18.7 }}>提交</Text>
                </TouchableOpacity>

                {/* 弹框 */}
                <Alert alertValue={this.state.alertValue} ifError={this.state.ifError} closeAlertFun={this.closeAlertFun.bind(this)} openAlert={this.state.openAlert} openAlertFun={this.openAlertFun.bind(this)} />
            </View>
        )
    }
    openAlertFun() {
        this.setState({
            openAlert: !this.state.openAlert
        })
    }
    closeAlertFun() {
        this.setState({
            openAlert: false
        })
    }
    selectFun(e) {
        if (this.state.value.indexOf(e) > -1) {
            let index = this.state.value.indexOf(e)
            this.state.value.splice(index, 1)
            this.setState({})
        } else {
            this.state.value.push(e)
            this.setState({})
        }
    }
    // 其他
    otherFun() {
        this.setState({
            isOther:!this.state.isOther,
            other:''
        })
    }
    // 输入其他内容
    onChangeText(e) {
        this.setState({
            other: e
        })
    }
    // 提交
    btn() {
        console.log(this.state.value,this.state.other)
        if (this.state.value.length == 0 && this.state.other == '') {
            this.setState({
                alertValue: '你还没选择举报内容',
                ifError: false,
                openAlert: !this.state.openAlert
            })

        } else {
            fetchFun.load({
                url: 'jlwork/report',
                data: {
                    mstype: 'recruit',//举报消息类型社交信息：cms 招聘：recruit 个人：person；动态：dynamic
                    key: this.state.uid[0][0],
                    value: this.state.value.join(','),
                    other: this.state.other,
                },
                success: (res) => {
                    console.log('---举报---', res)
                    this.setState({
                        alertValue: '我们已经收到你的举报',
                        ifError: true,
                        openAlert: !this.state.openAlert
                    }, () => {
                        setTimeout(() => {
                            this.setState({
                                // openAlert: false
                            })
                            this.props.navigation.goBack()
                        }, 3000)
                    })
                }
            });
        }
    }
}