/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 16:48:27 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-04 18:07:25
 * Module:工人/班组-优质工人
 */

import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image,
    TouchableOpacity,
    AsyncStorage
} from 'react-native';
import Icon from "react-native-vector-icons/Ionicons";
import ListItem from '../../component/listitem'
import Footer from '../../component/listfooter'
import Header from '../../component/listheader'
import fetchFun from '../../fetch/fetch'
import ImageCom from '../../component/imagecom';
import Images from '../../component/images';
import AlertUser from '../../component/alertuser'

export default class hiriingrecord extends Component {
    constructor(props) {
        super(props)
        //当前页
        this.page = 1
        this.pagesize = 10
        //状态
        this.state = {
            // 列表数据结构
            dataSource: [],
            // 下拉刷新
            isRefresh: false,
            // 加载更多
            isLoadMore: false,
            // 控制foot  1：正在加载   2 ：无更多数据
            showFoot: 1,

            // ----------实名or认证、突击弹框----------
            ifOpenAlert: false,//是否打开弹框
            param: '',//实名or认证、突击
            // ---------------------------------------
        }
    }
    componentWillMount() {
        this.getWorkTeam()// 优质工人列表数据获取
    }
    getWorkTeam() {
        fetchFun.load({
            url: 'v2/project/getWorkmanRecommendResume',
            data: {
                pg: this.page,
                pagesize: this.pagesize
            },
            success: (res) => {
                console.log('---优质工人列表---', res)
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
            <View style={{ flex: 1 }}>
                {/* 列表组件 */}
                <ListItem
                    data={this.state.dataSource}
                    ListHeaderComponent={() => <Header />}//头布局
                    renderItem={({ item }) => <List data={item} navigate={this.props.navigate} alertFun={this.alertFun.bind(this)} />}//item显示的布局
                    ListFooterComponent={() => <Footer />}//尾布局
                    ListEmptyComponent={() => <Empty />}// 空布局
                    onEndReached={() => this._onLoadMore()}//加载更多
                    onRefresh={() => this._onRefresh()}//下拉刷新相关
                />
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
    // 获取数据事件
    _getHotList() {
        this.state.isLoadMore = true
        fetch("http://m.app.haosou.com/index/getData?type=1&page=" + this.page)
            .then((response) => response.json())
            .then((responseJson) => {
                console.log(responseJson)
                if (this.page === 1) {
                    console.log("重新加载")
                    this.setState({
                        isLoadMore: false,
                        dataSource: responseJson.list
                    })
                } else {
                    console.log("加载更多")
                    this.setState({
                        isLoadMore: false,
                        // 数据源刷新 add
                        dataSource: this.state.dataSource.concat(responseJson.list)
                    })
                    if (this.page <= 3) {
                        this.setState({
                            showFoot: 1
                        })
                    } else if (this.page > 3) {
                        this.setState({
                            showFoot: 2
                        })
                    }
                }


            })
            .catch((error) => {
                console.error(error);
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
            this.pagesize = this.pagesize + 10
            this.getWorkTeam()
        }
    }
}
//空布局
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
                <Text style={styles.font}>优质工人数据为空</Text>
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
            <TouchableOpacity activeOpacity={0.5} onPress={() => this.props.navigate.navigate('Personal_preview', { uid: item.uid, fromTo: 'yzlw', role_type: '1' })}>
                <View style={{
                    flexDirection: 'row',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    marginTop: 11,
                    backgroundColor: '#fff',
                    paddingLeft: 13,
                    paddingTop: 13,
                    paddingBottom: 13,
                    paddingRight: 5.5,
                }}>
                    <View style={{ width: '100%' }}>
                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                            <View style={{
                                // backgroundColor: 'rgb(114, 102, 202)', 
                                flexDirection: 'row', alignItems: 'center',
                                justifyContent: 'center',
                                borderRadius: 4.4, width: 49, height: 49, marginRight: 20, overFlow: 'hidden'
                            }}>
                                <ImageCom
                                    style={{ borderRadius: 4.4, width: 49, height: 49, }}
                                    fontSize='17.6'
                                    userPic={item.head_pic}
                                    userName={item.real_name}
                                />
                                {/* <Image
                                    source={{ uri:item.head_pic }}
                                    style={{width:49,height:49,borderRadius: 4.4}} /> */}
                            </View>
                            <View style={{ flex: 1 }}>
                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                        <Text style={{ color: '#000', fontSize: 17.6 }}>{item.real_name}</Text>

                                        {/* 实名 */}
                                        {
                                            item.verified !== '0' ? (
                                                <TouchableOpacity
                                                    onPress={() => this.props.alertFun('sm')}>
                                                    <Image style={{ width: 52, height: 18.5, marginLeft: 8 }} source={require('../../assets/recruit/verified.png')}></Image>
                                                </TouchableOpacity>
                                            ) : (<View></View>)
                                        }

                                        {/* 认证 */}
                                        {
                                            item.group_verified == '1' ? (
                                                <TouchableOpacity
                                                    onPress={() => this.props.alertFun('rz')}>
                                                    <Image style={{ width: 52, height: 18.5, marginLeft: 8 }} source={require('../../assets/recruit/group-verified.png')}></Image>
                                                </TouchableOpacity>
                                            ) : (<View></View>)
                                        }

                                        {/* 突击队 */}
                                        {
                                            item.is_commando == '1' ? (
                                                <TouchableOpacity
                                                    onPress={() => this.props.alertFun('tj')}>
                                                    <Image style={{ width: 52, height: 18.5, marginLeft: 8 }} source={require('../../assets/recruit/commando-verified.png')}></Image>
                                                </TouchableOpacity>
                                            ) : (<View></View>)
                                        }
                                    </View>

                                    {/* 地点 */}
                                    {
                                        item.current_addr ? (
                                            <View style={{ flexDirection: 'row', alignItems: 'center', marginRight: 15 }}>
                                                <Icon name="place" size={15} color="#BFBFBF" />
                                                <Text style={{ color: '#666', fontSize: 13.2, marginLeft: 5 }}>{item.current_addr}</Text>
                                            </View>
                                        ) : (<View></View>)
                                    }

                                </View>
                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                    <View style={{ flexDirection: 'row' }}>
                                        {
                                            item.nationality ? (
                                                <Text style={{ color: '#666', fontSize: 13.2, marginRight: 10 }}>{item.nationality}族</Text>
                                            ) : (<View></View>)
                                        }
                                        {
                                            item.work_year ? (
                                                <View
                                                    style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-start', marginRight: 10 }}>
                                                    <Text style={{ color: '#666', fontSize: 13.2 }}>工龄</Text>
                                                    <Text style={{ color: '#eb4e4e', fontSize: 13.2 }}> {item.work_year} </Text>
                                                    <Text style={{ color: '#666', fontSize: 13.2 }}>年</Text>
                                                </View>
                                            ) : (<View></View>)
                                        }
                                        {/* {
                                            item.work_year ? (
                                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-start' }}>
                                                    <Text style={{ color: '#666', fontSize: 13.2 }}>队伍</Text>
                                                    <Text style={{ color: '#eb4e4e', fontSize: 13.2 }}> {item.scale} </Text>
                                                    <Text style={{ color: '#666', fontSize: 13.2 }}>人</Text>
                                                </View>
                                            ) : (<View></View>)
                                        } */}
                                    </View>
                                    <Icon style={{ marginRight: 5 }} name="r-arrow" size={12} color="#000" />
                                </View>
                            </View>
                        </View>

                        <View style={{ flexDirection: 'row', flexWarp: 'warp', marginTop: 3 }}>
                            {
                                item.pro_type && item.pro_type.length > 0 ? (
                                    item.pro_type.map((item, index) => {
                                        return (
                                            <View key={index} style={{
                                                marginTop: 4.4, marginRight: 6.6, backgroundColor: '#eee', paddingLeft: 4.4, paddingRight: 4.4,
                                                paddingTop: 2.2, paddingBottom: 2.2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', borderRadius: 2.2
                                            }}>
                                                <Text style={{ color: '#666', fontSize: 13.2 }}>{item}</Text>
                                            </View>
                                        )
                                    })
                                ) : (<View></View>)
                            }

                            {
                                item.work_type && item.work_type.length > 0 ? (
                                    item.work_type.map((items, index) => {
                                        if (index !== item.work_type.length - 1) {
                                            return (
                                                <View key={index} style={{
                                                    marginTop: 4.4, marginRight: 1, paddingLeft: 4.4, paddingRight: 4.4,
                                                    paddingTop: 2.2, paddingBottom: 2.2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', borderRadius: 2.2
                                                }}>
                                                    <Text style={{ color: '#000', fontSize: 13.2 }}>{items} |</Text>
                                                </View>
                                            )
                                        } else {
                                            return (
                                                <View key={index} style={{
                                                    marginTop: 4.4, marginRight: 6.6, paddingLeft: 4.4, paddingRight: 4.4,
                                                    paddingTop: 2.2, paddingBottom: 2.2, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', borderRadius: 2.2
                                                }}>
                                                    <Text style={{ color: '#000', fontSize: 13.2 }}>{items}</Text>
                                                </View>
                                            )
                                        }
                                    })
                                ) : (<View></View>)
                            }
                        </View>

                        {
                            item.introduce ? (
                                <View style={{ flexDirection: 'row', flexWarp: 'warp', marginTop: 5, marginBottom: 5 }}>
                                    <Text style={{ color: '#999', fontSize: 13.2 }}>
                                        {item.introduce.length > 25 ? item.introduce.substr(0, 25) + "..." : item.introduce}
                                    </Text>
                                </View>
                            ) : (<View></View>)
                        }


                        {
                            item.experience.pro_name || item.experience.content || item.experience.imgs ? (
                                <View style={{
                                    borderWidth: 1, borderColor: '#dbdbdb', borderRadius: 4.4,
                                    paddingLeft: 11, paddingRight: 11, paddingTop: 5.5, paddingBottom: 5.5,
                                    backgroundColor: '#f5f5f5', overFlow: 'hidden'
                                }}>
                                    {
                                        item.experience.pro_name ? (
                                            <Text style={{ color: '#000', height: 23 }}>
                                                {item.experience.pro_name.length > 25 ? item.experience.pro_name.substr(0, 25) + "..." : item.experience.pro_name}
                                            </Text>
                                        ) : (<View></View>)
                                    }

                                    {
                                        item.experience.content ? (
                                            <Text style={{ color: '#666', height: 23, marginTop: 2.2 }}>
                                                {item.experience.content.length > 25 ? item.experience.content.substr(0, 25) + "..." : item.experience.content}
                                            </Text>
                                        ) : (<View></View>)
                                    }

                                    <View style={{ flexDirection: 'row', overFlow: 'hidden' }}>
                                        {
                                            item.experience.imgs && item.experience.imgs.length > 0 ? (
                                                item.experience.imgs.map((items, indexs) => {
                                                    return (
                                                        <Images
                                                            key={indexs}
                                                            userPic={items}
                                                            index={indexs}
                                                            lengths={item.experience.imgs.length}
                                                            modalNum='100'
                                                            width='88'
                                                            height='88'
                                                            marginRight='5.5'
                                                            marginBottom='5.5'
                                                        />
                                                    )
                                                })
                                            ) : (<View></View>)
                                        }
                                    </View>
                                </View>
                            ) : (<View></View>)
                        }

                    </View>
                </View>
            </TouchableOpacity>
        )
    }
}
const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#ebebeb',
    },
    font: {
        color: '#999',
        fontSize: 15,
        textAlign: 'center',
    },
});