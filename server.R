server <- function(input, output, session) {
  # This part controls the interaction, modifly output based on user input

  #############
  ### Tab 2 ###
  #############

  # Corresponds to the Random Drink button
  rand_drink <- eventReactive(input$rand_button, {
    random_drink()
  })

  # Information about ingredients to be formatted in line 24
  rand_rec_table <- reactive({
    rand_drink()$ing
  })

  # Since each ingredient have the name, we only need to print the name one time.
  output$rand_title <- renderText({
    rand_rec_table()$strDrink[1]
  })

  # Formatting of the ingredient table
  output$rand_rec <- renderDataTable({
    rand_rec_table() %>%
      select(strIngredient, strMeasure) %>%
      filter(!strIngredient == "") %>%
      rename(
        Ingredient = strIngredient,
        Measurement = strMeasure
      ) %>%
      DT::datatable(
        rownames = FALSE,
        style = "bootstrap",
        options = list(
          iDisplayLength = 100,         # initial number of records
          aLengthMenu = c(5, 10),       # records/page options
          bLengthChange = 0,            # show/hide records per page dropdown
          bFilter = 0,                  # global search box on/off
          bInfo = 0                     # information on/off
        )
      ) %>%
      formatStyle("Ingredient",
        target = "row",
        backgroundColor = "#f2f2f2"
      )
  })

  # Takes the randomly generated drink and search the API for the photo
  output$rand_img <- renderUI({
    drink <- rand_rec_table()$strDrink[1]

    search_pic <- fromJSON(
      str_glue("https://www.thecocktaildb.com/api/json/v1/1/search.php?s={name}",
        name = URLencode(drink)
      )
    )

    tags$img(
      src = search_pic$drinks$strDrinkThumb[1],
      width = "300"
    )
  })

  # Output the instructions for the randomly generated drink
  output$rand_ins <- renderText({
    rand_drink()$ins
  })


  #############
  ### Tab 3 ###
  #############

  # Search for drinks in the API based on the first letter which is chosen in a dropdown
  letter_results <- reactive({
    search1 <- str_glue("https://www.thecocktaildb.com/api/json/v1/1/search.php?f={name}",
      name = URLencode(input$first_letter)
    )

    fromJSON(search1)$drinks
  })

  # Updates the second dropdown with the drink names based on what letter is choosen
  observe({
    updateSelectInput(session,
      "drink_choices",
      choices = sort(letter_results()$strDrink)
    )
  })

  # When the user press the Get Recipe button eventReactive pulls out the id for accuracy and send it to the function selected_drink()
  drink_search <- eventReactive(input$search_button, {
    drinkID <- letter_results() %>%
      filter(strDrink == input$drink_choices) %>%
      pull(idDrink)

    selected_drink(drink_choice = drinkID)
  })

  # Instructions for the drink the user decided in the dropdown
  output$instructions <- renderText({
    drink_search()$ins
  })

  # Format of the ingredient table for the drink the user decided in the dropdown
  output$selected_rec <- renderDataTable({
    drink_search()$ing %>%
      select(strIngredient, strMeasure) %>%
      filter(!strIngredient == "") %>%
      rename(
        Ingredient = strIngredient,
        Measurement = strMeasure
      ) %>%
      DT::datatable(
        rownames = FALSE,
        style = "bootstrap",
        options = list(
          iDisplayLength = 100, # Initial number of records
          aLengthMenu = c(5, 10), # Records/page options
          bLengthChange = 0, # Show/hide records per page dropdown
          bFilter = 0, # Global search box on/off
          bInfo = 0 # Information on/off
        )
      ) %>%
      formatStyle("Ingredient",
        target = "row",
        backgroundColor = "#f2f2f2"
      )
  })

  # Take the id of the chosen drink and use the API to get a picture of the drink
  selected_img <- eventReactive(input$search_button, {
    drinkID <- letter_results() %>%
      filter(strDrink == input$drink_choices) %>%
      pull(idDrink)

    search_pic <- fromJSON(
      str_glue("https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i={name}",
        name = URLencode(drinkID)
      )
    )
    search_pic$drinks$strDrinkThumb[1]
  })

  # Output of the drink picture found in line 116
  output$selected_img <- renderUI({
    tags$img(
      src = selected_img(),
      width = "350"
    )
  })


  #############
  ### Tab 4 ###
  #############

  # When the user search for an ingredient and click the Search button
  # This key find the ingredient even if the user do not type the full name
  # It gives an error if user type more, for example limeo instead of lime
  ingredient_search <- eventReactive(input$ingredient_button, {
    ingredient <- str_glue("https://www.thecocktaildb.com/api/json/v1/1/search.php?i={ingredient}",
      ingredient = URLencode(input$ingredient) # Based on user input
    )

    ingredient_search <- fromJSON(ingredient)
    ing_des <- ingredient_search$ingredients$strDescription

    # Prints error message if ingredient is spelled wrong or does not exist
    if (is.null(ing_des)) {
      return("The ingredient may not exist in the database, is there a chance that you spelled it wrong?")
    } else {
      return(ing_des)
    }
  })

  # Print out the ingredient information the user searched for or error message
  output$ingredient_information <- renderText({
    ingredient_search()
  })
}
