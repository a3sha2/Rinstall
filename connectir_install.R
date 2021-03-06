#!/usr/bin/env/Rscript

basedir <- getwd()
run <- function(cmd) {
    cat("RUNNING:", cmd, "\n")
    ret <- system(cmd)
    if (ret != 0) {
        cat("ERROR running", cmd, "exiting\n")
        quit(save="no", status=ret)
    }
    invisible(ret)
}

# Various Dependencies
cat("Installing various dependencies\n")
install.packages(
    c("codetools", "foreach", "doMC", "getopt", "optparse", 
        "bigmemory", "biganalytics", "bigmemory.sri", "testthat")
, repos="http://cran.us.r-project.org")
install.packages(
    c("plyr", "Rcpp", "RcppArmadillo", "inline", "devtools"), 
    dependencies=TRUE
, repos="http://cran.us.r-project.org")
# If devtools fails then you will need to manually download the libraries from git and install them

# Install BigAlgebra
cat("\nInstalling bigalgebra\n")
devtools::install_github("czarrar/bigalgebra") # https://github.com/czarrar/bigalgebra

# Installing niftir and friends
cat("\nInstalling connectir and friends\n")
devtools::install_github("czarrar/bigextensions") # https://github.com/czarrar/bigextensions
devtools::install_github("czarrar/niftir") # https://github.com/czarrar/niftir
run("git clone https://github.com/czarrar/connectir.git") # https://github.com/czarrar/connectir
run("R CMD INSTALL connectir")
cat("\nCopying scripts for connectir\n")
bindir <- dirname(system("which R", intern=TRUE))
system(sprintf("cp connectir/inst/scripts/*.R %s/", bindir))
system(sprintf("rm -f %s/*_worker.R", bindir))
system(sprintf("chmod +x %s/*.R", bindir))
setwd(basedir)
run("rm -rf connectir")

# TODO: add copying of scripts to some bin location
