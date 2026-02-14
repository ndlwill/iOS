#!/bin/bash

# 检查参数
if [ $# -ne 1 ]; then
  echo "用法: $0 <文件夹路径>"
  exit 1
fi

FOLDER_PATH="$1"

# 检查文件夹是否存在
if [ ! -d "$FOLDER_PATH" ]; then
  echo "错误：$FOLDER_PATH 不是一个有效的文件夹"
  exit 1
fi

# 获取文件夹绝对路径
FOLDER_PATH="$(cd "$(dirname "$FOLDER_PATH")" && pwd)/$(basename "$FOLDER_PATH")"

# 解析路径
PARENT_DIR="$(dirname "$FOLDER_PATH")"
FOLDER_NAME="$(basename "$FOLDER_PATH")"
ZIP_NAME="${FOLDER_NAME}.zip"

cd "$PARENT_DIR" || exit 1

# 创建加密 zip
echo "开始压缩：$FOLDER_NAME"
zip -er "$ZIP_NAME" "$FOLDER_NAME"

if [ $? -eq 0 ]; then
  echo "✅ 压缩完成：$PARENT_DIR/$ZIP_NAME"
else
  echo "❌ 压缩失败"
fi
