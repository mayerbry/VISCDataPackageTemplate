# Code Template for a VISC R Data Package

This repo contains default code for data processing assays and QC reports. It is not intended to be a starting point for new packages, as it does not contain some of the necessary files and directories for packages. Use `DataPackageR::datapackage_skeleton()` for that. However, it does contain standard data processing functions, standard QC report formatting functions, and standard processing code for BAMA, ELISA, NAb, and ICS.

PK code can be found in the Nussenzweig PK packages. The data and data processing have not been standardized enough yet to publish here.

Note that this code is still configured for datasets.R-based package building. It will need to be updated to handle the YAML-based package building.

* datasets.R is the old driver program.
* functions.R contains standard data-processing functions. This is sourced at the top of each preprocess_*.Rmd script.
* qc_functions.R contains standard formatting functions for QC reports. This is sourced at the top of each preprocess_*.Rmd script.
* protocol_specific.R contains protocol-specific objects, definitions, functions, etc. This is sourced at the top of each preprocess_*.Rmd script.
* reproducibility.R contains code for reproducibility tables. This is sourced at the end of each preprocess_*.Rmd script.
* preprocess_*.Rmd contains code for processing each respective assay

Note that metadata does not arrive as systematically as assay data. The VISC project managers are trying to streamline this process, but be aware that when you start processing assay data, you might have to ping the project managers to find treatment assignment information, demographics, etc. The best way I've found to handle metadata is to put it in `inst/extdat/` and read it in `protocol_specific.R`. If you source `protocol_specific.R` in each assay script, you'll have rx or demo or whatever defined as an object that you can refer to. If you save these datasets using `SaveObj()`, then alternately, you can `load()` the .Rda files from the `/data/` directory of the package.

---

## ICS-specific processing
This is a short description of the ICS processing flow. The processing code (`data-raw/preprocess_flow.Rmd` produces HTML output in `inst/doc/`. To run ICS preprocessing code, you’ll need to do some things first:

* Install bioconductor: 

```
source("https://bioconductor.org/biocLite.R")
biocLite()
```

You’ll have to install several packages from bioconductor, by including them in a subsequent `biocLite()` call just like you’d do with `install.packages()`. The packages are flowWorkspace, openCyto, ggcyto, flowIncubator. Use

```
biocLite(c("flowWorkspace", "openCyto", "ggcyto", "flowIncubator"))
```

* update the `PATH` variable at the top of the flow code to point to `T://cavd/obj1/cvd465/`

* change `parseXML` (in 1st chunk) to TRUE for your first run--this is referred to in the `eval=` argument of several chunks and controls whether the raw file parsing is done or not.

* define `SCRATCH` (1st chunk) to point to a location on your C drive that can hold a lot of data (about 20 GB). I kept local files for all protocols on my machine until the final report was sent out, so that I didn’t have to parse again. It can take 3-5 hours or more.

Once you parse the XML files, you’ll store objects locally so you don’t have to go through the extremely time-consuming parse process again. This is done with `save_gs()`--you’ll see several `save_gs()` calls through the process. If you’re ever running through the code and you worry that you’ve made a mistake, you can always just reload your last-saved local object with `load_gs()`. Once you’ve successfully gotten through the last chunk that has the argument `eval = parseXML`, you will have all relevant parsed data stored locally, and you can change parseXML to false and operate just from locally saved files.

FYI, `protocol_specific.R` contains some object definitions that are relevant to ICS.

*In general, the ICS flow goes like this:*

### Step 1 
Basic definitions, source files, load packages, set options

### Step 2
Parse XML files, save first local object

### Step 3, when needed
Used to standardize the parsed files--This will vary greatly by protocol and will often need Greg’s help. Save local object.

### Step 4
Print list of nodes and gating hierarchy

### Step 5
Add Boolean gates — this adds the Booleans to the data. Save second local object.

### Step 6
Extract the ICS data out of the GatingSet created in Step 7 into a data.table. Compute viability, compute marginals, and joint marginals, compute background values and parent values.

### Step 7
Fisher p-values

### Step 10
MIMOSA

### Step 11
COMPASS

### Step 12
Gating plots for review

---

## BAMA Notes

In the `inst/exdata` folder of this package, you'll find a file called `arp.csv` that contains the Antigen Reagent Project antigen panels and clades.

For QCing BAMA data, we have worked out the following process with the Tomaras lab:
1. Build package and internally QC and sanity check the data
2. Make sure you run `writePerm()` in your BAMA code with `qc=TRUE`. This outputs a CSV QC file for lab programmatic QC.
3. Write and internally review the BAMA QC report.
4. Upload the QC csv file and QC report to COWS: `https://atlas.scharp.org/cpas/project/HVTN/Tools%20and%20Reports/Collaborative%20Workspace/Data%20Sets-Reports/begin.view?`
  * Navigate to the `Duke [Tomaras]` tab
  * Navigate to the LUM folder
  * Navigate to the relevant cvdNNN numbered folder, or create one if it doesn't exist
  * Use the COWS GUI tools to upload your files. CSV files should have a date in the filename. The BAMA code does this by default.
5. Inform the lab by email that the QC report and csv file have been uploaded.
