require 'open-uri'
require 'json'
require 'cgi'

codexid=ARGV[0]
request_uri = 'https://sparql-docker.scta.info/ds/query?query='
#request_uri = 'http://localhost:3030/ds/query?query='
query = "SELECT ?canvas ?image_service ?s
  WHERE {
	   <http://scta.info/resource/#{codexid}> <http://scta.info/property/hasSurface> ?s .
	    ?s <http://scta.info/property/hasCanonicalISurface> ?is  .
	    ?is <http://scta.info/property/hasCanvas> ?canvas  .
	    ?canvas <http://iiif.io/api/presentation/2#hasImageAnnotations> ?bn .
      ?bn <http://www.w3.org/1999/02/22-rdf-syntax-ns#first> ?anno .
      ?anno <http://www.w3.org/ns/oa#hasBody> ?resource .
      ?resource <http://rdfs.org/sioc/services#has_service> ?image_service .
}"

url = "#{request_uri}#{CGI.escape(query)}"


data  = open(url).read
results = JSON.parse(data)

map = {}
results["results"]["bindings"].each do |r|

  canvas = r["canvas"]["value"]
  is = r["image_service"]["value"]
  s = r["s"]["value"]
  map[canvas] = {is: is, s: s}
end


mapElements = ""
map.each do |c, i|
  xml = "  <pair>\n    <canvas>#{c}</canvas>\n    <image>#{i[:is]}</image>\n    <surfaceId>#{i[:s]}</surfaceId>\n  </pair>\n"
  mapElements = mapElements + xml
end
output = "<?xml version='1.0' encoding='UTF-8'?>\n<images xmlns='http://scta.info/ns/canvas-image-map'>\n#{mapElements}</images>"

File.write("/Users/jcwitt/Projects/scta/scta-coordinates/#{codexid}/imageCanvasMap.xml", output)
