class RoomsController < ApplicationController
  protect_from_forgery
  before_action :authenticate_user!, except: [:index,:show,:top,:search ]
  helper_method :current_user

  def index
    @rooms = Room.all
    @q = Room.ransack(params[:q])
    @rooms = @q.result(distinct: true)
    if @rooms.count > 0
      flash.now[:alert] = "#{@rooms.count}件の検索結果"
    else
      flash.now[:alert] = "検索結果が見つかりませんでした"
    end
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    @room.user_id = current_user.id
    if @room.save
      flash[:notice] = "新規登録しました"
      redirect_to room_path(@room)
    else
      render"new"
    end
  end

  def show
    @room = Room.find(params[:id])
    @reservation = Reservation.new
  end

  def edit
    @room = Room.find(params[:id])
    if @room.user_id != current_user.id
      redirect_to room_path, alert: '編集権限がありません'
    end
  end

  def update
    @room = Room.find(params[:id])
    if @room.update(params.require(:room).permit(:roomname, :detail, :price, :address, :image, :image_cache))
    redirect_to room_path(@room)
    else
      render"edit"
    end
  end

  def search 
    if params[:area].present?
      @rooms = Room.search_area(params[:area])
      if @rooms.count > 1
        flash.now[:alert] = "#{@rooms.count}件の検索結果"
        render'index'
      else
        flash.now[:alert] = "検索結果が見つかりませんでした"
        render'index'
      end
    elsif params[:keyword].present?
      @rooms = Room.search(params[:keyword])
      if @rooms.count > 0
        flash.now[:alert] = "#{@rooms.count}件の検索結果"
        render'index'
      else
        flash.now[:alert] = "検索結果が見つかりませんでした"
        render'index'
      end
    else
      @rooms = Room.all
      flash.now[:alert] = "#{@rooms.count}件の検索結果"
        render'index'
    end  
  end

  def top
    @q = Room.ransack(params[:q])
  end

  def allroom
    @rooms = Room.where(user_id: current_user.id).order("created_at DESC")
    render'index'
  end


  private
  def room_params
    params.require(:room).permit(:user_id, :roomname, :detail, :price, :address, :image, :image_cache)
  end
end
