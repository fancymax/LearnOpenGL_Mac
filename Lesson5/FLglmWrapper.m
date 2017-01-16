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

#define ReturnMatrix2Array(matrix) \
float *array = (float *)malloc(sizeof(float) * 16);\
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
array[15] = matrix[3][3];\
return array;

#define Array2mat4(array,model)\
model[0][0] = array[0];\
model[0][1] = array[1];\
model[0][2] = array[2];\
model[0][3] = array[3];\
model[1][0] = array[4];\
model[1][1] = array[5];\
model[1][2] = array[6];\
model[1][3] = array[7];\
model[2][0] = array[8];\
model[2][1] = array[9];\
model[2][2] = array[10];\
model[2][3] = array[11];\
model[3][0] = array[12];\
model[3][1] = array[13];\
model[3][2] = array[14];\
model[3][3] = array[15];\
free(array);
             
+(float*) lookAtPosition:(float*)position target:(float*)target upVector:(float*)up {
    glm::mat4 view = glm::lookAt(Array2Vec(position), Array2Vec(target), Array2Vec(up));
    ReturnMatrix2Array(view);
}

+(float*) perspectiveAtFov:(float)FOV aspect:(float)aspect near:(float)near far:(float)far{
    glm::mat4 projection = glm::perspective(FOV, aspect, near, far);
    ReturnMatrix2Array(projection);
}

+(float*) translateAtX:(float)x Y:(float)y Z:(float)z {
    glm::mat4 model;
    model = glm::translate(model, glm::vec3(x,y,z));
    ReturnMatrix2Array(model);
}

+(float*) translateFrom:(float*)arrayMatrix X:(float)x Y:(float)y Z:(float)z {
    glm::mat4 model;
    Array2mat4(arrayMatrix, model)
    model = glm::translate(model, glm::vec3(x,y,z));
    ReturnMatrix2Array(model);
}

+(float*) rotateFrom:(float*)arrayMatrix angle:(float)angle X:(float)x Y:(float)y Z:(float)z {
    glm::mat4 model;
    Array2mat4(arrayMatrix, model)
    model = glm::rotate(model,angle, glm::vec3(x,y,z));
    ReturnMatrix2Array(model);
}

+(void)freeMatrix:(float *)matrix {
    free(matrix);
}

@end
