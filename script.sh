#!/bin/bash
echo "Shell Start to generate package.xml ..."
metaItems=(`git diff --name-status $GIT_PREVIOUS_BRANCH $GIT_NEXT_BRANCH | xargs`)
echo "Shell: generate empty deployment folder: codeDeployPkg ..."
pageString=""
componentString=""
clsString=""
triggerString=""
echo $metaItems
sleep 3

echo "now start"
for i in ${!metaItems[@]} 
do 
    metaName=${metaItems[i]}
    echo $metaName
    sleep 2
    if [[ ${metaItems[i]} == *".page" ]]; then
        pageName=${metaName#src/pages/}
        pageString=$pageString"<members>"${pageName%.page}"</members>"
        cp -p "$metaName" "codeDeployPkg/pages"
        cp -p "$metaName-meta.xml" "codeDeployPkg/pages"
    elif [[ ${metaItems[i]} == *".component" ]]; then
        componentName=${metaName#src/components/}
        componentString=$componentString"<members>"${componentName%.component}"</members>"
        cp -p "$metaName" "codeDeployPkg/components"
        cp -p "$metaName-meta.xml" "codeDeployPkg/components"
    elif [[ ${metaItems[i]} == *".cls" ]]; then 
    	sleep 3;
    	echo "Here"

        className=${metaName#src/classes/}
        clsString=$clsString"<members>"${className%.cls}"</members>"
        cp -p "$metaName" "codeDeployPkg/classes"
        cp -p "$metaName-meta.xml" "codeDeployPkg/classes"
    elif [[ ${metaItems[i]} == *".trigger" ]]; then
        triggerName=${metaName#src/triggers/}
        triggerString=$triggerString"<members>"${triggerName%.trigger}"</members>"
        cp -p "$metaName" "codeDeployPkg/triggers"
        cp -p "$metaName-meta.xml" "codeDeployPkg/triggers"
    fi
done
if [ "$pageString" != "" ]; then
    pageString="<types>$pageString<name>ApexPage</name></types>"
fi
if [ "$componentString" != "" ]; then 
    componentString="<types>$componentString<name>ApexComponent</name></types>"
fi
if [ "$clsString" != "" ]; then 
    clsString="<types>$clsString<name>ApexClass</name></types>"
fi
if [ "$triggerString" != "" ]; then
    triggerString="<types>"$triggerString"<name>ApexTrigger</name></types>"
fi
packageString="<?xml version=\"1.0\" encoding=\"UTF-8\"?><Package xmlns=\"http://soap.sforce.com/2006/04/metadata\">$pageString$componentString$clsString$triggerString<version>36.0</version></Package>"
echo $packageString > codeDeployPkg/package.xml
echo "Shell: package.xml is ready!"