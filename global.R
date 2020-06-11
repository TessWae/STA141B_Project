# Global loads in the libraries and two functions that formats the recipes

library(tidyverse)
library(DT)
library(jsonlite)

# Function that generates a random drink from the API and format and filter
# for the information we want.
# For example, random$drinks has 53 columns such as instructions in german.

random_drink <- function() {
  random <- fromJSON("https://www.thecocktaildb.com/api/json/v1/1/random.php")

  random_drink <- random$drinks

  ing <- random_drink %>%
    pivot_longer(3:ncol(.)) %>%
    filter(!is.na(value)) %>%
    mutate(ingID = str_sub(name, -1, -1)) %>%
    mutate(name = str_remove(name, "[1-9]")) %>%
    filter(name %in% c("strIngredient", "strMeasure")) %>%
    pivot_wider(names_from = "name", values_from = "value") %>%
    select(-ingID)

  list(
    ing = ing,
    ins = random_drink$strInstructions
  )
}

# Function that search for a drink based on id for accuracy from the API when the user choose
# a drink from the dropdown.
# Then format and filter for the information we want because there is 53 columns.

selected_drink <- function(drink_choice) {
  search <- str_glue("https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i={name}",
    name = URLencode(drink_choice) # This part connects the search with Shiny
  )

  drink_search <- fromJSON(search)

  chosen_drink <- drink_search$drinks

  ing <- chosen_drink %>%
    pivot_longer(3:ncol(.)) %>%
    filter(!is.na(value)) %>%
    mutate(ingID = str_sub(name, -1, -1)) %>%
    mutate(name = str_remove(name, "[1-9]")) %>%
    filter(name %in% c("strIngredient", "strMeasure")) %>%
    pivot_wider(names_from = "name", values_from = "value") %>%
    select(-ingID)

  list(
    ing = ing,
    ins = chosen_drink$strInstructions
  )
}