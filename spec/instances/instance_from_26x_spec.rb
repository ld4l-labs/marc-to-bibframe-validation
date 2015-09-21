require 'spec_helper'
require 'linkeddata'

describe 'instance from 26x or 300' do

=begin
# NON-ISBN, non-856
         else          (: $isbn-sets//bf:set is false use the first edition, etc:)
            for $i in $marcxml/marcxml:datafield[fn:matches(@tag, "(260|261|262|264|300)")][1]
             return mbshared:generate-instance-from260($i, $workID)
   ,
        if ($typeOf008!="SE") then
            for $i at $x in $marcxml/marcxml:datafield[@tag="260"][fn:position() != 1]
                return  mbshared:generate-additional-instance($i, $workID , $x)
        else (),
=end

  #  first of 260|261|262|264|300

  context "no 26x" do
    context 'only 245' do
      let(:g) {
        marcxml_str =
        '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01052cam a2200313 i 4500</leader>
            <controlfield tag="001">no_26x</controlfield>
            <controlfield tag="008">140604t20152015enk      b    001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">Slippery noodles</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'no_26x')
      }
      it '0 Instances' do
        expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 0
      end
      it '0 instanceOf' do
        expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 0
      end
    end # only 245
  end # no 26x

  context "260" do
    # first of 260|261|262|264|300
    # 260 (except the first one) when leader6 == 'a' && leader7 == 'b', 'i' or 's'
    context 'single 260' do
      let(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>02308cas a2200541 a 4500</leader>
            <controlfield tag="001">260</controlfield>
            <controlfield tag="008">790906u1921uuuubl ar p   o   0    0por c</controlfield>
            <datafield tag="245" ind1="1" ind2="2">
              <subfield code="a">A ordem.</subfield>
            </datafield>
            <datafield tag="260" ind1=" " ind2=" ">
              <subfield code="a">Rio de Janeiro :</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '260')
      }
      it '1 Instance' do
        expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 1
      end
      it '1 instanceOf' do
        expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 1
      end
    end # single 260
    context "mult 260" do
      context "serial_mult260" do
        let(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>02015cas a2200529 a 4500</leader>
            <controlfield tag="001">mult260</controlfield>
            <controlfield tag="008">921028c19899999fr br         0   b0fre c</controlfield>
          <datafield tag="245" ind1="1" ind2="0">
            <subfield code="a">Textuel.</subfield>
          </datafield>
          <datafield tag="260" ind1=" " ind2=" ">
            <subfield code="a">Paris :</subfield>
            <subfield code="b">L\'U.F.R. "Science des textes et documents",</subfield>
            <subfield code="c">1990-</subfield>
          </datafield>
          <datafield tag="260" ind1="2" ind2=" ">
            <subfield code="3">&lt;2011&gt;-2013</subfield>
            <subfield code="a">Paris :</subfield>
            <subfield code="b">UFR Lettres, Arts, Cine&#x301;ma</subfield>
          </datafield>
          <datafield tag="260" ind1="3" ind2=" ">
            <subfield code="3">2014-</subfield>
            <subfield code="a">Paris :</subfield>
            <subfield code="b">Hermann</subfield>
          </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'serial_mult260')
        }
        it '3 Instances' do
          expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 3
        end
        it '3 instanceOf' do
          expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 3
        end
      end
      context "non-serial mult260" do
        # TODO:  real example needed?
        let(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>02295cam a22004217a 4500</leader>
            <controlfield tag="001">non-serial_mult260</controlfield>
            <controlfield tag="008">081125s2008    kv ||||  y56||||| ||srp  </controlfield>
            <datafield tag="245" ind1="1" ind2="0">
              <subfield code="a">Validator test record for Nov. 2008 rollout /</subfield>
              <subfield code="c">David Reser.</subfield>
            </datafield>
            <datafield tag="260" ind1=" " ind2=" ">
              <subfield code="a">Original place :</subfield>
              <subfield code="b">Original Pub,</subfield>
              <subfield code="c">2008.</subfield>
            </datafield>
            <datafield tag="260" ind1="2" ind2=" ">
              <subfield code="a">Intervening place :</subfield>
              <subfield code="b">Intervening Pub.</subfield>
            </datafield>
            <datafield tag="260" ind1="3" ind2=" ">
              <subfield code="a">Current place :</subfield>
              <subfield code="b">Current Pub.</subfield>
            </datafield>
        </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'non_serial_mult260')
        }
        it '3 Instances' do
          expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 3
        end
        it '3 instanceOf' do
          expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 3
        end
      end
    end # mult 260
  end # 260

  context "261" do
    it 'need example data for 261' do
      fail 'need example data for 261'
    end
  end

  context "262" do
    it 'need example data for 262' do
      fail 'need example data for 262'
    end
  end

  context "264" do
    context "single 264" do
      context '264 ind2=1 book' do
        let(:g) {
          marcxml_str =
            '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>02308cas a2200541 a 4500</leader>
              <controlfield tag="001">264ind2_1_book</controlfield>
              <controlfield tag="008">790906u1921uuuubl ar p   o   0    0por c</controlfield>
              <datafield tag="245" ind1="1" ind2="2">
                <subfield code="a">A ordem.</subfield>
              </datafield>
              <datafield ind1=" " ind2="1" tag="264">
                <subfield code="a">London :</subfield>
                <subfield code="b">Prospect Books,</subfield>
                <subfield code="c">2015.</subfield>
              </datafield>
            </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '264ind2_1_book')
        }
        it '1 Instance' do
          expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 1
        end
        it '1 instanceOf' do
          expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 1
        end
      end
      context '264 ind2=1 online recording' do
        let(:g) {
          marcxml_str =
            '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>03714njm a2200649Ki 4500</leader>
              <controlfield tag="001">264ind2_1_online_recording</controlfield>
              <controlfield tag="008">150406s2010    ne synn o         n ger d</controlfield>
              <datafield ind1="1" ind2="0" tag="245">
                <subfield code="a">Symphony no. 3 /</subfield>
                <subfield code="c">Mahler.</subfield>
              </datafield>
              <datafield ind1=" " ind2="1" tag="264">
                <subfield code="a">[Netherlands] :</subfield>
                <subfield code="b">RCO Live,</subfield>
                <subfield code="c">[2010]</subfield>
              </datafield>
            </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '264ind2_1_online_recording')
        }
        it '1 Instance' do
          expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 1
        end
        it '1 instanceOf' do
          expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 1
        end
      end # 264 ind2=1 online recording
    end # single 264

    context "mult 264" do
      context "ind2 1 and 4 (book)" do
        let(:g) {
          marcxml_str =
            '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>02308cas a2200541 a 4500</leader>
              <controlfield tag="001">264ind2_1_4_book</controlfield>
              <controlfield tag="008">790906u1921uuuubl ar p   o   0    0por c</controlfield>
              <datafield tag="245" ind1="1" ind2="2">
                <subfield code="a">A ordem.</subfield>
              </datafield>
              <datafield ind1=" " ind2="1" tag="264">
                <subfield code="a">London :</subfield>
                <subfield code="b">Prospect Books,</subfield>
                <subfield code="c">2015.</subfield>
              </datafield>
              <datafield ind1=" " ind2="4" tag="264">
                <subfield code="c">©2015</subfield>
              </datafield>
            </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '264ind2_1_4_book')
        }
        it '1 Instance' do
          expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 1
        end
        it '1 instanceOf' do
          expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 1
        end
      end
      context "ind2 1 and 4 (map)" do
        let(:g) {
          marcxml_str =
            '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>01553cem a2200433 i 4500</leader>
              <controlfield tag="001">264ind2_1_4_map</controlfield>
              <controlfield tag="008">150115t20152015fr        e     1   fre  </controlfield>
              <datafield ind1="1" ind2="0" tag="245">
                <subfield code="a">Atlas mondial des femmes :</subfield>
                <subfield code="b">les paradoxes de l\'émancipation /</subfield>
                <subfield code="c">sous la direction de Isabelle Attané, Carole Brugeilles, Wilfried Rault ; cartographie, Cécile Marin.</subfield>
              </datafield>
              <datafield ind1=" " ind2="1" tag="264">
                <subfield code="a">Paris :</subfield>
                <subfield code="b">Éditions Autrement,</subfield>
                <subfield code="c">[2015]</subfield>
              </datafield>
              <datafield ind1=" " ind2="4" tag="264">
                <subfield code="c">©2015</subfield>
              </datafield>
            </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '264ind2_1_4_map')
        }
        it '1 Instance' do
          expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 1
        end
        it '1 instanceOf' do
          expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 1
        end
      end
    end # mult 264
  end # 264

end