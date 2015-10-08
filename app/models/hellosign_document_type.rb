class HellosignDocumentType < ActiveRecord::Base

  has_many :hellosign_documents

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :template_id, presence: true, uniqueness: { case_sensitive: false }
end
