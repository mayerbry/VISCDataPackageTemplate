# ---------------------------------------#
# protocol- and file-specific parameters #
# ---------------------------------------#

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
baseline_visit <- -2
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
