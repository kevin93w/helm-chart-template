echo Printing helm output as debug spec with development values...
helm template -f .\chart\values.development.yaml --debug .\chart\ > output.txt
echo Done, check output.txt...
