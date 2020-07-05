library(DiagrammeR)
library(rsvg)
library(DiagrammeRsvg)

exportpad <- "S:/bier/brouwjebier/images/"

# Afbeelding Brouwproces
bp <- grViz("
      digraph brouwproces {
      graph [layout = dot, rankdir = LR]
      
      # node opdrachten
      node [shape = rectangle, style = filled, fillcolor = Linen, fontname = Arial]
      1[label = 'zetmeel (mout)', fillcolor = Beige]
      2[label = 'suiker', fillcolor = Beige]
      3[label = 'alkohol', fillcolor = Beige]

      # edge opdrachten
      edge [fontname = Arial]
      1 -> 2[label = 'maischen']
      2 -> 3[label = 'vergisten']
    }
")

export_svg(bp) %>% charToRaw() %>% rsvg() %>% png::writePNG(paste(exportpad, "brouwproces.png", sep = ""))


# Afbeelding Moutproces en moutsoorten
mp <- grViz("
	  digraph moutproces {
	  graph[rankdir=TD]
	  node[shape = oval, style = filled]
	  N11[fillcolor=DarkGoldenRod, label='gerst']
	  N21[fillcolor=SteelBlue, label='Inweken met water\n(kamertemperatuur)']

	  node[shape = rectangle, style = filled]
	  N31[fillcolor=DarkSeaGreen, label='Drogen op lage temp.\n(60°C)', width=3.3]
	  N32[fillcolor=LightBlue, label='Stoven met water\n(55-70°C)', width=1.5]

	  node[shape = rectangle, style = 'rounded, filled', width=1.6]
	  N41[fillcolor=Gold, label='Lage temp.\neesten\n(85-115°C)']
	  N42[fillcolor=OrangeRed, label='Hoge temp.\neesten\n(160-220°C)']
	  N43[fillcolor=DarkOrange, label='Medium temp.\neesten\n(120-160°C)']
	  N44[fillcolor=red, label='Zeer hoge temp.\neesten\n(220-230°C)']

	  node[shape = rectangle, style = 'filled', width=1.5]
	  N51[fillcolor=Gold, label='pilsmout\npale ale mout\nVienna mout\nMünchener mout']
	  N52[fillcolor=SaddleBrown, label='chocolademout\nzwarte mout\nroostmout\nbruine mout']
	  N53[fillcolor=Salmon, label='kristal\nmouten\n\n\n']
	  N54[fillcolor=Black, fontcolor=White, label='geroosterde\ngerst\n\n\n']

	  N11->N21[label='Mouten']
	  N21->N31
	  N21->N32
	  N31->{N41 N42}
	  N32->N43
	  N11->N44[label='Roosteren']
	  N41->N51
	  N42->N52
	  N43->N53
	  N44->N54

	  subgraph niveau3 {
	    N31;N32
	  }

	  subgraph niveau4 {
	    rank='same'
	    N41;N42;N43;N44
	  }

	  subgraph niveau5 {
	    N51;N52;N53;N54
	  }

	  }
")

export_svg(mp) %>% charToRaw() %>% rsvg() %>% png::writePNG(paste(exportpad, "moutproces.png", sep = ""))

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
