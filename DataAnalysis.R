library(jsonlite)
library(dplyr)
library(knitr)

Salary104 <- fromJSON("104_Salary(Education).json")
Salary107 <- fromJSON("107_Salary(Education).json")
Salary104$大職業別 <- gsub("、|_| ","",Salary104$大職業別)
Salary107$大職業別 <- gsub("、|_| ","",Salary107$大職業別)
Salary104$大職業別 <- gsub("部門","",Salary104$大職業別)
Salary104$大職業別 <- gsub("教育服務業","教育業",Salary104$大職業別)
Salary104$大職業別 <- gsub("醫療保健服務業","醫療保健業",Salary104$大職業別)
Salary104$大職業別 <- gsub("營造業","營建工程",Salary104$大職業別)
Salary104$大職業別 <- gsub("資訊及通訊傳播業","出版影音製作傳播及資通訊服務業",Salary104$大職業別)

Salary104107 <- inner_join(Salary104,Salary107,by="大職業別")

Salary104107$`大學-薪資.x` <- gsub("…|—","",Salary104107$`大學-薪資.x`)
Salary104107$`大學-薪資.y` <- gsub("…|—","",Salary104107$`大學-薪資.y`)
Salary104107$`大學-薪資.x` <- as.numeric(Salary104107$`大學-薪資.x`)
Salary104107$`大學-薪資.y` <- as.numeric(Salary104107$`大學-薪資.y`)

Salary104107$SalaryRate <- Salary104107$`大學-薪資.y`/Salary104107$`大學-薪資.x`
Salary104107 %>%
  arrange(desc(SalaryRate)) %>% 
  head(10) %>%
  kable()

HighSalaryRate<-
  filter(Salary104107,SalaryRate>1.05) %>% 
  select(大職業別)
kable(HighSalaryRate)

strsplit(HighSalaryRate$大職業別,'-') %>%
  lapply("[",1) %>%
  unlist() %>%
  table() %>%
  kable()

Salary104$`大學-女/男` <- gsub("—|…","",Salary104$`大學-女/男`)
Salary107$`大學-女/男` <- gsub("—|…","",Salary107$`大學-女/男`)
Salary104$`大學-女/男` <- as.numeric(Salary104$`大學-女/男`)
Salary107$`大學-女/男` <- as.numeric(Salary107$`大學-女/男`)

Salary104 %>% 
  arrange(`大學-女/男`) %>% 
  head(10)%>%
  kable()
Salary107 %>% 
  arrange(`大學-女/男`) %>% 
  head(10) %>%
  kable()

Salary104 %>% 
  arrange(desc(`大學-女/男`)) %>% 
  head(10) %>%
  kable()
Salary107 %>% 
  arrange(desc(`大學-女/男`)) %>% 
  head(10) %>%
  kable()

Salary107$`大學-薪資` <- gsub("—|…","",Salary107$`大學-薪資`)
Salary107$`研究所-薪資` <- gsub("—|…","",Salary107$`研究所-薪資`)
Salary107$`大學-薪資` <- as.numeric(Salary107$`大學-薪資`)
Salary107$`研究所-薪資` <- as.numeric(Salary107$`研究所-薪資`)

Salary107$SalaryCollegeGraduteRate <- Salary107$`研究所-薪資`/Salary107$`大學-薪資` 
Salary107 %>%
  arrange(desc(SalaryCollegeGraduteRate)) %>% 
  head(10) %>%
  kable()

Salary107 %>%
  filter(Salary107$大職業別%in%
           c('出版影音製作傳播及資通訊服務業-專業人員',
             '出版影音製作傳播及資通訊服務業-技術員及助理專業人員',
             '出版影音製作傳播及資通訊服務業-事務支援人員',
             '專業科學及技術服務業-專業人員',
             '教育業-專業人員')) %>%
  select(大職業別,`大學-薪資`,`研究所-薪資`) %>%
  kable()

Salary107 %>%
  mutate(SubtractSalary=`研究所-薪資`-`大學-薪資`) %>%
  filter(Salary107$大職業別%in%
           c('出版影音製作傳播及資通訊服務業-專業人員',
             '出版影音製作傳播及資通訊服務業-技術員及助理專業人員',
             '出版影音製作傳播及資通訊服務業-事務支援人員',
             '專業科學及技術服務業-專業人員',
             '教育業-專業人員')) %>%
  select(大職業別,`大學-薪資`,`研究所-薪資`,SubtractSalary) %>%
  kable()
