#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

get '/' do
	erb "Welcome to Barber Shop!"			
end

get '/about' do
	erb :about
end

get '/contacts' do
	erb :contacts
end

post '/contacts' do
	@mailname = params[:mailname]
	@email = params[:email]
	@text = params[:text]

	@message = "Thank you, #{@mailname}, your message sent successfully"

	#f = File.open './public/contacts.txt', 'a'
	#f.write "User: #{@mailname}, Phone: #{@phone}, Date: #{@datetime}\n"
	#f.close

	erb 'message'
end

get '/visit' do
	erb :visit
end

configure do
	db = SQLite3::Database.new 'barbershop.db'
	db.execute 'CREATE TABLE IF NOT EXISTS "Users" 
		("id" INTEGER PRIMARY KEY AUTOINCREMENT,
		 "username" TEXT,
		 "phone" TEXT,
		 "datestamp" TEXT,
		 "color" TEXT )'
end

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

	hh = { 	:username => 'Введите имя',
			:phone => 'Введите телефон',
			:datetime => 'Введите дату и время' }

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")
	if @error != ''
		return erb :visit
	end

	@db = SQLite3::Database.new 'barbershop.db'
	@db.execute 'insert into Users (username, phone, datestamp, barber, color)
				values ( ?, ?, ?, ?, ?)', [@username, @phone, @datetime, @barber, @color]

	@db.close
	erb "Thank you, #{@username}, we\'ll be waiting for you #{@datetime}"
end

get '/login' do
	erb :loginform
end

post '/login' do
	@login = params[:login]
	@password = params[:password]


	if @login == 'admin' && @password == 'secret'
		erb :admin
	else
		erb :loginform
	end
end

get '/showusers' do
  erb "Hello World"
end