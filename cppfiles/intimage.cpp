/* ==========================================================================
 * update.cpp
 * example for illustrating how to manipulate structure and cell array
 *
 * takes a (MxN) structure matrix and returns a new structure (1x1)
 * containing corresponding fields: for string input, it will be (MxN)
 * cell array; and for numeric (noncomplex, scalar) input, it will be (MxN)
 * vector of numbers with the same classID as input, such as int, double
 * etc..
 *
 * This is a MEX-file for MATLAB.
 * Copyright 1984-2006 The MathWorks, Inc.
 *==========================================================================*/
/* $Revision: 1.6.6.2 $ */

#include "stdafx.h"
#include "cppmatrix.h"
        
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
    
    
    if(nrhs != 1) {
        mexErrMsgTxt("tow input argument required.");
    }
    // read the prhs[0]  sumimagedata
    // read the prhs[1]  the patches [x , y, w , h]
    // 
    matrix<unsigned char> imagedata(A_IN);
    int imgwidth = imagedata.N;
    int imgheight = imagedata.M;
    // global values
    A_OUT = mxCreateDoubleMatrix(imgheight + 1, imgwidth + 1, mxREAL);
    
    matrix<double> sumimgdata = matrix<double>(A_OUT);
    memset(sumimgdata.data, 0, sizeof(double) * (imgheight + 1) * (imgwidth + 1));
    double cursum = 0;
    for(int row = 1; row < sumimgdata.M; ++row) {
        cursum = 0;
        for(int col = 1; col < sumimgdata.N; ++ col) {
            cursum += imagedata.data[ (col  - 1) * imgheight + row - 1];
            sumimgdata.data[ col * (imgheight + 1) + row] = sumimgdata.data[ col * (imgheight + 1) + row - 1] + cursum;
        }
    }
}