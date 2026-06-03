#!/bin/bash
# export LANG=zh_CN.UTF-8
# export LC_ALL=zh_CN.UTF-8

# 目标文件路径
TARGET_FILE="package/noodles/A-default-settings/files/usr/lib/lua/luci/view/admin_status/index/links.htm"

# 日期
FIXED_DATE=$(date +%Y-%m-%d)

# =============== 核心 JS 计算 ===============
RESULT=$(node -e "
// 24节气、表情、干支、生肖、农历称谓
const SolarTerm = ['小寒','大寒','立春','雨水','惊蛰','春分','清明','谷雨','立夏','小满','芒种','夏至','小暑','大暑','立秋','处暑','白露','秋分','寒露','霜降','立冬','小雪','大雪','冬至'];
const EmojiPre = ['❄️','🧊','🌱','💦','⚡','🌤️','🌷','🌧️','🌻','🌾','🌿','☀️','🔥','🥵','🍃','🌬️','💧','🍂','🍁','🧊','🌨️','❄️','☃️','🌙'];
const EmojiSuf = ['⛄','❄️','🌳','💧','🐛','🕊️','🪁','🌱','☀️','🥜','🌾','🔥','🥵','🌞','🍂','🍃','🌫️','🍁','💧','🧊','🥶','⛄','❄️','❄️'];
const Gan = ['甲','乙','丙','丁','戊','己','庚','辛','壬','癸'];
const Zhi = ['子','丑','寅','卯','辰','巳','午','未','申','酉','戌','亥'];
const Zodiac = ['鼠🐭','牛🐮','虎🐯','兔🐰','龙🐉','蛇🐍','马🐎','羊🐑','猴🐵','鸡🐔','狗🐶','猪🐷'];
const MonthNames = ['正月','二月','三月','四月','五月','六月','七月','八月','九月','十月','冬月','腊月'];
const DayNames = ['初一','初二','初三','初四','初五','初六','初七','初八','初九','初十','十一','十二','十三','十四','十五','十六','十七','十八','十九','二十','廿一','廿二','廿三','廿四','廿五','廿六','廿七','廿八','廿九','三十'];

// 公历转农历
function toLunar(date) {
    const solarYear = date.getFullYear();
    const solarMonth = date.getMonth() + 1;
    const solarDay = date.getDate();
    const lunarInfo = [0x04bd8,0x04ae0,0x0a570,0x054d5,0x0d260,0x0d950,0x16554,0x056a0,0x09ad0,0x055d2,0x04ae0,0x0a5b6,0x0a4d0,0x0d250,0x1d255,0x0b540,0x0d6a0,0x0ada2,0x095b0,0x14977,0x04970,0x0a4b0,0x0b4b5,0x06a50,0x06d40,0x1ab54,0x02b60,0x09570,0x052f2,0x04970,0x06566,0x0d4a0,0x0ea50,0x06e95,0x05ad0,0x02b60,0x186e3,0x092e0,0x1c8d7,0x0c950,0x0d4a0,0x1d8a6,0x0b550,0x056a0,0x1a5b4,0x025d0,0x092d0,0x0d2b2,0x0a950,0x0b557,0x06ca0,0x0b550,0x15355,0x04da0,0x0a5d0,0x14573,0x052d0,0x0a9a8,0x0e950,0x06aa0,0x0aea6,0x0ab50,0x04b60,0x0aae4,0x0a570,0x05260,0x0f263,0x0d950,0x05b57,0x056a0,0x096d0,0x04dd5,0x04ad0,0x0a4d0,0x0d4d4,0x0d250,0x0d558,0x0b540,0x0b5a0,0x195a6,0x095b0,0x049b0,0x0a974,0x0a4b0,0x0b27a,0x06a50,0x06d40,0x0af46,0x0ab60,0x09570,0x04af5,0x04970,0x064b0,0x074a3,0x0ea50,0x06b58,0x055c0,0x0ab60,0x096d5,0x092e0,0x0c960,0x0d954,0x0d4a0,0x0da50,0x07552,0x056a0,0x0abb7,0x025d0,0x092d0,0x0cab5,0x0a950,0x0b4a0,0x0baa4,0x0ad50,0x055d9,0x04ba0,0x0a5b0,0x15176,0x052b0,0x0a930,0x07954,0x06aa0,0x0ad50,0x05b52,0x04b60,0x0a6e6,0x0a4e0,0x0d260,0x0ea65,0x0d530,0x05aa0,0x076a3,0x096d0,0x04bd7,0x04ad0,0x0a4d0,0x1d0b6,0x0d250,0x0d520,0x0dd45,0x0b5a0,0x056d0,0x055b2,0x049b0,0x0a577,0x0a4b0,0x0aa50,0x1b255,0x06d20,0x0ada0];
    let i, leap = 0, temp = 0;
    if (solarYear < 1900 || solarYear > 2100) return null;
    let offset = (Date.UTC(solarYear, solarMonth - 1, solarDay) - Date.UTC(1900, 0, 31)) / 86400000;
    for (i = 1900; i < 2101 && offset > 0; i++) { temp = lYearDays(i); offset -= temp; }
    if (offset < 0) { offset += temp; i--; }
    const lunarYear = i; leap = leapMonth(i); let isLeap = false;
    for (i = 1; i < 13 && offset > 0; i++) {
        if (leap > 0 && i == leap+1 && !isLeap) { --i; isLeap = true; temp = leapDays(lunarYear); }
        else temp = monthDays(lunarYear, i);
        if (isLeap && i == leap+1) isLeap = false;
        offset -= temp;
    }
    if (offset < 0) { offset += temp; --i; }
    return { year: lunarYear, month: i, day: offset + 1, isLeap: isLeap };
    function lYearDays(y) { let s=348; for(let i=0x8000;i>0x8;i>>=1)s+=(lunarInfo[y-1900]&i)?1:0; return s+leapDays(y); }
    function leapMonth(y) { return lunarInfo[y-1900] & 0xf; }
    function leapDays(y) { return leapMonth(y)?(lunarInfo[y-1900]&0x10000?30:29):0; }
    function monthDays(y,m) { return lunarInfo[y-1900]&(0x10000>>m)?30:29; }
}

// 节气计算（自动适配年份）
function getTermIndex(date) {
    const Y = date.getFullYear();
    const sTermInfo = [0,21208,42467,63836,85269,107014,128867,150926,173143,195551,218071,240698,263343,285924,308570,331061,353326,375495,397324,419059,440602,462011,483290,504444];
    const solarTerms = [];
    for(let i=0;i<24;i++){
        let sTermDate = new Date((31556925974.7*(Y-1900) + sTermInfo[i]*60000)+Date.UTC(1900,0,6,2,5));
        solarTerms.push([sTermDate.getUTCMonth()+1, sTermDate.getUTCDate()]);
    }
    let m = date.getMonth()+1, d = date.getDate();
    for(let i=solarTerms.length-1;i>=0;i--){
        let tm = solarTerms[i][0], td = solarTerms[i][1];
        if(m>tm || (m===tm && d>=td)) return i;
    }
    return 23;
}

// 天干地支、生肖（立春分界）
function getGanZhi(date) { const y=date.getFullYear(),m=date.getMonth()+1,d=date.getDate(); let cy=y;if(m<2||(m===2&&d<4))cy--; return Gan[(cy-4)%10]+Zhi[(cy-4)%12]+Zodiac[(cy-4)%12]; }

const now = new Date();
const ganzhi = getGanZhi(now);
const lunar = toLunar(now);
const lunarMonth = MonthNames[lunar.month-1];
const lunarDay = DayNames[lunar.day-1];
const tIdx = getTermIndex(now);
const term = SolarTerm[tIdx];
const ePre = EmojiPre[tIdx];
const eSuf = EmojiSuf[tIdx];

// 公历 YYYY.MM.DD 格式
const Y = now.getFullYear();
const M = String(now.getMonth()+1).padStart(2,'0');
const D = String(now.getDate()).padStart(2,'0');
const solarFull = Y+'.'+M+'.'+D;

// 一次性输出所有值
console.log(ganzhi+'年 '+lunarMonth+lunarDay+'|'+ePre+term+eSuf+'|'+solarFull);
")

# 拆分出 3 个值
A_VALUE=$(echo "$RESULT" | awk -F'|' '{print $1}')
B_VALUE=$(echo "$RESULT" | awk -F'|' '{print $2}')
C_VALUE=$(echo "$RESULT" | awk -F'|' '{print $3}')

# =============== 输出查看 ===============
echo -e "\n-------------------------------------"
echo -e " AAAA = $A_VALUE"
echo -e " BBBB = $B_VALUE"
echo -e " CCCC = $C_VALUE"
echo -e "-------------------------------------"

# =============== 替换文件 ===============
sed -i "s~AAAA~${A_VALUE}~g" "$TARGET_FILE"
sed -i "s~BBBB~${B_VALUE}~g" "$TARGET_FILE"
sed -i "s~CCCC~${C_VALUE}~g" "$TARGET_FILE"

echo -e "\n✅ 全部替换成功！"
