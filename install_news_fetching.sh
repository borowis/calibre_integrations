#!/bin/bash
# This is free and unencumbered shell script released into the public domain.
#

####################### Begin Customization Section #############################
#
# Name of the recipe to fetch. You can run:
#     ebook-convert --list-recipes
# to look for the correct name. Do not forget the .recipe suffix
FULL_PATH="/home/borowis/Documents/calibre_kindle"
EBOOK_CONVERT=`which ebook-convert`
declare -a RECIPES=("${FULL_PATH}/recipes/coding_horror.recipe" "${FULL_PATH}/recipes/xkcd.recipe" "${FULL_PATH}/recipes/what_if.recipe")
declare -a NAMES=("Coding_Horror" "XKCD" "What If") # postfix feed names and cron jobs keys
declare -a UPDATE_TIMES=("20" "3" "10") # check for updates interval for every feed; in days; should be less than 28 I think
OUTDIR="${FULL_PATH}/converted" # conversion output directory
CRON_TIME_PREFIX="@@min@@ 3 */@@days@@ * *" # time of day to run conversion; see more info on cron; you can change hours but not placeholders

# Select your output profile. See http://manual.calibre-ebook.com/cli/ebook-convert-14.html
# for a list. Common choices: kindle, kindle_dx, kindle_fire, kobo, ipad, sony
OUTPROFILE="kindle_dx"
#
######################## End Customization Section #############################


crontab -l > ${FULL_PATH}/mycron
total=${#RECIPES[*]}
cron_time=0 # we need a check so we don't run out of minutes
for (( i=0; i<=$(( $total -1 )); i++ ))
do
	echo "Set up some variables"
	sed -i "s/oldest_article\( *\)=\( *\)[0-9]\+/oldest_article\1=\2${UPDATE_TIMES[$i]}/g" ${RECIPES[$i]}
	CRON_TIME_STRING=`echo "${CRON_TIME_PREFIX}" | sed "s/@@min@@/${cron_time}/g"`
	CRON_TIME_STRING=`echo "${CRON_TIME_STRING}" | sed "s/@@days@@/${UPDATE_TIMES[$i]}/g"`
	cron_time=$(( ${cron_time}+5 ))

	echo "Setting cron job that will fetch ${RECIPES[$i]} into $OUTFILE"
	sed -i "/^.*${NAMES[$i]}.MOBI.*$/d" ${FULL_PATH}/mycron
	echo "${CRON_TIME_STRING} ${EBOOK_CONVERT} ${RECIPES[$i]} ${OUTDIR}/`date '+%Y_%m_%d'`_${NAMES[$i]}.MOBI --authors `date '+%Y/%m/%d'` --output-profile $OUTPROFILE --mobi-keep-original-images --no-inline-toc >> ${FULL_PATH}/log" >> ${FULL_PATH}/mycron
done

# set up new cron
crontab ${FULL_PATH}/mycron
rm ${FULL_PATH}/mycron

