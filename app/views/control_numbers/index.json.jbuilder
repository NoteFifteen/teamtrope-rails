json.array!(@control_numbers) do |control_number|
  json.extract! control_number, :id
  json.url control_number_url(control_number, format: :json)
end
