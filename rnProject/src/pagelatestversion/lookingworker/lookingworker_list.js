/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 17:51:45 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-10 11:21:20
 * Module:找工人-列表
 */

import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    ActivityIndicator,
    ListView,
    Image,
    ScrollView,
    Dimensions,
    TouchableOpacity,
    StatusBar,
    Platform,
    FlatList,
    RefreshControl
} from 'react-native';
import Icon from "react-native-vector-icons/Ionicons";
import ListItem from '../../component/listitem'
import Empty from '../../component/listempty'
import Header from '../../component/listheader'
import Footer from '../../component/listfooter'
import fetchFun from '../../fetch/fetch'
import ImageCom from '../../component/imagecom';

export default class lookworker extends Component {
    constructor(props) {
        super(props)
        this.page = 1//当前页
        this.pagesize = 10
        this.state = {
            // 列表数据结构
            dataSource: [
                // { key: 0, name: '余明' },
                // { key: 1, name: '王银' },
                // { key: 2, name: '陈夫' },
            ],
            // 下拉刷新
            isRefresh: false,
            // 加载更多
            isLoadMore: false,
            // 控制foot  1：正在加载   2 ：无更多数据
            showFoot: 1,
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });
    componentWillMount() {
        fetchFun.load({
            url: 'jlforemanwork/findhelper',
            data: {
                pg: this.page,
                pagesize: this.pagesize,
                cityno: this.props.navigation.getParam('cityno'),//如果不传，默认是成都
                role_type: this.props.navigation.getParam('role_type'),//查找的角色，1工人，2班组
                work_type: this.props.navigation.getParam('work_type'),//工种
                pro_type: 0,//工程类别
            },
            success: (res) => {
                console.log('---找工人列表---', res)
                if (res.state == 1) {
                    this.setState({
                        dataSource: res.values
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>找{this.props.navigation.getParam('role_type') == '1' ? '工人' : '班组'}({GLOBAL.zgrType.zgrTypeName})</Text>
                    </View>
                    <TouchableOpacity
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                {/* title */}
                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', marginTop: 7.7, marginBottom: 7.7 }}>
                    <Text style={{ color: '#999', fontSize: 15.4 }}>以下是 </Text>
                    <Text style={{ color: '#000', fontSize: 15.4 }}>{GLOBAL.zgrAddress.zgrAddressOneName} {GLOBAL.zgrAddress.zgrAddressTwoName}</Text>
                    <Text style={{ color: '#999', fontSize: 15.4 }}> 的工人 </Text>
                    <TouchableOpacity
                        onPress={() => this.zgrAddress()}
                        style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                        <Text style={{ color: '#eb4e4e', fontSize: 15.4 }}>切换城市</Text>
                        <Icon name="refresh" size={15} color="#EB4E4E" />
                    </TouchableOpacity>
                </View>
                {/* 列表组件 */}
                <ListItem
                    data={this.state.dataSource}
                    ListHeaderComponent={() => <Header />}//头布局
                    renderItem={({ item }) => <List data={item} navigation={this.props.navigation} />}//item显示的布局
                    ListFooterComponent={() => <Footer />}//尾布局
                    ListEmptyComponent={() => <Empty />}// 空布局
                    onEndReached={() => this._onLoadMore()}//加载更多
                    onRefresh={() => this._onRefresh()}//下拉刷新相关
                />
                {/* 底部按钮 */}
                <TouchableOpacity
                    onPress={() => this.props.navigation.navigate('Myrecruit')}
                    style={{ backgroundColor: '#fff', padding: 11, position: 'relative', bottom: 0, width: '100%', height: 66, }}>
                    <View style={{ backgroundColor: '#eb4e4e', flexDirection: 'row', alignItems: 'center', justifyContent: 'center', borderRadius: 4.4, height: 44 }}>
                        <Text style={{ color: '#fff', fontSize: 18.7 }}>发布招工 让别人来找我</Text>
                    </View>
                </TouchableOpacity>
            </View>
        )
    }
    //选择项目所在地
    zgrAddress() {
        fetchFun.load({
            url: 'jlcfg/cities',
            data: {
                level: '1',//城市级别 1：省 2 市 3县
                citycode: '0',//城市编码
                os: GLOBAL.os,
                token: GLOBAL.userinfo.token,
                ver: GLOBAL.ver,
            },
            success: (res) => {
                console.log('---获取城市列表-省---', res)
                if (res.state == 1) {
                    GLOBAL.AddressOne = res.values
                    this.setState({}, () => {
                        this.props.navigation.navigate('Address', {
                            name: '找工人项目所在地',
                            callback: (() => {
                                this.setState({})
                            })
                        })
                    })
                }
            }
        });
    }
    // 下拉刷新
    _onRefresh = () => {
        // 不处于 下拉刷新
        if (!this.state.isRefresh) {
            this.page = 1
            // this._getHotList()
        }
    };
    // 加载更多
    _onLoadMore() {
        // 不处于正在加载更多 && 有下拉刷新过，因为没数据的时候 会触发加载
        if (!this.state.isLoadMore && this.state.dataSource.length > 0 && this.state.showFoot !== 2) {
            this.page = this.page + 1
            // this._getHotList()
        }
    }
}
// item布局
class List extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        const item = this.props.data
        return (
            <TouchableOpacity
                activeOpacity={0.5}
                onPress={() => this.toMy(item)}
            >
                <View style={{
                    flexDirection: 'row',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    marginBottom: 11,
                    backgroundColor: '#fff',
                    paddingLeft: 13,
                    paddingTop: 13,
                    paddingBottom: 13,
                    paddingRight: 5.5
                }}>
                    <View style={{ width: '100%' }}>
                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                            <View style={{ marginRight: 17 }}>
                                <ImageCom
                                    style={{ borderRadius: 4.4, width: 49, height: 49, }}
                                    fontSize='17.6'
                                    userPic={item.head_pic}
                                    userName={item.real_name}
                                />
                            </View>
                            <View style={{ flex: 1 }}>
                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                        <Text style={{ color: '#000', fontSize: 17.6 }}>{item.real_name}</Text>
                                        {
                                            item.verified == 3 ? (
                                                <Image style={{ width: 51, height: 18, marginLeft: 8 }} source={require('../../assets/recruit/verified.png')}></Image>
                                            ) : false
                                        }
                                    </View>
                                    <View style={{ flexDirection: 'row', alignItems: 'center', marginRight: 15 }}>
                                        <Icon name="place" size={15} color="#BFBFBF" />
                                        <Text style={{ color: '#666', fontSize: 13.2, marginLeft: 5 }}>
                                            {item.current_addr}
                                        </Text>
                                    </View>
                                </View>
                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                    <View style={{ flexDirection: 'row' }}>
                                        <Text style={{ color: '#666', fontSize: 13.2, marginRight: 11 }}>
                                            {item.nationality}族
                                        </Text>
                                        <Text style={{ color: '#666', fontSize: 13.2, marginRight: 3 }}>
                                            工龄
                                        </Text>
                                        <Text style={{ color: '#eb4e4e', fontSize: 13.2, }}>
                                            {item.work_year}
                                        </Text>
                                        <Text style={{ color: '#666', fontSize: 13.2, marginRight: 11, marginLeft: 3 }}>
                                            年
                                        </Text>
                                        {
                                            this.props.navigation.getParam('role_type') == '2' ? (
                                                <View style={{ flexDirection: 'row' }}>
                                                    <Text style={{ color: '#666', fontSize: 13.2, marginRight: 3 }}>
                                                        队伍
                                                    </Text>
                                                    <Text style={{ color: '#eb4e4e', fontSize: 13.2, }}>
                                                        {item.person_count}
                                                    </Text>
                                                    <Text style={{ color: '#666', fontSize: 13.2, marginRight: 11, marginLeft: 3 }}>
                                                        人
                                                    </Text>
                                                </View>
                                            ) : false
                                        }
                                        {
                                            item.work_level.map((v, index) => {
                                                return (
                                                    <Text key={index} style={{ color: '#666', fontSize: 13.2 }}>
                                                        {v}
                                                    </Text>
                                                )
                                            })
                                        }

                                    </View>
                                    <Icon style={{ marginRight: 5 }} name="r-arrow" size={12} color="#000" />
                                </View>
                            </View>
                        </View>

                        <View style={{ flexDirection: 'row', flexWrap: 'wrap', marginTop: 3 }}>
                            {
                                item.pro_type.map((v, index) => {
                                    return (
                                        <View
                                            key={index}
                                            style={{
                                                marginTop: 4.4, marginRight: 6.6, backgroundColor: '#eee',
                                                paddingLeft: 4.4, paddingRight: 4.4,
                                                paddingTop: 2.2, paddingBottom: 2.2, flexDirection: 'row',
                                                alignItems: 'center', justifyContent: 'center', borderRadius: 2.2
                                            }}>
                                            <Text style={{ color: '#666', fontSize: 13.2 }}>{v}</Text>
                                        </View>
                                    )
                                })
                            }

                        </View>

                        {
                            item.introduce !== '' ? (
                                <View style={{ marginTop: 6.6 }}>
                                    <Text style={{ color: '#999', fontSize: 13.2, lineHeight: 19.8 }}>
                                        {item.introduce ? (item.introduce.length > 28 ? item.introduce.substr(0, 28) + "..." : item.introduce) : ""}
                                    </Text>
                                </View>
                            ) : false
                        }

                        {
                            item.friendcount > 0 && this.props.navigation.getParam('role_type') == '2' || item.experience_num > 0 && this.props.navigation.getParam('role_type') == '2' ? (
                                <View style={{
                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                    marginTop: 6.6, paddingTop: 11, borderTopWidth: 1, borderTopColor: '#ebebeb'
                                }}>
                                    {
                                        item.friendcount > 0 ? (
                                            <View style={{ flexDirection: 'row' }}>
                                                <Text style={{ color: '#999', fontSize: 13.2, lineHeight: 19.8 }}>你有 </Text>
                                                <Text style={{ color: '#eb4e4e', fontSize: 13.2, lineHeight: 19.8 }}>{item.friendcount}</Text>
                                                <Text style={{ color: '#999', fontSize: 13.2, lineHeight: 19.8 }}> 个朋友认识他</Text>
                                            </View>
                                        ) : false
                                    }
                                    {
                                        item.experience_num > 0 ? (
                                            <View style={{ flexDirection: 'row' }}>
                                                <Text style={{ color: '#999', fontSize: 13.2, lineHeight: 19.8 }}>他有 </Text>
                                                <Text style={{ color: '#eb4e4e', fontSize: 13.2, lineHeight: 19.8 }}>{item.experience_num}</Text>
                                                <Text style={{ color: '#999', fontSize: 13.2, lineHeight: 19.8 }}> 条项目经验</Text>
                                            </View>
                                        ) : false
                                    }
                                </View>
                            ) : false
                        }
                    </View>
                </View>
            </TouchableOpacity>
        )
    }
    //跳转到个人名片
    toMy(item) {
        this.props.navigation.navigate('Personal_preview', { uid: item.uid, fromTo: 'yzlw', role_type: this.props.navigation.getParam('role_type') })
    }
}
const styles = StyleSheet.create({
    main: {
        backgroundColor: '#ebebeb',
        flex: 1
    },
    font: {
        color: '#999',
        fontSize: 15,
        textAlign: 'center',
    },
})