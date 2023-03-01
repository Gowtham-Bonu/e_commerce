class CustomersController < ApplicationController
    def new
      @customer = Customer.new
    end
  
    def index
      @customers = Customer.all
    end
  
    def create
      @customer = Customer.new(customer_params)
      if @customer.save
        redirect_to customers_path
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    def update
      @customer = Customer.find(params[:id])
  
      if @customer.update(customer_params)
        redirect_to customers_path
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @customer = Customer.find(params[:id])
      @customer.destroy
  
      redirect_to customers_path, status: :see_other
    end
  
    def edit
      @customer = Customer.find(params[:id])
    end
  
    private
  
    def customer_params
      params.require(:customer).permit(:first_name, :last_name, :email, :phone_number)
    end
end
  
