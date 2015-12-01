class ControlNumber < ActiveRecord::Base
  # A control number is used to track the various identifiers used for a book amongst various marketplaces
  # and is associated with a given project.  The table stores all know variations of a control number in
  # a single row.  This data is also used to interface with and update similar records in Parse.
  belongs_to :project

  validates_uniqueness_of :apple_id, :asin, :bnid, :epub_isbn, :encore_asin, :hardback_isbn, :paperback_isbn, :parse_id, :allow_nil => true

  def bnid=(bnid)
    if bnid.nil? || bnid.length == 0
      super(nil)
    else
      super(bnid)
    end
  end

  def epub_isbn=(isbn)
    if isbn.nil? || isbn.length == 0
      super(nil)
    else
      super(strip_dashes(isbn))
    end
  end

  def epub_isbn
    add_dashes_to_isbn(super)
  end

  def hardback_isbn=(isbn)
    if isbn.nil? || isbn.length == 0
      super(nil)
    else
      super(strip_dashes(isbn))
    end
  end

  def hardback_isbn
    add_dashes_to_isbn(super)
  end

  def paperback_isbn=(isbn)
    if isbn.nil? || isbn.length == 0
      super(nil)
    else
      super(strip_dashes(isbn))
    end
  end

  def paperback_isbn
    add_dashes_to_isbn(super)
  end

  def asin=(asin)
    if asin.nil? || asin.length == 0
      super(nil)
    else
      super(asin)
    end
  end

  def encore_asin=(asin)
    if asin.nil? || asin.length == 0
      super(nil)
    else
      super(asin)
    end
  end

  def apple_id=(asin)
    if asin.nil? || asin.length == 0
      super(nil)
    else
      super(asin)
    end
  end

  def parse_id=(parse_id)
    if parse_id.nil? || parse_id.length == 0
      super(nil)
    else
      super(parse_id)
    end
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
