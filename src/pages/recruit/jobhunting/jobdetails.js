/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-20 17:44:03 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-03-27 16:48:38
 */
import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform, Image, ScrollView } from 'react-native';
import Icon from "react-native-vector-icons/iconfont";

export default class jobdetails extends Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({

        header: null,gesturesEnabled: false,
    });
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
                        <Icon style={{marginRight: 3}} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>招工详情</Text>
                    </View>
                    <TouchableOpacity
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                <ScrollView>
                    {/* 白色背景盒子 */}
                    <View style={styles.bg}>
                        <View style={{
                            paddingTop: 9, paddingBottom: 9, flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                            borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                        }}>
                            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                <View style={{ backgroundColor: '#eb7a4e', flexDirection: "row", alignItems: 'center', justifyContent: 'center', borderRadius: 3, marginRight: 7, width: 30, height: 16 }}>
                                    <Text style={{ color: '#fff', fontSize: 12 }}>点工</Text>
                                </View>
                                <Text style={{ color: '#000', fontSize: 17.6 }}>呼和浩特市招钢筋工</Text>
                                <Image style={{width:51,height:18,marginLeft:8}} source={require('../../../assets/recruit/jobverified.png')}></Image>
                            </View>
                            <View style={{ backgroundColor: '#eee', width: 37, height: 23, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', borderRadius: 2.2 }}>
                                <Text style={{ fontSize: 13.2, color: '#666' }}>土建</Text>
                            </View>
                        </View>

                        <View style={{
                            paddingTop: 9, paddingBottom: 9,
                            borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                        }}>
                            <View style={{ flexDirection: 'row', flexWrap: 'wrap' }}>
                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-start', width: '50%' }}>
                                    <Text style={{ color: '#000', fontSize: 15.4 }}>人数：</Text>
                                    <Text style={{ color: '#eb4e4e', fontSize: 15.4 }}>若干</Text>
                                    <Text style={{ color: '#999', fontSize: 13.2, marginLeft: 5.5 }}>人</Text>
                                </View>
                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-start', width: '50%' }}>
                                    <Text style={{ color: '#000', fontSize: 15.4 }}>工资：</Text>
                                    <Text style={{ color: '#eb4e4e', fontSize: 15.4 }}>面议</Text>
                                </View>
                            </View>
                            <View style={{ marginBottom: 6.5, marginTop: 6.5, flexDirection: 'row' }}>
                                <Text style={{ fontSize: 14, color: '#000', marginTop: 3.2 }}>待遇：</Text>
                                <View style={{ flexDirection: 'row', flexWrap: 'wrap' }}>
                                    <View style={{ marginTop: 3.2, backgroundColor: '#eee', marginRight: 6.5, borderRadius: 2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', paddingLeft: 4.5, paddingRight: 4.5, paddingTop: 2.2, paddingBottom: 2.2 }}>
                                        <Text style={{ fontSize: 12, color: '#333' }}>包吃不包住</Text>
                                    </View>
                                    <View style={{ marginTop: 3.2, backgroundColor: '#eee', marginRight: 6.5, borderRadius: 2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', paddingLeft: 4.5, paddingRight: 4.5, paddingTop: 2.2, paddingBottom: 2.2 }}>
                                        <Text style={{ fontSize: 12, color: '#333' }}>买保险</Text>
                                    </View>
                                    <View style={{ marginTop: 3.2, backgroundColor: '#eee', marginRight: 6.5, borderRadius: 2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', paddingLeft: 4.5, paddingRight: 4.5, paddingTop: 2.2, paddingBottom: 2.2 }}>
                                        <Text style={{ fontSize: 12, color: '#333' }}>按时发钱</Text>
                                    </View>
                                    <View style={{ marginTop: 3.2, backgroundColor: '#eee', marginRight: 6.5, borderRadius: 2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', paddingLeft: 4.5, paddingRight: 4.5, paddingTop: 2.2, paddingBottom: 2.2 }}>
                                        <Text style={{ fontSize: 12, color: '#333' }}>280</Text>
                                    </View>
                                    <View style={{ marginTop: 3.2, backgroundColor: '#eee', marginRight: 6.5, borderRadius: 2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', paddingLeft: 4.5, paddingRight: 4.5, paddingTop: 2.2, paddingBottom: 2.2 }}>
                                        <Text style={{ fontSize: 12, color: '#333' }}>9小时工作制</Text>
                                    </View>
                                </View>
                            </View>
                        </View>


                        <View style={{ paddingTop: 9, paddingBottom: 9, flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                            <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-start', width: '50%' }}>
                                <Text style={{ color: '#999', fontSize: 13.2 }}>发布时间：2019-03-19  10:00</Text>
                            </View>
                            <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-start', width: '50%' }}>
                                <Text style={{ color: '#999', fontSize: 13.2 }}>浏览次数：3</Text>
                            </View>
                        </View>
                    </View>

                    {/* 项目描述 */}
                    <View style={styles.bg}>
                        <View style={{ flexDirection: 'row', alignItems: 'center', paddingTop: 11, paddingBottom: 11, borderBottomWidth: 1, borderBottomColor: '#ebebeb' }}>
                            <Text style={{ color: '#999', fontSize: 15.4 }}>项目名称：</Text>
                            <Text style={{ color: '#000', fontSize: 15.4 }}>建设银行</Text>
                        </View>
                        <View style={{ flexDirection: 'row', alignItems: 'center', paddingTop: 11, paddingBottom: 11, borderBottomWidth: 1, borderBottomColor: '#ebebeb' }}>
                            <Text style={{ color: '#999', fontSize: 15.4 }}>施工单位：</Text>
                            <Text style={{ color: '#000', fontSize: 15.4 }}>建设银行</Text>
                        </View>
                        <View style={{
                            paddingTop: 11, paddingBottom: 5.5,
                            borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                        }}>
                            <Text style={{ color: '#999', fontSize: 15.4 }}>项目描述：</Text>
                            <Text style={{ color: '#000', fontSize: 15.4, lineHeight: 25 }}>我邀人，要四个人，北四环，一天二百五，四十五天开一个月的工资，压半个月，想干的给我打电话</Text>
                        </View>
                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', paddingTop: 11, paddingBottom: 11 }}>
                            <View style={{ flexDirection: 'row', alignItems: 'center', }}>
                                <Text style={{ color: '#999', fontSize: 15.4 }}>项目地址：</Text>
                                <Text style={{ color: '#000', fontSize: 15.4 }}>内蒙古呼和浩特</Text>
                            </View>
                            <View style={{ flexDirection: 'row', alignItems: 'center', }}>
                                <Text style={{ color: '#000', fontSize: 15.4 }}>查看位置</Text>
                                <Icon style={{ marginRight: 2 }} name="r-arrow" size={12} color="#000" />
                            </View>
                        </View>
                    </View>

                    {/* 发布人信息 */}
                    <View style={styles.bg}>
                        <View style={{
                            paddingTop: 9, paddingBottom: 9, flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                            borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                        }}>
                            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                <Text style={{ color: '#999', fontSize: 15.4 }}>发布人：</Text>
                                <Text style={{ color: '#000', fontSize: 15.4 }}>刘柳珠</Text>
                            </View>
                            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                <Icon style={{marginRight: 5.5}} name="plus" size={15} color="#4886ED" />
                                <Text style={{ color: 'rgb(72, 134, 237)', fontSize: 15.4 }}>订阅他的招工</Text>
                            </View>
                        </View>
                        <View style={{ paddingTop: 9, paddingBottom: 9, }}>
                            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                <Text style={{ color: '#999', fontSize: 15.4 }}>联系电话：</Text>
                                <Text style={{ color: '#000', fontSize: 15.4 }}>1335488****</Text>
                                <View style={{
                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                    borderWidth: 1, borderColor: '#eb4e4e', marginLeft: 5.2, borderRadius: 2.2,
                                    width: 59, height: 21
                                }}>
                                    <Text style={{ color: "#eb4e4e", fontSize: 13.2 }}>点击拨打</Text>
                                </View>
                            </View>
                            <Text style={{ color: "#eb4e4e", fontSize: 13.2, marginTop: 5.2 }}>联系我时请说明时在吉工家APP上看到的</Text>
                            <View style={{
                                marginTop: 11, padding: 5.5, borderWidth: 1, borderColor: '#dbdbdb', borderRadius: 4.4, backgroundColor: '#fafafa',
                                flexDirection: 'row', flexWrap: 'wrap'
                            }}>
                                <Text style={{ color: '#999', fontSize: 15.4, lineHeight: 25 }}>
                                    提示：此信息由平台用户提供，如果发现此信息不真实，请
                                    <Text style={{ color: '#4193df', fontSize: 15.4, fontWeight: '400' }}>立即举报</Text>
                                </Text>
                            </View>
                        </View>
                    </View>

                    {/* 公告 */}
                    <View style={{ padding: 11, backgroundColor: '#fdf1e0', flexDirection: 'row', alignItems: 'flex-start', marginBottom: 150 }}>
                        <View style={{
                            marginTop: 2.2, marginRight: 5.5, backgroundColor: 'rgb(255, 104, 3)', borderRadius: 2.2, width: 30, height: 19,
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                        }}>
                            <Text style={{ color: '#fff', fontSize: 13.2 }}>公告</Text>
                        </View>
                        <View>
                            <View style={{ flexDirection: 'row', flexWrap: 'wrap' }}>
                                <Text style={{ color: '#666', fontSize: 15.4 }}>加客服微信号
                                    <Text style={{ color: '#4193df', fontSize: 15.4, fontWeight: '400' }}>g918008</Text>
                                </Text>
                                <View style={{
                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                    borderWidth: 1, borderColor: 'rgb(153, 153, 153)', marginLeft: 5.2, borderRadius: 2.2,
                                    width: 59, height: 21
                                }}>
                                    <Text style={{ color: "#666", fontSize: 13.2 }}>点击复制</Text>
                                </View>
                                <Text style={{ color: '#666', fontSize: 15.4 }}>，拉你进工友群</Text>
                            </View>
                            <Text style={{ color: '#666', fontSize: 15.4, lineHeight: 25 }}>
                                关注“吉工家”微信公众号接收新工作提醒
                                <Text style={{ color: '#4193df', fontSize: 15.4, fontWeight: '400' }}>如何关注</Text>
                            </Text>
                        </View>
                    </View>
                </ScrollView>
                {/* 底部固定按钮 */}
                <View style={{
                    height: 64, backgroundColor: '#fff', flexDirection: 'row', justifyContent: 'space-between',
                    padding: 10, position: 'absolute', bottom: 0, width: '100%'
                }}>
                    <View style={{ borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 4, width: 157, paddingTop: 3, flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                        <Text style={{ color: '#eb4e4e', fontSize: 15, textAlign: 'center', lineHeight: 20 }}>和他聊聊</Text>
                    </View>
                    <View style={{ backgroundColor: '#eb4e4e', borderRadius: 4, width: 200, paddingTop: 3, flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                        <Text style={{ color: '#fff', fontSize: 15, textAlign: 'center', lineHeight: 20 }}>拨打电话</Text>
                    </View>
                </View>
            </View>
        )
    }
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
        marginBottom: 11,
    },
})