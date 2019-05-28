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
    RefreshControl,
    Modal
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import ListItem from '../../component/listitem'
import Header from '../../component/listheader'
import Footer from '../../component/listfooter'
import fetchFun from '../../fetch/fetch'
import Worker from '../workteam/work'
import { Flex } from '../../component/ui/index'
import { NavigationEvents } from 'react-navigation'
import * as _ from "lodash";
import AlertUser from '../../component/alertuser'

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
            ifFetchMore:false,
            ifLoadingMore:true,//是否显示加载更多加载框
            overList:false,//没有可以加载的数据

            // ----------实名or认证、突击弹框----------
            ifOpenAlert: false,//是否打开弹框
            param: '',//实名or认证、突击
            // ---------------------------------------
        }
        this.getData = this.getData.bind(this)
        this.loadMoreDataThrottled = _.throttle(this._onLoadMore, 3000, {trailing: false});
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null, gesturesEnabled: false,
    });
    componentWillMount() {
        // this.getData()
    }
    // 获取我联系的数据
    getData(e) {
		e == 'refresh' && (this.page = 1) //#20816
        let { dataSource } = this.state
        fetchFun.load({
            url: 'v2/project/connectedOrCollectionServiceList',
            noLoading:true,//不显示自定义加载框
            data: {
                pg: this.page,
                pagesize: this.pagesize,
                type: 2,//1，收藏列表，2，联系过的列表,
                kind: 'recruit'
            },
            success: (res) => {
                console.log('---联系过的列表---', res)
                this.setState({
                    dataSource: e == 'refresh'?res:dataSource.concat(res),
                    ifFetchMore:true,
                    ifLoadingMore:res.length<10?false:true,//隐藏正在加载效果
                    overList:res.length<10 && !(this.state.dataSource.length==0 && res.length==0)?true:false
                })
            }
        });
    }
    render() {
        return (
            <View style={{ backgroundColor: '#fff', flex: 1, }}>
				<NavigationEvents onDidFocus={payload => this.getData('refresh')} />
                {/* 导航条 */}
                <View style={{
                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                }}>
                    <TouchableOpacity activeOpacity={.7} style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                        onPress={() => this.props.navigation.goBack()}>
                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>我联系的</Text>
                    </View>
                    <TouchableOpacity activeOpacity={.7}
                        // onPress={() => this.ifModalFun()
                        // }
                        style={{
                            width: '25%', height: '100%', marginRight: 10,
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end'
                        }}>
                    </TouchableOpacity>
                </View>

                {/* 列表组件 */}
                <ListItem
                    data={this.state.dataSource}
                    ListHeaderComponent={() => <Header navigate={this.props.navigate} />}//头布局
                    renderItem={({ item }) => <List data={item} navigation={this.props.navigation} getData={this.getData} navigate={this.props.navigate} alertFun={this.alertFun.bind(this)} />}//item显示的布局
                    ListFooterComponent={() => <Footer overList={this.state.overList} navigate={this.props.navigate} ifLoadingMore = {this.state.ifLoadingMore} />}//尾布局
                    ListEmptyComponent={() => <Empty ifLoadingMore = {this.state.ifLoadingMore} />}// 空布局
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
            this.getData(refresh='refresh')
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
        if (this.isFresh) {
            this.setState({
                ifFetchMore: false,
            }, () => {
                // 不处于正在加载更多 && 有下拉刷新过，因为没数据的时候 会触发加载
                if (!this.state.isLoadMore && this.state.dataSource.length > 0 && this.state.showFoot !== 2) {
                    console.log('-----------------加载更多----------------')
                    this.page = this.page + 1
                    this.isFresh=false;
                    this.getData()
                }
            })
        }
    }
}
class List extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            showModal: false
        }
    }
    toggleModal() {
        let { showModal } = this.state
        this.setState({
            showModal: !showModal
        })
    }
    del(uid) {
        fetchFun.load({
            url: 'v2/project/clearOneConnectedService',
            data: {
                contacted_uid: uid
            },
            success: (res) => {
				// this.props.getData()
				this.props.getData(refresh='refresh')
                this.toggleModal()
            }
        });
    }
    alertFun(e){
        this.props.alertFun(e)
    }
    render() {
        const item = this.props.data
        return (
            <>
                <Worker item={item} navigation={this.props.navigation} alertFun={this.alertFun.bind(this)} />
                <Flex
                    style={{
                        paddingTop: 10,
                        paddingBottom: 10,
                        paddingLeft: 12,
                        paddingRight: 12,
                        backgroundColor: '#fafafa',
                        justifyContent: 'space-between'
                    }}
                >
                    <Text>联系时间:{item.last_contact_time}</Text>
                    <Text
                        onPress={() => this.toggleModal()}
                        style={{
                            color: '#666',
                            borderColor: '#999',
                            borderWidth: 1,
                            paddingTop: 5,
                            paddingBottom: 5,
                            paddingLeft: 10,
                            paddingRight: 10,
                            borderRadius: 2
                        }}
                    >
                        删除
					</Text>
                </Flex>
                <Modal
                    visible={this.state.showModal}
                    animationType="none"//从底部划出
                    transparent={true}//透明蒙层
                    onRequestClose={() => this.toggleModal()}//点击返回的回调函数
                    style={{ height: '100%' }}
                >
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.toggleModal()}
                        style={{ flex: 1, backgroundColor: 'rgba(0,0,0,.5)', flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        {/* 弹窗内容 */}
                        <View style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 300 }}>
                            <View style={{ padding: 16.5, minHeight: 100, justifyContent: 'center', alignItems: 'center' }}>
                                <Text>您确定要删除该联系记录吗？</Text>
                            </View>
                            {/* 按钮 */}
                            <View style={{
                                flexDirection: 'row', alignItems: 'center',
                                borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                            }}>
                                <TouchableOpacity activeOpacity={.7}
                                    onPress={() => this.toggleModal()}
                                    style={{
                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                        borderRightWidth: 1, borderRightColor: '#ebebeb', width: '50%', height: '100%'
                                    }}>
                                    <Text style={{ color: '#000', fontSize: 16.5 }}>取消</Text>
                                </TouchableOpacity>
                                <TouchableOpacity activeOpacity={.7}
                                    onPress={() => this.del(item.uid)}
                                    style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, height: '100%' }}>
                                    <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>确定</Text>
                                </TouchableOpacity>
                            </View>
                        </View>
                    </TouchableOpacity>
                </Modal>
            </>
        )
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
            !this.props.ifLoadingMore?(
                <View style={{ flex: 1 }}>
                    <View style={{ marginBottom: 21, marginTop: 160, flexDirection: 'row', justifyContent: 'center' }}>
                        <Image style={{ width: 80, height: 46 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/book.png` }}></Image>
                    </View>
                    <Text style={styles.font}>你联系过的工人/ 班组长将会出现在这里</Text>
                </View>
            ):false
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