# reproducibility code

## ---- reprotab

# Reproduceability Tables

# loading in rmarkdown so we can capture verison number
if(any(installed.packages()[, 1] == 'rmarkdown')) library(rmarkdown)

my_session_info <- devtools::session_info()

platform <- my_session_info[[1]]
packages <- my_session_info[[2]]

# TABLE 1
my_session_info1 <- data.table::data.table(
  name = names(platform),
  value = matrix(unlist(platform), nrow = length(platform)))

my_current_input <- ifelse(is.null(ci <- knitr::current_input()), 'No Input File Detected', ci)

file_name <-  data.table::data.table(
  name = 'file name',
  value = my_current_input)

# Add user info
user_info <- data.table::data.table(
  name = 'user',
  value = username)

gitremote <-  substr(remote <- system("git remote -v", intern = TRUE)[1],
                     regexpr("\t", remote) + 1,
                     regexpr(" ", remote) - 1)

if (is.na(gitremote) | gitremote == "") {
  # No Remote Connection, so just give absolute path
  folder_info <- data.table(
    name = 'location',
    value = getwd())
  my_session_info1 <- data.table::rbindlist(list(my_session_info1, folder_info, file_name, user_info))
} else{
  # Git Remote connection, so getting url and path
  all_git_files <- system('git ls-files -co --no-empty-directory --full-name', intern = TRUE)
  folder_info_in <- sub(paste0('/', my_current_input), '',
                        all_git_files[grep(my_current_input, all_git_files)])

  if(length(folder_info_in)==0){
    folder_info_in <- 'No Location Detected'
  } else {
    folder_info_in <- folder_info_in[sapply(folder_info_in,
                                            function(x){length(grep(x, getwd())) == 1})]
    }

  # Dropping matching file names that do not match folder path
  folder_info <- data.table::data.table(
    name = 'location',
    value = folder_info_in)
  url_info <- data.table::data.table(
    name = 'repo',
    value = gitremote)

  my_session_info1 <- data.table::rbindlist(list(my_session_info1, url_info, folder_info, file_name, user_info))
}

xtab1 <- xtable(x = my_session_info1,
               caption = 'Supplemental Table: Reproducibility Software Session Information',
               label = 'session_info')


# TABLE 2
my_session_info2 <- data.table::data.table(
  matrix(unlist(packages), ncol = length(packages))
  )[V2=='*'][, V2 := NULL] # Only want attached packages
data.table::setnames(my_session_info2, c(paste('V', c(1, 3, 4, 5), sep = '')), names(packages)[-2])

# Adding in Data Versions
if(nrow(my_session_info2)>0){
  my_session_info2[, data.version := as.character(packageDescription(package, fields = 'DataVersion')), by = package]
}

if(my_session_info2[, all(is.na(data.version))]){
  my_session_info2 <- my_session_info2[, .(package, version, date, source)]
} else {
  my_session_info2[is.na(data.version), data.version := '']
  setcolorder(my_session_info2, c('package', 'version', 'data.version', 'date', 'source'))
}

# if this is a vignette in a package, add the data package without loading it
if(file.exists('../DESCRIPTION')){
  thisRow <- my_session_info2[1]
  rd <- roxygen2:::read.description("../DESCRIPTION")
  thisRow[,
          `:=`(package = rd$Package,
               version = rd$Version,
               `data version` = rd$DataVersion,
               date = rd$Date,
               source = url_info$value)]

# if local repo path is too long, break it into two lines
# (this assumes that it doesn't need to wrap to 3 lines)
if(nchar(thisRow$source) > 60){
  slashes <- gregexpr("/", thisRow$source, fixed=TRUE)[[1]]
  p1 <- substr(thisRow$source, 1, slashes[which(slashes>30)][1])
  p2 <- substr(thisRow$source, slashes[which(slashes>30)][1]+1, 500)
  newsource <- gsub("_", "\\_", paste(p1, p2), fixed=TRUE)
  thisRow$source <- newsource
}

my_session_info2 <- rbindlist(list(my_session_info2, thisRow), use.names=TRUE, fill=TRUE)
setcolorder(my_session_info2, c('package', 'version', 'data version', 'date', 'source'))
my_session_info2 <- my_session_info2[! source %like% "local"]
}

xtab2 <- xtable(x = my_session_info2, caption = 'Supplemental Table: Reproducibility Software Package Version Information',
               label = 'session_info2', align='lllllp{6cm}')
if(toupper(knitr::current_input()) %like% "RMD"){kable(xtab1)} else {print(xtab1, include.rownames = FALSE, include.colnames = FALSE, size = "\\footnotesize")}
if(toupper(knitr::current_input()) %like% "RMD"){kable(xtab2)} else {print(xtab2, include.rownames = FALSE, size = "\\footnotesize", sanitize.text.function=identity)}
