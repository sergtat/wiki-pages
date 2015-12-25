#  Перегон djvu в pdf
Совсем недавно понадобилось перегнать djvu в pdf под linux. Решить эту задачу можно легко и просто с помощью нескольких строчек по схеме djvu-tiff-pdf:
  $ sudo apt-get install libtiff-tools djvulibre-bin djvulibre-desktop
  $ ddjvu -format=tiff yourfile.djvu yourfile.tiff
  $ tiff2pdf -j -o outfile.pdf yourfile.tiff

yourfile.djvu - входной файл  
yourfile.tiff -промежуточный  
outfile.pdf -результат