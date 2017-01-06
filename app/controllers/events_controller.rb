class EventsController < ApplicationController
  before_action :require_admin, except: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    #@events = Event.where('datetime > ? ', DateTime.now).order('time ASC')
    @events = Event.all
  end

  def show
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.create(event_params)
    if @event.save
      flash[:success] = "#{@event.title} was successfully created"
      redirect_to event_path(@event.id)
    else
      flash[:danger] = "Something went wrong when creating the event"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      flash[:success] = "#{@event.title} was successfully updated"
      redirect_to event_path(@event)
    else
      render 'edit'
    end
  end

  def destroy
    if @event.destroy
      flash[:success] = "The event was successfully destroyed"
      redirect_to events_path
    else
      flash[:danger] = "Something went wrong while deleting the event"
      render 'show'
    end
  end

  def require_admin
    if !current_user.admin?
      flash[:notice] = "You do not have the admin rights to perform that action"
      redirect_to events_path
    end
  end

  private

    def event_params
      params.require(:event).permit(:title, :datetime, :location, :description)
    end

    def set_event
      @event = Event.find(params[:id])
    end
end
