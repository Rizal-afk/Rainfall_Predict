# start from the rocker/r-ver:3.5.0 image
FROM rstudio/plumber

# Install required R packages
RUN R -e "install.packages('plumber')"
RUN R -e "install.packages('jsonlite')"
RUN R -e "install.packages('C50')"
RUN R -e "install.packages('libcoin')"
RUN R -e "install.packages('libPath')"

# copy everything from the current directory into the container
COPY / /

# open port 80 to traffic
EXPOSE 80

# when the container starts, start the main.R script
ENTRYPOINT ["Rscript", "plumber.R"]