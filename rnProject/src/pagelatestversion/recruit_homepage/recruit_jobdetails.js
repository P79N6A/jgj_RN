/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 16:14:41 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-11 15:37:12
 * Module:招工详情
 */

import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform, Image, ScrollView } from 'react-native';
import Icon from "react-native-vector-icons/Ionicons";
import fetchFun from '../../fetch/fetch'
import AlertUser from '../../component/alertuser'
import ImageCom from '../../component/imagecom';

export default class jobdetails extends Component {
    constructor(props) {
        super(props)
        this.state = {
            item: {},

            // ----------实名or认证、突击弹框----------
            ifOpenAlert: false,//是否打开弹框
            param: '',//实名or认证、突击
            // ---------------------------------------
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });
    componentWillMount() {
        fetchFun.load({
            url: 'jlwork/prodetailactive',
            data: {
                pid: this.props.navigation.getParam('pid'),
                contacted: '0'
            },
            success: (res) => {
                console.log('---招工详情---', res)
                if (res.state == 1) {
                    this.setState({
                        item: res.values
                    })
                }
            }
        });
    }
    render() {
        return (
            <View style={styles.main}>
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>详情</Text>
                    </View>
                    <TouchableOpacity
                        style={{
                            width: '25%', height: '100%', marginRight: 10, flexDirection: 'row',
                            alignItems: 'center', justifyContent: 'flex-end'
                        }}>
                        <Text style={{ fontSize: 17, color: '#EB4E4E', fontWeight: '400', }}>分享</Text>
                    </TouchableOpacity>
                </View>

                <ScrollView>
                    {/* 发布时间，看过人数 */}
                    <View
                        style={{
                            backgroundColor: '#E9E9E9', paddingLeft: 15,
                            paddingRight: 15, paddingTop: 9, paddingBottom: 9,
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between'
                        }}>
                        <Text style={{ color: '#666666', fontSize: 12 }}>{this.state.item.create_time_txt} 发布</Text>
                        <Text style={{ color: '#666666', fontSize: 12 }}>已经有 {this.state.item.review_cnt} 人看过</Text>
                    </View>

                    {/* 白色背景盒子 */}
                    <View style={styles.bg}>

                        {/* title */}
                        <View style={{
                            paddingTop: 9, paddingBottom: 9, flexDirection: 'row',
                            alignItems: 'center', justifyContent: 'space-between',
                        }}>
                            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                <View
                                    style={{
                                        backgroundColor: '#eb7a4e', flexDirection: "row",
                                        alignItems: 'center', justifyContent: 'center', borderRadius: 8,
                                        marginRight: 7, paddingLeft: 5, paddingRight: 5, paddingTop: 1, paddingBottom: 1
                                    }}>
                                    <Text style={{ color: '#fff', fontSize: 12 }}>
                                        {
                                            this.state.item.classes ? (
                                                this.state.item.classes[0].cooperate_type.type_name
                                            ) : (
                                                    <Text></Text>
                                                )
                                        }
                                    </Text>
                                </View>
                                <Text style={{ color: '#000', fontSize: 17.6 }}>
                                    {/* {this.state.item.pro_title} */}
                                    {this.state.item.pro_title ? (this.state.item.pro_title.length > 10 ? this.state.item.pro_title.substr(0, 10) + "..." : this.state.item.pro_title) : ""}
                                </Text>
                                {
                                    this.state.item.is_verified == 1 ? (
                                        <TouchableOpacity
                                            onPress={() => this.alertFun('sm')}>
                                            <Image style={{ width: 51, height: 18, marginLeft: 8 }}
                                                source={require('../../assets/recruit/jobverified.png')} ></Image>
                                        </TouchableOpacity>
                                    ) : false
                                }
                            </View>
                            <View
                                style={{
                                    fontSize: 14,
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
                                    {
                                        this.state.item.classes ? (
                                            this.state.item.classes[0].pro_type.type_name
                                        ) : (
                                                <Text></Text>
                                            )
                                    }
                                </Text>
                            </View>
                        </View>

                        <View>
                            {/* 待遇 */}
                            {
                                this.state.item.welfare && this.state.item.welfare.length > 0 ? (
                                    <View style={{ marginBottom: 6.5, flexDirection: 'row' }}>
                                        <View style={{ flexDirection: 'row', flexWrap: 'wrap' }}>
                                            {
                                                this.state.item.welfare.map((item, index) => {
                                                    return (
                                                        <View key={index} style={{
                                                            marginTop: 3.2,
                                                            marginRight: 5, borderRadius: 2, flexDirection: 'row',
                                                            alignItems: 'center',
                                                            justifyContent: 'center',
                                                            paddingRight: 6,
                                                            borderLeftWidth: index == 0 ? 0 : 1,
                                                            paddingLeft: index == 0 ? 0 : 6,
                                                            borderLeftColor: '#333'
                                                        }
                                                        }>
                                                            <Text style={{ fontSize: 12, color: '#333' }} >{item}</Text>
                                                        </View>
                                                    )
                                                })
                                            }
                                        </View>
                                    </View>
                                ) : (
                                        <View></View>
                                    )
                            }
                            <View style={{ flexDirection: 'row', flexWrap: 'wrap' }}>
                                <View style={{
                                    flexDirection: 'row', alignItems: 'center',
                                    justifyContent: 'flex-start', width: '50%', marginBottom: 6
                                }}>
                                    <Text style={{ color: '#000', fontSize: 15.4 }}>开工时间：</Text>
                                    <Text style={{ color: '#eb4e4e', fontSize: 15.4 }}>
                                        2019-03-27
                                    </Text>
                                </View>

                                <View style={{
                                    flexDirection: 'row', alignItems: 'center',
                                    justifyContent: 'flex-start', width: '50%', marginBottom: 6
                                }}>
                                    <Text style={{ color: '#000', fontSize: 15.4 }}>工资：</Text>
                                    <Text style={{ color: '#eb4e4e', fontSize: 15.4 }}>
                                        {
                                            this.state.item.classes ? (
                                                this.state.item.classes[0].max_money ? (
                                                    <Text style={{ color: '#EB4E4C', fontSize: 15.4 }
                                                    }>{this.state.item.classes[0].money}~{this.state.item.classes[0].max_money}</Text>
                                                ) : (
                                                        <Text style={{ color: '#EB4E4C', fontSize: 15.4 }}>{this.state.item.classes[0].money}</Text>
                                                    )
                                            ) : (
                                                    <Text></Text>
                                                )
                                        }
                                        <Text style={{ color: '#999', fontSize: 12, marginLeft: 5.5 }}> 元/天</Text>
                                    </Text>
                                </View>

                                <View style={{
                                    flexDirection: 'row', alignItems: 'center',
                                    justifyContent: 'flex-start', width: '50%', marginBottom: 6
                                }}>
                                    <Text style={{ color: '#000', fontSize: 15.4 }}>用工天数：</Text>
                                    <Text style={{ color: '#eb4e4e', fontSize: 15.4 }}>
                                        20
                                    </Text>
                                    <Text style={{ color: '#999', fontSize: 13.2, marginLeft: 5.5 }}>人</Text>
                                </View>

                                <View style={{
                                    flexDirection: 'row', alignItems: 'center',
                                    justifyContent: 'flex-start', width: '50%', marginBottom: 6
                                }}>
                                    <Text style={{ color: '#000', fontSize: 15.4 }}>人数：</Text>
                                    <Text style={{ color: '#eb4e4e', fontSize: 15.4 }}>

                                        {
                                            this.state.item.classes ? (
                                                this.state.item.classes[0].person_count
                                            ) : (
                                                    <Text></Text>
                                                )
                                        }
                                    </Text>
                                    <Text style={{ color: '#999', fontSize: 13.2, marginLeft: 5.5 }}>人</Text>
                                </View>

                                <View style={{
                                    flexDirection: 'row', alignItems: 'center',
                                    justifyContent: 'flex-start', width: '50%', marginBottom: 6
                                }}>
                                    <Text style={{ color: '#000', fontSize: 15.4 }}>工作时长：</Text>
                                    <Text style={{ color: '#eb4e4e', fontSize: 15.4 }}>
                                        9
                                    </Text>
                                    <Text style={{ color: '#999', fontSize: 13.2, marginLeft: 5.5 }}>小时/天</Text>
                                </View>
                            </View>

                            {/* 发布人信息 */}
                            <View style={{
                                marginTop: 10, marginBottom: 20,
                                paddingLeft: 10, paddingRight: 10, paddingTop: 10, paddingBottom: 17, borderRadius: 2.5,
                                shadowColor: '#000000',
                                shadowOffset: { width: 4, height: 4 },
                                shadowOpacity: 0.4,
                                shadowRadius: 2.5,
                                elevation: 2
                            }}>
                                <View style={{
                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                    marginBottom: 15, borderBottomWidth: 1, borderBottomColor: '#ebebeb', paddingBottom: 10
                                }}>
                                    <Text style={{ color: '#000000', fontSize: 12 }}>发布人：</Text>
                                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                        <Text style={{ color: '#000000', fontSize: 12 }}>你有3个朋友认识他</Text>
                                        <Icon style={{ marginLeft: 2 }} name="r-arrow" size={10} color="#333333" />
                                    </View>
                                </View>

                                <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
                                    <View style={{ flexDirection: 'row' }}>
                                        {/* <ImageCom
                                            style={{ borderRadius: 4.4, width: 49, height: 49, }}
                                            fontSize='17.6'
                                            userPic={this.state.item.share}
                                            userName={this.state.item.fmname}
                                        /> */}
                                        <View style={{
                                            width: 36, height: 36, borderRadius: 2.5, backgroundColor: '#4797E1',
                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                                        }}>
                                            <Text style={{ color: '#fff', fontSize: 15 }}>东霖</Text>
                                        </View>

                                        <View style={{ marginLeft: 10, marginTop: -5 }}>
                                            <Text style={{ color: '#000000', fontSize: 18, lineHeight: 24 }}>李东霖</Text>
                                            <Text style={{ color: '#000000', fontSize: 15, lineHeight: 24 }}>1360823****</Text>
                                        </View>
                                    </View>
                                    <View style={{ flexDirection: 'row', alignItems: 'flex-end' }}>
                                        <View style={{
                                            padding: 6, flexDirection: 'row', alignItems: "center",
                                            borderRadius: 2.5, borderWidth: 1, borderColor: '#EB4E4E', paddingTop: 3, paddingBottom: 3
                                        }}>
                                            <Icon style={{ marginRight: 2 }} name="bodadianhua" size={12} color="#EB4E4E" />
                                            <Text style={{ color: '#EB4E4E', fontSize: 12 }}>拨打电话</Text>
                                        </View>

                                        <View style={{
                                            padding: 6, flexDirection: 'row', alignItems: "center",
                                            borderRadius: 2.5, borderWidth: 1, borderColor: '#EB4E4E', marginLeft: 5, paddingTop: 3, paddingBottom: 3
                                        }}>
                                            <Icon style={{ marginRight: 2 }} name="liaoliao" size={12} color="#EB4E4E" />
                                            <Text style={{ color: '#EB4E4E', fontSize: 12 }}>和他聊聊</Text>
                                        </View>
                                    </View>
                                </View>
                            </View>

                            {/* 项目名称 */}
                            {
                                this.state.item.pro_work_name ? (
                                    <View style={{ flexDirection: "row", alignItems: 'center' }}>
                                        <Text style={{ fontSize: 14, color: '#000000', lineHeight: 24 }}>项目名称：</Text>
                                        <Text style={{ fontSize: 14, color: '#000000', lineHeight: 24, fontWeight: '600' }}>
                                            {this.state.item.pro_work_name}
                                        </Text>
                                    </View>
                                ) : false
                            }

                            {/* 施工单位 */}
                            {
                                this.state.item.company_name ? (
                                    <View style={{ flexDirection: "row", alignItems: 'center' }}>
                                        <Text style={{ fontSize: 14, color: '#000000', lineHeight: 24 }}>施工单位：</Text>
                                        <Text style={{ fontSize: 14, color: '#000000', lineHeight: 24, fontWeight: '600' }}>
                                            {this.state.item.company_name}
                                        </Text>
                                    </View>
                                ) : false
                            }

                            {/* 地址 */}
                            {
                                this.state.item.pro_address ? (
                                    <View style={{ flexDirection: "row", alignItems: 'center' }}>
                                        <Text style={{ fontSize: 14, color: '#000000', lineHeight: 24 }}>地    址：</Text>
                                        <Text style={{ fontSize: 14, color: '#000000', lineHeight: 24, fontWeight: '600' }}>
                                            {this.state.item.pro_address}
                                        </Text>
                                        <Icon style={{ marginLeft: 5 }} name='area' size={16} color="#EB4E4E" />
                                    </View>
                                ) : false
                            }

                            {/* 项目描述 */}
                            {
                                this.state.item.pro_description ? (
                                    <View>
                                        <Text style={{ fontSize: 14, color: '#000000', lineHeight: 24 }}>项目描述：</Text>
                                        <Text style={{ fontSize: 14, color: '#8B8B8B', lineHeight: 24, }}>
                                            {this.state.item.pro_description}
                                        </Text>
                                    </View>
                                ) : false
                            }

                            {/* 举报提示 */}
                            <View style={{
                                marginTop: 20, borderTopWidth: 1, borderColor: 'rgba(219,219,219,1)', borderBottomWidth: 1,
                                paddingTop: 12, paddingBottom: 12, flexDirection: 'row', flexWrap: 'wrap',
                            }}>
                                <Text style={{ color: '#000000', fontSize: 14, lineHeight: 20 }}>
                                    提示：此信息由平台用户实名提供，如果发现此信息不真实，请立即举报。
                                </Text>
                            </View>
                            <View style={{ flexDirection: 'row', justifyContent: "flex-end", marginTop: -30, marginBottom: 30 }}>
                                <Text style={{ color: '#EB4E4E', fontSize: 13 }}>我要举报》</Text>
                            </View>

                            <View style={{ flexDirection: 'row', alignItems: 'center', marginBottom: 25 }}>
                                <View style={{ flex: 1, height: 1, backgroundColor: '#FF6600' }}></View>
                                <Text style={{ color: '#FF6600', fontSize: 12, lineHeight: 20, marginLeft: 6, marginRight: 6 }}>
                                    联系我时请说明是在吉工家APP上看到的招工信息
                                </Text>
                                <View style={{ flex: 1, height: 1, backgroundColor: '#FF6600' }}></View>
                            </View>
                        </View>
                    </View>

                    <View style={{ backgroundColor: '#FDF4EE', flexDirection: 'row', padding: 15 }}>
                        <View style={{ width: '50%', borderRightWidth: 1, borderRightColor: '#FF6600' }}>
                            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                <Text style={{ color: '#000000', fontSize: 12, lineHeight: 19 }}>加客服微信号</Text>
                                <Text style={{ color: '#FF6600', fontSize: 12, lineHeight: 19 }}>g918008</Text>
                            </View>
                            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                <Text style={{ color: '#000000', fontSize: 12, lineHeight: 19 }}>拉你进工友群</Text>
                                <View style={{
                                    borderWidth: 1, borderColor: '#FF6600', borderRadius: 2, paddingLeft: 3, paddingRight: 3,
                                    marginLeft: 3
                                }}>
                                    <Text style={{ color: '#FF6600', fontSize: 10, lineHeight: 19 }}>复制微信号</Text>
                                </View>
                            </View>
                        </View>
                        <View style={{ width: '50%', paddingLeft: 15 }}>
                            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                <Text style={{ color: '#000000', fontSize: 12, lineHeight: 19 }}>关注【吉工家】微信公众号</Text>
                            </View>
                            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                <Text style={{ color: '#000000', fontSize: 12, lineHeight: 19 }}>接收新工作提醒</Text>
                                <View style={{
                                    borderWidth: 1, borderColor: '#FF6600', borderRadius: 2, paddingLeft: 3, paddingRight: 3,
                                    marginLeft: 3
                                }}>
                                    <Text style={{ color: '#FF6600', fontSize: 10, lineHeight: 19 }}>如何关注</Text>
                                </View>
                            </View>
                        </View>
                    </View>
                </ScrollView>

                {/* 按钮 */}
                <View style={{
                    position: 'relative', bottom: 0, height: 66, width: '100%',
                    backgroundColor: "#fff", padding: 11, flexDirection: 'row'
                }}>
                    <View style={{
                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1,
                        marginRight: 11
                    }}>
                        <View style={{ width: '50%' }}>
                            <View style={{ flexDirection: 'row', justifyContent: 'center' }}>
                                <Icon name="dingyue" size={23} color="#000000" />
                            </View>
                            <Text style={{ color: '#000000', fontSize: 12, textAlign: 'center' }}>订阅他的招工</Text>
                        </View>
                        <View style={{ width: '50%' }}>
                            <View style={{ flexDirection: 'row', justifyContent: 'center' }}>
                                <Icon name="liaoliao" size={23} color="#000000" />
                            </View>
                            <Text style={{ color: '#000000', fontSize: 12, textAlign: 'center' }}>和他聊聊</Text>
                        </View>
                    </View>
                    <View style={{
                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1,
                        backgroundColor: 'rgb(235, 78, 78)', borderRadius: 4, position: 'relative'
                    }}>
                        <Text style={{ color: '#fff', fontSize: 20 }}>拨打电话</Text>
                    </View>
                </View>

                {/* 弹框 */}
                <AlertUser ifOpenAlert={this.state.ifOpenAlert} alertFunr={this.alertFunr.bind(this)} param={this.state.param} />
            </View>
        )
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
}
const styles = StyleSheet.create({
    main: {
        flex: 1,
        backgroundColor: '#ebebeb',
    },
    bg: {
        backgroundColor: '#fff',
        paddingLeft: 11,
        paddingRight: 11,
    },
})