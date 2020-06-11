ui <- navbarPage(
  "Drink DB",
  # This part controls the layout and content of the application

  # Tab 1, main page of the app
  tabPanel(
    title = "Home",
    # Header photo of cocktails
    fluidRow(tags$img(
      height = 438,
      width = 876,
      src = "mainpage.jpg"
    )),
    # New row with information about the application
    fluidRow(
      column(
        10,
        tags$h4("Welcome to Drink DB!")
      )
    ),
    fluidRow(column(
      10,
      tags$p("This app helps you to find drink recipes or learn more about common ingredients."),
      tags$p(tags$strong("Drink Generator"), "randomly generates a drink for you."),
      tags$p(tags$strong("Drink Search"), "helps you to search for drinks with dropdown menus so you do not have to worry about spelling (great for exploration too)."),
      tags$p(tags$strong("Ingredient Information"), "allows you to search for common ingredients and read about them.")
    ))
  ),

  # Tab 2, random generator of drinks
  tabPanel(
    title = "Drink Generator",
    tags$img(src = "drinkgenerator.jpeg"),
    tags$hr(),
    fluidRow(column(6, tags$p("Click the button to randomly generate a drink"))),
    fluidRow(column(6, actionButton(
      "rand_button",
      "Random Drink"
    ))),
    tags$hr(),
    fluidRow(column(6, tags$h3(textOutput("rand_title")))),
    fluidRow(
      column(
        6,
        tags$br(),
        htmlOutput("rand_img")
      ),
      column(5, DTOutput("rand_rec"))
    ),
    fluidRow(column(
      10,
      tags$p(textOutput("rand_ins"))
    ))
  ),

  # Tab 3, dropdown menus for drink search by letter and name:
  tabPanel(
    title = "Drink Search",
    tags$img(src = "drinksearch.png"),
    tags$br(),
    "Use the dropdown menus to search for drinks based on the first letter.",
    tags$hr(),
    selectInput("first_letter",
      "First Letter",
      choices = LETTERS[-c(24, 21)], # Letter U and X have no drinks
      selected = "a"
    ),
    selectInput("drink_choices",
      "Drinks",
      choices = c("none")
    ),
    actionButton("search_button", "Get Recipe"),
    tags$br(),
    tags$br(),
    htmlOutput("selected_img"),
    tags$br(),
    fluidRow(column(5, DTOutput("selected_rec"))),
    tags$br(),
    fluidRow(column(5, textOutput("instructions"))),
    tags$br(),
    tags$br()
  ),

  # Tab 4, search bar for ingredient information:
  tabPanel(
    title = "Ingredient Information",
    "Look up common ingredients and learn more about them. Examples: Vodka, Wine, Malibu or Lime",
    tags$hr(),
    textInput("ingredient",
      "Type an ingredient",
      value = ""
    ),
    actionButton("ingredient_button", "Search"),
    tags$br(),
    (tags$img(
      height = 283,
      width = 866,
      src = "ingredients.jpg"
    )),
    textOutput("ingredient_information")
  )
)
