class LeasesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record_response 

  def index 
    render json: Lease.all 
  end 

  def show 
    lease = find_lease 
    render json: lease 
  end 

  def create 
    lease = Lease.create!(lease_params)
    render json: lease, status: :created 
  end 

  def update 
    lease = find_lease 
    lease.update!(lease_params)
    render json: lease, status: :accepted 
  end 

  def destroy 
    lease = find_lease 
    lease.destroy 
    head :no_content 
  end 

  private 
  def find_lease 
    Lease.find(params[:id])
  end
  
  def lease_params 
    params.permit(:rent, :tenant_id, :apartment_id)
  end 

  def render_not_found_response
    render json: {error: "Lease not found"}, status: :not_found 
  end 

  def render_invalid_record_response(exception) 
    render json: {errors: exception.record.errors.full_messages}, status: :unprocessable_entity 
  end

end
