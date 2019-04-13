/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 18:26:49 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-11 16:34:15
 * Module:发布招工-招工详情
 */

import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Image, ScrollView } from 'react-native';
import Icon from "react-native-vector-icons/Ionicons";
import fetchFun from '../../fetch/fetch'

export default class jobdetails extends Component {
    constructor(props) {
        super(props)
        this.state = {
            list:{}
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });
    componentWillMount(){
        this.getList()
    }
    getList(){
        fetchFun.load({
            url: 'jlwork/prodetailactive',
            data: {
                pid: GLOBAL.pid,
                work_type: GLOBAL.fbzgType.fbzgTypeNum,//工种编号
            },
            success: (res) => {
                console.log('---项目详情---', res)
                if (res.state == 1) {
                    this.setState({
                        list: res.values
                    })
                }
            }
        });
    }
    render() {
        let item = this.state.list
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>项目详情</Text>
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
                                <View style={{ backgroundColor: '#eb7a4e', flexDirection: "row", 
                                alignItems: 'center', justifyContent: 'center', borderRadius: 3, 
                                marginRight: 7, width: 30, height: 16 }}>
                                {
                                    item.classes?(
                                        <Text style={{ color: '#fff', fontSize: 12 }}>{item.classes[0].cooperate_type.type_name}</Text>
                                    ):false
                                }
                                </View>
                                {
                                    item.pro_title?(
                                        <Text style={{ color: '#000', fontSize: 17.6 }}>
                                        {item.pro_title}
                                        </Text>
                                    ):false
                                }
                                <Image style={{ width: 51, height: 18, marginLeft: 8 }}
                                    source={require('../../assets/recruit/verified.png')}></Image>
                            </View>
                            <View style={{ backgroundColor: '#eee', width: 37, height: 23, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', borderRadius: 2.2 }}>
                                {
                                    item.classes?(
                                        <Text style={{ fontSize: 13.2, color: '#666' }}>
                                        {item.classes[0].pro_type.type_name}
                                        </Text>
                                    ):false
                                }
                            </View>
                        </View>

                        <View style={{
                            paddingTop: 9, paddingBottom: 9,
                            borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                        }}>
                            <View style={{ flexDirection: 'row', flexWarp: 'warp' }}>
                                {
                                    item.classes?(
                                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-start', width: '50%' }}>
                                            <Text style={{ color: '#000', fontSize: 15.4 }}>人数：</Text>
                                            <Text style={{ color: '#eb4e4e', fontSize: 15.4 }}>
                                            {item.classes[0].person_count}
                                            </Text>
                                            <Text style={{ color: '#999', fontSize: 13.2, marginLeft: 5.5 }}>人</Text>
                                        </View>
                                    ):false
                                }
                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-start', width: '50%' }}>
                                    <Text style={{ color: '#000', fontSize: 15.4 }}>工资：</Text>
                                    <Text style={{ color: '#eb4e4e', fontSize: 15.4 }}>面议</Text>
                                </View>
                            </View>
                            {
                                item.welfare && item.welfare.length>0?(
                                    <View style={{ marginBottom: 6.5, marginTop: 6.5, flexDirection: 'row' }}>
                                        <Text style={{ fontSize: 14, color: '#000', marginTop: 3.2 }}>待遇：</Text>
                                        <View style={{ flexDirection: 'row', flexWrap: 'wrap' }}>
                                            {
                                                item.welfare.map((v,index)=>{
                                                    return(
                                                        <View 
                                                        key={index}
                                                        style={{ marginTop: 3.2, backgroundColor: '#eee', 
                                                        marginRight: 6.5, borderRadius: 2, flexDirection: 'row', 
                                                        alignItems: 'center', justifyContent: 'center', paddingLeft: 4.5,
                                                         paddingRight: 4.5, paddingTop: 2.2, paddingBottom: 2.2 }}>
                                                            <Text style={{ fontSize: 12, color: '#333' }}>
                                                            {v}
                                                            </Text>
                                                        </View>
                                                    )
                                                })
                                            }
                                        </View>
                                    </View>
                                ):false
                            }
                        </View>


                        <View style={{ paddingTop: 9, paddingBottom: 9, flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                            {
                                item.create_time_txt?(
                                    <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-start', width: '50%' }}>
                                        <Text style={{ color: '#999', fontSize: 13.2 }}>发布时间：{item.create_time_txt}</Text>
                                    </View>
                                ):false
                            }
                            
                            {
                                item.review_cnt?(
                                    <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-start', width: '50%' }}>
                                        <Text style={{ color: '#999', fontSize: 13.2 }}>浏览次数：{item.review_cnt}</Text>
                                    </View>
                                ):false
                            }
                        </View>
                    </View>

                    {/* 项目描述 */}
                    <View style={styles.bg}>
                        {
                            item.pro_work_name?(
                                <View style={{ flexDirection: 'row', alignItems: 'center', paddingTop: 11, paddingBottom: 11, borderBottomWidth: 1, borderBottomColor: '#ebebeb' }}>
                                    <Text style={{ color: '#999', fontSize: 15.4 }}>项目名称：</Text>
                                    <Text style={{ color: '#000', fontSize: 15.4 }}>{item.pro_work_name}</Text>
                                </View>
                            ):false
                        }

                        {
                            item.pro_description?(
                                <View style={{
                                    paddingTop: 11, paddingBottom: 5.5,
                                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                                }}>
                                    <Text style={{ color: '#999', fontSize: 15.4 }}>项目描述：</Text>
                                    <Text style={{ color: '#000', fontSize: 15.4, lineHeight: 25 }}>
                                    {
                                        item.pro_description
                                    }
                                    </Text>
                                </View>
                            ):false
                        }

                        {
                            item.pro_address?(
                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', paddingTop: 11, paddingBottom: 11 }}>
                                    <View style={{ flexDirection: 'row', alignItems: 'center', }}>
                                        <Text style={{ color: '#999', fontSize: 15.4 }}>项目地址：</Text>
                                        <Text style={{ color: '#000', fontSize: 15.4 }}>
                                        {item.pro_address}
                                        </Text>
                                    </View>
                                    <View style={{ flexDirection: 'row', alignItems: 'center', }}>
                                        <Text style={{ color: '#000', fontSize: 15.4 }}>查看位置</Text>
                                        <Icon style={{ marginRight: 2 }} name="r-arrow" size={12} color="#000" />
                                    </View>
                                </View>
                            ):false
                        }
                    </View>

                    {/* 发布人信息 */}
                    {
                        item.contact_info?(
                            <View style={styles.bg}>
                                <View style={{
                                    paddingTop: 9, paddingBottom: 9, flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                                }}>
                                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                        <Text style={{ color: '#999', fontSize: 15.4 }}>发布人：</Text>
                                        <Text style={{ color: '#000', fontSize: 15.4 }}>
                                        {item.contact_info[0].fmname}
                                        </Text>
                                    </View>
                                </View>
                            </View>
                        ):false
                    }

                </ScrollView>
                {/* 底部固定按钮 */}
                <View style={{
                    height: 64, backgroundColor: '#fff', flexDirection: 'row', justifyContent: 'space-between',
                    padding: 10, position: 'absolute', bottom: 0, width: '100%'
                }}>
                    <View style={{
                        borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 4, paddingTop: 3,
                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, marginRight: 10
                    }}>
                        <Text style={{ color: '#eb4e4e', fontSize: 15, textAlign: 'center', lineHeight: 20 }}>停止</Text>
                    </View>
                    <View style={{
                        borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 4, paddingTop: 3,
                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, marginRight: 10
                    }}>
                        <Text style={{ color: '#eb4e4e', fontSize: 15, textAlign: 'center', lineHeight: 20 }}>刷新</Text>
                    </View>
                    <View style={{
                        borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 4, paddingTop: 3,
                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, marginRight: 10
                    }}>
                        <Text style={{ color: '#eb4e4e', fontSize: 15, textAlign: 'center', lineHeight: 20 }}>修改</Text>
                    </View>
                    <View style={{
                        borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 4, paddingTop: 3,
                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1
                    }}>
                        <Text style={{ color: '#eb4e4e', fontSize: 15, textAlign: 'center', lineHeight: 20 }}>删除</Text>
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