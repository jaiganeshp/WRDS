#rm(list=ls())

#Change default library path
#.libPaths(c("c:/work/R/Lib",.libPaths()))

#Load necessary packages
#library(proto)
#library(gsubfn)
#library(chron)
#library(RSQLite)
#library(RSQLite.extfuns)
#library(sqldf)
#library(reshape)

#.dbFileName="C:/Tree/GitHub/WRDS/inst/extdata/Cqa.sqlite"


#Global variables
.dbFileName = system.file("extdata", "Cqa.sqlite", package="WRDS")
.tblCrsp ="dow30CRSP" 
.tblCompu="dow30Compustatlink"
.tblSector="sector"
.tblCompuFac =  "dow30compustat"

# ################################################################################
# #Fires the given query against database and returns all rows.
# ################################################################################
selectDb <- function(query)
{
  #Connect to database, this looks for a file in your working directory (getwd())
  db.Connection <- dbConnect(SQLite(), dbname=.dbFileName)
  
  #Get records from database
  result.sql <- dbSendQuery(conn = db.Connection,query)
  result.rows <- fetch(result.sql,n=-1)
  
  #Cleanup
  dbClearResult(result.sql)
  
  #Close out any open connection
  dbDisconnect(db.Connection) 
  
  #return records to the caller
  result.rows
}

####Time Series Return Query##########
getReturnTimeSeriesQuery <- function()
{
  return.query <- paste("select distinct c.[date],c.[TICKER],c.[RET] 
                        from",.tblCrsp,
                        "as c where c.[RET] !=0 order by c.[date]")
  strwrap(return.query, width=10000, simplify=TRUE)  
}


####Function to get the time series return using query##########
getReturnTimeSeries <- function()
{
  return.query <- getReturnTimeSeriesQuery()
  selectDb(return.query)  
}

#####Function to Returns as a table of TICKER's##########
getReturnPivot <- function()
{
  return.rows <- getReturnTimeSeries()
  cast(return.rows, date ~ TICKER,value='RET')  
}

####Query to Get FundamentalData From Compustatlink Table#########
getFundamentalReturnQuery <- function()
{
  funda.query <- paste("select s.gvkey,s.permno as PERMNO,s.[PERMCO],c.[CUSIP],
                        c.[TICKER] as TICKER,s.NAME,c.[RET] as [RETURN],s.[GSECTOR],
                        sec.[Sector] ,s.[MarketCap],s.[EntValue],s.[P2B],
                        s.[EV2S],s.[EV2OIBDA],s.datadate as CompuDate,c.[date] 
                        as CrspDate
                        from  ",.tblCrsp,"c inner join ",.tblCompu, 
                        "s on c.[permno]=s.[permno] and c.[permco]=s.[permco]  
                        inner join ",.tblSector,
                        "sec on sec.[GSECTOR] = s.[GSECTOR] 
                        where  c.[date] <= s.[datadate] and
                        julianday(date(substr(s.datadate,1,4)||'-'||
                        substr(s.datadate,6,2) ||'-'||'01')) 
                        - julianday(date(substr(c.date,1,4)||'-'||
                       substr(c.date,6,2) ||'-'||'01')) <= 62 
                       group by s.gvkey,s.permno,s.[PERMCO],c.[CUSIP],
                       c.[TICKER],s.NAME,c.[RET],s.[GSECTOR],sec.[Sector] ,
                      s.[MarketCap],s.[EntValue],s.[P2B],s.[EV2S],s.[EV2OIBDA],
                      s.datadate,c.[date]")
  strwrap(funda.query, width=10000, simplify=TRUE)  
}


####Query to Get Additional FundamentalData From Compustatlink Table#########
getadditionalFundamentalReturnQuery <- function()
{
  funda.addquery <- paste("select s.gvkey,s.permno as PERMNO,s.[PERMCO],c.[CUSIP]
                      , c.[TICKER] as TICKER,s.NAME,c.[RET] as [RETURN],
                      s.[GSECTOR], sec.[Sector] ,s.[MarketCap],s.[EntValue],
                      s.[P2B], s.[EV2S],s.[EV2OIBDA],(4* cp.OIBDPQ)/(cp.Cshoq * cp.PrccQ)  AS 'EG2P'
                      ,(cp.Cshoq * cp.PrccQ + cp.DLCQ + cp.DLTTQ - cp.CHEQ) / (4 * cp.saleq) As 'EV2S'
                      ,(4* cp.OIBDPQ)/(cp.Cshoq * cp.PrccQ + cp.DLCQ + cp.DLTTQ - cp.CHEQ)  AS 'EG2V'
                      ,s.datadate as CompuDate,c.[date] as CrspDate 
                      from",.tblCrsp, "c inner join", .tblCompu," s
                      on c.[permno]=s.[permno] and c.[permco]=s.[permco] 
                      inner join",.tblSector, "sec on sec.[GSECTOR] = s.[GSECTOR] 
                      left join", .tblCompuFac, "cp on cp.lpermno = s.permno 
                      and cp.datadate = s.datadate where c.[date] <= s.[datadate] and 
                      julianday(date(substr(s.datadate,1,4)||'-'|| substr(s.datadate,6,2) ||'-'||'01')) 
                      - julianday(date(substr(c.date,1,4)||'-'|| substr(c.date,6,2) ||'-'||'01')) <= 62 
                      group by s.gvkey,s.permno,s.[PERMCO],c.[CUSIP], c.[TICKER],
                      s.NAME,c.[RET],s.[GSECTOR],sec.[Sector] , s.[MarketCap],s.[EntValue]
                      ,s.[P2B],s.[EV2S],s.[EV2OIBDA], s.datadate,c.[date]")
  strwrap(funda.addquery, width=10000, simplify=TRUE)  
}


############Function to get Fundamental Data############
getFundamentalReturn <- function()
{
  funda.query <- getFundamentalReturnQuery()
  funda.return <-selectDb(funda.query)  
  funda.return[order(funda.return[,"TICKER"],funda.return[,"CrspDate"]),]
}

############Function to get Addtional Fundamental Data############
getadditionalFundamentalReturn <- function()
{
  funda.addquery <- getadditionalFundamentalReturnQuery()
  funda.return<-selectDb(funda.addquery)  
  funda.return[order(funda.return[,"TICKER"],funda.return[,"CrspDate"]),]
}


head(getFundamentalReturn())
head(getadditionalFundamentalReturn())

########Align the fundamental data############
getFundamental.aligned<-function()
{
  funda.return <- getFundamentalReturn() 
  funda.return[,"CompuDate"] <- as.Date(funda.return[,"CompuDate"])
  for(i in 1:length(funda.return[,"CompuDate"])){    
    if(as.integer(substr(funda.return[i,"CompuDate"],6,7))%%3 != 0){
      if(as.integer(substr(funda.return[i,"CompuDate"],6,7)) ==
           as.integer(substr(funda.return[i,"CrspDate"],6,7))){
        funda.return[i,"CompuDate"]=        
          as.Date(as.yearmon(as.Date(funda.return[i,"CompuDate"]))+ 2/12, frac = 1)    
      }
      else{
        funda.return[i,"CompuDate"]=        
          as.Date(as.yearmon(as.Date(funda.return[i,"CompuDate"]))- 1/12, frac = 1)    
      }
    }
  }
  funda.return[order(funda.return[,"TICKER"],funda.return[,"CrspDate"]),]
}


#########Align the additional fundamental data############
getadditionalFundamental.aligned<-function()
{
  funda.return <- getadditionalFundamentalReturn() 
  funda.return[,"CompuDate"] <- as.Date(funda.return[,"CompuDate"])
  for(i in 1:length(funda.return[,"CompuDate"])){    
    if(as.integer(substr(funda.return[i,"CompuDate"],6,7))%%3 != 0){
      if(as.integer(substr(funda.return[i,"CompuDate"],6,7)) ==
           as.integer(substr(funda.return[i,"CrspDate"],6,7))){
        funda.return[i,"CompuDate"]=        
          as.Date(as.yearmon(as.Date(funda.return[i,"CompuDate"]))+ 2/12, frac = 1)    
      }
      else{
        funda.return[i,"CompuDate"]=        
          as.Date(as.yearmon(as.Date(funda.return[i,"CompuDate"]))- 1/12, frac = 1)    
      }
    }
  }
  funda.return[order(funda.return[,"TICKER"],funda.return[,"CrspDate"]),]
}


############Get Fundamental Data Quarterly############
getFundamental.QuarterlyReturn<-function()
{
  funda.return<-getFundamental.aligned()          
  funda.quarter<- ddply(funda.return, .(gvkey,CompuDate,PERMNO,PERMCO, CUSIP, TICKER)
                        ,summarise, quarterly.return = prod(1+RETURN)-1, data.count = length(RETURN))
  funda.quarter[funda.quarter[,"data.count"]>2,c("gvkey","CompuDate","PERMNO",
                                                 "PERMCO", "CUSIP", "TICKER","quarterly.return")]  
}


############Get Additional Fundamental Data Quarterly############
getadditionalFundamental.QuarterlyReturn<-function()
{
  funda.return<-getadditionalFundamental.aligned()          
  funda.quarter<- ddply(funda.return, .(gvkey,CompuDate,PERMNO,PERMCO, CUSIP, TICKER)
                        ,summarise, quarterly.return = prod(1+RETURN)-1, data.count = length(RETURN))
  funda.quarter[funda.quarter[,"data.count"]>2,c("gvkey","CompuDate","PERMNO",
                                                 "PERMCO", "CUSIP", "TICKER","quarterly.return")]  
}


#Testing methods


# library(WRDS)
# library(plyr)
# library(zoo)

#Get combined data(fundamental from Compustat+returns from CRSP)





