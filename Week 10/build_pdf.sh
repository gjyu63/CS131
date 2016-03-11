# build the TeX file
latexmk -shell-escape hw6.tex
if [ $? -eq 0 ]; then
    pdflatex -shell-escape hw6.tex
else
    echo "something went wrong... :C"
fi
