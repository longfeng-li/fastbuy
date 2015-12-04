class StoreController < ApplicationController
  SORT_TYPE = { "title" => :title, "price" => :price, "quantity" => :quantity, "rating" => :rating}
  include CurrentCart, CurrentSales, SearchParams
  before_action :set_cart
  before_action :set_search_params

  def index
    expires_in 3.minutes, public: true, must_revalidate: true
    if params[:search] == nil
      @products = Product.paginate(page: params[:page], per_page: 20) if stale?([Product.paginate(page: params[:page], per_page: 20), @cart.class == Cart ? @cart.line_items : nil, current_seller, current_buyer])
     else
      if @search_param == 'on_sale'
        @search = Product.search(include: [:sale_products]) do
          with(:on_sale, true)
          paginate page: params[:page], per_page: 20
        end
      else
        @search = Product.search do
          fulltext params[:search]
          paginate page: params[:page], per_page: 20
        end
      end
      @products = @search.results
    end
    get_sales
  end
  
  def sort
    @sort_type = SORT_TYPE[params[:sort]]
    if stale?([Product.order(@sort_type).paginate(page:params[:page], per_page:20), @cart.class == Cart ? @cart.line_items : nil, current_seller, current_buyer]) 
      @products = Product.order(@sort_type).paginate(page: params[:page], per_page:20)
      get_sales
      render 'index'
    end
  end

end

