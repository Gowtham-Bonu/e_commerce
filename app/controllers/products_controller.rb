class ProductsController < ApplicationController
  def new
    @product = Product.new
  end

  def index
    @products = Product.all.unscope(where: :is_active)
    @product = @products.first
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
    products = Product.all.unscope(where: :is_active)
    @product = products.find(params[:id])
    if @product.update(product_params)
      redirect_to products_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    products = Product.all.unscope(where: :is_active)
    @product = products.find(params[:id])
    @product.destroy

    redirect_to products_path, status: :see_other
  end

  def edit
    products = Product.all.unscope(where: :is_active)
    @product = products.find(params[:id])
  end

  def show
    @product = Product.find(params[:id])
  end

  def filter
    @product_hash_q = Product.joins(:orders).group("products.id").select('products.id').sum("orders.quantity")
    @product_hash_q = @product_hash_q.sort_by{|k, v|-v}.first(3).to_h.sort.to_h
    @product_arr_q = []
    @product_hash_q.each do |k, v|
      @product_arr_q.push(Product.find(k))
    end
    @customer_hash = Customer.joins(:products).distinct.select('customers.id').group('customers.id').sum("products.price")
    @customer_hash = @customer_hash.sort_by{|k, v|-v}.first(3).to_h.sort.to_h
    @customer_arr = []
    @customer_hash.each do |k, v|
      @customer_arr.push(Customer.find(k))
    end
    @customer_hash_booked = Customer.joins(:orders).select('customers.id').group('customers.id').where('orders.status' => 'booked').count
    @customer_hash_booked = @customer_hash_booked.sort_by{|k, v|-v}.first(5).to_h
    @customer_arr_booked = []
    @customer_hash_booked.each do |k, v|
      @customer_arr_booked.push(Customer.find(k))
    end
    @customer_hash_cancelled = Customer.joins(:orders).select('customers.id').group('customers.id').where('orders.status' => 'canceled').count
    @customer_hash_cancelled = @customer_hash_cancelled.sort_by{|k, v|-v}.first(5).to_h
    @customer_arr_cancelled = []
    @customer_hash_cancelled.each do |k, v|
      @customer_arr_cancelled.push(Customer.find(k))
    end
  end

  private

  def product_params
    params.require(:product).permit(:title, :description, :price, :capacity, :status, :is_active)
  end
end
