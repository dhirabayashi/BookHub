require 'active_record'

ActiveRecord::Base.establish_connection(
    'adapter' =>'sqlite3',
    'database' => './bookhub.db'
)

class User < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
end
