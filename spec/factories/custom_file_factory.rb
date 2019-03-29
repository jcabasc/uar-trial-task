# frozen_string_literal: true

FactoryBot.define do
  factory :custom_file, class: CustomFile do
    name { 'test1' }
    tags { [] }
  end
end
