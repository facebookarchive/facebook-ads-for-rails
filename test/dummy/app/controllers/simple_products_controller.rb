# Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.

class SimpleProductsController < ApplicationController
  before_action :set_simple_product, only: [:show, :edit, :update, :destroy]

  # GET /simple_products
  def index
    @simple_products = SimpleProduct.all
  end

  # GET /simple_products/1
  def show
  end

  # GET /simple_products/new
  def new
    @simple_product = SimpleProduct.new
  end

  # GET /simple_products/1/edit
  def edit
  end

  # POST /simple_products
  def create
    @simple_product = SimpleProduct.new(simple_product_params)

    if @simple_product.save
      redirect_to @simple_product, notice: 'Simple product was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /simple_products/1
  def update
    if @simple_product.update(simple_product_params)
      redirect_to @simple_product, notice: 'Simple product was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /simple_products/1
  def destroy
    @simple_product.destroy
    redirect_to simple_products_url, notice: 'Simple product was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_simple_product
      @simple_product = SimpleProduct.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def simple_product_params
      params.require(:simple_product).permit(:title, :description, :image, :brand, :price, :condition, :category, :availability)
    end
end
