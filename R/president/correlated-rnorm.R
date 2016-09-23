library('Matrix')

buildCorrelationConstant <- function() {
  # Read correlations from file
  frame <- read.csv('state-correlation-matrix.csv', colClasses='double')
  rawMatrix <- as.matrix(frame)

  # Make the matrix the nearest positive definite, but still correlated,
  # because CorrelatedRnorm() won't work with the negative eigenvalues the
  # original generates.
  pdMatrix <- as.matrix(nearPD(rawMatrix, corr=TRUE)$mat)

  ev <- eigen(pdMatrix, symmetric=TRUE)

  return(ev$vectors %*% diag(sqrt(ev$values)) %*% t(ev$vectors))
}

kCorrelationConstant <- buildCorrelationConstant()

# Returns an array of normal-distribution doubles which are correlated.
CorrelatedRnorm <- function() {
  n <- nrow(kCorrelationConstant)
  random <- rnorm(n)
  ret <- kCorrelationConstant %*% random
  return(drop(ret))
}

print(CorrelatedRnorm())
