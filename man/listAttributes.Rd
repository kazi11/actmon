% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/attributeMethods.R
\name{listAttributes}
\alias{listAttributes}
\title{Get the attributes of a dataset}
\usage{
listAttributes(obj)
}
\arguments{
\item{obj}{A valid DAM S4 object.}
}
\value{
A vector of all attribute names in a dataset.
}
\description{
List all attributes (column names) from a dataset's metadata.
}
\examples{
listAttributes(DAM_DD)
}

