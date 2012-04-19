#ifndef STDAFX_MATLAB_HEADER
#define STDAFX_MATLAB_HEADER
#include "mex.h"
#include "mexutils.h"
#include "string.h"
#define A_IN prhs[0] 
#define B_IN prhs[1]
#define C_IN prhs[2]
#define D_IN prhs[3]
#define E_IN prhs[4]
#define F_IN prhs[5]
#define G_IN prhs[6]
#define A_OUT plhs[0]
#define B_OUT plhs[1]
#define C_OUT plhs[2]
#define D_OUT plhs[3]
#define E_OUT plhs[4]
#define F_OUT plhs[5]
#define     AREA            0
#define     TYPE            1
#define     LOCATION        2
#define     WEIGHT          3
#define     INDEX           4
#define     POSGAUSSIAN     5
#define     NEGGAUSSIAN     6
#define     CORRECT         7
#define     WRONG           8
#define     WEIGHTVALUE     9

#define     NUMSELECTORS       0
#define     OVERLAP            1
#define     SEARCHFACTOR       2
#define     MINFACTOR          3
#define     ITERATIONINIT      4
#define     NUMWEAKCLASSIFIER  5
#define     MINAREA            6
#define     IMGWIDTH           7
#define     IMGHEIGHT          8

#define     TOTALSTRONGCLASSIFIER             1
#define     TOPSTRONGCLASSIFIER               2
#define     BOTTOMLSTRONGCLASSIFIER           3
#define     LEFTSTRONGCLASSIFIER              4
#define     RIGHTSTRONGCLASSIFIER             5
#define     TOTALSELECTORS                    6
#define     TOTALALPHA                        7
#define     TOPSELECTORS                      8
#define     TOPALALPHA                        9
#define     BOTTOMSELECTORS                   10
#define     BOTTOMALALPHA                     11
#define     LEFTSELECTORS                     12
#define     LEFTALALPHA                       13
#define     RIGHTSELECTORS                    14
#define     RIGHTALALPHA                      15
struct patches {
    int x; 
    int y;
    int width;
    int height;
};
#define matrix2d matrix<double> **
#endif