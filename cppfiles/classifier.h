#ifndef CLASSIFIER_MATLAB_HEADER
#define CLASSIFIER_MATLAB_HEADER
/* ==========================================================================
 * classifier.h
 * parameter0  pathces
 * parameter1  alpha
 * parameter2  selectors
 * parameter3  haarfeature
 * parameter4  sumimagedata
 * 
 * 
 * 
 * 
 * This is a MEX-file for MATLAB.
 * 
 *==========================================================================*/
/* $Revision: 1.6.6.2 $ */
#include "stdafx.h"
#include "cppmatrix.h"

//#define _DEBUG_
void classify(
                matrix<double> *patchPtr,
                matrix<double> *alphaPtr,
                matrix<double> *selectorPtr,
                matrix2d       *haarfeaturePtr,
                matrix<double> *sumimagedataPtr,          
                matrix<double> confidencemap
                )
{
    #ifdef _DEBUG_
            mexPrintf("In the classy function ! \n");
    #endif
    matrix2d haarfeature = *haarfeaturePtr;
    
    int patchwidth = (int)(*patchPtr).data[3];
    int patchheight = (int)(*patchPtr).data[4];
    double * selector = (*selectorPtr).data;
    double * alpha = (*alphaPtr).data;
    double * sumimagedata = (*sumimagedataPtr).data;
    double * locationIndex;
    int    area;                                // the region' number in feature
    int    locationindex;                       // location' index in each selector
    int    numofselectors = (*selectorPtr).M;   // selectors' number
    int    sumimgwidth, sumimgheight;       // sumimage width and height
    int    x0, y0, width, height;               // region 
    int    x1, y1;                              // botright of the region
    int    topleft, topright, botleft, botright; // the for corn of the region
    int    tmp;
    double weightsum = 0;
    double mean;
    double confidence = 0;
    int    featureNumInEachSelector;
    double alphasum  = 0;
   // featureNumInEachSelector = haarfeature[0][AREA].M;
    sumimgwidth = (*sumimagedataPtr).N;
    sumimgheight = (*sumimagedataPtr).M;
    
    for(int iselector = 0; iselector < numofselectors; ++ iselector)
        alphasum += alpha[iselector];
    
    // used for speed up
    #ifdef _DEBUG_
            mexPrintf("numofselectors = %d ! \n", numofselectors);
    #endif
    int * selectorInt = new int[numofselectors];
    int * locationIndexInt = new int[numofselectors];
    int * areanum = new int[numofselectors];
    int * locationM = new int[numofselectors];
    double ** location = new double *[numofselectors];
    double ** weight = new double *[numofselectors];
    double * pos_mean = new double [numofselectors];
    double * neg_mean = new double [numofselectors];
    
    for(int iselector = 0; iselector < numofselectors; ++ iselector){
        selectorInt[iselector] = (int)selector[iselector]  - 1;
        #ifdef _DEBUG_
            mexPrintf("selectorInt = %d\n",selectorInt[iselector] );
        #endif
    }
    
    
    for(int iselector = 0; iselector < numofselectors; ++ iselector){
        locationIndexInt[iselector] = (int)haarfeature[iselector][INDEX].data[selectorInt[iselector]] - 1;
        #ifdef _DEBUG_
            mexPrintf("locationIndexInt = %d\n",locationIndexInt[iselector] );
        #endif
    }
    
    for(int iselector = 0; iselector < numofselectors; ++ iselector) {
        location[iselector] = haarfeature[iselector][LOCATION].data + locationIndexInt[iselector];
        weight[iselector] = haarfeature[iselector][WEIGHT].data + locationIndexInt[iselector];
    }
        
    for(int iselector = 0; iselector < numofselectors; ++ iselector) {
        areanum[iselector] = (int)haarfeature[iselector][AREA].data[selectorInt[iselector]];
    }
    for(int iselector = 0; iselector < numofselectors; ++ iselector) {
        locationM[iselector] = haarfeature[iselector][LOCATION].M;
    }
    for(int iselector = 0; iselector < numofselectors; ++ iselector) {
        pos_mean[iselector] = haarfeature[iselector][POSGAUSSIAN].data[selectorInt[iselector]];
        neg_mean[iselector] = haarfeature[iselector][NEGGAUSSIAN].data[selectorInt[iselector]];
        #ifdef _DEBUG_
            mexPrintf("POS_MEAN = %lf NEG_MEAN = %lf \n",pos_mean[iselector], neg_mean[iselector] );
        #endif
    }
        
    int npatches = (*patchPtr).M;
    int x_offset, y_offset;
    //matrix<double> confidencemap =
    for(int kpatch = 0; kpatch < npatches; ++kpatch ) {
        x_offset = (int)(*patchPtr).data[kpatch] - 1;
        y_offset = (int)(*patchPtr).data[kpatch + npatches] - 1;
        confidence = 0;
        for(int iselector = 0; iselector < numofselectors; ++ iselector){
            // calculate the weight sum of every haar feature
            // selectIndex is the index of weakclassifier in  this selector
            // as the haar type is not the same ,so the num of region of every
            // haarfeature is not same locationindex is the first index of the 
            // location ptr to this weakclassifier
            // area is the number of region in this weakclassifier
            /*
            #ifdef _DEBUG_
                   mexPrintf("in the first loop ! \n");
            #endif
            */
            weightsum = 0;
            for(int jarea = 0; jarea < areanum[iselector];  ++ jarea) {
                tmp = 0;
                x0 =      (int)location[iselector][jarea + tmp];
                tmp += locationM[iselector];
                y0 =      (int)location[iselector][jarea + tmp];
                tmp += locationM[iselector];
                width =   (int)location[iselector][jarea + tmp];
                tmp += locationM[iselector];
                height =  (int)location[iselector][jarea + tmp];

                x1 = x0 + width;
                y1 = y0 + height;
                x0 += x_offset;
                x1 += x_offset;
                y0 += y_offset;
                y1 += y_offset;
                topleft   = (x0 * sumimgheight + y0);
                botright  = (x1 * sumimgheight + y1);
                topright =  (x1 * sumimgheight + y0);
                botleft   = (x0 * sumimgheight + y1);
                /*     
                #ifdef _DEBUG_
                    mexPrintf("x0 = %d, y0 = %d  x1 = %d y1 = %d\n", x0, y0, x1, y1);
                    mexPrintf("topleft = %lf \n botright = %lf \n topright = %lf \n botleft = %lf \n",  \
                        sumimagedata[topleft], sumimagedata[botright],sumimagedata[topright], sumimagedata[botleft]);
                #endif
                */
                weightsum += weight[iselector][jarea] * ( sumimagedata[topleft] + sumimagedata[botright] - \
                        sumimagedata[topright] - sumimagedata[botleft]);
            }
            /*
            #ifdef _DEBUG_
                    mexPrintf("weight = %lf\n", weightsum);
            #endif
             */
            mean = (pos_mean[iselector] + neg_mean[iselector]) / 2;
            if( (weightsum <= mean && pos_mean[iselector] <= neg_mean[iselector]) ||  \
                (weightsum >= mean && pos_mean[iselector] >= neg_mean[iselector])){
                // positive
                confidence += alpha[iselector] * 1;
            }else {
                // negitive
                confidence += alpha[iselector] * -1;
            }
        }
        confidencemap.data[ x_offset * confidencemap.M + y_offset] =  confidence / alphasum;
    }
   delete [] selectorInt;
   delete [] locationIndexInt;
   delete [] weight;
   delete [] location;
   delete [] areanum;
   delete [] locationM;
   delete [] pos_mean;
   delete [] neg_mean;
}





#endif