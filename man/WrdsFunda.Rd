\name{WrdsFunda-helpers}

\alias{WrdsFunda-helpers}
\alias{getReturnTimeSeriesQuery}
\alias{getReturnTimeSeries}
\alias{getReturnPivot}
\alias{getFundamentalReturnQuery}
\alias{getFundamentalReturn}
\alias{getadditionalFundamentalReturn}
\alias{getFundamental.aligned}
\alias{getadditionalFundamental.aligned}
\alias{getFundamental.QuarterlyReturn}
\alias{getadditionalFundamental.QuarterlyReturn}

\title{
    Accessing merge data from CRSP and COMPUSTAT
}
\description{
    Acceessing merge data from CRSP and COMPUSTAT
}
\usage{
    getReturnTimeSeriesQuery()
    getReturnTimeSeries()
    getReturnPivot()
    getFundamentalReturnQuery()
    getFundamentalReturn()
    getadditionalFundamentalReturn()
    getFundamental.aligned()
    getadditionalFundamental.aligned()
    getFundamental.QuarterlyReturn()
    getadditionalFundamental.QuarterlyReturn()
}
\details{
    \code{getReturnTimeSeriesQuery}:
    Returns a query in form of a string
    
    \code{getReturnTimeSeries}:
    Executes the query against the database and returns the rows
    
    \code{getReturnPivot}:
    Converts the data into timeseries of ticker values

    \code{getFundamentalReturnQuery}:
    Returns a query in form of a string
    
    \code{getFundamentalReturn}:
    Executes the query against the database and returns the rows    

    \code{getadditionalFundamentalReturn}:
    Executes the query against the database and returns the rows with addtional fundamental factors.
    
    \code{getFundamental.aligned}:
    Executes the query against the database and returns the data with each stock aligned in proper quater.
    
    \code{getadditionalFundamental.aligned}:
    Executes the query against the database and returns the data with additional fundamental data and each stock aligned in proper quater.
    
    \code{getFundamental.QuarterlyReturn}:
    Executes the query against the database and returns the quarterly returns for each stock.
    
    \code{getadditionalFundamental.QuarterlyReturn}:
    Executes the query against the database and returns the quarterly returns for each stock
    with additional fundamental data.    

}
\author{
    Pankaj Singh, Jaiganesh Prabhakaran
}
\seealso{
\itemize{
    \item \link{getIndexStockQuery} 
    \item \link{getStockFromIndex}
    \item \link{getStockXCap} 
    \item \link{getStockLargeCap}
    \item \link{getStockMidCap} 
    \item \link{getStockSmallCap}
    \item \link{getProminentStocks} 
  }
}
\examples{

#Get combined data(fundamental from Compustat+returns from CRSP)
funda.return <- getFundamentalReturn() 
head(funda.return)

#GetTimeSeries data(returns for all stocks)
pivot.return<-getReturnPivot()
head(pivot.return)

}
\keyword{software}
