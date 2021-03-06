library(tidyverse)
library(kableExtra)

bkg.list <- read_csv2("S:/websites/vlearmoesbier/static/download/bkg_biertypen.csv")

# Tabel met klassen als kolommen (in )
bkg.klasse <- bkg.list %>% 
	select(BIERTYPE, KLASSE)

kla <- bkg.klasse %>% filter(KLASSE == "A") %>% select(BIERTYPE) %>% rename("Klasse A" = BIERTYPE) %>% mutate(id = seq.int(nrow(.)))
klb <- bkg.klasse %>% filter(KLASSE == "B") %>% select(BIERTYPE) %>% rename("Klasse B" = BIERTYPE) %>% mutate(id = seq.int(nrow(.)))
klc <- bkg.klasse %>% filter(KLASSE == "C") %>% select(BIERTYPE) %>% rename("Klasse C" = BIERTYPE) %>% mutate(id = seq.int(nrow(.)))
kld <- bkg.klasse %>% filter(KLASSE == "D") %>% select(BIERTYPE) %>% rename("Klasse D" = BIERTYPE) %>% mutate(id = seq.int(nrow(.)))
lijst <- list(kla, klb, klc, kld)
bkg.tabel <- Reduce(function(x,y,...) merge(x,y, all=TRUE,...), lijst) %>% select(-id)

# Schema Biertypen en klassen (in biertypen.Rmd)

# Voor BEGINSG en EBC wordt met de gemiddelde waarde gewerkt.
# Voor het maken van de plaatjes zijn alleen de kolommen BIERTYPE, KLASSE, EBC, BEGINSG nodig.
# EBC waarden >= 120 en BEGINSG<1100 worden weggelaten.
# eventueel kleuren voor de klassen nog verder aanpassen

bkg.selectie <- bkg.list %>%
	mutate(EBC = (EBCMIN + EBCMAX)/2) %>%
	mutate(BEGINSG = (BEGINSGMIN +BEGINSGMAX)/2) %>%
	select(BIERTYPE, KLASSE, EBC, BEGINSG) %>%
	filter(EBC < 90) %>%
	filter(BEGINSG < 1100)

bkg.schema <- ggplot(data = bkg.selectie, aes( x = EBC, y = BEGINSG)) +
	geom_point(size=1, color = "Red") +
	labs(title = "Biertypes en klassen", x = "Kleur (EBC)", y = "Begin SG") +
	geom_hline(yintercept = 1060, linetype = "dashed", color = "black") +
	geom_vline(xintercept = 30,  linetype = "dashed", color = "black") +
	theme_bw() +
	annotate("text", x=15, y=1040, label= "A", size=8, color = "Red") +
	annotate("text", x=45, y=1040, label= "B", size=8, color = "Red") +
	annotate("text", x=15, y=1075, label= "C", size=8, color = "Red") +
	annotate("text", x=45, y=1075, label= "D", size=8, color = "Red") +
	geom_text(label = bkg.selectie$BIERTYPE, nudge_x = 0.25, nudge_y = 0.25, check_overlap = TRUE, size = 3)
