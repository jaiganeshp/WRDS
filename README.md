This repo contains code to manage fundamental data of stocks.
To get started, you will need git client on your box. Then follow these steps.

* Clone the repo in your local machine.

* The data file at wrds\inst\extdata is blank. Replace the data file with one from OneDrive
      https://uwnetid-my.sharepoint.com/personal/psingh_uw_edu/Documents/WRDS/Cqa.sqlite?web=1

* Open the project file WRDS.Rproj in RStudio.

* Click the Build->Clean & Rebuild. This will drop the package in your lib path.

Now your are ready to use the package. There are sample test method in each of the R file. 
>library(WRDS)