# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController do
  controller do
    def index
      authorize :application
      render plain: 'Hello World'
    end
  end

  describe '#set_locale' do
    context 'with param not given' do
      it 'sets the locale to the default locale' do
        get :index
        expect(I18n.locale).to eq I18n.default_locale
      end
    end

    context 'with param given' do
      it 'sets the locale to the given locale' do
        get :index, params: { locale: 'de' }
        expect(I18n.locale).to eq :de
      end
    end
  end

  describe 'Authorization' do
    context 'with referer given' do
      before do
        request.env['HTTP_REFERER'] = 'http://example.com'
      end

      it 'redirects to the referer' do
        get :index
        expect(response).to redirect_to('http://example.com')
      end
    end

    context 'with no referer given' do
      it 'redirects to the root path' do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
