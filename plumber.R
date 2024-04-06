#plumber.R
library(plumber)
library(jsonlite)
library(RJSONIO)
library(C50)

options("plumber.port" = 8080)

modelc5 <- readRDS(file = 'c50_model.rds')
modelc5Wipso <- readRDS(file = 'c50_model+Wipso.rds')

#* @filter cors
cors <- function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  res$setHeader("Access-Control-Allow-Methods", "*")
  res$setHeader("Access-Control-Allow-Headers", "Content-Type")
  plumber::forward()
}

#* @apiTitle API de clasificacion de flores
#* @param suhu_min
#* @param suhu_max
#* @param suhu_rata
#* @param kelembapan
#* @param lama_penyinaran
#* @param kec_max
#* @param arah_max
#* @param kec_rata
#' @post /predict
#' @serializer print
function(suhu_min,suhu_max,suhu_rata,kelembapan,lama_penyinaran,kec_max,arah_max,kec_rata){
  test = c(suhu_min,suhu_max,suhu_rata,kelembapan,lama_penyinaran,kec_max,arah_max,kec_rata)
  test = sapply(test, as.numeric)
  test = data.frame(matrix(test, ncol = 8))
  
  colnames(test) = colnames(dataTest[,2:9])
  predict(modelc5, test)
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
  print(new_data)
  prediction <- predict(modelc5,new_data)
  res$body <- toJSON(prediction)
  res$setHeader("Content-Type", "application/json")
  print(res$body)
  return(res)
}

#' @post /C50Wipso_predict
#' @serializer print
function(req,res){
  req_data <- req$postBody
  req_json <- fromJSON(req_data, nullValue=NA)
  print(req_json)
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
  print(new_data)
  prediction <- predict(modelc5Wipso,new_data)
  res$body <- toJSON(prediction)
  res$setHeader("Content-Type", "application/json")
  print(res$body)
  return(res)
}