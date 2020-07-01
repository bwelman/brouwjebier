library(DiagrammeR)
library(rsvg)
library(DiagrammeRsvg)

exportpad <- "S:/bier/brouwjebier/images/"

# Brouwproces
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


# Moutproces en moutsoorten
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
