#!/bin/sh

helpFunction()
{
  echo ""
  echo "Usage: $0 -c config -p proto -o output ..."
  echo -e "\t-c The path to the test json file."
  echo -e "\t-p The path to the proto file."
  echo -e "\t-o The output format."
  echo ""
  echo -e "httpie options(if needed)"
  echo -e "\t-h The hostname, port and api path of the ghz-web server."
  exit 1 # Exit script after printing help
}

while getopts "c:h:o:p:" opt
do
  case "$opt" in
    c ) configFile="$OPTARG" ;;
    h ) httpOptions="$OPTARG" ;;
    o ) outFormat="$OPTARG" ;;
    p ) protoFile="$OPTARG" ;;
    ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
  esac
done

# Print helpFunction in case parameters are empty
if [ -z "$configFile" ] || [ -z "$outFormat" ] || [ -z "$protoFile" ]; then
  echo "Some or all of the obligatory parameters are empty!";
  helpFunction
elif [ -z "$httpOptions" ]; then
  /go/bin/ghz --config=./$configFile --proto=./$protoFile -O $outFormat
else
  /go/bin/ghz --config=./$configFile --proto=./$protoFile -O $outFormat | http POST $httpOptions
fi
