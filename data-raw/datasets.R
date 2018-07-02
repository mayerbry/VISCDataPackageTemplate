library(rmarkdown)

# ------------------------------------------------------------
# Source additional R scripts to preprocess assay data
for(fn in list.files(path="./", pattern="^preprocess_.*\\.Rmd$")){
  render(fn,
         output_format="html_document",
         envir = topenv(),
         output_dir = normalizePath("../inst/extdata/Logfiles"),
         clean = TRUE)
}

# Define data objects to keep in the package
objectsToKeep <- ls(pattern=pkgName)

# ------------------------------------------------------------
# Auto build roxygen documentation
# On first build, we generate boilerplate roxygen documentation using DataPackageR:::.autoDoc()
# User then manually edits the output file edit_and_rename_to_'documentation.R'.R and renames it to documentation.R.
# The documentation.R file is then used for all subsequent builds.
if(file.exists("documentation.R")){
  sys.source('documentation.R', envir=topenv())
} else {
  DataPackageR:::.autoDoc(pkgName, objectsToKeep, topenv())
}

# keep only objects labeled for retention
DataPackageR:::keepDataObjects(objectsToKeep)
