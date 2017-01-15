//
//  FLglmWrapper.m
//  Lesson5
//
//  Created by fancymax on 1/13/2017.
//  Copyright © 2017年 fancy. All rights reserved.
//


#include "glm/glm.hpp"
#include "glm/gtc/matrix_transform.hpp"
#include "glm/gtc/type_ptr.hpp"
#import "FLglmWrapper.h"

@implementation FLglmWrapper

#define Array2Vec(array) glm::vec3(array[0], array[1], array[2])

#define Matrix2Array(matrix,array) \
array[0] = matrix[0][0];\
array[1] = matrix[0][1];\
array[2] = matrix[0][2];\
array[3] = matrix[0][3];\
array[4] = matrix[1][0];\
array[5] = matrix[1][1];\
array[6] = matrix[1][2];\
array[7] = matrix[1][3];\
array[8] = matrix[2][0];\
array[9] = matrix[2][1];\
array[10] = matrix[2][2];\
array[11] = matrix[2][3];\
array[12] = matrix[3][0];\
array[13] = matrix[3][1];\
array[14] = matrix[3][2];\
array[15] = matrix[3][3];

+(float*) lookAt:(float*)position target:(float*)target upVector:(float*)up {
    glm::mat4 view = glm::lookAt(Array2Vec(position),
                Array2Vec(target),
                Array2Vec(up));

    float *array = (float *)malloc(sizeof(float) * 16);
    Matrix2Array(view,array);
    return array;
}



@end
