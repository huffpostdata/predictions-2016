#!/bin/sh

# Runs the model, archives its results, and uploads a new version of the
# website.

[[ -z "$BASE_URL" ]] && { echo >&2 'You must set the BASE_URL variable'; exit 1; }
[[ -z "$S3_BUCKET" ]] && { echo >&2 'You must set the S3_BUCKET variable'; exit 1; }

FAST_OR_SLOW="$1" # might be the empty string; that's okay. Only "fast" means something.

set -e

pushd "$(dirname "$0")" >/dev/null

OUTDIR=data/sheets/output
TEMP_OUTDIR=data/sheets/output-spool
BACKUP_OUTDIR=data/sheets/output-backup

rm -rf $TEMP_OUTDIR
mkdir $TEMP_OUTDIR
touch $TEMP_OUTDIR/.gitkeep # because the _real_ outdir has a .gitkeep

# Update poll data
echo >&2 'Running ./update-polls.js...'
./update-polls.js >$TEMP_OUTDIR/senate-polls.tsv

# Run model
echo >&2 "Running Rscript --vanilla ./all-states.R \"$1\"..."
rm -rf R/interim-results
(cd R && OUTPUT_DIR=../$TEMP_OUTDIR Rscript --vanilla ./all-states.R "$1")

# Move files around
echo >&2 'Archiving and placing new results in data/sheets/output...'
mkdir -p data/sheets/output-archives
TIMESTAMPED_OUTDIR=data/sheets/output-archives/$(date -u +"%Y-%m-%dT%H_%M_%SZ") # calculated _after_ we ran the model

mv $TEMP_OUTDIR $TIMESTAMPED_OUTDIR
# old output -> backup; new results -> new output
rm -rf $BACKUP_OUTDIR
mv $OUTDIR $BACKUP_OUTDIR
cp -a $TIMESTAMPED_OUTDIR $OUTDIR

# Build the website
echo >&2 'Building and uploading the website...'
npm install
./generator/upload.js

popd >/dev/null
