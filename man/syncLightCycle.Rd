% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/syncLightCycle.R
\name{syncLightCycle}
\alias{syncLightCycle}
\title{Synchronize experiment to its light cycle}
\usage{
syncLightCycle(DAM, ..., completeFirstDay = FALSE, lightFirst = TRUE)
}
\arguments{
\item{DAM}{A valid DAM S4 experiment you wish to sync}

\item{completeFirstDay}{A boolean value. If true, the first incomplete day in
the dataset is removed. If false, NAs are added to make an incomplete first
day have 24 full hours. Default: FALSE}

\item{lightFirst}{A boolean value. If true, the experiment is synced so that 
light periods appear first (otherwise dark periods are first). Default: 
TRUE}
}
\value{
Returns a DAM S4 object, synced by light cycle.
}
\description{
This method syncs an experiment to a cycling light. This ensures that the
start of each experimental day occurs at the same time that the lights switch
on or off. Useful for plotting and subsetting your data by days.
}

