class SymptomsController < ApplicationController
    before_action :authenticate_user!
    
    include Helpers::SymptomHelper

    def index
        symptoms = Symptom.where(user_id: params[:user_id])

        if current_user.id == params[:user_id].to_i
            render json: SymptomSerializer.new(symptoms)
        else
            render json: { error: '401 Unauthorized' }, status: 401
        end


    end

    def show
        symptom = Symptom.find(params[:id])

        options = {
            include: [:user]
        }

        if current_user.id == params[:user_id].to_i
            render json: SymptomSerializer.new(symptom, options)
        else
            render json: { error: '401 Unauthorized' }, status: 401
        end
    end

    def create
        symptom = Symptom.new(symptom_create)

        if symptom.save
            begin
                render json: symptom_response(symptom.latitude, symptom.longitude, symptom.symptom_name), status: 200
            rescue RestClient::Exceptions::OpenTimeout
                render json: { error: "Request Timeout" }, status: 408
            end
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

    def symptom_index(symptoms)
    end

    def symptom_create
        {
            image: params[:image],
            symptom_name: params[:symptom_name],
            author: current_user.full_name,
            latitude: params[:latitude],
            longitude: params[:longitude],
            user_id: current_user.id
        }
    end
    
    def show_symptom(symptom)
        {
            symptom: {
                id: symptom.id,
                symptom_name: symptom.symptom_name,
                author: symptom.author,
                url: rails_service_blob_path(filename: symptom.image.filename, signed_id: symptom.image.signed_id)
            }
        }
    end
end
