#DESCRIPTION: Exemplary code for producing plots with {esquisse}
#AUTHOR: Julia Romanowska
#DATE CREATED: 2022-03-31
#DATE UPDATED: 2022-10-16

# SETUP -----
# NOTE: if you don't have these packages installed, run first in the console:
#   install.packages(c("esquisse", "dplyr", "ggplot2"))
library(esquisse)
library(readr)
library(dplyr)
library(ggplot2)
library(here)

# READ DATA -----
consult_tidy <- read_delim(
	here("DATA", "Consultations_tidy_2021-09-03.txt"),
	delim = "\t"
)

# VISUALIZE ----
esquisser(consult_tidy)

consult_tidy <- consult_tidy %>%
	mutate(across(age:year, ~ as.factor(.x)))

esquisser(consult_tidy)

# ANALYSE ----
# group the dataset to apply summarising functions on per-group basis
consult_tidy_grouped <- consult_tidy %>%
  group_by(year, age)
# check how the data looks like:
consult_tidy_grouped # NOTE, 'group_by()' doesn't change the data looks!

# take sum of consultations per year and age group
consult_tidy_summary <- consult_tidy %>%
	filter(diagnosis == "Alle diagnoser")

# PLOT ----
# let's plot this sum!
plot_sum_consult <- ggplot(consult_tidy_summary,
        aes(x = year, y = nConsultations)) +
	geom_col(aes(fill = age), position = position_dodge())
plot_sum_consult

## MORE 'GEOMs' ON ONE PLOT ----
# what about median + sd?
consult_tidy_median <- consult_tidy_grouped %>%
	filter(diagnosis != "Alle diagnoser") %>%
	# summarise() function creates new columns _per group_
  summarise(median = median(nConsultations, na.rm = TRUE),
            stderr = sd(nConsultations, na.rm = TRUE))
# check how the data looks like now:
consult_tidy_median

# let's plot!
# first - medians
plot_median_consult <- ggplot(consult_tidy_median,
                   aes(year, median)) +
  geom_col(aes(fill = age), position = position_dodge())
plot_median_consult

# with ggplot(), it's easy to modify our plots
plot_median_consult +
	geom_errorbar(
		aes(
			ymin = median - stderr,
			ymax = median + stderr,
			group = age
		),
		position = position_dodge()
	)
# the modified plot can also be saved:
plot_median_sd_consult <- plot_median_consult +
	geom_errorbar(
		aes(
			ymin = median - stderr,
			ymax = median + stderr,
			group = age
		),
		position = position_dodge()
	)

## FACETTING ----
# why are the error bars so large?
# check data _per diagnosis type_ - using _facets_
ggplot(
	consult_tidy_grouped %>%
		filter(diagnosis != "Alle diagnoser"),
  aes(x = year, y = nConsultations)
	) +
	geom_col(aes(fill = age), position = position_dodge()) +
	facet_wrap(facets = vars(diagnosis))

# can't see the smallest values - change scales!
plot_consult_diagnosis_facets <- ggplot(
		consult_tidy_grouped %>%
			filter(diagnosis != "Alle diagnoser"),
  	aes(x = year, y = nConsultations)
	) +
	geom_col(aes(fill = age), position = position_dodge()) +
	facet_wrap(
		facets = vars(diagnosis),
		scales = "free_y"
	)
plot_consult_diagnosis_facets

# variation and more facets
#   - plot nConsultations vs age categories
#   - color according to gender
#   - facetting grid: diagnosis in rows, year in columns
consultations_per_year_diagnosis <- ggplot(
		consult_tidy_grouped %>%
			filter(diagnosis != "Alle diagnoser"),
  	aes(x = age, y = nConsultations)
	) +
	geom_col(aes(fill = gender), position = position_dodge()) +
	facet_grid(
		rows = vars(diagnosis),
		cols = vars(year),
		scales = "free_y"
	)
consultations_per_year_diagnosis

## PRETTIFY YOUR PLOT! ----
# we can't see much on this plot
consultations_per_year_diagnosis +
	scale_fill_manual(values = c("#d8b365", "#5ab4ac")) +
	# axis titles
	xlab("age category") +
	ylab("number of consultations") +
	theme_light() +
	theme(
		# text on x axis is not visible, so let's rotate it
		axis.text.x = element_text(angle = 90),
		# same for text on the facets in rows
		strip.text.y = element_text(angle = 0)
	)

# SAVE YOUR WORK ----
# by default - saves the last plot
ggsave(
	here("EXERCISES", "my_fantastic_plot.png"),
	width = 12,
	height = 14
)
