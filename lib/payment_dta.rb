require 'payment_dta/version'
require 'payment_dta/dta_file'
%w(esr_payment domestic_chf_payment financial_institution_payment bank_cheque_payment iban_payment special_financial_institution_payment total_record).each do |payment_type|
  require "payment_dta/payments/#{payment_type}"
end
