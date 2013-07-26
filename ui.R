library(shiny)

## change this to TRUE to switch to no name version, change ui.R and server.R
private = FALSE


subjectNames <- read.csv("name_of_subjects.csv", header = FALSE, sep = ",")
nameList <- as.character(subjectNames$V1)

## this will be updated each time the script is updated
version = "(Development Version 6)"

# Define UI type
shinyUI(pageWithSidebar(
                                                                                
  # Application title
  headerPanel(paste("Activity Map with Clinical and Survey Data",
                    version,
                    collapse = NULL)
  ),

  # Side bar options
  sidebarPanel(
    
    ## set styles of sidebarPanel using HTML tags, use span4 & well width
    tags$head(
      tags$style(type = 'text/css', "#startTime { width: 80px; }"),
      tags$style(type = 'text/css', "#endTime { width: 80px; }"),
      tags$style(type = "text/css", "select {max-width: 200px;}"),
      tags$style(type = "text/css", "textarea {max-width: 200px;}"),
      tags$style(type = "text/css", ".jslider {max-width: 200px;}"),
      tags$style(type = "text/css", ".well {max-width: 250px;}"),
      tags$style(type = "text/css", ".span4 {max-width: 250px;}")
    ),
    
    conditionalPanel(
      condition = FALSE,
      checkboxInput("private", "No Name Displayed", value = private)
    ),
    
    # only update when this button is pressed
    # submitButton("Update Plots"),  
    
    conditionalPanel(
      condition = "$('li.active a').first().html() === 'Object Interactions' ",
      radioButtons("objPlotType",
                   "Plot type:",
                   list("By Subjects" = "bySubject",
                        "By Object Type" = "byType"
                   ),
                   selected = "By Subjects"
      )
    ),
    
    conditionalPanel(
      condition = "input.private == false",
      # check boxes for all 20 subjects, with avatar names
      checkboxGroupInput("subject", "Subjects:",  
                      c(nameList[1], 
                        nameList[2], 
                        nameList[3],
                        nameList[4],
                        nameList[5],
                        nameList[6],
                        nameList[7],
                        nameList[8],
                        nameList[9],
                        nameList[10],
                        nameList[11],
                        nameList[12],
                        nameList[13],
                        nameList[14],
                        nameList[15],
                        nameList[16],
                        nameList[17],
                        nameList[18],
                        nameList[19],
                        nameList[20]
                      ),
                      selected = NULL
      )
    ),
    
    conditionalPanel(
      condition = "input.private == true",
      # check boxes for all 20 subjects, with avatar names
      checkboxGroupInput("subjectNoName", "Subjects(Anonymous): ",  
                      c("S1", 
                        "S2", 
                        "S3",
                        "S4",
                        "S5",
                        "S6",
                        "S7",
                        "S8",
                        "S9",
                        "S10",
                        "S11",
                        "S12",
                        "S13",
                        "S14",
                        "S15",
                        "S16",
                        "S17",
                        "S18",
                        "S19",
                        "S20"
                      ),
                      selected = NULL
      )
    ),
    
    conditionalPanel(
      condition = TRUE,
      checkboxInput("checkAllSub", "All Subjects", value = FALSE)
    ),
    
    conditionalPanel(
      condition = "$('li.active a').first().html() === 'Conversations'",
      br(),
      selectInput("choiceConversation",
                  "Conversations during this period:", 
                  list("None"),
                  selected = "None"
      )
    ),
    
    # blank row
    br(),
    
    conditionalPanel(
      condition = "$('li.active a').first().html() === 'Object Interactions'",
      # options to display information needed
      checkboxInput("object",
                    "Display Object Interactions Frequency Count",
                    value=FALSE)
    ),
    
    conditionalPanel(
      condition = "$('li.active a').first().html() === 'Object Interactions'",
      # options to display information needed
      checkboxInput("objectType",
                    "Display Object Type Statistics",
                    value=FALSE),
      br()
    ),

    conditionalPanel(
      condition = "$('li.active a').first().html() !== 'Raw Data' &&
                   $('li.active a').first().html() !== 'Conversations'",
      radioButtons("timePeriod",
                   "Time Period type:",
                   list("By DayCount" = "dayCount",
                        "By Real Date" = "date"
                   ),
                   selected = "By DayCount"
      )
    ),
                    
    conditionalPanel( # choose periods by DayCount
      condition = "input.timePeriod == 'dayCount' && (
                   $('li.active a').first().html() !== 'Raw Data' &&
                   $('li.active a').first().html() !== 'Conversations' )",
      sliderInput("dayCountPeriod", "Time: DayCount Week #:",
                  min = 1, max = 26, value = c(1,1), step = 1
                 )
    ),
    
    conditionalPanel( # choose periods by Real Date
      condition = "(input.timePeriod == 'date' &&
                   $('li.active a').first().html() !== 'Raw Data') ||
                   ( $('li.active a').first().html() === 'Conversations' )",
      dateRangeInput("dateRange", "Date Range:",
                     start = "2011-01-01", end = "2011-01-01",
                     min = "2011-01-01", max = "2012-12-31",
                     format = "yyyy-mm-dd", startview = "year",
                     weekstart = 0, language = "en"
      ),
    
      textInput("startTime", "Start Time:", value = "HH:MM:SS"),
      textInput("endTime", "End Time:", value = "HH:MM:SS")
    ),
    
    ## checkboxInput("byDate", "Switch to Real Date", value=FALSE), 
    ## switched to radioButton, so above line unused
    
  
    ## I found a way to hide buttons when in the second tab,
    ## but buttons only reappear when user clicks "Update Plots"
    
    
    ## as of 07/09, I removed the submit button, making these options only
    ## visible when "Main Window" is displayed
    conditionalPanel(
      condition = "$('li.active a').first().html()==='Main Window'",
      
      br(),
      # optional weight plot
      checkboxInput("weightPlot", "Show Weight Plots", value=TRUE), 
      # optional HBA1C plot
      checkboxInput("HBA1CPlot", "Show HBA1C Plots", value=TRUE), 
      
      checkboxInput("surveyP", "Show Survey Score Plots", value=TRUE),
      
      # Legend is fixed to visible on 07/10
  
      # survey question plot drop-down list
      
      conditionalPanel(
        condition = "input.surveyP == true",
        selectInput("choiceToView",
                    "Choose Survey Topic:", 
               list("Perceived Usefulness", 
                    "Perceived Ease Of Use", 
                    "Diabetes Empowerment",
                    "Diabetes Support",
                    "Diet",
                    "Exercise",
                    "Blood Sugar Testing",
                    "Diabetic Foot Care",
                    "Diabetes Knowledge"),
                    selected="Perceived Usefulness"
        )
      )
    )       
  ),


## define output layout and type

  mainPanel(
    
    ## more HTML code to control size of mainPanel?
    # tags$head(
      # tags$style(type = "text/css", ".well {max-width: 1250px;}"),
      # tags$style(type = "text/css", ".span8 {max-width: 1250px;}")
    # ),
    
    tabsetPanel(
        
      # first tab
      tabPanel("Main Window",
        
        # dynamic title
        h4(textOutput("caption")),
       
        # set the width & height of Activity Map
        plotOutput("activityPlot", height = "850px", width = "850px"), 
           
        conditionalPanel( # optional weight plot
          condition = "input.weightPlot == true",
          plotOutput("weightPlot")
        ),
            
        conditionalPanel( # optional HBA1C plot
          condition = "input.HBA1CPlot == true",
          plotOutput("HBA1CPlot")
        ),
        
        # survey question plot
        conditionalPanel(
          condition = "input.surveyP == true",
          plotOutput("surveyPlot")
        ),
          
        plotOutput("legendForMain")
      ),
      
      # second tab, object interactions
      tabPanel("Object Interactions",
        
        h4(textOutput("captionObject")),
        
        plotOutput("objectHeatMap", height = "850px", width = "850px"),
        
        # objects interaction info
        conditionalPanel( 
          condition = "input.object == true",
          h4("Object Interaction Data (Frequency Count)"),
          verbatimTextOutput("objData"),
          br()
        ),
        
        conditionalPanel( 
          condition = "input.objectType == true",
          h4("Object Type (Frequency Count)"),
          verbatimTextOutput("objType"),
          br()
        ),
        
        plotOutput("legendForObject")
        
      ),
      
      # third tab, handling conversations
      tabPanel("Conversations",
      
        h4(textOutput("captionConversation")),
        
        plotOutput("conversationMap", height = "850px", width = "850px"),
        
        verbatimTextOutput("convData"),
        
        plotOutput("legendForConversation"),

        br()
      ),
      
      # Last tab, raw data if needed...
      tabPanel("Raw Data", 
        
        # options to display information needed
        conditionalPanel(
          condition = " input.private == true ",
          h3("In public mode, raw data hidden.")
        ),
        
        # options to display information needed
        conditionalPanel(
          condition = " input.private == false ",
          checkboxInput("clinical", "Show Raw Clinical Data", value=FALSE),
          checkboxInput("survey", "Show Raw Survey Data", value=FALSE)
        ),
        
        # raw clinical data
        conditionalPanel(
          condition = "input.clinical == true && input.private == false ",
          h4("Raw Clinical Data"),         
          verbatimTextOutput("clinData"),
          br()
        ),
        
        # raw survey score data
        conditionalPanel(
          condition = "input.survey == true && input.private == false ",
          h4("Raw Survey Data"),
          verbatimTextOutput("survData")
        )
      )    
    )
  )
))