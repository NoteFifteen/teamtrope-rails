class NetgalleySubmission < ActiveRecord::Base
  belongs_to :project

  after_initialize :custom_init

  delegate :imprint_name, to: :project, allow_nil: true

  alias :imprint :imprint_name

  CATEGORIES = [
    "Arts & Photography",
    "Biographies & Memoirs",
    "Business & Investing",
    "Children's Fiction",
    "Children's Nonfiction",
    "Christian",
    "Comics & Graphic",
    "Computers & Internet",
    "Cooking, Food & Wine",
    "Crafts & Hobbies",
    "Entertainment",
    "Erotica",
    "General Fiction (Adult)",
    "Health, Mind & Body",
    "History",
    "Home & Garden",
    "Horror",
    "Humor",
    "LGBTQIA",
    "Literary Fiction",
    "Middle Grade",
    "Mystery & Thrillers",
    "New Adult",
    "Nonfiction (Adult)",
    "Outdoors & Nature",
    "Parenting & Families",
    "Poetry",
    "Politics",
    "Professional & Technical",
    "Reference",
    "Religion & Spirituality",
    "Romance",
    "Sci Fi & Fantasy",
    "Science",
    "Self-Help",
    "Sports",
    "Teens & YA",
    "Travel",
    "Women's Fiction"
  ]

  def custom_init
    return if project.nil?

    self.title ||= project.book_title
    self.author_name ||= project.authors.first.try(:member).try(:name)
    self.retail_price ||= project.try(:publication_fact_sheet).try(:ebook_price)
    self.publication_date ||= project.try(:published_file).try(:publication_date)
    self.isbn ||= project.try(:control_number).try(:epub_isbn)
    self.blurb ||= project.try(:draft_blurb).try(:draft_blurb)
    self.book_manager ||= project.book_managers.map{ |tm| tm.member.name}.join(", ")
  end
end
