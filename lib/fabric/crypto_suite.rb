require 'openssl'

module Fabric
  class CryptoSuite
    DEFAULT_KEY_SIZE = 256
    DEFAULT_DIGEST_ALGORITHM = 'SHA256'.freeze
    DEFAULT_AES_KEY_SIZE = 128

    EC_CURVES = { 256 => 'prime256v1', 384 => 'secp384r1' }.freeze

    CIPHER = 'aes-256-cbc'.freeze

    attr_reader :key_size, :digest_algorithm, :digest, :curve, :cipher

    def initialize(opts = {})
      @key_size = opts[:key_size] || DEFAULT_KEY_SIZE
      @digest_algorithm = opts[:digest_algorithm] || DEFAULT_DIGEST_ALGORITHM
      @digest = OpenSSL::Digest.new digest_algorithm
      @curve = EC_CURVES[key_size]
      @cipher = opts[:cipher] || CIPHER
    end

    def sign(private_key, message)
      digest = digest(message)
      key = pkey_from_private_key(private_key)
      signature = key.dsa_sign_asn1(digest)
      sequence = OpenSSL::ASN1.decode(signature)
      sequence = prevent_malleability(sequence, key.group.order)

      sequence.to_der
    end

    def generate_private_key
      key = OpenSSL::PKey::EC.new(curve)
      key.generate_key!
      key.private_key.to_i.to_s(16).downcase
    end

    def generate_csr(private_key, attrs = [])
      key = pkey_from_private_key(private_key)

      req = OpenSSL::X509::Request.new
      req.subject = OpenSSL::X509::Name.new(attrs)
      req.public_key = key.public_key # Ensure the public key is set correctly
      req.sign(key, @digest)

      req
    end

    def generate_nonce(length = 24)
      OpenSSL::Random.random_bytes(length)
    end

    def hexdigest(message)
      @digest.hexdigest(message)
    end

    def digest(message)
      @digest.digest(message)
    end

    def encode_hex(bytes)
      bytes.unpack('H*').first
    end

    def decode_hex(string)
      [string].pack('H*')
    end

    def keccak256(bytes)
      Digest::Keccak.new(256).digest(bytes)
    end

    def restore_public_key(private_key)
      private_bn = OpenSSL::BN.new(private_key, 16)
      group = OpenSSL::PKey::EC::Group.new(curve)

      # Calculate the public point from the private key
      public_point = group.generator.mul(private_bn)
      public_point.to_bn.to_s(16).downcase
    end

    def address_from_public_key(public_key)
      bytes = decode_hex(public_key)
      address_bytes = keccak256(bytes[1..-1])[-20..-1]
      encode_hex(address_bytes)
    end

    def build_shared_key(private_key, public_key)
      pkey = pkey_from_private_key(private_key)
      public_bn = OpenSSL::BN.new(public_key, 16)
      group = OpenSSL::PKey::EC::Group.new(curve)
      public_point = OpenSSL::PKey::EC::Point.new(group, public_bn)

      encode_hex(pkey.dh_compute_key(public_point))
    end

    def encrypt(secret, data)
      aes = OpenSSL::Cipher.new(cipher)
      aes.encrypt
      aes.key = decode_hex(secret)
      iv = aes.random_iv
      aes.iv = iv

      Base64.strict_encode64(iv + aes.update(data) + aes.final)
    end

    def decrypt(secret, data)
      return unless data

      encrypted_data = Base64.strict_decode64(data)
      aes = OpenSSL::Cipher.new(cipher)
      aes.decrypt
      aes.key = decode_hex(secret)
      aes.iv = encrypted_data[0..15]
      encrypted_data = encrypted_data[16..-1]

      aes.update(encrypted_data) + aes.final
    end

    private

    def pkey_from_private_key(private_key)
      private_bn = OpenSSL::BN.new(private_key, 16)
      group = OpenSSL::PKey::EC::Group.new(curve)

      # Create a new EC key with both the group and the private key set at creation
      key = OpenSSL::PKey::EC.new(group)
      key.generate_key # Generates both the private and public keys

      # Set the private key explicitly during key generation
      key.private_key = private_bn

      # Derive the public key directly from the private key
      public_point = group.generator.mul(private_bn)
      key.public_key = public_point

      key
    end

    def prevent_malleability(sequence, order)
      half_order = order >> 1

      if (half_key = sequence.value[1].value) > half_order
        sequence.value[1].value = order - half_key
      end

      sequence
    end
  end
end
