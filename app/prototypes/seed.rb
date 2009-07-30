customer = Customer.create!(:name => "CN")
product = customer.products.create!(:name => "Studentjob")
order = product.orders.create!(:query => "student", :link_partners_per_competitor => 10)
order.competitors.create!(:domain => "www.autotrack.nl")

