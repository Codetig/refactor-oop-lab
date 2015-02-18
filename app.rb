require 'pry'
require 'sinatra'
require 'better_errors'
require 'sinatra/reloader'
require 'pg'

require './models/squad'
require './models/student'

set :conn, PG.connect( dbname: 'weekendlab' )

before do
  @conn = settings.conn
  Squad.conn = @conn
  Student.conn = @conn
end

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

# SQUAD ROUTES

get '/' do
  redirect '/squads'
end

get '/squads' do
  @squads = Squad.all
  erb :'squads/index'
end

get '/squads/new' do
  erb :'squads/add'
end

get '/squads/:id' do
  @squad = Squad.find params[:id].to_i 

  erb :'squads/show'
end

get '/squads/:id/edit' do
  @squad = Squad.find params[:id].to_i
  erb :'squads/edit'
end

post '/squads' do
  Squad.create params
  redirect '/squads'
end

put '/squads/:id' do
  s = Squad.find(params[:id].to_i)
  s.name = params[:name]
  s.mascot = params[:mascot]
  s.save
  redirect '/squads'
end

delete '/squads/:id' do
  Squad.find(params[:id].to_i).destroy
  redirect '/squads'
end

# STUDENT ROUTES

get '/squads/:squad_id/students' do
  @students = Squad.find(params[:squad_id].to_i).students
  erb :'students/index'
end

get '/squads/:squad_id/students/new' do
  @squad_id = params[:squad_id].to_i
  erb :'students/add'
end

get '/squads/:squad_id/students/:student_id' do
  @student = Student.stFind params[:student_id]
  erb :'students/show'
end

get '/squads/:squad_id/students/:student_id/edit' do
  @student = Student.stFind params[:student_id].to_i
  erb :'students/edit'
end

post '/squads/:squad_id/students' do
  Student.create params
  redirect "/squads/#{params[:squad_id].to_i}"
end

put '/squads/:squad_id/students/:student_id' do
  st = Student.stFind params[:student_id].to_i
  st.name = params[:name]
  st.age = params[:age]
  st.spirit_animal = params[:spirit]
  st.squad_id = params[:squad_id]
  st.stSave

  redirect "/squads/#{params[:squad_id].to_i}"
end

delete '/squads/:squad_id/students/:student_id' do
  Student.stFind(params[:student_id].to_i).stDestroy
  redirect "/squads/#{params[:squad_id].to_i}"
end
