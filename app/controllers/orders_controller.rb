class OrdersController < ApplicationController
  def new
    @order = Order.new
    customers = Customer.all
    @customer_names = []
    customers.each do |customer|
      @customer_names.push([customer.first_name, customer.id])
    end
  end

  def create
    @order = Order.new(order_params)
    products = Product.all.unscope(where: :is_active)
    @product = products.find(@order.product_id)
    if @order.save!
      product_price = @product.price 
      order_quant = @order.quantity
      @order.update(total_price: product_price * order_quant )
      redirect_to active_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @order = Order.find(params[:id])
    customers = Customer.all
    @customer_names = []
    customers.each do |customer|
      @customer_names.push([customer.first_name, customer.id])
    end
  end

  def update
    @order = Order.find(params[:id])
    products = Product.all.unscope(where: :is_active)
    @product = products.find(@order.product_id)
    if @order.update(order_params)
      product_price = @product.price 
      order_quant = @order.quantity
      @order.update(total_price: product_price * order_quant )
      redirect_to orders_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    products = Product.all.unscope(where: :is_active)
    @product = products.find(params[:product_id])

    redirect_to product_orders_path(@product), status: :see_other
  end

  def index
    @orders = Order.all.unscoped
    @products = Product.all.unscoped
    @customers = Customer.all.unscoped
    @title = params[:title].strip if params[:title]
    if @title
      @found_product = Product.find_by(title: @title)
      if @found_product
        @orders = @found_product.orders
      end
    end
    @select_status = params[:select_status] if params[:select_status]
    if @select_status
      @orders = Order.all.where(status: @select_status)
    end
  end

  private

  def order_params
    params.require(:order).permit(:quantity, :status, :customer_id, :product_id)
  end
end

