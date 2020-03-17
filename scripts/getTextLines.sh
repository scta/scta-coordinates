CODEXID=$1
start=$2
stop=$3

i=$start
while [ $i -le $stop ]
do
#wget http://localhost:8080/exist/apps/scta-app/folio-lines-xml.xq?surface_id=http://scta.info/resource/$CODEXID/${i}r -O ../$CODEXID/lineText/${i}r.xml
wget https://exist.scta.info/exist/apps/scta-app/folio-lines-xml.xq?surface_id=http://scta.info/resource/$CODEXID/${i}r -O ../$CODEXID/lineText/${i}r.xml || echo '<div xmlns="http://scta.info/ns/xml-lines"></div>' > ../$CODEXID/lineText/${i}r.xml
i=$(($i+1))
done
i2=$start
while [ $i2 -le $stop ]
do
#wget http://localhost:8080/exist/apps/scta-app/folio-lines-xml.xq?surface_id=http://scta.info/resource/$CODEXID/${i2}v -O ../$CODEXID/lineText/${i2}v.xml
wget https://exist.scta.info/exist/apps/scta-app/folio-lines-xml.xq?surface_id=http://scta.info/resource/$CODEXID/${i2}v -O ../$CODEXID/lineText/${i2}v.xml || echo '<div xmlns="http://scta.info/ns/xml-lines"></div>' > ../$CODEXID/lineText/${i2}v.xml
i2=$(($i2+1))
done
