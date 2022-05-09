class Book
  attr_accessor :title, :author, :length

  def assign_values(values)
    values.each_key do |k, v|
      self.send("#{k}=", values[k])
    end
  end

  def self.create_method(title)
    define_method("#{title}_details") do |arg|
      puts "This book is #{self.title} author is #{self.author} and it's length is #{self.length}"
    end
  end

  def method_missing(method_name, *_arguments)
    if method_name.to_s.include?("test")
      puts 'Now we\'re in business'
    else
      raise ArgumentError.new('This method does not exist')
    end
  end
end

book_info = {
  title: 'ForrestGump',
  author: 'Winston Groom',
  length: 300
}




book = Book.new

book.assign_values(book_info)
Book.create_method(book.title)
# pp book.ForrestGump_details("test")
# pp book
# pp book.test('abc')


class Module
  def delegar(method, to:)
    define_method(method) do |*args, &block|
      send(to).send(method, *args, &block)
    end
  end
end

class Receptionist
  def phone(name)
    puts "Hello #{name}, I've answered your call"
  end
end

class Company
  attr_reader :receptionist
  delegar :phone, to: :receptionist

  def initialize
    @receptionist = Receptionist.new
  end
end

company = Company.new
company.phone 'Leigh'