GLOBAL={
    apiUrl:'http://api.test.jgjapp.com/',//url拼接

    os:'W',//平台
    ver:'4.0.0',//版本号
    person:'person',//平台类型 person 个人端 manage 管理端
    timeDifference:'',//与服务器时间差
    // 用户信息(登录返回)
    userinfo:{
        confirm_off: '1',//0表示对方的对账功能未关闭；1:已关闭
        double_info: '3',//是否填写两种角色信息：0一种都没有、1只有工人、2只有工头、3两种都具备
        free_dates: '0',
        free_server: '0',
        group_verified: '0',//班组认证
        has_realname: '1',//是否存在真实姓名 1 : 已完善 0 : 没有完善
        head_pic: 'media/images/20190402/100894379.png?nopic=1&real_name=沈桃林',//头像
        is_bind: '0',
        is_info: '1',//是否具有基本信息
        is_new: '0',//1为新用户,0为老用户
        real_name: '沈桃林',//登陆成功后对应的用户姓名
        red_status: '0',
        role: '1',//当前角色
        telephone: '18380439449',//当前用户的手机
        token: '29c179b585c23b0a5fd928a796c1ac4f',//接口唯一标识
        uid: '100894379',//登陆成功后对应的uid
        user_name: '沈桃林',
        verified: '0',//角色是否已通过实名
    },
    // 地址
    AddressOne:[],
    AddressTwo:[],
    AddressThree:[],
    // 找工作地址
    zgzAddress:{
        zgzAddressOneName:'选择城市',
        zgzAddressOneNum:'',

        zgzAddressTwoName:'选择城市',
        zgzAddressTwoNum:'',
    },
    // 找工人地址
    zgrAddress:{
        zgrAddressOneName:'选择城市',
        zgrAddressOneNum:'',

        zgrAddressTwoName:'',
        zgrAddressTwoNum:'',
    },
    // 发布招工项目所在地
    fbzgAddress:{
        fbzgAddressOneName:'选择城市',
        fbzgAddressOneNum:'',

        fbzgAddressTwoName:'',
        fbzgAddressTwoNum:'',

        detailAddress:'请选择所在地'//详细地址
    },

    // 工种
    typeArr:[],
    // 找工作选择工种
    zgzType:{
        zgzTypeName:'选择工种',
        zgzTypeNum:'',
    },
    // 找工人选择工种
    zgrType:{
        zgrTypeName:'选择工种',
        zgrTypeNum:'',
    },
    // 发布招工选择工种
    fbzgType:{
        fbzgTypeName:'选择工种',
        fbzgTypeNum:'',
    },
    // 发布招工选择工程类别
    fbzgProject:{
        fbzgProjectName:'选择工程类别',
        fbzgProjectNum:'',
    },

    pid:'',//项目id
    
    ///////////////////////////////////
    
    // 编辑的基本信息
    editbasic:{
        name:'',//姓名
        sex:'',//性别
        nation:[],//民族
        birthday:'',//生日
        workingyears:'',//工龄
        // 家乡地址
        jxaddress:{
            jxone:-1,
            jxtwo:-1,
            jxthree:-1,
            jxoneName:'',
            jxtwoName:'',
            jxthreeName:'',
        },
        // 期望工作地址
        qwaddress:{
            qwone:-1,
            qwtwo:-1,
            qwoneName:'',
            qwtwoName:'',
        },
        worktypelb:[],//选择工程类别
        worktype:[],// 选择工种
        mastery:[],// 选择熟练度
    },
    // 保存的基本信息
    basic:{},
    // 招突击队选择城市
    tjdaddress:{
        tjdone:-1,
        tjdtwo:-1,
        tjdoneName:'',
        tjdtwoName:'',
    },
}
