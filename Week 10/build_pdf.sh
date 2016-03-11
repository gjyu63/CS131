# build the TeX file
latexmk -shell-escape hw6.tex
if [ $? -eq 0 ]; then
    pdflatex -shell-escape hw6.tex
else
    echo "something went wrong... :C"
fi

# file cleanup
rm hw6.aux hw6.bbl hw6.blg hw6.dvi hw6.fdb_latexmk hw6.fls hw6.out
