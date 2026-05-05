# Bannery

Soubor `oteviraci_doba.tex` slouží jako příklad. Umožňuje experimentovat s různýma kombinacema barev.

# Konverze do JPG

```bash
$ pdftocairo -scale-to 1200 -jpeg -f 1 -l 1 oteviraci_doba.pdf
```

Parammetr `-f` a `-l` označujou číslo stránky.

