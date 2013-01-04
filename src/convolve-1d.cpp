#include <Rcpp.h>
using namespace Rcpp;

//' Convolution: 1d
//'
//' Automatically zero-pads sample so that kernel trails off to zero.
//' 
//' @author Dirk Eddelbuettel, Romain Francois
// [[Rcpp::export]]
NumericVector convolve_1d(NumericVector x, NumericVector kernel){
  int n_x = x.size(), n_k = kernel.size();
  NumericVector out(n_x + n_k - 1);

  Fast<NumericVector> fx(x), fkernel(kernel), fout(out);  
  for (int i = 0; i < n_x; i++)
    for (int j = 0; j < n_k; j++) 
      fout[i + j] += fx[i] * fkernel[j];
    
  return out;
}