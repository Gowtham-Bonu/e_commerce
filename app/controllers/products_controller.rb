class ProductsController < ApplicationController
  before_action :get_unscoped_product, only: [:update, :edit, :destroy]

  def get_unscoped_product
    @product = Product.unscoped.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def index
    @products = Product.all.unscoped
  end

  def active
    @products = Product.all
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      redirect_to products_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy

    redirect_to products_path, status: :see_other
  end

  def edit
  end

  def show
    @product = Product.find(params[:id])
  end

  def filter


    @product_arr_q = Product.joins(:orders).group("products.id").select('products.id, products.title, SUM(orders.quantity) AS qu, products.description, products.price, products.capacity, products.status, products.is_active').order('qu DESC').limit(3).collect{|arr| {id: arr.id, title: arr.title, description: arr.description, price: arr.price, capacity: arr.capacity, status: arr.status, is_active: arr.is_active}}

    @product_arr_p = Product.joins(:orders).group("products.id").select('products.id, products.title, SUM(orders.total_price) AS pri, products.description, products.price, products.capacity, products.status, products.is_active').order('pri DESC').limit(3).collect{|arr| {id: arr.id, title: arr.title, description: arr.description, price: arr.price, capacity: arr.capacity, status: arr.status, is_active: arr.is_active}}

    @customer_arr_booked = Customer.joins(:orders).group('customers.id').where('orders.status' => 'booked').select('customers.id', 'COUNT(orders.status) as cu', 'customers.first_name', 'customers.last_name', 'customers.email', 'customers.phone_number').order('cu DESC').limit(5).collect{|arr| {id: arr.id, first_name: arr.first_name,  last_name: arr.last_name,  email: arr.email,  phone_number: arr.phone_number}}  

    @customer_arr_cancelled = Customer.joins(:orders).group('customers.id').where('orders.status' => 'canceled').select('customers.id', 'COUNT(orders.status) as cu', 'customers.first_name', 'customers.last_name', 'customers.email', 'customers.phone_number').order('cu DESC').limit(5).collect{|arr| {id: arr.id, first_name: arr.first_name,  last_name: arr.last_name,  email: arr.email,  phone_number: arr.phone_number}}
  end

  private

  def product_params
    params.require(:product).permit(:title, :description, :price, :capacity, :status, :is_active)
  end
end
