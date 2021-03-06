<!-- README.md is generated from README.Rmd. Please edit that file -->
Loading the package
-------------------

The package currently exists in [a development version](https://github.com/geanders/hurricaneexposure) on GitHub. You can use the following code to load it:

``` r
library(devtools)
install_github("geanders/hurricaneexposure", 
               build_vignettes = TRUE)
library(hurricaneexposure)
```

Once you've loaded the dataframe, you can load the included data using the `data` function. For example:

``` r
data("hurr_tracks")
head(hurr_tracks)
#>       storm_id         date latitude longitude wind
#> 1 Alberto-1988 198808051800     32.0     -77.5   20
#> 2 Alberto-1988 198808060000     32.8     -76.2   20
#> 3 Alberto-1988 198808060600     34.0     -75.2   20
#> 4 Alberto-1988 198808061200     35.2     -74.6   25
#> 5 Alberto-1988 198808061800     37.0     -73.5   25
#> 6 Alberto-1988 198808070000     38.7     -72.4   25
```

The following datasets are included with the package:

-   `closest_dist`
-   `county_centers`
-   `hurr_tracks`
-   `rain`

For each, you can see the helpfiles for the data for more information about the data included in each.

Creating time series datasets of exposure
-----------------------------------------

There are several functions in this package that help to take the data on rainfall and storm tracks stored in the package and use them, in conjunction with thresholds for the distance to the storm tracks and the amount of rainfall required for exposure, to create time series of exposure that can be easily integrated into time series datasets of, for example, health data.

First, the `county_rain` function takes a list of county FIPS codes, bounds on the starting and ending years of the analysis, and thresholds for distance (storm path must come that close or closer to the county) and rainfall (total rainfall summed over the days you specify-- for example, `days_included = c(-1, 0, 1)` would use the total rainfall summed over the day before, day of, and day after the date when the storm was closest to the county). The function outputs a dataframe with all of the storms to which each of the counties was exposed.

For example, to get a dataset of all the storms to which Orleans Parish (FIPS 22071), and Newport News, Virginia (FIPS 51700), were exposed between 1995 and 2005, where "exposed" means that the storm passed within 100 kilometers of the county center and the rainfall over three days was 100 millimeters or more, you could run:

``` r
county_rain(counties = c("22071", "51700"),
            start_year = 1995, end_year = 2005,
            rain_limit = 100, dist_limit = 100,
            days_included = c(-1, 0, 1))
#> Source: local data frame [7 x 5]
#> 
#>       storm_id  fips        closest_date storm_dist tot_precip
#>          (chr) (chr)              (time)      (dbl)      (dbl)
#> 1    Bill-2003 22071 2003-06-30 16:45:00   41.67038      141.1
#> 2 Charley-2004 51700 2004-08-14 17:45:00   55.21439      136.2
#> 3   Cindy-2005 22071 2005-07-06 01:00:00   29.76580      113.2
#> 4   Floyd-1999 51700 1999-09-16 09:00:00   47.77641      207.5
#> 5 Isidore-2002 22071 2002-09-26 05:30:00   12.68783      249.0
#> 6 Katrina-2005 22071 2005-08-29 07:45:00   43.71121      196.2
#> 7 Matthew-2004 22071 2004-10-10 09:30:00   81.76565      123.2
```

In addition to giving you the names and closest dates of each storm for each county (`closest_date`-- note, this is given using the UTC timezone), this function also gives you the distance between the county and the storm's track at the time when the storm was closest to the county's population weighted center (`storm_dist`, in kilometers) and the total precipitation over the included days (`tot_precip`).

To get a dataframe listing the relevant storms for multi-county communities, you can use the `multi_county_rain` function in a similar way:

``` r
communities <- data.frame(commun = c(rep("ny", 6), "no", "new"),
                         fips = c("36005", "36047", "36061",
                                  "36085", "36081", "36119",
                                  "22071", "51700"))
rain_storm_df <- multi_county_rain(communities = communities,
                                   start_year = 1995, end_year = 2005,
                                   rain_limit = 100, dist_limit = 100,
                                   days_included = c(-1, 0, 1))
```

This output includes columns for the average closest distance for any of the counties in the community (`mean_dist`), the average precipitation for all the counties (`mean_precip`), the highest precipitation for any of the counties (`max_rain`), and the smallest distance between the storm track and any of the county population-weighted centers (`min_dist`).

Creating and writing time series of exposure
--------------------------------------------

To create time series of hurricane exposure for all of the storms that meet the exposure definition for study communities, you can use the function `rain_exposure`. If you have counties for your study, you can run this with a vector of the county FIPS as the `locations` argument (specify the directory path to write the files with `out_dir`):

``` r
rain_exposure(locations = c("22071", "51700"),
              start_year = 1995, end_year = 2005,
              rain_limit = 100, dist_limit = 100,
              out_dir = "~/tmp/storms")
```

If you have multi-county communities, set `locations` instead to be a dataframe with community names (`commun` column) and FIPS codes (`fips` column):

``` r
communities <- data.frame(commun = c(rep("ny", 6), "no", "new"),
                          fips = c("36005", "36047", "36061",
                          "36085", "36081", "36119",
                          "22071", "51700"))
rain_exposure(locations = communities,
              start_year = 1995, end_year = 2005,
              rain_limit = 100, dist_limit = 100, out_dir = "~/tmp/storms")
```

Both functions will output one file of exposure per county or community into the directory that you specify using the `out_dir` argument.

Mapping hurricane exposure
--------------------------

This package allows you to create some different maps of hurricane exposures based on distance to the storm track and rainfall.

### Plotting county-level exposure

The `map_counties` function creates county choropleths of different storm exposure variables (right now, rainfall and distance from the storm tracks). For example, to plot rain exposure for Hurricane Floyd in 1999 (the ID for this storm is "Floyd-2012"):

``` r
map_1 <- map_counties(storm = "Floyd-1999", metric = "rainfall")
map_1
```

![](README-unnamed-chunk-9-1.png)

You can also use this function to plot the closest distance between the storm and each county. For this, you use the argument `metric = "distance"`.

``` r
map_2 <- map_counties(storm = "Sandy-2012", metric = "distance")
map_2
```

![](README-unnamed-chunk-10-1.png)

You can map a binary variable of distance-based exposure using `map_distance_exposure`:

``` r
allison_map <- map_distance_exposure(storm = "Allison-2001",
                                     dist_limit = 75)
plot(allison_map)
```

![](README-unnamed-chunk-11-1.png)

You can also map a binary variable of rain exposure for the communities that were exposed, based on a certain rainfall limit and distance limit:

``` r
map_3 <- map_rain_exposure(storm = "Floyd-1999", rain_limit = 125,
                           dist_limit = 500, 
                           days_included = c(-1, 0, 1))
plot(map_3)
```

![](README-unnamed-chunk-12-1.png)

### Plotting storm tracks

The `map_tracks` function will map the hurricane tracks for one or more storms. For example, to plot the tracks of Hurricane Floyd in 1999 (the ID for this storm is "Floyd-2012"):

``` r
map_4 <- map_tracks(storms = "Floyd-1999")
#> 
#>  # maps v3.1: updated 'world': all lakes moved to separate new #
#>  # 'lakes' database. Type '?world' or 'news(package="maps")'.  #
map_4
```

![](README-unnamed-chunk-13-1.png)

There are some different options you can use for the tracks' appearance. For example, if you wanted to plot the tracks of several storms, not plot each point when the track locations were measured (typically every six hours), and use some transparency so you can see all the lines, you can use:

``` r
map_5 <- map_tracks(storms = c("Floyd-1999", "Sandy-2012",
                               "Katrina-2005"),
                    plot_points = FALSE,
                    alpha = 0.5)
map_5
```

![](README-unnamed-chunk-14-1.png)

You can also add these tracks to an existing `ggplot`-created US map. You do this through the `plot_object` argument. For example, to add the storm track to the plot of distance exposure for Sandy or rain exposure for Floyd, you could run:

``` r
map_6 <- map_tracks(storms = "Sandy-2012", plot_object = map_2,
                    plot_points = FALSE)
map_6
```

![](README-unnamed-chunk-15-1.png)

``` r
map_7 <- map_tracks(storms = "Floyd-1999", plot_object = map_3,
                    plot_points = FALSE)
map_7
```

![](README-unnamed-chunk-16-1.png)
