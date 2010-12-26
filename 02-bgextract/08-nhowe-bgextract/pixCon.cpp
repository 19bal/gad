//***************************************************************************/
//
// Matlab C routine file:  pixCon
//
// Program to create a sparse matrix of pixel connections quickly.
//
// Written 2/03 by N. Howe.
//
//***************************************************************************/

#include "mex.h"
#include <string.h>

//***************************************************************************/

#define HALFSQRT 0.7071067811865476

//***************************************************************************/

#ifndef ABS
#define ABS(a) (((a) < 0) ? -(a) : (a))
// macro for computing absolute value
#endif

//***************************************************************************/
//
//  mexFunction() is a gateway driver to call the code from Matlab.
//  This is the Matlab entry point.
//
//***************************************************************************/

void 
mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  int i, j, k, ndim, npix, nzmax;
  int *offset, *ir, *jc;
  double *out, *inp;
  char *mode;
  
  // check for proper number of arguments
  if (nrhs < 1) {
    mexErrMsgTxt("Must specify image dimensions.");
  }
  if (nlhs > 1) {
    mexErrMsgTxt("Too many output arguments.");
  }
  
  // check input
  if (!mxIsDouble(prhs[0])) {
    mexErrMsgTxt("First input must be type double.");
  }
  ndim = mxGetNumberOfElements(prhs[0]);
  if (ndim > 4) {
    mexErrMsgTxt("Number of dimensions exceeds design limit (4).");
  }

  // set up offset array
  inp = mxGetPr(prhs[0]);
  offset = (int*)mxMalloc((ndim+1)*sizeof(int));
  offset[0] = 1;
  for (i = 0; i < ndim; i++) {
    offset[i+1] = (int)(offset[i]*inp[i]);
  }
  npix = offset[ndim];
  //mexPrintf("Set up array.\n");

  // determine type of connection matrix
  if (nrhs > 1) {
    mode = (char*)mxGetPr(prhs[1]);
    if (!mxIsChar(prhs[1])) {
      mexErrMsgTxt("Second input must be type char.");
    }
  }
  //if ((nrhs == 1)||(strncmp(mode,"4con",mxGetNumberOfElements(prhs[1])))) {
  if ((nrhs == 1)||(*mode == '4')) {
    nzmax = npix*2*ndim;
    //mexPrintf("4con: %d\n",nzmax);
    plhs[0] = mxCreateSparse(npix, npix, nzmax, mxREAL);
    out = mxGetPr(plhs[0]);
    ir = mxGetIr(plhs[0]);
    jc = mxGetJc(plhs[0]);
    k = 0;
    for (i = 0; i < npix; i++) {
      mxAssert(k < nzmax,"Too many nonzeros.");
      jc[i] = k;
      //mexPrintf("Scanning element %d:\n",i);
      for (j = 0; j < ndim; j++) {
        //mexPrintf("  Neighbor at %d:  %d vs. %d.\n",i-offset[j],
        //          (i+npix)/offset[j+1],(i+npix-offset[j])/offset[j+1]);
        if ((i+npix)/offset[j+1] == (i+npix-offset[j])/offset[j+1]) {
          ir[k] = i-offset[j];
          out[k] = 1;
          k++;
        }
        //mexPrintf("  Neighbor at %d:  %d vs. %d.\n",i+offset[j],
        //          (i+npix)/offset[j+1],(i+npix+offset[j])/offset[j+1]);
        if ((i+npix)/offset[j+1] == (i+npix+offset[j])/offset[j+1]) {
          ir[k] = i+offset[j];
          out[k] = 1;
          k++;
        }
      }
    }
    jc[i] = k;
    //} else if (strncmp(mode,"inv2",mxGetNumberOfElements(prhs[1]))) {
  } else if (*mode == 'i') {
    int j2, ji, jp, jm;
    nzmax = npix*2*ndim*(ndim+1);
    //mexPrintf("inv2: %d\n",nzmax);
    plhs[0] = mxCreateSparse(npix, npix, nzmax, mxREAL);
    out = mxGetPr(plhs[0]);
    ir = mxGetIr(plhs[0]);
    jc = mxGetJc(plhs[0]);
    k = 0;
    for (i = 0; i < npix; i++) {
      mxAssert(k < nzmax,"Too many nonzeros.");
      jc[i] = k;
      for (j = 0; j < ndim; j++) {
        ji = i+npix;
        jp = i+npix+offset[j];
        jm = i+npix-offset[j];
        if (ji/offset[j+1] == jp/offset[j+1]) {
          ir[k] = i+offset[j];
          out[k] = 1;
          k++;
        }
        if (ji/offset[j+1] == jm/offset[j+1]) {
          ir[k] = i-offset[j];
          out[k] = 1;
          k++;
        }
        for (j2 = j; j2 < ndim; j2++) {
          if (jp/offset[j2+1] == (jp+offset[j2])/offset[j2+1]) {
            ir[k] = i+offset[j]+offset[j2];
            out[k] = ((j == j2) ? 0.5:HALFSQRT);
            k++;
          }
          if (jm/offset[j2+1] == (jm-offset[j2])/offset[j2+1]) {
            ir[k] = i-offset[j]-offset[j2];
            out[k] = ((j == j2) ? 0.5:HALFSQRT);
            k++;
          }
          if (j != j2) {
            if ((ji/offset[j+1] == jp/offset[j+1])
              &&(jp/offset[j2+1] == (jp-offset[j2])/offset[j2+1])) {
              ir[k] = i+offset[j]-offset[j2];
              out[k] = HALFSQRT;
              k++;
            }
            if ((ji/offset[j+1] == jm/offset[j+1])
              &&(jm/offset[j2+1] == (jm+offset[j2])/offset[j2+1])) {
              ir[k] = i-offset[j]+offset[j2];
              out[k] = HALFSQRT;
              k++;
            }
          }
        }
      }
    }
    jc[i] = k;
    //} else if (strncmp(mode,"edge",mxGetNumberOfElements(prhs[1]))) {
  } else if (*mode == 'e') {
    // Edge image
    bool *edge;
    const int *edim;
    nzmax = npix*2*ndim;
    //mexPrintf("edge: %d\n",nzmax);
    if (nrhs < 3) {
      mexErrMsgTxt("Must provide edge map as third argument.");
    }
    if (!mxIsLogical(prhs[2])) {
      mexErrMsgTxt("Edge map must be logical type.");
    }
    edge = mxGetLogicals(prhs[2]);
    edim = mxGetDimensions(prhs[2]);
    for (i = 0; i < ndim; i++) {
      if (edim[i] != inp[i]) {
        mexErrMsgTxt("Edge map must be same size as image.");
      }
    }
    plhs[0] = mxCreateSparse(npix, npix, nzmax, mxREAL);
    out = mxGetPr(plhs[0]);
    ir = mxGetIr(plhs[0]);
    jc = mxGetJc(plhs[0]);
    k = 0;
    for (i = 0; i < npix; i++) {
      mxAssert(k < nzmax,"Too many nonzeros.");
      jc[i] = k;
      //mexPrintf("Scanning element %d:\n",i);
      for (j = 0; j < ndim; j++) {
        //mexPrintf("  Neighbor at %d:  %d vs. %d.\n",i-offset[j],
        //          (i+npix)/offset[j+1],(i+npix-offset[j])/offset[j+1]);
        if ((i+npix)/offset[j+1] == (i+npix-offset[j])/offset[j+1]) {
          if (!(edge[i]||edge[i-offset[j]])) {
            ir[k] = i-offset[j];
            out[k] = 1;
            k++;
          }
        }
        //mexPrintf("  Neighbor at %d:  %d vs. %d.\n",i+offset[j],
        //          (i+npix)/offset[j+1],(i+npix+offset[j])/offset[j+1]);
        if ((i+npix)/offset[j+1] == (i+npix+offset[j])/offset[j+1]) {
          if (!(edge[i]||edge[i+offset[j]])) {
            ir[k] = i+offset[j];
            out[k] = 1;
            k++;
          }
        }
      }
    }
    jc[i] = k;
  } else if (*mode == 'd') {
    // deltas
    double *img;
    const int *idim;
    nzmax = npix*2*ndim;
    //mexPrintf("edge: %d\n",nzmax);
    if (nrhs < 3) {
      mexErrMsgTxt("Must provide edge map as third argument.");
    }
    if (!mxIsDouble(prhs[2])||mxIsComplex(prhs[2])) {
      mexErrMsgTxt("Third argument must be grayscale intensities.");
    }
    img = mxGetPr(prhs[2]);
    idim = mxGetDimensions(prhs[2]);
    for (i = 0; i < ndim; i++) {
      if (idim[i] != inp[i]) {
        mexErrMsgTxt("Intensities must be same size as image.");
      }
    }
    plhs[0] = mxCreateSparse(npix, npix, nzmax, mxREAL);
    out = mxGetPr(plhs[0]);
    ir = mxGetIr(plhs[0]);
    jc = mxGetJc(plhs[0]);
    k = 0;
    for (i = 0; i < npix; i++) {
      mxAssert(k < nzmax,"Too many nonzeros.");
      jc[i] = k;
      //mexPrintf("Scanning element %d:\n",i);
      for (j = 0; j < ndim; j++) {
        //mexPrintf("  Neighbor at %d:  %d vs. %d.\n",i-offset[j],
        //          (i+npix)/offset[j+1],(i+npix-offset[j])/offset[j+1]);
        if ((i+npix)/offset[j+1] == (i+npix-offset[j])/offset[j+1]) {
          ir[k] = i-offset[j];
          out[k] = 1/ABS(img[i]-img[i-offset[j]]);
          k++;
        }
        //mexPrintf("  Neighbor at %d:  %d vs. %d.\n",i+offset[j],
        //          (i+npix)/offset[j+1],(i+npix+offset[j])/offset[j+1]);
        if ((i+npix)/offset[j+1] == (i+npix+offset[j])/offset[j+1]) {
          ir[k] = i+offset[j];
          out[k] = 1/ABS(img[i]-img[i+offset[j]]);
          k++;
        }
      }
    }
    jc[i] = k;
  } else {
    mexErrMsgTxt("Unknown mode.");
  }

  // free memory
  mxFree(offset);
}
