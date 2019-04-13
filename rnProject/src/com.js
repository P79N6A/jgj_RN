
// 用户头像背景色计算
function nameCode(str) {
    let hash, serialNum;
    str = String(str);
    hash = String(str.charCodeAt(str.length - 1) || 0);
    serialNum = hash.charAt(hash.length - 1);
    return serialNum;
}

export {
    nameCode,
};