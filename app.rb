#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

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

	f = File.open './public/contacts.txt', 'a'
	f.write "User: #{@mailname}, Phone: #{@phone}, Date: #{@datetime}\n"
	f.close

	erb :message
end

get '/visit' do
	erb :visit
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

	@title = 'Thank you!'
	@message = "Dear #{@username}, we'll be waiting for you at #{@datetime}. Color: #{@color}"

	f = File.open './public/users.txt', 'a'
	f.write "User: #{@username}, Phone: #{@phone}, Barber: #{@barber}, Color: #{@color}, Date: #{@datetime}\n"
	f.close

	erb :message
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

