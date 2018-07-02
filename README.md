# Code Template for a VISC R Data Package

This repo contains default code for data processing assays and QC reports. It is not intended to be a starting point for new packages, as it does not contain some of the necessary files and directories for packages. However, it does contain standard data processing functions, standard QC report formatting functions, and standard processing code for BAMA, ELISA, NAb, and ICS.

PK code can be found in the Nussenzweig PK packages. The data and data processing have not been standardized enough yet to publish here.

Note that this code is still configured for datasets.R-based package building. It will need to be updated to handle the YAML-based package building.

* datasets.R is the old driver program.
* functions.R contains standard data-processing functions. This is sourced at the top of each preprocess_*.Rmd script.
* qc_functions.R contains standard formatting functions for QC reports. This is sourced at the top of each preprocess_*.Rmd script.
* protocol_specific.R contains protocol-specific objects, definitions, functions, etc. This is sourced at the top of each preprocess_*.Rmd script.
* reproducibility.R contains code for reproducibility tables. This is sourced at the end of each preprocess_*.Rmd script.
* preprocess_*.Rmd contains code for processing each respective assay
