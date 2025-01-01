#' Update Power Plant Data
#'
#' This function downloads the latest version of the power plant dataset from Kaggle,
#' verifies that the necessary columns are present, and updates the `power_plant_data.rda` object in the package.
#'
#' @details The dataset is sourced from Kaggle's "Global Power Plant Database".
#' For the function to work, you must have Kaggle's CLI tool installed and configured
#' with your API credentials. The CSV file is downloaded into the `data-raw/` directory,
#' and its content is validated before updating the RDA file in the `data/` directory.
#'
#' @return Updates the `power_plant_data.rda` file in the `data/` directory.
#' @examples
#' \dontrun{
#'   # Update the dataset and the R object:
#'   update_power_plant_data()
#' }
#' @export
update_power_plant_data <- function() {
  data_raw_dir = "data-raw/"
  data_dir = "data/"
  # Chemin du fichier CSV dans data-raw
  csv_file <- file.path(data_raw_dir, "GlobalPowerPlantDB.csv")

  # Commande pour télécharger les données via Kaggle CLI
  kaggle_command <- sprintf(
    "kaggle datasets download -d dianaddx/global-power-plant-database -p %s --unzip",
    data_raw_dir
  )

  # Télécharger et mettre à jour les données
  system(kaggle_command, intern = TRUE)

  # Vérifier si le fichier CSV existe après téléchargement
  if (file.exists(csv_file)) {
    # Charger les nouvelles données
    new_data <- read.csv(csv_file)

    # Effectuer des vérifications ou nettoyages si nécessaire
    # Exemple : Vérification des colonnes clés
    required_columns <- c("country", "capacity_mw", "latitude", "longitude", "primary_fuel")
    if (!all(required_columns %in% colnames(new_data))) {
      stop("Les données téléchargées ne contiennent pas les colonnes nécessaires.")
    }

    # Sauvegarder en tant qu'objet R dans data/
    usethis::use_data(new_data, name = "power_plant_data", overwrite = TRUE, internal = FALSE)

    message("The data has been updated successfully.")
  } else {
    stop("Failed to download data. Please check the Kaggle command.")
  }
}

