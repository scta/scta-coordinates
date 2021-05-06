CODEXID=$1
start=$2
stop=$3

i=$start
while [ $i -le $stop ]
do
wget https://exist.scta.info/exist/apps/scta-app/folio-lines-xml.xq?surface_id=http://scta.info/resource/$CODEXID/${i} -O ../$CODEXID/lineText/${i}.xml || echo '<div xmlns="http://scta.info/ns/xml-lines"></div>' > ../$CODEXID/lineText/${i}.xml
i=$(($i+1))
done
i2=$start
