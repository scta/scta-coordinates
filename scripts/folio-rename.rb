def folio_count_increase(current_surface) # e.g. 13-v
  current_folio = current_surface.split("-").first
  current_side = current_surface.split("-").last
  if current_side == "r"
    current_side = "v"
  elsif current_side == "v"
    current_side = "r"
    current_folio = current_folio.to_i + 1
  end
  return "#{current_folio}-#{current_side}"
end


start_surface = ARGV[0]
current_surface = start_surface
Dir.glob('../penn/page/*.xml').each do |file|
  puts current_surface
  current_surface_minus_dash = current_surface.gsub("-", '')
  File.rename(file, "../penn/page/#{current_surface_minus_dash}.xml")
  current_surface = folio_count_increase(current_surface)
end
