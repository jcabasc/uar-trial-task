# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CustomFile, type: :model do
  describe '#validations' do
    describe 'validate_sign_inclusion' do
      context 'valid' do
        subject { build(:custom_file, tags: ['tag1']) }
        it { expect(subject.valid?).to be_truthy }
      end

      context 'invalid' do
        subject { build(:custom_file, tags: ['tag1+']) }
        it { expect(subject.valid?).to be_falsey }
      end
    end
  end
end