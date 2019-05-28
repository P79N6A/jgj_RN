import React, { Component } from 'react'
import {
    StyleSheet, Text, View, TouchableOpacity, Platform,
    Image, ScrollView, NativeModules,
    DeviceEventEmitter, ImageBackground
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import fetchFun from '../../fetch/fetch'
import AlertUser from '../../component/alertuser'
import ImageCom from '../../component/imagecom';
// import { createChat } from '../../utils/index'
import { Global } from '@jest/types';
import Alert from '../../component/alert'
import LinearGradient from 'react-native-linear-gradient';
import sha1 from 'sha1';
import Thelabel from '../../component/thelabel'
import { withNavigation } from 'react-navigation';
import { openWebView } from '../../utils'

class Info extends Component {
    constructor(props) {
        super(props)
        this.state = {
            item: {},
            is_subscibe: true,//是否已订阅

            // ----------实名or认证、突击弹框----------
            ifOpenAlert: false,//是否打开弹框
            param: '',//实名or认证、突击
            // ---------------------------------------

            alertValue: '',//弹框内容
            ifError: true,//弹框图标为正确类型还是错误类型
            openAlert: false,//控制弹框关闭打开

            ifrender: false,

            // ifshowll: 1,//是否显示聊一聊按钮
        }
    }

    render() {
        let { item, navigation, isMy, style } = this.props
        console.log(item)
        return (
            <ScrollView style={{ flex: 1, backgroundColor: '#fff' }}>
                {/* 发布时间，看过人数 */}
                <View
                    style={{
                        backgroundColor: '#E9E9E9', paddingLeft: 15,
                        paddingRight: 15, paddingTop: 9, paddingBottom: 9,
                        flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between'
                    }}>
                    {
                        item.create_time_txt ? (
                            <Text style={{ color: '#666666', fontSize: 12 }}>
                                {item.create_time_txt} 发布
                                </Text>
                        ) : false
                    }
                    {
                        item.review_cnt && item.review_cnt !== '0' ? (
                            <Text style={{ color: '#666666', fontSize: 12 }}>
                                已经有 {item.review_cnt} 人看过
                                </Text>
                        ) : false
                    }
                </View>

                {/* 白色背景盒子 */}
                <View style={{
                    backgroundColor: '#fff',
                    paddingLeft: 11,
                    paddingRight: 11,
                    paddingTop: 15
                }}>

                    {/* title */}
                    <View style={{
                        flexDirection: 'row',
                        alignItems: 'center', justifyContent: 'space-between', marginBottom: 5,
                    }}>
                        {/* title背景色标签 */}
                        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                            {
                                item.classes ? (
                                    item.classes[0].cooperate_type ? (
                                        item.classes[0].cooperate_type.type_name ? (
                                            item.classes[0].cooperate_type.type_name == '突击队' ? (
                                                <LinearGradient colors={['#9c16ca', '#5612BC',]}
                                                    start={{ x: 0.25, y: 0.25 }} end={{ x: 0.75, y: 0.75 }}
                                                    style={{
                                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                        marginRight: 7, paddingLeft: 5, paddingRight: 5, paddingTop: 1,
                                                        paddingBottom: 1, borderRadius: 9
                                                    }}>
                                                    <Text style={{ color: '#fff', fontSize: 11 }}>
                                                        {item.classes[0].cooperate_type.type_name}
                                                    </Text>
                                                </LinearGradient>
                                            ) : (
                                                    item.classes[0].cooperate_type.type_name == '点工' ? (
                                                        <LinearGradient colors={['#f97547', '#F53055',]}
                                                            start={{ x: 0.25, y: 0.25 }} end={{ x: 0.75, y: 0.75 }}
                                                            style={{
                                                                flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                marginRight: 7, paddingLeft: 5, paddingRight: 5, paddingTop: 1,
                                                                paddingBottom: 1, borderRadius: 9
                                                            }}>
                                                            <Text style={{ color: '#fff', fontSize: 11 }}>
                                                                {item.classes[0].cooperate_type.type_name}
                                                            </Text>
                                                        </LinearGradient>
                                                    ) : (
                                                            item.classes[0].cooperate_type.type_name == '包工' ? (
                                                                <LinearGradient colors={['#4DBDEC', '#1259EA',]}
                                                                    start={{ x: 0.25, y: 0.25 }} end={{ x: 0.75, y: 0.75 }}
                                                                    style={{
                                                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                        marginRight: 7, paddingLeft: 5, paddingRight: 5, paddingTop: 1,
                                                                        paddingBottom: 1, borderRadius: 9
                                                                    }}>
                                                                    <Text style={{ color: '#fff', fontSize: 11 }}>
                                                                        {item.classes[0].cooperate_type.type_name}
                                                                    </Text>
                                                                </LinearGradient>
                                                            ) : (
                                                                    item.classes[0].cooperate_type.type_name == '总包' ? (
                                                                        <LinearGradient colors={['#f97547', '#F53055',]}
                                                                            start={{ x: 0.25, y: 0.25 }} end={{ x: 0.75, y: 0.75 }}
                                                                            style={{
                                                                                flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                                marginRight: 7, paddingLeft: 5, paddingRight: 5, paddingTop: 1,
                                                                                paddingBottom: 1, borderRadius: 9
                                                                            }}>
                                                                            <Text style={{ color: '#fff', fontSize: 11 }}>
                                                                                {item.classes[0].cooperate_type.type_name}
                                                                            </Text>
                                                                        </LinearGradient>
                                                                    ) : false
                                                                )
                                                        )
                                                )
                                        ) : false
                                    ) : false
                                ) : false
                            }

                            {/* 项目名称 */}
                            <Text style={{ color: '#000', fontSize: 17 }}>
                                {item.pro_title ? (item.pro_title.length > 9 ? item.pro_title.substr(0, 8) + "..." : item.pro_title) : ""}
                            </Text>

                            {/* 是否实名 */}
                            {
                                item.is_verified == 1 ? (
                                    item.is_company_auth == '2' ? (
                                        <TouchableOpacity activeOpacity={.7}
                                            onPress={() => this.props.navigation.navigate('Recruit_rzdetailpage')}>
                                            <Image style={{ width: 18, height: 17, marginLeft: 5, marginTop: 2 }}
                                                source={{ uri: `${GLOBAL.server}public/imgs/icon/company_auth.png` }}></Image>
                                        </TouchableOpacity>
                                    ) : (
                                            <TouchableOpacity activeOpacity={.7}
                                                onPress={() => this.alertFun('information-sm')}>
                                                <Image style={{ width: 46, height: 16, marginLeft: 5 }}
                                                    source={{ uri: `${GLOBAL.server}public/imgs/icon/jobverified.png` }} ></Image>
                                            </TouchableOpacity>
                                        )
                                ) : false
                            }
                            {/* <Thelabel name = 'information' is_verified={item.is_verified} is_company_auth={item.is_company_auth} /> */}
                        </View>

                        {/* 项目标签 */}
                        {
                            item.classes ? (
                                item.classes[0].pro_type ? (
                                    item.classes[0].pro_type.type_name ? (
                                        <View
                                            style={{
                                                fontSize: 12,
                                                backgroundColor: '#eee',
                                                borderRadius: 2,
                                                flexDirection: 'row',
                                                alignItems: 'center',
                                                justifyContent: "center",
                                                paddingLeft: 6,
                                                paddingRight: 6,
                                                paddingTop: 2.5,
                                                paddingBottom: 2.5,
                                            }}>
                                            <Text style={{ fontSize: 13.2, color: '#666' }}>
                                                {item.classes[0].pro_type.type_name}
                                            </Text>
                                        </View>
                                    ) : false
                                ) : false
                            ) : false
                        }
                    </View>

                    <View>
                        {/* 待遇 */}
                        {
                            item.welfare && item.welfare.length > 0 && item.welfare[0] ? (
                                <View style={{ flexDirection: 'row', marginBottom: 5 }}>
                                    <View style={{ flexDirection: 'row', flexWrap: 'wrap' }}>
                                        {
                                            item.welfare.map((item, index) => {
                                                return (
                                                    <View key={index} style={{
                                                        flexDirection: 'row',
                                                        alignItems: 'center',
                                                        justifyContent: 'center',
                                                    }
                                                    }>
                                                        {
                                                            index != 0 ? (
                                                                <View style={{
                                                                    width: 1, height: 10, backgroundColor: '#666666',
                                                                    marginLeft: 6, marginRight: 6
                                                                }}></View>
                                                            ) : false
                                                        }
                                                        <Text style={{ fontSize: 12, color: '#333' }} >{item}</Text>
                                                    </View>
                                                )
                                            })
                                        }
                                    </View>
                                </View>
                            ) : false
                        }

                        {/* 差别展示信息 */}
                        <View>
                            {
                                item.classes ? (
                                    item.classes[0].cooperate_type ? (
                                        item.classes[0].cooperate_type.type_name ? (
                                            item.classes[0].cooperate_type.type_name == '突击队' ? (
                                                <View style={{ flexDirection: 'row', alignItems: 'center', flexWrap: 'wrap' }}>
                                                    {/* 开工时间 */}
                                                    {
                                                        item.classes ? (
                                                            <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                <Text style={{ color: '#000', fontSize: 15, fontWeight: '400' }}>开工时间：</Text>
                                                                < Text style={{ color: '#EB4E4C', fontSize: 15, fontWeight: '400' }}>
                                                                    {item.classes[0].work_begin ? item.classes[0].work_begin : '面议'}
                                                                </Text>
                                                            </View>
                                                        ) : false
                                                    }

                                                    {/* 工钱 */}
                                                    {
                                                        item.classes ? (
                                                            item.classes[0].max_money ? (
                                                                < View style={{ width: '50%', flexDirection: "row", alignItems: 'center', }}>
                                                                    <Text style={{ color: '#000', fontSize: 15 }}>工钱：</Text>

                                                                    <Text style={{ color: '#EB4E4C', fontSize: 15, fontWeight: '400' }}>
                                                                        {item.classes[0].money}~{item.classes[0].max_money}
                                                                    </Text>

                                                                    <Text style={{ color: '#666', fontSize: 15, fontWeight: '400' }}>元/{item.classes[0].balance_way}</Text>
                                                                </View>
                                                            ) : (
                                                                    < View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                        <Text style={{ color: '#000', fontSize: 15, fontWeight: '400' }}>工钱：</Text>

                                                                        <Text style={{ color: '#EB4E4C', fontSize: 15, fontWeight: '400' }}>
                                                                            {item.classes[0].money && Number(item.classes[0].money) != 0 ? item.classes[0].money : '面议'}
                                                                        </Text>

                                                                        {
                                                                            item.classes[0].money && Number(item.classes[0].money) != 0 ? (
                                                                                <Text style={{ color: '#666', fontSize: 15, fontWeight: '400' }}>元/人/天</Text>
                                                                            ) : false
                                                                        }
                                                                    </View>
                                                                )
                                                        ) : false
                                                    }

                                                    {/* 人数 */}
                                                    {
                                                        item.classes ? (
                                                            <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                <Text style={{ color: '#000', fontSize: 15, fontWeight: '400' }}>人数：</Text>
                                                                <Text style={{ color: '#EB4E4C', fontSize: 15, fontWeight: '400' }}>
                                                                    {item.classes[0].person_count && Number(item.classes[0].person_count) != 0 ? item.classes[0].person_count : '若干'}
                                                                </Text>
                                                                <Text style={{ color: '#666', fontSize: 15, fontWeight: '400' }}>
                                                                    {item.classes[0].person_count && Number(item.classes[0].person_count) != 0 ? '人' : false}
                                                                </Text>
                                                            </View>
                                                        ) : false
                                                    }

                                                    {/* 用工天数 */}
                                                    {
                                                        item.classes ? (
                                                            <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                <Text style={{ color: '#000', fontSize: 15, fontWeight: '400' }}>用工天数：</Text>
                                                                <Text style={{ color: '#EB4E4C', fontSize: 15, fontWeight: '400' }}>
                                                                    {item.classes[0].work_day && Number(item.classes[0].work_day) != 0 ? item.classes[0].work_day : '面议'}
                                                                </Text>

                                                                {
                                                                    item.classes[0].work_day && Number(item.classes[0].work_day) != 0 ? (
                                                                        <Text style={{ color: '#666', fontSize: 15, fontWeight: '400' }}>天</Text>
                                                                    ) : false
                                                                }
                                                            </View>
                                                        ) : false
                                                    }

                                                    {/* 工作时长 */}
                                                    {
                                                        item.classes ? (
                                                            <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                <Text style={{ color: '#000', fontSize: 15, fontWeight: '400' }}>工作时长：</Text>
                                                                <Text style={{ color: '#EB4E4C', fontSize: 15, fontWeight: '400' }}>
                                                                    {item.classes[0].work_hour && Number(item.classes[0].work_hour) != 0 ? item.classes[0].work_hour : '面议'}
                                                                </Text>

                                                                {
                                                                    item.classes[0].work_hour && Number(item.classes[0].work_hour) != 0 ? (
                                                                        <Text style={{ color: '#666', fontSize: 15, fontWeight: '400' }}>小时/{item.classes[0].balance_way}</Text>
                                                                    ) : false
                                                                }
                                                            </View>
                                                        ) : false
                                                    }

                                                </View>
                                            ) : (
                                                    item.classes[0].cooperate_type.type_name == '点工' ? (
                                                        <View style={{ flexDirection: 'row', alignItems: 'center', flexWrap: 'wrap' }}>
                                                            {/* 人数 */}
                                                            {
                                                                item.classes ? (
                                                                    item.classes[0].person_count ? (
                                                                        <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                            <Text style={{ color: '#000', fontSize: 15, fontWeight: '400' }}>人数：</Text>
                                                                            < Text style={{ color: '#EB4E4C', fontSize: 15, fontWeight: '400' }}>
                                                                                {item.classes[0].person_count && Number(item.classes[0].person_count) != 0 ? item.classes[0].person_count : '若干'}
                                                                            </Text>
                                                                            < Text style={{ color: '#666', fontSize: 15, fontWeight: '400' }}>
                                                                                {item.classes[0].person_count && Number(item.classes[0].person_count) != 0 ? '人' : false}
                                                                            </Text>
                                                                        </View>
                                                                    ) : false
                                                                ) : false
                                                            }

                                                            {/* 工资 */}
                                                            {
                                                                item.classes ? (
                                                                    item.classes[0].max_money ? (
                                                                        < View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                            <Text style={{ color: '#000', fontSize: 15, fontWeight: '400' }}>工资：</Text>

                                                                            <Text style={{ color: '#EB4E4C', fontSize: 15, fontWeight: '400' }}>
                                                                                {item.classes[0].money}~{item.classes[0].max_money}
                                                                            </Text>

                                                                            <Text style={{ color: '#666', fontSize: 15, fontWeight: '400' }}>元/{item.classes[0].balance_way}</Text>
                                                                        </View>
                                                                    ) : (
                                                                            < View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                <Text style={{ color: '#000', fontSize: 15, fontWeight: '400' }}>工资：</Text>

                                                                                <Text style={{ color: '#EB4E4C', fontSize: 15, fontWeight: '400' }}>
                                                                                    {item.classes[0].money && Number(item.classes[0].money) != 0 ? item.classes[0].money : '面议'}
                                                                                </Text>

                                                                                {
                                                                                    item.classes[0].money && Number(item.classes[0].money) != 0 ? (

                                                                                        <Text style={{ color: '#666', fontSize: 15, fontWeight: '400' }}>元/{item.classes[0].balance_way}</Text>
                                                                                    ) : false
                                                                                }
                                                                            </View>
                                                                        )
                                                                ) : false
                                                            }
                                                        </View>
                                                    ) : (
                                                            item.classes[0].cooperate_type.type_name == '包工' ? (
                                                                // 总价、规模
                                                                Number(item.classes[0].money) && !Number(item.classes[0].unitMoney) ? (
                                                                    <View style={{ flexDirection: 'row', alignItems: 'center', flexWrap: 'wrap' }}>
                                                                        {/* 总价 */}
                                                                        {
                                                                            item.classes ? (
                                                                                item.classes[0].money && item.classes[0].money != '0' ? (
                                                                                    <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                        <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>总价：</Text>
                                                                                        < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                            {item.classes[0].money}
                                                                                        </Text>
                                                                                        < Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>元</Text>
                                                                                    </View>
                                                                                ) : (
                                                                                        <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                            <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>总价：</Text>
                                                                                            < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                面议
                                                            </Text>
                                                                                        </View>
                                                                                    )
                                                                            ) : false
                                                                        }
                                                                        {/* 规模 */}
                                                                        {
                                                                            item.classes ? (
                                                                                item.classes[0].total_scale ? (
                                                                                    <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                        <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>规模：</Text>

                                                                                        <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                            {item.classes[0].total_scale}
                                                                                        </Text>

                                                                                        <Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>{item.classes[0].balance_way}</Text>
                                                                                    </View>
                                                                                ) : (
                                                                                        <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                            <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>规模：</Text>

                                                                                            <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                面议
                                                            </Text>

                                                                                        </View>
                                                                                    )
                                                                            ) : false
                                                                        }
                                                                    </View>
                                                                ) : (
                                                                        // 单价、总价、规模
                                                                        Number(item.classes[0].unitMoney) && Number(item.classes[0].money) ? (
                                                                            <View style={{ flexDirection: 'row', alignItems: 'center', flexWrap: 'wrap' }}>
                                                                                {/* 单价 */}
                                                                                {
                                                                                    item.classes ? (
                                                                                        item.classes[0].unitMoney ? (
                                                                                            <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                                <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>单价：</Text>
                                                                                                < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                    {item.classes[0].unitMoney}
                                                                                                </Text>
                                                                                                < Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>元/{item.classes[0].balance_way}</Text>
                                                                                            </View>
                                                                                        ) : (
                                                                                                <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                                    <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>单价：</Text>
                                                                                                    < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                        面议
                                                                </Text>
                                                                                                </View>
                                                                                            )
                                                                                    ) : false
                                                                                }

                                                                                {/* 总价 */}
                                                                                {
                                                                                    item.classes ? (
                                                                                        item.classes[0].money && item.classes[0].money != '0' ? (
                                                                                            <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                                <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>总价：</Text>
                                                                                                < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                    {item.classes[0].money}
                                                                                                </Text>
                                                                                                < Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>元</Text>
                                                                                            </View>
                                                                                        ) : (
                                                                                                <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                                    <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>总价：</Text>
                                                                                                    < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                        面议
                                                                </Text>
                                                                                                </View>
                                                                                            )
                                                                                    ) : false
                                                                                }

                                                                                {/* 规模 */}
                                                                                {
                                                                                    item.classes ? (
                                                                                        item.classes[0].total_scale ? (
                                                                                            <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                                <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>规模：</Text>

                                                                                                <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                    {item.classes[0].total_scale}
                                                                                                </Text>

                                                                                                <Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>{item.classes[0].balance_way}</Text>
                                                                                            </View>
                                                                                        ) : (
                                                                                                <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                                    <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>规模：</Text>

                                                                                                    <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                        面议
                                                                </Text>

                                                                                                </View>
                                                                                            )
                                                                                    ) : false
                                                                                }
                                                                            </View>
                                                                        ) : (
                                                                                // 单价、规模
                                                                                <View style={{ flexDirection: 'row', alignItems: 'center', flexWrap: 'wrap' }}>
                                                                                    {/* 单价 */}
                                                                                    {
                                                                                        item.classes ? (
                                                                                            Number(item.classes[0].unitMoney) ? (
                                                                                                <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                                    <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>单价：</Text>
                                                                                                    < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                        {item.classes[0].unitMoney}
                                                                                                    </Text>
                                                                                                    < Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>元/{item.classes[0].balance_way}</Text>
                                                                                                </View>
                                                                                            ) : (
                                                                                                    <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                                        <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>单价：</Text>
                                                                                                        < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                            面议
                                                                    </Text>
                                                                                                    </View>
                                                                                                )
                                                                                        ) : false
                                                                                    }
                                                                                    {/* 规模 */}
                                                                                    {
                                                                                        item.classes ? (
                                                                                            Number(item.classes[0].total_scale) ? (
                                                                                                <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                                    <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>规模：</Text>

                                                                                                    <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                        {item.classes[0].total_scale}
                                                                                                    </Text>

                                                                                                    <Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>{item.classes[0].balance_way}</Text>
                                                                                                </View>
                                                                                            ) : (
                                                                                                    <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                                        <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>规模：</Text>

                                                                                                        <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                            面议
                                                                    </Text>

                                                                                                    </View>
                                                                                                )
                                                                                        ) : false
                                                                                    }
                                                                                </View>
                                                                            )
                                                                    )
                                                            ) : (
                                                                    item.classes[0].cooperate_type.type_name == '总包' ? (
                                                                        // 总价、规模
                                                                Number(item.classes[0].money) && !Number(item.classes[0].unitMoney) ? (
                                                                    <View style={{ flexDirection: 'row', alignItems: 'center', flexWrap: 'wrap' }}>
                                                                        {/* 总价 */}
                                                                        {
                                                                            item.classes ? (
                                                                                item.classes[0].money && item.classes[0].money != '0' ? (
                                                                                    <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                        <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>总价：</Text>
                                                                                        < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                            {item.classes[0].money}
                                                                                        </Text>
                                                                                        < Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>元</Text>
                                                                                    </View>
                                                                                ) : (
                                                                                        <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                            <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>总价：</Text>
                                                                                            < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                面议
                                                            </Text>
                                                                                        </View>
                                                                                    )
                                                                            ) : false
                                                                        }
                                                                        {/* 规模 */}
                                                                        {
                                                                            item.classes ? (
                                                                                item.classes[0].total_scale ? (
                                                                                    <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                        <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>规模：</Text>

                                                                                        <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                            {item.classes[0].total_scale}
                                                                                        </Text>

                                                                                        <Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>{item.classes[0].balance_way}</Text>
                                                                                    </View>
                                                                                ) : (
                                                                                        <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                            <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>规模：</Text>

                                                                                            <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                面议
                                                            </Text>

                                                                                        </View>
                                                                                    )
                                                                            ) : false
                                                                        }
                                                                    </View>
                                                                ) : (
                                                                        // 单价、总价、规模
                                                                        Number(item.classes[0].unitMoney) && Number(item.classes[0].money) ? (
                                                                            <View style={{ flexDirection: 'row', alignItems: 'center', flexWrap: 'wrap' }}>
                                                                                {/* 单价 */}
                                                                                {
                                                                                    item.classes ? (
                                                                                        item.classes[0].unitMoney ? (
                                                                                            <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                                <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>单价：</Text>
                                                                                                < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                    {item.classes[0].unitMoney}
                                                                                                </Text>
                                                                                                < Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>元/{item.classes[0].balance_way}</Text>
                                                                                            </View>
                                                                                        ) : (
                                                                                                <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                                    <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>单价：</Text>
                                                                                                    < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                        面议
                                                                </Text>
                                                                                                </View>
                                                                                            )
                                                                                    ) : false
                                                                                }

                                                                                {/* 总价 */}
                                                                                {
                                                                                    item.classes ? (
                                                                                        item.classes[0].money && item.classes[0].money != '0' ? (
                                                                                            <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                                <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>总价：</Text>
                                                                                                < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                    {item.classes[0].money}
                                                                                                </Text>
                                                                                                < Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>元</Text>
                                                                                            </View>
                                                                                        ) : (
                                                                                                <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                                    <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>总价：</Text>
                                                                                                    < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                        面议
                                                                </Text>
                                                                                                </View>
                                                                                            )
                                                                                    ) : false
                                                                                }

                                                                                {/* 规模 */}
                                                                                {
                                                                                    item.classes ? (
                                                                                        item.classes[0].total_scale ? (
                                                                                            <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                                <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>规模：</Text>

                                                                                                <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                    {item.classes[0].total_scale}
                                                                                                </Text>

                                                                                                <Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>{item.classes[0].balance_way}</Text>
                                                                                            </View>
                                                                                        ) : (
                                                                                                <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                                    <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>规模：</Text>

                                                                                                    <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                        面议
                                                                </Text>

                                                                                                </View>
                                                                                            )
                                                                                    ) : false
                                                                                }
                                                                            </View>
                                                                        ) : (
                                                                                // 单价、规模
                                                                                <View style={{ flexDirection: 'row', alignItems: 'center', flexWrap: 'wrap' }}>
                                                                                    {/* 单价 */}
                                                                                    {
                                                                                        item.classes ? (
                                                                                            Number(item.classes[0].unitMoney) ? (
                                                                                                <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                                    <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>单价：</Text>
                                                                                                    < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                        {item.classes[0].unitMoney}
                                                                                                    </Text>
                                                                                                    < Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>元/{item.classes[0].balance_way}</Text>
                                                                                                </View>
                                                                                            ) : (
                                                                                                    <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                                        <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>单价：</Text>
                                                                                                        < Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                            面议
                                                                    </Text>
                                                                                                    </View>
                                                                                                )
                                                                                        ) : false
                                                                                    }
                                                                                    {/* 规模 */}
                                                                                    {
                                                                                        item.classes ? (
                                                                                            Number(item.classes[0].total_scale) ? (
                                                                                                <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                                    <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>规模：</Text>

                                                                                                    <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                        {item.classes[0].total_scale}
                                                                                                    </Text>

                                                                                                    <Text style={{ color: '#666', fontSize: 12, marginLeft: 5.5, fontWeight: '400' }}>{item.classes[0].balance_way}</Text>
                                                                                                </View>
                                                                                            ) : (
                                                                                                    <View style={{ width: '50%', flexDirection: "row", alignItems: 'center', marginTop: 2 }}>
                                                                                                        <Text style={{ color: '#000', fontSize: 14, fontWeight: '400' }}>规模：</Text>

                                                                                                        <Text style={{ color: '#EB4E4C', fontSize: 14, fontWeight: '400' }}>
                                                                                                            面议
                                                                    </Text>

                                                                                                    </View>
                                                                                                )
                                                                                        ) : false
                                                                                    }
                                                                                </View>
                                                                            )
                                                                    )
                                                                        ) : false
                                                                )
                                                        )
                                                )
                                        ) : false
                                    ) : false
                                ) : false
                            }
                        </View>

                        {/* 发布人信息 */}
                        {
                            item.fmname ? (
                                <TouchableOpacity activeOpacity={.7}
                                    activeOpacity={1}
                                    onPress={() => this.toMy()}
                                    style={{
                                        marginTop: 20,
                                        marginBottom: 20,
                                        borderRadius: 2.5,

                                        paddingLeft: 10,
                                        paddingRight: 10,
                                        paddingTop: 10,
                                        paddingBottom: 17,

                                        // 设置阴影
                                        // shadowColor: 'rgba(0, 0, 0, 0.05)',
                                        // shadowOffset: { width: 0, height: 2},
                                        // shadowOpacity: 0.01,//设置阴影的不透明度 
                                        // shadowRadius: 5,//设置阴影的模糊半径
                                        // elevation: 3,//阴影的高度

                                        borderWidth: 1,
                                        borderColor: '#dbdbdb',
                                        borderRadius: 5,
                                    }}
                                >
                                    {/* <ImageBackground
                                        style={{
                                            // width:355,
                                            // height:135,
                                            paddingLeft: 10,
                                            paddingRight: 10,
                                            paddingTop: 10,
                                            paddingBottom: 17,
                                        }} source={require('../../assets/recruit/touying.png')}> */}
                                    <View style={{
                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                        marginBottom: 15, borderBottomWidth: 1, borderBottomColor: '#ebebeb', paddingBottom: 10
                                    }}>
                                        <Text style={{ color: '#000000', fontSize: 12 }}>发布人：</Text>
                                        <TouchableOpacity activeOpacity={.7}
                                            onPress={() => openWebView('friend', { pid: item.pid })/*this.props.acquaintance() */}
                                            style={{ flexDirection: 'row', alignItems: 'center' }}>
                                            {
                                                item.sharefriendnum ? (
                                                    <View style={{ flexDirection: "row", alignItems: "center" }}>
                                                        <Text style={{ color: '#000000', fontSize: 12 }}>
                                                            你有&nbsp;
                                                                </Text>
                                                        <Text style={{ color: '#000000', fontSize: 12 }}>
                                                            {item.sharefriendnum}
                                                        </Text>
                                                        <Text style={{ color: '#000000', fontSize: 12 }}>
                                                            &nbsp;个朋友认识他
                                                                </Text>
                                                    </View>
                                                ) : false
                                            }
                                            {
                                                item.sharefriendnum ? (
                                                    <Icon style={{ marginLeft: 2 }} name="r-arrow" size={10} color="#333333" />
                                                ) : false
                                            }
                                        </TouchableOpacity>
                                    </View>
                                    <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
                                        <View style={{ flexDirection: 'row', alignItems: "center" }}>
                                            {
                                                item.contact_info[0] ? (
                                                    <ImageCom
                                                        style={{ borderRadius: 4.4, width: 38, height: 38, }}
                                                        fontSize='17.6'
                                                        userPic={item.contact_info[0].head_pic}
                                                        userName={item.contact_info[0].fmname}
                                                    />
                                                ) : false
                                            }

                                            <View style={{ marginLeft: 10, }}>
                                                {
                                                    item.fmname ? (
                                                        <Text style={{ color: '#000000', fontSize: 18, lineHeight: 24, width: 80, flexWrap: "wrap", fontWeight: '400' }} numberOfLines={1}>
                                                            {item.fmname}
                                                        </Text>
                                                    ) : false
                                                }
                                                {
                                                    item.telephone ? (
                                                        <Text style={{ color: '#000000', fontSize: 15, lineHeight: 24 }}>{item.telephone}</Text>
                                                    ) : false
                                                }
                                            </View>
                                        </View>
                                        {
                                            isMy ? false : (
                                                <View style={{ flexDirection: 'row', alignItems: 'flex-end', }}>
                                                    <TouchableOpacity activeOpacity={.7}
                                                        onPress={() => this.props.call_button()}
                                                        style={{
                                                            flexDirection: 'row', alignItems: "center",
                                                            borderRadius: 2.5, borderWidth: 1, borderColor: '#EB4E4E', justifyContent: 'center', height: 24, width: 76, marginRight: 5
                                                        }}>
                                                        <Icon style={{ marginRight: 2 }} name="bodadianhua" size={12} color="#EB4E4E" />
                                                        <Text style={{ color: '#EB4E4E', fontSize: 12 }}>拨打电话</Text>
                                                    </TouchableOpacity>

                                                    {
                                                        this.props.ifshowll == 1 ? (
                                                            <TouchableOpacity activeOpacity={.7}
                                                                onPress={() => this.props.createChat()}
                                                                style={{
                                                                    flexDirection: 'row', alignItems: "center",
                                                                    borderRadius: 2.5, borderWidth: 1, borderColor: '#EB4E4E', justifyContent: 'center', height: 24, width: 76
                                                                }}>
                                                                <Icon style={{ marginRight: 2 }} name="liaoliao" size={12} color="#EB4E4E" />
                                                                <Text style={{ color: '#EB4E4E', fontSize: 12 }}>和他聊聊</Text>
                                                            </TouchableOpacity>
                                                        ) : false
                                                    }
                                                </View>
                                            )
                                        }
                                    </View>
                                    {/* </ImageBackground> */}
                                </TouchableOpacity>
                            ) : false
                        }

                        {/* 项目名称 */}
                        {
                            item.pro_work_name ? (
                                <View style={{ flexDirection: "row", alignItems: 'center' }}>
                                    <Text style={{ fontSize: 15, color: '#000000', lineHeight: 24 }}>项目名称：</Text>
                                    <Text style={{ fontSize: 15, color: '#000000', lineHeight: 24, fontWeight: '400' }}>
                                        {item.pro_work_name}
                                    </Text>
                                </View>
                            ) : false
                        }

                        {/* 施工单位 */}
                        {
                            item.company_name ? (
                                <View style={{ flexDirection: "row", alignItems: 'center' }}>
                                    <Text style={{ fontSize: 15, color: '#000000', lineHeight: 24 }}>施工单位：</Text>
                                    <Text style={{ fontSize: 15, color: '#000000', lineHeight: 24, fontWeight: '400' }}>
                                        {item.company_name}
                                    </Text>
                                </View>
                            ) : false
                        }

                        {/* 地址 */}
                        {
                            item.pro_address ? (
                                <View style={{ flexDirection: "row", alignItems: 'center' }}>
                                    <Text style={{ fontSize: 15, color: '#000000', lineHeight: 24 }}>地&emsp;&emsp;址：</Text>
                                    <Text style={{ fontSize: 15, color: '#000000', lineHeight: 24, fontWeight: '400' }}>
                                        {item.pro_address}
                                    </Text>
                                    {
                                        item.pro_location &&item.pro_location.length == 2?(
                                            <TouchableOpacity activeOpacity={.7}
                                                onPress={() => this.addressShowFun(item.pro_location)}>
                                                <Icon style={{ marginLeft: 5 }} name='area' size={16} color="#EB4E4E" />
                                            </TouchableOpacity>
                                        ):false
                                    }
                                </View>
                            ) : false
                        }

                        {/* 项目描述 */}
                        {
                            item.pro_description ? (
                                <View>
                                    <Text style={{ fontSize: 15, color: '#000000', lineHeight: 24 }}>项目描述：</Text>
                                    <Text style={{ fontSize: 15, color: '#8B8B8B', lineHeight: 24, }}>
                                        {item.pro_description}
                                    </Text>
                                </View>
                            ) : false
                        }
                        {/* 组件差别信息展示截止============================================================= */}

                        {/* 举报提示 */}
                        {
                            isMy ? false : (
                                <View>
                                    <View style={{
                                        marginTop: 20, borderTopWidth: 1, borderColor: 'rgba(219,219,219,1)', borderBottomWidth: 1,
                                        paddingTop: 12, paddingBottom: 12, position: "relative"
                                    }}>
                                        <Text style={{
                                            color: '#000000', fontSize: 14, lineHeight: 20, fontWeight: '400',
                                            position: 'absolute', left: 0, top: 12
                                        }}>
                                            提示：
                                        </Text>
                                        <Text style={{ color: '#000000', fontSize: 14, lineHeight: 20, }}>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;此信息由平台用户实名提供，如果发现此信息不真实，请立即举报。
                                        </Text>
                                    </View>
                                    <TouchableOpacity activeOpacity={.7}
                                        onPress={() => this.props.reportFun()}
                                        style={{ flexDirection: 'row', justifyContent: "flex-end", marginTop: -30, marginBottom: 30 }}>
                                        <Text style={{ color: '#EB4E4E', fontSize: 13 }}>我要举报》</Text>
                                    </TouchableOpacity>
                                    {/*  */}
                                    {
                                        item.is_reg && item.is_reg == 1 ? (
                                            <View style={{ flexDirection: 'row', alignItems: 'center', marginBottom: 25 }}>
                                                <View style={{ flex: 1, height: 1, backgroundColor: '#FF6600' }}></View>
                                                <Text style={{ color: '#FF6600', fontSize: 12, lineHeight: 20, marginLeft: 6, marginRight: 6 }}>
                                                    联系我时请说明是在吉工家APP上看到的招工信息
                                        </Text>
                                                <View style={{ flex: 1, height: 1, backgroundColor: '#FF6600' }}></View>
                                            </View>
                                        ) : false
                                    }
                                </View>
                            )
                        }

                    </View>

                </View>

                {/* 加客服微信号 */}
                {
                    isMy ? false : (
                        <View style={{ backgroundColor: '#FDF4EE', flexDirection: 'row', padding: 15 }}>
                            <View style={{ width: '50%', borderRightWidth: 1, borderRightColor: '#FF6600' }}>
                                <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                    <Text style={{ color: '#000000', fontSize: 12, lineHeight: 19 }}>加客服微信号 </Text>
                                    <Text style={{ color: '#FF6600', fontSize: 12, lineHeight: 19 }}>{item.wechat_customer}</Text>
                                </View>
                                <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                    <Text style={{ color: '#000000', fontSize: 12, lineHeight: 19 }}>拉你进工友群</Text>
                                    <TouchableOpacity activeOpacity={.7}
                                        onPress={() => this.props.copyWechatNumber()}
                                        style={{
                                            borderWidth: 1, borderColor: '#FF6600', borderRadius: 2, paddingLeft: 3, paddingRight: 3,
                                            marginLeft: 3
                                        }}>
                                        <Text style={{ color: '#FF6600', fontSize: 10, lineHeight: 19 }}>复制微信号</Text>
                                    </TouchableOpacity>
                                </View>
                            </View>
                            <View style={{ width: '50%', paddingLeft: 15 }}>
                                <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                    <Text style={{ color: '#000000', fontSize: 12, lineHeight: 19 }}>关注【吉工家】微信公众号</Text>
                                </View>
                                <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                    <Text style={{ color: '#000000', fontSize: 12, lineHeight: 19 }}>接收新工作提醒</Text>
                                    <TouchableOpacity activeOpacity={.7}
                                        onPress={() => this.props.startActivityFromJS()}
                                        style={{
                                            borderWidth: 1, borderColor: '#FF6600', borderRadius: 2, paddingLeft: 3, paddingRight: 3,
                                            marginLeft: 3
                                        }}>
                                        <Text style={{ color: '#FF6600', fontSize: 10, lineHeight: 19 }}>如何关注</Text>
                                    </TouchableOpacity>
                                </View>
                            </View>
                        </View>
                    )
                }
                {/* 弹框 */}
                <AlertUser gows={this.gows.bind(this)} ifOpenAlert={this.state.ifOpenAlert} alertFunr={this.alertFunr.bind(this)} param={this.state.param} />
            </ScrollView>
        )
    }
    toMy() {
        // this.props.navigation.navigate('Personal_preview', { uid: this.props.item.uid, fromTo: 'yzlw', role_type: this.props.item.role_type + '', nameTo: 'nameTo' })
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
    // 跳转到完善资料页面
    gows() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.openWebView('my/info?perfect=1');//调用原生方法
            this.setState({
                ifOpenAlert: !this.state.ifOpenAlert,
            })
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.JGJRecruitmentController.openWebView('my/info?perfect=1');//调用原生方法
            this.setState({
                ifOpenAlert: !this.state.ifOpenAlert,
            })
        }
    }
    // ----------实名or认证、突击弹框----------
    alertFun(e) {
        this.setState({
            ifOpenAlert: !this.state.ifOpenAlert,
            param: e,
        })
    }
    alertFunr() {
        this.setState({
            ifOpenAlert: false
        })
    }
    // --------------------------------------
    // 订阅
    subscFun() {
        this.setState({
            ifOpenAlert: false
        })
        fetchFun.load({
            url: 'jlwork/worksubscibe',
            data: {
                // pid: this.props.navigation.getParam('pid'),
                // contacted: '0'
                uid: GLOBAL.userinfo.uid,//当前用户UID
                buid: this.props.navigation.getParam('pid'),//被订阅用户UID
                type: this.state.is_subscibe ? '0' : '1',//1为订阅,0为取消订阅(默认为1)
                kind: 'recruit'
            },
            success: (res) => {
                console.log('---订阅---', res)
                if (this.state.is_subscibe) {
                    this.setState({
                        alertValue: '取消订阅成功',
                        openAlert: true,
                        is_subscibe: !this.state.is_subscibe
                    })
                } else {
                    this.setState({
                        alertValue: '订阅成功',
                        openAlert: true,
                        is_subscibe: !this.state.is_subscibe
                    })
                }
            }
        });
    }
    // 查看位置
    addressShowFun(pro_location) {
        console.log(pro_location)
        if(pro_location.length==2){
            const params = {
                lng: GLOBAL.otherUser.lng,
                lat: GLOBAL.otherUser.lat,
                city_name: GLOBAL.otherUser.city_name,
                province_name: GLOBAL.otherUser.province_name,
                pro_address: GLOBAL.otherUser.pro_address,
            }
            if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
                NativeModules.MyNativeModule.startActivityFromJS('com.jizhi.jlongg.main.activity.map.LookAddrActivity', pro_location.join(','));//调用原生方法
            }
            if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
                NativeModules.JGJRecruitmentController.openMapView(params);//调用原生方法
            }
        }
    }
}

const styles = StyleSheet.create({
    main: {
        flex: 1,
        backgroundColor: '#ebebeb',
    },
    bg: {
        // backgroundColor: '#fff',
        // paddingLeft: 11,
        // paddingRight: 11,
    },
    card: {
        // marginTop: 2, 
        // marginBottom: 20,
        // paddingLeft: 10, 
        // paddingRight: 10,
        // paddingTop: 10,
        // paddingBottom: 17,
        // borderRadius: 2.5,

    }
})


export default withNavigation(Info)