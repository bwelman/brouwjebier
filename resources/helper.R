# Hulpbestand om bkgtabel en bkgschema te maken.
# Moet uitgevoerd worden wanneer de BKG lijst verandert.

require(dplyr)
require(readr)
biertypen <- read_csv2("resources/bkg_biertypen.csv", show_col_types = FALSE)

bkg.klasse <- biertypen %>% select(BIERTYPE, KLASSE)
kla <- bkg.klasse %>% filter(KLASSE == "A") %>% select(BIERTYPE) %>% rename("Klasse A" = BIERTYPE) %>% mutate(id = seq.int(nrow(.)))
klb <- bkg.klasse %>% filter(KLASSE == "B") %>% select(BIERTYPE) %>% rename("Klasse B" = BIERTYPE) %>% mutate(id = seq.int(nrow(.)))
klc <- bkg.klasse %>% filter(KLASSE == "C") %>% select(BIERTYPE) %>% rename("Klasse C" = BIERTYPE) %>% mutate(id = seq.int(nrow(.)))
kld <- bkg.klasse %>% filter(KLASSE == "D") %>% select(BIERTYPE) %>% rename("Klasse D" = BIERTYPE) %>% mutate(id = seq.int(nrow(.)))
lijst <- list(kla, klb, klc, kld)
bkg.tabel <- Reduce(function(x,y,...) merge(x,y, all=TRUE,...), lijst) %>% select(-id)

save(bkg.tabel, file = 'resources/bkgtabel.rda') # bkgtabel kan geladen worden via load(file = 'resources/bkgtabel.rda')

# Een aantal biertypes en hun klasse
# Voor BEGINSG en EBC wordt met de gemiddelde waarde gewerkt.
# Voor het maken van de plaatjes zijn alleen de kolommen BIERTYPE, KLASSE, EBC, BEGINSG nodig.
# EBC waarden >= 120 en BEGINSG<1100 worden weggelaten.
# eventueel kleuren voor de klassen nog verder aanpassen
bkg.selectie <- biertypen %>%
	mutate(EBC = (EBCMIN + EBCMAX)/2) %>%
	mutate(BEGINSG = (BEGINSGMIN +BEGINSGMAX)/2) %>%
	select(BIERTYPE, KLASSE, EBC, BEGINSG) %>%
	filter(EBC < 90) %>%
	filter(BEGINSG < 1100)

bkgschema <- ggplot(data = bkg.selectie, aes( x = EBC, y = BEGINSG)) +
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

svg(filename = "images/bkgschema.svg")
plot(bkgschema)
dev.off()

# ---------------------------------------------------------
# Grafiek hoprendement-kooktijd (wordt gebruikt in hop.Rmd)
mydf <- data.frame(kooktijd = c(seq(0,60,3), 70,80,90, 120, 150))
mydf$dhr <-  (1.65*0.000125^.050) * (1-exp(-0.04*mydf$kooktijd))/4.15
ktdhr <- ggplot(data = mydf, aes(x = kooktijd, y = dhr)) +
	geom_line(size = 1.2, colour = "darkgreen") +
	theme_bw() +
	labs(title = "Rendement hopbitterheid - Kooktijd", x = "Kooktijd (min)", y = "Rendement") +
	scale_x_continuous(breaks = seq(0, 150, 10)) + scale_y_continuous(breaks = seq(0, 0.3, 0.05))

svg(filename = "images/kt-dhr.svg")
plot(ktdhr)
dev.off()

# ---------------------------------------------------------
# kleurenkaart (wordt gebruikt in mout.Rmd)
# Kleurenkaart met EBC waarde aan het begin van de naam
bierkleuren <- data.frame(
	kleur = c("04-Blond", "06-Lichtgoud", "08-Goud", "10-Goudoranje", "12-Oranje", "16-Amber", "20-Koper",
			  "24-Lichtbruin", "28-Middelbruin", "30-Bruin", "40-Roodbruin", "50-Donkerbruin", "60-Zwartbruin", "80-Zwart"),
	hex = c("#FFF59B","#FFF381","#FCE162","#FDCF4F","#F9B939","#EFA90E","#CE800A",
			"#B35E18","#9B481A","#8F4019","#622413","#43180F","#2D100B","#110707"))

kleurenkaart <-ggplot(data = bierkleuren, aes(x = kleur, y =1, fill = kleur)) +
	geom_col(show.legend = F, width = 1) +
	scale_fill_manual(values = bierkleuren$hex) +
	scale_x_discrete(expand=c(0,0)) +
	scale_y_discrete(expand=c(0,0)) +
	labs(x = NULL, y = NULL) +
	coord_flip() +
	labs(title = "EBC Kleurenkaart") +
	theme(aspect.ratio = 6/5)

svg(filename = "images/kleurenkaart.svg")
plot(kleurenkaart)
dev.off()

# ---------------------------------------------------------
# infusie-3staps, Voorbeeld maischstappen in een infusieproces (wordt gebruikt in maischen.Rmd)

infusie3 <- data.frame(tijd = c(0, 30,45,57,97,108,133,138,143),
					   temp = c(20,50,50,62,62,72,72,78,78))
infusieplot <- ggplot(data = infusie3, aes( x = tijd, y = temp, label=temp)) +
	geom_line(size =1.2, colour =  "#E69F00") +
	geom_text(size=3, vjust= -0.8, hjust = 1) +
	labs(title = "Voorbeeld infusieproces (3-staps)", x = "Tijd (min)", y = "Temperatuur (C)") +
	theme_bw() +
	scale_x_continuous(breaks = seq(0,150,10)) + scale_y_continuous(breaks = seq(0,100,10)) +
	annotate("text", x=30, y=48, label = "proteinase", hjust = 0) +
	annotate("text", x=60, y=60, label = "beta-amylase", hjust = 0) +
	annotate("text", x=110, y=70, label = "alpha-amylase", hjust = 0)

svg(filename = "images/infusieplot.svg", pointsize = 14)
plot(infusieplot)
dev.off()

# ---------------------------------------------------------
