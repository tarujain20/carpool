# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

User.create!(:first_name => "Julia", :last_name => "R", :email => "juliar@example.com", :password => "password", :password_confirmation => "password")
RideOffer.create!(:origin => "San Jose", :destination => "North Fork", :total_seat => 1, :date => 7.day.from_now.to_date)
RideOffer.create!(:origin => "San Jose", :destination => "Kelseyville", :total_seat => 1, :date => 7.day.from_now.to_date)

