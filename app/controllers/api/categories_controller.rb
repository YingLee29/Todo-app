# frozen_string_literal: true

module Api
  class CategoriesController < ApplicationController
    def index
      categories = Category.all
      render json: categories, status: :ok
    end

    def create
      category = Category.new(category_params)
      if category.save
        render json: category, status: :created
      else
        render json: { message: category.errors.full_messages.first }, status: :unprocessable_entity
      end
    end

    def show
      render json: category, status: :ok
    end

    def update
      if category.update category_params
        render json: category, status: :ok
      else
        render json: { message: category.errors.full_messages.first }, status: :unprocessable_entity
      end
    end

    def destroy
      category.destroy
      head :no_content
    end

    private

    def category_params
      params.permit :name
    end

    def category
      @category ||= Category.find params[:id]
    end
  end
end
