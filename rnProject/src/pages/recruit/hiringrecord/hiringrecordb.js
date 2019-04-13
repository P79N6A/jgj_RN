/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-25 11:05:36 
 * @Module：招聘记录-找人记录
 * @Last Modified time: 2019-03-25 11:05:36 
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
import ListItem from '../../../component/listitem'
import Header from '../../../component/listheader'
import Footer from '../../../component/listfooter'

export default class hiriingrecord extends Component {
    constructor(props) {
        super(props)
        //当前页
        this.page = 1
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
    }
    render() {
        return (
            <View style={{ backgroundColor: '#fff', flex: 1, }}>
                {/* 列表组件 */}
                <ListItem
                    data={this.state.dataSource}
                    ListHeaderComponent={() => <Header navigate={this.props.navigate} />}//头布局
                    renderItem={({item}) => <List data={item} navigate={this.props.navigate}/>}//item显示的布局
                    ListFooterComponent={() => <Footer navigate={this.props.navigate} />}//尾布局
                    ListEmptyComponent={() => <Empty />}// 空布局
                    onEndReached={() => this._onLoadMore()}//加载更多
                    onRefresh={() => this._onRefresh()}//下拉刷新相关
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
class List extends React.Component{
    constructor(props) {
        super(props)
        this.state = {}
    }
    render(){
        const item = this.props.data
        return(
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
// 空布局
class Empty extends React.Component{
    constructor(props) {
        super(props)
        this.state = {}
    }
    render(){
        return(
            <View style={{ flex: 1 }}>
                <View style={{ marginBottom: 21, marginTop: 160, flexDirection: 'row', justifyContent: 'center' }}>
                    <Icon name="note" size={45} color="#999999" />
                </View>
                <Text style={styles.font}>你联系过的工人/ 班组长将会出现在这里</Text>
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