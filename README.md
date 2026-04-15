
# HSGconnect

`HSGconnect` provides a convenient R interface to access files stored on
[SwitchDrive](https://drive.switch.ch) via WebDAV. Browse folders, read
data files, and import BFS survey data — directly from R, without manual
downloads.

## Installation

``` r
# pkg_install ("pak")
pak::pkg_install("NickGlaettli/HSGconnect")

# install.packages("devtools")
devtools::install_github("NickGlaettli/HSGconnect")
```

## Quick Start

``` r
library(HSGconnect)

# One-time setup: stores credentials in .Renviron
sd_setup()

# Connect to SwitchDrive
sd_connect()
#> Successfully connected to Switchdrive as max.mustermann@unisg.ch

# Browse files
sd_list_files("BFS Daten")
#> [1] "01 EHA Absolventen/"    "02 SSEE Studenten/"
#> [3] "03 Verträge/"           "04 Importinformationen/"

# Import BFS survey data
eha <- read_BFS_data(survey = "EHA", year = 2023, HSG_only = TRUE)
#> Reading eb_2023_hsg.sav...
#> Import successful: 1245 rows, 187 columns.

# Read any file from SwitchDrive
df <- read_sd("Projekte/report.xlsx", sheet = "Rohdaten")
```

## Prerequisites

An **app-specific password** for SwitchDrive (not your
university login) is strongly advised:

1.  Log in to [drive.switch.ch](https://drive.switch.ch)
2.  Go to **Settings → Security**
3.  Under *App passwords*, create a new password and copy it

## Main Functions

| Function          | Description                                             |
|:------------------|:--------------------------------------------------------|
| `sd_setup()`      | Store SwitchDrive credentials in `.Renviron` (one-time) |
| `sd_connect()`    | Authenticate and establish a WebDAV connection          |
| `sd_list_files()` | List files and folders on SwitchDrive                   |
| `read_BFS_data()` | Import BFS survey data (EHA / SSEE)                     |
| `read_sd()`       | Import any `.sav`, `.csv`, or `.xlsx` file              |

## Documentation

For a detailed walkthrough, see the vignette:

``` r
vignette("HSGconnect", package = "HSGconnect")
```
