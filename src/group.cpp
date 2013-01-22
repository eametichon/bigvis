#include <Rcpp.h>
#include "group.hpp"
#include "group-hex.hpp"
using namespace Rcpp;

template<typename Group>
IntegerVector group_out(const Group& group) {
  int n = group.size();
  IntegerVector out(n);
  for(int i = 0; i < n; ++i) {
    out[i] = group.bin(i);
  }

  return out;
}

// [[Rcpp::export]]
IntegerVector group_fixed(const NumericVector& x, double width, double origin = 0) {
  return group_out(GroupFixed(x, width, origin));
}

// [[Rcpp::export]]
IntegerVector group_breaks(const NumericVector& x, const NumericVector& breaks) {
  return group_out(GroupBreaks(x, breaks));
}

// [[Rcpp::export]]
IntegerVector group_integer(const IntegerVector& x, double origin = 0) {
  return group_out(GroupInteger(x, origin));
}

// [[Rcpp::export]]
IntegerVector group_rect(const NumericVector& x, const NumericVector& y, 
                         double x_width, double y_width,
                         double x_origin, double y_origin,
                         int x_bins) {
  return group_out(Group2d<GroupFixed>(
    GroupFixed(x, x_width, x_origin), 
    GroupFixed(y, y_width, y_origin), x_bins));
}


// [[Rcpp::export]]
IntegerVector group_hex(const NumericVector& x, const NumericVector& y, 
                         double x_width, double y_width,
                         double x_origin, double y_origin,
                         double x_max) {
  return group_out(GroupHex(x, y, x_width, y_width, x_origin, y_origin, x_max));
}
