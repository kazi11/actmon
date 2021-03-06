% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calcAnovaN.R
\name{calcTukeyHSD}
\alias{calcTukeyHSD}
\title{Run a Tukey HSD post-hoc test}
\usage{
calcTukeyHSD(aov, ..., sig.only = FALSE)
}
\arguments{
\item{aov}{An ANOVA model (created with \code{\link{stats::aov}})}

\item{sig.only}{Return only significant tests?}
}
\value{
Returns all of the significant
}
\description{
This is a convenience function designed to print out all of the significant 
comparisons (p < 0.05) from an ANOVA model
}

