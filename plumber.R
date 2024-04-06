# plumber.R

# Load necessary libraries
library(plumber)

# Define API endpoint
#* @get /echo
function(){
  list(msg = "Hello, world!")
}

# Create Plumber router
pr <- plumb("plumber.R")

# Run the API
pr$run(port=process.env.PORT)
