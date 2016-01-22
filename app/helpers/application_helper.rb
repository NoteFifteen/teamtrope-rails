# coding: utf-8
module ApplicationHelper
  def full_title(page_title)
    base_title = "Teamtrope"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do | builder |
        render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def self.scribd_prepare_isbn(control_number)

    return ["",""] if control_number.nil?

    ebook_isbn = control_number.epub_isbn
    ebook_isbn ||= ""
    parent_isbn = control_number.paperback_isbn
    parent_isbn ||= ""


    [parent_isbn.gsub(/-/, ''), ebook_isbn.gsub(/-/, '')]

  end

  def self.prepare_bisac_code(bisac_code, bisac_code_name)
    #project.publication_fact_sheet.bisac_code_one.gsub(/#{bisac_code_one}/, "")
    results =
    {
      code: bisac_code,
      name: bisac_code_name
    }
    if bisac_code_name.nil?
      if bisac_code =~ /([A-Z]{3}[0-9]{6})/
        results[:code] = $1
      else
        results[:code] = ""
      end
      results[:name] = bisac_code
    end
    results
  end

  def self.filter_special_characters(text)
    text.gsub(/"/, "\"")
          .gsub(/\r\n/, " ")
          .gsub(/\n/, " ")
          .gsub(/\u201c|\u201d|\u201e/, "\"")     # smart double quote
          .gsub(/\u2018|\u2019|\u201A|\uFFFD/, "'") # smart single quote
          .gsub( /\u02C6/, '^' )
          .gsub( /\u2039/, '<' )
          .gsub( /\u203A/, '>' )
          .gsub( /\u2013/, '-' )
          .gsub( /\u2014/, '--' )
          .gsub( /\u2026/, '...' )
          .gsub( /\u00A9/, '(c)' )
          .gsub( /\u00AE/, '(r)' )
          .gsub( /\u2122/, 'TM' )
          .gsub( /\u00BC/, '1/4' )
          .gsub( /\u00BD/, '1/2' )
          .gsub( /\u00BE/, '3/4' )
          .gsub(/[\u02DC|\u00A0]/, " ")
  end


  def self.lookup_library_pricing(ebook_price)
    if ebook_price >= 0 && ebook_price < 0.99
      "$1.50"
    elsif ebook_price <= 0.99 && ebook_price < 1.99
      "$2.50"
    elsif ebook_price <= 1.99 && ebook_price < 2.99
      "$3.50"
    elsif ebook_price <= 2.99 && ebook_price < 3.99
      "$5.45"
    elsif ebook_price <= 3.99 && ebook_price < 4.99
      "$6.75"
    elsif ebook_price <= 4.99 && ebook_price < 5.99
      "$7.95"
    elsif ebook_price <= 5.99 && ebook_price < 6.99
      "$9.25"
    elsif ebook_price <= 6.99 && ebook_price < 7.99
      "$10.50"
    elsif ebook_price <= 7.99 && ebook_price < 8.99
      "$11.95"
    elsif ebook_price <= 8.99 && ebook_price < 9.99
      "$13.25"
    elsif ebook_price >= 9.99 && ebook_price < 14.50
      "$14.50"
    elsif ebook_price > 14.50
      ("$%.2f" % ebook_price)
    else
      ""
    end
  end

  # List of countries for any Country selection
  def countries_list
    [
        ['Afghanistan', 'Afghanistan'],
        ['Albania', 'Albania'],
        ['Algeria', 'Algeria'],
        ['American Samoa', 'American Samoa'],
        ['Andorra', 'Andorra'],
        ['Angola', 'Angola'],
        ['Antigua and Barbuda', 'Antigua and Barbuda'],
        ['Argentina', 'Argentina'],
        ['Armenia', 'Armenia'],
        ['Australia', 'Australia'],
        ['Austria', 'Austria'],
        ['Azerbaijan', 'Azerbaijan'],
        ['Bahamas', 'Bahamas'],
        ['Bahrain', 'Bahrain'],
        ['Bangladesh', 'Bangladesh'],
        ['Barbados', 'Barbados'],
        ['Belarus', 'Belarus'],
        ['Belgium', 'Belgium'],
        ['Belize', 'Belize'],
        ['Benin', 'Benin'],
        ['Bermuda', 'Bermuda'],
        ['Bhutan', 'Bhutan'],
        ['Bolivia', 'Bolivia'],
        ['Bosnia and Herzegovina', 'Bosnia and Herzegovina'],
        ['Botswana', 'Botswana'],
        ['Brazil', 'Brazil'],
        ['Brunei', 'Brunei'],
        ['Bulgaria', 'Bulgaria'],
        ['Burkina Faso', 'Burkina Faso'],
        ['Burundi', 'Burundi'],
        ['Cambodia', 'Cambodia'],
        ['Cameroon', 'Cameroon'],
        ['Canada', 'Canada'],
        ['Cape Verde', 'Cape Verde'],
        ['Cayman Islands', 'Cayman Islands'],
        ['Central African Republic', 'Central African Republic'],
        ['Chad', 'Chad'],
        ['Chile', 'Chile'],
        ['China', 'China'],
        ['Colombia', 'Colombia'],
        ['Comoros', 'Comoros'],
        ['Congo, Democratic Republic of the', 'Congo, Democratic Republic of the'],
        ['Congo, Republic of the', 'Congo, Republic of the'],
        ['Costa Rica', 'Costa Rica'],
        ["Côte d'Ivoire", "Côte d'Ivoire"],
        ['Croatia', 'Croatia'],
        ['Cuba', 'Cuba'],
        ['Cyprus', 'Cyprus'],
        ['Czech Republic', 'Czech Republic'],
        ['Denmark', 'Denmark'],
        ['Djibouti', 'Djibouti'],
        ['Dominica', 'Dominica'],
        ['Dominican Republic', 'Dominican Republic'],
        ['East Timor', 'East Timor'],
        ['Ecuador', 'Ecuador'],
        ['Egypt', 'Egypt'],
        ['El Salvador', 'El Salvador'],
        ['Equatorial Guinea', 'Equatorial Guinea'],
        ['Eritrea', 'Eritrea'],
        ['Estonia', 'Estonia'],
        ['Ethiopia', 'Ethiopia'],
        ['Fiji', 'Fiji'],
        ['Finland', 'Finland'],
        ['France', 'France'],
        ['French Polynesia', 'French Polynesia'],
        ['Gabon', 'Gabon'],
        ['Gambia', 'Gambia'],
        ['Georgia', 'Georgia'],
        ['Germany', 'Germany'],
        ['Ghana', 'Ghana'],
        ['Greece', 'Greece'],
        ['Greenland', 'Greenland'],
        ['Grenada', 'Grenada'],
        ['Guam', 'Guam'],
        ['Guatemala', 'Guatemala'],
        ['Guinea', 'Guinea'],
        ['Guinea-Bissau', 'Guinea-Bissau'],
        ['Guyana', 'Guyana'],
        ['Haiti', 'Haiti'],
        ['Honduras', 'Honduras'],
        ['Hong Kong', 'Hong Kong'],
        ['Hungary', 'Hungary'],
        ['Iceland', 'Iceland'],
        ['India', 'India'],
        ['Indonesia', 'Indonesia'],
        ['Iran', 'Iran'],
        ['Iraq', 'Iraq'],
        ['Ireland', 'Ireland'],
        ['Israel', 'Israel'],
        ['Italy', 'Italy'],
        ['Jamaica', 'Jamaica'],
        ['Japan', 'Japan'],
        ['Jordan', 'Jordan'],
        ['Kazakhstan', 'Kazakhstan'],
        ['Kenya', 'Kenya'],
        ['Kiribati', 'Kiribati'],
        ['North Korea', 'North Korea'],
        ['South Korea', 'South Korea'],
        ['Kosovo', 'Kosovo'],
        ['Kuwait', 'Kuwait'],
        ['Kyrgyzstan', 'Kyrgyzstan'],
        ['Laos', 'Laos'],
        ['Latvia', 'Latvia'],
        ['Lebanon', 'Lebanon'],
        ['Lesotho', 'Lesotho'],
        ['Liberia', 'Liberia'],
        ['Libya', 'Libya'],
        ['Liechtenstein', 'Liechtenstein'],
        ['Lithuania', 'Lithuania'],
        ['Luxembourg', 'Luxembourg'],
        ['Macedonia', 'Macedonia'],
        ['Madagascar', 'Madagascar'],
        ['Malawi', 'Malawi'],
        ['Malaysia', 'Malaysia'],
        ['Maldives', 'Maldives'],
        ['Mali', 'Mali'],
        ['Malta', 'Malta'],
        ['Marshall Islands', 'Marshall Islands'],
        ['Mauritania', 'Mauritania'],
        ['Mauritius', 'Mauritius'],
        ['Mexico', 'Mexico'],
        ['Micronesia', 'Micronesia'],
        ['Moldova', 'Moldova'],
        ['Monaco', 'Monaco'],
        ['Mongolia', 'Mongolia'],
        ['Montenegro', 'Montenegro'],
        ['Morocco', 'Morocco'],
        ['Mozambique', 'Mozambique'],
        ['Myanmar', 'Myanmar'],
        ['Namibia', 'Namibia'],
        ['Nauru', 'Nauru'],
        ['Nepal', 'Nepal'],
        ['Netherlands', 'Netherlands'],
        ['New Zealand', 'New Zealand'],
        ['Nicaragua', 'Nicaragua'],
        ['Niger', 'Niger'],
        ['Nigeria', 'Nigeria'],
        ['Norway', 'Norway'],
        ['Northern Mariana Islands', 'Northern Mariana Islands'],
        ['Oman', 'Oman'],
        ['Pakistan', 'Pakistan'],
        ['Palau', 'Palau'],
        ['Palestine', 'Palestine'],
        ['Panama', 'Panama'],
        ['Papua New Guinea', 'Papua New Guinea'],
        ['Paraguay', 'Paraguay'],
        ['Peru', 'Peru'],
        ['Philippines', 'Philippines'],
        ['Poland', 'Poland'],
        ['Portugal', 'Portugal'],
        ['Puerto Rico', 'Puerto Rico'],
        ['Qatar', 'Qatar'],
        ['Romania', 'Romania'],
        ['Russia', 'Russia'],
        ['Rwanda', 'Rwanda'],
        ['Saint Kitts and Nevis', 'Saint Kitts and Nevis'],
        ['Saint Lucia', 'Saint Lucia'],
        ['Saint Vincent and the Grenadines', 'Saint Vincent and the Grenadines'],
        ['Samoa', 'Samoa'],
        ['San Marino', 'San Marino'],
        ['Sao Tome and Principe', 'Sao Tome and Principe'],
        ['Saudi Arabia', 'Saudi Arabia'],
        ['Senegal', 'Senegal'],
        ['Serbia and Montenegro', 'Serbia and Montenegro'],
        ['Seychelles', 'Seychelles'],
        ['Sierra Leone', 'Sierra Leone'],
        ['Singapore', 'Singapore'],
        ['Slovakia', 'Slovakia'],
        ['Slovenia', 'Slovenia'],
        ['Solomon Islands', 'Solomon Islands'],
        ['Somalia', 'Somalia'],
        ['South Africa', 'South Africa'],
        ['Spain', 'Spain'],
        ['Sri Lanka', 'Sri Lanka'],
        ['Sudan', 'Sudan'],
        ['Sudan, South', 'Sudan, South'],
        ['Suriname', 'Suriname'],
        ['Swaziland', 'Swaziland'],
        ['Sweden', 'Sweden'],
        ['Switzerland', 'Switzerland'],
        ['Syria', 'Syria'],
        ['Taiwan', 'Taiwan'],
        ['Tajikistan', 'Tajikistan'],
        ['Tanzania', 'Tanzania'],
        ['Thailand', 'Thailand'],
        ['Togo', 'Togo'],
        ['Tonga', 'Tonga'],
        ['Trinidad and Tobago', 'Trinidad and Tobago'],
        ['Tunisia', 'Tunisia'],
        ['Turkey', 'Turkey'],
        ['Turkmenistan', 'Turkmenistan'],
        ['Tuvalu', 'Tuvalu'],
        ['Uganda', 'Uganda'],
        ['Ukraine', 'Ukraine'],
        ['United Arab Emirates', 'United Arab Emirates'],
        ['United Kingdom', 'United Kingdom'],
        ['United States', 'United States'],
        ['Uruguay', 'Uruguay'],
        ['Uzbekistan', 'Uzbekistan'],
        ['Vanuatu', 'Vanuatu'],
        ['Vatican City', 'Vatican City'],
        ['Venezuela', 'Venezuela'],
        ['Vietnam', 'Vietnam'],
        ['Virgin Islands, British', 'Virgin Islands, British'],
        ['Virgin Islands, U.S.', 'Virgin Islands, U.S.'],
        ['Yemen', 'Yemen'],
        ['Zambia', 'Zambia'],
        ['Zimbabwe', 'Zimbabwe']
    ]
  end

  # List of US States for any State selections
  def us_states_list
    [
        ['Alabama', 'Alabama'],
        ['Alaska', 'Alaska'],
        ['Arizona', 'Arizona'],
        ['Arkansas', 'Arkansas'],
        ['California', 'California'],
        ['Colorado', 'Colorado'],
        ['Connecticut', 'Connecticut'],
        ['Delaware', 'Delaware'],
        ['District of Columbia', 'District of Columbia'],
        ['Florida', 'Florida'],
        ['Georgia', 'Georgia'],
        ['Hawaii', 'Hawaii'],
        ['Idaho', 'Idaho'],
        ['Illinois', 'Illinois'],
        ['Indiana', 'Indiana'],
        ['Iowa', 'Iowa'],
        ['Kansas', 'Kansas'],
        ['Kentucky', 'Kentucky'],
        ['Louisiana', 'Louisiana'],
        ['Maine', 'Maine'],
        ['Maryland', 'Maryland'],
        ['Massachusetts', 'Massachusetts'],
        ['Michigan', 'Michigan'],
        ['Minnesota', 'Minnesota'],
        ['Mississippi', 'Mississippi'],
        ['Missouri', 'Missouri'],
        ['Montana', 'Montana'],
        ['Nebraska', 'Nebraska'],
        ['Nevada', 'Nevada'],
        ['New Hampshire', 'New Hampshire'],
        ['New Jersey', 'New Jersey'],
        ['New Mexico', 'New Mexico'],
        ['New York', 'New York'],
        ['North Carolina', 'North Carolina'],
        ['North Dakota', 'North Dakota'],
        ['Ohio', 'Ohio'],
        ['Oklahoma', 'Oklahoma'],
        ['Oregon', 'Oregon'],
        ['Pennsylvania', 'Pennsylvania'],
        ['Rhode Island', 'Rhode Island'],
        ['South Carolina', 'South Carolina'],
        ['South Dakota', 'South Dakota'],
        ['Tennessee', 'Tennessee'],
        ['Texas', 'Texas'],
        ['Utah', 'Utah'],
        ['Vermont', 'Vermont'],
        ['Virginia', 'Virginia'],
        ['Washington', 'Washington'],
        ['West Virginia', 'West Virginia'],
        ['Wisconsin', 'Wisconsin'],
        ['Wyoming', 'Wyoming'],
        ['Armed Forces Americas', 'Armed Forces Americas'],
        ['Armed Forces Europe', 'Armed Forces Europe'],
        ['Armed Forces Pacific', 'Armed Forces Pacific']
    ]
  end

end


class String
  # lowercase and replace spaces with _
  def normalize
    return self.downcase.gsub(/ /, '_')
  end
end
