#!/bin/bash

function showHelp {
  echo "Usage: generate-tests.sh <options>"
  echo "Generate temp files for testing."
  echo "Default is to regenerate changed files that differ from the master branch."
  echo "Options:"
  echo "-f | --file) <path> Generate files for the given path."
  echo "-u | --unchanged) Generate files for unchanged files."
  echo "-a | --force-all) <path> Force generation of all files."
  echo "-h | --help) Show this help message."
}

function substituteCredentials {
  srcfile=$1
  outfile=$2
  echo "Substituting credentials in $srcfile: $outfile"
  cat $srcfile | 
    sed "s#https:\/\/{{< influxdb/host >}}#$INFLUX_HOST#g;" |
    sed "s#https:\/\/INFLUX_HOST#$INFLUX_HOST#g;" |
    sed "s/API_TOKEN/$INFLUX_TOKEN/g;" |
    sed "s/DATABASE_TOKEN/$INFLUX_TOKEN/g;" |
    sed "s/INFLUX_TOKEN/$INFLUX_TOKEN/g;" |
    sed "s/BUCKET_NAME/$INFLUX_DATABASE/g;" |
    sed "s/DATABASE_NAME/$INFLUX_DATABASE/g;" |
    sed "s/INFLUX_ORG/$INFLUX_ORG/g;" \
    > $outfile
}

function generateTestFile {
  # echo "Generating test file for $1"
  file=$1
  mkdir -p $outdir
  outfile=$outdir/$(basename ${file})
  # echo "Generating $outfile"
  substituteCredentials $file $outfile
}

function process {
  srcpath=$1
  outpath=$2
  if [[ -z $srcpath ]]; then
    echo "Use the -f | --file option to specify a path. Exiting."
    exit 1
  fi
  if [[ -z $outpath ]]; then
    echo "Use the -o | --outdir option to specify an output directory. Exiting."
    exit 1
  fi
  find $srcpath -name "*.md" -type f -print0 | while IFS= read -r -d $'\0' file; do
    # git diff --quiet prevents the diff from showing and exits with 1 if there was a diff, 0 if not
    if [[ $generate_changed == 0 ]] && ! git diff --quiet master -- "$file"; then
      echo "File has changed. Regenerating $outpath/$file."
      generateTestFile $file $outpath
    elif [[ $generate_changed == 1 ]] && git diff --quiet master -- "$file"; 
    then
      echo "File has not changed. Regenerating $outpath/$file."
      generateTestFile $file $outpath
    elif [[ $generate_all == 0 ]]; then
      echo "Forcing regeneration of $outpath/$file."
      generateTestFile $file $outpath
    fi
  done
}

VALID_ARGS=$(getopt -o hf:o:ua: --long help,file:,outdir:,unchanged,force-all: -- "$@")
if [[ $? -ne 0 ]]; then
    exit 1;
fi

generate_changed=0
generate_all=1
srcpath=""
outdir="./tmp"

while [ "$1" != "" ]; do
  case "$1" in
    -h | --help)
      showHelp
      exit 0
      ;;
    -f | --file)
      echo "Generating files for '$2'"
      generate_changed=0
      srcpath=$2
      shift 2
      ;;
    -o | --outdir)
      echo "Writing files to output directory '$2'"
      outdir=$2
      shift 2
      ;;
    -u | --unchanged)
      echo "Generating unchanged files"
      generate_changed=1
      shift
      ;;
    -a | --force-all)
      echo "Forcing generation of all files"
      generate_all=0
      shift
      ;;
    \?)
      echo "Invalid option: $1" 1>&2
      showHelp
      exit 22
      ;;
    --) shift;
        break
        ;;
    esac
done

process $srcpath $outdir