#!/bin/sh

cd /Users/ndl/Library/MobileDevice/Provisioning Profiles
for file in $(ls *)
do
    if [[ $(/usr/libexec/PlistBuddy -c "Print TeamName" /dev/stdin <<< $(/usr/bin/security cms -D -i ${file})) == "${TeamName}" ]]
    then
        profile=${file}
    fi
done