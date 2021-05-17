class SymptomsController < ApplicationController

    def show
        symptom = Symptom.find(params[:id])
        render json: show_symptom(symptom), status: 200
    end
    
    def create
        symptom = Symptom.new(create_params)
        
        if symptom.save
            render json: "Sukses", status: 200
        else
            render json: "Gagal", status: :unprocessable_entity
        end
    end

    def image 
        symptom = Symptom.find(params[:id])

        if symptom.image.attached?
            redirect_to rails_blob_url(symptom.image)
        else
            head :not_found
        end
    end

    private

    def create_params
        params.permit(:name, :image)
    end
    
    def show_symptom(symptom)
        {
            symptom: {
                name: symptom.name,
                author: "Ghaniy",
                url: symptom.image.url
            }
        }
    end
end
