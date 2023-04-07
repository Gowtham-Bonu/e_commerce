class CustomersController < ApplicationController
  before_action :find_customer, only: [:edit, :update, :destroy]

  def index
    @customers = Customer.all
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      redirect_to customers_path, notice: "you have successfully created a customer"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @customer.update(customer_params)
      redirect_to customers_path, notice: "you have successfully updated the customer"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @customer.destroy
      redirect_to customers_path, status: :see_other, notice: "you have successfully deleted the customer"
    else
      redirect_to customers_path, status: :unprocessable_entity, alert: "The delete action didn't work.."
    end
  end

  private

  def find_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :phone_number)
  end
end
