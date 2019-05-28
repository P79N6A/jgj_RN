/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 16:48:27 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-18 16:17:34
 * Module:工人/班组-优质突击队
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
import Icon from "react-native-vector-icons/iconfont";
import ListItem from '../../component/listitem'
import Footer from '../../component/listfooter'
import Header from '../../component/listheader'
import fetchFun from '../../fetch/fetch'
import ImageCom from '../../component/imagecom';
import Images from '../../component/images';
import AlertUser from '../../component/alertuser'
import Thelabel from '../../component/thelabel'
import * as _ from "lodash";

export default class hiriingrecord extends Component {
    constructor(props) {
        super(props)
        //当前页
        this.page = 1
        this.pagesize = 10
        this.isFresh=false
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

            ifFetchMore: false,
            ifLoadingMore: true,//是否显示加载更多加载框
            overList: false,//没有可以加载的数据
        }
        this.loadMoreDataThrottled = _.throttle(this._onLoadMore, 3000, {trailing: false});
    }
    componentWillMount() {
        this.getWorkTeam()// 优质工人列表数据获取
    }
    getWorkTeam(e) {
        let { dataSource } = this.state
        fetchFun.load({
            url: 'v2/project/getCommandoRecommendResume',
            noLoading: true,//不显示自定义加载框
            data: {
                pg: this.page,
                pagesize: this.pagesize,
                kind: 'recruit'
            },
            success: (res) => {
                console.log('---优质突击队列表---', res)
                this.setState({
                    // dataSource: dataSource.concat(res),
                    dataSource: e == 'refresh' ? res : dataSource.concat(res),
                    ifFetchMore: true,
                    ifLoadingMore: res.length < 10 ? false : true,//隐藏正在加载效果
                    overList: res.length < 10 && !(this.state.dataSource.length == 0 && res.length == 0) ? true : false
                })
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
                    ListFooterComponent={() => <Footer ifLoadingMore={this.state.ifLoadingMore} overList={this.state.overList} />}//尾布局
                    ListEmptyComponent={() => <Empty ifLoadingMore={this.state.ifLoadingMore} />}// 空布局
                    onEndReached={() => setTimeout(()=>{this._onLoadMore()},500)}//加载更多//加载更多
                    onRefresh={() => this._onRefresh()}//下拉刷新相关
                    onContentSizeChange={()=>this.onContentSizeChange}
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
    // 下拉刷新
    _onRefresh = () => {
        // 不处于 下拉刷新
        if (!this.state.isRefresh) {
            this.page = 1
            this.getWorkTeam(refresh = 'refresh')
        }
    };
    onContentSizeChange=()=>{
        this.isFresh=true;
    }

    // 加载更多
    _onLoadMore() {
        if (this.isFresh) {
            this.setState({
                ifFetchMore: false,
            }, () => {
                // 不处于正在加载更多 && 有下拉刷新过，因为没数据的时候 会触发加载
                if (!this.state.isLoadMore && this.state.dataSource.length > 0 && this.state.showFoot !== 2) {
                    console.log('-----------------加载更多1----------------')
                    this.page = this.page + 1
                    this.getWorkTeam()
                }
            })
        }
    }
    componentWillUnmount() {
        this.loadMoreDataThrottled.cancel();
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
            !this.props.ifLoadingMore ? (
                <View style={{ flex: 1, }}>
                    <View style={{ marginBottom: 21, marginTop: 160, flexDirection: 'row', justifyContent: 'center' }}>
                        <Image style={{ width: 80, height: 46 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/book.png` }}></Image>

                    </View>
                    <Text style={styles.font}>优质工人数据为空</Text>
                </View>
            ) : false
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
        // console.log(this.props.data)
        const item = this.props.data
        return (
            <TouchableOpacity activeOpacity={.7}  onPress={() => this.props.navigate.navigate('Personal_preview', { uid: item.uid, fromTo: 'yzlw', role_type: '2', grorbz: '2', nameTo: 'grorbz' })}>
                <View style={{
                    flexDirection: 'row',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    marginTop: 11,
                    backgroundColor: '#fff',
                    paddingLeft: 10,
                    paddingTop: 12,
                    paddingBottom: 12,
                    paddingRight: 10,
                }}>
                    <View style={{ width: '100%' }}>
                        <View style={{ position: "relative" }}>
                            <Icon style={{ position: 'absolute', right: 0, top: '50%', marginBottom: 6 }} name="r-arrow" size={12} color="#000" />
                            <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                <View style={{
                                    // backgroundColor: 'rgb(114, 102, 202)', 
                                    flexDirection: 'row', alignItems: 'center',
                                    justifyContent: 'center',
                                    borderRadius: 4.4, width: 49, height: 49, marginRight: 15, overFlow: 'hidden'
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
                                    <View style={{
                                        flexDirection: 'row', alignItems: 'center',
                                        justifyContent: 'space-between', flexWrap: 'wrap'
                                    }}>
                                        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                            <Text style={{ color: '#000', fontSize: 17.6 }}>
                                                {item.real_name ? (item.real_name.length > 3 ? item.real_name.substr(0, 2) + "..." : item.real_name) : false}
                                            </Text>

                                            {/* 实名 */}
                                            {
                                                item.verified !== '0' ? (
                                                    <TouchableOpacity activeOpacity={.7}
                                                        onPress={() => this.props.alertFun('user-sm')}>
                                                        <Image style={{ width: 46, height: 16, marginLeft: 5 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/verified.png` }}></Image>
                                                    </TouchableOpacity>
                                                ) : (false)
                                            }

                                            {/* 认证 */}
                                            {
                                                item.group_verified == '1' ? (
                                                    <TouchableOpacity activeOpacity={.7}
                                                        onPress={() => this.props.alertFun('user-rz-tj')}
                                                    >
                                                        <Image style={{ width: 46, height: 16, marginLeft: 5 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/group-verified.png` }}></Image>
                                                    </TouchableOpacity>
                                                ) : (false)
                                            }

                                            {/* 突击队 */}
                                            {
                                                item.is_commando == '1' ? (
                                                    <TouchableOpacity activeOpacity={.7}
                                                        onPress={() => this.props.alertFun('user-tj')}>
                                                        <Image style={{ width: 46, height: 16, marginLeft: 5 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/commando-verified.png` }}></Image>
                                                    </TouchableOpacity>
                                                ) : (false)
                                            }
                                            {/* <Thelabel name = 'user' verified={item.verified} group_verified={item.group_verified} is_commando={item.is_commando} /> */}

                                        </View>

                                        {/* 地点 */}
                                        {
                                            item.current_addr ? (
                                                <View style={{ flexDirection: 'row', alignItems: 'center', marginRight: 15 }}>
                                                    <Icon name="place" size={15} color="#BFBFBF" />
                                                    <Text style={{ color: '#666', fontSize: 13.2, marginLeft: 5 }}>{item.current_addr}</Text>
                                                </View>
                                            ) : (false)
                                        }

                                    </View>
                                    <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' ,marginTop:6}}>
                                        <View style={{ flexDirection: 'row' }}>
                                            {
                                                item.nationality ? (
                                                    <Text style={{ color: '#666', fontSize: 13.2, marginRight: 10 }}>{item.nationality}族</Text>
                                                ) : (false)
                                            }
                                            {
                                                item.work_year && Number(item.work_year) != 0 ? (
                                                    <View
                                                        style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-start', marginRight: 10 }}>
                                                        <Text style={{ color: '#666', fontSize: 13.2 }}>工龄</Text>
                                                        <Text style={{ color: '#eb4e4e', fontSize: 13.2 }}> {item.work_year} </Text>
                                                        <Text style={{ color: '#666', fontSize: 13.2 }}>年</Text>
                                                    </View>
                                                ) : (false)
                                            }
                                            {
                                                item.scale && Number(item.scale) != 0 ? (
                                                    <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-start' }}>
                                                        <Text style={{ color: '#666', fontSize: 13.2 }}>队伍</Text>
                                                        <Text style={{ color: '#eb4e4e', fontSize: 13.2 }}> {item.scale} </Text>
                                                        <Text style={{ color: '#666', fontSize: 13.2 }}>人</Text>
                                                    </View>
                                                ) : (false)
                                            }
                                        </View>
                                        {/* <Icon style={{ marginRight: 5 }} name="r-arrow" size={12} color="#000" /> */}
                                    </View>
                                </View>
                            </View>

                            <View style={{ flexDirection: 'row', flexWrap: 'wrap', marginTop: 3 }}>
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
                                    ) : (false)
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
                                    ) : (false)
                                }
                            </View>

                            {
                                item.introduce ? (
                                    <View style={{ flexDirection: 'row', flexWrap: 'wrap', marginTop: 6.6 }}>
                                        <Text style={{ color: '#999', fontSize: 13.2 }} numberOfLines={1}>
                                            {item.introduce}
                                        </Text>
                                    </View>
                                ) : (false)
                            }
                        </View>

                        {
                            item.experience.pro_name || item.experience.content || item.experience.imgs ? (
                                <View style={{
                                    marginTop: 6.6, borderWidth: .5, borderColor: '#dbdbdb', borderRadius: 4.4,
                                    paddingLeft: 11, paddingRight: 11, paddingTop: 5.5, paddingBottom: 5.5,
                                    backgroundColor: '#F5F5F5', overFlow: 'hidden'
                                }}>
                                    {
                                        item.experience.pro_name ? (
                                            <Text style={{ color: '#000', marginBottom: 2.5, lineHeight: 15 }}>
                                                {item.experience.pro_name.length > 25 ? item.experience.pro_name.substr(0, 25) + "..." : item.experience.pro_name}
                                            </Text>
                                        ) : (false)
                                    }

                                    {
                                        item.experience.content ? (
                                            <Text style={{ color: '#666', height: 15.4, marginTop: 1.1, marginBottom: 2.5, lineHeight: 15 }} numberOfLines={1}>
                                                {item.experience.content.length > 25 ? item.experience.content.substr(0, 25) + "..." : item.experience.content}

                                            </Text>
                                        ) : (false)
                                    }

                                    <View style={{ flexDirection: 'row', flexWrap: 'wrap' ,width:'100%'}}>
                                        {
                                            item.experience.imgs && item.experience.imgs.length > 0 ? (
                                                item.experience.imgs.map((items, indexs) => {
                                                    return (
                                                        <Images
                                                            key={indexs}
                                                            userPic={items}
                                                            index={indexs}
                                                            lengths={item.experience.imgs.length}
                                                            modalNum='3'
                                                            width='75'
                                                            height='75'
                                                            marginRight='5'
                                                            marginBottom='5'
                                                        />
                                                    )
                                                })
                                            ) : (false)
                                        }
                                    </View>
                                </View>
                            ) : (false)
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