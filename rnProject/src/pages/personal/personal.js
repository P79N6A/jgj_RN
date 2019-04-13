/*
 * @Author: stl
 * @Date: 2019-03-15 09:22:58 
 * @Module:个人中心
 * @Last Modified time: 2019-03-15 09:22:58 
 */
import React, { Component } from 'react'
import { View, Text, Image, StyleSheet, ImageBackground, StatusBar } from 'react-native'

export default class personal extends Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    static navigationOptions = {
        title: 'Home',
    }
    componentDidMount() {
        // 顶部通知栏样式
        this._navListener = this.props.navigation.addListener('didFocus', () => {
            StatusBar.setBarStyle('dark-content');//默认黑色字体
            StatusBar.setBackgroundColor('#ffffff');
        });
    }
    componentWillUnmount() {
        this._navListener.remove();
    }
    render() {
        return (
            <View style={styles.container}>
                {/* header */}
                <ImageBackground style={styles.header} source={require('../../assets/personal/db.png')}>
                    <View style={styles.padd}>
                        {/* 用户头像 */}
                        <Image style={styles.userimg} source={require('../../assets/personal/img.jpg')}></Image>
                        {/* 用户信息 */}
                        <View style={styles.you}>
                            <View style={styles.mainh}>
                                <View style={styles.top}>
                                    <Text style={styles.name}>张有财</Text>
                                    <Text style={styles.phone}>136****230</Text>
                                </View>
                                <View style={styles.right}>
                                    <Image style={styles.erweima} source={require('../../assets/personal/ma.png')}></Image>
                                    <Image style={styles.more} source={require('../../assets/personal/more.png')}></Image>
                                </View>
                            </View>
                            <View sytle={styles.bot}>
                                <Text style={{ color: '#ffffff', fontSize: 12, marginTop: 9 }}>一个独一无二的签名吧，这样可能会让你的人气爆棚哦！</Text>
                            </View>
                        </View>
                    </View>
                </ImageBackground>
                {/* 实名认证 */}
                <View style={styles.authen}>
                    <Text style={styles.authent}>你还没有进行实名认证</Text>
                    <Text style={styles.authent}>立即认证 ></Text>
                </View>
                {/* 领红包 */}
                <View style={styles.redeven}></View>
                {/* 切换身份、我的找活名片 */}
                <View style={styles.one}>
                    {/* 切换身份 */}
                    <View style={styles.single}>
                        <View style={styles.onel}>
                            <Icon style={{ marginRight: 13,}} name="refresh" size={20} color="#EB4E4E" />
                            <Text style={styles.oneltext}>切换身份</Text>
                        </View>
                        <View style={styles.oner}>
                            <Text style={styles.onertext}>班组长/工头</Text>
                            <Text style={styles.oneljt}>></Text>
                        </View>
                    </View>
                    {/* 我的找活名片 */}
                    <View style={styles.single}>
                        <View style={styles.onel}>
                        <Icon style={{ marginRight: 13,}} name="refresh" size={20} color="#EB4E4E" />
                            <Text style={styles.oneltext}>我的找活名片</Text>
                        </View>
                    </View>
                </View>
            </View>
        )
    }
}
const styles = StyleSheet.create({
    oneljt: {
        color: '#000000',
        fontSize: 14,
    },
    onertext: {
        color: '#999999',
        fontSize: 14,
        marginRight: 10,
    },
    oner: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    oneltext: {
        color: '#000000',
        fontSize: 16,
    },
    onelimg: {
        width: 20,
        height: 20,
        marginRight: 13,
    },
    onel: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    single: {
        height: 50,
        borderBottomColor: '#DBDBDB',
        borderBottomWidth: 0.5,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        paddingRight: 15,

    },
    one: {
        width: '100%',
        height: 100,
        backgroundColor: '#ffffff',
        paddingLeft: 20,
    },
    redeven: {
        height: 80,
        width: '100%',
    },
    authent: {
        color: '#FF6600',
        fontSize: 15,
    },
    authen: {
        width: '100%',
        height: 50,
        backgroundColor: '#FDF1E0',
        borderBottomColor: '#DBDBDB',
        borderBottomWidth: 0.5,
        paddingLeft: 20,
        paddingRight: 15,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
    },
    container: {
        flex: 1,
        alignItems: 'center',
        backgroundColor: '#EEEEEE',
    },
    header: {
        height: 121,
        width: '100%',
    },
    padd: {
        paddingLeft: 19,
        paddingTop: 25,
        paddingRight: 16,
        flexDirection: 'row',
    },
    userimg: {
        width: 60,
        height: 60,
        marginRight: 15,
    },
    you: {
        flex: 1,
        height: 82,
    },
    mainh: {
        flex: 1,
        height: 47,
        width: '100%',
        flexDirection: 'row',
        borderBottomWidth: 0.5,
        borderBottomColor: '#000000',
        alignItems: 'center',
        justifyContent: 'space-between',
        paddingBottom: 9,
    },
    top: {
        flex: 1,
    },
    name: {
        color: '#FFFFFF',
        fontSize: 19,
    },
    phone: {
        color: '#FFFFFF',
        fontSize: 12,
    },
    right: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    erweima: {
        width: 20,
        height: 20,
        marginRight: 8,
    },
    more: {
        width: 15,
        height: 15,
        transform: [{ rotate: '270deg' }],
    },
    bot: {
        flex: 1,
    },
})