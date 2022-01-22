#set.seed(25)
options(digits = 3)

# packages ---------------------------------------------------------------------

suppressMessages(library(knitr))
suppressMessages(library(tidyverse))
suppressMessages(library(kableExtra))
suppressMessages(library(DiagrammeR))
suppressMessages(library(formattable))

# knitr chunk options ----------------------------------------------------------

knitr::opts_chunk$set(
	echo = FALSE,
	message = FALSE,
	warning = FALSE,
	#cache = TRUE,
	comment = "#>",
	collapse = TRUE,
	fig.retina = 2,       # Control gebruik dpi
	fig.width = 6,
	fig.pos = "ht",       # positie figuur latex mode
	fig.align = 'center',
	fig.asp = 0.618,      # gulden snede verhouding
	fig.show = "hold",
	out.width = "60%",
	dev.args = list(png = list(type = "cairo-png"))
)

# knit options -----------------------------------------------------------------

options(knitr.kable.NA = "")

# kableExtra options -----------------------------------------------------------

options(kableExtra.html.bsTable = TRUE)
