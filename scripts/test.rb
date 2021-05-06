require 'open-uri'
require 'json'
require 'cgi'

codexid=ARGV[0]
request_uri = 'https://sparql-docker.scta.info/ds/query?query='
#request_uri = 'http://localhost:3030/ds/query?query='
query = query = "SELECT ?canvas ?image_service ?s ?p ?o 
WHERE {
   <http://scta.info/resource/#{codexid}> <http://scta.info/property/hasSurface> ?s .
     ?s <http://scta.info/property/hasCanonicalISurface> ?is  .
     ?is <http://scta.info/property/hasCanvas> ?canvas  .
     ?canvas ?p ?o
    # ?canvas <http://iiif.io/api/presentation/2#hasImageAnnotations> ?bn .
    # ?bn <http://www.w3.org/1999/02/22-rdf-syntax-ns#first> ?anno .
    # ?anno <http://www.w3.org/ns/oa#hasBody> ?resource .
    # ?resource <http://rdfs.org/sioc/services#has_service> ?image_service .
}"

url = "#{request_uri}#{CGI.escape(query)}"


data  = open(url).read
results = JSON.pretty_generate(JSON.parse(data))
puts results

