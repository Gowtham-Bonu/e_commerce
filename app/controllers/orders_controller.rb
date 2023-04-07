class OrdersController < ApplicationController
  before_action :get_order, only: [:edit, :update, :destroy]

  before_action :get_customer_names, only: [:edit, :new]

  def index
    @products = Product.all.unscoped
    @customers = Customer.all.unscoped
    if params[:title] or params[:select_status]
      if params[:title]
        product = Product.find_by(title: params[:title].strip)
        if product
          @orders = product.orders
        else
          @orders = []
        end
      else
        @orders = Order.where(status: params[:select_status])
      end
    else
      @orders = Order.all.unscoped
    end
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    product = Product.unscoped.find(@order.product_id)
    if @order.save
      @order.update(total_price: product.price * @order.quantity )
      redirect_to active_products_path, notice: "you have successfully created a product"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    @product = Product.unscoped.find(@order.product_id)
    if @order.update(order_params)
      @order.update(total_price: @product.price  * @order.quantity )
      redirect_to orders_path, notice: "you have successfully updated a product"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product = Product.unscoped.find(params[:product_id])
    if @order.destroy
      redirect_to product_orders_path(@product), status: :see_other, notice: "you have successfully deleted the employee"
    else
      redirect_to product_orders_path(@product), status: :unprocessable_entity, alert: "The delete action didn't work.."
    end
  end

  private

  def get_customer_names
    @customer_names = Customer.pluck(:first_name, :id)
  end

  def get_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:quantity, :status, :customer_id, :product_id)
  end
end