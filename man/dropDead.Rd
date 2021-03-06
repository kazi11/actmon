% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dropDead.R
\name{dropDead}
\alias{dropDead}
\title{Automatically remove dead animals}
\usage{
dropDead(obj)
}
\arguments{
\item{obj}{A valid DAM S4 object}
}
\value{
A DAM S4 object
}
\description{
This method gets rid of animals that died during an experiment. Death is
detected using the \code{\link{calcSurvivalTime}} method.
}
\examples{
notDead <- dropDead(DAM_DD)
}
\seealso{
\code{\link{calcSurvivalTime}}
}

