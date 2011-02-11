# extend the base Model class

class Sequel::Model
  def before_create
    self.created_at ||= Time.now if self.respond_to?(:created_at)
    super
  end
end
