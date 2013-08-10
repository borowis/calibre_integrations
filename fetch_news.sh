#!/bin/bash
# This is free and unencumbered shell script released into the public domain.
#

####################### Begin Customization Section #############################
#
# Name of the recipe to fetch. You can run:
#     ebook-convert --list-recipes
# to look for the correct name. Do not forget the .recipe suffix
declare -a RECIPES=("./recipes/coding_horror.recipe" "./recipes/xkcd.recipe" "./recipes/what_if.recipe")
declare -a NAMES=("Coding_Horror" "XKCD" "What If")
OUTDIR="./converted"
OLDEST_ARTICLES="2"

# Select your output profile. See http://manual.calibre-ebook.com/cli/ebook-convert-14.html
# for a list. Common choices: kindle, kindle_dx, kindle_fire, kobo, ipad, sony
OUTPROFILE="kindle_dx"
#
######################## End Customization Section #############################

DATEFILE=`date "+%Y_%m_%d"`
DATESTR=`date "+%Y/%m/%d"`

total=${#RECIPES[*]}
for (( i=0; i<=$(( $total -1 )); i++ ))
do
	OUTFILE="${OUTDIR}/${DATEFILE}_${NAMES[$i]}.MOBI"
	echo "Fetching ${RECIPES[$i]} into $OUTFILE"
	sed -i "s/oldest_article\( *\)=\( *\)[0-9]\+/oldest_article\1=\2${OLDEST_ARTICLES}/g" ${RECIPES[$i]}
	ebook-convert "${RECIPES[$i]}" "$OUTFILE" --output-profile "$OUTPROFILE" --no-inline-toc --mobi-keep-original-images

	# Change the author of the ebook from "calibre" to the current date. 
	# I do this because sending periodicals to a Kindle Touch is removing
	# the periodical format and there is no way to differentiate between
	# two editions in the home screen. This way, the date is shown next 
	# to the title.
	# See http://www.amazon.com/forum/kindle/ref=cm_cd_t_rvt_np?_encoding=UTF8&cdForum=Fx1D7SY3BVSESG&cdPage=1&cdThread=Tx1AP36U78ZHQ1I
	# and, please, email amazon (kindle-feedback@amazon.com) asking to add 
	# a way to keep the peridiocal format when sending through @free.kindle.com 
	# addresses
	echo "Setting date $DATESTR as author in $OUTFILE"
	ebook-meta "$OUTFILE" -a "$DATESTR"
done
