/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-22 14:06:54 
 * @Module:发布招工-可能合适你的人
 * @Last Modified time: 2019-03-22 14:06:54 
 */
import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image,
    TouchableOpacity,
    DeviceEventEmitter
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import ListItem from '../../component/listitem'
import Footer from '../../component/listfooter'
import fetchFun from '../../fetch/fetch'
import ImageCom from '../../component/imagecom';
import AlertUser from '../../component/alertuser'
import LinearGradient from 'react-native-linear-gradient'
import Information from '../../component/information'
import * as _ from "lodash";

export default class musuit extends Component {
    constructor(props) {
        super(props)
        //当前页
        this.page = 1
        this.pagesize = 10
        this.isFresh = false
        //状态
        this.state = {
            list: {},
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
            param: 'fbzg',//实名or认证、突击
            // ---------------------------------------
            pipeiView: true,
            ifFetchMore: false,
            ifLoadingMore: true,//是否显示加载更多加载框
            overList: false,//没有可以加载的数据
        }
        this.loadMoreDataThrottled = _.throttle(this._onLoadMore, 3000, { trailing: false });
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null, gesturesEnabled: false,
    });
    componentWillMount() {
        GLOBAL.suitType = this.props.navigation.getParam('type') ? this.props.navigation.getParam('type') : false
        this.setState({}, () => {
            this.getfbzgList()
            this.getList()
        })
    }
    // 发布数据
    getfbzgList() {
        console.log(GLOBAL.pid)
        fetchFun.load({
            url: 'jlwork/prodetailactive',
            noLoading: true,//不显示自定义加载框
            data: {
                pid: GLOBAL.pid,
                work_type: GLOBAL.fbzgType.fbzgTypeNum,//工种编号
            },
            success: (res) => {
                console.log('---发布数据---', res)
                this.setState({
                    list: res
                })
            }
        });
    }
    // 合适数据
    getList(e) {
        let { dataSource } = this.state
        fetchFun.load({
            url: 'jlforemanwork/findhelper',
            noLoading: true,//不显示自定义加载框
            data: {
                pg: this.page,
                pagesize: this.pagesize,
                cityno: GLOBAL.fbzgAddress.fbzgAddressTwoNum,//如果不传，默认是成都
                role_type: GLOBAL.suitType,//查找的角色，1工人，2班组
                work_type: GLOBAL.fbzgType.fbzgTypeNum,//工种编号,
                pro_type: GLOBAL.fbzgProject.fbzgProjectNum,//工程类别
            },
            success: (res) => {
                console.log('---合适的数据---', res)
                this.setState({
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
            <View style={{ backgroundColor: '#ebebeb', flex: 1 }}>
                {/* 导航条 */}
                <View style={{
                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                }}>
                    <TouchableOpacity activeOpacity={.7} style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                        onPress={() => {
                            this.props.navigation.navigate('Recruit_homepage'), DeviceEventEmitter.emit("EventType", param),
                                GLOBAL.fbzgType.fbzgTypeNum = '选择工种',
                                GLOBAL.fbzgProject.fbzgProjectNum = '选择工程类别'
                            this.setState({})
                        }}>
                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>可能合适你的人</Text>
                    </View>
                    <TouchableOpacity activeOpacity={.7}
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                {/* 列表组件 */}
                {
                    this.state.list ? (
                        <ListItem
                            data={this.state.dataSource}
                            ListHeaderComponent={() => <Header pipeiView={this.state.pipeiView} navigation={this.props.navigation} list={this.state.list} data={this.state.dataSource} alertFun={this.alertFun.bind(this)} />}//头布局
                            renderItem={({ item }) => <List data={item} navigation={this.props.navigation} alertFun={this.alertFun.bind(this)} />}//item显示的布局
                            ListFooterComponent={() => <Footer overList={this.state.overList} ifLoadingMore={this.state.ifLoadingMore} />}//尾布局
                            ListEmptyComponent={() => <Empty navigation={this.props.navigation} ifLoadingMore={this.state.ifLoadingMore} />}// 空布局
                            onEndReached={() => setTimeout(() => { this._onLoadMore() }, 500)}//加载更多
                            onRefresh={() => this._onRefresh()}//下拉刷新相关
                            onContentSizeChange={() => this.onContentSizeChange}
                        />
                    ) : false
                }

                {/* 弹框 */}
                <AlertUser ifOpenAlert={this.state.ifOpenAlert} alertFunr={this.alertFunr.bind(this)} param={this.state.param} />
            </View>
        )
    }
    // 下拉刷新
    _onRefresh = () => {
        // 不处于 下拉刷新
        if (!this.state.isRefresh) {
            this.page = 1
            this.getfbzgList()
            this.getList(refresh = 'refresh')
        }
    };
    onContentSizeChange = () => {
        this.isFresh = true;
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
                    this.isFresh = false;
                    this.getList()
                }
            })
        }
    }

    // ----------实名or认证、突击弹框----------
    // componentDidMount() {
    //     this.setState({
    //         ifOpenAlert: !this.state.ifOpenAlert,
    //     })
    // }
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
    // alertFunr() {
    //     this.setState({
    //         ifOpenAlert: false
    //     }, () => {
    //         setTimeout(() => {
    //             this.setState({
    //                 pipeiView: false
    //             })
    //         }, 2000)
    //     })
    // }
    // --------------------------------------

}
// 空布局
class Empty extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        return (
            !this.props.ifLoadingMore ? (
                <View style={{ height: '100%', }}>
                    <View style={{ marginBottom: 21, marginTop: 130, flexDirection: 'row', justifyContent: 'center' }}>
                        <Image style={{ width: 80, height: 46 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/book.png` }}></Image>
                    </View>
                    <Text style={{ textAlign: 'center' }}>没有找到相关工人或班组</Text>
                    <View style={{ flexDirection: "row", alignItems: "center", justifyContent: 'center' }}>
                        <Text style={{ color: '#999', fontSize: 15, textAlign: 'center', }}>建议你</Text>
                        <TouchableOpacity activeOpacity={.7} onPress={() => this.addressFun()}>
                            <Text style={{ color: '#eb4e4e', fontSize: 15, textAlign: 'center', }}>换个城市</Text>
                        </TouchableOpacity>
                        <Text style={{ color: '#999', fontSize: 15, textAlign: 'center', }}>试试</Text>
                    </View>
                </View>
            ) : false
        )
    }
    // 选择项目所在地
    addressFun() {
        if (GLOBAL.AddressOne && GLOBAL.AddressOne.length > 0) {
            this.props.navigation.navigate('Address', {
                name: '发布招工项目所在地',
                callback: (() => {
                    this.setState({})
                })
            })
        } else {
            fetchFun.load({
                url: 'jlcfg/cities',
                data: {
                    level: '1',//城市级别 1：省 2 市 3县
                    citycode: '0',//城市编码
                },
                success: (res) => {
                    console.log('---获取城市列表-省---', res)
                    GLOBAL.AddressOne = res
                    this.setState({}, () => {
                        this.props.navigation.navigate('Address', {
                            name: '发布招工项目所在地',
                            callback: (() => {
                                this.setState({})
                            })
                        })
                    })
                }
            });
        }
    }
}
// 头布局
class Header extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        console.log(this.props.list)
        let item = this.props.list
        return (
            <View>
                {
                    this.props.pipeiView ? (
                        <View
                            style={{
                                backgroundColor: '#fdf1e0', height: 40,
                                flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                borderBottomWidth: .5, borderBottomColor: '#ebebeb'
                            }}>
                            <Icon style={{ marginRight: 3 }} name="gouhao" size={14} color="#FF6600" />
                            <Text style={{ color: '#FF6600', fontSize: 13.2 }}>
                                发布成功，以下是根据你的条件匹配的帮手信息
                            </Text>
                        </View>
                    ) : false
                }

                <TouchableOpacity activeOpacity={.7}
                    onPress={() => this.props.navigation.navigate('Myrecruit_help')}
                    style={{
                        backgroundColor: '#fdf1e0', height: 40,
                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center', marginBottom: 10
                    }}>
                    <Text style={{ color: '#FF6600', fontSize: 13.2 }}>
                        如何防范骗子？
                    </Text>
                </TouchableOpacity>
                {
                    item.pro_title ? (
                        <TouchableOpacity activeOpacity={.7}
                            onPress={() => this.to(item)}
                            style={styles.information}>
                            <View style={styles.head}>
                                <View style={styles.headl}>
                                    <View style={{
                                        flexDirection: 'row', alignItems: 'center',
                                        justifyContent: 'center',
                                        borderRadius: 3
                                    }}>
                                        {
                                            item.classes ? (
                                                item.classes[0].cooperate_type ? (
                                                    item.classes[0].cooperate_type.type_name ? (
                                                        item.classes[0].cooperate_type.type_name == '突击队' ? (
                                                            <LinearGradient colors={['#9c16ca', '#5612BC',]}
                                                                start={{ x: 0.25, y: 0.25 }} end={{ x: 0.75, y: 0.75 }}
                                                                style={{
                                                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                    marginRight: 7, paddingLeft: 5, paddingRight: 5, paddingTop: 1,
                                                                    paddingBottom: 1, borderRadius: 9
                                                                }}>
                                                                <Text style={{ color: '#fff', fontSize: 12 }}>
                                                                    {item.classes[0].cooperate_type.type_name}
                                                                </Text>
                                                            </LinearGradient>
                                                        ) : (
                                                                item.classes[0].cooperate_type.type_name == '点工' ? (
                                                                    <LinearGradient colors={['#f97547', '#F53055',]}
                                                                        start={{ x: 0.25, y: 0.25 }} end={{ x: 0.75, y: 0.75 }}
                                                                        style={{
                                                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                            marginRight: 7, paddingLeft: 5, paddingRight: 5, paddingTop: 1,
                                                                            paddingBottom: 1, borderRadius: 9
                                                                        }}>
                                                                        <Text style={{ color: '#fff', fontSize: 12 }}>
                                                                            {item.classes[0].cooperate_type.type_name}
                                                                        </Text>
                                                                    </LinearGradient>
                                                                ) : (
                                                                        item.classes[0].cooperate_type.type_name == '包工' ? (
                                                                            <LinearGradient colors={['#4DBDEC', '#1259EA',]}
                                                                                start={{ x: 0.25, y: 0.25 }} end={{ x: 0.75, y: 0.75 }}
                                                                                style={{
                                                                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                                    marginRight: 7, paddingLeft: 5, paddingRight: 5, paddingTop: 1,
                                                                                    paddingBottom: 1, borderRadius: 9
                                                                                }}>
                                                                                <Text style={{ color: '#fff', fontSize: 12 }}>
                                                                                    {item.classes[0].cooperate_type.type_name}
                                                                                </Text>
                                                                            </LinearGradient>
                                                                        ) : (
                                                                                item.classes[0].cooperate_type.type_name == '总包' ? (
                                                                                    <LinearGradient colors={['#f97547', '#F53055',]}
                                                                                        start={{ x: 0.25, y: 0.25 }} end={{ x: 0.75, y: 0.75 }}
                                                                                        style={{
                                                                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                                                            marginRight: 7, paddingLeft: 5, paddingRight: 5, paddingTop: 1,
                                                                                            paddingBottom: 1, borderRadius: 9
                                                                                        }}>
                                                                                        <Text style={{ color: '#fff', fontSize: 12 }}>
                                                                                            {item.classes[0].cooperate_type.type_name}
                                                                                        </Text>
                                                                                    </LinearGradient>
                                                                                ) : false
                                                                            )
                                                                    )
                                                            )
                                                    ) : false
                                                ) : false
                                            ) : false
                                        }
                                    </View>
                                    <Text style={{ fontSize: 16, color: '#000' }}>{item.pro_title}</Text>
                                    {
                                        GLOBAL.userinfo.verified == 3 ? (
                                            item.is_company_auth == '2' ? (
                                                <TouchableOpacity activeOpacity={.7}
                                                    onPress={() => this.props.navigation.navigate('Recruit_rzdetailpage')}>
                                                    <Image style={{ width: 18, height: 17, marginLeft: 5, marginTop: 2 }}
                                                        source={{ uri: `${GLOBAL.server}public/imgs/icon/company_auth.png` }}></Image>
                                                </TouchableOpacity>
                                            ) : (
                                                    <TouchableOpacity activeOpacity={.7}
                                                        onPress={() => this.props.alertFun('information-sm')}>
                                                        <Image style={{ width: 46, height: 16, marginLeft: 5 }}
                                                            source={{ uri: `${GLOBAL.server}public/imgs/icon/jobverified.png` }} ></Image>
                                                    </TouchableOpacity>
                                                )
                                        ) : false
                                    }
                                </View>
                                {
                                    item.classes ? (
                                        <View style={styles.headr}>
                                            <Text>
                                                {item.classes[0].pro_type.type_name}
                                            </Text>
                                        </View>
                                    ) : false
                                }
                            </View>

                            {/* 字段显示组件 */}
                            <Information item={item} msNo={true} />

                        </TouchableOpacity>
                    ) : false
                }
                {
                    this.props.data.length ? (
                        <Text style={{ color: '#999', fontSize: 13.2, textAlign: 'center', marginBottom: 11 }}>以下是根据你所填条件匹配的帮手</Text>
                    ) : false
                }
            </View>
        )
    }
    to(item) {
        GLOBAL.fbzgType.fbzgTypeNum = '选择工种',
            GLOBAL.fbzgProject.fbzgProjectNum = '选择工程类别'
        this.setState({})
        this.props.navigation.navigate('Myrecruit_detailshow', {
            pid: item.pid,
            work_type: item.classes[0] ? item.classes[0].work_type.type_id : '', callback: (() => { }),
            item: item,
        })
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
            <TouchableOpacity activeOpacity={.7}
                onPress={() => this.tomy(item)}>
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
                                {
                                    item.real_name ? (
                                        <ImageCom
                                            style={{ borderRadius: 4.4, width: 49, height: 49, }}
                                            fontSize='17.6'
                                            userPic={item.head_pic}
                                            userName={item.real_name}
                                        />
                                    ) : false
                                }
                            </View>
                            <View style={{ flex: 1 }}>
                                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                        <Text style={{ color: '#000', fontSize: 17.6 }}>{item.real_name}</Text>
                                        {
                                            item.verified == 3 ? (
                                                <TouchableOpacity activeOpacity={.7}
                                                    onPress={() => this.props.alertFun('information-sm')}>
                                                    <Image style={{ width: 46, height: 16, marginLeft: 10 }} source={require('../../assets/recruit/verified.png')}></Image>
                                                </TouchableOpacity>
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
                                            ) : (
                                                    item.work_level && item.work_level.map((v, index) => {
                                                        return (
                                                            <View key={index} style={{ flexDirection: 'row' }}>
                                                                <Text style={{ color: '#666', fontSize: 13.2, marginRight: 3 }}>
                                                                    {v}
                                                                </Text>
                                                            </View>
                                                        )
                                                    })
                                                )
                                        }
                                    </View>
                                    <Icon style={{ marginRight: 5 }} name="r-arrow" size={12} color="#000" />
                                </View>
                            </View>
                        </View>

                        <View style={{ flexDirection: 'row', flexWrap: 'wrap', marginTop: 3 }}>
                            {
                                item.pro_type && item.pro_type.map((v, index) => {
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

                        <View style={{
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                            marginTop: 6.6, paddingTop: 11, borderTopWidth: 1, borderTopColor: '#ebebeb'
                        }}>
                            {
                                item.work_year > 0 ? (
                                    <View style={{ flexDirection: 'row' }}>
                                        <Text style={{ color: '#999', fontSize: 13.2, lineHeight: 19.8 }}>他有 </Text>
                                        <Text style={{ color: '#eb4e4e', fontSize: 13.2, lineHeight: 19.8 }}>{item.work_year}</Text>
                                        <Text style={{ color: '#999', fontSize: 13.2, lineHeight: 19.8 }}> 条项目经验</Text>
                                    </View>
                                ) : false
                            }
                        </View>
                    </View>
                </View>
            </TouchableOpacity>
        )
    }
    tomy(item) {
        this.props.navigation.navigate('Personal_preview',
            { uid: item.uid, fromTo: 'yzlw', role_type: GLOBAL.userinfo.role, is_close: 0 })
    }
}
const styles = StyleSheet.create({
    information: {
        paddingLeft: 15,
        paddingRight: 15,
        marginBottom: 15,
        backgroundColor: 'white',
        paddingTop: 10,
        paddingBottom: 10
    },
    head: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: "space-between",
        height: 38,
    },
    headl: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    headr: {
        fontSize: 14,
        backgroundColor: '#eee',
        borderRadius: 2,
        color: '#666',
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: "center",
        paddingLeft: 6,
        paddingRight: 6,
        paddingTop: 2.5,
        paddingBottom: 2.5,
    },
    main: {
        // borderTopWidth: .5,
        // borderTopColor: '#999',
        paddingBottom: 10
    },
    foot: {
        height: 32,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'flex-end'
    },
})