require 'csv'

class SeedDataWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

  def perform(table_name, file_path, batch_size = 1000)
  	return unless File.exist?(file_path)

		file = File.open(file_path)
		headers = file.first

		# This will enqueue one sidekiq workder for one batche.
	  file.lazy.each_slice(batch_size) do |csv_rows|
	    RecordInsertionWorker.perform_async(table_name, headers, csv_rows)
	  end
  end
end