class CategoryController < ApplicationController
	def add
	@category=Category.new()
	case request.method
	when :post
	@category=Category.find(params[:category])
	@category.accept=false
	if @category.save
	flash[:notice] = "New category added"
	else
	flash[:error] = "Failed to add category"
	end	
	end
	end
	def show_events_category
	end
	def accept
	end
protected
	def delete
	end


end
