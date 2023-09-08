function showHelp {
  echo "Usage: generate.sh <options>"
  echo "Commands:"
  echo "-c) Regenerate changed files. To save time in development, only regenerates files that differ from the master branch."
  echo "-h) Show this help message."
}

generate_changed=0
generate_all=1

while getopts "hc" opt; do
  case ${opt} in
    h)
      showHelp
      exit 0
      ;;
    u)
      # Generate unchanged files
      generate_changed=1
      ;;
    f)
      # Force generation of all files
      generate_all=0
      ;;
    \?)
      echo "Invalid option: $OPTARG" 1>&2
      showHelp
      exit 22
      ;;
    :)
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      showHelp
      exit 22
      ;;
    esac
done

srcpath=$1
outdir="./tmp"

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
    file=$1
    mkdir -p $outdir
    outfile=$outdir/$(basename ${file})
    echo "Generating $outfile"
    substituteCredentials $file $outfile
}

find $srcpath -name "*.md" -type f -print0 | while IFS= read -r -d $'\0' file; do
  # git diff --quiet prevents the diff from showing and exits with 1 if there was a diff, 0 if not
  if [[ $generate_changed == 0 ]] && ! git diff --quiet master -- "$file"; then
    generateTestFile $file
  fi
done
