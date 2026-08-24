# Engine: 1 = pdflatex, 4 = lualatex, 5 = xelatex
$pdf_mode = 4;

# -shell-escape is required by minted.
$lualatex = 'lualatex %O -shell-escape -interaction=nonstopmode -synctex=1 %S';
$xelatex  = 'xelatex  %O -shell-escape -interaction=nonstopmode -synctex=1 %S';
$pdflatex = 'pdflatex %O -shell-escape -interaction=nonstopmode -synctex=1 %S';

# biblatex + biber (set to 0 if the template uses plain bibtex)
$bibtex_use = 2;

# Keep artefacts out of the source tree.
# These MUST match vimtex_compiler_latexmk in nvim.
$out_dir = 'build';
$aux_dir = 'build';

$clean_ext = 'bbl nav out run.xml snm synctex.gz %R-blx.bib';
push @generated_exts, 'glo', 'gls', 'glg';
