def convert_num_to_filio(number)
  folnum = ""
  if number.even?
    number = (number / 2) - 22
    folnum = "#{number}v"
  else
    number = (number / 2) - 21 # doesn't need to be -7.5 because ruby is doing integer division and therefore not returning a fractional remainder
    folnum = "#{number}r"
  end
  return folnum
end


counter = 166 # when counter is 698 folio = 348v, when counter 699 folio = 348r
changeDirectory = "/Users/jcwitt/Projects/scta/scta-coordinates/paris1512/alto/"
#changeDirectory = "/Users/jcwitt/Documents/research/manuscripts/cod-AAssXX_images2/"

Dir.glob("#{changeDirectory}*.xml").each do |file|
  fileNumber = file.split(changeDirectory)[1].split(".xml")[0]
    newFolioNumber = convert_num_to_filio(fileNumber.to_i)
    #puts fileNumber
    #puts newFolioNumber
    

    
  if (fileNumber.to_i >= counter && fileNumber.to_i <= 351)
    File.rename(file, "#{changeDirectory}#{newFolioNumber}.xml")
    puts "===="
    puts newFolioNumber
    puts fileNumber
  else
    #File.rename(file, "#{changeDirectory}f#{fileNumber}.jpg")
    puts fileNumber
    puts counter
  end
end
