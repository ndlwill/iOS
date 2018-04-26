//
//  DHMatrix.h
//  LunarLander
//
//  Created by DreamHack on 16-4-14.
//  Copyright (c) 2016年 DreamHack. All rights reserved.
//

#ifndef DHVectorDiagram_DHMatrix_h
#define DHVectorDiagram_DHMatrix_h


#define DH_INLINE   static inline

#import <Foundation/Foundation.h>

typedef double * DHLinearVector;

typedef struct {
    
    int row, column;
    // 先取行后取列
    // 比如values[0]表示取到了第0行(仍然是一个指针，指向第0行的double类型的数组)
    // values[0][1]表示取到了第0行第1列
    // 如果要直接取第n列，请调用下方的行数取列向量
    double **values;
    
} DHMatrix;

// 目前只有矩阵乘法

DH_INLINE size_t DHMatrixValueByteSize(DHMatrix matrix)
{
    return matrix.row * matrix.column * sizeof(double);
}

// 打印矩阵
DH_INLINE void DHMatrixPrint(DHMatrix matrix)
{
    for (int i = 0; i < matrix.row; ++i) {
        printf("|");
        for (int j = 0; j < matrix.column; ++j) {
            double value = matrix.values[i][j];
            printf("%f ",value);
        }
        printf("|\n");
    }
}

// 释放一个矩阵的内存。
// 因为矩阵中有一成员是在堆里面分配的内存，所以需要手动释放
DH_INLINE void DHMatrixRelease(DHMatrix matrix)
{
    for (int i = 0; i < matrix.row; ++i) {
        free(matrix.values[i]);
    }
    free(matrix.values);
}

#pragma mark - 矩阵构造

// 元素全为0
DH_INLINE DHMatrix DHMatrixMakeZero(int row, int column)
{
    DHMatrix matrix;
    matrix.row = row;
    matrix.column = column;
    
    if (row * column == 0) {
        matrix.values = NULL;
        return matrix;
    }
    
    double ** values = malloc(matrix.row * sizeof(double *));
    for (int i = 0; i < matrix.row; ++i) {
        size_t size = matrix.column * sizeof(double);
        values[i] = malloc(size);
        memset(values[i], 0, size);
    }
    
    matrix.values = values;
    
    return matrix;
}

DH_INLINE DHMatrix DHMatrixMake(int row, int column, double **values)
{
    DHMatrix matrix;
    matrix.row = row;
    matrix.column = column;
    matrix.values = values;
    return matrix;
}

//
DH_INLINE DHMatrix DHMatrixMakeWithString(int row, int column ,NSString * valueString, NSString * seperator)
{
    DHMatrix matrix = DHMatrixMakeZero(row, column);
    
    NSMutableArray * valuesArray = [[valueString componentsSeparatedByString:seperator] mutableCopy];
    // 如果给出的字符串内容元素数量不够，则后面的用0填充
    
    for (int i = (int)valuesArray.count; i < row * column; ++i) {
        [valuesArray addObject:@0];
    }

    [valuesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        CGFloat value = [obj floatValue];
        matrix.values[idx/column][idx%column] = value;
    }];
    
    return matrix;
}


DH_INLINE DHMatrix DHMatrixMakeIdentity(int length)
{
    
    DHMatrix matrix = DHMatrixMakeZero(length, length);
    
    for (int i = 0; i < length; ++i) {
        matrix.values[i][i] = 1;
    }
    
    return matrix;
}

// 拷贝一个矩阵
DH_INLINE DHMatrix DHMatrixMakeWithMatrix(DHMatrix matrix)
{
    DHMatrix aMatrix = DHMatrixMakeZero(matrix.row, matrix.column);
    
    for (int i = 0; i < matrix.row; i++) {
        memcpy(aMatrix.values[i], matrix.values[i], sizeof(double) * matrix.column);
    }
    
    return aMatrix;
}

#pragma mark - 矩阵计算

// 从矩阵中获取某一行的值（行向量）
// 行向量并不是直接取的values指针，而是创建了一个新的一维数组然后把值赋进这个数组
// 所以构造出来的行向量需要手动管理内存，请在使用结束后进行release（调用free(vector)）
DH_INLINE DHLinearVector DHMatrixRowVectorAtRow(DHMatrix matrix, int row)
{
    size_t size = matrix.column * sizeof(double);
    DHLinearVector rowVector = malloc(size);
    memcpy(rowVector, matrix.values[row], size);
    return rowVector;
}

// 从矩阵中获取某一列的值（列向量）
// 列向量并不是直接取的values指针，而是创建了一个新的一维数组然后把值赋进这个数组
// 所以构造出来的列向量需要手动管理内存，请在使用结束后进行release（调用free(vector)）
DH_INLINE DHLinearVector DHMatrixColumnVectorAtColumn(DHMatrix matrix, int column)
{
    double * columnVector = malloc(matrix.row * sizeof(double));
    
    // 一行一行取值
    for (int i = 0; i < matrix.row; ++i) {
        
        double value = matrix.values[i][column];
        
        columnVector[i] = value;
    }
    
    return columnVector;
}

// 矩阵取反
DH_INLINE DHMatrix DHMatrixInvert(DHMatrix matrix)
{
    int row = matrix.row, column = matrix.column;
    DHMatrix invertMatrix = DHMatrixMakeZero(row, column);
    for (int i = 0; i < row; ++i) {
        for (int j = 0; j < column; ++j) {
            invertMatrix.values[i][j] = -matrix.values[i][j];
        }
    }
    return invertMatrix;
}

// 矩阵加法
DH_INLINE DHMatrix DHMatrixAddition(DHMatrix matrix1, DHMatrix matrix2)
{
    // 如果它们的行列数不相等，则无法进行相加，返回零矩阵
    if (matrix1.row != matrix2.row || matrix1.column != matrix2.column) {
        return DHMatrixMakeZero(0, 0);
    }
    
    int row = matrix1.row;
    int column = matrix1.column;
    DHMatrix matrix = DHMatrixMakeZero(row, column);
    
    // 对每一元素进行相加
    for (int i = 0; i < row; ++i) {
        for (int j = 0; j < column; ++j) {
            double sum = matrix1.values[i][j] + matrix2.values[i][j];
            matrix.values[i][j] = sum;
        }
    }
    return matrix;
    
}

// 矩阵减法
DH_INLINE DHMatrix DHMatrixSubstraction(DHMatrix matrix1, DHMatrix matrix2)
{
    // 先把减数取反
    DHMatrix subMatrix = DHMatrixInvert(matrix2);
    // 将两个矩阵相加
    DHMatrix resultMatrix = DHMatrixAddition(matrix1, subMatrix);
    
    // 释放减数矩阵
    DHMatrixRelease(subMatrix);
    return resultMatrix;
}

// 在开始矩阵乘法之前，先实现行向量乘以列向量的算法
DH_INLINE double DHMatrixRowVectorMutiplyColumnVector(DHLinearVector rowVector, DHLinearVector columnVector, int length)
{
    CGFloat result = 0;
    for (int i = 0; i < length; ++i) {
        CGFloat product = rowVector[i] * columnVector[i];
        result += product;
    }
    return result;
}

// 矩阵乘法
DH_INLINE DHMatrix DHMatrixMultiplication(DHMatrix matrix1, DHMatrix matrix2)
{
    // 如果左边的列数不等于右边的行数则不能相乘，返回一个零矩阵
    if (matrix1.column != matrix2.row) {
        return DHMatrixMakeZero(0, 0);
    }
    DHMatrix productMatrix = DHMatrixMakeZero(matrix1.row, matrix2.column);
    
    // 从左边一行一行的取，然后乘以右边的每一列
    for (int i = 0; i < matrix1.row; ++i) {
        
        // 取左边第i行的行向量
        DHLinearVector rowVector = DHMatrixRowVectorAtRow(matrix1, i);
        for (int j = 0; j < matrix2.column; ++j) {
            
            // 用行向量乘以右边的列向量
            
            // 取右边的列向量
            DHLinearVector columnVector = DHMatrixColumnVectorAtColumn(matrix2, j);
            // 乘
            double product = DHMatrixRowVectorMutiplyColumnVector(rowVector, columnVector, matrix2.row);
            // 将乘积作为结果矩阵的第i行第j列的元素
            productMatrix.values[i][j] = product;
            
            // 释放列向量
            free(columnVector);
        }
        
        // 释放行向量
        free(rowVector);
    }
    
    return productMatrix;
}

#pragma mark - 矩阵与平面图形的操作

// 用矩阵表示一个平面上的点
DH_INLINE DHMatrix DHMatrixFromCGPoint(CGPoint point)
{
    // 矩阵必须是1行3列，并且第三列的数字必须为1
    NSString * matrixString = [NSString stringWithFormat:@"%f,%f,1",point.x,point.y];
    DHMatrix matrix = DHMatrixMakeWithString(1, 3, matrixString, @",");
    
    return matrix;
}

// 将一个点矩阵转换为平面上的点，只取第一行前两列的数
DH_INLINE CGPoint DHMatrixToCGPoint(DHMatrix matrix)
{
    return CGPointMake(matrix.values[0][0], matrix.values[0][1]);
}

// 平移矩阵
// 1  0  0
// 0  1  0
// dx dy 0
DH_INLINE DHMatrix DHTranslationMatrix(double dx, double dy)
{
    NSString * matrixString = [NSString stringWithFormat:@"1,0,0,0,1,0,%f,%f,1",dx,dy];
    return DHMatrixMakeWithString(3, 3, matrixString, @",");
}

// 缩放矩阵
// sx 0  0
// 0  sy 0
// 0  0  1
DH_INLINE DHMatrix DHScaleMatrix(double sx, double sy)
{
    NSString * matrixString = [NSString stringWithFormat:@"%f,0,0,0,%f,0,0,0,1",sx,sy];
    return DHMatrixMakeWithString(3, 3, matrixString, @",");
}

// 旋转矩阵
// cos  sin 0
// -sin cos 0
// 0    0   1
DH_INLINE DHMatrix DHRotationMatrix(double theta)
{
    NSString * matrixString = [NSString stringWithFormat:@"%f,%f,0,%f,%f,0,0,0,1",cos(theta),sin(theta),-sin(theta),cos(theta)];
    return DHMatrixMakeWithString(3, 3, matrixString, @",");
}


#endif
