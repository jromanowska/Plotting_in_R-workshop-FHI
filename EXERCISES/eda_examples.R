#DESCRIPTION: Exemplary code with explorative data analysis
#AUTHOR: Julia Romanowska
#DATE CREATED: 2022-03-31
#DATE UPDATED: 2022-04-06

# SETUP -----
# NOTE: if you don't have these packages installed, run first in the console:
#   install.packages(c("skimr", "DataExplorer", "dataReporter", "tibble", "ggplot2", "esquisse", "ggiraph"))
library(skimr)
library(dataReporter)
library(DataExplorer)
library(tibble)
library(esquisse)
library(ggplot2)
library(ggiraph)

# DATA -----
data(airquality)
as_tibble(airquality)
skim(airquality)

airquality1 <- airquality %>%
  dplyr::mutate(Month = as.factor(Month))
skim(airquality1)
# REPORT ----
# from DataExplorer:
create_report(airquality)

# from dataReporter:
makeDataReport(airquality)

# VISUALIZATION ----
# esquisse
esquisse::esquisser(airquality)

# take the code and make it interactive!
# use ggiraph
plot_points <- ggplot(airquality) +
 aes(x = Ozone, y = Solar.R, colour = as.factor(Month)) +
 geom_point_interactive(aes(tooltip = paste("OZ:", Ozone, "\n S.R:", Solar.R, "\nM:", Month)), shape = "circle", size = 3) +
 scale_color_viridis_d_interactive(option = "viridis", direction = 1) +
 theme_gray()

girafe(ggobj = plot_points)
