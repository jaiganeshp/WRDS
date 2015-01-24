# library(WRDS)
# library(plyr)
# library(zoo)
# 
# funda.return.alined<-getFundamental.aligned()
# 
# funda.return <- getFundamentalReturn() 
# 
# 
# qreturn<-getFundamental.QuarterlyReturn()
# 
# qreturn.alinged<- getadditionalFundamental.aligned()
# 
# head(funda.return)
# head(qreturn.alinged)
# 
# funda.quarter<- ddply(funda.return, .(gvkey,CompuDate,PERMNO,PERMCO, CUSIP, TICKER)
#                       ,summarise, quaterly.return = prod(1+RETURN)-1)
# 
# funda.return[,"CompuDate"]= as.Date(funda.return[,"CompuDate"])
# 
# # msft<-funda.return[funda.return[,"TICKER"]=="MSFT",]
# # msftq<-funda.quarter[funda.quarter[,"TICKER"]=="MSFT",]
# 
# # cd<-data.frame(funda.return[funda.return[,"TICKER"]=="MSFT","CompuDate"])
# # colnames(cd)<-"Date"
# # head(cd)
# # cc<-count(cd)#[,"freq"]
# # 1%%3
# # i=2737
# 
# for(i in 1:length(funda.return[,"CompuDate"])){
#   if(as.integer(substr(funda.return[i,"CompuDate"],6,7))%%3 != 0){
#     funda.return[i,"CompuDate"]=        
#       as.Date(as.yearmon(as.Date(funda.return[i,"CompuDate"]))- 1/12, frac = 1)    
#   }
# }
# 
# 
# unique(substr(funda.return[,"CompuDate"],6,7))
# 
# funda.quarter <- data.frame(funda.quarter, month = substr(funda.quarter[,"CompuDate"],6,7))
# 
# 
# hwp<-funda.return[funda.return[,"TICKER"]=="HWP",]
# 
# head(funda.quarter)
# unique(substr(funda.return[,"CompuDate"],6,7))
# 
# head(funda.quarter[order(funda.quarter[,"PERMNO"]),])
# 
# prod(1+funda.return[1:3,"RETURN"]) - 1
# 
# 
# #GetTimeSeries data(returns for all stocks)
# pivot.return<-getReturnPivot()
# head(pivot.return)
# 
# write.csv(qreturn, "q.csv")
# write.csv(funda.return, "m1.csv")
# write.csv(funda.returna, "m.csv")
