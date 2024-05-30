message('Loading Packages')
library(rvest)
library(tidyverse)
library(mongolite)

message('Scraping Data')
url <- "https://id.jooble.org/lowongan-kerja/Depok/"
page <- read_html(url)

titles <- page %>% html_nodes(xpath = '//h2[@class="sXM9Eq PkepBU"]') %>% html_text()
gaji <- page %>% html_nodes(xpath = '//p[@class="W3cvaC"]') %>% html_text()
deskripsi <- page %>% html_nodes(xpath = '//div[@class="PAM72f"]') %>% html_text()
perusahaan <- page %>% html_nodes(xpath = '//div[@class="heru4z"]') %>% html_text()
alamat<- page %>% html_nodes(xpath = '//div[@class="caption NTRJBV"]') %>% html_text()


data <- data.frame(
  time_scraped = Sys.time(),
  titles = head(titles, 5),
  gaji = head(gaji, 5),
  deskripsi = head(deskripsi, 5),
  perusahaan = head(perusahaan,5),
  alamat = head(alamat,5),
  stringsAsFactors = FALSE
)
View(data)

# MONGODB
message('Input Data to MongoDB Atlas')
atlas_conn <- mongo(
  collection = Sys.getenv("ATLAS_COLLECTION"),
  db         = Sys.getenv("ATLAS_DB"),
  url        = Sys.getenv("ATLAS_URL")
)

atlas_conn$insert(data)
rm(atlas_conn)