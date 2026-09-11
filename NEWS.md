# HSGconnect 0.2.0

## Breaking changes

* `read_BFS_data()` now defaults to `year = 2025` (previously `2023`).
  Calls without an explicit `year` now load the 2025 survey. Pass
  `year = 2023` to get the previous behaviour. Note that there is no
  SSEE survey for 2025, so `read_BFS_data(survey = "SSEE")` needs an
  explicit year (e.g. `year = 2024`).

## Improvements

* Failed requests in `sd_connect()`, `sd_list_files()`, `read_BFS_data()`
  and `read_sd()` now report the tried URL and a hint for common HTTP
  status codes (401, 403, 404, 423). On a 401 the message explains how
  to create a new SwitchDrive app password and rerun `sd_setup()`.

## Documentation and metadata

* Fixed the maintainer e-mail address in DESCRIPTION.
* Removed `LazyData`, as the package ships no data sets.
* Documented the return values of `sd_get_connection()` and `sd_setup()`.
* README.Rmd now uses pak for installation, matching README.md.

# HSGconnect 0.1.0

* Initial release.
