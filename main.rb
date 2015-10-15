require "open-uri"  
require "nokogiri"  
require "csv"
require "json"

brands = {
    "Acura" => ["MDX", "RDX", "RL", "TL", "TSX"], 
    
    "Aston Martin" => ["DB9", "Vantage"], "Audi" => ["A3", "A4", "A6", "A8", "Q7", "RS 4", "S4", "S6", "S8"], 
    
    "Bentley" => ["Arnage", "Azure", "Continental"], 
    
    "BMW" => ["3-Series", "5-Series", "6-Series", "7-Series", "Alpina-B7", "M5", "M6", "X3", "X5", "Z4", "Z4-M"], 
    
    "Buick" => ["LaCrosse", "Lucerne", "Rainier", "Rendezvous", "Terraza"], 
    
    "Cadillac" => ["CTS", "DTS", "Escalade", "Escalade-ESV", "Escalade-EXT", "SRX", "STS", "XLR"], 
    
    "Chevrolet" => ["Avalanche", "Aveo", "Cobalt", "Colorado-Crew-Cab", "Colorado-Extended-Cab", "Colorado-Regular-Cab",
              "Corvette", "Equinox", "Express-1500-Cargo", "Express-1500-Passenger", "Express-2500-Cargo", "Express-2500-Passenger", 
              "Express-3500-Cargo", "Express-3500-Passenger", "HHR", "Impala", "Malibu", "Monte-Carlo", "Silverado-(Classic)-1500-Crew-Cab", 
              "Silverado-(Classic)-1500-Extended-Cab", "Silverado-(Classic)-1500-HD-Crew-Cab", "Silverado-(Classic)-1500-Regular-Cab", 
              "Silverado-(Classic)-2500-HD-Crew-Cab", "Silverado-(Classic)-2500-HD-Extended-Cab", "Silverado-(Classic)-2500-HD-Regular-Cab",
              "Silverado-(Classic)-3500-Crew-Cab", "Silverado-(Classic)-3500-Extended-Cab", "Silverado-(Classic)-3500-Regular-Cab", 
              "Silverado-1500-Crew-Cab", "Silverado-1500-Extended-Cab", "Silverado-1500-Regular-Cab", "Silverado-2500-HD-Crew-Cab",
              "Silverado-2500-HD-Extended-Cab", "Silverado-2500-HD-Regular-Cab", "Silverado-3500-HD-Crew-Cab", "Silverado-3500-HD-Extended-Cab", 
              "Silverado-3500-HD-Regular-Cab", "Suburban-1500", "Suburban-2500", "Tahoe", "TrailBlazer", "Uplander-Cargo", "Uplander-Passenger"], 
   
     "Chrysler" => ["300", "Aspen", "Crossfire", "Pacifica", "PT-Cruiser", "Sebring", "Town-&-Country"], 
   
    "Dodge" => ["300", "Aspen", "Crossfire", "Pacifica", "PT-Cruiser", "Sebring", "Town-&-Country"], 
   
    "Ferrari" => ["599 GTB Fiorano", "612 Scaglietti", "F430"],
   
    "Ford" => ["Crown-Victoria", "E150-Super-Duty-Cargo", 
              "E150-Super-Duty-Passenger", "E250-Super-Duty-Cargo", "E350-Super-Duty-Cargo", "E350-Super-Duty-Passenger", "Edge", "Escape", 
              "Expedition", "Expedition-EL", "Explorer", "Explorer-Sport-Trac", "F150-Regular-Cab", "F150-Super-Cab", "F150-SuperCrew-Cab", 
              "F250-Super-Duty-Crew-Cab", "F250-Super-Duty-Regular-Cab", "F250-Super-Duty-Super-Cab", "F350-Super-Duty-Crew-Cab", 
              "F350-Super-Duty-Regular-Cab", "F350-Super-Duty-Super-Cab", "Five-Hundred", "Focus", "Freestar-Cargo", "Freestar-Passenger", 
              "Freestyle", "Fusion", "Mustang", "Ranger-Regular-Cab", "Ranger-Super-Cab", "Taurus"], 
   
    "GMC" => ["Acadia", "Canyon-Crew Cab", "Canyon-Extended Cab", "Canyon-Regular Cab", "Envoy", "Savana-1500 Cargo", 
              "Savana-1500 Passenger", "Savana-2500 Cargo", "Savana-2500 Passenger", "Savana-3500 Cargo", "Savana-3500 Passenger",
              "Sierra-(Classic) 1500 Crew Cab", "Sierra-(Classic) 1500 Extended Cab", "Sierra-(Classic) 1500 HD Crew Cab", 
              "Sierra-(Classic) 1500 Regular Cab", "Sierra-(Classic) 2500 HD Crew Cab", "Sierra-(Classic) 2500 HD Extended Cab",
              "Sierra-(Classic) 2500 HD Regular Cab", "Sierra-(Classic) 3500 Crew Cab", "Sierra-(Classic) 3500 Extended Cab",
              "Sierra-(Classic) 3500 Regular Cab", "Sierra-1500 Crew Cab", "Sierra-1500 Extended Cab", "Sierra-1500 Regular Cab",
              "Sierra-2500 HD Crew Cab", "Sierra-2500 HD Extended Cab", "Sierra-2500 HD Regular Cab", "Sierra-3500 HD Crew Cab", 
              "Sierra-3500 HD Extended Cab", "Sierra-3500 HD Regular Cab", "Yukon", "Yukon-XL 1500", "Yukon-XL 2500"], 
    "Honda" => ["Accord", "Civic", "CR-V", "Element", "Fit", "Odyssey", "Pilot", "Ridgeline", "S2000"], 
   
    "Hyundai" => ["Accent", "Azera", "Elantra", "Equus", "Genesis", "Genesis-Coupe", "Santa-Fe", "Santa-Fe Sport", "Sonata", "Tucson",
                  "Veloster"], "Infiniti" => ["EX", "FX", "G", "M", "QX"],

    "Jeep" => ["Commander", "Compass", "Grand-Cherokee", "Liberty", "Patriot", "Wrangler"],

    "Kia" => ["Forte", "Optima", "Rio", "Rondo", "Sedona", "Soul", "Sportage"],
   
    "Mazda" => ["CX-7", "CX-9", "MAZDA3", "MAZDA5", "MAZDA6", "MX-5-Miata", "RX-8", "Tribute"],
   
    "Scion" => ["tC", "xB", "xD"], 
   
    "Subaru" => ["Forester", "Impreza", "Legacy", "Outback", "Tribeca"],
   
    "Toyota" => ["4Runner", "Avalon", "Camry", "Corolla", "FJ-Cruiser", "Highlander", "Land-Cruiser", "Matrix", "Prius", "RAV4",
                 "Sequoia", "Sienna", "Tacoma-Access-Cab", "Tacoma-Double-Cab", "Tacoma-Regular-Cab", "Tundra-CrewMax",
                 "Tundra-Double-Cab", "Tundra-Regular-Cab", "Venza", "Yaris"]
}

years = (1992..2015)
mileages = (0..25).map{ |v| 10000 + v*5000 }

styles = []
data = {}
brands.each_pair do |brand, models|
  data[brand] = {}
  models.each do |model|
    model.gsub!(/\s/, '-')
    data[brand][model] = {}
    years.each do |year|  
      data[brand][model][year] = {}
        begin
          styles_doc = Nokogiri::HTML(open("http://www.kbb.com/#{brand}/#{model}/#{year}-#{brand}-#{model}/styles/?pricetype=trade-in&amp;anchor=true&amp;mileage=20000"))
          styles_doc.css(".style-name").each { |a| styles << a.text.gsub(/(\r|\n|\s{2,})*/, '').gsub(/\s/, '-').downcase unless a.text.include? "Not Sure" }
          puts "Availible Styles: #{styles.to_s}"
        styles.each do |model_type|
          data[brand][model][year][model_type] = {}
          mileages.each do |mileage|
            sleep 2
            doc = Nokogiri::HTML(open("http://www.kbb.com/#{brand}/#{model}/#{year}-#{brand}-#{model}/#{model_type}/?pricetype=trade-in&amp;anchor=true&amp;mileage=#{mileage}"))
            data[brand][model][year][model_type][mileage] = doc.css("#out-wrap > script:nth-child(16)").text
            puts "year: #{year} mileage: #{mileage} style: #{model_type.gsub(/-/, " ")} value: #{JSON.parse("{#{data[brand][model][year][model_type][mileage].scan(/("price":\s\d+\.\d*)/)[3].first}}")['price']}"
          end
        end
        rescue
      end
    end

  end
end

puts data.to_json

File.open("kbb.json","w") do |f|
  f.write(data.to_json)
end
