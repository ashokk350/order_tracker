
BATCH_SIZE = 1000

['users', 'products', 'orders'].each do |table_name|
	file_name = if table_name == 'orders'
		# Waiting for users and products to insert into databses first.
		sleep 10
		'order_details'
	else
		table_name
	end
 
	file_path = Rails.root.join('public', "#{file_name}.csv")
	SeedDataWorker.perform_async(table_name, file_path, BATCH_SIZE)
end


