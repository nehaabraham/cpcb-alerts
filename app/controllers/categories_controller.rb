class CategoriesController < ApplicationController
  def index
    @categories = Category.all.order(:name)
  end

  def show
    @category = Category.find(params[:id])
    @events = Event.where(:category_id => @category.id)
  end

  private

    def category_params
      params.require(:category).permit(:name)
    end

end
