class Empresa < ActiveRecord::Base
	has_and_belongs_to_many :usuarios
	has_many :servicios 
end
