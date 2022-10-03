class ApartmentsController < ApplicationController 
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record_response 

  def index 
    render json: Apartment.all 
  end 

  def show 
    apartment = find_apartment 
    render json: apartment
  end 

  def create 
    apartment = Apartment.create!(apartment_params) 
    render json: apartment, status: :created 
  end 

  def update 
    apartment = find_apartment 
    apartment.update!(apartment_params) 
    render json: apartment, status: :accepted 
  end 

  def destroy 
    apartment = find_apartment 
    apartment.leases.destroy_all 
    apartment.destroy 
    head :no_content
  end 

  private 
  def find_apartment 
    Apartment.find(params[:id]) 
  end 

  def apartment_params 
    params.permit(:number)
  end 

  def render_not_found_response
    render json: {error: "Apartment not found"}, status: :not_found 
  end 

  def render_invalid_record_response(exception) 
    render json: {errors: exception.record.errors.full_messages}, status: :unprocessable_entity 
  end 

end
