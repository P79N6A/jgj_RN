/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 16:11:57 
 * @Last Modified by:   mikey.zhaopeng 
 * @Last Modified time: 2019-03-29 16:11:57 
 * Module:帮助中心
 */

import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform, Image, ScrollView,
    NativeModules,
    DeviceEventEmitter } from 'react-native';
import Icon from "react-native-vector-icons/iconfont";

export default class Doubt extends Component {
    constructor(props) {
        super(props)
        this.state = {
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null,gesturesEnabled: false,
    });
    componentDidMount(){
        // 底部导航控制
        this.bottomTab()
    }
    bottomTab(){
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.footerController('{state:"hide"}');//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.JGJRecruitmentController.footerController({state:"hide"});//调用原生方法
        }
    }
    render() {
        return (
            <View style={styles.containermain}>
                {/* 导航条 */}
                <View style={{
                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                }}>
                    <TouchableOpacity activeOpacity={.7} style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                        onPress={() => {this.props.navigation.goBack(),DeviceEventEmitter.emit("EventType", param)}}>
                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>帮助中心详情</Text>
                    </View>
                    <TouchableOpacity activeOpacity={.7} style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                <ScrollView>
                    <View style={styles.main}>
                        <View style={{ flexDirection: 'row', justifyContent: 'flex-start', width: '100%', alignItems: 'center', marginTop: 20, marginBottom: 20 }}>
                            <Icon style={{ marginLeft: 3 }} name="question-circle" size={19} color="#999" />
                            <Text style={{ fontWeight: '400', color: '#000', fontSize: 20, marginLeft: 3 }}>防骗指南</Text>
                        </View>
                        <View style={{ width: '100%', backgroundColor: '#fafafa', color: '#666', borderWidth: 1, borderColor: '#dbdbdb', borderRadius: 4, padding: 10 }}>
                            <Text style={styles.tit}>招工防骗指南</Text>
                            <Text style={styles.red}>※ 一切以没路费为由让先打钱的都是骗子</Text>
                            <Text style={styles.fonts}>
                                以没有路费或路费不够让你打钱买车票，或通过微信发送的车票样品，基本都是用软件制作的虚假车票，也是骗子一贯使用的诈骗手段，往往是得到钱后立即将你拉入黑名单。</Text>
                            <Text style={styles.red}>※ 与对方联系时注意核对信息并保留沟通证据</Text>
                            <Text style={styles.fonts}>1、双方沟通时，请尽量在吉工家的消息里仔细核实对方的：民族，姓名，年龄，籍贯，需要人数，工种和技术细节问题，必要时微信视频，以确保本人真实性。
2、新招人来工地必须查看身份证，工地不留没有身份证的务工人员。</Text>
                            <Text style={styles.red}>※ 遇到工地诈骗时的应对方法</Text>
                            <Text style={styles.fonts}>1、本人找机会离开工地，并马上报警，为警方提供之前交流的聊天证据和视频内容等。
</Text>
                            <Text style={styles.fonts}>
                                2、配合警方处理，其实这时候骗子也很害怕，如果之前有被举报的诈骗在警察局留有案底，这时警察会对他们依法进行处理，不必去管他。
</Text>
                            <Text style={styles.red}>在工作中，大多数都是诚信工友，真实的在招工找活，但在招工找活时防范之心不可无，请到吉工家曝光台去查询对方是否被曝光过
</Text>
                            <Text style={styles.tith}>找活防骗指南</Text>
                            <Text style={styles.red}>※ 不要奢望高于市场行情的“高薪”，日赚上千甚至更多的必然有问题，谨防传销！</Text>
                            <Text style={styles.fonts}>
                                1、与对方联系时注意保留沟通证据，开启通话录音。
</Text><Text style={styles.fonts}>
                                2、在吉工家找活时，请在吉工家消息里与对方核实招工情况，约定好工资.待遇以及包吃住等具体问题，保留沟通证据，做到有据可依。
</Text><Text style={styles.fonts}>
                                3、沟通时需注意询问招工要求的细节；要求对方发一些工地上的现场照片、建设单位等，以了解项目的实际情况。
</Text><Text style={styles.fonts}>
                                4、当然，除以上几点外，可以看的点还有很多，主要考虑的是不是真招工，项目是不是真的存在，开工后及时与招工方签订一份协议（双方签字按手印）以便明确工资等，防止以后产生纠纷没依据。
</Text><Text style={styles.fonts}>
                                5、如遇恶意拖欠工资，需报警或找劳动监察大队处理，千万不要进行暴力讨薪和违法讨薪。
</Text>
                            <Text style={styles.red}>※ 祝大家顺利找到合适的工作或工人！</Text>
                            <Text style={styles.red}>招工找活过程中遇到任何问题，也可以拨打吉工家客服热线4008623818。</Text>
                        </View>
                    </View>
                </ScrollView>
            </View>
        )
    }

}

const styles = StyleSheet.create({
    containermain: {
        flex: 1,
        backgroundColor: 'white',
        alignItems: 'center',
    },
    main: {
        paddingLeft: 10,
        paddingRight: 10,
        marginBottom: 10
    },
    red: {
        color: 'rgb(255, 0, 0)',
        fontSize: 17,
        marginBottom: 18,
    },
    tit: {
        color: 'rgb(255, 0, 0)',
        fontSize: 17,
        fontWeight: '400',
        marginTop: 18,
        marginBottom: 18,
    },
    tith: {
        color: 'rgb(255, 0, 0)',
        fontSize: 17,
        fontWeight: '400',
        marginTop: 36,
        marginBottom: 18,
    },
    tits: {
        color: 'rgb(255, 0, 0)',
        fontSize: 17,
        fontWeight: '400',
        marginBottom: 18,
    },
    fonts: {
        color: "#666",
        marginBottom: 18,
        fontSize: 17,
        lineHeight: 27,
    },
    fontst: {
        color: "#666",
        marginBottom: 18,
        marginTop: 36,
        fontSize: 17,
        lineHeight: 27,
    },
    wornphone: {
        color: 'rgb(255, 0, 0)',
        fontSize: 17,
        marginTop: 36,
    },
    phone: {
        color: 'rgb(255, 0, 0)',
        fontSize: 17,
        marginBottom: 18,
    },
})