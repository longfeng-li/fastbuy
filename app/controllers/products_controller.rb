class ProductsController < ApplicationController
  include CurrentCart, SearchParams
  before_action :set_cart, only: [:show]
  before_action :authenticate_seller!, except: [:show]
  before_action except: [:show ] do
    sign_out current_buyer if !current_buyer.nil?
  end
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :seller_verification, only: [:edit, :update, :destroy]
  before_action :set_search_params

  # GET /products
  # GET /products.json
  def index
    if params[:search] == nil
        @products = current_seller.products.paginate(page: params[:page], per_page: 20) if stale?([current_seller, current_seller.products.paginate(page: params[:page], per_page: 20)])
    else
      if params[:search] == 'on_sale'
        @search = Product.search do
          with(:seller_id, current_seller.id)
          with(:on_sale, true)
          paginate page: params[:page], per_page: 20
        end
      else
        @search = Product.search do
          fulltext params[:search]
          with(:seller_id, current_seller.id)
          paginate page: params[:page], per_page: 20
        end
      end
      @products = @search.results
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    fresh_when([@product, @cart, @cart.class == Cart ? @cart.line_items : nil, current_seller, current_buyer])
  end

  # GET /products/new
  def new
    @product = Product.new if stale?([current_seller, current_seller.products])
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    _has_succeeded = false
    @product.transaction do
      @product.seller_id = current_seller.id
      if @product.image.path
         @product.image_url = @product.image.url
      end
      _has_succeeded = @product.save
    end

    respond_to do |format|
      if _has_succeeded
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    begin
      @product.destroy
      rescue Exception => msg
       respond_to do |format|
         format.html { redirect_to products_url, notice: msg.message }
         format.json { head :no_content }
       end
    else 
      respond_to do |format|
        format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    def seller_verification
      if @product.seller != current_seller
        redirect_to products_path, notice: 'You are not the owner of the product.'
      end  
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:title, :description, :image_url, :price, :rating, :quantity, :image)
    end
end
