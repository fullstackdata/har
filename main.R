# main script to pass arguments to run_analysis.R

#Change inputDir for setting the name of the input folder
inputDir <- "UCI HAR Dataset";

commandArgs <- function() c(inputDir);

source("run_analysis.R");




