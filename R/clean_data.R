#' Clean the power_plant_data DataFrame
#'
#' This internal function cleans the `power_plant_data` dataframe by performing the following:
#' - Removes the `other_fuel3` column, which has 100% missing values.
#' - Cleans the `commissioning_year` column by rounding it to the nearest integer and converting it to an integer type.
#'
#' @details
#' The cleaned dataframe ensures compatibility for analysis and visualization by removing unnecessary or problematic columns
#' and standardizing data types.
#'
#' @return A cleaned version of the `power_plant_data` dataframe.
#' @keywords internal
clean_power_plant_data <- function() {
  GBPowerPlant::power_plant_data %>%
    # Remove the 'other_fuel3' column
    select(-c(other_fuel3, url, wepp_id)) %>%
    # Clean and format the 'commissioning_year' column
    mutate(
      commissioning_year = as.integer(round(commissioning_year)), # Round to nearest whole number and Convert to integer
      year_of_capacity_data = as.integer(year_of_capacity_data) # Convert to integer
    )
}
