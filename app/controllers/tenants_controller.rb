class TenantsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record_response
  
  def index 
    render json: Tenant.all 
  end 

  def show 
    tenant = find_tenant 
    render json: tenant
  end 

  def create 
    tenant = Tenant.create!(tenant_params)
    render json: tenant, status: :created 
  end 

  def update 
    tenant = find_tenant 
    tenant.update 
    render json: tenant, status: :accepted
  end 

  def destroy 
    tenant = find_tenant 
    tenant.leases.destroy_all 
    tenant.destroy 
    head :no_content 
  end 

  private 

  def find_tenant 
    Tenant.find(params[:id])
  end 

  def tenant_params 
    params.permit(:name, :age)
  end 

  def render_not_found_response
    render json: {error: "Tenant not found"}, status: :not_found 
  end 

  def render_invalid_record_response(exception) 
    render json: {errors: exception.record.errors.full_messages}, status: :unprocessable_entity 
  end

end
