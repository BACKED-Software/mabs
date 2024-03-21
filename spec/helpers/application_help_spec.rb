# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#require_sign_in' do
    let(:mock_block) { proc { 'Hello, Test!' } }

    context 'when user is signed in' do
      before do
        # assuming user_signed_in? helper is from Devise. Replace as necessary
        allow(helper).to receive(:user_signed_in?).and_return(true)
      end

      it 'executes the block' do
        expect(helper.require_sign_in(&mock_block)).to eq 'Hello, Test!'
      end
    end

    context 'when user is not signed in' do
      before do
        # assuming user_signed_in? helper is from Devise. Replace as necessary
        allow(helper).to receive(:user_signed_in?).and_return(false)
      end

      it 'does not execute the block' do
        expect(helper.require_sign_in(&mock_block)).to be_nil
      end
    end
  end
end
