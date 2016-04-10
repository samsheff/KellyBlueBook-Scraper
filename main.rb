require 'open-uri'
require 'json'
require 'csv'

makes = JSON.parse(open("http://www.kbb.com/jsdata/3.3.56.0_55747/_makes?vehicleclass=&filterbycpo=false&filter=&priceMin=&priceMax=&categoryId=0&hasNCBBPrice=false").read)

CSV.open("makes.csv", "wb") do |csv|
  makes.each do |make|
    csv << [make["Id"], make["Name"]]
  end
end

makes.each do |make|
  models = JSON.parse(open("http://www.kbb.com/jsdata/3.3.56.0_55747/_modelsyears?vehicleclass=&makeid=#{make["Id"]}&filterbycpo=false&filter=&priceMin=&priceMax=&categoryId=0&includeDefaultVehicleId=false&includeTrims=false&hasNCBBPrice=false").read)
  CSV.open("#{make["Name"]}-Models.csv", "wb") do |csv|
    models.each do |model|
      model["Year"].each do |year|
        csv << [make["Id"], make["Name"], model["Id"], model["Name"], year]
      end
    end
  end
end

CSV.open("prices.csv", "wb") do |csv|
  1000000.times do |vehicle_id|

    pricing = JSON.parse(open("https://api.kbb.com/ads/v1/pricing/default/used/?zipcode=92064&vehicleIds=#{vehicle_id}&api_key=wayf67fx3y6z82r3vyjwcsyk&campaign-key=APIHouseAd_MazdaCX5_1115").read)["results"]
    vehicle = JSON.parse(open("https://api.kbb.com/ads/v1/vehicle?vehicleIds=#{vehicle_id}&api_key=wayf67fx3y6z82r3vyjwcsyk&campaign-key=APIHouseAd_MazdaCX5_1115").read)["results"][0]
    
    pricing.each do |match|
      match["prices"].each do |price|
        csv << [vehicle["vehicleId"], price["name"], price["id"], price["price"], price["percent"], vehicle["make"], vehicle["model"], vehicle["year"], vehicle["trim"]]         
      end
    end
  end
end

