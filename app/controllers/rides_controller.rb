class RidesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ride, only: [:show, :edit, :update, :destroy]
  before_action :owned_ride, only: [:edit, :update, :destroy]  

  # GET /rides
  # GET /rides.json
  # GET / rides.xml
  def index
    @rides = Ride.all
    
    #http://api.rubyonrails.org/classes/ActionController/MimeResponds.html
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @rides }
      format.json { render :json => @rides }
    end
  end

  # GET /rides/1
  # GET /rides/1.json
  # GET /rides/1.xml
  def show
    #http://guides.rubyonrails.org/layouts_and_rendering.html#using-render
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @ride }
      format.json { render :json => @ride }
    end
  end

  # GET /rides/new
  def new
    @ride = current_user.rides.build
  end
  

  # GET /rides/1/edit
  def edit
  end
  
  
  # POST /rides
  # POST /rides.json
  def create

    @ride = current_user.rides.build(ride_params)
    get_distance(@ride)

    respond_to do |format|
      if @ride.save
        format.html { 
          flash[:success] = "Your ride has been created!"
          redirect_to root_path
          #redirect_to @ride, notice: 'Ride was successfully created.' 
          }
        format.json { render :show, status: :created, location: @ride }
      else
        format.html { 
          flash[:alert] = "Your new ride couldn't be created! Please check the form"
          render :new }
        format.json { render json: @ride.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rides/1
  # PATCH/PUT /rides/1.json
  def update
    respond_to do |format|
      get_distance(@ride)
      if @ride.update(ride_params)
        format.html { 
          flash[:success] = "Ride updated."
          redirect_to root_path }
        format.json { render :show, status: :ok, location: @ride }
      else
        format.html { 
          flash[:alert] = "Update failed.  Please check the form."
          render :edit }
        format.json { render json: @ride.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rides/1
  # DELETE /rides/1.json
  def destroy
    @ride.destroy
    respond_to do |format|
      format.html { 
        flash[:success] = "Your ride has been deleted."
        redirect_to root_path }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ride
      @ride = Ride.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ride_params
      params.require(:ride).permit(:from, :to, :date, :time, :distance)
    end
  
    def owned_ride  
      unless current_user == @ride.user
        flash[:alert] = "That ride doesn't belong to you!"
        redirect_to root_path
      end
    end  
  
  def get_distance(ride)
    response = HTTParty.get("http://maps.googleapis.com/maps/api/directions/json?origin=#{ride.from}&destination=#{ride.to}")
    body = JSON.parse(response.body) 
    distance_meters = body['routes'][0]['legs'][0]['distance']['value']
    ride.distance = distance_meters/1000
  end
  
end
