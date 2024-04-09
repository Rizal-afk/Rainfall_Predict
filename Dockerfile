# Use the official R base image
FROM rocker/r-ver:4.1.2

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev

# Install R packages
RUN R -e "install.packages(c('plumber', 'jsonlite', 'C50', 'RJSONIO'), repos='https://cloud.r-project.org/')"

# Copy Plumber API code into the container
COPY plumber.R /app/plumber.R

# Copy c50_model.rds file into the container
COPY c50_model.rds /app/c50_model.rds

# Copy c50Wipso_model.rds file into the container
COPY c50Wipso_model.rds /app/c50Wipso_model.rds

# Set working directory
WORKDIR /app

# Expose port
EXPOSE $PORT

# Command to run the plumber API
CMD ["R", "-e", "pr <- plumber::plumb('plumber.R'); pr$run(host='0.0.0.0', port=as.numeric(Sys.getenv('PORT')))"]
