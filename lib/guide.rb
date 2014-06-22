require 'restaurant'
require 'guide/config'

class Guide

  def initialize(path=nil)
    Restaurant.filepath = path
    unless Restaurant.file_exists?
      puts "File created" if Restaurant.create_file
    end
  end

  def launch!
    intro
    result = nil
    until result == :quit
      user_response = get_action
      result = perform_action(user_response)
    end
    outro
  end

  # Keep asking for user input until we get an allowed action
  def get_action
    action = nil
    actions = Guide::Config.actions
    until actions.include?(action)
      puts "Allowed actions: " + actions.join(", ") if action
      print "> "
      action = gets.chomp.downcase.strip
    end
    return action
  end

  def perform_action(action)
    case action
    when "quit"
      return :quit
    when "list"
      list
    when "find"
      puts "FIND A RESTAURANT\n\n"
      puts "Find using a key phrase  to search the restaurant list."
      puts "Examples: 'find talame', 'find Mexican', 'find mex'"
    when "add"
      add
    end
  end

  def add
    restaurant = Restaurant.build_using_questions
    save_restaurant(restaurant)
  end

  def save_restaurant(restaurant)
    if restaurant.save
      puts "Restaurant saved"
    else
      puts "Error saving restaurant"
    end
  end

  def list
    results = Restaurant.saved_restaurants
    puts "\nRestaurant Listings\n\n".upcase
    results.each do |restaurant|
      puts restaurant.name
    end
  end

  def intro
    puts "\n\n<<< Welcome to GGs Food Finder>>>\n\n"
    puts "This is an interactive guide to help you find the food you crave\n\n"
  end

  def outro
    puts "\n<<< Goodbye and Good Night!>>>\n\n\n"
  end

end
