class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if !params[:ratings] and session[:ratings]
      redir = true
    else 
      session[:ratings] = params[:ratings]
    end
    if !params[:sortby] and session[:sortby]
      redir = true
    else
      session[:sortby] = params[:sortby]
    end

    if redir
      redirect_to movies_path ({ :sortby => session[:sortby], :ratings => session[:ratings]})
    end


    @all_ratings = Movie.all_ratings
    if params[:ratings]
      @selected_ratings = params[:ratings].respond_to?('keys') ? params[:ratings].keys : params[:ratings]
    else 
      @selected_ratings = @all_ratings
    end
    @sortby = params[:sortby]
    if @sortby
      @movies = Movie.all(:conditions => [ "rating IN (?)", @selected_ratings], :order => @sortby)
    else
      @movies = Movie.all(:conditions => [ "rating IN (?)", @selected_ratings])
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
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

end
