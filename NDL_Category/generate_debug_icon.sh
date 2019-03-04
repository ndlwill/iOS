#!/bin/sh

CMD_NOT_FOUND_EXIT_NO=60
ENV_ERROR_EXIT_NO=61

CONVERT_CMD_PATH=`which convert`
echo "===log: CONVERT_CMD_PATH = $CONVERT_CMD_PATH==="

if [[ ! -f $CONVERT_CMD_PATH || -z $CONVERT_CMD_PATH ]]; then
	echo "===WARNING: brew install imagemagick==="
	exit $CMD_NOT_FOUND_EXIT_NO
fi

COMMIT_SHORT_HEAD=`git rev-parse --short HEAD`
BRANCH_HEAD=`git rev-parse --abbrev-ref HEAD`
BUILD_VERSION=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" ${INFOPLIST_FILE}`
MAIN_TEXT="${COMMIT_SHORT_HEAD}\n${BRANCH_HEAD}\n${BUILD_VERSION}"
echo "===log: MAIN_TEXT = $MAIN_TEXT==="
echo "===log: RES_PATH = ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
echo "===log: CONFIGURATION = ${CONFIGURATION}==="

if [ ${CONFIGURATION} = "Release" ]; then
	exit $ENV_ERROR_NO
fi

function generate_debug_icon () {
	ORIGINAL_IMG=$1

	cd "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

	if [[ ! -f ${ORIGINAL_IMG} || -z ${ORIGINAL_IMG} ]]; then
		echo "===WARNING: NO_ORIGINAL_IMG_EXIT_NO==="
		return;
	fi

	convert ${ORIGINAL_IMG} -blur 10x8 blurredImage.png

	ORIGINAL_IMG_W=`identify -format %w ${ORIGINAL_IMG}`
	ORIGINAL_IMG_H=`identify -format %h ${ORIGINAL_IMG}`
	ORIGINAL_IMG_HALF_H=`expr ${ORIGINAL_IMG_H} / 2`
	CROPPED_IMG_Y=$(( ${ORIGINAL_IMG_H} - ${ORIGINAL_IMG_HALF_H} ))

	convert blurredImage.png -crop ${ORIGINAL_IMG_W}x${ORIGINAL_IMG_HALF_H}+0+${CROPPED_IMG_Y} croppedImage.png

	POINT_SIZE=$(( (8 * $ORIGINAL_IMG_W) / 58 ))
	echo "===log: POINT_SIZE = ${POINT_SIZE}==="

	convert -background none -fill white -pointsize ${POINT_SIZE} -gravity center caption:"${MAIN_TEXT}" croppedImage.png +swap -composite label.png

	composite -geometry +0+${ORIGINAL_IMG_HALF_H} label.png ${ORIGINAL_IMG} ${ORIGINAL_IMG}

	rm blurredImage.png
	rm croppedImage.png
	rm label.png
}



ICON_ARRAY_COUNT=$(( `/usr/libexec/PlistBuddy -c "Print :CFBundleIcons:CFBundlePrimaryIcon:CFBundleIconFiles" "${CONFIGURATION_BUILD_DIR}/${INFOPLIST_PATH}" | wc -l` - 2 ))
echo "===log: ICON_ARRAY_COUNT = ${ICON_ARRAY_COUNT}==="

for ((i=0; i<ICON_ARRAY_COUNT; i++)); do
	ICON_NAME=`/usr/libexec/PlistBuddy -c "Print CFBundleIcons:CFBundlePrimaryIcon:CFBundleIconFiles:$i" "${CONFIGURATION_BUILD_DIR}/${INFOPLIST_PATH}"`
	echo "===log: ICON_NAME = ${ICON_NAME}==="

	if [[ $ICON_NAME == *.png ]] || [[ $ICON_NAME == *.PNG ]]; then
		echo "=====if====="
		generate_debug_icon $ICON_NAME
	else
		echo "=====else====="
		generate_debug_icon "${ICON_NAME}@2x.png"
		generate_debug_icon "${ICON_NAME}@3x.png"
	fi
done
