fluidPage(
  numericInput(inputId = "cutoff",
               "Survival Cut-off",
               value=0.38,
               min=0.00,
               max=1.00,
               step=0.01),
  dataTableOutput(outputId = 'tab')
)