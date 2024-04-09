#plumber.R
library(plumber)
library(jsonlite)
library(C50)
library(RJSONIO)

modelc5 <- readRDS('c50_model.rds')
modelc5Wipso <- readRDS('c50Wipso_model.rds')

#' @filter cors
cors <- function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  
  if (req$REQUEST_METHOD == "OPTIONS") {
    res$setHeader("Access-Control-Allow-Methods","*")
    res$setHeader("Access-Control-Allow-Headers", req$HTTP_ACCESS_CONTROL_REQUEST_HEADERS)
    res$status <- 200 
    return(list())
  } else {
    plumber::forward()
  }
  
}

#* @apiTitle RainfallPredict API

#' @get /
#' @serializer print
function(){
  list('Weather Predictor Model')
}

#' @post /C50_predict
#' @serializer print
function(req,res){
  req_data <- req$postBody
  req_json <- fromJSON(req_data, nullValue=NA)
  print(req_json)
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
#' @serializer print
function(req,res){
  req_data <- req$postBody
  req_json <- fromJSON(req_data, nullValue=NA)
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
