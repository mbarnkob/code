# Kode til analyse af Valde's jul kort

Herunder findes kode til analyse af Valde's jul kort fra julen 2025. Koden kan køres med R.

## Data
Seneste data (op til 10 december 2025) er samlet ind af Benjamin og mig selv (Mike), hovedsagligt i Odense.
Kort-antal er korrigeret for evt. byt, således at data her er opgivet før byt.

## Analyse #1 - sandsynligheden for kort efter antal symboler

Denne analyse bestod af 208 kort indsamlet i og omkring Odense (hovedsagligt fra Bilka i Odense).

*Data*: [kort_7dec.csv](kort_7dec.csv)

*Kode*: [analysis-1.r](analysis-1.r)

*Resultat:*

![Graf over Valde's jul kort](Valde-1.jpg "Sandsynlighed for Valde's jul kort")

## Analyse #2 - fund af kort outliers

*Data*: [kort_11dec.csv](kort_11dec.csv)

*Kode*: [analysis-2.r](analysis-2.r)

**Beskrivelse**

Denne analyse består af 652 kort, og identificerer to outlier grupper i kort med 1 eller 2 symboler.

For kort med ét symbol, drejer det sig om: 3, 25, 38.

For kort med to symboler, drejer det sig om: 9, 26, 33.

Hvis man fjerner disse kort er sandsynligheden for at for et kort følgende inden for symbol-kategorierne:

1 symbol: 3,8%

2 symboler: 1,1%

3 symboler: 0,6%


**Resultat:**

![Grafer med og uden outlier kort](analysis-2.jpg "Grafer med og uden outlier kort")

![Monte Carlo analyse af sandsynlighed for et 1 symbol kort](analysis-2b.jpg "Monte Carlo analyse af sandsynlighed for et 1 symbol kort")
