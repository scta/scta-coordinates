codexid=$1
base="/Users/jcwitt/Projects/scta/scta-coordinates/output/simpleXmlCoordinates"

echo $base/$codexid
rsync -avh $base/$codexid "/Volumes/db/apps/simpleXmlCoordinates/"
