assert = require 'assert'
ByteBuffer = require 'bytebuffer'
{Signature} = require '../ecc/signature'

class Email

    constructor: (
        @subject, @body
        @reply_to = new Buffer("0000000000000000000000000000000000000000", 'hex').toString('binary')
        @attachments = []
        @signature
    ) ->
        throw "subject is required" unless @subject
        #throw "body is required" unless @body TODO failing

    Email.fromBuffer = (buf) ->
        b = ByteBuffer.fromBinary buf.toString('binary'), ByteBuffer.LITTLE_ENDIAN
        Email.fromByteBuffer b

    toBuffer: (include_signature) ->
        b=@toByteBuffer(include_signature)
        new Buffer b.toBinary(), 'binary'    

    Email.fromByteBuffer= (b) ->
        subject = b.readVString()
        body = b.readVString()

        # reply_to message Id ripemd 160 (160 bits / 8 = 20 bytes)
        len = 20
        _b = b.copy(b.offset, b.offset + len); b.skip len
        reply_to = new Buffer(_b.toBinary(), 'binary')

        # FC_REFLECT( bts::mail::attachment, (name)(data) )
        attachments = Array(b.readVarint32())
        throw "Message with attachments has not been implemented" unless attachments.length is 0

        sig_bin = b.copy(b.offset, b.offset + 65).toBinary(); b.skip 65
        sig_buf = new Buffer sig_bin, 'binary'
        signature = Signature.fromBuffer sig_buf
        
        throw "Message contained #{b.remaining()} unknown bytes" unless b.remaining() is 0
        new Email(subject, body, reply_to, attachments, signature)

    toByteBuffer: (include_signature = true) ->
        b = new ByteBuffer(ByteBuffer.DEFAULT_CAPACITY, ByteBuffer.LITTLE_ENDIAN)
        b.writeVString @subject
        b.writeVString @body
        b.append @reply_to.toString('binary'), 'binary'
        b.writeVarint32 @attachments.length
        throw "Message with attachments has not been implemented" unless @attachments.length is 0
        if include_signature
            throw "Missing signature" unless @signature
            b.append @signature.toBuffer().toString('binary'), 'binary' 
        return b.copy 0, b.offset

    ### <HEX> ###
    
    Email.fromHex= (hex) ->
        b = ByteBuffer.fromHex hex
        return Email.fromByteBuffer b

    toHex: (include_signature) ->
        b=@toByteBuffer(include_signature)
        b.toHex()
        
    ### </HEX> ###

exports.Email = Email
