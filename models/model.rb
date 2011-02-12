# extend the base Model class

class Sequel::Model
  
  # set created_at
  def before_create
    self.created_at ||= Time.now if self.respond_to?(:created_at)
    super
  end
  
  # set updated_at
  def before_save
    self.updated_at = Time.now if self.respond_to?(:updated_at)
    super
  end
end
