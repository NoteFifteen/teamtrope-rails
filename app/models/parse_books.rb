class ParseBooks < ActiveRecord::Base

  def apple_id=(apple_id)
    super(transform_empty_to_nil(apple_id))
  end

  def asin=(asin)
    super(transform_empty_to_nil(asin))
  end

  def bnid=(bnid)
    super(transform_empty_to_nil(bnid))
  end

  def createspace_isbn=(createspace_isbn)
    super(strip_dashes(transform_empty_to_nil(createspace_isbn)))
  end

  def epub_isbn=(epub_isbn)
    super(strip_dashes(transform_empty_to_nil(epub_isbn)))
  end

  def epub_isbn_itunes=(epub_isbn_itunes)
    super(strip_dashes(transform_empty_to_nil(epub_isbn_itunes)))
  end

  def hardback_isbn=(hardback_isbn)
    super(strip_dashes(transform_empty_to_nil(hardback_isbn)))
  end

  def paperback_isbn=(paperback_isbn)
    super(strip_dashes(transform_empty_to_nil(paperback_isbn)))
  end

  def lightning_source=(lightning_source)
    super(transform_empty_to_nil(lightning_source))
  end

  def inclusion_asin=(inclusion_asin)
    super(transform_empty_to_nil(inclusion_asin))
  end

  def meta_comet_id=(meta_comet_id)
    super(transform_empty_to_nil(meta_comet_id))
  end

  # Remove dashes from the ISBN before storing
  def strip_dashes(value)
    value.gsub(/-/, '') unless value.nil?
  end

  # Make empty values nil for Postgres
  def transform_empty_to_nil stringVal
    stringVal = nil unless stringVal.nil? || stringVal.length > 0
    stringVal
  end
end
