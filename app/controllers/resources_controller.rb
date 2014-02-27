# require 'bitly'
class ResourcesController < ApplicationController
    before_filter :authenticate_user!, only:[:new, :create, :edit, :update, :destroy]

  def new
    roadmap = Roadmap.find(params[:roadmap_id])
    @new_position = roadmap.resources.length + 1
    @resource = Resource.new()
  end

  def create
    roadmap = Roadmap.find(params[:roadmap_id])
    new_resource = roadmap.resources.create(resource_params)
    
    client = Bitly.client
    bitly_url = client.shorten(new_resource.url)
    # short_url is a method for bitly gem
    new_resource.short_url = bitly_url.short_url
    new_resource.save
    
    redirect_to roadmap_resource_path(roadmap, new_resource)
  end

  def edit
    @roadmap = Roadmap.find(params[:roadmap_id])
    @resource = @roadmap.resources.find(params[:id])
  end

  def update
    roadmap = Roadmap.find(params[:roadmap_id])
    resource = roadmap.resources.find(params[:id])
    resource.update(resource_params)
    redirect_to roadmap_resource_path(roadmap, resource)

  end

  def show
    @roadmap = Roadmap.find(params[:roadmap_id])
    @resource = @roadmap.resources.find(params[:id])
  end

  def destroy
    roadmap = Roadmap.find(params[:roadmap_id])
    roadmap.resources.find(params[:id]).destroy
    redirect_to roadmap_path(roadmap)

  end

  private

  def resource_params
    params.require(:resource).permit(:name, :url, :description, :attachment, :image, :position_id, :short_url)
  end  
  
end
