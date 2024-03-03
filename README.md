# README

# Versions

ruby 2.5.8
rails 6.1.7.7 
npm 10.1.0

# To run backend (rails)
rails server


# To run frontend (vuejs)
You need to run this command from client folder. you can find client folder in root directory of the project.

npm run dev

# To run sidekiq
bundle exec sidekiq

# To setup database
I am using postgresql databse for this project.

rails db:create
rails db:migrate
rails db:seed


# Points to consider

1. First, seed data for users and products CSV files, and then proceed with the order_details CSV file. This sequence is essential as the user_id serves as a foreign key in the order table, while the product_id acts as a foreign key in the order_details table. I have stored sampple CSV files in public folder of project.

2. While seeding sample CSV data, jobs are enqueued in Sidekiq for batches of CSV rows. As the file size may increase in the future, scaling Sidekiq enables faster seeding of data.

3. When a user clicks the download button, a CSV file is generated to track order history in the public folder. The system then polls the status of the Sidekiq job to determine if the CSV file has been generated. Upon completion, the file is downloaded and subsequently deleted from the server. However, this approach is not efficient in case of heavy trafic or file size is too large. We can use s3 bucket to overcome this issue.

4. In the 'order_details.csv' file, duplicate data exists for 'user_email' and 'product_code', which are already present in the 'users' and 'products' CSV files, respectively. Storing duplicate data in database is not a good practice. To address this issue and ensure future scalability, I've implemented the 'order' and 'order details' tables, establishing associations where necessary.

Note: If the file fails to download, navigate to the orders controller and halt the deletion of the file. You can locate the file in the public folder. It's worth noting that downloads may not function as expected in certain browsers.


