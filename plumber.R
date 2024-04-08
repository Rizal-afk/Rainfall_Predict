#plumber.R
library(plumber)
library(jsonlite)


my_packages = c('C50')
install_if_missing = function(p) {
    if (p %in% rownames(installed.packages()) == FALSE) {
        install.packages(p, dependencies = TRUE)
    }else{
        cat(paste("Skipping already installed package:",p,"\n"))
    }
}
invisible(sapply(my_packages, install_if_missing))

modelc5 <- readRDS(file = 'c50_model.rds')
modelc5Wipso <- readRDS(file = 'c50_model+Wipso.rds')

#* @filter cors
cors <- function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  res$setHeader("Access-Control-Allow-Methods", "*")
  res$setHeader("Access-Control-Allow-Headers", "Content-Type")
  plumber::forward()
}

#* @get /
function() {
  list("Model C50 dan Wipso Curah Hujan ")
}

#' @post /C50_predict
function(req,res){
  req_data <- req$postBody
  req_json <- fromJSON(req_data)
  req_json[sapply(req_json, is.null)] <- NA
  new_data <- data.frame(
    suhuMin = req_json[["suhuMin"]],
    suhuMax = req_json[["suhuMax"]],
    suhuRatarata = req_json[["suhuRata"]],
    kelembapan = req_json[["kelembapan"]],
    lamanyaPenyinaran = req_json[["lamanyaPenyinaran"]],
    kecepatanAnginMax = req_json[["kecepatanAnginMax"]],
    arahAnginSaatKecepatanMax = req_json[["arahAnginmax"]],
    kecepatanAnginRatarata = req_json[["kecAngin"]]
  )
  prediction <- predict(modelc5,new_data)
  res$body <- toJSON(prediction)
  res$setHeader("Content-Type", "application/json")
  return(res)
}

#' @post /C50Wipso_predict
function(req,res){
  req_data <- req$postBody
  req_json <- fromJSON(req_data)
  req_json[sapply(req_json, is.null)] <- NA
  new_data <- data.frame(
    suhuMin = req_json[["suhuMin"]],
    suhuMax = req_json[["suhuMax"]],
    suhuRata = req_json[["suhuRata"]],
    kelembapan = req_json[["kelembapan"]],
    lamanyaPenyinaran = req_json[["lamanyaPenyinaran"]],
    kecepatanAnginMax = req_json[["kecepatanAnginMax"]],
    arahAnginSaatKecepatanMax = req_json[["arahAnginmax"]],
    kecepatanAnginRatarata = req_json[["kecAngin"]]
  )
  prediction <- predict(modelc5Wipso,new_data)
  res$body <- toJSON(prediction)
  res$setHeader("Content-Type", "application/json")
  return(res)
}