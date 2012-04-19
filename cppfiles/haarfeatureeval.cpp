/* ========================================================================
 *   haar feature eval
 *   author : chenyeufeng
 *   used to calculate haar feature value in each block
 *   parameter : 
 *   A_IN : strongclassifier, 
 *   B_IN : sumimagedata,
 *   C_IN : patch
 *   return a 3d array  
 *   A_OUT :
 *   weight[numberofweakclassifier][numofpatches][numofselectors]
 *=======================================================================*/
/* $Revision : 1.0 */
#include "stdafx.h"
#include "cppmatrix.h"
#define MAX_NUMBER_PARAMETER 100
void readHaarfeature(
                     matrix2d haarfeature,
                     const mxArray * haar_ptr,
                     int NStructElems,
                     int nfields)
{     
    for(int ifield = 0; ifield < nfields; ifield ++) {
       for(int jstruct = 0; jstruct < NStructElems; jstruct ++) {
            // get the haarfeature(jstruct).field(ifield)
            haarfeature[jstruct][ifield] = matrix<double>(mxGetFieldByNumber(haar_ptr, jstruct, ifield));
            //haarfeature[jstruct][ifield] = tmp;
        }
    }
}
void readParameter(
                     double * parameter,
                     const mxArray * parameter_ptr
                     )
{
    mxArray * tmp;
    int nfields = mxGetNumberOfFields(parameter_ptr);
    for(int ifield = 0, ip = 0; ifield < nfields; ifield ++) {
            // get the haarfeature(jstruct).field(ifield)
        tmp = mxGetFieldByNumber(parameter_ptr, 0, ifield);

        //haarfeature[jstruct][ifield] = tmp;
        if(mxIsDouble(tmp) && mxGetM(tmp) == 1 && mxGetN(tmp) == 1){
            parameter[ip++] = mxGetPr(tmp)[0];
        }
    }
 }
void getweakclassifiervalue(
                            matrix2d        *haarfeaturePtr,
                            matrix<double>  &sumimage,
                            matrix<double>  &patches,
                            matrix<double>  &weightsumArray,
                            int             numofselectors,
                            int             featureNumInEachSelector
                            )
{
    double weightsum;
    int areanum;
    int x0, y0, x1, y1, width, height;
    int topleft, topright, botleft, botright; // the for corn of the region
    int x_offset, y_offset;
    int locationIndex;
    int locationM;
    int tmp = 0;
   
    double * sumimagedata = sumimage.data;
    int sumimgwidth = sumimage.N;
    int sumimgheight = sumimage.M;
    int numofpatches = patches.M;
    for(int kpatch = 0; kpatch < numofpatches; ++ kpatch) {
        x_offset = (int)patches.data[kpatch] - 1;
        y_offset = (int)patches.data[kpatch + numofpatches] - 1;
        
        for(int iselector = 0; iselector < numofselectors; ++ iselector){
            locationM = (*haarfeaturePtr)[iselector][LOCATION].M;
            for( int jweak = 0; jweak < featureNumInEachSelector; ++jweak) {
                weightsum = 0;
                areanum = (int)(*haarfeaturePtr)[iselector][AREA].data[jweak];
                // minus 1 important
                locationIndex = (int)(*haarfeaturePtr)[iselector][INDEX].data[jweak] - 1;
                for(int karea = 0; karea < areanum; ++ karea ) {
                    tmp = 0;
                    x0 = (int)(*haarfeaturePtr)[iselector][LOCATION].data[locationIndex + karea + tmp];
                    tmp += locationM;
                    y0 = (int)(*haarfeaturePtr)[iselector][LOCATION].data[locationIndex + karea + tmp];
                    tmp += locationM;
                    width = (int)(*haarfeaturePtr)[iselector][LOCATION].data[locationIndex + karea + tmp];
                    tmp += locationM;
                    height = (int)(*haarfeaturePtr)[iselector][LOCATION].data[locationIndex + karea + tmp];


                    x1 = x0 + width;
                    y1 = y0 + height;
                    x0 += x_offset;
                    x1 += x_offset;
                    y0 += y_offset;
                    y1 += y_offset;
                    topleft = (x0 * sumimgheight + y0);
                    botright = (x1 * sumimgheight + y1);
                    topright = (x1 * sumimgheight + y0);
                    botleft = (x0 * sumimgheight + y1);

                    weightsum += (*haarfeaturePtr)[iselector][WEIGHT].data[locationIndex + karea] * \
                            ( sumimagedata[topleft] + sumimagedata[botright] - \
                            sumimagedata[topright] - sumimagedata[botleft]);
                }//end of karea
                weightsumArray(jweak, kpatch, iselector) = weightsum;
            }// end of jweak
        }// end of iselector
    }// end of kpatch
}
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
    
    const mxArray * haar_ptr;
    const mxArray * parameter_ptr;
    
    
    int nfields, NStructElems, ifield, jstruct;
    matrix2d haarfeature;
    mxArray * tmp;
    
    if(nrhs != 3) {
        mexErrMsgTxt("three input argument required.");
    }
    // read the prhs[0] sumimagedata
    // read the prhs[1] the patches [x , y, w , h]
    //
    haar_ptr = A_IN;
    matrix<double> sumimagedata = matrix<double>(B_IN);
    matrix<double> patches = matrix<double>(C_IN);
    parameter_ptr = mexGetVariablePtr("caller", "parameter");
    
    // read haar_ptr
    
    // fields  : number of the attributions in a struct
    // NStructElems : number of the struct
    nfields = mxGetNumberOfFields(haar_ptr);
    NStructElems = mxGetNumberOfElements(haar_ptr);
    
    haarfeature = new matrix<double> * [NStructElems];
    for(jstruct = 0; jstruct < NStructElems; jstruct ++)
        haarfeature[jstruct] = new matrix<double>[nfields];
    
    // haarfeature is the mxArray point the struct
    // haarfeature[jstruct][ifield] means the i(th) field in j(th) struct
    
    readHaarfeature(haarfeature, haar_ptr, NStructElems, nfields);
    
    double * parameter = new double[MAX_NUMBER_PARAMETER];
    readParameter(parameter, parameter_ptr);
    
    
    int featureNumInEachSelector = (int)parameter[NUMWEAKCLASSIFIER];
    int numofselectors = (int)parameter[NUMSELECTORS];
    int numofpatches = patches.M;
    
    
    int ndims = 3, dims[3] = {featureNumInEachSelector, numofpatches, numofselectors};
    A_OUT = mxCreateNumericArray(ndims, dims , mxDOUBLE_CLASS, mxREAL);
    matrix<double> weightArray = matrix<double>(A_OUT);
    getweakclassifiervalue(&haarfeature, sumimagedata, patches, weightArray, numofselectors,\
            featureNumInEachSelector);
    
    
    for(jstruct = 0; jstruct < NStructElems; jstruct ++)
        delete [] haarfeature[jstruct];
    delete [] haarfeature;  
}
