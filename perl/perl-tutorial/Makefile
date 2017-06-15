# $Id: Makefile,v 1.1 2007-11-21 14:06:37-08 - - $

all : README.html
	more README.text

README.html : README.text
	txt2html README.text >README.html

ci :
	cid + README.text GNUmakefile *.perl

lis :
	enscript -GjC -plisting.ps README.text GNUmakefile *.perl
	ghostview -magstep 1 listing.ps

