# ---------------------------------------#
# protocol- and file-specific parameters #
# ---------------------------------------#

# This file is intended as a place to define protocol-specific parameters, options, functions, etc.
# so that the preprocess_*.Rmd files stay as untouched as possible by protocol-specific requirements.
# This file should be sourced by each preprocess_*.Rmd file, but that means that objects defined herein
# will be recreated multiple times during package builds. However, this is a good place to create metadata
# objects, such as rx files, challenge data, demographics, etc. that will be needed by multiple assays.

# There may be times when a standard data processing function from functions.R will need to be modified
# for a particular assay because the standard version isn't adequate. If the preprocess_*.Rmd file
# sources this file *after* functions.R, it is possible redefine your functions without modifying
# the default function in functions.R.

# Get protocol name
pkgName <- roxygen2:::read.description("../DESCRIPTION")$Package
pkgName1 <- simpleCap(gsub(".", " ", pkgName, fixed=TRUE)) # Remove dots from protocol name
pkgName1 <- gsub("([[:alpha:]])([[:digit:]])", "\\1 \\2", pkgName1) # space between VDC name and protocol number

# Define global username vars
Ruser <- Sys.getenv("USER")
username <- getUsername(Ruser)
Rversion <- paste0("R version ", R.version$major, ".", R.version$minor, " (", username, ")")

# Read metadata files and save as systematically named Rda files
challenge_file <- file.path("..", "inst", "extdata", "some_challenge_data.csv")
if(file.exists(challenge_file)){
  challenge <- fread(challenge_foile)
  setnames(challenge, c("ptid", "group", "num_challenges"))
  saveObj("challenge", "challenge")
}

rx_file <- file.path("..", "inst", "extdata", "rx.csv")
if(file.exists(rx_file){
  rx <- fread(rx_file)
  setkey(rx, ptid)
  saveObj("rx", "rx")
}

arp_file <- file.path("..", "inst", "extdata", "arp.csv")
if(file.exists(arp_file){
  arp <- fread(arp_file)
  setkey(arp, antigen)
  saveObj("arp", "arp")
}

# --------------
# ICS
# --------------
ICS_control <- "COSTIM"
ICS_baseline_visit <- -4
COMPASS_iterations <- 40000
Vpctcut <- 35
Vrawcut <- 35000

# Subsetting Test Based on only comparisons (Populations) we will be interested in.
pops_of_interest <- c("CD4/TOTM/IFNg", "CD4/TOTM/IL2", "CD4/TOTM/IL4", "CD4/TOTM/IL5", "CD4/TOTM/IL13", "CD4/TOTM/IL17A",
                      "CD4/TOTM/IL21", "CD4/CM/CXCR5/IL21", "CD4/TOTM/IFNg Or IL2", "CD8/TOTM/IFNg", "CD8/TOTM/IL2", "CD8/TOTM/IFNg Or IL2",
                      "CD4/TOTM/IL4 Or IL5 Or IL13", "CD8/TOTM/IL4 Or IL5 Or IL13")


# --------------
# BAMA
# --------------

# Get the names of the bama files in inst/extdata
z <- function(x){list.files(path="../inst/extdata", pattern=x, ignore.case=TRUE)}
bama_qfilenames <- as.character(unlist(sapply("serum", z)))

# (blanklist is all lower case so caps in antigen field don't mess up matching)
# blanklist["blank"] is name of blank bead
# blanklist["gp70"] are the names of the gp70 blank that may appear
blanklist <- list(
  blank = "blank",
  gp70 = c("gp70 control", "mulvgp70_his6") # gp70 control should be first
)

# static facts about the protocol
baseline_visit <- 0
binding_dil <- 80
allowNonRunMatchedBlanks <- FALSE
infillPosThreshold <- FALSE
derivePosThreshold <- TRUE


# --------------
# NAb
# --------------

# Get the names of the bama files in inst/extdata
z <- function(x){list.files(path="../inst/extdata", pattern=x, ignore.case=TRUE)}
nab_qfilenames <- as.character(unlist(sapply("NAB", z)))

tier <- data.table(
  isolate = c("25710-2.43", "BJOX002000.03.2", "MN.3", "SHIV SF162P3.5", "SVA-MLV", "TRO.11"),
  tier = c("2", NA, "1A", "SHIV", NA, "2"),
  clade = c("C", "CRF07_BC", "B", "B", NA, "B")
  )
setkey(tier, isolate)

# --------------
# ELISA
# --------------

elisa_qfilename <- list.files(path="../inst/extdata/", pattern="elisa", ignore.case = TRUE)
