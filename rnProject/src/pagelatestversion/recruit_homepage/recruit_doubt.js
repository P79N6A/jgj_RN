/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 16:10:07 
 * @Last Modified by:   mikey.zhaopeng 
 * @Last Modified time: 2019-03-29 16:10:07 
 * Module:帮助中心
 */

import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform, Image, ScrollView } from 'react-native';
import Icon from "react-native-vector-icons/Ionicons";

export default class Doubt extends Component {
    constructor(props) {
        super(props)
        this.state = {
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });
    render() {
        return (
            <View style={styles.containermain}>
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>帮助中心详情</Text>
                    </View>
                    <TouchableOpacity style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                <ScrollView>
                    <View style={styles.main}>
                        <View style={{ flexDirection: 'row', justifyContent: 'flex-start', width: '100%', alignItems: 'center', marginTop: 20, marginBottom: 20 }}>
                            <Icon style={{ marginLeft: 3 }} name="question-circle" size={19} color="#999" />
                            <Text style={{ fontWeight: 'bold', color: '#000', fontSize: 20, marginLeft: 3 }}>找活说明</Text>
                        </View>
                        <View style={{ width: '100%', backgroundColor: '#fafafa', color: '#666', borderWidth: 1, borderColor: '#dbdbdb', borderRadius: 4, padding: 10 }}>
                            <Text style={styles.tit}>怎么找活？</Text>
                            <Text style={styles.fonts}>通过实名认证后，即可在招工详情页直接拨打招工方电话或聊聊进行联系。</Text>
                            <Text style={styles.fonts}>完善你的找活名片，找活更容易，并有机会被推荐为优质工人，在优质工人/班组里展示，增加曝光量。</Text>
                            <Text style={styles.fonts}>通过平台认证，可获得更多找活特权。</Text>
                            <Text style={styles.tith}>找活注意事项：</Text>
                            <Text style={styles.tits}>吉工家平台大多数人是诚信工友，但找活时防范之心不可无！</Text>
                            <Text style={styles.fonts}>找活时，如遇无效、虚假、诈骗信息，请立即举报！</Text>
                            <Text style={styles.fonts}>求职过程中请勿缴纳费用，谨防诈骗!</Text>
                            <Text style={styles.fonts}>找活时，请注意电话沟通问些工作细节，辨别招工信息真假，防范传销等形式的诈骗！</Text>
                            <Text style={styles.fonts}>你还可以去【发现-曝光台】看看工友们曾遇到的被骗案例，提高警惕。</Text>
                            <Text style={styles.tith}>找活防骗指南：</Text>
                            <Text style={styles.fonts}>吉工家一直以来提醒大家找活时要谨慎，也不断提供一些防骗的只是。特别为各位工友总结了一下几点，希望大家在找活时提高警惕，少上当、不上当：</Text>
                            <Text style={styles.fonts}>1、不要奢望高于市场行情的“高薪”，日赚上千甚至更多的必然有问题。谨防传销！</Text>
                            <Text style={styles.fonts}>2、对于陌生招工者应仔细询问、核对清楚招工要求细节，看对方是不是干建筑的是不是够专业，或是要求对方发一些以前的施工照片、项目合同、资质证书等。可以用吉工家APP的聊聊，保留沟通记录。必要时，对口头约定免责条款要进行微信视频聊天录像后，再去应聘。</Text>
                            <Text style={styles.fonts}>3、找活如遇以任何理由让你先打钱，皆为诈骗！请立即拨打客服电话举报！切记，不要轻易对外转账，不要将自己的银行密码等轻易示人！</Text>
                            <Text style={styles.fontst}>当然，可以看的点还有很多，主要考量的是招工的是不是真招工，项目是不是真的存在，以及尽可能与招工方签订劳动合同明确工资，房子以后产生纠纷没依据。</Text>
                            <Text style={styles.fonts}>祝大家顺利找到合适的建筑活！</Text>
                            <Text style={styles.wornphone}>如与任何问题，请致电吉工家客服热线：</Text>
                            <Text style={styles.phone}>4008623818</Text>
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
    tit: {
        color: 'rgb(255, 0, 0)',
        fontSize: 17,
        fontWeight: 'bold',
        marginTop: 18,
        marginBottom: 18,
    },
    tith: {
        color: 'rgb(255, 0, 0)',
        fontSize: 17,
        fontWeight: 'bold',
        marginTop: 36,
        marginBottom: 18,
    },
    tits: {
        color: 'rgb(255, 0, 0)',
        fontSize: 17,
        fontWeight: 'bold',
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