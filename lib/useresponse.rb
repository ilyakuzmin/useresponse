require 'digest'
require 'useresponse/version'

module Useresponse
  class OneLogin
    DIRECT_URL = '#domain#/sso/#source#/#fullname#/#email#/#user_id#/#hash#/direct-sso#properties#'

    def initialize(config)
      @config = {
        source:   config[:source],
        domain:   config[:domain],
        secret:   config[:secret],
        redirect: 0,
      }
    end

    def url(data)
      attributes = {
        fullname: data[:fullname],
        email:    data[:email],
        user_id:  data[:user_id]
      }
      attributes.merge!(@config)

      output = DIRECT_URL.dup

      attributes.each do |key, val|
        unless [:secret, :domain].include?(key)
          val = encrypt(val, attributes[:secret])
        end
        output.sub!("##{key}#", val)
      end

      hash = generateHash(attributes, attributes[:secret])
      output.sub!('#hash#', hash)
      output.sub!('#properties#', '')

      output
    end

    private

    def encrypt(string, key)
      key = Digest::SHA1.hexdigest(key)
      string = string.to_s.bytes
      string_length = string.length
      key_length = key.length
      j = 0
      hash = ''

      string_length.times do |i|
        string_ord = string[i]
        j = 0 if j == key_length
        key_ord = key[j].ord
        j += 1
        hash += (string_ord + key_ord).to_s(36).reverse
      end

      hash
    end

    def generateHash(data, key)
      key = Digest::SHA1.hexdigest(Digest::MD5.hexdigest(key.reverse))
      hashable = [
        data[:fullname],
        data[:user_id],
        data[:email],
        data[:source]
      ]
      hashable = hashable.join(key)
      hashable = hashable.bytes.reverse.map(&:chr).join # PHP strrev function

      Digest::SHA1.hexdigest(hashable)
    end
  end
end
