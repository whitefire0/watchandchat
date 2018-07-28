module Socketing
  @@conn = nil
  def self.set(conn)
    @@conn = conn
  end

  def self.get
    @@conn
  end
end