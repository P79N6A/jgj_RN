/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 16:59:12 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-04 17:49:03
 * Module:名片预览
 */

import React, { Component } from 'react';
import {
    Image,
    StyleSheet,
    Text,
    TouchableOpacity,
    View,
    Modal,
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import Icon from "react-native-vector-icons/Ionicons";
import ListItem from '../../component/listitem'
import fetchFun from '../../fetch/fetch'
import ImageCom from '../../component/imagecom';
import Images from '../../component/images';
import Alert from '../../component/alert'
import AlertUser from '../../component/alertuser'

export default class readme extends Component {
    constructor(props) {
        super(props);
        //当前页
        this.page = 1
        this.pagesize = 10
        //状态
        this.state = {
            fromTo: '',
            uid: '',//id
            role_type: '',//1，工人，2工头
            ifOperation: false,//是否被收藏
            ifmore: false,
            // 列表数据结构
            dataSource: [],
            headerData: {},
            // 下拉刷新
            isRefresh: false,
            // 加载更多
            isLoadMore: false,
            // 控制foot  1：正在加载   2 ：无更多数据
            showFoot: 1,

            ifError: true,
            alertValue: '',
            openAlert: false,

            ifOpenAlert:false,//是否打开弹框
            param:'',//实名or认证、突击
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });
    componentWillMount() {
        let uid = [this.props.navigation.getParam('uid')]
        let fromTo = [this.props.navigation.getParam('fromTo')]
        let role_type = [this.props.navigation.getParam('role_type')]
        this.setState({
            fromTo: fromTo,
            uid: uid,
            role_type: role_type
        }, () => {
            this.getData(uid)//获取该人名片数据
        })

    }
    //获取个人名片数据
    getData(uid) {
        fetchFun.load({
            url: 'v2/workday/getResumeInfo',
            data: {
                uid: uid[0],
                role: this.state.role_type[0],//默认当前角色 (只能工人角色)
                flag: 1,//默认为0 （浏览简历标识 浏览：1）
                share: 0,//默认为0 （分享后浏览简历标识 浏览：1）
            },
            success: (res) => {
                console.log('---名片数据---', res)
                if (res.state == 1) {
                    this.setState({
                        headerData: res.values
                    })
                    if (res.values.is_collection == 1) {//已被收藏
                        this.setState({
                            ifOperation: true
                        })
                    }
                }
                this.projectList(uid)//获取项目经验数据
            }
        });
    }
    // 获取项目经验数据
    projectList(uid) {
        fetchFun.load({
            url: 'jlwork/getproexperience',
            data: {
                pg: this.page,
                pagesize: this.pagesize,
                uid: uid[0],
            },
            success: (res) => {
                console.log('---项目经验---', res)
                if (res.state == 1) {
                    this.setState({
                        dataSource: res.values
                    })
                }
            }
        });
    }
    render() {
        let headerObj = {
            fromTo: this.state.fromTo,
            uid: this.state.uid,
            role_type: this.state.role_type,
            ifOperation: this.state.ifOperation,
        }
        return (
            <View style={styles.container}>
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
                        {
                            this.state.headerData !== '{}' ? (
                                <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>
                                    {this.state.headerData.realname}的找活名片
                                </Text>
                            ) : (<View></View>)
                        }

                    </View>
                    <TouchableOpacity
                        style={{
                            width: '25%', height: '100%', marginRight: 10,
                            flexDirection: 'row', alignItems: 'center',
                            justifyContent: 'flex-end'
                        }}>
                        {
                            this.state.fromTo == 'yzlw' ? (
                                <TouchableOpacity onPress={() => this.moreFun()}>
                                    <Text style={{ fontSize: 17, color: '#eb4e4e', fontWeight: '400', }}>
                                        更多
                                    </Text>
                                </TouchableOpacity>
                            ) : false
                        }
                    </TouchableOpacity>
                </View>

                {/* 举报按钮弹框 */}
                <Modal
                    animationType="none"
                    transparent={true}
                    visible={this.state.ifmore}
                    onRequestClose={() => {
                        this.setState({
                            ifmore: !this.state.ifmore
                        })
                    }}>
                    <TouchableOpacity style={{ width: '100%', height: '100%' }}
                        onPress={() => this.setState({
                            ifmore: !this.state.ifmore
                        })}>
                        <View style={{ position: 'absolute', right: 11, top: 62, }}>
                            <View style={{
                                position: 'absolute',
                                right: 10, top: -10,
                                width: 0,
                                height: 0,
                                borderWidth: 12,
                                borderTopWidth: 0,
                                borderColor: 'rgba(74,74,74,0)',
                                borderBottomColor: 'rgb(74,74,74)'
                            }}></View>

                            <TouchableOpacity
                                onPress={() => this.toReport()}
                                style={{
                                    width: 101, height: 56, paddingLeft: 17.6, paddingRight: 17.6, paddingTop: 15.4, paddingBottom: 15.4,
                                    backgroundColor: "rgb(74,74,74)", flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                    borderRadius: 4
                                }}>
                                <Icon name="shield" size={17} color="#fff" />
                                <Text style={{ color: "#fff", fontSize: 16 }}>举报</Text>
                            </TouchableOpacity>
                        </View>
                    </TouchableOpacity>
                </Modal>

                {/* 列表组件 */}
                <ListItem
                    data={this.state.dataSource}
                    ListHeaderComponent={() => <Header headerData={this.state.headerData} headerObj={headerObj} updateOperation={this.updateOperation.bind(this)} alertFun={this.alertFun.bind(this)} />}//头布局
                    renderItem={({ item }) => <List data={item} lastItemId={this.state.dataSource[this.state.dataSource.length - 1].id} />}//item显示的布局
                    ListFooterComponent={() => <Footer openFun={this.openFun.bind(this)} />}//尾布局
                    ListEmptyComponent={() => <Empty />}// 空布局
                    onEndReached={() => this._onLoadMore()}//加载更多
                    onRefresh={() => this._onRefresh()}//下拉刷新相关
                />

                {/* 弹框 */}
                <Alert
                    alertValue={this.state.alertValue}
                    ifError={this.state.ifError}
                    openAlert={this.state.openAlert}
                    openAlertFun={this.openAlertFun.bind(this)} />

                {/* 按钮 */}
                <View style={{
                    position: 'absolute', bottom: 0, height: 66, width: '100%',
                    backgroundColor: "#fff", padding: 11, flexDirection: 'row'
                }}>
                    <View style={{
                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1,
                        borderWidth: 1, borderColor: 'rgb(235, 78, 78)', borderRadius: 4, marginRight: 11
                    }}>
                        <Text style={{ color: '#eb4e4e', fontSize: 20 }}>和他聊聊</Text>
                    </View>
                    <View style={{
                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1,
                        backgroundColor: 'rgb(235, 78, 78)', borderRadius: 4, position: 'relative'
                    }}>
                        <Text style={{ color: '#fff', fontSize: 20 }}>拨打电话</Text>
                        <Icon style={{ position: 'absolute', right: 4, top: -13 }} name="gtgk" size={50} color="#fff" />
                    </View>
                </View>
            
                {/* 弹框-实名、认证、突击 */}
                <AlertUser ifOpenAlert={this.state.ifOpenAlert} alertFunr={this.alertFunr.bind(this)} param={this.state.param} />
            </View>
        );
    }
    alertFun(e){
        this.setState({
            ifOpenAlert:!this.state.ifOpenAlert,
            param:e,
        })
    }
    alertFunr(){
        this.setState({
            ifOpenAlert:false
        })
    }
    openAlertFun() {
        this.setState({
            openAlert: !this.state.openAlert
        })
    }
    // 打开弹框
    openFun() {
        this.setState({
            openAlert: true,
            alertValue: '该微信号：g918010已复制，请在微信中添加朋友时粘贴搜索'
        }, () => {
            setTimeout(() => {
                this.setState({
                    openAlert: !this.state.openAlert
                })
            }, 1000)
        })
    }
    //点击举报
    toReport() {
        this.setState({
            ifmore: !this.state.ifmore
        })
        this.props.navigation.navigate('Personal_report', { uid: this.state.uid })
    }
    //更改是否已收藏状态
    updateOperation() {
        this.setState({
            ifOperation: !this.state.ifOperation
        })
    }
    // 点击更多
    moreFun() {
        this.setState({
            ifmore: !this.state.ifmore
        })
    }
    // 下拉刷新
    _onRefresh = () => {
        // 不处于 下拉刷新
        if (!this.state.isRefresh) {
            this.page = 1
        }
    };
    // 加载更多
    _onLoadMore() {
        // 不处于正在加载更多 && 有下拉刷新过，因为没数据的时候 会触发加载
        if (!this.state.isLoadMore && this.state.dataSource.length > 0 && this.state.showFoot !== 2) {
            this.page = this.page + 1
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
        let item = this.props.headerData
        let fromTo = this.props.headerObj.fromTo
        // console.log(item)
        if (JSON.stringify(item) !== '{}') {
            return (
                <View style={{ backgroundColor: '#fff' }}>
                    {/* 背景盒子 */}
                    <LinearGradient colors={['#2e16b2', '#fff',]} style={styles.bg}>
                        <View style={{
                            marginLeft: 11, marginRight: 11, marginTop: 22, marginBottom: 22,
                            borderRadius: 11, backgroundColor: '#fff', position: 'relative'
                        }}>
                            {/* 收藏 */}
                            {
                                fromTo == 'yzlw' ? (
                                    this.props.headerObj.ifOperation ? (
                                        <TouchableOpacity onPress={() => this.operatingFun()} style={{
                                            backgroundColor: 'rgb(253, 232, 232)',
                                            width: 88, height: 38, flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                            borderBottomLeftRadius: 24.8, borderTopRightRadius: 8.8, position: 'absolute', right: 0, top: 0
                                        }}>
                                            <Icon name="heart" size={22} color="#eb4e4e" />
                                            <Text style={{ color: '#eb4e4e', fontSize: 14.3, fontWeight: '700', marginLeft: 5.5 }}>已收藏</Text>
                                        </TouchableOpacity>
                                    ) : (
                                            <TouchableOpacity onPress={() => this.operatingFun()} style={{
                                                backgroundColor: 'rgb(229, 229, 229)',
                                                width: 88, height: 38, flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                borderBottomLeftRadius: 24.8, borderTopRightRadius: 8.8, position: 'absolute', right: 0, top: 0
                                            }}>
                                                <Icon name="heart" size={22} color="#999999" />
                                                <Text style={{ color: '#999', fontSize: 14.3, fontWeight: '700', marginLeft: 5.5 }}>收藏</Text>
                                            </TouchableOpacity>
                                        )
                                ) : false
                            }

                            {/* 基本信息 */}
                            <View style={{ paddingLeft: 22, paddingRight: 22, paddingBottom: 22, paddingTop: 22, flexDirection: 'row', alignItems: 'center' }}>
                                <View style={{ marginRight: 20, marginLeft: -10 }}>
                                    <ImageCom
                                        style={{ borderRadius: 4.4, width: 66, height: 66, }}
                                        fontSize='19.8'
                                        userPic={item.head_pic}
                                        userName={item.realname}
                                    />
                                    <Text style={{ fontSize: 18.7, color: '#000', fontWeight: '700', textAlign: 'center', marginTop: 6.6 }}>
                                        {item.realname}
                                    </Text>
                                </View>

                                <View>
                                    <Text
                                        style={{
                                            fontSize: 18.7, color: '#000',
                                            fontWeight: '700', textAlign: 'left',
                                            height: 24, marginBottom: 10
                                        }}>
                                        {
                                            item.gender ? (<Text>{item.gender}&nbsp;&nbsp;</Text>) : (false)
                                        }
                                        {
                                            item.age ? (<Text>{item.age}岁&nbsp;&nbsp;</Text>) : (false)
                                        }
                                        {
                                            item.nation ? (<Text>{item.nation}</Text>) : (false)
                                        }
                                    </Text>

                                    {/* 工作状态（op为m时传：0没工作、1已开工、2已开工也找新工作） */}
                                    {
                                        item.work_status == '0' ? (
                                            <Text style={{ color: '#eb4e4e', fontSize: 15.4, height: 23, marginBottom: 10 }}>
                                                未开工正在找工作
                                        </Text>
                                        ) : (
                                                item.work_status == '1' ? (
                                                    <Text style={{ color: '#eb4e4e', fontSize: 15.4, height: 23, marginBottom: 10 }}>
                                                        暂时不需要找工作
                                            </Text>
                                                ) : (
                                                        item.work_status == '2' ? (
                                                            <Text style={{ color: '#eb4e4e', fontSize: 15.4, height: 23, marginBottom: 10 }}>
                                                                已开工也在找工作
                                                </Text>
                                                        ) : false
                                                    )
                                            )
                                    }

                                    <View style={{ flexDirection: 'row' }}>
                                        {
                                            item.idverified !== '0' ? (
                                                <TouchableOpacity
                                                onPress={()=>this.props.alertFun('sm')}>
                                                    <Image style={{ width: 52, height: 18, marginRight: 5 }} source={require('../../assets/recruit/verified.png')}></Image>
                                                </TouchableOpacity>
                                            ) : (false)
                                        }
                                        {
                                            item.group_verified == '1' ? (
                                                <TouchableOpacity
                                                onPress={()=>this.props.alertFun('rz')}>
                                                <Image style={{ width: 52, height: 18, marginRight: 5 }} source={require('../../assets/recruit/group-verified.png')}></Image>
                                                </TouchableOpacity>
                                            ) : (false)
                                        }
                                        {
                                            item.is_commando == '1' ? (
                                                <TouchableOpacity
                                                onPress={()=>this.props.alertFun('tj')}>
                                                <Image style={{ width: 52, height: 18 }} source={require('../../assets/recruit/commando-verified.png')}></Image>
                                                </TouchableOpacity>
                                            ) : (false)
                                        }
                                    </View>

                                </View>
                            </View>
                            {/* 个人情况 */}
                            <View style={{ paddingLeft: 22, paddingRight: 22, paddingBottom: 22 }}>
                                {/* 工龄 */}
                                {
                                    item.work_year ? (
                                        <View style={styles.lanmu}>
                                            <Text style={styles.fontl}>工        龄：</Text>
                                            <Text style={styles.fontr}>{item.work_year}年</Text>
                                        </View>
                                    ) : (false)
                                }

                                {/* 家乡 */}
                                {
                                    item.hometown.name ? (
                                        <View style={styles.lanmu}>
                                            <Text style={styles.fontl}>家        乡：</Text>
                                            <Text style={styles.fontr}>{item.hometown.name}</Text>
                                        </View>
                                    ) : false
                                }

                                {/* 期望工作地 */}
                                {
                                    item.expectaddr.name && item.expectaddr.name.trim() ? (
                                        <View style={styles.lanmu}>
                                            <Text style={styles.fontl}>期望工作地：</Text>
                                            <Text style={styles.fontr}>{item.expectaddr.name}</Text>
                                        </View>
                                    ) : (false)
                                }
                                {/* 所在城市 */}
                                {
                                    item.current_addr.name ? (
                                        <View style={styles.lanmu}>
                                            <Text style={styles.fontl}>所在城市：</Text>
                                            <Text style={styles.fontr}>{item.current_addr.name}</Text>
                                        </View>
                                    ) : (false)
                                }

                                {
                                    item.foreman_info.worktype.length == 0 ? null : (
                                        <View>
                                            {/* 我是班组长 */}
                                            <Text style={{ color: "#000", fontSize: 15.4, marginTop: 22, marginBottom: 11 }}>我是班组长:</Text>
                                            {/* 工程类别 */}
                                            {
                                                item.foreman_info.protype && item.foreman_info.protype.length > 0 ? (
                                                    <View style={styles.lanmu}>
                                                        <Text style={styles.fontl}>工程类别：</Text>
                                                        <View
                                                            style={{ flexWrap: 'wrap', width: 280, flexDirection: 'row' }}>
                                                            {
                                                                item.foreman_info.protype.map((val, indexs) => {
                                                                    if (indexs == item.foreman_info.protype.length - 1) {
                                                                        return (
                                                                            <Text key={indexs}
                                                                                style={{
                                                                                    color: "#000",
                                                                                    fontSize: 15.4,
                                                                                }}>{val.name}</Text>
                                                                        )
                                                                    } else {
                                                                        return (
                                                                            <Text key={indexs}
                                                                                style={{
                                                                                    color: "#000",
                                                                                    fontSize: 15.4,
                                                                                }}>{val.name}  |  </Text>
                                                                        )
                                                                    }
                                                                })
                                                            }
                                                        </View>
                                                    </View>
                                                ) : null
                                            }
                                            {/* 工种 */}
                                            {
                                                item.foreman_info.worktype && item.foreman_info.worktype.length > 0 ? (
                                                    <View style={styles.lanmu}>
                                                        <Text style={styles.fontl}>工        种：</Text>
                                                        <View
                                                            style={{ flexWrap: 'wrap', width: 280, flexDirection: 'row' }}>
                                                            {
                                                                item.foreman_info.worktype.map((val, indexs) => {
                                                                    if (indexs == item.foreman_info.worktype.length - 1) {
                                                                        return (
                                                                            <Text key={indexs}
                                                                                style={{
                                                                                    color: "#000",
                                                                                    fontSize: 15.4,
                                                                                }}>{val.name}</Text>
                                                                        )
                                                                    } else {
                                                                        return (
                                                                            <Text key={indexs}
                                                                                style={{
                                                                                    color: "#000",
                                                                                    fontSize: 15.4,
                                                                                }}>{val.name}  |  </Text>
                                                                        )
                                                                    }
                                                                })
                                                            }
                                                        </View>
                                                    </View>
                                                ) : null
                                            }
                                            {/* 队伍人数：*/}
                                            {
                                                item.foreman_info.scale ? (
                                                    <View style={styles.lanmu}>
                                                        <Text style={styles.fontl}>队伍人数：</Text>
                                                        <Text style={styles.fontrs}>{item.foreman_info.scale}人</Text>
                                                    </View>
                                                ) : null
                                            }
                                        </View>
                                    )
                                }

                                {
                                    item.worker_info.worktype.length == 0 ? null : (
                                        <View>
                                            {/* 我是工人 */}
                                            <Text style={{ color: "#000", fontSize: 15.4, marginTop: 22, marginBottom: 11 }}>我是工人:</Text>
                                            {/* 工程类别 */}
                                            {
                                                item.worker_info.protype && item.worker_info.protype.length > 0 ? (
                                                    <View style={styles.lanmu}>
                                                        <Text style={styles.fontl}>工程类别：</Text>
                                                        <View
                                                            style={{ flexWrap: 'wrap', width: 280, flexDirection: 'row' }}>
                                                            {
                                                                item.worker_info.protype.map((val, indexs) => {
                                                                    if (indexs == item.worker_info.protype.length - 1) {
                                                                        return (
                                                                            <Text key={indexs}
                                                                                style={{
                                                                                    color: "#000",
                                                                                    fontSize: 15.4,
                                                                                }}>{val.name}</Text>
                                                                        )
                                                                    } else {
                                                                        return (
                                                                            <Text key={indexs}
                                                                                style={{
                                                                                    color: "#000",
                                                                                    fontSize: 15.4,
                                                                                }}>{val.name}  |  </Text>
                                                                        )
                                                                    }
                                                                })
                                                            }
                                                        </View>
                                                    </View>
                                                ) : null
                                            }
                                            {/* 工种 */}
                                            {
                                                item.worker_info.worktype && item.worker_info.worktype.length > 0 ? (
                                                    <View style={styles.lanmu}>
                                                        <Text style={styles.fontl}>工        种：</Text>
                                                        <View
                                                            style={{ flexWrap: 'wrap', width: 280, flexDirection: 'row' }}>
                                                            {
                                                                item.worker_info.worktype.map((val, indexs) => {
                                                                    if (indexs == item.worker_info.worktype.length - 1) {
                                                                        return (
                                                                            <Text key={indexs}
                                                                                style={{
                                                                                    color: "#000",
                                                                                    fontSize: 15.4,
                                                                                }}>{val.name}</Text>
                                                                        )
                                                                    } else {
                                                                        return (
                                                                            <Text key={indexs}
                                                                                style={{
                                                                                    color: "#000",
                                                                                    fontSize: 15.4,
                                                                                }}>{val.name}  |  </Text>
                                                                        )
                                                                    }
                                                                })
                                                            }
                                                        </View>
                                                    </View>
                                                ) : null
                                            }
                                            {/* 熟练度 */}
                                            {
                                                item.worker_info.worklevel ? (
                                                    <View style={styles.lanmu}>
                                                        <Text style={styles.fontl}>熟  练  度：</Text>
                                                        <Text style={styles.fontrs}>{item.worker_info.worklevel}</Text>
                                                    </View>
                                                ) : null
                                            }
                                        </View>
                                    )
                                }
                            </View>
                        </View>
                    </LinearGradient>

                    {/* 自我介绍 */}
                    <View style={styles.tit}>
                        <View style={styles.a}></View>
                        <View style={styles.b}></View>
                        <Text style={styles.titfont}>自我介绍</Text>
                        <View style={styles.a}></View>
                        <View style={styles.b}></View>
                    </View>
                    <View style={styles.viewfont}>
                        {
                            !item.introduce || item.introduce == '' ? (
                                <Text style={styles.font}>这家伙很懒，啥都没写</Text>
                            ) : (
                                    <Text style={styles.font}>{item.introduce}</Text>
                                )
                        }
                    </View>

                    {/* 职业技能 */}
                    {
                        item.cerification && item.cerification.length ? (
                            <View>
                                <View style={styles.tit}>
                                    <View style={styles.a}></View>
                                    <View style={styles.b}></View>
                                    <Text style={styles.titfont}>职业技能</Text>
                                    <View style={styles.a}></View>
                                    <View style={styles.b}></View>
                                </View>
                                <View style={styles.viewfont}>
                                    {
                                        item.cerification.map((val, index) => {
                                            return (
                                                <Text key={index} style={styles.font}>{(index ? " | " : "") + val.certificate_name}</Text>
                                            )
                                        })
                                    }
                                </View>
                            </View>
                        ) : false
                    }
                    {/* 项目经验 */}
                    <View style={{
                        marginLeft: 22,
                        marginRight: 22,
                        marginTop: 11,
                        marginBottom: 30,
                        flexDirection: 'row',
                        justifyContent: 'center',
                        alignItems: 'center'
                    }}>
                        <View style={styles.a}></View>
                        <View style={styles.b}></View>
                        <Text style={styles.titfont}>项目经验</Text>
                        <View style={styles.a}></View>
                        <View style={styles.b}></View>
                    </View>

                </View>
            )
        } else {
            return false
        }
    }
    // 收藏按钮
    operatingFun() {
        fetchFun.load({
            url: 'v2/project/serviceOperating',
            data: {
                type: this.props.headerObj.ifOperation ? '2' : '1',
                uid: this.props.headerObj.uid[0],
                role_type: this.props.headerObj.role_type[0],//1，工人，2工头
            },
            success: (res) => {
                console.log('---劳务收藏，取消---', res)
                if (res.state == 1) {
                    this.props.updateOperation()//更改是否收藏状态
                }
            }
        });
    }
}
// 尾布局
class Footer extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        return (
            <View>
                {/* 公告 */}
                <View style={{ paddingTop: 11, paddingBottom: 11, backgroundColor: '#ebebeb', marginBottom: 66 }}>
                    <View style={{ padding: 11, backgroundColor: "#fdf1e0", flexDirection: 'row', alignItems: "flex-start" }}>
                        <View style={{
                            width: 30, height: 19, backgroundColor: "rgb(255, 104, 3)", borderRadius: 2.2,
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center', marginRight: 5.5, marginTop: 3
                        }}><Text style={{
                            color: '#fff',
                            fontSize: 13
                        }}>公告</Text></View>
                        <View >
                            <View style={{ flexDirection: "row", alignItems: "center", marginBottom: 5 }}>
                                <Text style={{ color: '#666', fontSize: 15.4 }}>加客服微信号</Text>
                                <Text style={{ color: '#4193df', fontSize: 15.4 }}>g9188008</Text>
                                <TouchableOpacity
                                    onPress={() => this.props.openFun()}
                                    style={{
                                        borderWidth: 0.5, borderColor: '#999', borderRadius: 2.2,
                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                        paddingLeft: 4, paddingRight: 4, marginLeft: 3
                                    }}>
                                    <Text style={{ color: '#666', fontSize: 13.2 }}>点击复制</Text>
                                </TouchableOpacity>
                                <Text style={{ color: '#666', fontSize: 15.4 }}>，拉你进工友群</Text>
                            </View>
                            <View style={{ flexDirection: "row", alignItems: "center" }}>
                                <Text style={{ color: '#666', fontSize: 15.4 }}>关注“吉工家”微信公众号接收新工作提醒 </Text>
                                <Text style={{ color: '#4193df', fontSize: 15.4 }}>如何关注</Text>
                            </View>
                        </View>
                    </View>
                </View>
            </View>
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
            <View style={{ backgroundColor: '#fff', paddingTop: 33, paddingBottom: 33 }}>
                <Text style={{ textAlign: 'center' }}>暂无记录哦~</Text>
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
        const id = this.props.lastItemId
        return (
            <View style={{ backgroundColor: '#fff' }}>
                {/* 具体项目经验内容 */}
                <View style={{ paddingLeft: 26, paddingRight: 26 }}>

                    <View>
                        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                            <Image style={{ width: 14, height: 14, marginRight: 14 }} source={require('../../assets/personal/sj.png')}></Image>

                            {/* 时间 */}
                            <Text style={{ color: '#999', fontSize: 13.2, marginRight: 13.2 }}>
                                {item.ctime}
                            </Text>

                            {/* 地址 */}
                            <Text style={{ color: '#999', fontSize: 13.2, marginRight: 13.2 }}>
                                {item.proaddress}
                            </Text>
                        </View>
                        <View style={{ borderLeftWidth: 2, borderLeftColor: 'rgb(245,245,245)', marginTop: 7, marginBottom: 7, paddingLeft: 17, marginLeft: 7 }}>

                            {/* 项目名称 */}
                            <Text
                                style={{
                                    color: '#333', fontSize: 17.6, height: 26,
                                    marginTop: 5.5, marginBottom: 5.5, marginLeft: 5, fontWeight: '700'
                                }}>
                                {item.proname}
                            </Text>

                            {/* 项目情况 */}
                            {
                                item.desc && item.desc !== '' ? (
                                    <Text
                                        style={{
                                            color: '#999', fontSize: 15.4, height: 22,
                                            marginBottom: 15.5, marginLeft: 5
                                        }}>
                                        {item.desc}
                                    </Text>
                                ) : false
                            }

                            <View style={{ flexWrap: 'wrap', marginLeft: 5.2, marginTop: 5.2, flexDirection: 'row', marginBottom: 20 }}>
                                {
                                    item.imgs && item.imgs.length > 0 ? (
                                        item.imgs.map((items, indexs) => {
                                            return (
                                                <Images
                                                    key={indexs}
                                                    userPic={items}
                                                    index={indexs}
                                                    lengths={item.imgs.length}
                                                    modalNum='100'
                                                    width='100'
                                                    height='100'
                                                    marginRight='5.5'
                                                    marginBottom='5.5'
                                                />
                                            )
                                        })
                                    ) : (false)
                                }
                            </View>
                        </View>
                    </View>

                    {/* 没有更多了 */}
                    {
                        id == item.id ? (
                            <View>
                                <View style={{ flexDirection: 'row', alignItems: 'center', marginBottom: 20 }}>
                                    <View style={{ width: 12, height: 12, marginRight: 16, marginLeft: 3, backgroundColor: 'rgb(245,245,245)', borderRadius: 14 }}></View>
                                    <Text style={{ color: '#999', fontSize: 13.2, marginRight: 13.2 }}>没有更多了</Text>
                                </View>
                            </View>
                        ) : false
                    }
                </View>

            </View>
        )
    }
}
const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#fff',
    },
    bg: {
        backgroundColor: 'rgb(85,65,190)'
    },
    lanmu: {
        marginTop: 4.5,
        marginBottom: 4.5,
        flexDirection: 'row',
        alignItems: 'flex-start',

    },
    fontl: {
        color: "#999",
        fontSize: 15.4
    },
    fontr: {
        color: "#000",
        fontSize: 15.4
    },
    fontrs: {
        color: "#000",
        fontSize: 15.4,
        flexWrap: 'wrap',
        width: 280,
    },
    tit: {
        marginLeft: 22,
        marginRight: 22,
        marginTop: 11,
        marginBottom: 4.5,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center'
    },
    titfont: {
        color: '#000',
        fontSize: 18.7,
        fontWeight: '700',
        marginLeft: 11,
        marginRight: 11,
    },
    a: {
        width: 3,
        height: 13,
        borderRadius: 2,
        marginRight: 2,
        backgroundColor: '#fa6ba2',
        transform: [{ rotate: '15deg' }]
    },
    b: {
        width: 3,
        height: 13,
        borderRadius: 2,
        marginRight: 2,
        backgroundColor: '#efbb59',
        transform: [{ rotate: '15deg' }]
    },
    viewfont: {
        paddingLeft: 22,
        paddingRight: 22,
        paddingTop: 11,
        paddingBottom: 11,
        flexDirection: 'row',
        justifyContent: "center",
        flexWrap: 'wrap',
    },
    font: {
        color: '#000',
        fontSize: 15.4,
        lineHeight: 20
    },
});