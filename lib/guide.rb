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
      user_response, args = get_action
      result = perform_action(user_response, args)
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
      args = gets.chomp.downcase.strip.split(' ')
      action = args.shift
    end
    return action, args
  end

  def perform_action(action, args=[])
    case action
    when "quit"
      return :quit
    when "list"
      list
      when "find"
      search_term = args.first
      find(search_term)
    when "add"
      add
    end
  end

  def add
    restaurant = Restaurant.build_using_questions
    save_restaurant(restaurant)
  end

  def find(search_term="")
    if (!search_term)
      puts "Find using a key phrase to search the restaurant list."
      puts "Examples: 'find talame', 'find Mexican', 'find mex'"
      return
    end

    restaurants = Restaurant.saved_restaurants
    filtered = restaurants.select do |rest|
      rest.name.downcase.include?(search_term.downcase) ||
      rest.cuisine.downcase.include?(search_term.downcase) ||
      rest.price.to_i <= search_term.to_i
    end

    if (filtered.empty?)
      puts "No Listings found."
    else
      puts filtered
      output_restaurants(filtered)
    end
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
    output_restaurants(results)
  end

  def output_restaurants(list)
    list.each do |rest|
      puts rest.name + " | " + rest.cuisine + " | " + rest.price
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
