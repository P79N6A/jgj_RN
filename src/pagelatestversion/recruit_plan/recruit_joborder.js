/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 16:32:59
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-03-29 16:33:21
 * Module:招聘订单
 */

import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image,
    TouchableOpacity,
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import ListItem from '../../component/listitem'
import Header from '../../component/listheader'
import Footer from '../../component/listfooter'

import fetchFun from '../../fetch/fetch'
import * as _ from "lodash";

export default class recruitplan extends Component {
    constructor(props) {
        super(props);
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
            initLoad:false,
            last_time:'',

            ifFetchMore: false,
            ifLoadingMore: true,//是否显示加载更多加载框
            overList: false,//没有可以加载的数据
        }
        this.loadMoreDataThrottled = _.throttle(this._onLoadMore, 3000, {trailing: false});
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null,gesturesEnabled: false,
    });
    componentDidMount(){
        this._getHotList()
    }
    render() {
        return (
            <View style={{ backgroundColor: '#fff', flex: 1 }}>
                {/* 导航条 */}
                <View style={{
                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                }}>
                    <TouchableOpacity activeOpacity={.7} style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                                      onPress={() => {this.props.navigation.goBack(),this.props.navigation.state.params.callback()}}>
                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>招聘订单</Text>
                    </View>
                    <TouchableOpacity activeOpacity={.7} style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>

                {/* 列表组件 */}
                <ListItem
                    data={this.state.dataSource}
                    ListHeaderComponent={() => <Header />}//头布局
                    renderItem={({ item }) => <List data={item} />}//item显示的布局
                    ListFooterComponent={() => <Footer ifLoadingMore={this.state.ifLoadingMore} overList={this.state.overList} />}//尾布局
                    ListEmptyComponent={() => <Empty ifLoadingMore={this.state.ifLoadingMore}  initLoad={this.state.initLoad} />}// 空布局
                    onEndReached={() => setTimeout(()=>{this._onLoadMore()},500)}//加载更多//加载更多
                    onRefresh={() => this._onRefresh()}//下拉刷新相关
                    onContentSizeChange={()=>this.onContentSizeChange}
                />
            </View>
        )
    }
    // 获取数据事件
    _getHotList(e) {
        let { dataSource ,last_time} = this.state
        // this.state.isLoadMore = true

        fetchFun.load({
            url: 'workday/recruit-order-list',
            newApi: true,
            noLoading: true,//不显示自定义加载框
            type: 'GET',
            data: {
                pg: this.page,
                pagesize: this.pagesize,
                last_time
            },
            success: (res) => {
                console.log('---招聘订单---',res)
                let responseJson = res
                this.isFresh=true;
                this.setState({
                    dataSource: e == 'refresh' ? res : this.state.dataSource.concat(res),
                    ifFetchMore: true,
                    ifLoadingMore: res.length < 10 ? false : true,//隐藏正在加载效果
                    // overList:res.length<10 && !(this.state.dataSource.length==0 && res.length==0)?true:false
                }, () => {
                    this.setState({
                        overList: this.state.dataSource.length == 0 ? false : (this.state.ifLoadingMore ? false : true)
                    })
                })
                // if (this.page === 1) {
                //     console.log("重新加载")
                //     this.setState({
                //         isLoadMore: false,
                //         dataSource: responseJson
                //     })
                // } else {
                //     console.log("加载更多")
                //     this.isFresh=true;
                //     this.setState({
                //         isLoadMore: false,
                //         // 数据源刷新 add
                //         // dataSource: this.state.dataSource.concat(responseJson)
                //         dataSource: e == 'refresh'?responseJson:dataSource.concat(responseJson),
                //         last_time:res[res.length-1] && res[res.length-1].order_time_str?res[res.length-1].order_time_str:'',
                //
                //
                //
                // })
                //     if (this.page <= 3) {
                //         this.setState({
                //             showFoot: 1
                //         })
                //     } else if (this.page > 3) {
                //         this.setState({
                //             showFoot: 2
                //         })
                //     }
                // }
            }
        })
    }
    // 下拉刷新
    _onRefresh = () => {
        // 不处于 下拉刷新
        if (!this.state.isRefresh) {
            this.page = 1
            this._getHotList(refresh='refresh')
        }
    };
    onContentSizeChange=()=>{
        this.isFresh=true;
    }
    componentWillUnmount() {
        this.loadMoreDataThrottled.cancel();
    }
    // 加载更多
    _onLoadMore() {

        if (this.isFresh && this.state.dataSource && this.state.dataSource.length>=10) {
            this.setState({
                ifFetchMore: false,
            }, () => {
                // 不处于正在加载更多 && 有下拉刷新过，因为没数据的时候 会触发加载
                if (!this.state.isLoadMore && this.state.dataSource.length > 0 && this.state.showFoot !== 2) {
                    console.log('-----------------加载更多----------------')
                    this.page = this.page + 1
                    this.isFresh=false;
                    this._getHotList()
                }
            })
        }
    }
}
// 空布局
class Empty extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        // console.log(this.props.ifLoadingMore,'空布局')

        return (
            <>
                {!this.props.ifLoadingMore?
                    <View style={{ height: '100%', }}>
                        <View style={{ marginBottom: 21, marginTop: 160, flexDirection: 'row', justifyContent: 'center' }}>
                            <Image style={{width:80,height:46}} source={{uri:`${GLOBAL.server}public/imgs/icon/book.png`}}></Image>
                        </View>
                        <Text style={styles.font}>你还未购买过任何招聘服务</Text>
                    </View>:
                    null
                }
            </>
        )
    }
}
// item布局
class List extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
        this.picType = {
            find_work:'have_job',
            worker_resume:'have_resume',
            foreman_auth:'foreman',
            worker_auth:'worker',
            commando_auth:'commando',
            release_project:'project',
            combine_combo:'combo',
            work:'jobwork'
        }
    }
    render() {
        const item = this.props.data
        return (
            <TouchableOpacity activeOpacity={.7} >
                <View style={{
                    flexDirection: 'row',
                    alignItems: 'center',
                    // justifyContent: 'center',
                    marginTop: 1,
                    backgroundColor: '#fff',
                    paddingTop:5,
                    paddingRight: 10,
                    paddingLeft:10,
                    paddingBottom:5
                }}>
                    <Image
                        source={{ uri: `${GLOBAL.server}public/imgs/my/shop/${this.picType[item.pic_type]}.png` }}
                        style={{
                            width:60,
                            height:60,
                            marginRight:15
                        }}
                    />
                    <View>
                        <Text style={{color:'#000',fontSize:15}}>{item.service_name}</Text>
                        <Text style={{color:'#666',fontSize:12}}>{item.pic_type.indexOf('_auth') != -1 ? `有效期：${item.order_num}年` : `购买数量：${item.order_num}`}</Text>
                    </View>
                </View>
                <View
                    style={{
                        flexDirection: 'row',
                        alignItems: 'center',
                        justifyContent: 'space-between',
                        backgroundColor: '#fff',
                        paddingRight: 10,
                        paddingLeft:10,
                        paddingBottom:10
                    }}
                >
                    <Text style={{color:'#666'}}>{item.order_time}</Text>
                    <Text style={{color:'#000'}}>支付金额：<Text style={{color:'#eb4e4e',fontSize:17}}>￥{item.order_price}</Text></Text>
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