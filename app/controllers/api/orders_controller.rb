module Api
  class OrdersController < ApplicationController
    def generate_csv
      job_id = CsvGeneratorWorker.perform_async(user_params[:user_id])

      render json: job_id
    end

    def status
      sidekiq_tracker = SidekiqTrcker.find_by(job_id:  params[:job_id])

      # Finding the use to prepare the file path.
      file_path = if sidekiq_tracker.completed?
        user = User.find(params[:user_id])

        Rails.root.join('public', "#{user&.username}_orders.csv")
      end

      render json: { status: sidekiq_tracker.status, file_path: file_path }
    end

    def delete_file
      if File.exist?(params[:file_path])
        File.delete(params[:file_path])
        render status: :ok
      else
        render status: :not_found
      end
    end

    private

    def user_params
      params.permit(:user_id)
    end

    def sidekiq_tracker_params
      params.permit(:job_id, :user_id)
    end
  end
end