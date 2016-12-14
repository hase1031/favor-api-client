require "favor/api/client/version"
require 'net/http'
require 'json'

module Favor
  module Api

    class RequestError < StandardError;
    end

    module Client

      API_ENDPOINT = 'http://widget.favor.life/api/v1'

      @@options = {
          method: 'get'
      }

      # Default search options
      def self.options
        @@options
      end

      # Set default search options
      def self.options=(opts)
        @@options = opts
      end

      def self.configure(&proc)
        fail ArgumentError, "Block is required." unless block_given?
        yield @@options
      end

      # Search image by article_id
      def self.image_search(article_id, opts = {})
        opts[:path] = '/photo_list.json'
        opts[:a] = article_id
        self.send_request(opts)
      end

      # Show detail of the photo.
      def self.image_detail(article_id, position, opts = {})
        opts[:path] = '/photo.json'
        opts[:a] = article_id
        opts[:n] = position
        self.send_request(opts)
      end

      def self.send_request(opts)
        opts = self.options.merge(opts) if self.options
        http_response = call_api(opts)
        res = Response.new(http_response)
        unless http_response.kind_of? Net::HTTPSuccess
          err_msg = "HTTP Response: #{http_response.code} #{http_response.message}"
          err_msg += " - #{res.error}" if res.error
          fail Favor::Api::RequestError, err_msg
        end
        res
      end

      class Response

        def initialize(res)
          @code = res.code
          @message = (res.kind_of? Net::HTTPSuccess) ? nil : res.message
          @body = JSON.parse(res.body)
        end

        def body
          @body
        end

        def error
          @message
        end

        def code
          @code.to_i
        end

        def article
          @body['article']
        end

        def image
          @body['photo']
        end

        def images
          @body['photos']
        end

      end

      private

      def self.call_api(opts)
        http_method = opts.delete(:method)
        if http_method == 'post'
          request_url = prepare_url({path: opts.delete(:path)})
          Net::HTTP.post_form(URI::parse(request_url), opts)
        else
          request_url = prepare_url(opts)
          Net::HTTP.get_response(URI::parse(request_url))
        end
      end

      def self.prepare_url(opts)
        path = opts.delete(:path)
        query_string = opts.empty? ? '' : '?' + URI.encode_www_form(opts)
        API_ENDPOINT + path + query_string
      end

    end
  end
end
