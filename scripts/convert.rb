codexid=ARGV[0]
base="/Users/jcwitt/Projects/scta/scta-coordinates"
widthStandard=ARGV[1] # use "column" width or "line" width


def convert_coordfiles (base, codexid, widthStandard="column")
  cycles = []
  Dir.foreach("#{base}/#{codexid}/page/") do |item|
      # puts base
      # puts codexid
      # puts item
      if item.end_with?(".xml")
        #if item == "39v.xml" ## uncomment to convert specific page
          convert_coord_file(base, codexid, item, widthStandard)
        #end
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

def convert_coord_file (base, codexid, file, widthStandard="column")
  
  puts "Begin Coord conversion for #{file}";

  `saxon "-s:#{base}/#{codexid}/page/#{file}" "-xsl:#{base}/scripts/coordinate-converter-simpleXML.xsl" "-o:#{base}/output/simpleXmlCoordinates/#{codexid}/#{file}" "codexid=#{codexid}" "widthStandard=#{widthStandard}";`
end

useWidthStandard = widthStandard ? widthStandard : "column"
convert_coordfiles(base, codexid, useWidthStandard)
