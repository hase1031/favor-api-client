require 'spec_helper'

describe Favor::Api::Client do

  token = 'your token'

  before do
    Favor::Api::Client.configure do |options|
      options[:t] = token
    end
    WebMock.enable!
  end

  it 'has a version number' do
    expect(Favor::Api::Client::VERSION).not_to be nil
  end

  describe '#image_search' do

    path = '/photo_list.json'
    article_id = 8334

    context '200 status' do
      sample_response = {
          article: {
              title: 'example',
              main_image: 'http://www.example.com',
              url: 'http://www.example.com',
              credit_logo: 'http://www.example.com',
          },
          photos: {
              "0" => 'http://www.example.com',
              "1" => 'http://www.example.com',
              "2" => 'http://www.example.com',
          },
          error: 0,
      }

      it 'returns 200 status' do
        query_string = URI.encode_www_form({a: article_id, t: token})
        WebMock.stub_request(:get, Favor::Api::Client::API_ENDPOINT + path + '?' + query_string).to_return(
            :body => JSON.generate(sample_response),
            :status => 200,
            :headers => {'Content-type' => ' application/json'}
        )
        res = Favor::Api::Client.image_search(article_id)
        images = res.images
        expect(images.length).to eq(sample_response[:photos].length)
        expect(res.code).to eq(200)
      end
    end

    context '500 status' do
      sample_response =
          {
              status: 500,
              message: 'Internal Server Error.',
              data: nil
          }

      it 'returns 500 status' do
        query_string = URI.encode_www_form({a: article_id, t: token})
        WebMock.stub_request(:get, Favor::Api::Client::API_ENDPOINT + path + '?' + query_string).to_return(
            :body => JSON.generate(sample_response),
            :status => 500,
            :headers => {'Content-type' => ' application/json'}
        )
        expect { Favor::Api::Client.image_search(article_id) }.to raise_error(Favor::Api::RequestError)
      end
    end
  end

  describe '#image_detail' do

    path = '/photo.json'
    article_id = 8334
    position = 0

    context '200 status' do
      sample_response =
          {
              photo: {
                  title: "example",
                  main_image: "http://www.example.com",
                  image: "http://www.example.com",
                  url: "http://www.example.com",
                  credit_logo: 'http://www.example.com',
              },
              error: 0,
          }
      it 'returns 200 status' do
        query_string = URI.encode_www_form({a: article_id, n: position, t: token})
        WebMock.stub_request(:get, Favor::Api::Client::API_ENDPOINT + path + '?' + query_string).to_return(
            :body => JSON.generate(sample_response),
            :status => 200,
            :headers => {'Content-type' => ' application/json'}
        )
        res = Favor::Api::Client.image_detail(article_id, position)
        expect(res.image['title']).to eq(sample_response[:photo][:title])
      end
    end

    context '500 status' do
      sample_response =
          {
              status: 500,
              message: 'Internal Server Error.',
          }
      it 'returns 500 status' do
        query_string = URI.encode_www_form({a: article_id, n: position, t: token})
        WebMock.stub_request(:get, Favor::Api::Client::API_ENDPOINT + path + '?' + query_string).to_return(
            :body => JSON.generate(sample_response),
            :status => 500,
            :headers => {'Content-type' => ' application/json'}
        )
        expect { Favor::Api::Client.image_detail(article_id, position) }.to raise_error(Favor::Api::RequestError)
      end
    end
  end

end
