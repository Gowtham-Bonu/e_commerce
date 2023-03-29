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
    @product_hash_q = Product.joins(:orders).group("products.id").select('products.id').sum("orders.quantity")
    @product_hash_q = @product_hash_q.sort_by{|k, v|-v}.first(3).to_h.sort.to_h.keys
    @product_arr_q = Product.find(@product_hash_q)

    @customer_hash = Customer.joins(:products).distinct.select('customers.id').group('customers.id').sum("products.price")
    @customer_hash = @customer_hash.sort_by{|k, v|-v}.first(3).to_h.sort.to_h.keys
    @customer_arr = Customer.find(@customer_hash)

    @customer_hash_booked = Customer.joins(:orders).select('customers.id').group('customers.id').where('orders.status' => 'booked').count
    @customer_hash_booked = @customer_hash_booked.sort_by{|k, v|-v}.first(5).to_h.keys
    @customer_arr_booked = Customer.find(@customer_hash_booked)

    @customer_hash_cancelled = Customer.joins(:orders).select('customers.id').group('customers.id').where('orders.status' => 'canceled').count
    @customer_hash_cancelled = @customer_hash_cancelled.sort_by{|k, v|-v}.first(5).to_h.keys
    @customer_arr_cancelled = Customer.find(@customer_hash_cancelled)
  end

  private

  def product_params
    params.require(:product).permit(:title, :description, :price, :capacity, :status, :is_active)
  end
end
