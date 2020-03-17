codexid=ARGV[0]
base="/Users/jcwitt/Projects/scta/scta-coordinates"


def convert_coordfiles (base, codexid)
  cycles = []
  Dir.foreach("#{base}/#{codexid}/page/") do |item|
      # puts base
      # puts codexid
      # puts item
      if item.end_with?(".xml")
        convert_coord_file(base, codexid, item)
      end
    end
      #THREAD example. Create a new thread for each File
      #LAst time this crashed the computer
  # cycles << Thread.new do
  #     if item.end_with?(".xml")
  #       puts "starting new thread"
  #       convert_coord_file(base, codexid, item)
  #     end
  #   end
  # end
  # cycles.each{|t| t.join}
end

def convert_coord_file (base, codexid, file)

  puts "Begin Coord conversion for #{file}";

  `saxon "-s:#{base}/#{codexid}/page/#{file}" "-xsl:#{base}/scripts/coordinate-converter-simpleXML-perc-adjust.xsl" "-o:#{base}/output/simpleXmlCoordinates/#{codexid}/#{file}" "codexid=#{codexid}";`
end

convert_coordfiles(base, codexid)
