module rec Types_piqi:
  sig
    type uint64 = int64
    type binary = string
    type message_type =
      [
        | `null_message
        | `echo
        | `flush
        | `info
        | `set_option
        | `error
        | `append_tx
        | `check_tx
        | `commit
        | `query
        | `init_chain
        | `begin_block
        | `end_block
      ]
    type code_type =
      [
        | `ok
        | `internal_error
        | `encoding_error
        | `bad_nonce
        | `unauthorized
        | `insufficient_funds
        | `unknown_request
        | `base_duplicate_address
        | `base_encoding_error
        | `base_insufficient_fees
        | `base_insufficient_funds
        | `base_insufficient_gas_price
        | `base_invalid_input
        | `base_invalid_output
        | `base_invalid_pub_key
        | `base_invalid_sequence
        | `base_invalid_signature
        | `base_unknown_address
        | `base_unknown_pub_key
        | `base_unknown_plugin
        | `gov_unknown_entity
        | `gov_unknown_group
        | `gov_unknown_proposal
        | `gov_duplicate_group
        | `gov_duplicate_member
        | `gov_duplicate_proposal
        | `gov_duplicate_vote
        | `gov_invalid_member
        | `gov_invalid_vote
        | `gov_invalid_voting_power
      ]
    type request = Request.t
    type request_echo = Request_echo.t
    type request_flush = Request_flush.t
    type request_info = Request_info.t
    type request_set_option = Request_set_option.t
    type request_append_tx = Request_append_tx.t
    type request_check_tx = Request_check_tx.t
    type request_query = Request_query.t
    type request_commit = Request_commit.t
    type request_init_chain = Request_init_chain.t
    type request_begin_block = Request_begin_block.t
    type request_end_block = Request_end_block.t
    type response = Response.t
    type response_error = Response_error.t
    type response_echo = Response_echo.t
    type response_flush = Response_flush.t
    type response_info = Response_info.t
    type response_set_option = Response_set_option.t
    type response_append_tx = Response_append_tx.t
    type response_check_tx = Response_check_tx.t
    type response_query = Response_query.t
    type response_commit = Response_commit.t
    type response_init_chain = Response_init_chain.t
    type response_begin_block = Response_begin_block.t
    type response_end_block = Response_end_block.t
    type validator = Validator.t
  end = Types_piqi
and Request:
  sig
    type t = {
      mutable echo: Types_piqi.request_echo option;
      mutable flush: Types_piqi.request_flush option;
      mutable info: Types_piqi.request_info option;
      mutable set_option: Types_piqi.request_set_option option;
      mutable append_tx: Types_piqi.request_append_tx option;
      mutable check_tx: Types_piqi.request_check_tx option;
      mutable commit: Types_piqi.request_commit option;
      mutable query: Types_piqi.request_query option;
      mutable init_chain: Types_piqi.request_init_chain option;
      mutable begin_block: Types_piqi.request_begin_block option;
      mutable end_block: Types_piqi.request_end_block option;
    }
  end = Request
and Request_echo:
  sig
    type t = {
      mutable message: string option;
    }
  end = Request_echo
and Request_flush:
  sig
    type t = {
      _dummy: unit;
    }
  end = Request_flush
and Request_info:
  sig
    type t = {
      _dummy: unit;
    }
  end = Request_info
and Request_set_option:
  sig
    type t = {
      mutable key: string option;
      mutable value: string option;
    }
  end = Request_set_option
and Request_append_tx:
  sig
    type t = {
      mutable tx: Types_piqi.binary option;
    }
  end = Request_append_tx
and Request_check_tx:
  sig
    type t = {
      mutable tx: Types_piqi.binary option;
    }
  end = Request_check_tx
and Request_query:
  sig
    type t = {
      mutable query: Types_piqi.binary option;
    }
  end = Request_query
and Request_commit:
  sig
    type t = {
      _dummy: unit;
    }
  end = Request_commit
and Request_init_chain:
  sig
    type t = {
      mutable validators: Types_piqi.validator list;
    }
  end = Request_init_chain
and Request_begin_block:
  sig
    type t = {
      mutable height: Types_piqi.uint64 option;
    }
  end = Request_begin_block
and Request_end_block:
  sig
    type t = {
      mutable height: Types_piqi.uint64 option;
    }
  end = Request_end_block
and Response:
  sig
    type t = {
      mutable error: Types_piqi.response_error option;
      mutable echo: Types_piqi.response_echo option;
      mutable flush: Types_piqi.response_flush option;
      mutable info: Types_piqi.response_info option;
      mutable set_option: Types_piqi.response_set_option option;
      mutable append_tx: Types_piqi.response_append_tx option;
      mutable check_tx: Types_piqi.response_check_tx option;
      mutable commit: Types_piqi.response_commit option;
      mutable query: Types_piqi.response_query option;
      mutable init_chain: Types_piqi.response_init_chain option;
      mutable begin_block: Types_piqi.response_begin_block option;
      mutable end_block: Types_piqi.response_end_block option;
    }
  end = Response
and Response_error:
  sig
    type t = {
      mutable error: string option;
    }
  end = Response_error
and Response_echo:
  sig
    type t = {
      mutable message: string option;
    }
  end = Response_echo
and Response_flush:
  sig
    type t = {
      _dummy: unit;
    }
  end = Response_flush
and Response_info:
  sig
    type t = {
      mutable info: string option;
    }
  end = Response_info
and Response_set_option:
  sig
    type t = {
      mutable log: string option;
    }
  end = Response_set_option
and Response_append_tx:
  sig
    type t = {
      mutable code: Types_piqi.code_type option;
      mutable data: Types_piqi.binary option;
      mutable log: string option;
    }
  end = Response_append_tx
and Response_check_tx:
  sig
    type t = {
      mutable code: Types_piqi.code_type option;
      mutable data: Types_piqi.binary option;
      mutable log: string option;
    }
  end = Response_check_tx
and Response_query:
  sig
    type t = {
      mutable code: Types_piqi.code_type option;
      mutable data: Types_piqi.binary option;
      mutable log: string option;
    }
  end = Response_query
and Response_commit:
  sig
    type t = {
      mutable code: Types_piqi.code_type option;
      mutable data: Types_piqi.binary option;
      mutable log: string option;
    }
  end = Response_commit
and Response_init_chain:
  sig
    type t = {
      _dummy: unit;
    }
  end = Response_init_chain
and Response_begin_block:
  sig
    type t = {
      _dummy: unit;
    }
  end = Response_begin_block
and Response_end_block:
  sig
    type t = {
      mutable diffs: Types_piqi.validator list;
    }
  end = Response_end_block
and Validator:
  sig
    type t = {
      mutable pub_key: Types_piqi.binary option;
      mutable power: Types_piqi.uint64 option;
    }
  end = Validator


let rec parse_string x = Piqirun.string_of_block x

and parse_binary x = Piqirun.string_of_block x

and parse_uint64 x = Piqirun.int64_of_varint x
and packed_parse_uint64 x = Piqirun.int64_of_packed_varint x

and parse_request x =
  let x = Piqirun.parse_record x in
  let _echo, x = Piqirun.parse_optional_field 1 parse_request_echo x in
  let _flush, x = Piqirun.parse_optional_field 2 parse_request_flush x in
  let _info, x = Piqirun.parse_optional_field 3 parse_request_info x in
  let _set_option, x = Piqirun.parse_optional_field 4 parse_request_set_option x in
  let _append_tx, x = Piqirun.parse_optional_field 5 parse_request_append_tx x in
  let _check_tx, x = Piqirun.parse_optional_field 6 parse_request_check_tx x in
  let _commit, x = Piqirun.parse_optional_field 7 parse_request_commit x in
  let _query, x = Piqirun.parse_optional_field 8 parse_request_query x in
  let _init_chain, x = Piqirun.parse_optional_field 9 parse_request_init_chain x in
  let _begin_block, x = Piqirun.parse_optional_field 10 parse_request_begin_block x in
  let _end_block, x = Piqirun.parse_optional_field 11 parse_request_end_block x in
  Piqirun.check_unparsed_fields x;
  {
    Request.echo = _echo;
    Request.flush = _flush;
    Request.info = _info;
    Request.set_option = _set_option;
    Request.append_tx = _append_tx;
    Request.check_tx = _check_tx;
    Request.commit = _commit;
    Request.query = _query;
    Request.init_chain = _init_chain;
    Request.begin_block = _begin_block;
    Request.end_block = _end_block;
  }

and parse_request_echo x =
  let x = Piqirun.parse_record x in
  let _message, x = Piqirun.parse_optional_field 1 parse_string x in
  Piqirun.check_unparsed_fields x;
  {
    Request_echo.message = _message;
  }

and parse_request_flush x =
  let x = Piqirun.parse_record x in
  Piqirun.check_unparsed_fields x;
  {
    Request_flush
    ._dummy = ();
  }

and parse_request_info x =
  let x = Piqirun.parse_record x in
  Piqirun.check_unparsed_fields x;
  {
    Request_info
    ._dummy = ();
  }

and parse_request_set_option x =
  let x = Piqirun.parse_record x in
  let _key, x = Piqirun.parse_optional_field 1 parse_string x in
  let _value, x = Piqirun.parse_optional_field 2 parse_string x in
  Piqirun.check_unparsed_fields x;
  {
    Request_set_option.key = _key;
    Request_set_option.value = _value;
  }

and parse_request_append_tx x =
  let x = Piqirun.parse_record x in
  let _tx, x = Piqirun.parse_optional_field 1 parse_binary x in
  Piqirun.check_unparsed_fields x;
  {
    Request_append_tx.tx = _tx;
  }

and parse_request_check_tx x =
  let x = Piqirun.parse_record x in
  let _tx, x = Piqirun.parse_optional_field 1 parse_binary x in
  Piqirun.check_unparsed_fields x;
  {
    Request_check_tx.tx = _tx;
  }

and parse_request_query x =
  let x = Piqirun.parse_record x in
  let _query, x = Piqirun.parse_optional_field 1 parse_binary x in
  Piqirun.check_unparsed_fields x;
  {
    Request_query.query = _query;
  }

and parse_request_commit x =
  let x = Piqirun.parse_record x in
  Piqirun.check_unparsed_fields x;
  {
    Request_commit
    ._dummy = ();
  }

and parse_request_init_chain x =
  let x = Piqirun.parse_record x in
  let _validators, x = Piqirun.parse_repeated_field 1 parse_validator x in
  Piqirun.check_unparsed_fields x;
  {
    Request_init_chain.validators = _validators;
  }

and parse_request_begin_block x =
  let x = Piqirun.parse_record x in
  let _height, x = Piqirun.parse_optional_field 1 parse_uint64 x in
  Piqirun.check_unparsed_fields x;
  {
    Request_begin_block.height = _height;
  }

and parse_request_end_block x =
  let x = Piqirun.parse_record x in
  let _height, x = Piqirun.parse_optional_field 1 parse_uint64 x in
  Piqirun.check_unparsed_fields x;
  {
    Request_end_block.height = _height;
  }

and parse_response x =
  let x = Piqirun.parse_record x in
  let _error, x = Piqirun.parse_optional_field 1 parse_response_error x in
  let _echo, x = Piqirun.parse_optional_field 2 parse_response_echo x in
  let _flush, x = Piqirun.parse_optional_field 3 parse_response_flush x in
  let _info, x = Piqirun.parse_optional_field 4 parse_response_info x in
  let _set_option, x = Piqirun.parse_optional_field 5 parse_response_set_option x in
  let _append_tx, x = Piqirun.parse_optional_field 6 parse_response_append_tx x in
  let _check_tx, x = Piqirun.parse_optional_field 7 parse_response_check_tx x in
  let _commit, x = Piqirun.parse_optional_field 8 parse_response_commit x in
  let _query, x = Piqirun.parse_optional_field 9 parse_response_query x in
  let _init_chain, x = Piqirun.parse_optional_field 10 parse_response_init_chain x in
  let _begin_block, x = Piqirun.parse_optional_field 11 parse_response_begin_block x in
  let _end_block, x = Piqirun.parse_optional_field 12 parse_response_end_block x in
  Piqirun.check_unparsed_fields x;
  {
    Response.error = _error;
    Response.echo = _echo;
    Response.flush = _flush;
    Response.info = _info;
    Response.set_option = _set_option;
    Response.append_tx = _append_tx;
    Response.check_tx = _check_tx;
    Response.commit = _commit;
    Response.query = _query;
    Response.init_chain = _init_chain;
    Response.begin_block = _begin_block;
    Response.end_block = _end_block;
  }

and parse_response_error x =
  let x = Piqirun.parse_record x in
  let _error, x = Piqirun.parse_optional_field 1 parse_string x in
  Piqirun.check_unparsed_fields x;
  {
    Response_error.error = _error;
  }

and parse_response_echo x =
  let x = Piqirun.parse_record x in
  let _message, x = Piqirun.parse_optional_field 1 parse_string x in
  Piqirun.check_unparsed_fields x;
  {
    Response_echo.message = _message;
  }

and parse_response_flush x =
  let x = Piqirun.parse_record x in
  Piqirun.check_unparsed_fields x;
  {
    Response_flush
    ._dummy = ();
  }

and parse_response_info x =
  let x = Piqirun.parse_record x in
  let _info, x = Piqirun.parse_optional_field 1 parse_string x in
  Piqirun.check_unparsed_fields x;
  {
    Response_info.info = _info;
  }

and parse_response_set_option x =
  let x = Piqirun.parse_record x in
  let _log, x = Piqirun.parse_optional_field 1 parse_string x in
  Piqirun.check_unparsed_fields x;
  {
    Response_set_option.log = _log;
  }

and parse_response_append_tx x =
  let x = Piqirun.parse_record x in
  let _code, x = Piqirun.parse_optional_field 1 parse_code_type x in
  let _data, x = Piqirun.parse_optional_field 2 parse_binary x in
  let _log, x = Piqirun.parse_optional_field 3 parse_string x in
  Piqirun.check_unparsed_fields x;
  {
    Response_append_tx.code = _code;
    Response_append_tx.data = _data;
    Response_append_tx.log = _log;
  }

and parse_response_check_tx x =
  let x = Piqirun.parse_record x in
  let _code, x = Piqirun.parse_optional_field 1 parse_code_type x in
  let _data, x = Piqirun.parse_optional_field 2 parse_binary x in
  let _log, x = Piqirun.parse_optional_field 3 parse_string x in
  Piqirun.check_unparsed_fields x;
  {
    Response_check_tx.code = _code;
    Response_check_tx.data = _data;
    Response_check_tx.log = _log;
  }

and parse_response_query x =
  let x = Piqirun.parse_record x in
  let _code, x = Piqirun.parse_optional_field 1 parse_code_type x in
  let _data, x = Piqirun.parse_optional_field 2 parse_binary x in
  let _log, x = Piqirun.parse_optional_field 3 parse_string x in
  Piqirun.check_unparsed_fields x;
  {
    Response_query.code = _code;
    Response_query.data = _data;
    Response_query.log = _log;
  }

and parse_response_commit x =
  let x = Piqirun.parse_record x in
  let _code, x = Piqirun.parse_optional_field 1 parse_code_type x in
  let _data, x = Piqirun.parse_optional_field 2 parse_binary x in
  let _log, x = Piqirun.parse_optional_field 3 parse_string x in
  Piqirun.check_unparsed_fields x;
  {
    Response_commit.code = _code;
    Response_commit.data = _data;
    Response_commit.log = _log;
  }

and parse_response_init_chain x =
  let x = Piqirun.parse_record x in
  Piqirun.check_unparsed_fields x;
  {
    Response_init_chain
    ._dummy = ();
  }

and parse_response_begin_block x =
  let x = Piqirun.parse_record x in
  Piqirun.check_unparsed_fields x;
  {
    Response_begin_block
    ._dummy = ();
  }

and parse_response_end_block x =
  let x = Piqirun.parse_record x in
  let _diffs, x = Piqirun.parse_repeated_field 4 parse_validator x in
  Piqirun.check_unparsed_fields x;
  {
    Response_end_block.diffs = _diffs;
  }

and parse_validator x =
  let x = Piqirun.parse_record x in
  let _pub_key, x = Piqirun.parse_optional_field 1 parse_binary x in
  let _power, x = Piqirun.parse_optional_field 2 parse_uint64 x in
  Piqirun.check_unparsed_fields x;
  {
    Validator.pub_key = _pub_key;
    Validator.power = _power;
  }

and parse_message_type x =
  match Piqirun.int32_of_signed_varint x with
    | 0l -> `null_message
    | 1l -> `echo
    | 2l -> `flush
    | 3l -> `info
    | 4l -> `set_option
    | 5l -> `error
    | 17l -> `append_tx
    | 18l -> `check_tx
    | 19l -> `commit
    | 20l -> `query
    | 21l -> `init_chain
    | 22l -> `begin_block
    | 23l -> `end_block
    | x -> Piqirun.error_enum_const x
and packed_parse_message_type x =
  match Piqirun.int32_of_packed_signed_varint x with
    | 0l -> `null_message
    | 1l -> `echo
    | 2l -> `flush
    | 3l -> `info
    | 4l -> `set_option
    | 5l -> `error
    | 17l -> `append_tx
    | 18l -> `check_tx
    | 19l -> `commit
    | 20l -> `query
    | 21l -> `init_chain
    | 22l -> `begin_block
    | 23l -> `end_block
    | x -> Piqirun.error_enum_const x

and parse_code_type x =
  match Piqirun.int32_of_signed_varint x with
    | 0l -> `ok
    | 1l -> `internal_error
    | 2l -> `encoding_error
    | 3l -> `bad_nonce
    | 4l -> `unauthorized
    | 5l -> `insufficient_funds
    | 6l -> `unknown_request
    | 101l -> `base_duplicate_address
    | 102l -> `base_encoding_error
    | 103l -> `base_insufficient_fees
    | 104l -> `base_insufficient_funds
    | 105l -> `base_insufficient_gas_price
    | 106l -> `base_invalid_input
    | 107l -> `base_invalid_output
    | 108l -> `base_invalid_pub_key
    | 109l -> `base_invalid_sequence
    | 110l -> `base_invalid_signature
    | 111l -> `base_unknown_address
    | 112l -> `base_unknown_pub_key
    | 113l -> `base_unknown_plugin
    | 201l -> `gov_unknown_entity
    | 202l -> `gov_unknown_group
    | 203l -> `gov_unknown_proposal
    | 204l -> `gov_duplicate_group
    | 205l -> `gov_duplicate_member
    | 206l -> `gov_duplicate_proposal
    | 207l -> `gov_duplicate_vote
    | 208l -> `gov_invalid_member
    | 209l -> `gov_invalid_vote
    | 210l -> `gov_invalid_voting_power
    | x -> Piqirun.error_enum_const x
and packed_parse_code_type x =
  match Piqirun.int32_of_packed_signed_varint x with
    | 0l -> `ok
    | 1l -> `internal_error
    | 2l -> `encoding_error
    | 3l -> `bad_nonce
    | 4l -> `unauthorized
    | 5l -> `insufficient_funds
    | 6l -> `unknown_request
    | 101l -> `base_duplicate_address
    | 102l -> `base_encoding_error
    | 103l -> `base_insufficient_fees
    | 104l -> `base_insufficient_funds
    | 105l -> `base_insufficient_gas_price
    | 106l -> `base_invalid_input
    | 107l -> `base_invalid_output
    | 108l -> `base_invalid_pub_key
    | 109l -> `base_invalid_sequence
    | 110l -> `base_invalid_signature
    | 111l -> `base_unknown_address
    | 112l -> `base_unknown_pub_key
    | 113l -> `base_unknown_plugin
    | 201l -> `gov_unknown_entity
    | 202l -> `gov_unknown_group
    | 203l -> `gov_unknown_proposal
    | 204l -> `gov_duplicate_group
    | 205l -> `gov_duplicate_member
    | 206l -> `gov_duplicate_proposal
    | 207l -> `gov_duplicate_vote
    | 208l -> `gov_invalid_member
    | 209l -> `gov_invalid_vote
    | 210l -> `gov_invalid_voting_power
    | x -> Piqirun.error_enum_const x


let rec gen__string code x = Piqirun.string_to_block code x

and gen__binary code x = Piqirun.string_to_block code x

and gen__uint64 code x = Piqirun.int64_to_varint code x
and packed_gen__uint64 x = Piqirun.int64_to_packed_varint x

and gen__request code x =
  let _echo = Piqirun.gen_optional_field 1 gen__request_echo x.Request.echo in
  let _flush = Piqirun.gen_optional_field 2 gen__request_flush x.Request.flush in
  let _info = Piqirun.gen_optional_field 3 gen__request_info x.Request.info in
  let _set_option = Piqirun.gen_optional_field 4 gen__request_set_option x.Request.set_option in
  let _append_tx = Piqirun.gen_optional_field 5 gen__request_append_tx x.Request.append_tx in
  let _check_tx = Piqirun.gen_optional_field 6 gen__request_check_tx x.Request.check_tx in
  let _commit = Piqirun.gen_optional_field 7 gen__request_commit x.Request.commit in
  let _query = Piqirun.gen_optional_field 8 gen__request_query x.Request.query in
  let _init_chain = Piqirun.gen_optional_field 9 gen__request_init_chain x.Request.init_chain in
  let _begin_block = Piqirun.gen_optional_field 10 gen__request_begin_block x.Request.begin_block in
  let _end_block = Piqirun.gen_optional_field 11 gen__request_end_block x.Request.end_block in
  Piqirun.gen_record code (_echo :: _flush :: _info :: _set_option :: _append_tx :: _check_tx :: _commit :: _query :: _init_chain :: _begin_block :: _end_block :: [])

and gen__request_echo code x =
  let _message = Piqirun.gen_optional_field 1 gen__string x.Request_echo.message in
  Piqirun.gen_record code (_message :: [])

and gen__request_flush code x =
  Piqirun.gen_record code ([])

and gen__request_info code x =
  Piqirun.gen_record code ([])

and gen__request_set_option code x =
  let _key = Piqirun.gen_optional_field 1 gen__string x.Request_set_option.key in
  let _value = Piqirun.gen_optional_field 2 gen__string x.Request_set_option.value in
  Piqirun.gen_record code (_key :: _value :: [])

and gen__request_append_tx code x =
  let _tx = Piqirun.gen_optional_field 1 gen__binary x.Request_append_tx.tx in
  Piqirun.gen_record code (_tx :: [])

and gen__request_check_tx code x =
  let _tx = Piqirun.gen_optional_field 1 gen__binary x.Request_check_tx.tx in
  Piqirun.gen_record code (_tx :: [])

and gen__request_query code x =
  let _query = Piqirun.gen_optional_field 1 gen__binary x.Request_query.query in
  Piqirun.gen_record code (_query :: [])

and gen__request_commit code x =
  Piqirun.gen_record code ([])

and gen__request_init_chain code x =
  let _validators = Piqirun.gen_repeated_field 1 gen__validator x.Request_init_chain.validators in
  Piqirun.gen_record code (_validators :: [])

and gen__request_begin_block code x =
  let _height = Piqirun.gen_optional_field 1 gen__uint64 x.Request_begin_block.height in
  Piqirun.gen_record code (_height :: [])

and gen__request_end_block code x =
  let _height = Piqirun.gen_optional_field 1 gen__uint64 x.Request_end_block.height in
  Piqirun.gen_record code (_height :: [])

and gen__response code x =
  let _error = Piqirun.gen_optional_field 1 gen__response_error x.Response.error in
  let _echo = Piqirun.gen_optional_field 2 gen__response_echo x.Response.echo in
  let _flush = Piqirun.gen_optional_field 3 gen__response_flush x.Response.flush in
  let _info = Piqirun.gen_optional_field 4 gen__response_info x.Response.info in
  let _set_option = Piqirun.gen_optional_field 5 gen__response_set_option x.Response.set_option in
  let _append_tx = Piqirun.gen_optional_field 6 gen__response_append_tx x.Response.append_tx in
  let _check_tx = Piqirun.gen_optional_field 7 gen__response_check_tx x.Response.check_tx in
  let _commit = Piqirun.gen_optional_field 8 gen__response_commit x.Response.commit in
  let _query = Piqirun.gen_optional_field 9 gen__response_query x.Response.query in
  let _init_chain = Piqirun.gen_optional_field 10 gen__response_init_chain x.Response.init_chain in
  let _begin_block = Piqirun.gen_optional_field 11 gen__response_begin_block x.Response.begin_block in
  let _end_block = Piqirun.gen_optional_field 12 gen__response_end_block x.Response.end_block in
  Piqirun.gen_record code (_error :: _echo :: _flush :: _info :: _set_option :: _append_tx :: _check_tx :: _commit :: _query :: _init_chain :: _begin_block :: _end_block :: [])

and gen__response_error code x =
  let _error = Piqirun.gen_optional_field 1 gen__string x.Response_error.error in
  Piqirun.gen_record code (_error :: [])

and gen__response_echo code x =
  let _message = Piqirun.gen_optional_field 1 gen__string x.Response_echo.message in
  Piqirun.gen_record code (_message :: [])

and gen__response_flush code x =
  Piqirun.gen_record code ([])

and gen__response_info code x =
  let _info = Piqirun.gen_optional_field 1 gen__string x.Response_info.info in
  Piqirun.gen_record code (_info :: [])

and gen__response_set_option code x =
  let _log = Piqirun.gen_optional_field 1 gen__string x.Response_set_option.log in
  Piqirun.gen_record code (_log :: [])

and gen__response_append_tx code x =
  let _code = Piqirun.gen_optional_field 1 gen__code_type x.Response_append_tx.code in
  let _data = Piqirun.gen_optional_field 2 gen__binary x.Response_append_tx.data in
  let _log = Piqirun.gen_optional_field 3 gen__string x.Response_append_tx.log in
  Piqirun.gen_record code (_code :: _data :: _log :: [])

and gen__response_check_tx code x =
  let _code = Piqirun.gen_optional_field 1 gen__code_type x.Response_check_tx.code in
  let _data = Piqirun.gen_optional_field 2 gen__binary x.Response_check_tx.data in
  let _log = Piqirun.gen_optional_field 3 gen__string x.Response_check_tx.log in
  Piqirun.gen_record code (_code :: _data :: _log :: [])

and gen__response_query code x =
  let _code = Piqirun.gen_optional_field 1 gen__code_type x.Response_query.code in
  let _data = Piqirun.gen_optional_field 2 gen__binary x.Response_query.data in
  let _log = Piqirun.gen_optional_field 3 gen__string x.Response_query.log in
  Piqirun.gen_record code (_code :: _data :: _log :: [])

and gen__response_commit code x =
  let _code = Piqirun.gen_optional_field 1 gen__code_type x.Response_commit.code in
  let _data = Piqirun.gen_optional_field 2 gen__binary x.Response_commit.data in
  let _log = Piqirun.gen_optional_field 3 gen__string x.Response_commit.log in
  Piqirun.gen_record code (_code :: _data :: _log :: [])

and gen__response_init_chain code x =
  Piqirun.gen_record code ([])

and gen__response_begin_block code x =
  Piqirun.gen_record code ([])

and gen__response_end_block code x =
  let _diffs = Piqirun.gen_repeated_field 4 gen__validator x.Response_end_block.diffs in
  Piqirun.gen_record code (_diffs :: [])

and gen__validator code x =
  let _pub_key = Piqirun.gen_optional_field 1 gen__binary x.Validator.pub_key in
  let _power = Piqirun.gen_optional_field 2 gen__uint64 x.Validator.power in
  Piqirun.gen_record code (_pub_key :: _power :: [])

and gen__message_type code x =
  Piqirun.int32_to_signed_varint code (match x with
    | `null_message -> 0l
    | `echo -> 1l
    | `flush -> 2l
    | `info -> 3l
    | `set_option -> 4l
    | `error -> 5l
    | `append_tx -> 17l
    | `check_tx -> 18l
    | `commit -> 19l
    | `query -> 20l
    | `init_chain -> 21l
    | `begin_block -> 22l
    | `end_block -> 23l
  )
and packed_gen__message_type x =
  Piqirun.int32_to_packed_signed_varint (match x with
    | `null_message -> 0l
    | `echo -> 1l
    | `flush -> 2l
    | `info -> 3l
    | `set_option -> 4l
    | `error -> 5l
    | `append_tx -> 17l
    | `check_tx -> 18l
    | `commit -> 19l
    | `query -> 20l
    | `init_chain -> 21l
    | `begin_block -> 22l
    | `end_block -> 23l
  )

and gen__code_type code x =
  Piqirun.int32_to_signed_varint code (match x with
    | `ok -> 0l
    | `internal_error -> 1l
    | `encoding_error -> 2l
    | `bad_nonce -> 3l
    | `unauthorized -> 4l
    | `insufficient_funds -> 5l
    | `unknown_request -> 6l
    | `base_duplicate_address -> 101l
    | `base_encoding_error -> 102l
    | `base_insufficient_fees -> 103l
    | `base_insufficient_funds -> 104l
    | `base_insufficient_gas_price -> 105l
    | `base_invalid_input -> 106l
    | `base_invalid_output -> 107l
    | `base_invalid_pub_key -> 108l
    | `base_invalid_sequence -> 109l
    | `base_invalid_signature -> 110l
    | `base_unknown_address -> 111l
    | `base_unknown_pub_key -> 112l
    | `base_unknown_plugin -> 113l
    | `gov_unknown_entity -> 201l
    | `gov_unknown_group -> 202l
    | `gov_unknown_proposal -> 203l
    | `gov_duplicate_group -> 204l
    | `gov_duplicate_member -> 205l
    | `gov_duplicate_proposal -> 206l
    | `gov_duplicate_vote -> 207l
    | `gov_invalid_member -> 208l
    | `gov_invalid_vote -> 209l
    | `gov_invalid_voting_power -> 210l
  )
and packed_gen__code_type x =
  Piqirun.int32_to_packed_signed_varint (match x with
    | `ok -> 0l
    | `internal_error -> 1l
    | `encoding_error -> 2l
    | `bad_nonce -> 3l
    | `unauthorized -> 4l
    | `insufficient_funds -> 5l
    | `unknown_request -> 6l
    | `base_duplicate_address -> 101l
    | `base_encoding_error -> 102l
    | `base_insufficient_fees -> 103l
    | `base_insufficient_funds -> 104l
    | `base_insufficient_gas_price -> 105l
    | `base_invalid_input -> 106l
    | `base_invalid_output -> 107l
    | `base_invalid_pub_key -> 108l
    | `base_invalid_sequence -> 109l
    | `base_invalid_signature -> 110l
    | `base_unknown_address -> 111l
    | `base_unknown_pub_key -> 112l
    | `base_unknown_plugin -> 113l
    | `gov_unknown_entity -> 201l
    | `gov_unknown_group -> 202l
    | `gov_unknown_proposal -> 203l
    | `gov_duplicate_group -> 204l
    | `gov_duplicate_member -> 205l
    | `gov_duplicate_proposal -> 206l
    | `gov_duplicate_vote -> 207l
    | `gov_invalid_member -> 208l
    | `gov_invalid_vote -> 209l
    | `gov_invalid_voting_power -> 210l
  )


let gen_string x = gen__string (-1) x
let gen_binary x = gen__binary (-1) x
let gen_uint64 x = gen__uint64 (-1) x
let gen_request x = gen__request (-1) x
let gen_request_echo x = gen__request_echo (-1) x
let gen_request_flush x = gen__request_flush (-1) x
let gen_request_info x = gen__request_info (-1) x
let gen_request_set_option x = gen__request_set_option (-1) x
let gen_request_append_tx x = gen__request_append_tx (-1) x
let gen_request_check_tx x = gen__request_check_tx (-1) x
let gen_request_query x = gen__request_query (-1) x
let gen_request_commit x = gen__request_commit (-1) x
let gen_request_init_chain x = gen__request_init_chain (-1) x
let gen_request_begin_block x = gen__request_begin_block (-1) x
let gen_request_end_block x = gen__request_end_block (-1) x
let gen_response x = gen__response (-1) x
let gen_response_error x = gen__response_error (-1) x
let gen_response_echo x = gen__response_echo (-1) x
let gen_response_flush x = gen__response_flush (-1) x
let gen_response_info x = gen__response_info (-1) x
let gen_response_set_option x = gen__response_set_option (-1) x
let gen_response_append_tx x = gen__response_append_tx (-1) x
let gen_response_check_tx x = gen__response_check_tx (-1) x
let gen_response_query x = gen__response_query (-1) x
let gen_response_commit x = gen__response_commit (-1) x
let gen_response_init_chain x = gen__response_init_chain (-1) x
let gen_response_begin_block x = gen__response_begin_block (-1) x
let gen_response_end_block x = gen__response_end_block (-1) x
let gen_validator x = gen__validator (-1) x
let gen_message_type x = gen__message_type (-1) x
let gen_code_type x = gen__code_type (-1) x


let rec default_string () = ""
and default_binary () = ""
and default_uint64 () = 0L
and default_request () =
  {
    Request.echo = None;
    Request.flush = None;
    Request.info = None;
    Request.set_option = None;
    Request.append_tx = None;
    Request.check_tx = None;
    Request.commit = None;
    Request.query = None;
    Request.init_chain = None;
    Request.begin_block = None;
    Request.end_block = None;
  }
and default_request_echo () =
  {
    Request_echo.message = None;
  }
and default_request_flush () =
  {
    Request_flush
    ._dummy = ();
  }
and default_request_info () =
  {
    Request_info
    ._dummy = ();
  }
and default_request_set_option () =
  {
    Request_set_option.key = None;
    Request_set_option.value = None;
  }
and default_request_append_tx () =
  {
    Request_append_tx.tx = None;
  }
and default_request_check_tx () =
  {
    Request_check_tx.tx = None;
  }
and default_request_query () =
  {
    Request_query.query = None;
  }
and default_request_commit () =
  {
    Request_commit
    ._dummy = ();
  }
and default_request_init_chain () =
  {
    Request_init_chain.validators = [];
  }
and default_request_begin_block () =
  {
    Request_begin_block.height = None;
  }
and default_request_end_block () =
  {
    Request_end_block.height = None;
  }
and default_response () =
  {
    Response.error = None;
    Response.echo = None;
    Response.flush = None;
    Response.info = None;
    Response.set_option = None;
    Response.append_tx = None;
    Response.check_tx = None;
    Response.commit = None;
    Response.query = None;
    Response.init_chain = None;
    Response.begin_block = None;
    Response.end_block = None;
  }
and default_response_error () =
  {
    Response_error.error = None;
  }
and default_response_echo () =
  {
    Response_echo.message = None;
  }
and default_response_flush () =
  {
    Response_flush
    ._dummy = ();
  }
and default_response_info () =
  {
    Response_info.info = None;
  }
and default_response_set_option () =
  {
    Response_set_option.log = None;
  }
and default_response_append_tx () =
  {
    Response_append_tx.code = None;
    Response_append_tx.data = None;
    Response_append_tx.log = None;
  }
and default_response_check_tx () =
  {
    Response_check_tx.code = None;
    Response_check_tx.data = None;
    Response_check_tx.log = None;
  }
and default_response_query () =
  {
    Response_query.code = None;
    Response_query.data = None;
    Response_query.log = None;
  }
and default_response_commit () =
  {
    Response_commit.code = None;
    Response_commit.data = None;
    Response_commit.log = None;
  }
and default_response_init_chain () =
  {
    Response_init_chain
    ._dummy = ();
  }
and default_response_begin_block () =
  {
    Response_begin_block
    ._dummy = ();
  }
and default_response_end_block () =
  {
    Response_end_block.diffs = [];
  }
and default_validator () =
  {
    Validator.pub_key = None;
    Validator.power = None;
  }
and default_message_type () = `null_message
and default_code_type () = `ok


include Types_piqi
