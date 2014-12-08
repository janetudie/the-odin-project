class TagsController < ApplicationController
	before_filter :require_login, only: [:destroy]

	def index
		@tags = Tag.all
	end

	def show
  		@tag = Tag.find(params[:id])
	end

	def destroy
  		@atag = Tag.find(params[:id])
  		@tag.destroy

  		redirect_to tags_path
  	end

end
