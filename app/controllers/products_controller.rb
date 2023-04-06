class ProductsController < ApplicationController
  before_action :get_all_products, only: [:update, :edit, :destroy]

  def index
    @products = Product.all.unscoped
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: "you have successfully created a product"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      redirect_to products_path, notice: "you have successfully updated the product"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.destroy
      redirect_to products_path, status: :see_other, notice: "you have successfully deleted the product"
    else
      redirect_to products_path, status: :unprocessable_entity, alert: "The action didn't work.."
    end
  end

  def active
    @products = Product.all
  end

  def filter
    @product_arr_q = Product.joins(:orders).group("products.id").select('products.id, products.title, SUM(orders.quantity) AS qu, products.description, products.price, products.capacity, products.status, products.is_active').order('qu DESC').limit(3)
    @product_arr_p = Product.joins(:orders).group("products.id").select('products.id, products.title, SUM(orders.total_price) AS pri, products.description, products.price, products.capacity, products.status, products.is_active').order('pri DESC').limit(3)
    @customer_arr_booked = Customer.joins(:orders).group('customers.id').where('orders.status' => 'booked').select('customers.id', 'COUNT(orders.status) as cu', 'customers.first_name', 'customers.last_name', 'customers.email', 'customers.phone_number').order('cu DESC')
    @customer_arr_cancelled = Customer.joins(:orders).group('customers.id').where('orders.status' => 'canceled').select('customers.id', 'COUNT(orders.status) as cu', 'customers.first_name', 'customers.last_name', 'customers.email', 'customers.phone_number').order('cu DESC').limit(5)
  end

  private

  def get_all_products
    @product = Product.unscoped.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:title, :description, :price, :capacity, :status, :is_active)
  end
end
