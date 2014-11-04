assert = require("assert")

Ecc = require '../src/ecc'
Aes = Ecc.Aes
Signature = Ecc.Signature
PrivateKey = Ecc.PrivateKey
PublicKey = Ecc.PublicKey


test = (key) ->
    describe "Key Convert", ->
        it "BTS", ->
            private_key = PrivateKey.fromHex key.private_key
            public_key = private_key.toPublicKey()
            assert.equal key.bts_address, public_key.toBtsAddy() 

        it "PTS", ->
            private_key = PrivateKey.fromHex key.private_key
            public_key = private_key.toPublicKey()
            assert.equal key.pts_address, public_key.toPtsAddy()
        
        it "To WIF", ->
            private_key = PrivateKey.fromHex key.private_key
            assert.equal key.private_key_WIF_format, private_key.toWif()

        it "From WIF", ->
            private_key = PrivateKey.fromWif key.private_key_WIF_format
            assert.equal private_key.toHex(), key.private_key
            
        it "Calc public key", ->
            private_key = PrivateKey.fromHex key.private_key
            public_key = private_key.toPublicKey()
            assert.equal key.bts_address, public_key.toBtsAddy()
            
        it "Decrypt private key", ->
            aes = Aes.fromSecret "Password00"
            d = aes.decrypt_hex key.encrypted_private_key
            assert.equal key.private_key, d

test
    public_key: "XTS7jDPoMwyjVH5obFmqzFNp4Ffp7G2nvC7FKFkrMBpo7Sy4uq5Mj"
    private_key: "20991828d456b389d0768ed7fb69bf26b9bb87208dd699ef49f10481c20d3e18"
    private_key_WIF_format: "5J4eFhjREJA7hKG6KcvHofHMXyGQZCDpQE463PAaKo9xXY6UDPq"
    bts_address: "XTS8DvGQqzbgCR5FHiNsFf8kotEXr8VKD3mR"
    pts_address: "Po3mqkgMzBL4F1VXJArwQxeWf3fWEpxUf3"
    encrypted_private_key: "5e1ae410919c450dce1c476ae3ed3e5fe779ad248081d85b3dcf2888e698744d0a4b60efb7e854453bec3f6883bcbd1d"
    