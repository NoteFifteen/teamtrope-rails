json.array!(@imported_contracts) do |imported_contract|
  json.extract! imported_contract, :id, :document_type, :document_signers, :document_date, :contract
  json.url imported_contract_url(imported_contract, format: :json)
end
