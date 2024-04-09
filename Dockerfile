# Use an R base image
FROM rocker/r-ver:4.1.1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev

# Install R packages
RUN R -e "install.packages(c('plumber', 'jsonlite', 'C50'))"

# Copy your Plumber API file into the container
COPY plumber.R /app/plumber.R

# Set the working directory
WORKDIR /app

# Expose the port your Plumber API listens on
EXPOSE 8000

# Command to run the Plumber API
CMD ["R", "-e", "pr <- plumber::plumb('plumber.R'); pr$run(host='0.0.0.0', port=8000)"]
