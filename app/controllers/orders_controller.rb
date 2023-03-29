class OrdersController < ApplicationController
  before_action :get_order, only: [:edit, :update, :destroy]
  before_action :get_customer_names, only: [:edit, :new]

  def get_customer_names
    @customer_names = Customer.pluck(:first_name, :id)
  end

  def get_order
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @product = Product.unscoped.find(@order.product_id)
    if @order.save!
      @order.update(total_price: @product.price  * @order.quantity )
      redirect_to active_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @product = Product.unscoped.find(@order.product_id)
    if @order.update(order_params)
      @order.update(total_price: @product.price  * @order.quantity )
      redirect_to orders_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order.destroy
    @product = Product.unscoped.find(params[:product_id])

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

