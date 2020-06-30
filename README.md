Dit boek bevat de brouwcursus van het Twents Bierbrouwers Gilde.

Samenstelling en eindredactie: Ben Welman

Medewerkers: Douwe Beimin

**Productieproces**

-  Het boek is geschreven in **Markdown** formaat.
-  Elk hoofdstuk is een .Rmd bestand welke je met een eenvoudige tekstverwerker kunt maken.
-  De eerste regel van een hoofdstuk begint met het symbool `#`, dan een spatie en dan de titel.
-  Een hoofdstuk kan paragrafen bevatten. Elke paragraaftitel begint met `##`, dan een spatie en dan de titel. Subparagrafen beginnen met `###`

De mogelijke uitvoerformaten voor het boek zijn: html, pdf en epub. Het compileren naar een uitvoerformaat wordt door Ben Welman gedaan.

**Rol mogelijke mede-auteurs**

-  Aanleveren van (deel van de) inhoud
-  Correcties/suggesties tekst

**Inhoud cursus basis**

Het cursusboek wordt tijdsonafhankelijk, dus geen datums van bijeenkomsten of namen van cursisten en mentoren.

Geprobeerd wordt om de hoofdstukken tot 1 onderwerp te beperken zodat de omvang niet te groot wordt.

**Inhoud cursus gevorderd**

Mogelijke onderwerpen

-  uitdieping verschillende brouwmethodes
-  theoretische verdieping, waaronder meer scheikunde
-  gist: hergebruik, bewaren in diepvries, opkweken vanuit fles
-  water: hardheid, zuurgraad, (rest)alkaliteit
-  ondergistend bier maken
-  Aanpak klonen van een (commercieel) bier
-  Kegs en alles daaromheen
-  Tappen
-  Gebruik stikstof

## LaTeX aanpassingen

### Afbeeldingen

De chunkparameter `fig.pos="H"` zorgt er voor dat alle afbeeldingen terechtkomen op de plaats waar ze ook in het document ingevoegd worden, anders worden ze onder aan een pagina geplaatst. Echter deze optie wordt alleen gebruikt wanneer knitr denkt dat voor de afbeelding een Latex figure environment moet produceren in plaats van een Markdown opdracht `![]()`. En knitr produceert alleen een figure environment wanneer er `en een `fig.caption` gespecificeerd is èn er tenminste een van de volgende opties gespecificeerd is: `fig.align`, `out.width`, `out.extra`. Om knitr daartoe te forceren kun je naast de caption als optie toevoegen `out.extra = ''`.

Een alternatief is het gebruik van latex package `float` en daarna het latex commando `\floatplacement{figure}{H}`
Ik heb dit toegevoegd aan de preambule.tex en dat lijkt goed te werken.
je kunt dit zien in de `.tex` file in de [thesisdown package](https://github.com/ismayc/thesisdown) van Chester Ismay.

The actual size of a plot is determined by the chunk options fig.width and fig.height (the size of the plot generated from a graphical device), and we can specify the output size of plots via the chunk options out.width and out.height. The possible value of these two options depends on the output format of the document. For example, out.width = '30%' is a valid value for HTML output, but not for LaTeX/PDF output. However, knitr will automatically convert a percentage value for out.width of the form x% to (x / 100) \linewidth, e.g., out.width = '70%' will be treated as .7\linewidth when the output format is LaTeX. This makes it possible to specify a relative width of a plot in a consistent manner. Figure 2.2 is an example of out.width = 70%.

Ik heb oud.width / out.height toegepast voor Latex en dat werkt, maar de figuur wordt dan links uitgelijnd en de titel blijft gecentreerd. Wanneer ik het weer combineer met fig.align werkt oud.width weer niet.

f you want to put multiple plots in one figure environment, you must use the chunk option fig.show = 'hold' to hold multiple plots from a code chunk and include them in one environment. You can also place plots side by side if the sum of the width of all plots is smaller than or equal to the current line width. For example, if two plots have the same width 50%, they will be placed side by side. Similarly, you can specify out.width = '33%' to arrange three plots on one line. Figure 2.3 is an example of two plots, each with a width of 50%.

Dit moet ik eerst voor Latex uitproberen. Het kan alleen maar met 1 titel.