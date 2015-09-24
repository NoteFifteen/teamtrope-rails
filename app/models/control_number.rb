class ControlNumber < ActiveRecord::Base
  # A control number is used to track the various identifiers used for a book amongst various marketplaces
  # and is associated with a given project.  The table stores all know variations of a control number in
  # a single row.  This data is also used to interface with and update similar records in Parse.
  belongs_to :project

  def epub_isbn=(isbn)
    super(strip_dashes(isbn))
  end

  def epub_isbn
    add_dashes_to_isbn(super)
  end

  def hardback_isbn=(isbn)
    super(strip_dashes(isbn))
  end

  def hardback_isbn
    add_dashes_to_isbn(super)
  end

  def paperback_isbn=(isbn)
    super(strip_dashes(isbn))
  end

  def paperback_isbn
    add_dashes_to_isbn(super)
  end


  private

  # Remove dashes from the ISBN before storing
  def strip_dashes(value)
    value.gsub(/-/, '') unless value.nil?
  end

  # Add dashes to an ISBN number, like 9781620150320 to 978-1-62015-032-0
  def add_dashes_to_isbn(isbn)
    # Length should always be 13
    if !isbn.nil? && isbn.length == 13
      m = isbn.match(/(\d{3})(\d)(\d{5})(\d{3})(\d)/)
      isbn = "#{m[1]}-#{m[2]}-#{m[3]}-#{m[4]}-#{m[5]}"
    end

    isbn
  end

end
