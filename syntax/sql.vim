syn match sqlSpecial /@\S\+/

" Aggregate
syn keyword sqlFunction approx_count_distinct avg checksum_agg count count_big grouping grouping_id max min stdev stdevp string_agg sum var varp
" Analytic
syn keyword sqlFunction cume_dist first_value lag last_value lead percent_rank percentile_cont percentile_disc
" Collation
syn keyword sqlFunction collationproperty tertiary_weights
" Configuration
syn keyword sqlFunction @@datefirst @@dbts @@langid @@language @@lock_timeout @@max_connections @@max_precision @@nestlevel @@options @@remserver @@servername @@servicename @@spid @@textsize @@version
" Conversion
syn keyword sqlFunction cast convert parse try_cast try_convert try_parse
" Cryptographic
syn keyword sqlFunction encryptbykey decryptbykey encryptbypassphrase decryptbypassphrase key_id key_guid decryptbykeyautoasymkey key_name symkeyproperty
syn keyword sqlFunction encryptbyasymkey decryptbyasymkey encryptbycert decryptbycert asymkeyproperty asymkey_id
syn keyword sqlFunction signbyasymkey verifysignedbyasmkey signbycert verigysignedbycert is_objectsigned
syn keyword sqlFunction decryptbykeyautocert
syn keyword sqlFunction hashbytes
syn keyword sqlFunction certencoded certprivatekey
" Cursor
syn keyword sqlFunction @@cursor_rows @@fetch_status cursor_status
" Data Type
syn keyword sqlFunction datalength ident_seed ident_current identity ident_incr sql_variant_property
" Date & Time
syn keyword sqlFunction sysdatetime sysdatetimeoffset sysutcdatetime datename datepart day month year datefromparts datetime2fromparts datetimefromparts datetimeoffsetfromparts smalldatetimefromparts timefromparts
syn keyword sqlFunction datediff datediff_big dateadd eomonth switchoffset todatetimeoffset @@datefirst datefirst dateformat @@language language isdate format
" JSON
syn keyword sqlFunction isjson json_value json_query json_modify
" Mathematical
syn keyword sqlFunction abs acos asin atan atn2 ceiling cos cot degrees exp floor log log10 pi power radians rand round sign sin sqrt square tan
" Logical
syn keyword sqlFunction choose greatest iif least
" Metadata
syn keyword sqlFunction @@procid app_name applock_mode applock_test assemblyproperty col_length col_name columnproperty database_principal_id databasepropertyex db_id db_name
syn keyword sqlFunction file_id file_idex file_name filegroup_id filegroup_name filegroupproperty fileproperty fulltextcatalogproperty fulltextserviceproperty
syn keyword sqlFunction index_col indexkey_property indexproperty next value for object_definition object_id object_name object_schema_name objectproperty objectpropertyex original_db_name
syn keyword sqlFunction parsename schema_id schema_name scope_identity serverproperty stats_date type_id type_name typeproperty version
" Ranking
syn keyword sqlFunction dense_rank ntile rank row_number
" Replication
syn keyword sqlFunction publishingservername
" Security
syn keyword sqlFunction certencoded pwdcompare certprivatekey pwdencrypt current_user schema_id database_principal_id schema_name  session_user  suser_id  suser_sid
syn keyword sqlFunction has_perms_by_name suser_sname is_member system_user is_rolemember suser_name is_srvrolemember user_id loginproperty user_name original_login permissions
" String
syn keyword sqlFunction ascii char charindex concat concat_ws difference format left len lower ltrim nchar patindex quotename replace replicate reverse right rtrim
syn keyword sqlFunction soundex space str string_agg string_escape string_split stuff substring translate trim unicode upper
" System
syn keyword sqlFunction $partition error_procedure @@error error_severity @@identity error_state @@pack_received formatmessage @@rowcount get_filestream_transaction_context @@trancount getansinull binary_checksum
syn keyword sqlFunction host_id checksum host_name compress isnull connectionproperty isnumeric context_info min_active_rowversion current_request_id newid current_transaction_id newsequentialid decompress rowcount_big error_line
syn keyword sqlFunction session_context error_message session_id error_number xact_state
" System Statistical
syn keyword sqlFunction @@connections @@pack_received @@cpu_busy @@pack_sent @@timeticks @@idle @@total_errors @@io_busy @@total_read @@packet_errors @@total_write
" Text & Image
syn keyword sqlFunction textptr textvalid
" Trigger
syn keyword sqlFunction columns_updated eventdata trigger_nestlevel update()

" Windowing clauses
syn keyword sqlFunction over rows range unbounded preceding following current row partition by

highlight sqlFunction guifg=#ff7f00
