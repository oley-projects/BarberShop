#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
	db.close
end

def is_barber_exists? db, name
	db.execute('select * from Barbers where name =?', [name]).length > 0
end

def seed_db db, barbers
	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute 'insert into Barbers (name) values (?)', [barber]
		end
	end
end

before do
	db = get_db
	@barbers = db.execute 'select * from Barbers'
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS "Users" 
		("id" INTEGER PRIMARY KEY AUTOINCREMENT,
		 "username" TEXT,
		 "phone" TEXT,
		 "datestamp" TEXT,
		 "color" TEXT )'
	db.execute 'CREATE TABLE IF NOT EXISTS "Barbers"
		("id" INTEGER PRIMARY KEY AUTOINCREMENT,
		 "name" TEXT UNIQUE,
		 "details" TEXT )'

	seed_db db, ['Walter White', 'Jessie Pinkman', 'Gus Fring', 'Mike Pington']
end

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

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@color = params[:color]

	hh = { 	:username => 'Введите имя',
			:phone => 'Введите телефон',
			:datetime => 'Введите дату и время' }

	@error = hh.select {|key,_| params[key] == ""}.values.join(". ")
	if @error != ''
		return erb :visit
	end

	db = get_db
	db.execute 'insert into Users (username, phone, datestamp, barber, color)
				values ( ?, ?, ?, ?, ?)', [@username, @phone, @datetime, @barber, @color]
	erb "<h3>Thank you, #{@username}</h3>"
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
	db = get_db
	@res = db.execute 'select * from Users order by id desc' 
	erb :showusers
end