% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/importFilesPredictionTool.R
\name{importOther}
\alias{importOther}
\title{Import circRNAs detected by an annotation-based circRNA
detection tool}
\usage{
importOther(pathToFile)
}
\arguments{
\item{pathToFile}{A character string specifying the path to the file
containing the detected circRNAs.}
}
\value{
A data frame.
}
\description{
The function importOther() is designed to read output file from a
annotation-based circRNA detection tool. The user after the detection of the
crcRNAs must format the output file, so that it has the following columns
with header: gene, strand, chrom, startUpBSE, endDownBSE and coverage.
If more columns are present they will be discared.
}
\examples{
# Path to an example file containing circRNAs
pathToFile <- system.file("extdata", "tool1/circRNAs_001.txt",
    package="circRNAprofiler")

# Inner function.
# Import circRNAs
importOther(pathToFile)

}
\keyword{internal}
