module StatusesHelper
	def flash_class(type)
		case type
		when :alert
			"alert-error"
		when :notice
			"alert-success"
		else
			" "
		end
	end
	
end
