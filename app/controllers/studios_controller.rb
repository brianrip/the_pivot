class StudiosController < ApplicationController
  def index
    @studios = Studio.where(status: 0)
  end

  def show
    @studio = Studio.find(params[:id])
  end

  def new
    @studio = Studio.new
  end

  def create
    @studio = Studio.new(studio_params)
    if @studio.save
      @studio.update(status: 2)
      current_user.update(role: 1, studio_id: @studio.id)
      flash[:success] = "Application submitted!"
      redirect_to dashboard_path
    else
      flash[:alert] = "Please fill in all application fields"
    end
  end

  def edit
  end

  private

    def studio_params
      params.require(:studio).permit(:name, :description, :promo_image)
    end
end
