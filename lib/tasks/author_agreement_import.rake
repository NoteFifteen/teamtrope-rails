namespace :teamtrope do

  desc 'Create Author Agreement Queue'
  task hydrate_author_agreements: :environment do
    require "csv"
    author_agreements = Rails.root.join('db', 'seed-data', 'author_agreements.csv')
    csv = CSV.parse(File.read(author_agreements), headers: :first_row)
    i = 0

    csv.each do |row|
      next if row['ID'].nil? || row['Need?'] || row['File'] =~ /^AA -.*? - .*?/
      next if row['ID'].empty?

      AuthorAgreementQueue.create(
        status: 0,
        nickname: row['ID'],
        file: row['File']
      )

    end
  end

  desc 'Import Author Agreements'
  task import_author_agreements: :environment do

    require "net/https"
    require "uri"

    job_queue = Booktrope::JobQueue.new
    job_queue.workers_count = Figaro.env.thread_count || 3

    contract_url_prefix = "https://teamtrope.com/wp-content/uploads/2016/05/"


    i = 0

    AuthorAgreementQueue.where.not(status: 99).each do |item|

      nickname = item.nickname

      user = User.find_by_nickname nickname
      # TODO think about how to capture the output of this operation.
      if user.nil?
        puts "User not found: #{nickname}"
        next
      end

      document_url = "#{contract_url_prefix}#{item.file.gsub(/ /,'-').gsub(/---/,'-').gsub(/'/, '')}"

      author_role = Role.find_by_name "Author"

      job_queue.add_task(lambda { |thread_id|

        puts "#{thread_id}: checking #{document_url}"
        document_uri = check_url document_url

        unless document_uri.nil?
          puts "#{thread_id}: found: #{document_uri}"
          signers = [user.id]

          sleep 1
          begin
            TeamMembership.joins(:project).includes(:project)
                    .where(member_id: user.id, role_id: author_role.id)
                    .distinct.map(&:project).each do |project|
              puts "#{thread_id}: uploading contract to #{project.id}"

              imported_contract = project.imported_contracts.build(
                                              document_type: 'author_agreement',
                                              document_signers: signers,
                                              document_date: Date.today)

              imported_contract.contract = document_uri
              imported_contract.save
              sleep 2
            end
            puts "#{thread_id}: saved"
            item.update_attributes status: 99
          rescue StandardError => e
            puts e.message
          end
        end
      })
      # break if i > 50
      i += 1
    end

    ActiveRecord::Base.connection_pool.with_connection do
      job_queue.perform_blocks
    end
  end

  def check_url(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)

    # If we get a 200 response back from teamtrope, store the URL
    if response.code == '200'
      uri
    else
      puts "url not found #{url}"
      nil
    end
  end
end
