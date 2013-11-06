module AlbumsHelper
	def album_thumbnail(album)
		if album.pictures.count > 0 
			iamge_tag(album.pictures.first.assert.url(:small))
		else
			image_tag(" http://1.bp.blogspot.com/-AJvXsfYgMME/T384eUBl8iI/AAAAAAAAAEI/FSrDFoPnm1Q/s1600/Kittens+&+Puppies+11_05_ccnan.jpg")
		end
	end
end


