# -*- coding: utf-8 -*-

require "spec_helper"

describe "MySlog" do
  before :each do
    @myslog = MySlog.new
  end

  describe "#parse" do
  end

  describe "#parse_record" do
    before :all do
      @record = <<-EOF
# Time: 111003 14:17:38
# User@Host: root[root] @ localhost []
# Query_time: 0.000270  Lock_time: 0.000097 Rows_sent: 1  Rows_examined: 0
SET timestamp=1317619058;
SELECT * FROM life;
      EOF
    end

    before :each do
      @lines = @record.split("\n").map {|line| line.chomp}
    end

    it "should return an instance of Hash" do
      @myslog.send(:parse_record, @lines).should be_an_instance_of Hash
    end
  end
end
