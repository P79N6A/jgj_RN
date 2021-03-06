/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-25 15:15:20 
 * @Module:招聘订单
 * @Last Modified time: 2019-03-25 15:15:20 
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
import Icon from "react-native-vector-icons/iconfont";
import ListItem from '../../../component/listitem'
import Header from '../../../component/listheader'
import Footer from '../../../component/listfooter'
import * as _ from "lodash";

export default class recruitplan extends Component {
    constructor(props) {
        super(props);
        //当前页
        this.page = 1
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
        }
        this.loadMoreDataThrottled = _.throttle(this._onLoadMore, 3000, {trailing: false});
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null,gesturesEnabled: false,
    });
    render() {
        return (
            <View style={{ backgroundColor: '#fff', flex: 1 }}>
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>招聘订单</Text>
                    </View>
                    <TouchableOpacity style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>

                {/* 列表组件 */}
                <ListItem
                    data={this.state.dataSource}
                    ListHeaderComponent={() => <Header />}//头布局
                    renderItem={({ item }) => <List data={item} />}//item显示的布局
                    ListFooterComponent={() => <Footer />}//尾布局
                    ListEmptyComponent={() => <Empty />}// 空布局
                    onEndReached={() => setTimeout(()=>{this._onLoadMore()},500)}//加载更多//加载更多
                    onRefresh={() => this._onRefresh()}//下拉刷新相关
                    onContentSizeChange={()=>this.onContentSizeChange}
                />
            </View>
        )
    }
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
            this._getHotList()
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
                    console.log('-----------------加载更多----------------')
                    this.page = this.page + 1
                    this.isFresh=false;
                    this._getHotList()
                }
            })
        }
    }
    componentWillUnmount() {
        this.loadMoreDataThrottled.cancel();
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
            <View style={{ height: '100%', }}>
                <View style={{ marginBottom: 21, marginTop: 160, flexDirection: 'row', justifyContent: 'center' }}>
                    <Image style={{width:80,height:46}} source={{uri:`${GLOBAL.server}public/imgs/icon/book.png`}}></Image>

                </View>
                <Text style={styles.font}>你还未购买过任何招聘服务</Text>
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
            <TouchableOpacity activeOpacity={0.5}>
                <View style={{
                    flexDirection: 'row',
                    alignItems: 'center',
                    // justifyContent: 'center',
                    marginTop: 5,
                    backgroundColor: '#fff',
                    padding: 10
                }}>
                    <Image source={{ uri: item.logo_url }} style={styles.itemImages} />
                    <Text style={{ marginLeft: 6 }}>
                        {item.baike_name}
                    </Text>
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