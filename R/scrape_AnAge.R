#' Extracting life history data from the AnAge database
#'
#' An R wrapper to access life history data from AnAge (http://genomics.senescence.info/species/)
#' for one or multiple species.
#'
#' @param latin_name latin name of the species. Can be a string "Felis catus" or a vector with
#'                   multiple species c("Felis catus", "Bos taurus"). The default separator is " ",
#'                   but others can be chosen, see below. Should be case insensitive.
#'
#' @param vars       vector of variables to extract for the species. Example:
#'                    c("maximum_lovevity_yrs", "female_matury_days"). \cr
#'                    Options are: \cr
#'                   "maximum_longevity_yrs" \cr
#'                   "female_maturity_days"  \cr
#'                   "male_maturity_days"    \cr
#'                   "gestation_incubation_days" - duration of either gestation or incubation in days \cr
#'                   "weaning_days" \cr
#'                   "litter_clutch_size" - size of either litter or clutch \cr
#'                   \cr
#'                   To see all options, check data(AnAge_variables)
#' @param name_sep   separator between genus and species in latin_name. Default is " ", as in "Felis catus".
#' @param download_data Data has to be downloaded at least once and is by default
#'                      saved into the working directory. For each subsequent call, download_data can be set to FALSE,
#'                      except for when you want to update the datafile.
#' @param file_path  Name and path of file. Make sure to keep it as a .zip. Defaults to
#'                   "life_history_data.zip", thus saving it into the working directory or looking
#'                   for it in the working directory when download_data = FALSE.
#'
#' @references
#' Tacutu, R., Thornton, D., Johnson, E., Budovsky, A., Barardo, D., Craig, T., Diana, E.,
#' Lehmann, G., Toren, D., Wang, J., Fraifeld, V. E., de Magalhaes, J. P. (2018)
#' \emph{Human Ageing Genomic Resources: new and updated databases.}. Nucleic Acids Research 46(D1):D1083-D1090.
#'
#' @author Martin Stoffel (martin.adam.stoffel@@gmail.com)
#'
#' @examples
#'
#' dat <- scrape_AnAge(latin_name = c("felis catus"),
#'                     vars = c("maximum_longevity_yrs","female_maturity_days"))
#' dat
#'
#' # For multiple species. Now download_data = FALSE, as data has been
#' # downloaded already in the example above.
#'
#' species <- c("felis catus", "Sterna paradisaea")
#' dat <- scrape_AnAge(latin_name = species,
#'                     vars = c("maximum_longevity_yrs","female_maturity_days"),
#'                     download_data = FALSE)
#' dat
#'
#' @import dplyr stringr
#'
#'
#'
#' @export

scrape_AnAge <- function(latin_name = NULL,  vars = NULL, name_sep = " ",
                         download_data = TRUE, file_path = "life_history_data.zip") {

    if (download_data) {
        url <- "http://genomics.senescence.info/species/dataset.zip"
        utils::download.file(url, file_path) # download file
    }

    suppressMessages(dat <- readr::read_delim(file_path, delim = "\t", col_types = readr::cols(.default = "c")))

    new_names <- stringr::str_replace_all(names(dat), " \\(days\\)", "_days") %>%
        stringr::str_replace(" \\(g\\)", "_g") %>%
        stringr::str_replace(" \\(yrs\\)", "_yrs") %>%
        stringr::str_replace(" \\(W\\)", "_w") %>%
        stringr::str_replace(" \\(K\\)", "_k") %>%
        stringr::str_replace(" \\(per yr\\)", "_per_year") %>%
        stringr::str_replace(" \\(1/days\\)", "_1_days") %>%
        stringr::str_replace("/", "_") %>%
        stringr::str_replace("-", "") %>%
        stringr::str_replace(" ", "_") %>%
        tolower()

    names(dat) <- new_names

    # vectorised
    species_name <- tolower(latin_name)

    # species_name_enquo <- dplyr::enquo(species_name)
    traits <- dplyr::enquo(vars)

    test <- dat %>%
        tidyr::unite(genus, species, col = "genus_species", sep = name_sep) %>%
        dplyr::mutate(genus_species = tolower(genus_species))

    # species_available <- species_name %in% test$genus_species
    # if (any(!species_available)){
    #     which_species_not <- species_name[!species_available]
    #
    # }
    #
    # which(stringdist(species_name, test$genus_species) < 5)
    #
    dat_full <- tibble(species_latin = species_name)

    dat_out <- dat %>%
        tidyr::unite(genus, species, col = "genus_species", sep = name_sep) %>%
        dplyr::mutate(genus_species = tolower(genus_species)) %>%
        dplyr::filter(genus_species %in% species_name) %>%
        dplyr::select(genus_species, !!traits) %>%
        dplyr::rename(species_latin = genus_species)

    if (nrow(dat_out) < length(species_name)) {
        dat_out <- dplyr::full_join(dat_full, dat_out , by = "species_latin")
    }

    dat_out

    # dat %>%
    #         tidyr::unite(genus, species, col = "genus_species", sep = name_sep) %>%
    #         dplyr::mutate(genus_species = tolower(genus_species)) %>%
    #         dplyr::filter(genus_species %in% species_name) %>%
    #         dplyr::select(genus_species, !!vars)


}

