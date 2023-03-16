class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_response

  def index
    items = params[:user_id] ? find_user.items : Item.all
    render json: items, include: :user
  end

  def show
    item_id = params[:id]
    item = params[:user_id] ? find_user.items.find(item_id) : Item.find(item_id)
    render json: item, include: :user
  end

  def create
    item = find_user.items.create(items_params)
    render json: item, status: :created
  end

  private

  def find_user
    User.find(params[:user_id])
  end

  def items_params
    params.permit(:name, :description, :price)
  end

  def record_not_found_response
    render json: {error: "Record Not Found"}, status: :not_found
  end

end
