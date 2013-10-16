class MoviesController < ApplicationController

  def show
    id     = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
  end

  def index
    @all_ratings = Movie.ratings.sort # Get all distinct ratings through sql query
    session[:sort_by] ||= 'title' # session sorting hash
    session[:ratings] ||= @all_ratings # session ratings hash
    session[:sort_by] = (params[:sort].blank? ? session[:sort_by] : params[:sort]) # if sort_param is blank, sort by previous, else by param
    session[:ratings] = (params[:ratings].blank? ? session[:ratings] : params[:ratings].keys) # if filter is blank, filter by previous, else by param
    @movies = Movie.where(:rating => session[:ratings]).order("#{session[:sort_by]} ASC") # declare movies as Movie filtered by session and ordered by session
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie         = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def console_log(statement)
    p "=============================================="
    p "                Begin Log                     "
    p "=============================================="
    p statement
    p "=============================================="
  end


end
