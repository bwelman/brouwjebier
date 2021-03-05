exportpad <- "S:/bier/brouwjebier/images/"


# Afbeelding Biertypen en klassen

library(tidyverse)

bkg_biertypen <- read_delim("S:/websites/vlearmoesbier/static/download/bkg_biertypen.csv",
							";", escape_double = FALSE, locale = locale(decimal_mark = ","),
							trim_ws = TRUE)

# Voor BEGINSG en EBC wordt nu met de gemiddelde waarde gewerkt.
# Voor het maken van de plaatjes zijn alleen de kolommen BIERTYPE, KLASSE, EBC, BEGINSG nodig.
# EBC waarden >= 120 en BEGINSG<1100 worden weggelaten.
# eventueel kleuren voor de klassen nog verder aanpassen

bkg_biertypen2 <- bkg_biertypen %>%
	mutate(EBC = (EBCMIN + EBCMAX)/2) %>%
	mutate(BEGINSG = (BEGINSGMIN +BEGINSGMAX)/2) %>%
	select(BIERTYPE, KLASSE, EBC, BEGINSG) %>%
	filter(EBC < 90) %>%
	filter(BEGINSG < 1100)

plot1 <- ggplot(data = bkg_biertypen2,
				aes( x = EBC, y = BEGINSG)) +
	geom_point(size=1, color = "Red") +
	labs(title = "Biertypes en klassen", x = "Kleur (EBC)", y = "Begin SG") +
	geom_hline(yintercept = 1060, linetype = "dashed", color = "black") +
	geom_vline(xintercept = 30,  linetype = "dashed", color = "black") +
	theme_bw() +
	annotate("text", x=15, y=1040, label= "A", size=8, color = "Red") +
	annotate("text", x=45, y=1040, label= "B", size=8, color = "Red") +
	annotate("text", x=15, y=1075, label= "C", size=8, color = "Red") +
	annotate("text", x=45, y=1075, label= "D", size=8, color = "Red") +
	geom_text(label = bkg_biertypen2$BIERTYPE, nudge_x = 0.25, nudge_y = 0.25, check_overlap = TRUE, size = 3)
plot1

# bewaar als png bestand
ggpubr::ggexport(plot1, filename = paste(exportpad, "bierklassen-typen.png", sep=""))

# Maak tabel met biertypen per klasse
library(tidyverse)

bkg_biertypen <- read_delim("S:/websites/vlearmoesbier/static/download/bkg_biertypen.csv",
							";", escape_double = FALSE, locale = locale(decimal_mark = ","),
							trim_ws = TRUE)
bt <- bkg_biertypen %>% select(BIERTYPE, KLASSE)


kla <- bt %>% filter(KLASSE == "A") %>% mutate("Klasse A" = BIERTYPE) %>% select("Klasse A") %>% mutate(id = seq.int(nrow(.)))
klb <- bt %>% filter(KLASSE == "B") %>% mutate("Klasse B" = BIERTYPE) %>% select("Klasse B") %>% mutate(id = seq.int(nrow(.)))
klc <- bt %>% filter(KLASSE == "C") %>% mutate("Klasse C" = BIERTYPE) %>% select("Klasse C") %>% mutate(id = seq.int(nrow(.)))
kld <- bt %>% filter(KLASSE == "D") %>% mutate("Klasse D" = BIERTYPE) %>% select("Klasse D") %>% mutate(id = seq.int(nrow(.)))
lijst <- list(kla, klb, klc, kld)
tabel <- Reduce(function(x,y,...) merge(x,y, all=TRUE,...), lijst) %>% select(-id)

# In de Rmd kun je de tabel mooi produceren met knitr::kable(). OM geen NA's af te drukken moet je dit via options aangeven
# options(knitr.kable.NA = '')
# knitr::kable(tabel)
