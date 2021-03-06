#' Density and random number generation functions for a challenging
#' distribution.
#'
#' This is a 1/3-2/3 mixture of a t-distribution with 2 degrees of freedom
#' centered at 15 and scaled by 2, and a gamma distribution with shape 2
#' and rate 1/3. (The t-distribution is windsorised at 0, but this
#' has negligible effect.) This distribution is challenging because it
#' mixes heavy tailed and asymmetric distributions.
#'
#' @param x values to evaluate pdf at
#' @param n number of random samples to generate
#' @export
#' @examples
#' plot(dchallenge, xlim = c(-5, 60), n = 500)
#'
#' x <- rchallenge(1e4)
#' hist(x, breaks = 1000)
#' xsum <- condense(bin(x, 0.1))
#' plot(xsum$x, xsum$.count, type = "l")
#' xsmu <- smooth(xsum, 0.3)
#' plot(xsmu$x, xsmu$.count, type = "l")
#' plot(xsmu$x, xsmu$.count, type = "l", xlim = c(0, 30))
dchallenge <- function(x) {
  # Windorised t-distribution
  scale <- function(x) (x - 30) / 2
  spike <- ifelse(x < 0, 0, dt(scale(x), df = 2)) +
    pt(scale(0), df = 2) * (x == 0)

  slope <- dgamma(x, 2, 1/3)

  (spike + 2 * slope) / 3
}

# plot(pchallenge, xlim = c(-5, 60), n = 500)
pchallenge <- function(x) {
  #  H(y) =
  #  = int_0^y h(x) dx
  #  = int_0^y 1/3 f(x) + 2/3 g(x) dx
  #  = 1/3 int_0^y f(x) dx + 2/3 int_0^y g(x) dx =
  #  = 1/3 F(y) + 2/3 G(y)

  # h(x) = g((x - 30) / 2)
  # H(y) = int_0^y g((x - 30) / 2) dx
  # complete transformation

  scale <- function(x) (x - 30) / 2
  spike <- ifelse(x < 0, 0, pt(scale(x), df = 2))

  slope <- pgamma(x, 2, 1/3)

  (spike + 2 * slope) / 3
}

qchallenge <- function(x) {
  # approximate pchallenge with 1000 points, and linearise
  # use to implement fast option to rchallenge that does inverse pdf
  # transformation + runif()
}


#' @rdname dchallenge
#' @export
rchallenge <- function(n) {
  nt <- rbinom(1, n, 1 / 3)
  ngamma <- n - nt

  spike <- 2 * rt(nt, df = 2) + 15
  spike[spike < 0] <- 0

  slope <- rgamma(ngamma, 2, 1/3)

  c(spike, slope)
}

