# Copyright (C) 2013 Dmitry Yakimenko (detunized@gmail.com).
# Licensed under the terms of the MIT license. See LICENCE for details.

require "spec_helper"
require_relative "test_data"

describe LastPass::Parser do
    let(:key_iteration_count) { 5000 }
    let(:blob) { LastPass::Blob.new TEST_BLOB, key_iteration_count }
    let(:padding) { "BEEFFACE"}
    let(:encryption_key) { "OfOUvVnQzB4v49sNh4+PdwIFb9Fr5+jVfWRTf+E2Ghg=".decode64 }
    let(:encoded_rsa_key) { "98F3F5518AE7C03EBBF195A616361619033509FB1FFA0408E883B7C5E80381F8" +
                            "C8A343925DDA78FB06A14324BEC77EAF63290D381F54763A2793FE25C3247FC0" +
                            "29022687F453426DE96A9FB34CEB55C02764FB41E5E1619226FE47FA7EA40B41" +
                            "0973132F7AB2DE2D7F08C181C7D56BBF92CD4D44BC7DEE4253DEC36C77D28E30" +
                            "6F41B8BB26B0EDB97BADCEE912D3671C22339036FC064F5AF60D3545D47B8263" +
                            "6BBA1896ECDCF5EBE99A1061EFB8FBBD6C3500EA06A28BB8863F413702D9C05B" +
                            "9A54120F1BEFA0D98A48E82622A36DBD79772B5E4AD957045DC2B97311983592" +
                            "A357037DDA172C284B4FEC7DF8962A11B42079D6F943C8F9C0FEDFEA0C43A362" +
                            "B550E217715FD82D9F3BB168A006B0880B1F3660076158FE8CF6B706CF2FEAA1" +
                            "A731D1F68B1BC20E7ADE15097D2CD84606B4B0756DFE25DAF110D62841F44265" +
                            "73A676B904972B31AD7B02093C536341E1DA943F1AFF88DF2005BD04C6897FB6" +
                            "F9E307DA1C2BD219AB39F911FF90C6B1EA658C72C67C1EADC36CD5202654B4E1" +
                            "99A88F13DCE1148CC04F81485896627BB1DB5C73969520CC66652492383930E3" +
                            "3AFD57BE171F4BA25016EC9C3662F5B054101E381565433E46CB9FD517B59AE8" +
                            "A5CE7D11005282E551E9DCAA1996763E41B49677F906F122AAB76E852F35B31F" +
                            "397B70949D5F6C8DAA244AF16E9D48E0801E5C6D3FCEAFD2C3E157968B3E796C" +
                            "87E1F3FFF86B62FE5263D1A597E3906BF697C019F1F543D7BB1E11B08837B47F" +
                            "4528E4B47EB77508CFC0581B2A005383D0A238EA5BDE2E2602E0D2408B139735" +
                            "F4BAF8D6CF260BBC81833A85F14C5746AC6081B878486F5A4BD23B821F3F5F6B" +
                            "DAC8A9B57E25E24EDB8D701F01AE142D63A8A7D0F1CC8FAFF5F0320551CEB29B" +
                            "DB6907C57E38602927AD7240003FEB238AC5437FE4BAD11BB5038CA74D539523" +
                            "A167B8EBB1210608EB7DA53B4155D05B87D21848E58905EFA550EA5A51E0A68D" +
                            "5FF0F9E0CC0D5105DD98BE9E2C41362794A71A573CCA87B57147115B86FC8A6B" +
                            "B1778CED1920787271C75D69C5D63CD798915BF8F9877808F841F9269B2EA809" +
                            "0E11F6C89FDB537F341142CA29BAC761E1CF9D58FFB0C44A26E5EF7FA14142C8" +
                            "A84BC9304A221D5F961DB41B5925B06823A12A6F8950E47325021A747A02A28F" +
                            "DAE65997EBDF5D2BDBCA7C8D689AE186A9FE85A170B76EE92595C9E33639C993" +
                            "07C377FA4DA975E191810E993CDC0A33EE494B0EE8A1B6A9408285012967C17A" +
                            "8CB5EE8E7973CF9186A98000FE00F1CC76420089C6BDCE9E39D403C320DF1135" +
                            "1597FF8B231689389CCE12844289FEFE468BFCAEE9A2CFB1A8DD066AEC974DA9" +
                            "C8530C9A17593E25DC89934E056B178329C4BBF7113657677AB25EE66A1E1D92" +
                            "F62154B2451B37727F05B3AC0F2501F7A95845C9BE210D411028C27A9AD4B0E8" +
                            "31A6C46D26883A8AA2D1E2BD3E8E122A6FC21CECB7AE2B91C6FCFA793C5CAFF6" +
                            "53C6670D914A29EAD81CD5C29FFB048C81CC80EDD693B4D8091B2D5DE88EA042" +
                            "11AC551F406B713278BD14667E437C610953D6186C2986BA60361C2013395E8E" +
                            "A9D14CD00EC5C61147BE03D8965B5376DF32E2C3740128398E0D47900C888FD0" +
                            "D1F7D583808AFBC0712806E11462B37815C20692FB38E61CC0B1AAF66A854982" +
                            "6A1F5FFFF2436B0B9F9EDFF4F5B59B362AA1D25A4E3C398EB18445483F8419BD" +
                            "1511A5177E9C4B7034375A2D91B95153535E6CD5F023F4EED0E15B5415A3B7A7" +
                            "7E390AA698DF00F4FD897B0454C00959AF0CB54B272DE63968815B971C44B273" +
                            "6AC737FAE6A19F544907833F13C6F424D30E3B85054A4402EC94079C1473C20B" +
                            "E4C1B33525486BB098EF960082DB4DF5FE9CAF71681B03CB2D4BE7382FF0C03F" +
                            "18144DE554256591773DC3F381116955233FDA7223D71C402E558783F221E25A" +
                            "94FECD350654A9CD8EE8C39E4B1CFBA0D5FD46891527F2D0FC9EA61584A76D59" +
                            "99719811B2BAFC99769E6911733ED389A731C327CB5D7BB6D79CE030D3285586" +
                            "C6681FC8C110EFE30CEE883FFEF5FB511B4421863E2A15F8CDCFA7B84B931121" +
                            "5B23093DE3B5E7F4CFCCE60BE7857B7442B8FCC3E43C46C4BFA3E9ABD2F479F6" +
                            "BD8D3F3D36C0FAC1F4D72FBE96C644AB56F73CAF956D5544B2EB9C589ED30FF3" +
                            "0BB03D09DB455764EF4A33C24F93170A98A21455826390B13A8F338A820EC08D" +
                            "6E9F562282C2F815BB57CE511AB6B0DE75EFA63F28C6D0B25298CDAAC76742D5" +
                            "353B26B77C1533B4DFE2D95F3E89315C0D806A90FCDFDC31CE04A9E29937680D" +
                            "32D8B503352388109C1F5F41E8496302E13A61917F70A9AA3C5ECDBD88163E3C" +
                            "F0580C5EB1382BB66194AC0983BAA16B4D220756F4B7E3DDFFC5BF343FA7E31D" +
                            "14FED4409AD0FE9BBE01AF79DA4852253CBF166FDCA90E894B5267A502F73347" +
                            "06F8C767EC861324CC7734352D76DB007E25105E7994CF91D79532221316F4DE" +
                            "56BAE4351D3E3C6549FBFEF13BBE2636071794AD9EC3787B4A71E5438B86C358" +
                            "65ECF2EA5980318F82D8B113C0EC8FEE41C243E0A1A09F373A0CF546FA18E1EC" +
                            "7DB4842A6B8B03D115654222B87DA6034EFDE2224DBD23AB104BF3723856C03D" +
                            "B639BA073F2CC8E4AB05BAADDB5DEACC1874F4D6F86B95710019114DACBFE48F" +
                            "EF2AE2DF27356B5C17948B26A41FD1A8F07E8068E176F995910C373886DB47D2" +
                            "6C2FE5CD97AAF1829EBC1EEBA4D88343A322E810385138F51F0E5149183699C4" +
                            "05E49ED13C2889A22742893A52567B0F7D4A3BC9F4DC6D29F713AA7FB4EF6B13" +
                            "5F92F598404A80E7D6515CE234AFA68A4B562AF203162C60D578F0D00E302958" +
                            "174E1A712FD449D257C6AA5F56E4DBD0363573931463BC910858AF1EC40C1F4A" +
                            "7BE27DE8E170D4AACF6C34B0CDE15190FD81FA5676136A4D73E2AA4BBFBB8E7C" +
                            "1178EF47362188D9288E822B10BBF2C8BE075A5BD1D3E1F08108BA8C4E6FB173" +
                            "DCECB5771E9D8AE4CD776EA3409DF30FA2252D3C3769AF12177F4A1929DC8E74" +
                            "D5AEAC94CF94EEBA0E9AC012C57B40A8BB57530C25846B841005767B9AABE436" +
                            "D4590977FDDA519B9B284CF8B8922A0E8B659ECE3745A95800EE1B3DDD33E0FF" +
                            "230C0528BC7A4CB80604411E59E08775A42C634E93BA9C77D015659AC912F436" +
                            "94F774E94050E4B3BF84290368D5AFD7F043BDCA3BD0CC8C0E267069B6F1386A" +
                            "E1D9C8B5512AAAA292FDA9CA07E27BAF983E1E25A11732797425F2BB396B302E" +
                            "0782BA183D4BC1F682365774520EAC8A321C7A0BD08027021EA0063D471E0AD1" +
                            "E1469AD803C311D3FBF50B5538265D4262B6716D90E89A8C906D08533D650000" +
                            "6BF1B8ABAAFE1CA3AFDD1A19ACABE5B86A804D36AE27163CAF390FD266D5FFEF" +
                            "FC7CE6FEF9458E4AF0C4108E32EFD11C19751B1D9883E803F7C2E1A5786F3385" +
                            "1A7CA3772ECD7CB0E9782A7D30E0A9FD09EED361B774A277C618C995FD7F7634" +
                            "E7DB3834690B58DDFF6B721157D0EC02" }
    let(:rsa_key_encryption_key) { "v4uHomAR0tAXC3fA5Nfq7DjyJxuvYErMSCcZIWZKjpM=".decode64 }

    describe ".extract_chunks" do
        context "returned chunks" do
            let(:chunks) { LastPass::Parser.extract_chunks blob }

            it { expect(chunks).to be_instance_of Array }

            it "all values are instances of Chunk" do
                expect(chunks.map(&:class).uniq).to eq [LastPass::Chunk]
            end
        end
    end

    describe ".parse_ACCT" do
        let(:accounts) {
            LastPass::Parser
                .extract_chunks(blob)
                .select { |i| i.id == "ACCT" }
                .map { |i| LastPass::Parser.parse_ACCT i, TEST_ENCRYPTION_KEY }
        }

        it "parses accounts" do
            expect(accounts.map &:id).to eq TEST_ACCOUNTS.map &:id
        end
    end

    describe ".parse_PRIK" do
        let(:chunk) { LastPass::Chunk.new "PRIK", encoded_rsa_key }
        let(:rsa_key) { LastPass::Parser.parse_PRIK chunk, rsa_key_encryption_key }

        it "parses private key" do
            expect(rsa_key).to be_instance_of OpenSSL::PKey::RSA
            expect(rsa_key.n.to_s).to eq "26119467519435514320618523953258926539081857789201" +
                                         "11592360794055150234493177840791445076164320959092" +
                                         "33977645519805962686071307052774013402170389235283" +
                                         "48398581900094955608774421569689169697285847986479" +
                                         "82303230642077254435741682688235176460351551099267" +
                                         "22581481667367599195203736002065084704013295528661" +
                                         "76687143747593851140122182044652173598693510643390" +
                                         "47711449981712845835960707676646864765530616733341" +
                                         "58401920829305659156984748726238485655720031774127" +
                                         "01900577710668575227691993026576480667273922300137" +
                                         "80405264300989392980537603337301835174777026188388" +
                                         "93147718435999645840214854231168704372464234421315" +
                                         "01138217872658041"
            expect(rsa_key.e.to_s).to eq "65537"
            expect(rsa_key.d.to_s).to eq "20217010678828834626882766446083366137418639853408" +
                                         "07494174069610076841252047428625473158347002598408" +
                                         "18346644251082549844764624454370315666751565294997" +
                                         "10533208173186395672159239558808345075823110774221" +
                                         "61501075434955107584446470508660844962452555542861" +
                                         "72030926355197158923586674949673551608716945271868" +
                                         "18816984671497443384191412119383687600754285611808" +
                                         "23265620694961977962255376280640334543711420731809" +
                                         "16169692928898605559361322123131373948352054888316" +
                                         "99068010065680008419210277574874665723796199239285" +
                                         "78432149273871356528827780412288057677598714485872" +
                                         "23380715275000339748138416696881866569449168516354" +
                                         "08203050733598637"
            expect(rsa_key.p.to_s).to eq "17745924258106322606344019888040076543466707208121" +
                                         "93651272762195900747632457567234817364256394944312" +
                                         "33791510564351470780224344194760390006214095043405" +
                                         "42496712265086317539172843039592265661675784866722" +
                                         "91261262550895476526939878375016658686669778355984" +
                                         "43725100552628219407700007375820870959681331890216" +
                                         "873285999"
            expect(rsa_key.q.to_s).to eq "14718572636476888213359534581670909910031809536407" +
                                         "40164297606657861988206326322941728093846078102409" +
                                         "77115817405984843964689092056948880068086594283588" +
                                         "67786990898525462713620707076259988063113810297786" +
                                         "62342502396556461808879680749106840152602791951788" +
                                         "07295572399572445909627940220804206538364578785262" +
                                         "498615959"
            expect(rsa_key.dmp1.to_s).to eq "11323089471614997519408698592522878386531994069" +
                                            "33541387540978328974191124807026398192741826901" +
                                            "86286081197790519393403018396347119829946883285" +
                                            "08800265628051101161010033119239372833462468119" +
                                            "90625594353955836736745514688525978377008530625" +
                                            "69694172942783772849726563761756732407513441791" +
                                            "680438851248236159711158591"
            expect(rsa_key.dmq1.to_s).to eq "12614892732210916138126631634839174964470249502" +
                                            "72370951196981338360130575847987543477227082933" +
                                            "41184913630399067613236576233063778305668453307" +
                                            "65828324726545238243590265660986543730618177968" +
                                            "24851190055502445616363498122584261892788460430" +
                                            "15963041982287770355559480659540210015737708509" +
                                            "273864533597668007301940253"
            expect(rsa_key.iqmp.to_s).to eq "12662716333617943892704787530332782239196594580" +
                                            "72960727418453194230165281227127897455330083723" +
                                            "88895713617946267318745745224382578970891647971" +
                                            "94015463887039228876036602797561671319853126600" +
                                            "52663805817336717151173320411542486382434841161" +
                                            "62999647203566877832873138065626190040996517274" +
                                            "418161068665712298519808863"
        end
    end

    describe ".parse_secure_note_server" do
        let(:url) { "url" }
        let(:username) { "username" }
        let(:password) { "password" }
        let(:notes) { "Hostname:#{url}\nUsername:#{username}\nPassword:#{password}" }

        it "returns parsed values" do
            result = LastPass::Parser.parse_secure_note_server notes
            expect(result[0]).to eq url
            expect(result[1]).to eq username
            expect(result[2]).to eq password
        end
    end

    describe ".read_chunk" do
        it "returns a chunk" do
            with_chunk_hex "ABCD", "DEADBEEF", padding do |io|
                expect(LastPass::Parser.read_chunk io).to eq LastPass::Chunk.new("ABCD", "DEADBEEF".decode_hex)
                expect(io.pos).to eq 12
            end
        end
    end

    describe ".read_item" do
        it "returns an item" do
            with_item_hex "DEADBEEF", padding do |io|
                expect(LastPass::Parser.read_item io).to eq "DEADBEEF".decode_hex
                expect(io.pos).to eq 8
            end
        end
    end

    describe ".skip_item" do
        it "skips an empty item" do
            with_item_hex "", padding do |io|
                LastPass::Parser.skip_item io
                expect(io.pos).to eq 4
            end
        end

        it "skips a non-empty item" do
            with_item_hex "DEADBEEF", padding do |io|
                LastPass::Parser.skip_item io
                expect(io.pos).to eq 8
            end
        end
    end

    describe ".read_id" do
        it "returns an id" do
            with_bytes "ABCD" + padding do |io|
                expect(LastPass::Parser.read_id io).to eq "ABCD"
                expect(io.pos).to eq 4
            end
        end
    end

    describe ".read_size" do
        it "returns a size" do
            with_hex "DEADBEEF" + padding do |io|
                expect(LastPass::Parser.read_size io).to eq 0xDEADBEEF
                expect(io.pos).to eq 4
            end
        end
    end

    describe ".read_payload" do
        it "returns a payload" do
            with_hex "FEEDDEADBEEF" + padding do |io|
                expect(LastPass::Parser.read_payload io, 6).to eq "FEEDDEADBEEF".decode_hex
                expect(io.pos).to eq 6
            end
        end
    end

    describe ".read_uint32" do
        it "returns a number" do
            with_hex "DEADBEEF" + padding do |io|
                expect(LastPass::Parser.read_size io).to eq 0xDEADBEEF
                expect(io.pos).to eq 4
            end
        end
    end

    describe ".decode_hex" do
        it "decodes hex" do
            def hex s
                s.force_encoding "ASCII-8BIT"
            end

            expect(LastPass::Parser.decode_hex "")
                .to eq ""

            expect(LastPass::Parser.decode_hex "00ff")
                .to eq hex "\x00\xFF"

            expect(LastPass::Parser.decode_hex "00010203040506070809")
                .to eq hex "\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09"

            expect(LastPass::Parser.decode_hex "000102030405060708090a0b0c0d0e0f")
                .to eq hex "\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F"

            expect(LastPass::Parser.decode_hex "8af633933e96a3c3550c2734bd814195")
                .to eq hex "\x8A\xF6\x33\x93\x3E\x96\xA3\xC3\x55\x0C\x27\x34\xBD\x81\x41\x95"
        end

        it "raises exception on odd length" do
            expect { LastPass::Parser.decode_hex "0" }
                .to raise_error ArgumentError, "Input length must be multple of 2"
        end

        it "raises exception on invalid characters" do
            expect { LastPass::Parser.decode_hex "xz" }
                .to raise_error ArgumentError, "Input contains invalid characters"
        end
    end

    describe ".decode_base64" do
        it "decodes base64" do
            def check base64, plain
                expect(LastPass::Parser.decode_base64 base64).to eq plain
            end

            check "", ""
            check "YQ==", "a"
            check "YWI=", "ab"
            check "YWJj", "abc"
            check "YWJjZA==", "abcd"
        end
    end

    describe ".decode_aes256_auto" do
        def check encoded, decoded
            expect(LastPass::Parser.decode_aes256_auto encoded, encryption_key)
                .to eq decoded
        end

        it "decodes a blank string" do
            check "", ""
        end

        it "decodes ECB/plain string" do
            check "BNhd3Q3ZVODxk9c0C788NUPTIfYnZuxXfkghtMJ8jVM=".decode64,
                   "All your base are belong to us"
        end

        it "decodes ECB/base64 string" do
            check "BNhd3Q3ZVODxk9c0C788NUPTIfYnZuxXfkghtMJ8jVM=",
                   "All your base are belong to us"
        end

        it "decodes CBC/plain string" do
            check "IcokDWmjOkKtLpZehWKL6666Uj6fNXPpX6lLWlou+1Lrwb+D3ymP6BAwd6C0TB3hSA==".decode64,
                   "All your base are belong to us"
        end

        it "decodes CBC/base64 string" do
            check "!YFuiAVZgOD2K+s6y8yaMOw==|TZ1+if9ofqRKTatyUaOnfudletslMJ/RZyUwJuR/+aI=",
                   "All your base are belong to us"
        end
    end

    describe ".decode_aes256_ecb_plain" do
        def check encoded, decoded
            expect(LastPass::Parser.decode_aes256_ecb_plain encoded.decode64, encryption_key)
                .to eq decoded
        end

        it "decodes a blank string" do
            check "", ""
        end

        it "decodes a short string" do
            check "8mHxIA8rul6eq72a/Gq2iw==", "0123456789"
        end

        it "decodes a long string" do
            check "BNhd3Q3ZVODxk9c0C788NUPTIfYnZuxXfkghtMJ8jVM=", "All your base are belong to us"
        end
    end

    describe ".decode_aes256_ecb_base64" do
        def check encoded, decoded
            expect(LastPass::Parser.decode_aes256_ecb_base64 encoded, encryption_key)
                .to eq decoded
        end

        it "decodes a blank string" do
            check "", ""
        end

        it "decodes a short string" do
            check "8mHxIA8rul6eq72a/Gq2iw==", "0123456789"
        end

        it "decodes a long string" do
            check "BNhd3Q3ZVODxk9c0C788NUPTIfYnZuxXfkghtMJ8jVM=", "All your base are belong to us"
        end
    end

    describe ".decode_aes256_cbc_plain" do
        def check encoded, decoded
            expect(LastPass::Parser.decode_aes256_cbc_plain encoded.decode64, encryption_key)
                .to eq decoded
        end

        it "decodes a blank string" do
            check "", ""
        end

        it "decodes a short string" do
            check "IQ+hiIy0vGG4srsHmXChe3ehWc/rYPnfiyqOG8h78DdX", "0123456789"
        end

        it "decodes a long string" do
            check "IcokDWmjOkKtLpZehWKL6666Uj6fNXPpX6lLWlou+1Lrwb+D3ymP6BAwd6C0TB3hSA==",
                  "All your base are belong to us"
        end
    end

    describe ".decode_aes256_cbc_base64" do
        def check encoded, decoded
            expect(LastPass::Parser.decode_aes256_cbc_base64 encoded, encryption_key)
                .to eq decoded
        end

        it "decodes a blank string" do
            check "", ""
        end

        it "decodes a short string" do
            check "!6TZb9bbrqpocMaNgFjrhjw==|f7RcJ7UowesqGk+um+P5ug==", "0123456789"
        end

        it "decodes a long string" do
            check "!YFuiAVZgOD2K+s6y8yaMOw==|TZ1+if9ofqRKTatyUaOnfudletslMJ/RZyUwJuR/+aI=",
                  "All your base are belong to us"
        end
    end

    #
    # Helpers
    #

    private

    def with_blob &block
        with_bytes TEST_BLOB, &block
    end

    def with_hex hex, &block
        with_bytes hex.decode_hex, &block
    end

    def with_bytes bytes, &block
        StringIO.open bytes do |io|
            yield io
        end
    end

    #
    # Chunks
    #

    def with_chunk id, payload, padding = "", &block
        with_bytes make_chunk(id, payload, padding), &block
    end

    def with_chunk_hex id, payload, padding = "", &block
        with_bytes make_chunk_hex(id, payload, padding), &block
    end

    def make_chunk id, payload, padding = ""
        [id, payload.size, payload, padding].pack "a4Na*a*"
    end

    def make_chunk_hex id, payload, padding = ""
        make_chunk id, payload.decode_hex, padding
    end

    #
    # Items
    #

    def with_item payload, padding = "", &block
        with_bytes make_item(payload, padding), &block
    end

    def with_item_hex payload, padding = "", &block
        with_bytes make_item_hex(payload, padding), &block
    end

    def make_item payload, padding = ""
        [payload.size, payload, padding].pack "Na*a*"
    end

    def make_item_hex payload, padding = ""
        make_item payload.decode_hex, padding
    end
end
