class Restaurant

  @@filepath = nil

  def self.filepath=(path=nil)
    @@filepath = File.join(APP_ROOT, path)
  end

  attr_accessor :name, :cuisine, :price

  def self.file_exists?
    return false unless @@filepath
    return false unless File.exist?(@@filepath)
    return true
  end

  def self.file_useable?
    return false unless @@filepath
    return false unless File.exist?(@@filepath)
    return false unless File.readable?(@@filepath)
    return false unless File.writable?(@@filepath)
    return true
  end

  def self.create_file
    File.open(@@filepath, "w") unless file_exists?
    return file_useable?
  end

  def self.saved_restaurants
    # we could set @@restaurants so that we don't read from file each time
    # considerations are other people working on the file at the same time etc.
    restaurants = []
    if !file_useable?
      restaurants
    end

    file = File.new(@@filepath, 'r')
    file.each_line do |line|
      restaurant = Restaurant.new.import_line(line.chomp)
      restaurants << restaurant
    end
    file.close
    restaurants
  end

  def self.build_using_questions
    puts "\nAdds a restaurant\n\n".upcase
    args = {}

    print "Restaurant name: "
    args[:name] = gets.chomp

    print "Cuisine type: "
    args[:cuisine] = gets.chomp

    print "Average price: "
    args[:price] = gets.chomp

    self.new(args)
  end

  def initialize(args={})
    @name = args[:name] || ""
    @cuisine = args[:cuisine] || ""
    @price = args[:price] || ""
  end

  def import_line(line)
    @name, @cuisine, @price = line.split("\t")
    self
  end

  def save
    return false unless Restaurant.file_useable?
    File.open(@@filepath, "a") do |file|
      file.puts "#{[@name, @cuisine, @price].join("\t")}\n"
    end
    return Restaurant.file_useable?
  end

end