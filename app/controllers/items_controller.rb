class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found
  
  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
      return render json: items, except: [:created_at, :updated_at], status: :ok
    else
      items = Item.all
      return render json: items, include: { user: { except: [:created_at, :updated_at] }}, 
      except: [:created_at, :updated_at, :user_id], status: :ok
    end
  end

  def show
    item = Item.find(params[:id])
    render json: item, status: :ok
  end

  def create 
    item = Item.create(item_params)
    render json: item, except: [:created_at, :updated_at], status: :created
  end

  private

  def item_params
    params.permit(:name, :description, :price, :user_id)
  end

  def render_record_not_found
    render json: {error: "Record not found"}, status: :not_found
  end

end
