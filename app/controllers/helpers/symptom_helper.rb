module Helpers::SymptomHelper
    extend ActiveSupport::Concern

    class_methods do
        def symptom_url(sym)
            sym.image.url
        end    
    end

    def symptom_response(lat, lng, sym_name)
        maps_api = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{lat},#{lng}&radius=5000&type=hospital&keyword=poli%20kulit&language=id&key=#{Rails.application.credentials.google_api[:maps]}"
        search_api = "https://www.googleapis.com/customsearch/v1?cx=4e2cd14c70ac4f2cf&q=#{sym_name}&gl=id&num=5&key=#{Rails.application.credentials.google_api[:cse]}"

        maps_res = RestClient.get(maps_api)
        search_res = RestClient.get(search_api)

        # mp_open = File.open("/home/skidi-backend/skidi-backend-api/app/controllers/maps_response.json")
        # maps_res = mp_open.read

        # sc_open = File.open("/home/skidi-backend/skidi-backend-api/app/controllers/search_response.json")
        # search_res = sc_open.read

        maps = JSON.parse(maps_res)
        search = JSON.parse(search_res)       

        symptom_response = {}
        symptom_response["data"] = {}
        symptom_response["data"] = { type: "symptom" }
        symptom_response["data"]["attributes"] = { symptom_name: sym_name }
        symptom_response["data"]["attributes"]["sources"] = []
        symptom_response["included"] = []

        search["items"].each do |res|
            data = {}
            data["title"] = res["title"]
            data["snippet"] = res["snippet"]
            data["url"] = res["formattedUrl"]
            symptom_response["data"]["attributes"]["sources"] << data
        end

        # type_hospitals = { type: "hospitals", attributes: [] }
        type_hospitals = {}
        type_hospitals["type"] = "hospitals"
        type_hospitals["attributes"] = []

        symptom_response["included"] << type_hospitals
        
        maps["results"].each do |res|
            data = {}
            uri = "https://www.google.com/maps/search/?api=1"

            data["coordinates"] = res["geometry"]["location"]
            data["name"] = res["name"]
            data["place_id"] = res["place_id"]
            data["maps_url"] = "#{uri}&query=#{res["geometry"]["location"]["lat"]},#{res["geometry"]["location"]["lng"]}&query_place_id=#{res["place_id"]}"
            
            type_hospitals["attributes"] << data
        end

        return symptom_response
    end

end