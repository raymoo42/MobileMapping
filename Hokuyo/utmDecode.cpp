#include <math.h>
#include <matrix.h>
#include <mex.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
 if ( nlhs!=1 || nrhs!=1) {
    printf("utmDecode error! Expecting exactly one inputs and one output!\n");
        return;
 }
    
 double *scan,*output;
 int buf1,buf2,buf3,aa;
 int n_data,n_points;
 int i;
         
 scan=mxGetPr(prhs[0]);
 n_data=mxGetM(prhs[0]);
 n_points=n_data/3;
 
 
 plhs[0] = mxCreateDoubleMatrix(n_points, 1, mxREAL);
 output=mxGetPr(plhs[0]);
 
 for (i=0;i<n_points;i++)
 {
     //mexPrintf("%d\n",i);

     buf1=scan[i*3]-48;
        //  mexPrintf("%d\n",buf1);
          
     buf2=scan[1+ i*3]-48;
        // mexPrintf("%d\n",buf2);
          
     buf3=scan[2+ i*3]-48;
        //  mexPrintf("%d\n",buf3);
     
     output[i]= (buf1<<12)|(buf2<<6)|buf3;
     
     // the maximum reading is 60m according to the manufacturer
     if (output[i]>60000)
             output[i]=0;
     //mexPrintf("%f\n",output[i]);
  
 }
 
}