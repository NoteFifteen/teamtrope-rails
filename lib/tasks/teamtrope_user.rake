namespace :teamtrope do
  desc "User Import Fix"
  task user_import_fix: :environment do


    $imported_user_hash = {}

    total = 2
    user_restore_list = Rails.root.join('db', 'seed-data', 'user_restore_list.csv')
    require "csv"
    csv = CSV.parse(File.read(user_restore_list), headers: :first_row)
    csv.each do | import_user |


      puts "#{import_user['ID']},#{import_user['user_login']},#{import_user['user_email']},#{import_user["roles"]},#{import_user["Role(s)"]}\n"
      #User.create!(uid: import_user['ID'], name: import_user['user_login'], email: import_user['user_email'])

      user = User.where(id: total, uid: import_user['ID'],
        name: import_user['display_name'],
        nickname: import_user['user_nicename'],
        email: import_user['user_email'],
        provider: 'wordpress_hosted').first_or_create

      # user = User.where(email: import_user['email']).first

      # user ||= User.create!(
      #   uid: import_user['ID'],
      #   name: import_user['display_name'],
      #   nickname: import_user['user_nicename'],
      #   email: import_user['user_email'],
      #   provider: 'wordpress_hosted'
      #   )

      roles = import_user["Role(s)"].downcase.gsub(/ /, '_').split('::')
      roles << 'project_manager' if roles.include? "book_manager"
      user.roles = roles

      user.build_profile if user.profile.nil?
      user.save

      $imported_user_hash[user.uid] = user

      total = total + 1
    end

    puts "finished importing users."

    puts "Creating TeamMemberships"

    projects_xml_file = Rails.root.join('db', 'seed-data', 'projects.xml')

    require 'nokogiri'
    # parsing the uploaded xml file
    doc = Nokogiri::XML(File.open(projects_xml_file))

    # getting the list of items
    items = doc.xpath("//item")

    items.each_with_index do | item, index |
      next if item.xpath('./wp:status').text == 'trash'
      project = Project.find_by_wp_id(item.xpath("./wp:post_id").text)
      create_team_memberships project, item
    end

  end

  # pct_label is an override most role percents are key + '_pct' the pct_label
  # is for overriding the few cases where it's not
  $wp_rails_role_map = {
    'book_author' => { percent: 33.0, role_name: 'Author'},
    'book_marketing_manager' => { percent: 20.0, role_name: 'Book Manager', pct_label: 'book_manager_pct'},
    'book_cover_designer' => { percent: 4.0, role_name: 'Cover Designer', pct_label: 'book_designer_pct'},
    'book_editor' => { percent: 7.0, role_name: 'Editor'},
    'book_project_manager' => { percent: 4.0, role_name: 'Project Manager'},
    'book_proofreader' => { percent: 2.0, role_name: 'Proofreader'},
  }


  def create_team_memberships(project, item)
    #looping through the team member hash
    $wp_rails_role_map.each do | key, tm_hash |
      wp_member_role = fetch_field_value item, key
      # Most corresponding percents for roles from wp are role_name + _pct
      # :pct_label is the override for the outliers
      wp_member_role_pct = fetch_field_value item, (tm_hash.has_key? :pct_label)? tm_hash[:pct_label] : "#{key}_pct"

      ttr_role = Role.where(name: tm_hash[:role_name]).first

      unless ttr_role.nil?
        # wp_member_role can either be an array or a string depending if there are multiple
        # convert single entries to an array so we can loop through.
        wp_member_role = [wp_member_role] unless wp_member_role.class == Array

        wp_member_role.each do | member_id |
          next if member_id.nil? || member_id.to_i < 1
          member = $imported_user_hash[member_id]
          unless member.nil?
            tm = project.team_memberships.build(member: member, role: ttr_role, percentage: wp_member_role_pct.nil?? tm_hash[:percent] : wp_member_role_pct.to_f)
            tm.save
            puts "created team_membership #{member.uid}, #{member.email}"
          else
            #puts " type: 'TeamMembership::MissingUser', message: nil user #{member_id} project: #{project.title}role: #{ttr_role.name}"
          end
        end
        #@errors.push "role info: #{item.xpath("./wp:post_id").text}\t#{wp_member_role}\t#{wp_member_role_pct}\t#{item.xpath("./title").text}"
      else
        puts " type: 'TeamMembership::UnmappableRole', message: Unmappable role: #{tm_hash[:role_name]} project: #{project.title} "
      end
    end
  end

  def deserialize_php_array(serialized_data)
    results = Array.new
    serialized_data.scan(/i:([0-9])+;s:([0-9]+):\"(.+?)\";/).each do | match |
      results.push match[2]
    end
    results
  end

  # fetches the value given the key from a wordpress xml export.
  # fields that are lists are often converted to a serialized php array.
  # Deserialize will deserialze the array into an array of strings.
  def fetch_field_value(item, key, deserialize = true)
    value = item.xpath("./wp:postmeta/wp:meta_key[text() = '#{key}']/following-sibling::wp:meta_value/text()").text
    # check if we need to deserialize array
    if deserialize && value =~ /a:[0-9]+:{i:([0-9]+);s:([0-9]+):\"(.*?)\";}/
      value = deserialize_php_array value
    end
    value
  end

end
