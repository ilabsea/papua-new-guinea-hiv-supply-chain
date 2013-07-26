# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :year do |n|
    2000 + n
  end

  factory :import_surv1, :class => ImportSurv do
    surv_type { ImportSurv::TYPES_SURV1}
    year 2013
    month 'January'
    user { FactoryGirl.create :user_data_entry }
  end

  factory :import_surv2, :class => ImportSurv do
    surv_type { ImportSurv::TYPES_SURV2}
    year
    month {'January'}
    user { FactoryGirl.create :user_data_entry }
  end

  factory :import_surv do
    surv_type {  ImportSurv::TYPES[rand(1)] }
    year 
    month {'January'}
    user { FactoryGirl.create :user_data_entry }
  end

end
