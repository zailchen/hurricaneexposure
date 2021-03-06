#' Location of United States county centers of population
#'
#' A dataset containing the latitude and longitude of the
#' center of population of every United State county,
#' based on population as of the 2010 US Census.
#'
#' @format A data frame with 3221 rows and 7 variables:
#' \describe{
#'   \item{state_fips}{state FIPS code}
#'   \item{county_fips}{county 3-digit FIPS code}
#'   \item{fips}{county 5-digit FIPS code}
#'   \item{county_name}{county name}
#'   \item{state_name}{state name}
#'   \item{population}{population}
#'   \item{latitude}{latitude of county's center of population}
#'   \item{longitude}{longitude of county's center of population}
#' }
#'
#' @source \url{https://www.census.gov/geo/reference/centersofpop.html}
#'
#' @references
#' Bureau of the Census, Centers of Population Computation for the United
#' States 1950-2010, U.S. Department of Commerce, Bureau of the Census,
#'   Washington, DC, issued 2011. \url{http://www2.census.gov/geo/pdfs/reference/cenpop2010/COP2010_documentation.pdf}
"county_centers"

#' Closest distances between counties and a storm track
"closest_dist"

#' Storm tracks for Atlantic basin storms
#'
#' A dataset containing the storm tracks for all Atlantic basin tropical
#' storms between 1987 and 2012.
#'
#' @format A data frame with 12,206 rows and 6 variables:
#' \describe{
#'   \item{storm_id}{Unique storm identifier}
#'   \item{date}{Date and time of storm track recording}
#'   \item{latitude}{Latitude of storm center}
#'   \item{longitude}{Longitude of storm center}
#'   \item{wind}{Maximum storm wind speed}
#' }
#'
#' @note The original dataset included more separate `status` categories
#'    than this version. Here, I have pooled together into "Other" the
#'    following categories: extratropical cyclones (of any intensity),
#'    subtropical cycles of both subtropical depression and subtropical
#'    storm intensity, tropical waves of any intensity, disturbances of
#'    any intensity, and lows that do not fall under any of these
#'    categories.
#'
#' @references
#'    [Determine correct refenence]
"hurr_tracks"

#' Rainfall for a week-long window for tropical storms
#'
#' A dataframe that gives the total rainfall in US counties for a one-week
#' window centered at the date on which the tropical storm was closest
#' to the county for all Atlantic basin storms between 1987 and 2012.
#'
#' @format A list with 991,530 rows and 3 variables:
#' \describe{
#'   \item{fips}{county 5-digit FIPS code}
#'   \item{storm_id}{unique identifier for each tropical storm}
#'   \item{lag}{Number of days from date when storm was closest to the county}
#'   \item{precip}{Average daily precipitation, in millimeters, for NLDAS grid
#'    points with the county for the given lag day}
#'   \item{precip_max}{Maximum daily precipitation, in millimeters, for NLDAS grid
#'    points with the county for the given lag day}
#' }
#'
#' @references
#'    [Get proper reference from Bill and Mohammad]
"rain"
