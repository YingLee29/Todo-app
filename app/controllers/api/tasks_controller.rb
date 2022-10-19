# frozen_string_literal: true

module Api
  class TasksController < ApplicationController
    def index
      authorize Task
      tasks = category.tasks.with_attached_image.ransack(search_params).result
      render json: tasks.map { |task| format_response(task) }, status: :ok
    end

    def create
      task = Task.new task_params.merge(author_id: current_user.id)
      if task.save
        render json: task, status: :created
      else
        render json: { message: task.errors.full_messages.first }, status: :unprocessable_entity
      end
    end

    def show
      render json: format_response(task)
    end

    def update
      authorize task
      if task.update task_params
        render json: format_response(task), status: :ok
      else
        render json: { message: task.errors.full_messages.first }, status: :unprocessable_entity
      end
    end

    def destroy
      task.destroy
      head :no_content, status: :ok
    end

    def update_assignee
      authorize task
      if task.update(assignee_id: params["task"]["assignee_id"])
        render json: task, status: :ok
      else
        render json: { message: task.errors.full_messages.first }, status: :unprocessable_entity
      end
    end

    private

    def task_params
      params.permit :title, :status, :image, :deadline_at, :start_at, :end_at, :schedule_type, :category_id,
                    :priority, :assignee_id
    end

    def category
      @category ||= Category.find params[:category_id]
    end

    def task
      @task ||= Task.find params[:id]
    end

    def search_params
      {
        title_cont: params[:title],
        priority_eq: params[:priority],
        status_eq: params[:status],
        s: "id desc"
      }
    end

    def format_response(task)
      task.as_json.merge(image_url: task.image_url)
    end
  end
end
