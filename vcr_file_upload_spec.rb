require 'vcr'
require 'json'
require 'httmultiparty'

describe "vcr file uploads" do

  before do
    VCR.configure do |c|
      c.cassette_library_dir = '.'
      c.hook_into :webmock
    end
  end

  subject do
    JSON.parse(HTTMultiParty.post("https://public.opencpu.org/ocpu/library/utils/R/read.csv/json",
                                  query: { file: File.new('test.csv') }).body)
  end

  it 'works with vcr' do
    VCR.use_cassette :multi_part_request do |cassette|
      expect(subject).to eq [{"head1"=>1, "head2"=>2}, {"head1"=>4, "head2"=>5}]
    end
  end

  it 'works without vcr' do
    VCR.turn_off!
    WebMock.disable!
    expect(subject).to eq [{"head1"=>1, "head2"=>2}, {"head1"=>4, "head2"=>5}]
    WebMock.enable!
    VCR.turn_on!
  end
end