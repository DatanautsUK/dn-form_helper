# frozen_string_literal: true

require 'spec_helper'

describe 'XSS protection' do
  before do
    # @user = User.new(:first_name => '"><script>alert("xss")</script>', :last_name => 'Blogs')
    @user = User.new(first_name: 'Jo', last_name: 'Blogs')
  end

  def session
    { csrf: '12345' }
  end

  def request
    r = double('request')
    allow(r).to receive(:script_name) { '/admin' }
    r
  end

  describe 'form_for' do
    it 'should have csrf field' do
      f = form_for(@user) { '<p>abc def</p>' }
      expect(f).to match(/input.*name=.authenticity_token./)
    end
  end
end
