#!/bin/sh



# ===CheckMobileprovision===
# cd ~
# CurrentPath=$(pwd)
# cd $CurrentPath/Library/MobileDevice/Provisioning\ Profiles
# echo "Info: ===$(pwd)==="

# TEAM_NAME="Shanghai Youdun Network Technology Co., Ltd"

# # check xxx.mobileprovision
# for file in $(ls *)
# do
#     if [[ $(/usr/libexec/PlistBuddy -c "Print TeamName" /dev/stdin <<< $(/usr/bin/security cms -D -i ${file})) == "${TEAM_NAME}" ]]
#     then
#         ExpirationDate=`/usr/libexec/PlistBuddy -c "Print ExpirationDate" /dev/stdin <<< $(/usr/bin/security cms -D -i ${file})`
#         echo "${file}: ExpirationDate=$ExpirationDate"
#     fi
# done



# ===CheckPushCert===
EXPIRATION_WARNING_CODE=100

OUTPUT_DIR=~/Desktop/PushPem
OUTPUT_PUSH_PEM_NAME=push.pem

ReplaceMonthNumber=1

function transformMonthToNumber () {
    MONTH=$1

    if [ $MONTH == "Jan" ]
    then
        ReplaceMonthNumber=1
    elif [ $MONTH == "Feb" ]
    then
        ReplaceMonthNumber=2
    elif [ $MONTH == "Mar" ]
    then
        ReplaceMonthNumber=3
    elif [ $MONTH == "Apr" ]
    then
        ReplaceMonthNumber=4
    elif [ $MONTH == "May" ]
    then
        ReplaceMonthNumber=5
    elif [ $MONTH == "Jun" ]
    then
        ReplaceMonthNumber=6
    elif [ $MONTH == "Jul" ]
    then
        ReplaceMonthNumber=7
    elif [ $MONTH == "Aug" ]
    then
        ReplaceMonthNumber=8
    elif [ $MONTH == "Sept" ]
    then
        ReplaceMonthNumber=9
    elif [ $MONTH == "Oct" ]
    then
        ReplaceMonthNumber=10
    elif [ $MONTH == "Nov" ]
    then
        ReplaceMonthNumber=11
    elif [ $MONTH == "Dec" ]
    then
        ReplaceMonthNumber=12
    fi
}

if [ ! -d $OUTPUT_DIR ]; then
    echo "===create PushPem==="
    mkdir $OUTPUT_DIR
fi

# for AJS
# security find-certificate -a -c "Apple Push Services: com.aijiasuinc.AiJiaSuClient" -p > $OUTPUT_DIR/$OUTPUT_PUSH_PEM_NAME
# for FLY
security find-certificate -a -c "Apple Push Services: com.flyinc.FlyClient" -p > $OUTPUT_DIR/$OUTPUT_PUSH_PEM_NAME

# -dates          - both Before and After dates
# notBefore=Mar 10 10:49:24 2020 GMT notAfter=Apr 9 10:49:24 2021 GMT
# ExpirationDate=$(openssl x509 -in $OUTPUT_DIR/$OUTPUT_PUSH_PEM_NAME -noout -dates | grep 'After' | awk -F '=' '{print $2}')

# -enddate        - notAfter field
# notAfter=Apr 9 10:49:24 2021 GMT
ExpirationDate=$(openssl x509 -in $OUTPUT_DIR/$OUTPUT_PUSH_PEM_NAME -noout -enddate | awk -F '=' '{print $2}')

# 方法1==========替换英文月份为数字月份==========
# 截取月份
# SubStringMonth=${ExpirationDate%% *}
# 替换月份的number
# transformMonthToNumber $SubStringMonth
# 用变量替换${a//}做字符串替换
# FinalExpirationDate=${ExpirationDate/$SubStringMonth/$ReplaceMonthNumber}
# ExpirationDateTimestamp=$(date -j -f "%m %d %H:%M:%S %Y %Z" "$FinalExpirationDate" +%s)

# 方法2==========直接转换==========
ExpirationDateTimestamp=$(LC_ALL=en_US.UTF-8 date -j -f "%b %d %H:%M:%S %Y %Z" "$ExpirationDate" +%s)
echo "ExpirationDateTimestamp = $ExpirationDateTimestamp"

CurrentDateTimestamp=$(date +%s) # 北京时间 将日期转化为时间戳
echo "CurrentDateTimestamp = $CurrentDateTimestamp"

deltaDay=$(( $(( $ExpirationDateTimestamp - $CurrentDateTimestamp )) / (60*60*24) ))
echo "deltaDay = $deltaDay"
if [ $deltaDay -lt 30 ]; then
    echo '===WARNING: ExpirationDate < 30==='
    exit $EXPIRATION_WARNING_CODE
fi

