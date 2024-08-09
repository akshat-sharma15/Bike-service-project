FactoryBot.define do
  factory :bike do
    info { "TVS Jupiter 110" }
    regstration_num { "MP 09 BW 7865" }
    status { "available" }
    rate { 100 }
    association :service_center
  end
end
