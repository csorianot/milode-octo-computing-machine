% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/filter_neighbourhoods.R
\name{filter_neighbourhoods}
\alias{filter_neighbourhoods}
\title{filter_neighbourhoods}
\usage{
filter_neighbourhoods(x)
}
\arguments{
\item{x}{A \code{\linkS4class{Milo}} object.}
}
\value{
\code{Milo} object with refined neighbourhood assignment
}
\description{
Filtering redundant neighbourhoods, using the greedy approach to set cover problem
}
\details{
This function refines neighbourhood assignment and discards redundant neighbourhoods. This call is highly recommended since it reduces computational time greatly.
It is called directly in \code{\link{assign_neighbourhoods}} if \code{filtering=TRUE}, and also can be called independently post hoc.

Under the hood, it adapts \code{\link[RcppGreedySetCover]{greedySetCover}} function, which implements greedy solution to NP-hard \sQuote{set cover} problem.
In this solution, all neighbourhoods are sorted in the decreasing order of their size (i.e. number of cells),
and neighbourhoods are iteratively added to the final neighbourhood set if they contain at least one cell not \sQuote{covered} by previously added neighbourhoods.
}
\examples{
require(SingleCellExperiment)
n_row = 500
n_col = 100
n_latent = 5
sce = SingleCellExperiment(assays =
list(counts = floor(matrix(rnorm(n_row*n_col), ncol=n_col)) + 4))
rownames(sce) = as.factor(1:n_row)
colnames(sce) = c(1:n_col)
sce$cell = colnames(sce)
reducedDim(sce , "reduced_dim") =
matrix(rnorm(n_col*n_latent), ncol=n_latent)
sce = assign_neighbourhoods(sce,
reducedDim_name = "reduced_dim" , k = 10 , order = 1)
sce = filter_neighbourhoods(sce)
}
