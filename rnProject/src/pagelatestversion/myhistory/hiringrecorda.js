/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-04-08 15:52:06 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-09 11:11:14
 * Module:我的招工
 */

import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image,
    ScrollView,
    TouchableOpacity,
    Platform,
    FlatList,
    RefreshControl
} from 'react-native';
import Icon from "react-native-vector-icons/Ionicons";
import ListItem from '../../component/listitem'
import Footer from '../../component/listfooter'
import fetchFun from '../../fetch/fetch'

export default class hiriingrecord extends Component {
    constructor(props) {
        super(props)
        //当前页
        this.page = 1
        this.pagesize = 10
        //状态
        this.state = {
            // 列表数据结构
            dataSource: [
            ],
            // 下拉刷新
            isRefresh: false,
            // 加载更多
            isLoadMore: false,
            // 控制foot  1：正在加载   2 ：无更多数据
            showFoot: 1,
        }
    }
    componentWillMount() {
        this.getList()//我的招工数据
    }
    // 我的招工数据
    getList() {
        fetchFun.load({
            url: 'jlforemanwork/getselfproliststandard',
            data: {
                pg: this.page,
                pagesize: this.pagesize
            },
            success: (res) => {
                console.log('---我的招工数据---', res)
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
            <View style={{ backgroundColor: '#fff', flex: 1, }}>
                {/* 列表组件 */}
                <ListItem
                    data={this.state.dataSource}
                    ListHeaderComponent={() => <Header />}//头布局
                    renderItem={({ item }) => <List data={item} navigation={this.props.navigation} />}//item显示的布局
                    ListFooterComponent={() => <Footer navigation={this.props.navigation} />}//尾布局
                    ListEmptyComponent={() => <Empty />}// 空布局
                    onEndReached={() => this._onLoadMore()}//加载更多
                    onRefresh={() => this._onRefresh()}//下拉刷新相关
                />

                {/* 底部按钮 */}
                <TouchableOpacity
                    onPress={() => this.props.navigation.navigate('Myrecruit')}
                    style={{ backgroundColor: '#fafafa', height: 66, padding: 11, position: 'absolute', bottom: 0, width: '100%', height: 66 }}>
                    <View style={{ backgroundColor: '#eb4e4e', flexDirection: 'row', alignItems: 'center', justifyContent: 'center', borderRadius: 4.4, height: 44 }}>
                        <Text style={{ color: '#fff', fontSize: 18.7 }}>发布招工</Text>
                    </View>
                </TouchableOpacity>

            </View>
        )
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
// 头部布局
class Header extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        return (
            <View style={{ backgroundColor: '#fdf1e0', padding: 6.6 }}>
                <Text style={{ color: '#f18215', fontSize: 13.2, marginLeft: 70 }}>1、经常刷新招工信息能够让你的招工信息更靠前</Text>
                <Text style={{ color: '#f18215', fontSize: 13.2, marginLeft: 70 }}>2、若工人已招满，请及时停止招工</Text>
            </View>
        )
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
                onPress={() => this.listItemClick(item)}
                style={{ backgroundColor: '#fff', paddingLeft: 11, paddingRight: 11, marginBottom: 11 }}>
                <View style={{
                    paddingTop: 6.6, paddingBottom: 6.6, flexDirection: 'row', alignItems: 'center',
                    justifyContent: 'space-between'
                }}>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                        <View style={{
                            marginRight: 7, backgroundColor: item.classes[0].cooperate_type.type_name == '突击队' ? '#4886ed' : '#eb7a4e', paddingLeft: 2, paddingRight: 2,
                            paddingTop: 2, paddingBottom: 1, borderRadius: 3, flexDirection: 'row',
                            alignItems: 'center', justifyContent: 'center'
                        }}>
                            <Text style={{ color: '#fff', fontSize: 12 }}>
                                {item.classes[0].cooperate_type.type_name}
                            </Text>
                        </View>
                        <Text style={{ color: '#000', fontSize: 17.6 }}>
                            {item.pro_title}
                        </Text>
                        {/* <Image style={{ width: 51, height: 18, marginLeft: 8 }}
                            source={require('../../assets/recruit/jobverified.png')} ></Image> */}
                    </View>
                    <View style={{
                        backgroundColor: '#eee', paddingLeft: 5.5, paddingRight: 5.5,
                        paddingTop: 2.2, paddingBottom: 2.2, borderRadius: 2.2
                    }}>
                        <Text style={{ color: '#666', fontSize: 13.2 }}>
                            {item.classes[0].pro_type.type_name}
                        </Text>
                    </View>
                </View>

                <View style={{
                    borderBottomWidth: 1, borderBottomColor: "#ebebeb",
                    flexDirection: 'row',
                    alignItems: 'center', justifyContent: 'space-between',
                    paddingTop: 11, paddingBottom: 11
                }}>
                    <View style={{ flex: 1 }}>
                        <View style={{ flexDirection: 'row', alignItems: 'center', marginBottom: 7 }}>
                            {
                                item.welfare.map((v, index) => {
                                    return (
                                        <View key={index} style={{
                                            borderRightWidth: index == 0 ? 0 : 1, borderRightColor: '#333333', paddingRight: 7,
                                            flexDirection: 'row', alignItems: 'center', height: 16, marginRight: 7
                                        }}>
                                            <Text style={{ color: '#333333', fontSize: 14, marginTop: 5, marginTop: 0 }}>{v}</Text>
                                        </View>
                                    )
                                })
                            }
                        </View>
                        <View style={{ flexDirection: 'row', flexWarp: 'warp' }}>
                            <View style={{ width: '50%' }}>
                                <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                    <Text style={{ color: '#000', fontSize: 15.4, fontWeight: '700' }}>单价：</Text>
                                    <Text style={{ color: '#eb4e4e', fontSize: 15.4, fontWeight: '700' }}>
                                        {item.classes[0].money}
                                    </Text>
                                    <Text style={{ color: '#999', fontSize: 15.4, fontWeight: '700' }}>元/平方米</Text>
                                </View>
                            </View>
                            <View style={{ width: '50%' }}>
                                <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                    <Text style={{ color: '#000', fontSize: 15.4, fontWeight: '700' }}>规模：</Text>
                                    <Text style={{ color: '#eb4e4e', fontSize: 15.4, fontWeight: '700' }}>{item.classes[0].total_scale}万</Text>
                                    <Text style={{ color: '#999', fontSize: 15.4, fontWeight: '700' }}>平方米</Text>
                                </View>
                            </View>
                        </View>
                        <Text style={{ color: '#999', fontSize: 14, marginTop: 5 }}>项目描述</Text>
                    </View>
                    <View>
                        <Icon name="r-arrow" size={12} color="#000" />
                    </View>
                </View>

                <View style={{
                    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                    paddingTop: 5.2, paddingBottom: 5.2
                }}>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                        <View style={{
                            borderWidth: 1, borderColor: "#666666",
                            marginRight: 10, paddingLeft: 6, paddingRight: 6, paddingTop: 4, paddingBottom: 4,
                            borderRadius: 4
                        }}>
                            <Text style={{ color: '#333333', fontSize: 12 }}>停止招工</Text>
                        </View>
                        <View style={{
                            borderWidth: 1, borderColor: "#666666",
                            marginRight: 10, paddingLeft: 6, paddingRight: 6, paddingTop: 4, paddingBottom: 4,
                            borderRadius: 4
                        }}>
                            <Text style={{ color: '#333333', fontSize: 12 }}>刷新</Text>
                        </View>
                        <View style={{
                            borderWidth: 1, borderColor: "#666666",
                            marginRight: 10, paddingLeft: 6, paddingRight: 6, paddingTop: 4, paddingBottom: 4,
                            borderRadius: 4
                        }}>
                            <Text style={{ color: '#333333', fontSize: 12 }}>修改</Text>
                        </View>
                        <View style={{
                            borderWidth: 1, borderColor: "#666666",
                            marginRight: 10, paddingLeft: 6, paddingRight: 6, paddingTop: 4, paddingBottom: 4,
                            borderRadius: 4
                        }}>
                            <Text style={{ color: '#333333', fontSize: 12 }}>删除</Text>
                        </View>
                    </View>
                    <TouchableOpacity
                        style={{
                            paddingLeft: 11, paddingTop: 3, paddingBottom: 3,
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                        }}>
                        <Icon name="peoples" size={16} color="#EB4E4E" />
                        <Text style={{ color: '#000', fontSize: 15.4, fontWeight: 'bold', marginLeft: 6 }}>合适的人</Text>
                    </TouchableOpacity>
                </View>

            </TouchableOpacity>

        )
    }
    listItemClick(item) {
        this.props.navigation.navigate('Recruit_jobdetails', { pid: item.pid })
    }
}
// 空布局
class Empty extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        return (
            <View style={{ flex: 1, }}>
                <View style={{ marginBottom: 21, marginTop: 160, flexDirection: 'row', justifyContent: 'center' }}>
                    <Icon name="note" size={45} color="#999999" />
                </View>
                <Text style={styles.font}>我的招工数据为空</Text>
            </View>
        )
    }
}
const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#fff',
    },
    font: {
        color: '#999',
        fontSize: 15,
        textAlign: 'center',
    },
});