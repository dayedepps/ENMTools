% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/env.evaluate.R
\name{env.evaluate}
\alias{env.evaluate}
\title{Calculates evaluation metrics (AUC, etc.) using latin hypercube sampling in environment space}
\usage{
env.evaluate(species, model, env, bg.source = "background", ...)
}
\arguments{
\item{species}{An enmtools.species object}

\item{model}{An enmtools.model object or a model that can be projected using the predict() function of dismo}

\item{env}{A raster or raster stack of environmental data.}

\item{bg.source}{Determines whether minima and maxima of the environment space should be picked using the environment layers or the background points.}

\item{...}{Arguments to be passed to othfer functions}
}
\description{
Calculates evaluation metrics (AUC, etc.) using latin hypercube sampling in environment space
}

