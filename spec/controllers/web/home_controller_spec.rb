# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Web::HomeController, type: :controller do
  describe 'Visit Home page' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
