class String
  def blank?
    self == '' or self.nil?
  end
end

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


class Hash
  # Return a new hash with all keys converted to strings.
  def stringify_keys
    dup.stringify_keys!
  end

  # Destructively convert all keys to strings.
  def stringify_keys!
    keys.each do |key|
      self[key.to_s] = delete(key)
    end
    self
  end

  # Return a new hash with all keys converted to symbols, as long as
  # they respond to +to_sym+.
  def symbolize_keys
    dup.symbolize_keys!
  end

  # Destructively convert all keys to symbols, as long as they respond
  # to +to_sym+.
  def symbolize_keys!
    self.keys.each do |key|
      if self[key].is_a? Hash
        self[key].symbolize_keys!
      end
      self[(key.to_sym rescue key) || key] = delete(key)
    end
    self
  end
end
